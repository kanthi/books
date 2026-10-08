---
title: "defer: Scope-Based Cleanup (TS 25755)"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# `defer`: Scope-Based Cleanup with TS 25755

## Thesis

Every C programmer has written the cleanup ladder: acquire a file, a buffer, a lock, and on each failure `goto` the label that releases exactly what has been acquired so far. It works, and the Linux kernel is built on it. It is also where leaks and double-frees live, because the release code sits far from the acquisition and every new resource means editing two places in the right order.

WG14 answered with a **Technical Specification**, ISO/IEC TS 25755, *"defer, a mechanism for general purpose, lexical scope-based undo"* (project editor JeanHeyd Meneide). It adds one statement:

```c
defer statement-or-block;      /* the keyword is _Defer; <stddefer.h> spells it defer */
```

The deferred block runs when control leaves the **enclosing block** for any reason the language can see: falling off the end, `return`, `break`, `continue`, or `goto` out of it. Multiple deferred blocks run in reverse order. Release now sits one line under acquisition, and the compiler, not you, maintains the ladder.

Where things stand in late 2026:

| Implementation | Status |
|----------------|--------|
| **Clang 22.1+** | Implemented (WG14 draft N3734) behind **`-fdefer-ts`**, C mode only. Clang 23.1.3, the current release, behaves the same and still marks the feature "subject to change". |
| **GCC** | Not in any release. The GCC 16 release notes (16.1/16.2) don't list it, and Debian's GCC 14.2 has no `<stddefer.h>`. Patches have been posted to gcc-patches. |
| **The TS itself** | WG14 finished the text in 2026 and sent it to ISO for publication. ISO's catalogue page still lists ISO/IEC TS 25755 as under development, so treat details as provisional. |

A TS is not part of C23. It is an optional extension that compilers may implement and that may later be folded into C2y. This chapter uses Clang 23 for `defer` and shows the portable fallback that works on today's GCC.

## Mental model

```text
{                                   ← block E opens
    A = acquire_a();
    defer release(A);               ← registered (not run)
    B = acquire_b();
    defer release(B);               ← registered (not run)
    ... return / break / goto out / end of block ...
}                                   ← leaving E: run release(B), then release(A)
```

| Rule | Consequence |
|------|-------------|
| Deferred blocks belong to the **enclosing block**, not the function | A `defer` inside a loop body runs at the end of *every iteration*. Go programmers, take note: Go's `defer` is function-scoped |
| They run **LIFO** | Release order is the reverse of acquisition order, which is almost always what you want |
| They read variables **when they run** | A deferred `printf("%d", n)` prints the value `n` has at scope exit, not at the `defer` line |
| `return expr;` evaluates `expr` **first**, then runs deferred blocks | A deferred block cannot change the function's return value |
| You may not jump **into** a defer's scope or **out of** a deferred block | `goto` past a `defer`, and `return`/`break`/`goto` inside a deferred block, are compile errors |
| `exit`, `abort`, `longjmp`, `_Exit`, signals do **not** run deferred blocks | `defer` is lexical. It is not a destructor and not a `finally` for the whole process |

## Worked examples

All listings were built and run on x86_64 Linux with **Clang 23.1.3** (LLVM release tarball) and Debian's **GCC 14.2.0**, glibc 2.41.

### Case 0: is it there?

```c
#include <stdio.h>
#include <stddefer.h>
int main(void) {
#ifdef __STDC_DEFER_TS25755__
    printf("__STDC_DEFER_TS25755__ = %d\n", __STDC_DEFER_TS25755__);
#else
    printf("no defer TS\n");
#endif
    {
        defer printf("deferred\n");
        printf("body\n");
    }
    return 0;
}
```

```bash
clang -std=c23 -fdefer-ts -Wall -Wextra probe.c -o probe && ./probe
clang -std=c23 probe.c -o probe
gcc -std=c23 -c probe.c
```

```
__STDC_DEFER_TS25755__ = 1
body
deferred
probe.c:10:9: error: use of undeclared identifier 'defer'
   10 |         defer printf("deferred\n");
      |         ^~~~~
1 error generated.
probe.c:2:10: fatal error: stddefer.h: No such file or directory
    2 | #include <stddefer.h>
      |          ^~~~~~~~~~
compilation terminated.
```

Without `-fdefer-ts`, Clang's `<stddefer.h>` defines nothing, because the header only maps `defer` to `_Defer` when `__STDC_DEFER_TS25755__` is set. GCC 14 has no header at all. The macro's value is `1` here: Clang provides only the `_Defer` keyword, and the lowercase spelling comes from the header.

### Case 1: when deferred blocks run

```c
/* order.c — when deferred blocks run: LIFO, per block, per loop iteration */
#include <stddefer.h>
#include <stdio.h>

static int step(const char *what, int v) {
    printf("  %s\n", what);
    return v;
}

static int answer(void) {
    int x = 1;
    defer { printf("  defer sees x=%d, sets it to 99\n", x); x = 99; }
    return step("return expression evaluated", x);
}

int main(void) {
    puts("1. LIFO within one block");
    {
        defer puts("  first registered, runs last");
        defer puts("  second registered, runs first");
        puts("  end of block body");
    }

    puts("2. block scope, not function scope");
    for (int i = 0; i < 3; i++) {
        defer printf("  cleanup for i=%d\n", i);
        if (i == 1)
            continue;               /* still runs the defer */
        printf("  body i=%d\n", i);
    }

    puts("3. the value is captured at exit, not at the defer statement");
    {
        int n = 1;
        defer printf("  deferred print sees n=%d\n", n);
        n = 42;
    }

    puts("4. return value is computed before deferred blocks run");
    printf("  answer() returned %d\n", answer());
    return 0;
}
```

```bash
clang -std=c23 -fdefer-ts -Wall -Wextra order.c -o order && ./order
```

```
1. LIFO within one block
  end of block body
  second registered, runs first
  first registered, runs last
2. block scope, not function scope
  body i=0
  cleanup for i=0
  cleanup for i=1
  body i=2
  cleanup for i=2
3. the value is captured at exit, not at the defer statement
  deferred print sees n=42
4. return value is computed before deferred blocks run
  return expression evaluated
  defer sees x=1, sets it to 99
  answer() returned 1
```

Section 2 shows the property that makes `defer` useful in loops: the `continue` at `i == 1` skipped the body's `printf`, but not the cleanup. Section 4 is the one that bites. Keep it in mind for Case 2.

### Case 2: replacing a cleanup ladder

The task: read up to `max` bytes from one file, upper-case them, and write them to another. There are three resources and five failure points. Here is the classic version:

```c
/* upcase_goto.c — classic C cleanup: one label per acquired resource */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

int upcase_file(const char *in_path, const char *out_path, size_t max) {
    int rc = -1;
    FILE *in = fopen(in_path, "rb");
    if (!in) { perror(in_path); goto out; }

    char *buf = malloc(max);
    if (!buf) { perror("malloc"); goto close_in; }

    FILE *out = fopen(out_path, "wb");
    if (!out) { perror(out_path); goto free_buf; }

    size_t n = fread(buf, 1, max, in);
    if (ferror(in)) { perror("fread"); goto close_out; }
    for (size_t i = 0; i < n; i++)
        buf[i] = (char)toupper((unsigned char)buf[i]);
    if (fwrite(buf, 1, n, out) != n) { perror("fwrite"); goto close_out; }
    rc = (int)n;

close_out:
    if (fclose(out) != 0 && rc >= 0) { perror("fclose"); rc = -1; }
free_buf:
    free(buf);
close_in:
    fclose(in);
out:
    return rc;
}

int main(int argc, char **argv) {
    if (argc != 3) { fprintf(stderr, "usage: %s IN OUT\n", argv[0]); return 2; }
    int n = upcase_file(argv[1], argv[2], 4096);
    printf("result: %d\n", n);
    return n < 0;
}
```

And a direct translation to `defer`:

```c
/* upcase_defer.c — the same function with TS 25755 defer */
#include <ctype.h>
#include <stddefer.h>
#include <stdio.h>
#include <stdlib.h>

int upcase_file(const char *in_path, const char *out_path, size_t max) {
    FILE *in = fopen(in_path, "rb");
    if (!in) { perror(in_path); return -1; }
    defer fclose(in);

    char *buf = malloc(max);
    if (!buf) { perror("malloc"); return -1; }
    defer free(buf);

    FILE *out = fopen(out_path, "wb");
    if (!out) { perror(out_path); return -1; }
    int rc = -1;
    defer {
        if (fclose(out) != 0 && rc >= 0) { perror("fclose"); rc = -1; }
    }

    size_t n = fread(buf, 1, max, in);
    if (ferror(in)) { perror("fread"); return -1; }
    for (size_t i = 0; i < n; i++)
        buf[i] = (char)toupper((unsigned char)buf[i]);
    if (fwrite(buf, 1, n, out) != n) { perror("fwrite"); return -1; }
    rc = (int)n;
    return rc;
}

int main(int argc, char **argv) {
    if (argc != 3) { fprintf(stderr, "usage: %s IN OUT\n", argv[0]); return 2; }
    int n = upcase_file(argv[1], argv[2], 4096);
    printf("result: %d\n", n);
    return n < 0;
}
```

Build both with AddressSanitizer (which includes LeakSanitizer on Linux), then run each against a good input, a missing input, an unwritable directory, and `/dev/full`. `/dev/full` accepts `fwrite` into stdio's buffer but fails when the buffer is flushed at `fclose`.

```bash
printf 'hello, defer\n' > in.txt
for v in goto defer; do
  clang -std=c23 -fdefer-ts -g -O1 -fsanitize=address -Wall -Wextra upcase_$v.c -o up_$v
  echo "== $v"
  ./up_$v in.txt out.txt; cat out.txt
  ./up_$v missing.txt out.txt; echo "exit=$?"
  ./up_$v in.txt /nonexistent/dir/out.txt; echo "exit=$?"
  ./up_$v in.txt /dev/full; echo "exit=$?"
done
```

```
== goto
result: 13
HELLO, DEFER
missing.txt: No such file or directory
result: -1
exit=1
/nonexistent/dir/out.txt: No such file or directory
result: -1
exit=1
fclose: No space left on device
result: -1
exit=1
== defer
result: 13
HELLO, DEFER
missing.txt: No such file or directory
result: -1
exit=1
/nonexistent/dir/out.txt: No such file or directory
result: -1
exit=1
fclose: No space left on device
result: 13
exit=0
```

No sanitizer reports, so both versions release everything on every path. The `defer` version is shorter and harder to get wrong when a fourth resource arrives. **But look at the last run.** The `defer` version printed the `fclose` error and then reported success. `return rc;` evaluated `rc` (13) before the deferred block ran, so setting `rc = -1` inside the deferred block changed a local that nobody would read again. The data was lost and the caller was told everything was fine.

### Case 3: release with `defer`, commit explicitly

The fix is a rule, not a trick. Use `defer` for releases whose failure you can't act on: `free`, closing a file you only read, unlocking. An operation whose failure *is* the result, such as closing or `fsync`ing a file you wrote, or `COMMIT`, goes on the success path explicitly. The deferred block only covers the error paths.

```c
/* upcase_defer_fixed.c — defer for release, an explicit close where the error matters */
#include <ctype.h>
#include <stdbool.h>
#include <stddefer.h>
#include <stdio.h>
#include <stdlib.h>

int upcase_file(const char *in_path, const char *out_path, size_t max) {
    FILE *in = fopen(in_path, "rb");
    if (!in) { perror(in_path); return -1; }
    defer fclose(in);                     /* read side: close errors don't matter */

    char *buf = malloc(max);
    if (!buf) { perror("malloc"); return -1; }
    defer free(buf);

    FILE *out = fopen(out_path, "wb");
    if (!out) { perror(out_path); return -1; }
    bool out_closed = false;
    defer { if (!out_closed) fclose(out); } /* error paths only */

    size_t n = fread(buf, 1, max, in);
    if (ferror(in)) { perror("fread"); return -1; }
    for (size_t i = 0; i < n; i++)
        buf[i] = (char)toupper((unsigned char)buf[i]);
    if (fwrite(buf, 1, n, out) != n) { perror("fwrite"); return -1; }

    out_closed = true;                    /* success path: the close is the commit */
    if (fclose(out) != 0) { perror("fclose"); return -1; }
    return (int)n;
}

int main(int argc, char **argv) {
    if (argc != 3) { fprintf(stderr, "usage: %s IN OUT\n", argv[0]); return 2; }
    int n = upcase_file(argv[1], argv[2], 4096);
    printf("result: %d\n", n);
    return n < 0;
}
```

```bash
clang -std=c23 -fdefer-ts -g -O1 -fsanitize=address -Wall -Wextra upcase_defer_fixed.c -o up_fixed
./up_fixed in.txt out.txt; echo "exit=$?"
./up_fixed missing.txt out.txt; echo "exit=$?"
./up_fixed in.txt /dev/full; echo "exit=$?"
```

```
result: 13
exit=0
missing.txt: No such file or directory
result: -1
exit=1
fclose: No space left on device
result: -1
exit=1
```

### Case 4: the same shape on today's GCC

Until GCC ships the TS, the portable way to get scope-bound cleanup is the `cleanup` variable attribute, which GCC and Clang have supported for many years. It attaches a function to a *variable*, not to a block of code, so you write one small helper per resource type. The "disarm, then close explicitly" pattern from Case 3 carries over unchanged.

```c
/* upcase_cleanup.c — pre-TS idiom: GCC/Clang __attribute__((cleanup)) */
#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>

static void close_file(FILE **f) { if (*f) fclose(*f); }
static void free_mem(char **p)    { free(*p); }

#define AUTO_FILE __attribute__((cleanup(close_file))) FILE *
#define AUTO_MEM  __attribute__((cleanup(free_mem))) char *

int upcase_file(const char *in_path, const char *out_path, size_t max) {
    AUTO_FILE in = fopen(in_path, "rb");
    if (!in) { perror(in_path); return -1; }

    AUTO_MEM buf = malloc(max);
    if (!buf) { perror("malloc"); return -1; }

    AUTO_FILE out = fopen(out_path, "wb");
    if (!out) { perror(out_path); return -1; }

    size_t n = fread(buf, 1, max, in);
    if (ferror(in)) { perror("fread"); return -1; }
    for (size_t i = 0; i < n; i++)
        buf[i] = (char)toupper((unsigned char)buf[i]);
    if (fwrite(buf, 1, n, out) != n) { perror("fwrite"); return -1; }

    FILE *o = out;
    out = NULL;                       /* disarm: we close it ourselves */
    if (fclose(o) != 0) { perror("fclose"); return -1; }
    return (int)n;
}

int main(int argc, char **argv) {
    if (argc != 3) { fprintf(stderr, "usage: %s IN OUT\n", argv[0]); return 2; }
    int n = upcase_file(argv[1], argv[2], 4096);
    printf("result: %d\n", n);
    return n < 0;
}
```

```bash
gcc -std=c23 -g -O1 -fsanitize=address -Wall -Wextra upcase_cleanup.c -o up_cleanup_gcc
./up_cleanup_gcc in.txt out.txt; echo "exit=$?"
./up_cleanup_gcc missing.txt out.txt; echo "exit=$?"
./up_cleanup_gcc in.txt /dev/full; echo "exit=$?"
clang -std=c23 -Wall -Wextra upcase_cleanup.c -o up_cleanup_clang && ./up_cleanup_clang in.txt out.txt
```

```
result: 13
exit=0
missing.txt: No such file or directory
result: -1
exit=1
fclose: No space left on device
result: -1
exit=1
result: 13
```

| | `goto` ladder | `__attribute__((cleanup))` | TS 25755 `defer` |
|-|---------------|----------------------------|------------------|
| Standard C | Yes | No (GNU extension) | Optional TS, Clang only today |
| Unit of cleanup | Label | Variable | Any statement or block |
| Arbitrary cleanup code (`unlock`, `printf`, `rollback`) | Yes | Only via a helper per type | Yes, inline |
| Runs on `continue`/`break` out of a loop body | Only if you wrote it | Yes | Yes |
| Can affect the return value | Yes | No | No |

## The trap

### Jumps the compiler rejects

```c
/* illegal.c — jumps the defer TS forbids */
#include <stddefer.h>
#include <stdio.h>
#include <stdlib.h>

int jump_past(int fail) {
    if (fail)
        goto done;                 /* jumps over the defer into its scope */
    char *p = malloc(16);
    defer free(p);
done:
    return 0;
}

int leave_from_defer(void) {
    defer {
        return 1;                  /* cannot leave a deferred block early */
    }
    return 0;
}
```

```bash
clang -std=c23 -fdefer-ts -c illegal.c
```

```
illegal.c:8:9: error: cannot jump from this goto statement to its label
    8 |         goto done;                 /* jumps over the defer into its scope */
      |         ^
illegal.c:10:5: note: jump bypasses defer statement
   10 |     defer free(p);
      |     ^
/opt/llvm-23/lib/clang/23/include/stddefer.h:16:15: note: expanded from macro 'defer'
   16 | #define defer _Defer
      |               ^
illegal.c:17:9: error: cannot return from a defer statement
   17 |         return 1;                  /* cannot leave a deferred block early */
      |         ^
2 errors generated.
```

Both are good errors. A `goto` that skips a `defer` would leave the compiler unsure whether to run it. A deferred block that returns would abandon the remaining cleanup. The fix for the first is usually to open a new block `{ … }` for the resource, so the label sits outside the defer's scope.

### Leaving without leaving the block

```c
/* exit_skips.c — exit() and longjmp leave without running deferred blocks */
#include <stddefer.h>
#include <stdio.h>
#include <stdlib.h>

static void work(int code) {
    defer puts("deferred cleanup ran");
    if (code)
        exit(code);
    puts("returning normally");
}

int main(int argc, char **argv) {
    (void)argv;
    work(argc > 1);
    return 0;
}
```

```bash
clang -std=c23 -fdefer-ts -Wall exit_skips.c -o exit_skips
./exit_skips; echo "exit=$?"
./exit_skips now; echo "exit=$?"
```

```
returning normally
deferred cleanup ran
exit=0
exit=1
```

`exit()` never returns to `work`, so the deferred `puts` never runs. The same is true of `abort`, `_Exit`, `longjmp` over the frame, and a fatal signal. Memory and file descriptors are reclaimed by the kernel anyway. A temporary file that should have been `unlink`ed, or a lock file, is not. Process-wide cleanup still belongs in `atexit` handlers or the caller.

### Mutating the result from a deferred block

Case 2's `/dev/full` run is the trap. A deferred block that assigns to the variable being returned looks like Go's named-result trick, but C has no named results. `return rc;` copies the value before the deferred blocks run. If a cleanup step can fail in a way the caller must hear about, it isn't cleanup. Do it explicitly on the success path (Case 3).

## The boring rule

> Put `defer release(x);` on the line right after `x` is acquired and checked. Use `defer` only for releases whose failure you can ignore: `free`, read-side `fclose`, unlocking, restoring a saved value. Writes are committed explicitly on the success path, with the deferred block covering only the error paths through a "done" flag. Remember that deferred blocks are per block (and per loop iteration) and are skipped by `exit` and `longjmp`. Gate the code on `__STDC_DEFER_TS25755__`, build it with `-fdefer-ts`, and keep a `cleanup`-attribute fallback while GCC catches up.

## Try this

1. Add a fourth resource to `upcase_goto.c` (say, a second output buffer) and count how many lines change. Do the same in `upcase_defer_fixed.c`.
2. Write a `with_lock(pthread_mutex_t *m)` pattern: `pthread_mutex_lock(m); defer pthread_mutex_unlock(m);` inside a loop that `continue`s on odd iterations, and prove with a counter that the mutex is unlocked every time.
3. Wrap Case 3 in a header that uses `defer` when `__STDC_DEFER_TS25755__` is defined and the `cleanup` attribute otherwise. Build it with both compilers.
4. Move the `defer free(buf);` *above* the `if (!buf)` check. Is `free(NULL)` on the failure path a bug? What about `defer fclose(in);` above `if (!in)`?
5. Replace `exit(code)` in `exit_skips.c` with a `longjmp` to a `setjmp` in `main` and confirm the deferred block is still skipped. Then read the TS's wording on `longjmp` and explain why the compiler can't help here.

## Sources

- WG14, ISO/IEC TS 25755 working draft N3928, *defer, a mechanism for general purpose, lexical scope-based undo* (ed. JeanHeyd Meneide): <https://thephd.dev/_vendor/future_cxx/technical%20specification/C%20-%20defer/C%20-%20defer%20Technical%20Specification.pdf>
- WG14 N3734 (the draft Clang implements): <https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3734.pdf>
- ISO catalogue entry, ISO/IEC TS 25755: <https://www.iso.org/standard/91402.html>
- Clang 22 release notes ("Implemented the `defer` draft Technical Specification … `-fdefer-ts`"): <https://releases.llvm.org/22.1.0/tools/clang/docs/ReleaseNotes.html>
- LLVM commit 71bfdd1, "[Clang] Add support for the C `_Defer` TS (#162848)": <https://github.com/llvm/llvm-project/commit/71bfdd130403>
- GCC 16 release series changes (no `defer` entry): <https://gcc.gnu.org/gcc-16/changes.html>
- GCC manual, `cleanup` variable attribute: <https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html>
