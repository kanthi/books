---
title: "Hexadecimal Floating Literals and %a: Exact Floats in C"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Hexadecimal Floating Literals and %a: Exact Floats in C

After this page you will be able to write floating-point constants that need no rounding, print the exact value a `double` holds with `%a`, pass floats through text and get the same bits back, and read the IEEE 754 binary64 layout from hex.

## Why Decimal Literals Lie

When you write a base-10 decimal floating-point literal in C, such as `0.1`, the compiler must convert that decimal fraction into a binary floating-point representation (typically IEEE 754 `double`). Because $0.1$ has no finite representation in binary—much like $1/3$ cannot be represented as a finite decimal—the value stored in memory is an approximation rather than the exact decimal fraction.

```c
double tenth = 0.1;
```

In standard IEEE 754 double precision (64-bit), the exact value stored for `0.1` is actually `0.0001100110011001100110011001100110011001100110011001101...` in binary, which evaluates to approximately `0.1000000000000000055511151231257827021181583404541015625`.

The rounding happens at compile time, silently. Usually that is fine. When you write the constants of a math library, a bit-exact test vector, or a tolerance such as 2⁻²⁰, you want to say exactly which bits you mean. Hexadecimal floating literals (C99) let you do that: they are written in base 2 to begin with, so there is nothing to round.

## The Hexadecimal Floating Literal Syntax

A hexadecimal floating-point literal consists of a prefix (`0x` or `0X`), a hexadecimal significand (mantissa) with an optional radix point (`.`), a required binary exponent indicator (`p` or `P`), an optional sign (`+` or `-`), and a decimal integer representing a power of two.

The binary exponent `p` or `P` is **mandatory**. `0x1.8` on its own is not a floating literal and does not compile. Without the `p`, `0x1e5` would be an integer, since `e` is a hex digit; that is why hex floats use `p` rather than `e`.

The general form is:
$$\text{0x} \, [\text{hex-digits}] \, [.\text{hex-digits}] \, \text{p} \, [\pm] \, \text{decimal-exponent} \, [\text{suffix}]$$

The value of the literal is computed as:
$$\text{significand}_{16} \times 2^{\text{decimal-exponent}}$$

| Hexadecimal Literal | Equivalent Mathematical Expression | Decimal Value | Type |
| :--- | :--- | :--- | :--- |
| `0x1p0` | $1.0_{16} \times 2^0$ | $1.0$ | `double` |
| `0x1.8p+4` | $(1 + 8/16) \times 2^4 = 1.5 \times 16$ | $24.0$ | `double` |
| `0x0.8p0` | $(0 + 8/16) \times 2^0 = 0.5 \times 1$ | $0.5$ | `double` |
| `0x1.ap-2` | $(1 + 10/16) \times 2^{-2} = 1.625 \times 0.25$ | $0.40625$ | `double` |
| `0x1.8p+4f` | $1.5 \times 2^4$ | $24.0$ | `float` |
| `0x1.8p+4L` | $1.5 \times 2^4$ | $24.0$ | `long double` |

Suffixes function identically to standard decimal floating literals: `f` or `F` specifies `float`, while `l` or `L` specifies `long double`. Unsuffixed literals default to `double`.

A hexadecimal literal containing at most 13 hex fraction digits after a normalized leading `1` occupies at most $13 \times 4 = 52$ bits in the significand fraction. A `double` stores exactly 52 fraction bits, so any such literal is stored with no rounding at all, provided its exponent is in the normal range.

## Printing Exact Values with `%a`

C99 introduced the `%a` and `%A` conversion specifiers for `printf` family functions. While `%f` prints fixed-point decimal notation and `%e` prints decimal scientific notation, `%a` prints the exact floating-point value in hexadecimal scientific format.

The default format produced by `%a` for a normalized `double` in glibc is:
$$[-]0\text{x}h.hhhh\dots\text{p}\pm d$$

where $h$ represents hexadecimal digits and $d$ represents the decimal exponent power of two. `%A` uses uppercase characters (`0X`, hex digits `A`-`F`, and `P`).

### Round-Tripping Floats Losslessly

`%.6g` throws digits away, so the value you read back is a different `double`. `%.17g` prints enough significant digits (17) that any binary64 `double` reads back exactly with a correctly rounding `strtod`, as glibc's is, but the text is long and does not show you the bits.

`%a` is exact by construction: when `FLT_RADIX` is 2, as on every mainstream platform, it prints the binary value digit for digit, and `strtod` (or `strtof`, `strtold`) accepts the same notation. The round trip gives back the same bits:

```c
char buf[64];
double original = 1.0 / 3.0;

snprintf(buf, sizeof(buf), "%a", original);
double restored = strtod(buf, NULL);

assert(original == restored); /* needs <assert.h>, <stdio.h>, <stdlib.h> */
```

## Reading IEEE 754 Binary64 Through Hexadecimal

An IEEE 754 binary64 (`double`) value consists of 64 bits structured into three distinct fields:

1. **Sign bit**: 1 bit ($s$)
2. **Biased exponent**: 11 bits ($e$), with a bias of 1023
3. **Significand fraction**: 52 bits ($f$)

```
 1 bit   11 bits                       52 bits
+------+-----------+--------------------------------------------------+
| Sign | Exponent  |                     Fraction                     |
+------+-----------+--------------------------------------------------+
  63    62       52 51                                               0
```

52 bits are exactly 13 hex digits ($52 / 4 = 13$). So for a normal number, the 13 digits after `0x1.` in `%a` output *are* the fraction field, and the `p` exponent plus 1023 is the exponent field. For example, `0x1.8p+4` (24.0) has sign 0, exponent field $4 + 1023 = 1027$ = `0x403`, and fraction `0x8000000000000`. Packed together, the 64 bits are `0x4038000000000000`.

### Common Floating-Point Constants in Hex

The standard `<float.h>` header defines limits for floating-point types. The table below illustrates how these limits map directly to binary64 hex values:

| Constant | Hexadecimal Notation | Binary Exponent | Description |
| :--- | :--- | :--- | :--- |
| `DBL_MAX` | `0x1.fffffffffffffp+1023` | $2^{1023}$ | Maximum finite `double` value |
| `DBL_MIN` | `0x1p-1022` | $2^{-1022}$ | Smallest normalized positive `double` |
| `DBL_EPSILON` | `0x1p-52` | $2^{-52}$ | Difference between $1.0$ and next representable `double` |
| Subnormal min | `0x0.0000000000001p-1022` | $2^{-1074}$ | Smallest positive subnormal `double`, as glibc prints it |

### Subnormal Numbers

When a value falls below `DBL_MIN` ($2^{-1022}$), the implicit leading bit becomes `0` rather than `1`. In glibc implementations, formatting the minimum denormalized value produces `0x0.0000000000001p-1022`, showing a zero before the hexadecimal point and a single 1 in the 13th fractional position ($2^{-52} \times 2^{-1022} = 2^{-1074}$).

## Deconstructing Floats with `frexp` and `ldexp`

The standard C library provides `frexp` and `ldexp` in `<math.h>` to inspect and construct floating-point values programmatically.

The `frexp` function breaks a floating-point number $x$ into a normalized fraction $m$ and an integer exponent $e$ such that:
$$x = m \times 2^e$$
where $|m| \in [0.5, 1.0)$ or $m = 0$.

Notice that `frexp` normalizes the mantissa $m$ to the range $[0.5, 1.0)$, whereas glibc's `%a` prints a normal `double` with a leading `1` before the point, which is the range $[1.0, 2.0)$.

For example, when evaluating `24.0` (`0x1.8p+4`):
* `%a` represents $24.0$ as $1.5 \times 2^4$ (`0x1.8p+4`).
* `frexp` breaks $24.0$ into $0.75 \times 2^5$ (`0x1.8p-1` $\times 2^5$).

`ldexp(m, e)` performs the inverse calculation, computing $m \times 2^e$.

## Complete Lab Walk-Through

The following program demonstrates decimal vs. hexadecimal literal precision, formatting with `%a`, exact round-tripping, `float` promotion rules, and decomposition with `frexp` and `ldexp`.

<!-- file: hexfloat.c -->
```c
#include <float.h>
#include <math.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
    /* 1. Decimal literals are rounded; hex literals are exact. */
    double tenth = 0.1;
    double one_p = 0x1p0;          /* 1.0 */
    double max_hex = 0x1.fffffffffffffp+1023;
    printf("0.1        = %a  (%.17g)\n", tenth, tenth);
    printf("0x1p0      = %a  (%g)\n", one_p, one_p);
    printf("DBL_MAX    : %s\n", max_hex == DBL_MAX ? "equal to 0x1.fffffffffffffp+1023" : "different");
    printf("DBL_MIN    = %a\n", DBL_MIN);
    printf("DBL_EPSILON= %a\n", DBL_EPSILON);
    printf("denorm min = %a\n", nextafter(0.0, 1.0));

    /* 2. The doubles just below and just above 1.0. */
    printf("below 1.0  = %a\n", nextafter(1.0, 0.0));
    printf("above 1.0  = %a\n", nextafter(1.0, 2.0));

    /* 3. Round trip through text: %a is exact, %.6g is not. */
    double x = 1.0 / 3.0;
    char a[64], g[64];
    snprintf(a, sizeof a, "%a", x);
    snprintf(g, sizeof g, "%.6g", x);
    printf("1/3 as %%a  = %s -> round trip %s\n", a, strtod(a, NULL) == x ? "exact" : "LOST");
    printf("1/3 as %%.6g= %s -> round trip %s\n", g, strtod(g, NULL) == x ? "exact" : "LOST");

    /* 4. Float and long double use the same notation. */
    printf("0.1f       = %a\n", (double)0.1f);
    printf("0.1L       = %La\n", 0.1L);

    /* 5. Pulling the exponent and mantissa apart. */
    int e;
    double m = frexp(0x1.8p+4, &e); /* 1.5 * 2^4 = 24 */
    printf("frexp(24)  = %a * 2^%d\n", m, e);
    printf("ldexp      = %g\n", ldexp(0x1.8p0, 4));
    return 0;
}
```

This was tested with gcc 14.2 and glibc 2.41:

```bash
gcc --version | head -1
```

```text
gcc (Debian 14.2.0-19) 14.2.0
```

Compile with warnings on. This produced no warnings:

```bash
gcc -std=c17 -Wall -Wextra -O2 -o hexfloat hexfloat.c -lm
```

Execute the compiled binary:

```bash
./hexfloat
```

It printed:

```text
0.1        = 0x1.999999999999ap-4  (0.10000000000000001)
0x1p0      = 0x1p+0  (1)
DBL_MAX    : equal to 0x1.fffffffffffffp+1023
DBL_MIN    = 0x1p-1022
DBL_EPSILON= 0x1p-52
denorm min = 0x0.0000000000001p-1022
below 1.0  = 0x1.fffffffffffffp-1
above 1.0  = 0x1.0000000000001p+0
1/3 as %a  = 0x1.5555555555555p-2 -> round trip exact
1/3 as %.6g= 0.333333 -> round trip LOST
0.1f       = 0x1.99999ap-4
0.1L       = 0xc.ccccccccccccccdp-7
frexp(24)  = 0x1.8p-1 * 2^5
ldexp      = 24
```

Reading the output line by line:

- `0.1` is really `0x1.999999999999ap-4`. The repeating `9`s are binary `1001` repeating, and the final `a` is where the compiler rounded up. `%.17g` shows the same rounding in decimal: `0.10000000000000001`.
- `0x1p0` is exactly 1, and `DBL_MAX` compares equal to the literal `0x1.fffffffffffffp+1023`.
- `DBL_MIN`, `DBL_EPSILON` and the smallest subnormal are powers of two, so in hex they are just `0x1p-1022`, `0x1p-52` and a single `1` in the last fraction digit.
- Just above 1.0, only the last hex digit changes (`0x1.0000000000001p+0`): the gap is `0x1p-52`, which is `DBL_EPSILON`. Just below 1.0 the exponent drops to `-1` and every fraction digit is `f`. The gap there is half as big, $2^{-53}$.
- `%a` text reads back exactly with `strtod`. `%.6g` text (`0.333333`) does not.
- `0.1f` shows only 6 fraction digits ending in `a`: a `float` has 23 fraction bits, so it is rounded much earlier than the `double`.
- `0.1L` on x86-64 is the 80-bit x87 format, which stores 64 significand bits with an explicit leading bit. glibc prints it with a leading hex digit `c` (binary `1100`) and adjusts the exponent: `0xc.ccccccccccccccdp-7`.
- `frexp` reports 24 as `0x1.8p-1 * 2^5`, that is $0.75 \times 2^5$. `ldexp(0x1.8p0, 4)` goes the other way and gives 24.

## Pitfalls and Common Mistakes

### 1. Missing the Binary Exponent `p`

Leaving out the `p` exponent is a compile error.

```c
/* Incorrect: Missing exponent */
double bad = 0x1.8; 

/* Correct */
double good = 0x1.8p0;
```

### 2. Assuming `p` Represents Base-16 Power

In hexadecimal floating literals, `p` stands for "power of two", not power of sixteen.

```c
/* 0x1.0p4 means 1.0 * (2^4) = 16.0, NOT 1.0 * (16^4) */
double val = 0x1.0p4;
```

### 3. Floating-Point Promotion in `printf`

Variadic functions such as `printf` promote a `float` argument to `double`. So `%a` with a `float` prints the `double` that has the same value as that `float`. The conversion is exact, so what you see is the `float`'s own rounding: it ends after 6 hex digits, much earlier than `0.1` as a `double`.

```c
float f = 0.1f;
printf("%a\n", f); /* glibc prints 0x1.99999ap-4 (trailing zeros dropped) */
```

### 4. Mismatched Specifiers for `long double`

`%a` expects a `double` (or a promoted `float`). Passing a `long double` to `%a` is undefined behaviour, and `-Wall` warns about it. Use `%La`.

```c
long double ld = 0.1L;
printf("%La\n", ld); /* Correct format specifier for long double */
```

### 5. Locale Specificity with Decimal Points

Source-code literals always use `.`. At run time, though, `printf("%a")` and `strtod` use the radix character of the current `LC_NUMERIC` locale, and that applies to hex floats too. A program that calls `setlocale(LC_ALL, "")` under a locale that uses `,` will write `0x1,8p+4`, and `strtod` stops reading at the `.` in `0x1.8p+4`. Keep `LC_NUMERIC` as `"C"` for data files, or use a locale-independent parser.

## Key Takeaways

* **Exact Representation**: Hexadecimal floating literals (C99+) allow writing binary floating-point numbers without decimal conversion errors.
* **Syntax Rule**: A hex float literal requires `0x`/`0X`, a hex significand, and a mandatory binary exponent `p`/`P` followed by a decimal power of two.
* **Bit-Exact I/O**: The `%a` specifier formats floats in exact hex notation. Text written with `%a` reads back with `strtod` to the same bits. `%.17g` also round-trips a `double`; `%.6g` does not.
* **Direct Bit Mapping**: 13 hexadecimal fractional digits map directly to the 52 significand fraction bits of an IEEE 754 binary64 `double`.
* **Standard Functions**: `frexp` decomposes numbers into normalized mantissa ($[0.5, 1.0)$) and integer exponent, while `ldexp` combines them.

## Sources

- [cppreference: Floating constants](https://en.cppreference.com/w/c/language/floating_constant)
- [cppreference: fprintf, printf, sprintf](https://en.cppreference.com/w/c/io/fprintf)
- [cppreference: strtof, strtod, strtold](https://en.cppreference.com/w/c/string/byte/strtof)
- [cppreference: frexp, frexpf, frexpl](https://en.cppreference.com/w/c/numeric/math/frexp)
- [WG14 N3220 working draft (C23 text plus fixes)](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n3220.pdf)
- [GNU C Library Manual: Floating-Point Conversions](https://www.gnu.org/software/libc/manual/html_node/Floating_002dPoint-Conversions.html)
