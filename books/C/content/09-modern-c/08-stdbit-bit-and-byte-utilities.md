# C23 `<stdbit.h>`: Bit and Byte Utilities

## Thesis

Every serious C code base has a `bits.h` full of `__builtin_clz`, `__builtin_popcount`, hand-rolled "round up to a power of two" loops, and `#ifdef __BYTE_ORDER__` blocks. C23 (ISO/IEC 9899:2024, §7.18) replaces that folklore with a standard header: **`<stdbit.h>`** — fourteen families of bit queries (`stdc_leading_zeros`, `stdc_count_ones`, `stdc_bit_width`, `stdc_bit_ceil`, …) plus three endianness macros.

The improvements over the builtins are not cosmetic:

- **Every function is defined for zero.** `__builtin_clz(0)` is undefined behaviour; `stdc_leading_zeros(0u)` is 32.
- **Type-generic and width-correct.** `stdc_leading_zeros` on a `uint8_t` counts within 8 bits, on a `uint64_t` within 64 — no `clz` vs `clzl` vs `clzll` mismatch.
- **Overflow is specified.** `stdc_bit_ceil` returns 0 when the next power of two does not fit, instead of wrapping silently.

glibc ships the header since **2.39** (January 2024), with out-of-line functions for each width (`_uc`, `_us`, `_ui`, `_ul`, `_ull`) and type-generic macros; GCC 14 adds `__builtin_stdc_*` builtins that glibc's macros use when available. The boring habit: **new bit-twiddling code calls `<stdbit.h>` with unsigned operands, and the old `bits.h` shrinks to a fallback shim.**

## Mental model

```text
  bit:   31 30 29 ...  9  8 │ 7  6  5  4 │        3  2  1  0
  x:      0  0  0 ...  0  0 │ 1  1  1  1 │        0  0  0  0
         leading zeros: 24  │  ones: 4   │ trailing zeros: 4

  x = 0x000000F0 (unsigned int, 32 bits)
  "first" functions count positions 1-based:  first_leading_one  = 25 (from the MSB)
                                              first_trailing_one =  5 (from the LSB)
                                              0 means "no such bit"
  bit_width = 8   (bits needed: 32 - leading_zeros)
  bit_floor = 0x80, bit_ceil = 0x100   (0 if not representable)
```

| Family | Question it answers | `x == 0` | Return type |
|--------|---------------------|----------|-------------|
| `leading_zeros` / `leading_ones` | run length from the MSB | width | `unsigned int` |
| `trailing_zeros` / `trailing_ones` | run length from the LSB | width / 0 | `unsigned int` |
| `first_leading_{zero,one}` | 1-based position from the MSB | 1 / **0 = none** | `unsigned int` |
| `first_trailing_{zero,one}` | 1-based position from the LSB | 1 / **0 = none** | `unsigned int` |
| `count_zeros` / `count_ones` | population count | width / 0 | `unsigned int` |
| `has_single_bit` | is it a power of two? | `false` | `bool` |
| `bit_width` | bits needed to represent `x` (⌊log2 x⌋ + 1) | 0 | `unsigned int` |
| `bit_floor` | largest power of two ≤ `x` | 0 | same as argument |
| `bit_ceil` | smallest power of two ≥ `x` | 1 | same as argument; **0 if it does not fit** |

Endianness, at compile time: `__STDC_ENDIAN_NATIVE__` equals `__STDC_ENDIAN_LITTLE__` or `__STDC_ENDIAN_BIG__` (or something else on exotic hardware). C23 gives you detection only — there is no standard byte-swap function in `<stdbit.h>`.

## Worked examples

All listings were built and run on x86_64 Linux with GCC 14.2 (Debian 14.2.0-19), Clang 19.1.7, and glibc 2.41. Output was identical under both compilers except where *The trap* shows otherwise.

### Case 1: a tour on one value

```c
/* tour.c — every <stdbit.h> family on one 32-bit value. */
#include <stdbit.h>
#include <stdio.h>

int main(void) {
    unsigned x = 0x00F0u;   /* ...0000 1111 0000 — bits 4..7 set */

    printf("x = 0x%08X (width %zu bits)\n", x, sizeof x * 8);
    printf("leading_zeros        %2u\n", stdc_leading_zeros(x));
    printf("leading_ones         %2u\n", stdc_leading_ones(x));
    printf("trailing_zeros       %2u\n", stdc_trailing_zeros(x));
    printf("trailing_ones        %2u\n", stdc_trailing_ones(x));
    printf("first_leading_one    %2u   (1-based from MSB)\n", stdc_first_leading_one(x));
    printf("first_trailing_one   %2u   (1-based from LSB)\n", stdc_first_trailing_one(x));
    printf("first_trailing_zero  %2u\n", stdc_first_trailing_zero(x));
    printf("count_ones           %2u\n", stdc_count_ones(x));
    printf("count_zeros          %2u\n", stdc_count_zeros(x));
    printf("has_single_bit       %2d\n", stdc_has_single_bit(x));
    printf("bit_width            %2u\n", stdc_bit_width(x));
    printf("bit_floor        0x%04X\n", stdc_bit_floor(x));
    printf("bit_ceil         0x%04X\n", stdc_bit_ceil(x));

    puts("-- edge cases --");
    printf("leading_zeros(0u)    %2u   (defined: the type's width)\n", stdc_leading_zeros(0u));
    printf("first_trailing_one(0u) %u   (0 means \"no such bit\")\n", stdc_first_trailing_one(0u));
    printf("bit_width(0u)        %2u\n", stdc_bit_width(0u));
    printf("bit_ceil(0u)         %2u\n", stdc_bit_ceil(0u));
    printf("bit_ceil(0x80000001u) %u   (not representable -> 0)\n", stdc_bit_ceil(0x80000001u));
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -O2 tour.c -o tour && ./tour
```

```text
x = 0x000000F0 (width 32 bits)
leading_zeros        24
leading_ones          0
trailing_zeros        4
trailing_ones         0
first_leading_one    25   (1-based from MSB)
first_trailing_one    5   (1-based from LSB)
first_trailing_zero   1
count_ones            4
count_zeros          28
has_single_bit        0
bit_width             8
bit_floor        0x0080
bit_ceil         0x0100
-- edge cases --
leading_zeros(0u)    32   (defined: the type's width)
first_trailing_one(0u) 0   (0 means "no such bit")
bit_width(0u)         0
bit_ceil(0u)          1
bit_ceil(0x80000001u) 0   (not representable -> 0)
```

Read the edge cases twice. `bit_ceil(0)` is 1 (the smallest power of two), `first_*` functions return **0 for "not found"**, so every position you get back must be decremented before use as a shift count or index.

### Case 2: sizing a ring buffer with `stdc_bit_ceil`

Power-of-two capacities let a ring buffer replace `% capacity` with `& mask`. The old idiom — a loop or the "smear right" trick — silently wraps to 0 on huge inputs; `stdc_bit_ceil` *defines* that case as 0, which the caller can test.

```c
/* ring.c — power-of-two ring buffer sized with stdc_bit_ceil. */
#include <stdbit.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

struct ring {
    size_t   mask;          /* capacity - 1; capacity is a power of two */
    size_t   head, tail;    /* free-running counters; index = counter & mask */
    uint32_t *slots;
};

static bool ring_init(struct ring *r, size_t want) {
    if (want == 0) return false;
    size_t cap = stdc_bit_ceil(want);      /* 0 if it cannot be represented */
    if (cap == 0) return false;
    r->slots = calloc(cap, sizeof *r->slots);
    if (!r->slots) return false;
    r->mask = cap - 1;
    r->head = r->tail = 0;
    return true;
}

static bool ring_push(struct ring *r, uint32_t v) {
    if (r->head - r->tail > r->mask) return false;   /* full */
    r->slots[r->head++ & r->mask] = v;
    return true;
}

static bool ring_pop(struct ring *r, uint32_t *v) {
    if (r->head == r->tail) return false;            /* empty */
    *v = r->slots[r->tail++ & r->mask];
    return true;
}

int main(void) {
    const size_t asks[] = { 1, 5, 64, 1000, SIZE_MAX / 2 + 2 };
    for (size_t i = 0; i < sizeof asks / sizeof asks[0]; i++) {
        size_t c = stdc_bit_ceil(asks[i]);
        printf("want %-20zu -> capacity %zu%s\n", asks[i], c,
               c ? "" : "  (not representable: refuse)");
    }

    struct ring r;
    if (!ring_init(&r, 5)) return 1;
    unsigned pushed = 0;
    for (uint32_t v = 100; ring_push(&r, v); v++) pushed++;
    printf("capacity %zu, pushed %u before full\n", r.mask + 1, pushed);

    uint32_t v;
    printf("popped:");
    while (ring_pop(&r, &v)) printf(" %u", v);
    printf("\n");
    free(r.slots);
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -O2 ring.c -o ring && ./ring
```

```text
want 1                    -> capacity 1
want 5                    -> capacity 8
want 64                   -> capacity 64
want 1000                 -> capacity 1024
want 9223372036854775809  -> capacity 0  (not representable: refuse)
capacity 8, pushed 8 before full
popped: 100 101 102 103 104 105 106 107
```

`size_t` is `unsigned long` on LP64 Linux, so the type-generic macro selects the 64-bit implementation and returns a `size_t`-width result. The "full" test `head - tail > mask` relies on unsigned wrap of free-running counters, which is well-defined.

### Case 3: a slot/ID allocator on a bitmap

File-descriptor tables, connection IDs, and inode bitmaps all ask "lowest free slot?". With one 64-bit word per 64 slots, `stdc_first_trailing_zero` answers in a single instruction per word, and `stdc_count_ones` gives occupancy.

```c
/* slots.c — a 256-slot ID allocator on a bitmap of 64-bit words. */
#include <stdbit.h>
#include <stdint.h>
#include <stdio.h>

#define WORDS 4                      /* 4 × 64 = 256 slots */
static uint64_t used[WORDS];         /* bit set = slot in use */

/* Lowest free slot, or -1. stdc_first_trailing_zero is 1-based, 0 = none. */
static int slot_alloc(void) {
    for (int w = 0; w < WORDS; w++) {
        unsigned pos = stdc_first_trailing_zero(used[w]);
        if (pos == 0) continue;               /* word full */
        unsigned bit = pos - 1;               /* convert to 0-based */
        used[w] |= UINT64_C(1) << bit;
        return w * 64 + (int)bit;
    }
    return -1;
}

static void slot_free(int id) {
    used[id / 64] &= ~(UINT64_C(1) << (id % 64));
}

static unsigned slots_in_use(void) {
    unsigned n = 0;
    for (int w = 0; w < WORDS; w++) n += stdc_count_ones(used[w]);
    return n;
}

int main(void) {
    int a = slot_alloc(), b = slot_alloc(), c = slot_alloc();
    printf("allocated %d %d %d, in use %u\n", a, b, c, slots_in_use());

    slot_free(b);
    printf("freed %d, next alloc reuses %d\n", b, slot_alloc());

    while (slot_alloc() >= 0) { }
    printf("after filling: in use %u, alloc -> %d\n", slots_in_use(), slot_alloc());

    slot_free(200);
    printf("freed 200, alloc -> %d\n", slot_alloc());
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -Wconversion -O2 slots.c -o slots && ./slots
```

```text
allocated 0 1 2, in use 3
freed 1, next alloc reuses 1
after filling: in use 256, alloc -> -1
freed 200, alloc -> 200
```

The single line `unsigned bit = pos - 1;` is the whole cost of the 1-based convention — and forgetting it is an off-by-one that allocates slot 1 first and never hands out slot 0.

### Case 4: a power-of-two latency histogram

Operators bucket latencies by order of magnitude (HDR-style). `stdc_bit_width(ns)` *is* the bucket index: bucket `b` holds values in `[2^(b-1), 2^b - 1]`, and 0 gets its own bucket — no `log2()`, no floating point, no special case for zero.

```c
/* hist.c — power-of-two latency histogram: bucket = stdc_bit_width(ns). */
#include <stdbit.h>
#include <stdint.h>
#include <stdio.h>

#define BUCKETS 65   /* bit_width of a uint64_t is 0..64 */

int main(void) {
    /* Pretend these came from clock_gettime() deltas, in nanoseconds. */
    const uint64_t samples_ns[] = {
        0, 1, 3, 800, 950, 1024, 1500, 2047, 2048,
        120000, 130000, 250000, 4000000, 4100000, 900000000,
    };
    unsigned hist[BUCKETS] = {0};

    for (size_t i = 0; i < sizeof samples_ns / sizeof samples_ns[0]; i++)
        hist[stdc_bit_width(samples_ns[i])]++;     /* O(1), branch-free */

    printf("%-28s%s\n", "bucket (ns)", "count");
    for (unsigned b = 0; b < BUCKETS; b++) {
        if (!hist[b]) continue;
        uint64_t lo = b ? UINT64_C(1) << (b - 1) : 0;
        uint64_t hi = b ? (b == 64 ? UINT64_MAX : (UINT64_C(1) << b) - 1) : 0;
        printf("[%11llu, %11llu]  %u\n",
               (unsigned long long)lo, (unsigned long long)hi, hist[b]);
    }
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -Wconversion -O2 hist.c -o hist && ./hist
```

```text
bucket (ns)                 count
[          0,           0]  1
[          1,           1]  1
[          2,           3]  1
[        512,        1023]  2
[       1024,        2047]  3
[       2048,        4095]  1
[      65536,      131071]  2
[     131072,      262143]  1
[    2097152,     4194303]  2
[  536870912,  1073741823]  1
```

### Case 5: endianness — detect with `<stdbit.h>`, decode with shifts

The endianness macros are integer constant expressions, so they work in `#if`. But the robust way to *decode* wire formats is still to assemble bytes with shifts: correct on every host, no unaligned pointer casts, and the optimiser recognises the pattern.

```c
/* wire.c — endianness detection with <stdbit.h>, decoding with shifts. */
#include <stdbit.h>
#include <stdint.h>
#include <stdio.h>
#include <string.h>

#if __STDC_ENDIAN_NATIVE__ == __STDC_ENDIAN_LITTLE__
#  define HOST_ORDER "little-endian"
#elif __STDC_ENDIAN_NATIVE__ == __STDC_ENDIAN_BIG__
#  define HOST_ORDER "big-endian"
#else
#  define HOST_ORDER "mixed/other"
#endif

/* Decode a big-endian (network order) u32 from bytes. Correct on every host;
   no casts of unaligned pointers, no #ifdef per architecture. */
uint32_t load_be32(const unsigned char *p) {
    return (uint32_t)p[0] << 24 | (uint32_t)p[1] << 16 |
           (uint32_t)p[2] << 8  | (uint32_t)p[3];
}

int main(void) {
    const unsigned char hdr[] = { 0x00, 0x00, 0x20, 0xFB, 0xDE, 0xAD };  /* len=8443 */
    uint32_t raw;
    memcpy(&raw, hdr, sizeof raw);

    printf("host byte order : %s\n", HOST_ORDER);
    printf("memcpy as-is    : %u (0x%08X)\n", raw, raw);
    printf("load_be32       : %u (0x%08X)\n", load_be32(hdr), load_be32(hdr));
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra -O2 wire.c -o wire && ./wire
```

```text
host byte order : little-endian
memcpy as-is    : 4213178368 (0xFB200000)
load_be32       : 8443 (0x000020FB)
```

The portable shift expression compiles to a single load plus byte swap on x86_64 with both compilers:

```bash
gcc -std=c23 -O2 -S -o - wire.c | sed -n '/^load_be32:/,/ret/p' | grep -v '^\s*\.'
```

```text
load_be32:
	movl	(%rdi), %eax
	bswap	%eax
	ret
```

Use `__STDC_ENDIAN_NATIVE__` for what it is good at: a `static_assert` that a memory-mapped on-disk format really is native-endian, or picking a fast path. Do not build decoders that are only correct on one byte order.

### Case 6: one shim for older libcs

glibc before 2.39 (still common in long-term-support distributions) has no `<stdbit.h>`. Wrap only the calls your project uses and test both paths. The fallback below is deliberately **64-bit only** — exactly the width restriction the real type-generic macros remove — and it guards the zero case the builtins leave undefined.

```c
/* stdbit_compat.h — the three <stdbit.h> calls this project uses, on any
   GCC/Clang + any libc. Prefer the real header; fall back carefully. */
#ifndef STDBIT_COMPAT_H
#define STDBIT_COMPAT_H

#if defined(__has_include) && !defined(STDBIT_FORCE_FALLBACK)
#  if __has_include(<stdbit.h>)
#    include <stdbit.h>
#    define STDBIT_IMPL "libc <stdbit.h>"
#  endif
#endif

#ifndef STDBIT_IMPL
#  include <stdint.h>
#  define STDBIT_IMPL "fallback"
/* __builtin_clzll / __builtin_ctzll are UNDEFINED for 0 — guard it. */
static inline unsigned compat_bit_width_u64(uint64_t x) {
    return x ? 64u - (unsigned)__builtin_clzll(x) : 0u;
}
static inline unsigned compat_count_ones_u64(uint64_t x) {
    return (unsigned)__builtin_popcountll(x);
}
static inline unsigned compat_first_trailing_zero_u64(uint64_t x) {
    return ~x ? (unsigned)__builtin_ctzll(~x) + 1u : 0u;   /* 1-based, 0 = none */
}
#  define stdc_bit_width(x)          compat_bit_width_u64(x)
#  define stdc_count_ones(x)         compat_count_ones_u64(x)
#  define stdc_first_trailing_zero(x) compat_first_trailing_zero_u64(x)
#endif

#endif /* STDBIT_COMPAT_H */
```

```c
/* compat.c — same results from the real header and the fallback. */
#include <stdint.h>
#include <stdio.h>
#include "stdbit_compat.h"

int main(void) {
    const uint64_t v[] = { 0, 1, 0xF0, UINT64_MAX };
    printf("impl: %s\n", STDBIT_IMPL);
    for (int i = 0; i < 4; i++)
        printf("x=%-20llu width=%2u ones=%2u first_trailing_zero=%2u\n",
               (unsigned long long)v[i], stdc_bit_width(v[i]),
               stdc_count_ones(v[i]), stdc_first_trailing_zero(v[i]));
    return 0;
}
```

```bash
gcc -std=c23 -Wall -Wextra compat.c -o c1 && ./c1
gcc -std=c17 -Wall -Wextra -DSTDBIT_FORCE_FALLBACK compat.c -o c2 && ./c2
```

```text
impl: libc <stdbit.h>
x=0                    width= 0 ones= 0 first_trailing_zero= 1
x=1                    width= 1 ones= 1 first_trailing_zero= 2
x=240                  width= 8 ones= 4 first_trailing_zero= 1
x=18446744073709551615 width=64 ones=64 first_trailing_zero= 0
impl: fallback
x=0                    width= 0 ones= 0 first_trailing_zero= 1
x=1                    width= 1 ones= 1 first_trailing_zero= 2
x=240                  width= 8 ones= 4 first_trailing_zero= 1
x=18446744073709551615 width=64 ones=64 first_trailing_zero= 0
```

## The trap

**Integer promotion and signed arguments.** The type-generic macros pick a width from the *type of the expression you pass*. In C, `uint8_t >> 1` is an `int`, and `int` is signed. The standard says these macros take unsigned integer types only, but whether you get a diagnostic depends on the toolchain:

```c
/* trap.c — integer promotion and signedness meet type-generic bit macros. */
#include <stdbit.h>
#include <stdint.h>
#include <stdio.h>

int main(void) {
    uint8_t b = 0x10;                       /* 0001 0000 */
    int flags = -1;                         /* all 32 bits set */

    printf("leading_zeros(b)                 = %u\n", stdc_leading_zeros(b));
    printf("leading_zeros(b >> 1)            = %u\n", stdc_leading_zeros(b >> 1));
    printf("leading_zeros((uint8_t)(b >> 1)) = %u\n", stdc_leading_zeros((uint8_t)(b >> 1)));
    printf("count_ones(flags)                = %u\n", stdc_count_ones(flags));
    printf("count_ones((unsigned)flags)      = %u\n", stdc_count_ones((unsigned)flags));
    return 0;
}
```

GCC 14 maps the macros onto its `__builtin_stdc_*` builtins and rejects both mistakes:

```bash
gcc -std=c23 -Wall -Wextra trap.c -o trap
```

```text
In file included from trap.c:2:
trap.c: In function ‘main’:
trap.c:11:55: error: argument 1 in call to function ‘__builtin_stdc_leading_zeros’ has signed type
   11 |     printf("leading_zeros(b >> 1)            = %u\n", stdc_leading_zeros(b >> 1));
      |                                                       ^~~~~~~~~~~~~~~~~~
trap.c:13:55: error: argument 1 in call to function ‘__builtin_stdc_count_ones’ has signed type
   13 |     printf("count_ones(flags)                = %u\n", stdc_count_ones(flags));
      |                                                       ^~~~~~~~~~~~~~~
```

Clang 19 has no such builtins, so glibc's header falls back to a `sizeof`-based macro that converts the argument to `unsigned long long`. It compiles **without a warning** and prints:

```bash
clang -std=c23 -Wall -Wextra trap.c -o trap && ./trap
```

```text
leading_zeros(b)                 = 3
leading_zeros(b >> 1)            = 28
leading_zeros((uint8_t)(b >> 1)) = 4
count_ones(flags)                = 64
count_ones((unsigned)flags)      = 32
```

`b >> 1` was counted as a 32-bit value (28 leading zeros instead of 4), and `-1` was sign-extended to 64 bits before counting (64 ones from a 32-bit `int`). Same source, two toolchains, one compile error and one silent wrong answer.

Related mistakes:

- **Forgetting the 1-based `first_*` convention** (Case 3) — subtract 1, and treat 0 as "none".
- **Using `stdc_bit_ceil` without checking for 0** (Case 2) — 0 means "does not fit", and `0 - 1` as a mask is all ones.
- **Swapping in `__builtin_clz` "because it's the same"** — it is not defined for 0 and is fixed at `unsigned int` width.
- **Treating endianness macros as a decoder** (Case 5) — detection is not conversion.

## The boring rule

> Bit queries go through `<stdbit.h>` with an operand whose type is explicitly unsigned and of the width you mean — cast after any shift or arithmetic (`(uint8_t)(b >> 1)`, `(uint32_t)flags`). Treat `first_*` results as 1-based with 0 for "none", treat `bit_ceil` returning 0 as an error, and decode byte orders with shifts. Build with GCC ≥ 14 in at least one CI job so its builtins reject signed arguments the other toolchains accept.

Review checklist:

1. No new `__builtin_clz/ctz/popcount` calls outside a single compat header.
2. Every `stdc_*` argument is unsigned by type, not by hope; no shifted narrow types without a cast.
3. Every `stdc_first_*` result is tested for 0 and decremented before use.
4. Every `stdc_bit_ceil` result is tested for 0.
5. Wire-format decoders use byte shifts; `__STDC_ENDIAN_NATIVE__` appears only in `#if`/`static_assert`.

## Try this

1. Add `stdc_leading_ones` to Case 1 for `x = 0xFF000000u` and predict the output before running it.
2. Extend Case 3 with `slot_alloc_highest()` using `stdc_first_leading_zero` on each word, scanning from the last word down. Remember the position counts from the MSB.
3. In Case 4, add a sample of `UINT64_MAX` and confirm it lands in bucket 64 with the upper bound printed correctly.
4. Write `load_le64` and `store_be16` in Case 5's style and check the assembly at `-O2` for single `mov`/`bswap`/`rol` instructions.
5. Compile `trap.c` with both compilers on your machine. If you only have Clang, add `-Wsign-conversion` and see whether it catches either line — then decide which CI job your team needs.

## Sources

- ISO/IEC 9899:2024 (C23) §7.18 *Bit and byte utilities* — overview at [cppreference: Bit manipulation (since C23)](https://en.cppreference.com/c/numeric/bit_manip)
- [The GNU C Library manual (2.39) — Bit Manipulation](https://sourceware.org/glibc/manual/2.39/html_node/Bit-Manipulation.html)
- [glibc 2.39 release announcement](https://sourceware.org/pipermail/libc-announce/2024/000038.html) — `<stdbit.h>` added
