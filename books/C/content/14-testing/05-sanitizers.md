# Compiler Sanitizers (ASan, UBSan, TSan, MSan)

## Overview

Compiler sanitizers are **instrumented builds** that turn many classes of memory and concurrency bugs into **loud, early failures** instead of silent corruption. For operators and CI, the boring habit is: ship tests under **AddressSanitizer + UndefinedBehaviorSanitizer**, run a separate **ThreadSanitizer** job for threaded code, and treat **MemorySanitizer** as an advanced Clang-only gate when you can rebuild the whole dependency graph.

| Tool | Flag | Catches (high level) | Typical slowdown |
|------|------|----------------------|------------------|
| **ASan** (AddressSanitizer) | `-fsanitize=address` | Heap/stack/global OOB, use-after-free, double-free, some use-after-return/scope; leaks via integrated LSan on Linux | ~2× |
| **UBSan** (UndefinedBehaviorSanitizer) | `-fsanitize=undefined` | Signed overflow, null deref, misaligned access, invalid shifts, … | small |
| **TSan** (ThreadSanitizer) | `-fsanitize=thread` | Data races | ~5–15× |
| **MSan** (MemorySanitizer) | `-fsanitize=memory` | Use of uninitialized values (Clang) | ~3× |

**Hard rule:** ASan, TSan, and MSan are **mutually exclusive** in one binary. ASan + UBSan **can** be combined: `-fsanitize=address,undefined`.

Baseline compile line (GCC or Clang):

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fno-omit-frame-pointer \
  -fsanitize=address,undefined \
  -o prog prog.c
```

Use the compiler driver (`cc` / `gcc` / `clang`) for the **link** step so the sanitizer runtime is linked. Linking with bare `ld` usually fails or produces a binary that cannot report errors.

## Mental model

```text
source ──► instrumented object code ──► link sanitizer runtime
                │
                ▼
           run tests / binary
                │
         first real bug ──► stderr report + non-zero exit
```

Sanitizers are **bug detectors for test and debug builds**, not production hardening. Do not ship ASan-instrumented binaries to users expecting a security boundary — the runtime is not designed as a hardened sandbox.

---

## AddressSanitizer (ASan)

### Planted use-after-free

```c
/* file: asan_uaf.c */
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    int *p = malloc(sizeof *p);
    if (p == NULL) {
        return 1;
    }
    *p = 42;
    free(p);
    /* BOOM: use-after-free */
    printf("%d\n", *p);
    return 0;
}
```

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fno-omit-frame-pointer \
  -fsanitize=address -o asan_uaf asan_uaf.c
./asan_uaf
```

Expected shape of the report (exact addresses vary):

```text
==PID==ERROR: AddressSanitizer: heap-use-after-free on address …
READ of size 4 at … thread T0
    #0 … in main asan_uaf.c:…
…
freed by thread T0 here:
    #0 … in free …
    #1 … in main asan_uaf.c:…
previously allocated by thread T0 here:
    #0 … in malloc …
    #1 … in main asan_uaf.c:…
==PID==ABORTING
```

Read the report top-down: **error type**, **access**, **stack of the bad use**, then **who freed**, then **who allocated**.

### Heap buffer overflow

```c
/* file: asan_oob.c */
#include <stdlib.h>
#include <stdio.h>

int main(void) {
    int *a = malloc(4 * sizeof *a);
    if (a == NULL) {
        return 1;
    }
    for (int i = 0; i <= 4; i++) { /* last iteration is OOB */
        a[i] = i;
    }
    printf("%d\n", a[0]);
    free(a);
    return 0;
}
```

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fsanitize=address -o asan_oob asan_oob.c
./asan_oob
# Expect: heap-buffer-overflow
```

### Useful ASan runtime knobs

```bash
# List all options
ASAN_OPTIONS=help=1 ./asan_uaf

# Common CI defaults
ASAN_OPTIONS=detect_leaks=1:abort_on_error=1:halt_on_error=1 ./tests

# Symbolize with llvm-symbolizer when stacks are raw
ASAN_SYMBOLIZER_PATH="$(command -v llvm-symbolizer)" ./asan_uaf
```

On Linux, LeakSanitizer is integrated with ASan and often on by default. Suppress third-party leak noise with `LSAN_OPTIONS=suppressions=lsan.supp` rather than turning leaks off globally unless you have a documented reason.

---

## UndefinedBehaviorSanitizer (UBSan)

UBSan catches **language undefined behavior** that may not be a classic memory corruption yet still means the program is not trustworthy.

```c
/* file: ubsan_overflow.c */
#include <limits.h>
#include <stdio.h>

int main(void) {
    int x = INT_MAX;
    /* signed overflow is UB */
    int y = x + 1;
    printf("%d\n", y);
    return 0;
}
```

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fsanitize=undefined -o ubsan_overflow ubsan_overflow.c
./ubsan_overflow
# Expect a runtime diagnostic about signed integer overflow
```

Combine with ASan for day-to-day CI:

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fno-omit-frame-pointer \
  -fsanitize=address,undefined -o tests tests.c
```

Pass UBSan-specific knobs via `UBSAN_OPTIONS` (not packed into `ASAN_OPTIONS` when both runtimes are present).

---

## ThreadSanitizer (TSan)

TSan finds **data races**: unsynchronized concurrent access where at least one access is a write.

```c
/* file: tsan_race.c — needs -pthread */
#include <pthread.h>
#include <stdio.h>

static int counter;

static void *worker(void *arg) {
    (void)arg;
    for (int i = 0; i < 100000; i++) {
        counter++; /* race */
    }
    return NULL;
}

int main(void) {
    pthread_t a, b;
    pthread_create(&a, NULL, worker, NULL);
    pthread_create(&b, NULL, worker, NULL);
    pthread_join(a, NULL);
    pthread_join(b, NULL);
    printf("%d\n", counter);
    return 0;
}
```

```bash
cc -std=c17 -Wall -Wextra -g -O1 -fsanitize=thread -pthread -o tsan_race tsan_race.c
./tsan_race
# Expect: WARNING: ThreadSanitizer: data race
```

**Requirements:** compile **and** link with `-fsanitize=thread`. Prefer instrumenting **all** objects in the process; non-instrumented shared libraries can hide races or add noise. Runtime knobs live in `TSAN_OPTIONS` (for example `history_size=7` when stacks fail to restore).

Fix the race with a mutex, atomics, or by removing shared mutable state — then re-run until TSan is silent.

---

## MemorySanitizer (MSan) — brief

MSan (Clang) detects **uses of uninitialized memory**. It is stricter than ASan about “read before write.”

```bash
clang -std=c17 -Wall -Wextra -g -O1 -fno-omit-frame-pointer \
  -fsanitize=memory -fsanitize-memory-track-origins=2 \
  -o msan_demo msan_demo.c
```

**Operator constraints:**

- Instrument **every** dependency, including libc wrappers Clang ships for MSan — mixed instrumented/non-instrumented code produces false positives.
- Do not combine with ASan/TSan.
- Prefer a dedicated CI job on a known toolchain image, not a laptop one-off, until the rebuild story is solid.

If you cannot rebuild the world, stick to ASan+UBSan (+ Valgrind Memcheck for selected tests) and schedule MSan later.

---

## Interpreting reports (operator checklist)

1. **Reproduce with symbols:** `-g`, preferably `-O1`, `-fno-omit-frame-pointer`.
2. **Read the first error only** — ASan aborts on the first finding by design; fix it, then re-run.
3. **Map frames to your code** before blaming the standard library; library frames often sit above the real bug.
4. **Confirm it is your build:** wrong binary, stale `.o`, or a non-instrumented `dlopen` plugin are common false friends.
5. **One sanitizer family per job** in CI matrices (see below).

---

## CI gates (practical matrix)

| Job | Flags | Notes |
|-----|-------|-------|
| `asan-ubsan` | `-fsanitize=address,undefined` | Default PR gate for C tests |
| `tsan` | `-fsanitize=thread` | Only if the suite exercises threads |
| `msan` | `-fsanitize=memory` | Clang + fully instrumented deps |
| `release` | no sanitizers, `-O2`/`-O3` | Ship artifacts; do not mix |

Example Makefile fragment:

```make
CFLAGS_SAN = -std=c17 -Wall -Wextra -g -O1 -fno-omit-frame-pointer

test-asan: tests.c
	$(CC) $(CFLAGS_SAN) -fsanitize=address,undefined -o tests-asan tests.c
	ASAN_OPTIONS=detect_leaks=1:abort_on_error=1 ./tests-asan

test-tsan: tests_threaded.c
	$(CC) $(CFLAGS_SAN) -fsanitize=thread -pthread -o tests-tsan tests_threaded.c
	./tests-tsan
```

Fail the pipeline on **any** sanitizer abort. Do not “warn-only” ASan in CI — that trains the team to ignore red stacks.

---

## Common false friends

| Symptom / belief | Reality |
|------------------|---------|
| “ASan false positive” | ASan is not expected to false-positive on fully instrumented code; re-check lifetime and OOB logic |
| Combining ASan + TSan | Unsupported; use separate binaries/jobs |
| Sanitizer “fixes” the bug | It only **detects**; you still patch the code |
| Running ASan at `-O0` only | Works, but `-O1` is the documented sweet spot for speed + traces |
| Ignoring leaks because “process exits” | Still a bug signal in long-lived services and tests; triage with LSan suppressions carefully |
| Shipping ASan to production for “safety” | Wrong tool — use hardened allocators / privilege drop / fuzzing separately |
| TSan clean ⇒ no concurrency bugs | Deadlocks, logic races, and missed wakes can remain |
| UBSan silent at `-O2` without the flag | Without `-fsanitize=undefined`, the compiler may exploit UB |

Selective opt-out (rare): `__attribute__((no_sanitize("address")))` on a function, gated with `__has_feature(address_sanitizer)` / `__SANITIZE_ADDRESS__`. Prefer fixing the code; use ignorelists only for third-party pain you cannot rebuild yet.

---

## Try this

1. Build `asan_uaf.c` and `asan_oob.c`; save both reports and highlight the allocation/free stacks.
2. Add `-fsanitize=undefined` to a project that uses intentional unsigned wrap — confirm you did **not** enable unsigned overflow in the default `undefined` group unless you opted in.
3. Run `tsan_race.c`, then fix it with `pthread_mutex_t` and show a clean TSan run.
4. Wire `test-asan` into CI so a planted UAF fails the job.

## Sources

- [Clang AddressSanitizer](https://clang.llvm.org/docs/AddressSanitizer.html)
- [Clang UndefinedBehaviorSanitizer](https://clang.llvm.org/docs/UndefinedBehaviorSanitizer.html)
- [Clang ThreadSanitizer](https://clang.llvm.org/docs/ThreadSanitizer.html)
- [Clang MemorySanitizer](https://clang.llvm.org/docs/MemorySanitizer.html)
- [AddressSanitizer wiki (Google)](https://github.com/google/sanitizers/wiki/AddressSanitizer)
