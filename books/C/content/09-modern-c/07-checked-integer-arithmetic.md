# Checked Integer Arithmetic with C23 `<stdckdint.h>`

## Thesis

Integer overflow is the quiet bug behind undersized buffers, negative lengths, and "impossible" branches that the optimizer deletes. For decades the portable C answer was hand-written pre-checks (`if (a > INT_MAX - b)`), which are easy to get wrong for mixed signedness and nearly impossible to get right for 64-bit multiplication. C23 (ISO/IEC 9899:2024, §7.20) standardises the fix: three type-generic macros in `<stdckdint.h>` —

```c
bool ckd_add(type1 *result, type2 a, type3 b);
bool ckd_sub(type1 *result, type2 a, type3 b);
bool ckd_mul(type1 *result, type2 a, type3 b);
```

Each computes the **mathematically exact** result, stores it (wrapped) in `*result`, and returns **`true` if it did not fit**. GCC 14 and Clang 18 ship the header and compile each call to an add/multiply plus a branch on the CPU's overflow or carry flag. There is no longer a reason to write overflow checks by hand in new code.

The boring operator habit: **every size, offset, or count that comes from outside the process passes through a `ckd_*` call (or an allocator that checks for you) before it reaches `malloc`, `memcpy`, or an array index.**

## Mental model

```text
          a (any integer type)      b (any integer type)
                    \                 /
                     ▼               ▼
           exact arithmetic in "infinite precision" — never UB
                              │
                              ▼
            convert to the type of *result   (the ONLY type that matters)
                              │
              ┌───────────────┴───────────────┐
         fits exactly                    does not fit
    *result = exact value            *result = value wrapped to width
     return false                     return true   ← treat as error
```

Three consequences follow:

1. **The result type defines "overflow".** `ckd_add(&r8, 100, 28)` overflows for `int8_t r8` but not for `int r8`. To ask "does this fit in 64 bits?", make `*result` 64 bits wide.
2. **Operand types and signedness do not matter.** `ckd_sub(&size, 3u, 5u)` correctly reports that `-2` does not fit in `size_t`; `ckd_mul(&u, -1, -1)` correctly reports that `1` fits in `unsigned`. No casts, no usual-arithmetic-conversion surprises.
3. **The stored value on overflow is a wrapped leftover.** It is well-defined (no UB), but it is not an answer. Return an error; do not keep computing with it.

| Approach | Signed safe? | Mixed signedness? | 64×64 multiply? | Standard? |
|----------|--------------|-------------------|-----------------|-----------|
| `a + b < a` after the fact | **No** — UB, optimizer may delete it | No | No | — |
| Pre-check `a > MAX - b` | Yes, if written perfectly | Painful | Painful (division) | Yes |
| Widen to `int64_t`, compare | Yes | Mostly | **No** (no portable 128-bit) | Yes |
| `__builtin_*_overflow` | Yes | Yes | Yes | GCC/Clang extension |
| C23 `ckd_*` | Yes | Yes | Yes | **ISO C23** |

## Worked examples

All listings were built and run on x86_64 Linux with GCC 14.2 (Debian 14.2.0-19), Clang 19.1.7, and glibc 2.41. Each listing produced identical output under both compilers unless noted.

### Case 1: the check the optimizer is allowed to delete

The classic after-the-fact test looks reasonable and is wrong for signed types: if `a + 100` overflows, behaviour is undefined, so the compiler may assume it never does — and `a + 100 < a` is then always false.

```c
/* naive.c — the overflow check that the optimizer is allowed to delete. */
#include <limits.h>
#include <stdio.h>

/* Intent: "would a + 100 overflow?"  Signed overflow is undefined, so the
   compiler may assume a + 100 never wraps and fold this to 0. */
__attribute__((noinline))
int would_overflow(int a) {
    return a + 100 < a;
}

int main(void) {
    printf("would_overflow(INT_MAX) = %d\n", would_overflow(INT_MAX));
    return 0;
}
```

```bash
for o in -O0 -O2; do gcc   -std=c23 $o naive.c -o naive && echo "gcc $o: $(./naive)"; done
for o in -O0 -O2; do clang -std=c23 $o naive.c -o naive && echo "clang $o: $(./naive)"; done
```

```text
gcc -O0: would_overflow(INT_MAX) = 0
gcc -O2: would_overflow(INT_MAX) = 0
clang -O0: would_overflow(INT_MAX) = 1
clang -O2: would_overflow(INT_MAX) = 0
```

Same source, three different "answers" to a yes/no question. GCC folds the comparison away even at `-O0`; the generated function is literally "return 0":

```bash
gcc -std=c23 -O2 -S -o - naive.c | sed -n '/would_overflow:/,/ret/p'
```

```text
would_overflow:
.LFB3:
	.cfi_startproc
	xorl	%eax, %eax
	ret
```

UBSan sees the overflow at run time, which is how you *find* such sites — but finding is not fixing:

```bash
gcc -std=c23 -O2 -fsanitize=undefined naive.c -o naive_ub && ./naive_ub
```

```text
naive.c:9:14: runtime error: signed integer overflow: 2147483647 + 100 cannot be represented in type 'int'
would_overflow(INT_MAX) = 1
```

The fix is one line: `int r; return ckd_add(&r, a, 100);`.

### Case 2: what the macros actually report

This listing pins down the semantics in the mental model: result type decides, signedness of operands is irrelevant, and the stored value on overflow is the wrapped leftover.

```c
/* basics.c — what ckd_add / ckd_sub / ckd_mul actually report. */
#include <limits.h>
#include <stdckdint.h>
#include <stdint.h>
#include <stdio.h>

int main(void) {
    int i;
    bool ov = ckd_add(&i, INT_MAX, 1);
    printf("INT_MAX + 1      -> int      ov=%d stored=%d\n", ov, i);

    /* Operands are evaluated as if in infinite precision; only the
       *result* type decides whether it "fits". */
    size_t n;
    ov = ckd_sub(&n, (size_t)3, (size_t)5);
    printf("3 - 5            -> size_t   ov=%d stored=%zu\n", ov, n);

    int8_t small;
    ov = ckd_add(&small, 100, 27);
    printf("100 + 27         -> int8_t   ov=%d stored=%d\n", ov, small);
    ov = ckd_add(&small, 100, 28);
    printf("100 + 28         -> int8_t   ov=%d stored=%d\n", ov, small);

    /* Mixed signedness is fine: -1 * -1 == 1 fits in unsigned. */
    unsigned u;
    ov = ckd_mul(&u, -1, -1);
    printf("-1 * -1          -> unsigned ov=%d stored=%u\n", ov, u);
    ov = ckd_mul(&u, -1, 1);
    printf("-1 * 1           -> unsigned ov=%d stored=%u\n", ov, u);

    /* Widening the result type is how you ask "does it fit in 64 bits?" */
    long long wide;
    ov = ckd_mul(&wide, INT_MAX, INT_MAX);
    printf("INT_MAX*INT_MAX  -> llong    ov=%d stored=%lld\n", ov, wide);
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -O2 basics.c -o basics && ./basics
```

```text
INT_MAX + 1      -> int      ov=1 stored=-2147483648
3 - 5            -> size_t   ov=1 stored=18446744073709551614
100 + 27         -> int8_t   ov=0 stored=127
100 + 28         -> int8_t   ov=1 stored=-128
-1 * -1          -> unsigned ov=0 stored=1
-1 * 1           -> unsigned ov=1 stored=4294967295
INT_MAX*INT_MAX  -> llong    ov=0 stored=4611686014132420609
```

`bool` is a keyword in C23, so no `<stdbool.h>` is needed. Clang 19 (`clang -std=c23 …`) prints byte-identical output.

### Case 3: sizing an allocation from an untrusted count

This is where overflow becomes a memory-safety bug. A count read from a file header, a network packet, or `argv` is multiplied by an element size and added to a header size. With a large enough count the product wraps to something tiny, `malloc` succeeds, and the subsequent loop writes far past the end.

```c
/* alloc.c — sizing a buffer from an untrusted element count. */
#define _DEFAULT_SOURCE   /* -std=c23 is strict ISO; this exposes reallocarray() */
#include <errno.h>
#include <stdckdint.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct record { uint32_t id; uint32_t flags; };   /* 8 bytes */
struct table  { size_t count; size_t cap; struct record rows[]; };

/* Publishing each pointer through a volatile stops the optimizer from
   deleting an unused malloc/free pair and assuming it "succeeded". */
static void *volatile sink;

/* WRONG: the multiplication silently wraps for huge counts. */
static size_t naive_size(size_t count) {
    return sizeof(struct table) + count * sizeof(struct record);
}

/* RIGHT: every step that can overflow is checked; false means "fits". */
static bool checked_size(size_t count, size_t *out) {
    size_t body;
    if (ckd_mul(&body, count, sizeof(struct record))) return false;
    if (ckd_add(out, body, sizeof(struct table)))     return false;
    return true;
}

static struct table *table_new(size_t count) {
    size_t bytes;
    if (!checked_size(count, &bytes)) { errno = EOVERFLOW; return NULL; }
    struct table *t = malloc(bytes);
    if (t) { t->count = 0; t->cap = count; }
    return t;
}

int main(int argc, char **argv) {
    if (argc != 2) { fprintf(stderr, "usage: %s COUNT\n", argv[0]); return 2; }
    size_t count = strtoull(argv[1], NULL, 0);

    printf("count        = %zu\n", count);
    printf("naive bytes  = %zu\n", naive_size(count));

    size_t bytes;
    if (checked_size(count, &bytes))
        printf("checked      = %zu\n", bytes);
    else
        printf("checked      = overflow, refusing\n");

    struct table *t = sink = table_new(count);
    printf("table_new    = %s (%s)\n", t ? "ok" : "NULL", t ? "-" : strerror(errno));
    free(sink);

    /* The library already checks n * size for you in these two calls. */
    void *p = sink = calloc(count, sizeof(struct record));
    printf("calloc       = %s\n", p ? "ok" : "NULL");
    free(sink);
    p = sink = reallocarray(NULL, count, sizeof(struct record));
    printf("reallocarray = %s\n", p ? "ok" : "NULL");
    free(sink);
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -O2 alloc.c -o alloc
./alloc 1000
./alloc 0x2000000000000001
```

```text
count        = 1000
naive bytes  = 8016
checked      = 8016
table_new    = ok (-)
calloc       = ok
reallocarray = ok

count        = 2305843009213693953
naive bytes  = 24
checked      = overflow, refusing
table_new    = NULL (Value too large for defined data type)
calloc       = NULL
reallocarray = NULL
```

The hostile count is `2^61 + 1`. Times 8 bytes it is `2^64 + 8`, which wraps to `8`; plus the 16-byte header gives a **24-byte** buffer for "two quintillion" records. The checked version refuses before calling `malloc`.

Two library calls already do the `n × size` check internally and are the first thing to reach for:

- `calloc(n, size)` — ISO C; zero-fills, returns `NULL` on overflow.
- `reallocarray(ptr, n, size)` — originally OpenBSD, in glibc since 2.26, standardised by **POSIX.1-2024**; behaves like `realloc(ptr, n * size)` but fails with `ENOMEM` when the multiplication overflows. Under strict `-std=c23`, glibc 2.41 declares it only when you request extensions with `_DEFAULT_SOURCE` (as the listing does); `_POSIX_C_SOURCE 202405L` alone is not enough there.

Why the `volatile sink`? Without it, Clang 19 at `-O2` deleted the unused `calloc`/`free` pair and printed `calloc = ok` for the hostile count — the optimizer may assume an allocation whose result is never used succeeded. A probe that is optimised away proves nothing; publish the pointer somewhere the compiler cannot see through. (The listing also avoids printing `errno` after `calloc`: ISO C does not require allocators to set it, and LLVM does not model it as changed by the call.)

Neither covers the `+ sizeof(struct table)` header term, which is why `checked_size` uses `ckd_mul` *and* `ckd_add`.

### Case 4: parsing a bounded number digit by digit

Parsers are the other hot spot. Accumulating `v = v * 10 + digit` into the destination type and checking at each step rejects oversized input exactly at the digit that breaks the bound — no `strtoul` range dance, no `errno`, no locale.

```c
/* parse.c — parse a decimal port/length field without trusting its size. */
#include <stdckdint.h>
#include <stdint.h>
#include <stdio.h>

/* Returns true on success. Rejects empty input, non-digits, and any value
   that does not fit in uint16_t — checked at every digit, not at the end. */
static bool parse_u16(const char *s, uint16_t *out) {
    uint16_t v = 0;
    if (*s == '\0') return false;
    for (; *s; s++) {
        if (*s < '0' || *s > '9') return false;
        if (ckd_mul(&v, v, 10))      return false;
        if (ckd_add(&v, v, *s - '0')) return false;
    }
    *out = v;
    return true;
}

int main(void) {
    const char *inputs[] = { "8443", "65535", "65536", "99999999999999999999", "12a", "" };
    for (size_t i = 0; i < sizeof inputs / sizeof inputs[0]; i++) {
        uint16_t port;
        if (parse_u16(inputs[i], &port))
            printf("%-22s -> %u\n", inputs[i], port);
        else
            printf("%-22s -> rejected\n", inputs[i]);
    }
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -Wconversion -O2 parse.c -o parse && ./parse
```

```text
8443                   -> 8443
65535                  -> 65535
65536                  -> rejected
99999999999999999999   -> rejected
12a                    -> rejected
                       -> rejected
```

Note that `-Wconversion` is silent: `ckd_add(&v, v, *s - '0')` adds an `int` to a `uint16_t` and stores into `uint16_t` without any implicit narrowing — the narrowing is exactly what the macro checks.

### Case 5: one header for C23 and older toolchains

`<stdckdint.h>` is a header shipped by the **compiler** (GCC ≥ 14, Clang ≥ 18), not by libc. Both GCC 14 and Clang 19 accept it even in `-std=c17` or older modes. For older compilers, map the macros onto the GCC/Clang builtins they are defined in terms of — and mind the **argument order**: the builtins put the result pointer *last*.

```c
/* ckd_compat.h — use C23 <stdckdint.h> when present, else the GCC/Clang
   builtins it is defined in terms of. Note the argument order swap. */
#ifndef CKD_COMPAT_H
#define CKD_COMPAT_H

#if defined(__has_include) && !defined(CKD_FORCE_BUILTIN)
#  if __has_include(<stdckdint.h>)
#    include <stdckdint.h>
#    define CKD_IMPL "stdckdint.h"
#  endif
#endif

#ifndef CKD_IMPL
#  if defined(__GNUC__) || defined(__clang__)
     /* builtins: (a, b, result)   ckd_*: (result, a, b) */
#    define ckd_add(r, a, b) __builtin_add_overflow((a), (b), (r))
#    define ckd_sub(r, a, b) __builtin_sub_overflow((a), (b), (r))
#    define ckd_mul(r, a, b) __builtin_mul_overflow((a), (b), (r))
#    define CKD_IMPL "__builtin_*_overflow"
#  else
#    error "no checked-arithmetic support: need C23 <stdckdint.h> or GCC/Clang builtins"
#  endif
#endif

#endif /* CKD_COMPAT_H */
```

```c
/* compat.c — same call sites, either implementation. */
#include <limits.h>
#include <stdio.h>
#include "ckd_compat.h"

int main(void) {
    long r;
    int ov = ckd_mul(&r, LONG_MAX / 2, 3);
    printf("impl=%s  ov=%d\n", CKD_IMPL, ov);
    return 0;
}
```

```bash
gcc   -std=c17 -Wall -Wextra                     compat.c -o compat && ./compat
gcc   -std=c17 -Wall -Wextra -DCKD_FORCE_BUILTIN compat.c -o compat && ./compat
clang -std=c11 -Wall -Wextra -DCKD_FORCE_BUILTIN compat.c -o compat && ./compat
```

```text
impl=stdckdint.h  ov=1
impl=__builtin_*_overflow  ov=1
impl=__builtin_*_overflow  ov=1
```

Call sites use the C23 spelling everywhere; deleting the shim later is a one-line change.

## The trap

**Habits from the builtins, and trusting the leftover value.** The compilers reject the worst mistakes, but not uniformly:

```c
/* misuse.c — mistakes the compiler rejects. */
#include <stdckdint.h>

int main(void) {
    int  a = 1, b = 2, r;
    bool flag;
    char c;
    (void)ckd_add(&flag, a, b);   /* bool result: not allowed      */
    (void)ckd_add(&c, a, b);      /* plain char result: not allowed */
    (void)ckd_add(a, b, &r);      /* builtin argument order by habit */
    return r;
}
```

```bash
clang -std=c23 -c misuse.c -o /dev/null
```

```text
misuse.c:8:11: error: result argument to checked integer operation must be a pointer to a non-const integer type other than plain 'char', 'bool', bit-precise, or an enumeration ('bool *' invalid)
    8 |     (void)ckd_add(&flag, a, b);   /* bool result: not allowed      */
      |           ^~~~~~~~~~~~~~~~~~~~
/usr/lib/llvm-19/lib/clang/19/include/stdckdint.h:37:59: note: expanded from macro 'ckd_add'
   37 | #define ckd_add(R, A, B) __builtin_add_overflow((A), (B), (R))
      |                                                           ^~~
misuse.c:9:11: error: result argument to checked integer operation must be a pointer to a non-const integer type other than plain 'char', 'bool', bit-precise, or an enumeration ('char *' invalid)
    9 |     (void)ckd_add(&c, a, b);      /* plain char result: not allowed */
      |           ^~~~~~~~~~~~~~~~~
/usr/lib/llvm-19/lib/clang/19/include/stdckdint.h:37:59: note: expanded from macro 'ckd_add'
   37 | #define ckd_add(R, A, B) __builtin_add_overflow((A), (B), (R))
      |                                                           ^~~
misuse.c:10:11: error: operand argument to checked integer operation must be an integer type other than plain 'char', 'bool', bit-precise, or an enumeration ('int *' invalid)
   10 |     (void)ckd_add(a, b, &r);      /* builtin argument order by habit */
      |           ^~~~~~~~~~~~~~~~~
/usr/lib/llvm-19/lib/clang/19/include/stdckdint.h:37:54: note: expanded from macro 'ckd_add'
   37 | #define ckd_add(R, A, B) __builtin_add_overflow((A), (B), (R))
      |                                                      ^~~
3 errors generated.
```

```bash
gcc -std=c23 -c misuse.c -o /dev/null
```

```text
misuse.c: In function ‘main’:
misuse.c:8:11: error: argument 3 in call to function ‘__builtin_add_overflow’ has pointer to boolean type
    8 |     (void)ckd_add(&flag, a, b);   /* bool result: not allowed      */
      |           ^~~~~~~
misuse.c:10:11: error: argument 2 in call to function ‘__builtin_add_overflow’ does not have integral type
   10 |     (void)ckd_add(a, b, &r);      /* builtin argument order by habit */
      |           ^~~~~~~
```

GCC 14 silently accepts the plain-`char` result (the standard only *recommends* a diagnostic) — so code that builds with GCC can fail on Clang. Beyond what the compilers catch:

- **Ignoring the return value.** `ckd_add(&n, n, len);` with no `if` is just addition with extra steps. Wrap it: `if (ckd_add(&n, n, len)) return -EOVERFLOW;`.
- **Using `*result` after overflow.** It is the truncated bit pattern (`24` bytes in Case 3). Never pass it on.
- **Checking in the wrong type.** `int total; ckd_add(&total, a_size_t, b_size_t)` checks fit in `int`, which may be what you want for a protocol field, but is wrong if the next line passes `total` to `malloc`. Make `*result` the type of the *consumer*.
- **Checking one step of a multi-step expression.** `header + n * size` is two operations; both need checking (Case 3). So does every iteration of an accumulator (Case 4).
- **`_BitInt` and enums.** C23 excludes bit-precise integers, `bool`, plain `char`, and enumerations from `ckd_*` operands and results; convert to an ordinary integer type first.
- **`-fwrapv` as a fix.** It makes signed overflow wrap instead of being UB, so Case 1's comparison survives — but the program still computes a wrong, wrapped size. Wrapping is not detection.

## The boring rule

> Any arithmetic on a size, count, offset, length, or index that is influenced by input goes through `ckd_add` / `ckd_sub` / `ckd_mul` — with `*result` typed as whatever consumes the value — and an overflow return becomes an error path, never a value. Prefer `calloc` / `reallocarray` when the expression is exactly `n × size`. Run tests under `-fsanitize=undefined` to find the sites you missed.

Checklist for review:

1. No after-the-fact overflow tests (`a + b < a`) on signed types anywhere.
2. Every `malloc`/`realloc` argument that is not a constant is either a `ckd_*` result or replaced by `calloc`/`reallocarray`.
3. Every `ckd_*` call is the condition of an `if` (or its result is otherwise tested).
4. Parsers accumulate into the destination type with `ckd_mul` + `ckd_add` per digit.
5. Builds that must support pre-C23 compilers use one shim header (Case 5), not ad-hoc builtins sprinkled through the code.

## Try this

1. Suppose `table_new` in Case 3 used `naive_size` and allocated with `calloc(1, bytes)`. Would the overflow be caught? Explain why `calloc` only protects the multiplication it performs itself.
2. Extend `parse_u16` from Case 4 into a generic `parse_u64` and test it against `18446744073709551615` and `18446744073709551616`.
3. Write `bool checked_area(size_t w, size_t h, size_t bpp, size_t *out)` for an image decoder (`w × h × bpp` plus a 54-byte header) and feed it `w = h = 0x100000001`.
4. Compile Case 1 with `-fwrapv` under GCC and Clang at `-O2`. Does `would_overflow` now return 1? Is the program *correct* now, or merely deterministic?
5. Disassemble `checked_size` (`gcc -O2 -S alloc.c`) and find the `jc`/`jo`/`seto` (or `mul` + flag test) that implements the check. Count the instructions it costs.

## Sources

- ISO/IEC 9899:2024 (C23) §7.20 *Checked integer arithmetic* — summarised at [cppreference: `ckd_add`](https://en.cppreference.com/c/numeric/ckd_add) and [`ckd_mul`](https://en.cppreference.com/c/numeric/ckd_mul)
- [GCC manual — Integer Overflow Builtins](https://gcc.gnu.org/onlinedocs/gcc/Integer-Overflow-Builtins.html)
- [POSIX.1-2024 `reallocarray()`](https://pubs.opengroup.org/onlinepubs/9799919799.2024edition/functions/reallocarray.html) (Austin Group defect 1218); glibc 2.26 NEWS for its introduction
- [Clang review D157331 — Implement C23 `<stdckdint.h>`](https://reviews.llvm.org/D157331) (Clang 18)
