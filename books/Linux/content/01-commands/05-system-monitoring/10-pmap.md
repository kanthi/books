---
title: "pmap"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# pmap

## Overview

**Thesis:** when a process's RSS keeps climbing but every heap profiler says "no leak", believe the kernel, not the allocator. `pmap` (procps-ng) prints a process's memory map from `/proc/PID/smaps`. It is the quickest way to see *which mapping* is growing: heap, stack, a library, or an anonymous region that `malloc` never knew about. This page uses it as the first step of a three-tool hunt for a native leak:

1. **`pmap`** shows *where* the memory is (an anonymous region that grows and moves).
2. **A syscall tracer** shows *who* creates it. Use `bpftrace` where the kernel allows it, and `strace -k` where it does not.
3. **`gdb`, scripted** stops only on the guilty call and prints the full stack and the returned address, which you can match against step 1.

Typical operator jobs:

- Tell a heap leak (`[heap]` / `malloc` arenas grow) from a mapping leak (`[ anon ]` regions grow).
- Find out what a 2 GB RSS is actually made of: libraries, thread stacks, arenas, or shared memory.
- Confirm a fix by watching the guilty region stop growing.

```bash
# Debian/Ubuntu/Fedora: part of procps(-ng), installed by default
pmap --version
```

```text
pmap from procps-ng 4.0.4
```

## Mental model

```text
 virtual address space of one process            what each tool can see
 ────────────────────────────────────            ──────────────────────
 [stack]                                          pmap / smaps:  every mapping, its size and RSS
 ...                                              heap profilers: only malloc/free (and new/delete)
 [ anon ]  ◀── mmap(MAP_ANONYMOUS) by an           LD_PRELOAD mmap hook: only calls through the
 [ anon ]      allocator, a pool, a JIT, a NIC        mmap() *symbol*, not syscall(SYS_mmap, ...)
 libfoo.so    driver library...                   strace / bpftrace: every syscall, however issued
 [heap]    ◀── brk(): small malloc() blocks        gdb: anything you can put a breakpoint on
 binary
```

| Fact | Consequence |
|------|-------------|
| `malloc` serves small blocks from `[heap]`/arenas and large ones from fresh anonymous mappings | Heap profilers account for both, but only for memory obtained **through `malloc`** |
| Libraries may call `mmap` directly, or bypass even that with the raw `syscall(SYS_mmap, …)` | That memory is invisible to heap profilers *and* to `LD_PRELOAD` hooks on `mmap` |
| The kernel **merges adjacent anonymous mappings** with the same permissions | Many leaked 256 KiB blocks show up as **one** `[ anon ]` region that grows downwards: same end address, smaller start address |
| `Kbytes` is reserved address space, `RSS` is what is in RAM | A pool that maps 256 KiB but touches 64 KiB grows `Kbytes` 4× faster than `RSS`. Watch both |
| `pmap` reads `/proc/PID/smaps` and does not stop the process | It is safe to run against production every second |

## Syntax

```bash
pmap [options] PID [PID ...]
```

| Option | Meaning |
|--------|---------|
| (none) | Address, size, permissions, mapping name |
| `-x`, `--extended` | Add `RSS` and `Dirty` columns (KiB) and a `total kB` line |
| `-X` | Every common `smaps` field (`Pss`, `Anonymous`, `Swap`, `THPeligible`, …). The format follows the kernel's `smaps`, so do not parse columns by position across kernels |
| `-XX` | Everything the kernel provides |
| `-q`, `--quiet` | No header or footer, which is handy for `sort` |
| `-p`, `--show-path` | Full path of file mappings |
| `-A low[,high]` | Only mappings in an address range |
| `-d`, `--device` | Device format (offset and device per mapping) |

For one number instead of a table, `/proc/PID/smaps_rollup` gives totals (`Rss`, `Pss_Anon`, `Anonymous`, …) without walking every mapping.

## Safety

- `pmap` needs the same access as reading `/proc/PID/smaps`. That means your own processes, or root (or `CAP_SYS_PTRACE`) for others. It does **not** pause the target.
- `strace -p` and `gdb -p` **attach** with `ptrace`. They stop or slow every thread of the target. Prefer launching the program under the tool, as below, or use `bpftrace`, which does not stop the process.
- Attaching is also restricted by `kernel.yama.ptrace_scope` (Debian/Ubuntu default `1`: only descendants). Do not loosen it on production hosts just to debug.
- A conditional breakpoint still traps on **every** call to the function, and gdb then evaluates the condition. On a hot function that is a large slowdown. Keep such sessions short.

## Examples with Explanations

All examples use a small, self-contained leak, so you can reproduce every step as an ordinary user. `leaky.c` simulates a request loop. Each request uses a 64 KiB `malloc` buffer, which it frees correctly. It also takes a 256 KiB "pinned" buffer from a tiny pool, which gets memory with a **raw `syscall(SYS_mmap, …)`** and, on release, parks the buffer on a deferred-release list. The list is drained only when it grows past `POOL_MAX_UNRELEASED`, and the default is unlimited. This is the same shape as a real-world leak in a registration-cache library (see the case note after example 7).

```c
/* leaky.c — a request loop with a native leak that malloc never sees.
 *
 * Each "request" uses a 64 KiB heap buffer (freed, healthy) and a 256 KiB
 * "pinned" buffer from a tiny pool allocator. The pool gets memory with a raw
 * syscall(SYS_mmap) and, on release, parks buffers on a deferred-release
 * list that is drained only when it exceeds POOL_MAX_UNRELEASED.
 * Default: unlimited, so nothing is ever unmapped.
 *
 *   ./leaky [requests]          POOL_MAX_UNRELEASED=16 ./leaky
 */
#define _GNU_SOURCE
#include <malloc.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/syscall.h>
#include <unistd.h>

#define PIN_SIZE (256 * 1024)

struct parked { void *addr; struct parked *next; };
static struct parked *unreleased;
static long n_unreleased, max_unreleased = -1;   /* -1 = unlimited */

static void *pool_get(void)
{
    /* raw syscall: bypasses glibc's mmap() symbol and any hook on it */
    void *p = (void *)syscall(SYS_mmap, NULL, PIN_SIZE,
                              PROT_READ | PROT_WRITE,
                              MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    if (p == MAP_FAILED) { perror("mmap"); exit(1); }
    return p;
}

static void pool_put(void *p)
{
    struct parked *e = malloc(sizeof *e);   /* tiny: 16 bytes on the heap */
    e->addr = p;
    e->next = unreleased;
    unreleased = e;
    if (max_unreleased >= 0 && ++n_unreleased > max_unreleased) {
        while (unreleased) {                /* drain the whole list */
            struct parked *x = unreleased;
            unreleased = x->next;
            syscall(SYS_munmap, x->addr, PIN_SIZE);
            free(x);
        }
        n_unreleased = 0;
    }
}

static long rss_kib(void)
{
    char line[256];
    long kib = -1;
    FILE *f = fopen("/proc/self/status", "r");
    while (f && fgets(line, sizeof line, f))
        if (sscanf(line, "VmRSS: %ld kB", &kib) == 1) break;
    if (f) fclose(f);
    return kib;
}

static void handle_request(int i)
{
    char *scratch = malloc(64 * 1024);      /* normal heap use */
    memset(scratch, i & 0xff, 64 * 1024);
    char *pinned = pool_get();              /* "registered" buffer */
    memcpy(pinned, scratch, 64 * 1024);     /* touch it: now resident */
    free(scratch);
    pool_put(pinned);                       /* "released" ... */
}

int main(int argc, char **argv)
{
    int requests = argc > 1 ? atoi(argv[1]) : 2000;
    const char *cap = getenv("POOL_MAX_UNRELEASED");
    if (cap) max_unreleased = atol(cap);
    printf("pid %d, %d requests, max_unreleased=%ld\n",
           getpid(), requests, max_unreleased);
    fflush(stdout);
    int every = requests >= 4 ? requests / 4 : 1;
    for (int i = 1; i <= requests; i++) {
        handle_request(i);
        if (i % every == 0) {
            struct mallinfo2 mi = mallinfo2();
            printf("req %5d  VmRSS %7ld KiB  malloc in-use %5zu KiB\n",
                   i, rss_kib(), mi.uordblks / 1024);
            fflush(stdout);
        }
        usleep(1000);
    }
    return 0;
}
```

```bash
mkdir -p /tmp/leak && cd /tmp/leak        # save leaky.c here
gcc -O0 -g -fno-omit-frame-pointer -o leaky leaky.c
```

`-g` and `-fno-omit-frame-pointer` keep stacks readable for the later steps. `-O0` keeps `pool_get` as a real function. At `-O1` and above, GCC inlines the whole request path into `main`, and the stacks below collapse to a single frame.

Tested on Debian 13 (kernel 6.12, x86-64) with gcc 14.2, glibc 2.41, procps-ng 4.0.4, strace 6.13, gdb 16.3 and bpftrace 0.23.2. PIDs, addresses and paths in the outputs are from that box.

### 1. Symptom: RSS climbs, the heap does not

```bash
./leaky 2000
```

```text
pid 473958, 2000 requests, max_unreleased=-1
req   500  VmRSS   33844 KiB  malloc in-use    20 KiB
req  1000  VmRSS   65920 KiB  malloc in-use    37 KiB
req  1500  VmRSS   97936 KiB  malloc in-use    53 KiB
req  2000  VmRSS  129952 KiB  malloc in-use    68 KiB
```

RSS grows by about 64 KiB per request: the part of each pinned buffer that was touched. `malloc` reports 68 KiB in use, and that is only the 16-byte list nodes. Any tool that counts `malloc`/`free` (heaptrack, Memray, Valgrind's massif in heap mode, `mallinfo2`) would truthfully report "no leak". **Heaps lie by omission**: they only know about memory they handed out.

### 2. Where: watch the biggest mappings with `pmap -x`

`top-maps.sh` prints the header, the total, and the top N mappings by RSS:

```bash
#!/bin/sh
# top-maps.sh PID [N] — largest mappings by RSS, with header and total
pmap -x "$1" | awk 'NR == 2 || /^total/'
pmap -x "$1" | sed '1,2d;$d' | sort -k3 -nr | head -n "${2:-3}"
```

```bash
chmod +x top-maps.sh
./leaky 8000 > leaky.out & sleep 0.5
P=$(awk '{print $2; exit}' leaky.out | tr -d ,)   # the PID leaky printed, not $!
echo "leaky pid $P"; sleep 1.5
echo "### t=2s"; ./top-maps.sh "$P"; sleep 3
echo "### t=5s"; ./top-maps.sh "$P"
wait
```

```text
leaky pid 474858
### t=2s
Address           Kbytes     RSS   Dirty Mode  Mapping
total kB          459004  115876  114340
00007ff333c02000  457228  114312  114312 rw---   [ anon ]
00007ff34faad000    1420    1024       0 r-x-- libc.so.6
00007ff34fc8e000     160     160       0 r-x-- ld-linux-x86-64.so.2
### t=5s
Address           Kbytes     RSS   Dirty Mode  Mapping
total kB         1143684  287096  285560
00007ff309f82000 1141772  285448  285448 rw---   [ anon ]
00007ff34faad000    1420    1024       0 r-x-- libc.so.6
000055bbfe2e4000     268     212     212 rw---   [ anon ]
```

Read it like this:

- **One anonymous region holds almost all of the RSS** (114 MB, then 285 MB), and it is not `[heap]`. This is a mapping leak, not a `malloc` leak.
- **Its start address moves down** (`…7ff333c02000` → `…7ff309f82000`) while its size grows. New mappings are placed just below the previous ones, and the kernel merges them into one region. "Growing and moving" is the signature of repeated `mmap` with no matching `munmap`. A single region that grows in place points to `mremap` instead.
- **`Kbytes` grows 4× faster than `RSS`** (each 256 KiB mapping has 64 KiB touched). On a long-running service, address-space growth like this ends in `ENOMEM` from `mmap` or an overcommit OOM, even if RSS looks tolerable.

To follow it live, use `watch -n 1 ./top-maps.sh "$P"`. For a single number, read `/proc/PID/smaps_rollup`. Here it is one second into a fresh run:

```bash
./leaky 1500 > leaky.out & sleep 1
P=$(awk '{print $2; exit}' leaky.out | tr -d ,)
grep -E 'Rss|Pss_Anon|Anonymous' /proc/$P/smaps_rollup; wait
```

```text
Rss:               58664 kB
Pss_Anon:          56904 kB
Anonymous:         56904 kB
```

Nearly all of RSS (56.9 of 58.7 MB) is anonymous memory. Libraries and the binary account for the rest. That rules out file-backed growth (a mapped file or a cache) before you look at a single mapping.

### 3. Why an `LD_PRELOAD` hook sees nothing

The usual next move is to interpose `mmap`/`munmap` and count calls:

```c
/* mmaphook.c — LD_PRELOAD shim that counts calls to the mmap()/munmap() symbols */
#define _GNU_SOURCE
#include <dlfcn.h>
#include <stdio.h>
#include <sys/mman.h>
#include <sys/types.h>

static long n_mmap, n_munmap;

void *mmap(void *addr, size_t len, int prot, int flags, int fd, off_t off)
{
    static void *(*real)(void *, size_t, int, int, int, off_t);
    if (!real) real = dlsym(RTLD_NEXT, "mmap");
    n_mmap++;
    return real(addr, len, prot, flags, fd, off);
}

int munmap(void *addr, size_t len)
{
    static int (*real)(void *, size_t);
    if (!real) real = dlsym(RTLD_NEXT, "munmap");
    n_munmap++;
    return real(addr, len);
}

__attribute__((destructor)) static void report(void)
{
    fprintf(stderr, "[mmaphook] mmap() calls: %ld, munmap() calls: %ld\n",
            n_mmap, n_munmap);
}
```

```bash
gcc -shared -fPIC -O2 -o mmaphook.so mmaphook.c -ldl
LD_PRELOAD=./mmaphook.so ./leaky 400
```

```text
pid 475280, 400 requests, max_unreleased=-1
req   100  VmRSS    8256 KiB  malloc in-use     7 KiB
req   200  VmRSS   14724 KiB  malloc in-use    12 KiB
req   300  VmRSS   21124 KiB  malloc in-use    15 KiB
req   400  VmRSS   27528 KiB  malloc in-use    18 KiB
[mmaphook] mmap() calls: 0, munmap() calls: 0
```

Zero calls, while RSS grew by 19 MB. `LD_PRELOAD` interposes **symbols**. `syscall(SYS_mmap, …)` never calls the `mmap` symbol, and neither does a library that patches its own GOT entries or issues the `syscall` instruction itself. An empty hook log does not mean "no `mmap`". It means "no `mmap` through this door". You need a tracer that sits at the **kernel boundary**.

### 4. Who: count and attribute syscalls at the kernel boundary

`strace` sees every system call, however it was issued. Launch the program under it rather than attaching:

```bash
strace -f -c -e trace=mmap,munmap ./leaky 400 2>&1 | tail -n 8
```

```text
req   300  VmRSS   21012 KiB  malloc in-use    15 KiB
req   400  VmRSS   27416 KiB  malloc in-use    18 KiB
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
100.00    0.001799           4       408           mmap
  0.00    0.000000           0         1           munmap
------ ----------- ----------- --------- --------- ----------------
100.00    0.001799           4       409           total
```

408 `mmap` (400 requests plus 8 from the dynamic loader) against 1 `munmap`. That is the leak, counted. `-k` adds a user-space stack to each call:

```bash
strace -k -e trace=mmap ./leaky 2 2>&1 | grep -A 6 'mmap(NULL, 262144' | head -n 7
```

```text
mmap(NULL, 262144, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0) = 0x7fef2bb1b000
 > /usr/lib/x86_64-linux-gnu/libc.so.6(syscall+0x19) [0x10e4f9]
 > /workspace/scratch/leak/leaky(pool_get+0x38) [0x1291]
 > /workspace/scratch/leak/leaky(handle_request+0x37) [0x146c]
 > /workspace/scratch/leak/leaky(main+0xd9) [0x157c]
 > /usr/lib/x86_64-linux-gnu/libc.so.6(__libc_start_call_main+0x78) [0x29ca8]
 > /usr/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main_alias_2+0x85) [0x29d65]
```

The top frame, **`syscall+0x19`**, is the tell. The call came through glibc's generic `syscall()` wrapper, not through `mmap()`, which is exactly why the hook missed it. The next frame names the culprit, `pool_get`.

`strace` is the right tool for a reproducer. On a busy production process it is not: every traced syscall costs two `ptrace` stops, and `-p` attaches to (and slows) every thread. That is where `bpftrace` comes in.

### 5. Who, in production: `bpftrace` on the syscall tracepoints

```c
// mmapwatch.bt — who maps anonymous memory, and who gives it back?
tracepoint:syscalls:sys_enter_mmap /pid == cpid && args.fd == -1/
{
    @mmap_bytes[ustack(perf)] = sum(args.len);
    @mmap_calls = count();
}
tracepoint:syscalls:sys_enter_munmap /pid == cpid/
{
    @munmap_bytes = sum(args.len);
    @munmap_calls = count();
}
```

```bash
sudo bpftrace mmapwatch.bt -c './leaky 400'       # launch under bpftrace (cpid = child)
# or, for a running process: replace "cpid" with "$1" and run
#   sudo bpftrace mmapwatch.bt PID
```

The script sums anonymous `mmap` bytes **per user stack** and totals `munmap`, all in the kernel, with no per-call stop of the target. When the program exits (or on Ctrl-C) bpftrace prints the maps: the stack that ends in `pool_get` would carry about 100 MiB with 400 calls, against a near-zero `munmap` total.

**Not run on this book's test box.** The test VM's kernel exposes no tracefs and no kprobe/uprobe PMUs (`/sys/bus/event_source/devices` lists only `breakpoint msr power software`), so the run fails before attaching:

```text
mmapwatch.bt:1-2: ERROR: tracepoint not found: syscalls:sys_enter_mmap
```

Kprobe and uprobe variants fail on the same box with `ERROR: Unknown BPF object load failure`. This is common in sandboxes, some containers and minimal cloud kernels. Check before an incident with `sudo bpftrace -l 'tracepoint:syscalls:sys_enter_mmap'`. If it prints nothing, use `strace -k` (step 4) on a reproducer, or the gdb approach in step 6.

Two field notes for when it does run:

- `ustack()` depends on frame pointers (or DWARF unwinding, which bpftrace does not do in-kernel). A library built without frame pointers shows **one** frame (`syscall+N`) and then nothing. That single frame is still enough to drive step 6.
- Add `tracepoint:syscalls:sys_enter_mremap` if `pmap` shows a region growing **in place** rather than moving.

### 6. Prove it: scripted `gdb` that stops only on the guilty call

`gdb` gives the complete stack *and* the address returned, which you can match against the `pmap` region. Put a breakpoint on glibc's `syscall()` with a condition on the syscall number. On x86-64 the first argument, `$rdi`, is the number (`9` = `mmap`) and the third, `$rdx`, is the length. A second breakpoint just after the `syscall` instruction reads `$rax`, the kernel's return value.

First find that offset in *your* glibc:

```bash
gdb -q -batch -ex 'disassemble syscall' /lib/x86_64-linux-gnu/libc.so.6 | head -n 12
```

```text
Dump of assembler code for function syscall:
   0x000000000010e4e0 <+0>:	mov    %rdi,%rax
   0x000000000010e4e3 <+3>:	mov    %rsi,%rdi
   0x000000000010e4e6 <+6>:	mov    %rdx,%rsi
   0x000000000010e4e9 <+9>:	mov    %rcx,%rdx
   0x000000000010e4ec <+12>:	mov    %r8,%r10
   0x000000000010e4ef <+15>:	mov    %r9,%r8
   0x000000000010e4f2 <+18>:	mov    0x8(%rsp),%r9
   0x000000000010e4f7 <+23>:	syscall
   0x000000000010e4f9 <+25>:	cmp    $0xfffffffffffff001,%rax
   0x000000000010e4ff <+31>:	jae    0x10e502 <syscall+34>
   0x000000000010e501 <+33>:	ret
```

`+25` is the instruction after `syscall`. It matches the `syscall+0x19` frame from `strace -k`. Other glibc builds differ (the vLLM investigation saw `syscall+29`), so always check.

```gdb
# mmap-catch.gdb — stop only on raw syscall(SYS_mmap, ...), print who and what
set pagination off
set $want = 0

# entry: rdi = syscall number (9 = mmap on x86-64), rdx = length
break syscall if $rdi == 9
commands
  silent
  set $want = 1
  printf "syscall(SYS_mmap, len=%lu) from:\n", $rdx
  bt 4
  continue
end

# right after the `syscall` instruction: rax = the kernel's return value
break *syscall+25 if $want == 1
commands
  silent
  set $want = 0
  printf "  -> mapped at 0x%lx\n\n", $rax
  continue
end

# just before the process exits, show where those mappings ended up
catch syscall exit_group
commands
  silent
  info proc mappings
  continue
end

run 3
```

```bash
gdb -q -batch -x mmap-catch.gdb ./leaky 2>&1 | grep -v '^\['
```

```text
Breakpoint 1 at 0x10c0
Breakpoint 2 at 0x10d9
Catchpoint 3 (syscall 'exit_group' [231])
Using host libthread_db library "/lib/x86_64-linux-gnu/libthread_db.so.1".
pid 475570, 3 requests, max_unreleased=-1
syscall(SYS_mmap, len=262144) from:
#0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:30
#1  0x0000555555555291 in pool_get () at leaky.c:29
#2  0x000055555555546c in handle_request (i=1) at leaky.c:68
#3  0x000055555555557c in main (argc=2, argv=0x7fffffffde68) at leaky.c:84
  -> mapped at 0x7ffff7d7c000

req     1  VmRSS    1820 KiB  malloc in-use     4 KiB
syscall(SYS_mmap, len=262144) from:
#0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:30
#1  0x0000555555555291 in pool_get () at leaky.c:29
#2  0x000055555555546c in handle_request (i=2) at leaky.c:68
#3  0x000055555555557c in main (argc=2, argv=0x7fffffffde68) at leaky.c:84
  -> mapped at 0x7ffff7d3c000

req     2  VmRSS    1948 KiB  malloc in-use     6 KiB
syscall(SYS_mmap, len=262144) from:
#0  syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:30
#1  0x0000555555555291 in pool_get () at leaky.c:29
#2  0x000055555555546c in handle_request (i=3) at leaky.c:68
#3  0x000055555555557c in main (argc=2, argv=0x7fffffffde68) at leaky.c:84
  -> mapped at 0x7ffff7cfc000

req     3  VmRSS    2012 KiB  malloc in-use     6 KiB
process 475570
Mapped address spaces:

Start Addr         End Addr           Size               Offset             Perms File 
0x0000555555554000 0x0000555555555000 0x1000             0x0                r--p  /workspace/scratch/leak/leaky 
...
0x0000555555559000 0x000055555557a000 0x21000            0x0                rw-p  [heap] 
0x00007ffff7cfc000 0x00007ffff7dbf000 0xc3000            0x0                rw-p   
0x00007ffff7dbf000 0x00007ffff7de7000 0x28000            0x0                r--p  /usr/lib/x86_64-linux-gnu/libc.so.6 
...
```

(The `...` lines are elided from the full `info proc mappings` table: the remaining library, `[vvar]`, `[vdso]`, `[stack]` and `[vsyscall]` mappings.)

Each hit prints the full stack to `leaky.c:29`, and the returned address. The three returns step down by `0x40000` (256 KiB), and the final map shows them merged into one anonymous region, `0x7ffff7cfc000–0x7ffff7dbf000`, that starts at the last address returned. That is the same "growing and moving down" region that `pmap` flagged in step 2, now tied to a line of source.

The "Breakpoint 1 at 0x10c0" line is gdb resolving `syscall` to the program's PLT stub before libc is loaded. After `run`, it re-resolves both breakpoints into libc, as the `#0 syscall () at …syscall.S` frames show.

Two practical notes:

- `finish` cannot be used inside breakpoint `commands` (it resumes and loses the remaining commands). Hence the `$want` flag and the second breakpoint at a fixed offset.
- In production the same script would start with `attach PID` instead of `run`. That stops **every thread** while gdb sets up and on every breakpoint hit. Do it on a canary instance, for seconds, never on the only replica.

### 7. Fix and verify

Here the fix is to bound the deferred-release list:

```bash
POOL_MAX_UNRELEASED=16 ./leaky 2000
```

```text
pid 473970, 2000 requests, max_unreleased=16
req   500  VmRSS    2256 KiB  malloc in-use     4 KiB
req  1000  VmRSS    2704 KiB  malloc in-use     6 KiB
req  1500  VmRSS    2064 KiB  malloc in-use     6 KiB
req  2000  VmRSS    2512 KiB  malloc in-use     6 KiB
```

RSS stays flat at about 2–3 MB, against 130 MB for the same 2,000 requests in step 1. Verify a fix in production the same way you found the leak: `top-maps.sh` should show no anonymous region that keeps growing.

**Real-world case.** The design of `leaky.c` mirrors a 2025 leak in vLLM's prefill/decode-disaggregated serving. The UCX communication library (used through NIXL) intercepts `mmap`/`munmap` for its registration cache. It allocated with raw `syscall(SYS_mmap)`, and it parked "released" regions in an invalidation queue whose default limit (`UCX_RCACHE_MAX_UNRELEASED`) was unbounded. Heap profilers saw nothing, `LD_PRELOAD` hooks saw nothing, `pmap` showed growing, moving anonymous regions, `bpftrace` found `syscall+29`, and conditional gdb breakpoints named `ucm_mmap`. The workaround merged into vLLM sets `UCX_MEM_MMAP_HOOK_MODE=none`. Capping `UCX_RCACHE_MAX_UNRELEASED` is the alternative knob.

## The trap

**Watching the wrong PID, or the wrong half of a pipe.**

The program you started is often not the process holding the memory. Depending on the shell and how the job line is written, `$!` can be a forked shell rather than the program, and `uv run`, `npm`, `sudo` and container shims all sit in front of the real process. In step 2 the script used the PID that `leaky` printed. Here is what `$!` was in the test box's non-interactive bash, for the same job line:

```bash
./leaky 8000 > /tmp/leaky.out & P=$!; sleep 2; ./top-maps.sh "$P"
```

```text
Address           Kbytes     RSS   Dirty Mode  Mapping
total kB            4764    2112     544
00007f3c2fe7f000    1420     700       0 r-x-- libc.so.6
000055d9eaf9b000     804     652       0 r-x-- bash
000055da0a97b000     404     340     340 rw---   [ anon ]
```

That is a 4.7 MB `bash`, not the 450 MB leaker. It looks healthy, and it stays healthy, so you conclude "no leak". Check with `ps -o pid,ppid,comm --ppid "$P" -p "$P"` before watching anything.

A second, quieter version of the same trap is the "keep the header" idiom that appears in many write-ups:

```bash
pmap -x "$P" | (head -n 2; tail -n +3 | sort -k3 -nr | head -n 3)
```

```text
475171:   ./leaky 3000
Address           Kbytes     RSS   Dirty Mode  Mapping
```

`head` reads a whole buffer from the pipe, not just two lines, so `tail` gets what is left, which here is nothing. On a large process `tail` gets the remainder of the buffer, so the first few kilobytes of mappings silently **disappear from the sort**. Run `pmap` twice (as `top-maps.sh` does) or use `pmap -q`.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| Trusting heap profilers for RSS | "No leak" while RSS climbs. Compare `mallinfo2`/profiler totals with `VmRSS` and `smaps_rollup` first |
| Looking only at RSS | Reserved address space (`Kbytes`) can grow much faster. Watch both columns |
| One big `[ anon ]` line looks like one allocation | Adjacent anonymous mappings merge. Use the moving start address, or `strace`/gdb, to see individual calls |
| `LD_PRELOAD` hook shows nothing | Raw `syscall()`, GOT patching and static binaries bypass symbol interposition. Trace at the kernel boundary |
| `bpftrace` "tracepoint not found" | No tracefs, or a locked-down kernel. `sudo bpftrace -l 'tracepoint:syscalls:*mmap*'` tells you in advance |
| One-frame `ustack()` | The library was built without frame pointers. Use the top frame (`syscall+N`) as a gdb breakpoint target |
| Inlined code in stacks | Production builds inline aggressively. Use `-g` plus `addr2line -i` or gdb's inline frames, or reproduce at `-O0` |
| `gdb`/`strace -p` on production | Stops or slows all threads. Prefer launching under the tool, a canary, or bpftrace |
| `pmap -X` column positions | Columns follow the kernel's `smaps` fields and change between kernels. Select fields by name |

## The boring rule

> When RSS grows: `smaps_rollup` first (anon or file?), then `pmap -x` twice, a few seconds apart (which mapping, and does it move?), then count `mmap` vs `munmap` at the kernel boundary (`bpftrace` in production, `strace -c`/`-k` on a reproducer), then a conditional gdb breakpoint on the one call site you found, on a canary. Fix by bounding the cache or pool, and verify with the same `pmap` loop.

## Related Commands

| Command | Role |
|---------|------|
| `strace -c` / `strace -k` | Syscall counts and per-call user stacks (launch, don't attach, when you can) |
| `bpftrace` | In-kernel syscall aggregation with stacks, without stopping the target |
| `gdb` | Conditional breakpoints, full stacks, register values |
| `ltrace` | Library-call tracing (symbol-level, so it shares `LD_PRELOAD`'s blind spot for raw syscalls) |
| `perf` | Sampling profiles; `perf trace` for syscalls where tracepoints exist |
| `/proc/PID/smaps_rollup` | One-shot totals: `Rss`, `Pss_Anon`, `Anonymous`, `Swap` |

## Try this

1. Run `leaky` with `POOL_MAX_UNRELEASED=0`, `16` and unset, and watch `top-maps.sh` each time. At what list size does the anonymous region stop growing?
2. Change `pool_get` to call `mmap()` instead of `syscall(SYS_mmap, …)`, rebuild, and rerun step 3. What does `mmaphook.so` report now, and which `strace -k` frame changes?
3. Rebuild `leaky` with `-O2` and repeat steps 4 and 6. Which frames disappear, and can you still identify the call site?
4. On a host where `bpftrace -l 'tracepoint:syscalls:sys_enter_mmap'` prints a line, run `mmapwatch.bt` against `leaky` and compare its byte totals with `strace -c`.
5. Add `tracepoint:syscalls:sys_enter_mremap` to `mmapwatch.bt` and write a variant of `leaky.c` that grows one buffer with `mremap`. How does it look in `pmap` compared with the `mmap` leak?

## Sources

- [pmap(1)](https://man7.org/linux/man-pages/man1/pmap.1.html), procps-ng manual
- [proc_pid_smaps(5)](https://man7.org/linux/man-pages/man5/proc_pid_smaps.5.html) and [proc_pid_maps(5)](https://man7.org/linux/man-pages/man5/proc_pid_maps.5.html): mapping fields; `smaps_rollup`
- [mmap(2)](https://man7.org/linux/man-pages/man2/mmap.2.html), [syscall(2)](https://man7.org/linux/man-pages/man2/syscall.2.html)
- [strace(1)](https://man7.org/linux/man-pages/man1/strace.1.html) (`-c`, `-k`)
- [bpftrace manual](https://github.com/bpftrace/bpftrace/blob/master/man/adoc/bpftrace.adoc): tracepoints, `args`, `ustack`, `cpid`
- [GDB manual: Break Commands](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Break-Commands.html) and [Conditions](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Conditions.html)
- vLLM issue [#24264](https://github.com/vllm-project/vllm/issues/24264) (CPU memory leak in P/D disaggregation) and PR [#32181](https://github.com/vllm-project/vllm/pull/32181) (`UCX_MEM_MMAP_HOOK_MODE=none`)
