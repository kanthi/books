# Fundamental Data Types

## Introduction

Data types define what values you can store, how much memory they use, which operations apply, and how the compiler interprets bits. In C, sizes of some types are **implementation-defined** (within standard minimums), so portable code measures with `sizeof` and uses limits headers or fixed-width types when exact width matters.

This chapter covers integer and floating types, `char` and `bool`, full `sizeof` / `limits.h` / `float.h` demos, signed overflow undefined behavior and safer patterns, and a strong emphasis on `stdint.h` fixed-width types—with full programs you can run on Linux.

**Compile convention:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
./program
```

## Basic Data Types in C

1. **Integer types** — whole numbers  
2. **Floating-point types** — real numbers  
3. **Character types** — `char` (integer family)  
4. **Boolean** — `_Bool` / `bool` (C99+)  

---

## Integer Types

### Typical Sizes (LP64 Linux, e.g. x86_64)

These are **common** on 64-bit Linux with GCC—not guarantees for every platform.

| Type | Size (typical) | Range (typical, signed) |
|------|----------------|-------------------------|
| `char` | 1 byte | −128..127 or 0..255 if unsigned `char` |
| `short` | 2 bytes | −32 768..32 767 |
| `int` | 4 bytes | −2 147 483 648..2 147 483 647 |
| `long` | 8 bytes (LP64) | full 64-bit signed range |
| `long long` | 8 bytes | full 64-bit signed range |

### Unsigned Variants

| Type | Typical max |
|------|-------------|
| `unsigned char` | 255 |
| `unsigned short` | 65 535 |
| `unsigned int` | 4 294 967 295 |
| `unsigned long` | 2⁶⁴−1 on LP64 |
| `unsigned long long` | 2⁶⁴−1 |

Unsigned arithmetic wraps modulo 2ⁿ (well-defined). Signed overflow is **not** well-defined (see below).

---

## Worked Demo: sizeof of Major Types

Run this on your machine and keep the output—it is your ABI cheatsheet.

```c
/* sizeof_tour.c */
#include <stdio.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdint.h>

int main(void) {
    printf("=== sizeof tour (this machine) ===\n");
    printf("char:          %zu\n", sizeof(char));
    printf("signed char:   %zu\n", sizeof(signed char));
    printf("unsigned char: %zu\n", sizeof(unsigned char));
    printf("short:         %zu\n", sizeof(short));
    printf("unsigned short:%zu\n", sizeof(unsigned short));
    printf("int:           %zu\n", sizeof(int));
    printf("unsigned int:  %zu\n", sizeof(unsigned int));
    printf("long:          %zu\n", sizeof(long));
    printf("unsigned long: %zu\n", sizeof(unsigned long));
    printf("long long:     %zu\n", sizeof(long long));
    printf("unsigned long long: %zu\n", sizeof(unsigned long long));
    printf("float:         %zu\n", sizeof(float));
    printf("double:        %zu\n", sizeof(double));
    printf("long double:   %zu\n", sizeof(long double));
    printf("bool / _Bool:  %zu\n", sizeof(bool));
    printf("void *:        %zu\n", sizeof(void *));
    printf("size_t:        %zu\n", sizeof(size_t));
    printf("ptrdiff_t:     %zu\n", sizeof(ptrdiff_t));
    printf("int8_t:        %zu\n", sizeof(int8_t));
    printf("int16_t:       %zu\n", sizeof(int16_t));
    printf("int32_t:       %zu\n", sizeof(int32_t));
    printf("int64_t:       %zu\n", sizeof(int64_t));
    printf("uint64_t:      %zu\n", sizeof(uint64_t));
    printf("intptr_t:      %zu\n", sizeof(intptr_t));
    printf("uintptr_t:     %zu\n", sizeof(uintptr_t));
    printf("intmax_t:      %zu\n", sizeof(intmax_t));

    int x = 0;
    printf("sizeof x:      %zu (parens optional for expressions)\n", sizeof x);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o sizeof_tour sizeof_tour.c
./sizeof_tour
```

**Sample-shaped output** on a typical x86_64 Linux GCC (yours may match):

```text
char: 1, short: 2, int: 4, long: 8, long long: 8
float: 4, double: 8, long double: 16
void *: 8
```

On 32-bit ILP32 Linux, `long` and pointers are often 4 bytes—another reason not to assume.

---

## Limits from `limits.h`

```c
/* limits_demo.c */
#include <stdio.h>
#include <limits.h>

int main(void) {
    printf("=== limits.h (signed) ===\n");
    printf("CHAR_BIT   = %d bits in a byte\n", CHAR_BIT);
    printf("CHAR_MIN   = %d\n", CHAR_MIN);
    printf("CHAR_MAX   = %d\n", CHAR_MAX);
    printf("SCHAR_MIN  = %d\n", SCHAR_MIN);
    printf("SCHAR_MAX  = %d\n", SCHAR_MAX);
    printf("SHRT_MIN   = %d\n", SHRT_MIN);
    printf("SHRT_MAX   = %d\n", SHRT_MAX);
    printf("INT_MIN    = %d\n", INT_MIN);
    printf("INT_MAX    = %d\n", INT_MAX);
    printf("LONG_MIN   = %ld\n", LONG_MIN);
    printf("LONG_MAX   = %ld\n", LONG_MAX);
    printf("LLONG_MIN  = %lld\n", LLONG_MIN);
    printf("LLONG_MAX  = %lld\n", LLONG_MAX);

    printf("\n=== limits.h (unsigned maxima) ===\n");
    printf("UCHAR_MAX  = %u\n", UCHAR_MAX);
    printf("USHRT_MAX  = %u\n", USHRT_MAX);
    printf("UINT_MAX   = %u\n", UINT_MAX);
    printf("ULONG_MAX  = %lu\n", ULONG_MAX);
    printf("ULLONG_MAX = %llu\n", ULLONG_MAX);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o limits_demo limits_demo.c
./limits_demo
```

Use these macros for **portable** range checks instead of hard-coded `2147483647`.

---

## Floating-Point Types and `float.h`

| Type | Typical size | Approx. decimal digits |
|------|--------------|------------------------|
| `float` | 4 | ~6–7 (`FLT_DIG`) |
| `double` | 8 | ~15–16 (`DBL_DIG`) |
| `long double` | 8–16 | extended (`LDBL_DIG`) |

```c
/* float_limits_demo.c */
#include <stdio.h>
#include <float.h>

int main(void) {
    printf("=== sizes ===\n");
    printf("float:       %zu\n", sizeof(float));
    printf("double:      %zu\n", sizeof(double));
    printf("long double: %zu\n", sizeof(long double));

    printf("\n=== decimal digits of precision ===\n");
    printf("FLT_DIG  = %d\n", FLT_DIG);
    printf("DBL_DIG  = %d\n", DBL_DIG);
    printf("LDBL_DIG = %d\n", LDBL_DIG);

    printf("\n=== min positive normalized / max finite ===\n");
    printf("FLT_MIN  = %e  FLT_MAX  = %e\n", FLT_MIN, FLT_MAX);
    printf("DBL_MIN  = %e  DBL_MAX  = %e\n", DBL_MIN, DBL_MAX);
    printf("LDBL_MIN = %Le LDBL_MAX = %Le\n", LDBL_MIN, LDBL_MAX);

    printf("\n=== epsilon (1 + eps != 1) ===\n");
    printf("FLT_EPSILON  = %e\n", FLT_EPSILON);
    printf("DBL_EPSILON  = %e\n", DBL_EPSILON);
    printf("LDBL_EPSILON = %Le\n", LDBL_EPSILON);

    printf("\n=== radix and mantissa bits ===\n");
    printf("FLT_RADIX = %d\n", FLT_RADIX);
    printf("FLT_MANT_DIG = %d  DBL_MANT_DIG = %d  LDBL_MANT_DIG = %d\n",
           FLT_MANT_DIG, DBL_MANT_DIG, LDBL_MANT_DIG);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o float_limits_demo float_limits_demo.c
./float_limits_demo
```

### Classic Precision Surprise

```c
#include <stdio.h>

int main(void) {
    double a = 0.1 + 0.2;
    printf("0.1 + 0.2 = %.20f\n", a);
    printf("equals 0.3? %s\n", (a == 0.3) ? "yes" : "no");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o fp_surprise fp_surprise.c
./fp_surprise
```

---

## Character Types

`char` is an integer type holding a character code (often ASCII/UTF-8 unit). Whether plain `char` is signed is **implementation-defined**.

```c
#include <stdio.h>

int main(void) {
    char letter = 'A';
    char from_code = 65;

    printf("Letter: %c\n", letter);
    printf("As int: %d\n", letter);
    printf("from_code: %c\n", from_code);

    signed char sc = -1;
    unsigned char uc = 255;
    printf("signed char -1 -> %d\n", sc);
    printf("unsigned char 255 -> %u\n", uc);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o char_demo char_demo.c
./char_demo
```

Prefer `unsigned char` for raw byte buffers; prefer `signed char` when you need negative small integers explicitly.

---

## Boolean Type (C99+)

```c
#include <stdio.h>
#include <stdbool.h>

int main(void) {
    _Bool flag = 1;
    bool ok = true;
    bool bad = false;

    printf("flag=%d ok=%d bad=%d\n", flag, ok, bad);
    if (ok) {
        printf("Task complete path\n");
    }
    return 0;
}
```

Any scalar converts to `_Bool`: zero → 0, nonzero → 1.

---

## Fixed-Width Types (`stdint.h`) — Prefer These When Width Matters

`int` and `long` change meaning across ABIs. For wire formats, file headers, embedded registers, cryptography, and cross-platform protocols, use **exact-width** types when the implementation provides them (all modern hosted Linux toolchains do for 8/16/32/64).

### Exact-Width

| Type | Width | Signed range (two’s complement) |
|------|-------|----------------------------------|
| `int8_t` / `uint8_t` | 8 | −128..127 / 0..255 |
| `int16_t` / `uint16_t` | 16 | ±2¹⁵ / 0..2¹⁶−1 |
| `int32_t` / `uint32_t` | 32 | ±2³¹ / 0..2³²−1 |
| `int64_t` / `uint64_t` | 64 | ±2⁶³ / 0..2⁶⁴−1 |

Also: `int_leastN_t`, `int_fastN_t`, `intmax_t`, `intptr_t`, `uintptr_t`.

### Printing Portably: `inttypes.h`

```c
/* stdint_demo.c */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <stddef.h>

int main(void) {
    int8_t   a = -5;
    uint8_t  b = 200;
    int16_t  c = -1000;
    uint16_t d = 50000;
    int32_t  e = 123456789;
    uint32_t f = 4000000000u;
    int64_t  g = -123456789012345LL;
    uint64_t h = 123456789012345ULL;

    printf("int8:   %" PRId8 "\n", a);
    printf("uint8:  %" PRIu8 "\n", b);
    printf("int16:  %" PRId16 "\n", c);
    printf("uint16: %" PRIu16 "\n", d);
    printf("int32:  %" PRId32 "\n", e);
    printf("uint32: %" PRIu32 "\n", f);
    printf("int64:  %" PRId64 "\n", g);
    printf("uint64: %" PRIu64 "\n", h);

    /* Hex */
    printf("uint32 hex: 0x%08" PRIX32 "\n", f);

    /* Pointer-sized integers */
    void *p = &e;
    uintptr_t raw = (uintptr_t)p;
    printf("pointer as uintptr_t: 0x%" PRIxPTR "\n", raw);

    /* Limits from stdint.h */
    printf("INT32_MIN=%" PRId32 " INT32_MAX=%" PRId32 "\n",
           INT32_MIN, INT32_MAX);
    printf("UINT64_MAX=%" PRIu64 "\n", UINT64_MAX);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o stdint_demo stdint_demo.c
./stdint_demo
```

### When to Use What

| Need | Choose |
|------|--------|
| Exact layout / protocol field | `intN_t` / `uintN_t` |
| “At least N bits”, speed OK | `int_fastN_t` |
| “At least N bits”, small size | `int_leastN_t` |
| Object sizes, array indices | `size_t` |
| Pointer difference | `ptrdiff_t` |
| Generic local counter on host | `int` is fine |
| File offsets (POSIX) | often `off_t` (with feature macros) |

### Example: Portable Binary Header

```c
/* packet_header.c */
#include <stdio.h>
#include <stdint.h>
#include <inttypes.h>
#include <string.h>

struct PacketHeader {
    uint32_t magic;    /* 0x4B313947 'K19G' style demo */
    uint16_t version;
    uint16_t length;
    uint32_t crc32;
};

int main(void) {
    struct PacketHeader h = {
        .magic = 0x4B313947u,
        .version = 1,
        .length = 42,
        .crc32 = 0xDEADBEEFu
    };

    printf("sizeof header = %zu (expect 12 if no padding)\n", sizeof h);
    printf("magic=%08" PRIX32 " ver=%" PRIu16 " len=%" PRIu16 " crc=%08" PRIX32 "\n",
           h.magic, h.version, h.length, h.crc32);

    /* Serialize explicitly (endianness still your responsibility) */
    uint8_t buf[12];
    memcpy(buf + 0, &h.magic, 4);
    memcpy(buf + 4, &h.version, 2);
    memcpy(buf + 6, &h.length, 2);
    memcpy(buf + 8, &h.crc32, 4);

    printf("bytes:");
    for (size_t i = 0; i < sizeof buf; i++) {
        printf(" %02X", buf[i]);
    }
    printf("\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o packet_header packet_header.c
./packet_header
```

Note: `memcpy` of multi-byte integers uses **host endianness**. Network protocols often need explicit big-endian packing.

---

## Signed Overflow Is Undefined Behavior

For **signed** integer types, overflow (and some underflows) are **undefined behavior (UB)** in C. The compiler may assume signed overflow never happens and optimize accordingly—including deleting “impossible” checks.

```c
/* overflow_ub_note.c — educational; do not rely on wraparound of signed int */
#include <stdio.h>
#include <limits.h>
#include <stdint.h>
#include <inttypes.h>

int main(void) {
    int x = INT_MAX;
    printf("INT_MAX = %d\n", x);

    /* The expression (x + 1) is UB if it overflows.
     * In practice you might see wrap, a trap, or surprising optimization.
     * Do NOT write production code that expects wrap on signed overflow.
     */
    printf("Naive signed x+1 is UB if evaluated at INT_MAX.\n");

    /* Well-defined wrap: use unsigned */
    unsigned int ux = (unsigned int)INT_MAX;
    printf("unsigned wrap: %u + 1 = %u\n", ux, ux + 1u);

    /* Or use wider type for the math */
    int64_t wide = (int64_t)x + 1;
    printf("widened: %" PRId64 "\n", wide);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o overflow_ub_note overflow_ub_note.c
./overflow_ub_note
```

Safer patterns:

```c
/* overflow_safe_patterns.c */
#include <stdio.h>
#include <limits.h>
#include <stdint.h>
#include <inttypes.h>
#include <stdbool.h>

/* Return false if a + b would overflow int */
static bool safe_add_int(int a, int b, int *out) {
    if (b > 0 && a > INT_MAX - b) {
        return false;
    }
    if (b < 0 && a < INT_MIN - b) {
        return false;
    }
    *out = a + b;
    return true;
}

/* Unsigned: wrap is defined; detect wrap if you need saturation/error */
static bool safe_add_u32(uint32_t a, uint32_t b, uint32_t *out) {
    if (a > UINT32_MAX - b) {
        return false; /* would wrap */
    }
    *out = a + b;
    return true;
}

static bool safe_mul_int(int a, int b, int *out) {
    if (a == 0 || b == 0) {
        *out = 0;
        return true;
    }
    /* Use int64_t intermediate when int is 32-bit — common on Linux */
    int64_t r = (int64_t)a * (int64_t)b;
    if (r > INT_MAX || r < INT_MIN) {
        return false;
    }
    *out = (int)r;
    return true;
}

int main(void) {
    int sum;
    if (!safe_add_int(INT_MAX, 1, &sum)) {
        printf("add INT_MAX+1: overflow detected (good)\n");
    }

    if (safe_add_int(100, 23, &sum)) {
        printf("100+23 = %d\n", sum);
    }

    uint32_t u;
    if (!safe_add_u32(UINT32_MAX, 1u, &u)) {
        printf("u32 MAX+1: overflow detected\n");
    }

    int prod;
    if (!safe_mul_int(100000, 100000, &prod)) {
        printf("100000*100000 does not fit in int\n");
    }

    /* Compiler helpers (GCC/Clang) — practical on Linux */
    int r;
    if (__builtin_add_overflow(INT_MAX, 1, &r)) {
        printf("__builtin_add_overflow caught INT_MAX+1\n");
    }
    if (!__builtin_add_overflow(20, 22, &r)) {
        printf("__builtin_add_overflow 20+22 = %d\n", r);
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o overflow_safe_patterns overflow_safe_patterns.c
./overflow_safe_patterns
```

### Safer Patterns Summary

| Pattern | Notes |
|---------|--------|
| Check before op | `if (a > INT_MAX - b)` style for add |
| Wider intermediate | `int64_t` for 32-bit `int` multiply/add |
| Unsigned modular math | Defined wrap; still check if wrap is an error |
| `__builtin_*_overflow` | GCC/Clang; clean and efficient |
| Sanitizers | `gcc -fsanitize=undefined` catches overflow at runtime in tests |

```bash
gcc -std=c17 -Wall -Wextra -fsanitize=undefined -o ov_san ov.c
./ov_san
```

---

## Type Specifiers and Qualifiers

| Specifier / qualifier | Role |
|----------------------|------|
| `signed` / `unsigned` | Signedness |
| `short` / `long` / `long long` | Rank / width hints |
| `const` | Not assignable through this lvalue |
| `volatile` | May change outside program’s knowledge |
| `restrict` | Pointer aliasing promise (C99) |

```c
#include <stdio.h>

int main(void) {
    const int max_size = 100;
    long long big = 123456789012345LL;
    unsigned short port = 8080;

    printf("max_size=%d big=%lld port=%hu\n", max_size, big, port);
    return 0;
}
```

---

## Type Promotion (Preview)

`char` and `short` promote to `int` (or `unsigned int`) in expressions. Mixed `int`/`float`/`double` follow usual arithmetic conversions. Details belong in the type-conversion chapter; for now, know that `sizeof(char + char)` is often `sizeof(int)`.

```c
#include <stdio.h>

int main(void) {
    char a = 1, b = 2;
    printf("sizeof(char)=%zu sizeof(a+b)=%zu\n", sizeof(char), sizeof(a + b));
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o promote promote.c
./promote
```

---

## Practical Combined Explorer

```c
/* type_explorer.c */
#include <stdio.h>
#include <limits.h>
#include <float.h>
#include <stdint.h>
#include <inttypes.h>
#include <stddef.h>

int main(void) {
    printf("=== Memory Requirements ===\n");
    printf("char %zu | int %zu | long %zu | float %zu | double %zu | void* %zu\n",
           sizeof(char), sizeof(int), sizeof(long),
           sizeof(float), sizeof(double), sizeof(void *));

    int n = 1000;
    printf("\nArray of %d ints: %zu bytes\n", n, (size_t)n * sizeof(int));
    printf("Array of %d int64_t: %zu bytes\n", n, (size_t)n * sizeof(int64_t));

    printf("\n=== Critical limits ===\n");
    printf("INT_MAX=%d UINT_MAX=%u\n", INT_MAX, UINT_MAX);
    printf("LONG_MAX=%ld\n", LONG_MAX);
    printf("SIZE_MAX=%zu\n", (size_t)SIZE_MAX);
    printf("DBL_DIG=%d DBL_EPSILON=%e\n", DBL_DIG, DBL_EPSILON);

    printf("\n=== Fixed width sanity ===\n");
    printf("sizeof(int32_t)=%zu sizeof(int64_t)=%zu\n",
           sizeof(int32_t), sizeof(int64_t));

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o type_explorer type_explorer.c
./type_explorer
```

---

## Best Practices

1. **Measure** with `sizeof`; don’t hard-code type sizes.  
2. Use **`stdint.h`** for on-disk, on-wire, and register-facing fields.  
3. Print fixed-width values with **`inttypes.h`** macros (`PRId32`, …).  
4. Treat **signed overflow as a bug**, not as wraparound.  
5. Prefer **`size_t`** for sizes and indices into objects.  
6. Compare floats with **tolerances**, not `==`, unless you need exact bit identity.  
7. Enable **`-Wall -Wextra`**; add **`-fsanitize=undefined`** in debug builds.

---

## Exercises

### Exercise 1 — ABI report

Extend `sizeof_tour.c` to also print `CHAR_BIT`, whether plain `char` is signed (`(char)-1 < 0`), and `sizeof(struct { char c; int i; })` vs sum of members (padding).

```bash
gcc -std=c17 -Wall -Wextra -o abi_report abi_report.c
./abi_report
```

### Exercise 2 — limits-driven clamp

Write `int clamp_to_int(long long x)` that returns `INT_MIN`/`INT_MAX` if out of range, else `(int)x`. Test with values from `limits_demo` output.

### Exercise 3 — safe multiply

Implement `bool safe_mul_i64(int64_t a, int64_t b, int64_t *out)` without invoking UB. Compare against `__builtin_mul_overflow`.

### Exercise 4 — protocol fields

Define a message with `uint8_t type`, `uint16_t id`, `uint32_t payload_len` using fixed-width types. Pack into a byte buffer in **little-endian** explicitly (shifts and masks), then unpack and verify round-trip.

### Exercise 5 — float.h scavenger

Print `FLT_ROUNDS` and explain what each value means (look up in the standard or man pages). Measure how many times you can add `FLT_EPSILON` to `1.0f` before the sum changes (loop with a counter).

### Exercise 6 — UB sanitizer lab

Intentionally evaluate `int x = INT_MAX; x = x + 1;` in a tiny program under:

```bash
gcc -std=c17 -Wall -Wextra -fsanitize=undefined -O0 -o ub ub.c
./ub
```

Then rewrite using a safe helper and confirm the sanitizer is silent.

---

## Summary

1. **Integer and floating types** — families, typical Linux sizes  
2. **`sizeof` tour** — measure your ABI  
3. **`limits.h` / `float.h`** — portable ranges and FP characteristics  
4. **`char` / `bool`** — integer nature and boolean conversion  
5. **`stdint.h` + `inttypes.h`** — fixed-width types and portable I/O  
6. **Signed overflow UB** — detection patterns and builtins  
7. **Qualifiers** — `const`, `volatile`, `restrict` (preview)  
8. **Exercises** — ABI report, clamp, safe mul, packing, sanitizers  

Next: variables, constants, and storage duration—how these types appear in real programs.
