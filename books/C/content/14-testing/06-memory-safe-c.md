---
title: "Memory-Safe C in Practice: Fil-C, counted_by, and -fbounds-safety"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Memory-Safe C in Practice: Fil-C, `counted_by`, and `-fbounds-safety`

## Thesis

Sanitizers find memory bugs **in the runs you test**. This chapter is about the other question: what stops an out-of-bounds write or a use-after-free **in production**, on input you never tried? As of October 2026 there are three practical answers for C on Linux, and they work at different levels:

| Option | What it is | Status (Oct 2026) | Unit of protection |
|--------|------------|-------------------|--------------------|
| **Fil-C** | A memory-safe *implementation* of C and C++. Every pointer carries an invisible capability and memory is garbage collected. You rebuild the program **and its libc** with it | 0.686 (released 2026-10-04). Linux x86_64/ARM64 only, based on Clang 20.1.8 | The **allocation**, rounded up to 16 bytes |
| **`counted_by`** | An attribute that ties a flexible array member to the struct field holding its length. The compiler then checks indexing (`-fsanitize=bounds`) and size queries | Upstream Clang (including 23.1.3) and GCC 15+. Not in GCC 14 | The **array member**, by its declared count |
| **`-fbounds-safety`** | Apple's bounds-annotation dialect of C (`__counted_by` on pointers, wide local pointers, compile-time rejection of unchecked arithmetic) | Upstream Clang documents it as "a design document … not available for users yet". Clang 23.1.3 rejects the flag. It ships in Apple's Clang fork | The **pointer**, by its annotation |

None of them is a free upgrade. This chapter runs the same few bugs through a plain build, `_FORTIFY_SOURCE=3`, AddressSanitizer, `counted_by`, and Fil-C, and shows what each one stops, what each one misses, and what it costs.

## Mental model

```text
                    detects in tests     stops in production     what you rebuild
                    ────────────────     ───────────────────     ─────────────────
ASan                 yes (byte-exact)     no (not hardening)      your code
_FORTIFY_SOURCE=3    some libc calls      same calls, abort       your code
counted_by + bounds  indexed FAM access   only with -trap         your code + annotations
Fil-C                yes (per object)     yes, panics             your code + libc + every dependency
```

| Question | Fil-C | ASan | `counted_by` |
|----------|-------|------|--------------|
| Overflow into the *next* allocation | Panic | Report | Only for annotated arrays |
| Overflow into the *next field* of the same struct | **Not caught** | **Not caught** | Only for annotated arrays |
| Use after free | Panic, every time | Report, unless the memory has been reused | No |
| Off-by-a-few past `malloc(n)` | Not caught until the 16-byte rounding is exhausted | Report | Caught exactly, for annotated arrays |
| Integer → pointer round trip through memory | Panic (the integer carries no capability) | Allowed | Allowed |
| Typical cost here | ~1.7× time, ~2× memory | ~1.8× time, ~2× memory | A compare per checked access |

The rows that matter most are the gaps. Fil-C protects *objects*, not fields. ASan is a debugging tool that an attacker can step around. `counted_by` only knows the arrays you annotate.

## Worked examples

All transcripts below come from this machine:

```console
$ gcc --version | head -1
gcc (Debian 14.2.0-19) 14.2.0
$ clang --version | head -1
clang version 23.1.3 (https://github.com/llvm/llvm-project 0d261d1ca552c95a8f007e061c787ac7132fbcbc)
$ $FILC/build/bin/clang --version | head -1
clang version 20.1.8 (Fil-C 0.686 git@github.com:pizlonator/fil-c.git 163fae598eaf249b74065b0156f3a7e7ba8c0e5a)
$ clang -fbounds-safety -c packet.c -o /dev/null
clang: error: unknown argument: '-fbounds-safety'
```

`clang` is the LLVM 23.1.3 release and `gcc` is Debian's 14.2. `$FILC` is the unpacked `filc-0.686-linux-x86_64` release tarball, after its `./setup.sh` has run. That tarball is the musl-based distribution, so `$FILC/build/bin/clang` links against Fil-C's own libc, not the system glibc.

### Case 1: an overflow into the next allocation

```c
// heap.c — copy a name into an 8-byte heap buffer without checking its length
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv) {
    const char *who = argc > 1 ? argv[1] : "kim";
    char *tag  = malloc(8);
    char *next = malloc(8);
    strcpy(next, "intact");
    strcpy(tag, who);                       /* no length check */
    printf("tag=%s next=%s\n", tag, next);
    free(next);
    free(tag);
    return 0;
}
```

```console
$ gcc -O2 -g heap.c -o heap_gcc
$ gcc -O2 -g -D_FORTIFY_SOURCE=3 heap.c -o heap_fortify
$ clang -O1 -g -fsanitize=address heap.c -o heap_asan
$ $FILC/build/bin/clang -O2 -g heap.c -o heap_fil
$ ./heap_gcc kim
tag=kim next=intact
$ ./heap_gcc kimberly-from-accounts-payable-admin; echo "exit=$?"
tag=kimberly-from-accounts-payable-admin next=dmin
double free or corruption (out)
Aborted
exit=134
$ ./heap_fortify kimberly-from-accounts-payable-admin; echo "exit=$?"
*** buffer overflow detected ***: terminated
Aborted
exit=134
$ ./heap_asan kimberly-from-accounts-payable-admin; echo "exit=$?"
=================================================================
==490270==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7bb331de0018 at pc 0x5558e5d16b15 bp 0x7ffcefde6f50 sp 0x7ffcefde6708
WRITE of size 37 at 0x7bb331de0018 thread T0
    #0 0x5558e5d16b14 in strcpy /home/runner/work/llvm-project/llvm-project/compiler-rt/lib/asan/asan_interceptors.cpp:642:5
    #1 0x5558e5d73822 in main /workspace/scratch/memsafe/heap.c:11:5
    #2 0x7f9332a98ca7 in __libc_start_call_main csu/../sysdeps/nptl/libc_start_call_main.h:58:16
    #3 0x7f9332a98d64 in __libc_start_main csu/../csu/libc-start.c:360:3
    #4 0x5558e5c83350 in _start (/workspace/scratch/memsafe/heap_asan+0x2d350)
...
$ ./heap_fil kimberly-from-accounts-payable-admin; echo "exit=$?"
filc safety error: cannot write pointer with ptr >= upper.
    pointer: 0x7f8bb39082e0,0x7f8bb39082d0,0x7f8bb39082e0
    expected 1 writable bytes.
semantic origin:
    (libc.so) src/string/stpcpy.c:12:12: __stpcpy
check scheduled at:
    (libc.so) src/string/stpcpy.c:12:13: __stpcpy
    (libc.so) src/string/strcpy.c:5:2: strcpy
    (heap_fil) heap.c:11:5: main
    (libc.so) src/env/__libc_start_main.c:79:7: __libc_start_main
    (libpizlo.so) <runtime>: start_program
[490283] filc panic: thwarted a futile attempt to violate memory safety.
Trace/breakpoint trap
exit=133
```

The ASan report is cut after the first frames.

- **Plain build.** `next` now reads `dmin`. The copy ran over the 8-byte buffer, through glibc's chunk header, and into the neighbouring string. The program only died later, inside `free`, far from the bug. On a different input it would not have died at all.
- **`_FORTIFY_SOURCE=3`.** glibc's checked `strcpy` knew the destination was an 8-byte `malloc` and aborted before writing. That only works because the size was visible at the call.
- **ASan** gives the best *diagnosis*: the exact write size (37) and the allocation it overflowed. It's built for tests, though. Its redzones and quarantine are probabilistic barriers, not a security boundary, and it roughly doubles memory.
- **Fil-C** stops the write at the first byte past the object (`ptr >= upper`) and panics with a stack. The trace goes through Fil-C's own `stpcpy`. The libc is compiled with the same checks, so there is no unchecked `strcpy` to hide in.

### Case 2: use after free

```c
// session.c — a dangling pointer meets a recycled allocation
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct session { char user[16]; int is_admin; };

int main(void) {
    struct session *s = malloc(sizeof *s);
    strcpy(s->user, "guest");
    s->is_admin = 0;
    free(s);                                   /* logout... */

    struct session *t = malloc(sizeof *t);     /* ...someone else logs in */
    strcpy(t->user, "root");
    t->is_admin = 1;

    printf("stale pointer sees: user=%s is_admin=%d\n", s->user, s->is_admin);
    free(t);
    return 0;
}
```

```console
$ gcc -O0 -g session.c -o session_gcc 2>/dev/null
$ ./session_gcc
stale pointer sees: user=root is_admin=1
$ clang -O1 -g -fsanitize=address session.c -o session_asan
$ ./session_asan; echo "exit=$?"
=================================================================
==490351==ERROR: AddressSanitizer: heap-use-after-free on address 0x7b6d9ede0050 at pc 0x55b9421cb85e bp 0x7ffd60c81f40 sp 0x7ffd60c81f38
READ of size 4 at 0x7b6d9ede0050 thread T0
    #0 0x55b9421cb85d in main /workspace/scratch/memsafe/session.c:18:69
    #1 0x7f3d9fc71ca7 in __libc_start_call_main csu/../sysdeps/nptl/libc_start_call_main.h:58:16
    #2 0x7f3d9fc71d64 in __libc_start_main csu/../csu/libc-start.c:360:3
...
$ $FILC/build/bin/clang -O2 -g session.c -o session_fil
$ ./session_fil; echo "exit=$?"
filc safety error: cannot access pointer to free object.
    pointer: 0x7fbd53d10550,0x7fbd53d10550,0x7fbd53d10550,free
    expected valid capability.
semantic origin:
    (session_fil) session.c:18:69: main
check scheduled at:
    (session_fil) session.c:14:25: main
    (libc.so) src/env/__libc_start_main.c:79:7: __libc_start_main
    (libpizlo.so) <runtime>: start_program
[490394] filc panic: thwarted a futile attempt to violate memory safety.
Trace/breakpoint trap
exit=133
```

The plain build (`-O0`, so the transcript is stable) shows the exploit shape. glibc handed the freed chunk straight to the next `malloc` of the same size, so the stale pointer now sees `root` with `is_admin=1`. With `-O2 -Wall`, GCC warns `pointer 's' used after 'free'`, and the program prints whatever the allocator left in the chunk, which is different on every run. ASan caught it because the freed chunk was still in quarantine. With enough allocation churn in between, ASan's quarantine recycles too.

Fil-C's report reads `pointer to free object`. Freeing an object sets its capability's upper bound to its lower bound, so every later access through any old pointer panics deterministically. The memory is reclaimed by the garbage collector once nothing points to it, which means a dangling pointer can never see another object's data.

### Case 3: teach the compiler how long an array is

A flexible array member (`data[]`) is the classic place where the compiler loses track of a size. `counted_by` tells it which field holds the count:

```c
// packet.c — a flexible array member that knows its own length
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#if defined(__has_attribute)
#  if __has_attribute(counted_by)
#    define COUNTED_BY(n) __attribute__((counted_by(n)))
#  endif
#endif
#ifndef COUNTED_BY
#  define COUNTED_BY(n)
#endif

struct packet {
    size_t len;
    unsigned char data[] COUNTED_BY(len);
};

[[gnu::noinline]] static size_t room(struct packet *p) {
    return __builtin_dynamic_object_size(p->data, 1);
}

[[gnu::noinline]] static void fill(struct packet *p, size_t last) {
    for (size_t i = 0; i <= last; i++)
        p->data[i] = (unsigned char)i;
}

[[gnu::noinline]] static void copy_in(struct packet *p, const void *src, size_t n) {
    memcpy(p->data, src, n);
}

int main(int argc, char **argv) {
    const char *mode = argc > 1 ? argv[1] : "room";
    struct packet *p = calloc(1, sizeof *p + 16);
    if (!p) return 1;

    if (!strcmp(mode, "late")) {           /* write first, set the count after */
        fill(p, 15);
        p->len = 16;
        puts("late: returned");
        free(p);
        return 0;
    }

    p->len = 16;                           /* count before any use of data[] */
    if (!strcmp(mode, "room")) {
        size_t r = room(p);
        if (r == (size_t)-1) puts("room(p) = unknown");
        else                 printf("room(p) = %zu\n", r);
    } else if (!strcmp(mode, "fill")) {
        fill(p, p->len);                   /* off by one: last valid is len-1 */
        puts("fill: returned");
    } else if (!strcmp(mode, "copy")) {
        char src[32] = {0};
        copy_in(p, src, sizeof src);       /* 32 bytes into 16 */
        puts("copy: returned");
    }
    free(p);
    return 0;
}
```

```console
$ gcc -std=c2x -O2 -g -fsanitize=bounds packet.c -o packet_gcc
$ clang -std=c23 -O2 -g -fsanitize=bounds packet.c -o packet_clang
$ ./packet_gcc room; ./packet_clang room
room(p) = unknown
room(p) = 16
$ ./packet_gcc fill
fill: returned
$ ./packet_clang fill
packet.c:26:12: runtime error: index 16 out of bounds for type 'unsigned char[] __counted_by(len)' (aka 'unsigned char[]')
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior packet.c:26:12 
fill: returned
$ clang -std=c23 -O2 -g -fsanitize=bounds -fsanitize-trap=bounds packet.c -o packet_trap
$ ./packet_trap fill; echo "exit=$?"
Illegal instruction
exit=132
```

- `room(p)` is `__builtin_dynamic_object_size(p->data, 1)` inside a non-inlined function. Clang reads `p->len` and answers `16`. GCC 14 doesn't know the attribute, so the `COUNTED_BY` macro expands to nothing and the answer is "unknown".
- With `-fsanitize=bounds`, Clang checks every `p->data[i]` against `p->len` and reports the off-by-one at `index 16`. GCC 14 can't, because it has nothing to compare against.
- By default UBSan reports and **continues** (`fill: returned`). For hardening rather than diagnosis, add `-fsanitize-trap=bounds`. The check then compiles to a trap instruction with no runtime library, and the process dies with `SIGILL` (exit 132) at the bad write.

The `#if __has_attribute(counted_by)` guard is the portable pattern. The annotation documents the invariant on every compiler and enforces it on the ones that understand it.

### Case 4: what Fil-C asks you to change

Fil-C is meant to be "fanatically compatible", and most code builds unchanged. The idiom it breaks on purpose is turning a pointer into an integer and back, because the capability can't survive the trip through an integer stored in memory:

```c
// handles.c — hand out integer handles for objects, the way many C APIs do
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if defined(__FILC__) && !defined(RAW_CAST)
#include <stdfil.h>
static zexact_ptrtable *table;
static uintptr_t to_handle(void *p)       { return zexact_ptrtable_encode(table, p); }
static void     *from_handle(uintptr_t h) { return zexact_ptrtable_decode(table, h); }
static void      handles_init(void)       { table = zexact_ptrtable_new(); }
#else
static uintptr_t to_handle(void *p)       { return (uintptr_t)p; }
static void     *from_handle(uintptr_t h) { return (void *)h; }
static void      handles_init(void)       { }
#endif

struct widget { int id; };

[[gnu::noinline]] static uintptr_t widget_open(int id) {
    struct widget *w = malloc(sizeof *w);
    w->id = id;
    return to_handle(w);
}

[[gnu::noinline]] static int widget_id(uintptr_t h) {
    struct widget *w = from_handle(h);
    return w->id;
}

int main(void) {
    handles_init();
    uintptr_t h = widget_open(7);
    printf("widget id %d\n", widget_id(h));
    return 0;
}
```

```console
$ gcc -std=c2x -O2 -g -Wall handles.c -o handles_gcc && ./handles_gcc
widget id 7
$ $FILC/build/bin/clang -std=c2x -O2 -g -Wall -DRAW_CAST handles.c -o handles_raw
$ ./handles_raw; echo "exit=$?"
filc safety error: cannot read pointer with null object.
    pointer: 0x7f58043042d0,<null>
    expected 4 bytes.
semantic origin:
    (handles_raw) handles.c:28:15: widget_id
check scheduled at:
    (handles_raw) handles.c:28:15: widget_id
    (handles_raw) handles.c:34:30: main
    (libc.so) src/env/__libc_start_main.c:79:7: __libc_start_main
    (libpizlo.so) <runtime>: start_program
[490466] filc panic: thwarted a futile attempt to violate memory safety.
Trace/breakpoint trap
exit=133
$ $FILC/build/bin/clang -std=c2x -O2 -g -Wall handles.c -o handles_fil && ./handles_fil
widget id 7
```

`(void *)h` produces the right address with a **null** capability, so the first dereference panics. The fix is to keep an explicit table, and `<stdfil.h>` ships one. `zexact_ptrtable_encode` returns exactly the pointer's integer value, so handles look the same as before, and `decode` gives the capability back. A decoded handle to a freed object still has a null capability, so stale handles stay caught.

Small cases like this can mislead. When the integer never leaves a register, the optimizer folds `(int *)(uintptr_t)p` back into `p` and the raw cast happens to work at `-O2`. It's the trip through memory, a struct field or a hash table, that loses the capability. Test the real code path, not a toy.

### Case 5: what it costs

```c
// bench2.c — two small CPU-bound kernels: array sort and a pointer tree
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

static unsigned long long rng = 88172645463325252ULL;
static int next_rand(void) {                          /* xorshift64: same stream on every libc */
    rng ^= rng << 13; rng ^= rng >> 7; rng ^= rng << 17;
    return (int)(rng >> 33);
}

static double ms_since(struct timespec a) {
    struct timespec b; clock_gettime(CLOCK_MONOTONIC, &b);
    return (b.tv_sec - a.tv_sec) * 1e3 + (b.tv_nsec - a.tv_nsec) / 1e6;
}

static void sort(int *v, long lo, long hi) {          /* plain quicksort */
    while (lo < hi) {
        int p = v[(lo + hi) / 2]; long i = lo, j = hi;
        while (i <= j) {
            while (v[i] < p) i++;
            while (v[j] > p) j--;
            if (i <= j) { int t = v[i]; v[i] = v[j]; v[j] = t; i++; j--; }
        }
        if (j - lo < hi - i) { sort(v, lo, j); lo = i; } else { sort(v, i, hi); hi = j; }
    }
}

struct tnode { struct tnode *l, *r; int key; };

static void free_tree(struct tnode *t) {
    if (!t) return;
    free_tree(t->l); free_tree(t->r); free(t);
}

static struct tnode *insert(struct tnode *t, int key) {
    struct tnode **slot = &t, *root = t;
    while (*slot) slot = key < (*slot)->key ? &(*slot)->l : &(*slot)->r;
    *slot = calloc(1, sizeof **slot);
    (*slot)->key = key;
    return root ? root : *slot;
}

int main(void) {
    enum { N = 1 << 20, TN = 1 << 18, LOOKUPS = 1 << 22 };
    int *v = malloc(N * sizeof *v);
    for (long i = 0; i < N; i++) v[i] = next_rand();
    struct timespec t0; clock_gettime(CLOCK_MONOTONIC, &t0);
    for (int r = 0; r < 5; r++) { for (long i = 0; i < N; i++) v[i] ^= next_rand(); sort(v, 0, N - 1); }
    double sort_ms = ms_since(t0);

    struct tnode *root = NULL;
    for (int i = 0; i < TN; i++) root = insert(root, next_rand());
    clock_gettime(CLOCK_MONOTONIC, &t0);
    long hits = 0;
    for (int i = 0; i < LOOKUPS; i++) {
        int k = next_rand();
        for (struct tnode *n = root; n; n = k < n->key ? n->l : n->r)
            if (n->key == k) { hits++; break; }
    }
    double tree_ms = ms_since(t0);
    printf("sort: %.0f ms   tree: %.0f ms   (check %d %ld)\n", sort_ms, tree_ms, v[N / 2] & 1, hits);
    free_tree(root); free(v);
    return 0;
}
```

```console
$ clang -O2 bench2.c -o bench_clang
$ clang -O2 -fsanitize=address bench2.c -o bench_asan
$ $FILC/build/bin/clang -O2 bench2.c -o bench_fil
$ /usr/bin/time -f "maxrss=%M KiB wall=%e s" ./bench_clang
sort: 474 ms   tree: 1764 ms   (check 1 499)
maxrss=13888 KiB wall=2.32 s
$ /usr/bin/time -f "maxrss=%M KiB wall=%e s" ./bench_asan
sort: 529 ms   tree: 3335 ms   (check 1 499)
maxrss=26840 KiB wall=4.09 s
$ /usr/bin/time -f "maxrss=%M KiB wall=%e s" ./bench_fil
sort: 642 ms   tree: 3213 ms   (check 1 499)
maxrss=28208 KiB wall=4.04 s
```

The benchmark uses its own xorshift generator, so all three builds sort and search the same data even though Fil-C's musl `rand()` differs from glibc's (`check 1 499` matches). Across three runs each on this 8-core box, the numbers stayed within about 10%:

- **Array sort:** Fil-C ~1.3× the plain build.
- **Pointer-chasing tree lookups:** ~1.8×.
- **Peak memory:** ~2× for both ASan and Fil-C.

Fil-C's own write-up quotes "about 4x in the bad cases". Treat these numbers as one data point, not a budget, and measure your hot path.

## The trap

**Memory safety is about *objects*. Your bug might be about *fields*.** Overflow `name[8]` by four bytes so that it lands exactly on `is_admin`, inside the same 12-byte allocation:

```c
// field.c — the same bug, but the victim lives inside the same object
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct account {
    char name[8];
    int  is_admin;
};

int main(int argc, char **argv) {
    const char *who = argc > 1 ? argv[1] : "kim";
    struct account *a = calloc(1, sizeof *a);
    strcpy(a->name, who);                   /* overflows into is_admin */
    printf("name=%s is_admin=%d\n", a->name, a->is_admin);
    free(a);
    return 0;
}
```

```console
$ ./field_gcc 'kimberly!AA'
name=kimberly!AA is_admin=4276513
$ ./field_asan 'kimberly!AA'
name=kimberly!AA is_admin=4276513
$ ./field_fil 'kimberly!AA'
name=kimberly!AA is_admin=4276513
$ ./field_fortify 'kimberly!AA'; echo "exit=$?"
*** buffer overflow detected ***: terminated
Aborted
exit=134
```

ASan and Fil-C both let `is_admin` become `4276513`. The write never left the object, so neither has anything to object to. Only `_FORTIFY_SOURCE=3` caught it, because `strcpy` into `a->name` is checked with `__builtin_dynamic_object_size(a->name, 1)`, the size of the *member*. Fortify only covers the libc calls it wraps, though. A hand-written byte loop into `a->name` gets past fortify, ASan, and Fil-C alike. What does catch that loop is `-fsanitize=bounds`, because `name` has a declared size of 8 (`index 8 out of bounds for type 'char[8]'`).

Fil-C's bounds are also not byte-exact. Allocations are rounded up to the runtime's 16-byte minimum alignment (`stdfil.h` documents this as "may allocate slightly more than `count`"), so a 13-byte copy into `malloc(8)` passes:

```console
$ ./heap_fil 'kimberly!AAA'
tag=kimberly!AAA next=intact
$ ./heap_asan 'kimberly!AAA'
=================================================================
==491062==ERROR: AddressSanitizer: heap-buffer-overflow on address 0x7c039f9e0018 at pc 0x55b22e78fb15 bp 0x7ffe9345fa20 sp 0x7ffe9345f1d8
WRITE of size 13 at 0x7c039f9e0018 thread T0
...
```

That's still *memory-safe*, since no other object can be reached. But it means Fil-C is not a replacement for ASan as a bug finder.

`counted_by` has its own traps. The count is a promise you have to keep:

```console
$ ./packet_clang late
packet.c:26:12: runtime error: index 0 out of bounds for type 'unsigned char[] __counted_by(len)' (aka 'unsigned char[]')
SUMMARY: UndefinedBehaviorSanitizer: undefined-behavior packet.c:26:12 
late: returned
$ ./packet_clang copy; echo "exit=$?"
copy: returned
exit=0
$ $FILC/build/bin/clang -std=c2x -O2 -g packet.c -o packet_fil
$ ./packet_fil fill
fill: returned
$ ./packet_fil copy
filc safety error: cannot write 32 bytes when upper - ptr = 24 (destination ptr = 0x7f55ef104588,0x7f55ef104580,0x7f55ef1045a0).
    (libpizlo.so) <runtime>: memmove
    (packet_fil) packet.c:30:5: copy_in
...
```

- **Set the count first.** In `late` mode the array is filled while `len` is still `0` (from `calloc`), so the first, perfectly valid write is reported as `index 0 out of bounds`. Treat `p->len = n` as part of the allocation.
- **Indexing is checked. Bulk copies are not.** `memcpy` of 32 bytes into the 16-byte `data[]` ran to completion in the Clang build (`copy: returned`). `-fsanitize=bounds` instruments `p->data[i]`, not `memcpy`. Fil-C caught the same copy (`cannot write 32 bytes when upper - ptr = 24`) but not the one-byte `fill` overrun, which landed in the 16-byte rounding slack.

## The boring rule

> Keep ASan + UBSan in CI. They find the bugs. Hardening is a separate decision:
>
> - **Every compiler you ship with:** annotate every flexible array member with a `__has_attribute`-guarded `counted_by`, assign the count before the first element, and build release binaries with `-fsanitize=bounds -fsanitize-trap=bounds` plus `-D_FORTIFY_SOURCE=3`. The checks are cheap and need no runtime library.
> - **A process that parses hostile input and you can rebuild the whole stack:** build it with Fil-C. Budget about 2× memory and measure CPU, replace integer↔pointer round trips with `zexact_ptrtable`, and treat a Fil-C panic as a crash that would otherwise have been an exploit.
> - **Fields that guard security decisions** (`is_admin`, lengths, function pointers) should not sit right after a fixed-size buffer that string APIs write into. Neither Fil-C nor ASan sees overflows between fields.
> - **`-fbounds-safety`:** wait for upstream Clang to enable it, or use Apple's toolchain, before you plan around it.

## Try this

1. Replace `strcpy(a->name, who)` in `field.c` with a hand-written `for` loop that copies bytes until `'\0'`. Confirm that the `-D_FORTIFY_SOURCE=3` build no longer catches the overflow and the Clang `-fsanitize=bounds` build does. Then fix it with `snprintf(a->name, sizeof a->name, "%s", who)`.
2. Reorder `struct account` so that `is_admin` comes first. Which of the four builds now detects `'kimberly!AA'`, and why?
3. Clang 23 also accepts `counted_by` on **pointer** members. Write `struct buf { size_t cap; unsigned char *data COUNTED_BY(cap); };`, index one past `cap` under `-fsanitize=bounds`, and check which of your compilers report it.
4. In `bench2.c`, change `struct tnode` to hold a 64-byte key. Rerun all three builds and see how Fil-C's memory ratio moves when objects contain more data and fewer pointers.
5. Build `heap.c` with `$FILC/build/bin/clang` and run it under `strace -f`. Find where Fil-C's runtime sets up its heap and compare the syscalls to the glibc build.

## Sources

- Fil-C 0.686 release (2026-10-04), README and binaries: <https://github.com/pizlonator/fil-c/releases/tag/v0.686>
- Fil-C, *InvisiCaps: The Fil-C Capability Model* (integer→pointer gives a null capability; freed objects; "about 4x in the bad cases"): <https://fil-c.org/invisicaps>
- Fil-C `stdfil.h` (`zgc_alloc` minalign, `zptrtable`, `zexact_ptrtable`), in the release tarball at `pizfix/stdfil-include/stdfil.h`
- Clang, *`-fbounds-safety`: Enforcing bounds safety for C* (status note: "design document … not available for users yet"): <https://clang.llvm.org/docs/BoundsSafety.html>
- Clang attribute reference, `counted_by`: <https://clang.llvm.org/docs/AttributeReference.html#counted-by-counted-by-or-null-sized-by-sized-by-or-null>
- GCC 15 release series changes (`counted_by` for flexible array members): <https://gcc.gnu.org/gcc-15/changes.html>
- GCC manual, common variable attributes (`counted_by`): <https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html>
- Clang UndefinedBehaviorSanitizer (`-fsanitize=bounds`, `-fsanitize-trap`): <https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html>
- glibc manual, Source Fortification (`_FORTIFY_SOURCE=3`): <https://sourceware.org/glibc/manual/latest/html_node/Source-Fortification.html>
