---
title: "io_uring (batched asynchronous I/O)"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# io_uring (batched asynchronous I/O)

## Overview

**Thesis:** with `read(2)`, every read is a separate trip into the kernel: you ask, you wait, you ask again. **io_uring** replaces that conversation with two ring buffers shared between your process and the kernel. You write requests (**SQEs**) into the submission queue. The kernel writes results (**CQEs**) into the completion queue. One `io_uring_enter(2)` call can hand over a whole batch, and reaping completions that are already posted costs no system call at all. That makes it the fastest general-purpose I/O interface on Linux. It is also an interface that operators often switch **off**, so every program that uses it needs a fallback.

Typical operator jobs:

- Recognise io_uring in `strace` output and in tools that use it (`fio --ioengine=io_uring`, databases, QEMU, newer runtimes and imaging tools).
- Confirm whether io_uring is allowed on a host or in a container before you blame an application.
- Decide on the policy knob `kernel.io_uring_disabled` for a multi-tenant host.
- Read a small liburing program and know where the buffers, tags and errors live.

## Mental model

```text
   your process                                   kernel
   ────────────                                   ──────
   io_uring_get_sqe()  ──▶ [ SQ ring: SQE SQE SQE ]  ──▶  executes requests
   io_uring_submit()   ── one io_uring_enter(2) ──▶      (in any order)
   io_uring_wait_cqe() ◀── [ CQ ring: CQE CQE CQE ]  ◀──  posts results
                           (shared memory: reading a posted CQE is a load, not a syscall)
```

| Fact | Consequence |
|------|-------------|
| Rings are memory mapped and shared | Submitting N requests can cost one syscall, and reaping can cost zero |
| Completions arrive **in any order** | Every SQE carries `user_data` (a 64-bit tag). You match results by tag, never by position |
| A CQE's `res` is the syscall's return value | Negative `res` is `-errno`. Positive `res` can be a **short** read, exactly like `read(2)` |
| The kernel uses your buffer until the CQE arrives | A stack buffer that goes out of scope before completion is a memory-corruption bug |
| It can be disabled by sysctl, seccomp or an LSM | `io_uring_setup(2)` fails with `EPERM` (policy) or `ENOSYS` (filtered or very old kernel) |

## Syntax

The raw interface is three system calls (`io_uring_setup`, `io_uring_enter`, `io_uring_register`). Nearly everyone uses **liburing**, the library maintained alongside the kernel code:

```c
struct io_uring ring;
io_uring_queue_init(entries, &ring, 0);            /* io_uring_setup + mmap the rings */
struct io_uring_sqe *sqe = io_uring_get_sqe(&ring); /* claim a slot */
io_uring_prep_read(sqe, fd, buf, len, offset);      /* fill it like a pread() call */
io_uring_sqe_set_data64(sqe, tag);                  /* your tag, echoed in the CQE */
io_uring_submit(&ring);                             /* io_uring_enter: hand over the batch */
io_uring_wait_cqe(&ring, &cqe);                     /* next completion (no syscall if posted) */
io_uring_cqe_seen(&ring, cqe);                      /* give the CQ slot back */
io_uring_queue_exit(&ring);
```

On Debian and Ubuntu the headers are in `liburing-dev`, on Fedora in `liburing-devel`. Link with `-luring`.

The host policy knob (Linux 6.6 and later):

| `kernel.io_uring_disabled` | Effect |
|---|---|
| `0` (default) | Anyone may create rings |
| `1` | Only processes with `CAP_SYS_ADMIN`, or in the group named by `kernel.io_uring_group`, may create rings |
| `2` | Nobody may create rings. Existing rings keep working |

## Safety

Reading files with io_uring is no more dangerous than reading them with `read(2)`. The risk is on the **kernel** side: io_uring is a large attack surface and has a long CVE history. That is why Android, ChromeOS, Google's production fleet and Docker's default seccomp profile restrict it, and why the sysctl exists. Changing `kernel.io_uring_disabled` affects the whole host. Try it only on a machine you own, and set it back.

## Examples with Explanations

Tested on Linux 6.12 (Debian 13) with GCC 14.2 and liburing 2.9. Every call used here has been in the kernel since 5.6 and in liburing since 2.2, so the listings work unchanged on current kernels.

### 1. Three reads, one system call

```c
/* batch3.c — read three files with one io_uring_submit() */
#include <fcntl.h>
#include <liburing.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

int main(int argc, char **argv)
{
    struct io_uring ring;
    char buf[3][64];
    int fds[3], n = argc - 1;

    if (n < 1 || n > 3) { fprintf(stderr, "usage: %s f1 [f2 [f3]]\n", argv[0]); return 2; }
    int rc = io_uring_queue_init(8, &ring, 0);
    if (rc < 0) { fprintf(stderr, "io_uring_queue_init: %s\n", strerror(-rc)); return 1; }

    for (int i = 0; i < n; i++) {
        fds[i] = open(argv[i + 1], O_RDONLY);
        if (fds[i] < 0) { perror(argv[i + 1]); return 1; }
        struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
        io_uring_prep_read(sqe, fds[i], buf[i], sizeof buf[i] - 1, 0);
        io_uring_sqe_set_data64(sqe, i);          /* tag: which file */
    }
    printf("submitted %d SQEs in one call\n", io_uring_submit_and_wait(&ring, n));

    for (int done = 0; done < n; done++) {
        struct io_uring_cqe *cqe;
        io_uring_wait_cqe(&ring, &cqe);           /* already complete: no syscall */
        int i = (int)io_uring_cqe_get_data64(cqe);
        if (cqe->res < 0)
            printf("%s: error %s\n", argv[i + 1], strerror(-cqe->res));
        else {
            buf[i][cqe->res] = '\0';
            buf[i][strcspn(buf[i], "\n")] = '\0';
            printf("%-20s %3d bytes  \"%s\"\n", argv[i + 1], cqe->res, buf[i]);
        }
        io_uring_cqe_seen(&ring, cqe);
    }
    io_uring_queue_exit(&ring);
    return 0;
}
```

```bash
gcc -O2 -Wall -o batch3 batch3.c -luring
./batch3 /etc/hostname /proc/version /etc/os-release
```

```text
submitted 3 SQEs in one call
/proc/version         63 bytes  "Linux version 6.12.94+ (root@758c51f35d4c) (gcc (Debian 12.2.0-"
/etc/hostname         22 bytes  "grok-bot-vm-399265740"
/etc/os-release       63 bytes  "PRETTY_NAME="Debian GNU/Linux 13 (trixie)""
```

Two things to notice:

- The files were submitted in the order hostname, version, os-release, but **`/proc/version` completed first**. That is why each SQE carries a tag (`io_uring_sqe_set_data64`) and why the loop looks the file up by tag.
- `io_uring_submit_and_wait(&ring, n)` submits and waits for `n` completions in the same `io_uring_enter` call. After that, `io_uring_wait_cqe` only reads shared memory.

Count the system calls:

```bash
strace -c -e trace=io_uring_enter,io_uring_setup,read,openat ./batch3 /etc/hostname /proc/version /etc/os-release
```

```text
% time     seconds  usecs/call     calls    errors syscall
------ ----------- ----------- --------- --------- ----------------
  0.00    0.000000           0         2           read
  0.00    0.000000           0         6           openat
  0.00    0.000000           0         1           io_uring_setup
  0.00    0.000000           0         1           io_uring_enter
------ ----------- ----------- --------- --------- ----------------
100.00    0.000000           0        10           total
```

One `io_uring_enter` did all three reads. The two `read` calls are the dynamic loader reading shared libraries, not our files.

### 2. Is io_uring allowed here?

```bash
cat /proc/sys/kernel/io_uring_disabled      # 0, 1 or 2
cat /proc/sys/kernel/io_uring_group         # -1 means no group is exempt
sudo sysctl -q kernel.io_uring_disabled=2   # lab only: turn it off for everyone
./batch3 /etc/hostname
sudo sysctl -q kernel.io_uring_disabled=1   # privileged only
./batch3 /etc/hostname
sudo ./batch3 /etc/hostname
sudo sysctl -q kernel.io_uring_disabled=0   # restore the default
```

```text
0
-1
io_uring_queue_init: Operation not permitted
io_uring_queue_init: Operation not permitted
submitted 1 SQEs in one call
/etc/hostname         22 bytes  "grok-bot-vm-399265740"
```

With `1`, the unprivileged run is refused and the root run works. In a container the same `EPERM` (or `ENOSYS`) usually comes from the runtime's seccomp profile rather than the sysctl. Check `grep Seccomp /proc/self/status` inside the container and the runtime's profile before you change any host setting.

### 3. A fallback that keeps the program working

```c
/* readall.c — io_uring when allowed, plain pread() when not */
#include <errno.h>
#include <fcntl.h>
#include <liburing.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>

static long read_with_pread(int fd, char *buf, size_t len)
{
    return pread(fd, buf, len, 0);
}

int main(int argc, char **argv)
{
    char buf[256];
    struct io_uring ring;
    int fd = open(argc > 1 ? argv[1] : "/etc/hostname", O_RDONLY);
    if (fd < 0) { perror("open"); return 1; }

    int rc = io_uring_queue_init(4, &ring, 0);
    if (rc == -EPERM || rc == -ENOSYS) {          /* sysctl, seccomp, or old kernel */
        fprintf(stderr, "io_uring unavailable (%s); using pread\n", strerror(-rc));
        long n = read_with_pread(fd, buf, sizeof buf);
        printf("pread: %ld bytes\n", n);
        return n < 0;
    }
    if (rc < 0) { fprintf(stderr, "io_uring_queue_init: %s\n", strerror(-rc)); return 1; }

    struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
    io_uring_prep_read(sqe, fd, buf, sizeof buf, 0);
    io_uring_submit(&ring);
    struct io_uring_cqe *cqe;
    io_uring_wait_cqe(&ring, &cqe);
    printf("io_uring: %d bytes\n", cqe->res);
    io_uring_cqe_seen(&ring, cqe);
    io_uring_queue_exit(&ring);
    return 0;
}
```

```bash
gcc -O2 -Wall -o readall readall.c -luring
./readall
sudo sysctl -q kernel.io_uring_disabled=2; ./readall; sudo sysctl -q kernel.io_uring_disabled=0
```

```text
io_uring: 22 bytes
io_uring unavailable (Operation not permitted); using pread
pread: 22 bytes
```

The fallback is decided **once, at ring setup**, and treats `EPERM` and `ENOSYS` as "not here" rather than as fatal errors. Any other error is a real failure and is reported as one.

### 4. Benchmarks with fio

```bash
fio --name=ur --filename=testfile --size=256M --rw=randread --bs=4k \
    --ioengine=io_uring --iodepth=32 --direct=1 --runtime=10 --time_based
```

Run the same job with `--ioengine=psync` to compare against one syscall per read. If io_uring is disabled, fio fails at setup instead of quietly falling back, which is what you want from a benchmark.

## The trap

**The buffer must outlive the request.** `io_uring_prep_read` only records a pointer. The kernel writes into that memory whenever the read completes, which may be after the function that prepared it has returned:

```c
void start_read(struct io_uring *ring, int fd)
{
    char buf[4096];                       /* BUG: lives on this stack frame */
    struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
    io_uring_prep_read(sqe, fd, buf, sizeof buf, 0);
    io_uring_submit(ring);
}                                         /* returns; the kernel may write here later */
```

On a fast local file this often "works", because the read completes before the frame is reused. On a pipe, socket or slow disk the kernel writes 4 KiB into whatever stack frame occupies that address later. ASan does not see kernel writes, so it will not catch this. The rule is the same as for POSIX AIO: allocate request buffers with the same lifetime as the request (heap, a per-request struct, or registered buffers) and free them only after you have seen the CQE.

## Notes & Pitfalls

| Pitfall | Symptom / fix |
|---------|---------------|
| Matching results by order | Wrong data attributed to the wrong file. Tag every SQE with `user_data` |
| Ignoring short reads | `res` smaller than requested. Loop, like `read(2)` |
| Forgetting `io_uring_cqe_seen` | The CQ fills up and new completions are dropped or overflow. Always mark CQEs seen |
| Treating `EPERM` as a bug | It is policy (sysctl, seccomp, LSM). Fall back to synchronous I/O |
| `io_uring_get_sqe` returns `NULL` | The SQ is full. Submit what you have, then retry |
| Expecting `strace` to show the reads | It shows only `io_uring_enter`. Use `bpftrace` on `io_uring:*` tracepoints to see individual operations |
| Using it for three small files | It works, but it saves almost nothing. The gains appear with high queue depth, many small requests, or network servers |

## The boring rule

> Use io_uring through liburing, tag every request, keep its buffer alive until its CQE is seen, and decide at ring setup whether it is available, falling back to plain syscalls on `EPERM`/`ENOSYS`. On shared hosts, set `kernel.io_uring_disabled` deliberately (`1` plus `io_uring_group` for trusted services) rather than leaving it to defaults.

## Related Commands

| Command | Role |
|---------|------|
| `strace -c` | Count `io_uring_enter` calls versus `read`/`write` |
| `sysctl kernel.io_uring_disabled` / `kernel.io_uring_group` | Host policy |
| `fio --ioengine=io_uring` | Benchmark io_uring against `psync` and `libaio` |
| `bpftrace -l 'tracepoint:io_uring:*'` | Per-request tracing |
| `grep Seccomp /proc/self/status` | Is a seccomp filter active in this process or container? |

## Try this

1. Change `batch3.c` to read the same three files 1,000 times with a ring of 64 entries, submitting in batches of 32, and compare `strace -c` totals with a `pread` loop.
2. Run `batch3` inside `docker run --rm` with the default profile, then with `--security-opt seccomp=unconfined`, and record the error each time.
3. Set `kernel.io_uring_disabled=1` and `kernel.io_uring_group` to a group your user belongs to. Confirm unprivileged rings work again. Restore both values.
4. Rewrite the trap so the buffer lives in a heap-allocated request struct that is freed after `io_uring_cqe_seen`.

## Sources

- [io_uring(7)](https://man7.org/linux/man-pages/man7/io_uring.7.html), [io_uring_setup(2)](https://man7.org/linux/man-pages/man2/io_uring_setup.2.html), [io_uring_enter(2)](https://man7.org/linux/man-pages/man2/io_uring_enter.2.html)
- liburing man pages and source: [github.com/axboe/liburing](https://github.com/axboe/liburing) (`io_uring_queue_init(3)`, `io_uring_prep_read(3)`, `io_uring_submit_and_wait(3)`)
- Jens Axboe, [Efficient IO with io_uring](https://kernel.dk/io_uring.pdf)
- Kernel documentation, [`/proc/sys/kernel/` — io_uring_disabled, io_uring_group](https://docs.kernel.org/admin-guide/sysctl/kernel.html#io-uring-disabled)
- fio documentation, [`ioengine=io_uring`](https://fio.readthedocs.io/en/latest/fio_doc.html#i-o-engine)
