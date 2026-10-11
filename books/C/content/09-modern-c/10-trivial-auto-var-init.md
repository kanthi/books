---
title: "GCC -ftrivial-auto-var-init: Zero and Pattern Init"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# `-ftrivial-auto-var-init`: Making Uninitialized Stack Boring

## Thesis

Uninitialized automatic (stack) variables are a classic C footgun: reads are undefined behaviour, and in practice they leak whatever previous frame left behind — sometimes secrets, often "works on my machine" nondeterminism. Fixing every declaration by hand does not scale across a large codebase. GCC and Clang offer a compile-time mitigator:

```bash
-ftrivial-auto-var-init=zero     # or =pattern
```

The compiler inserts initialization for automatic variables that lack an explicit initializer. Security-sensitive and predictability-sensitive builds can flip the default without rewriting every function. This is not a substitute for correct initialization in new code, and it has sharp edges around **padding**, **partial writes**, **unions**, and **control-flow corners** (notably some `switch` locals). This chapter measures the flag on the box's GCC and documents what upstream says beyond that version.

## Where things stand (2026-10)

| Toolchain | Status |
|-----------|--------|
| **GCC 14.2.0** (Debian on this lab box) | `-ftrivial-auto-var-init=uninitialized\|pattern\|zero` present. Default remains `uninitialized`. Docs: initializes autos **and** struct/union **padding** to zero when the flag is on. No `-fzero-init-padding-bits=` on 14.2. |
| **GCC 15+** | Still has `-ftrivial-auto-var-init`. Separately, GCC 15 tightened when **explicit** initializers zero union padding; use `-fzero-init-padding-bits=unions` (or `=all`) / `{}` (C23) when you need the old "zero all the bytes" behaviour for initialized objects. That flag is **not** the same as trivial-auto-var-init. |
| **GCC 16** | Confirm in the release notes of the GCC you ship; this chapter's runnable cases use **14.2.0**. Treat 16 as "re-read Optimize Options before relying on new padding knobs." |
| **Clang** | Has supported the same idea longer; historically `=zero` needed an extra "I know this may go away" gate on some versions. Not installed on this lab box — verify your Clang's `clang --help` before copying flags. |

GCC's own docs are clear on a subtlety: even with `=zero` or `=pattern`, the compiler **still treats** the variable as uninitialized for `-Wuninitialized` / analyzer purposes and optimizes *as if* it were uninitialized. The inserted stores are a safety net for the abstract machine's UB-shaped holes, not a promise that tools will stop nagging.

## Mental model

```text
auto object, no initializer
        │
        ├─ default (=uninitialized):  contents = leftover stack garbage
        ├─ =zero:                     all bytes 0x00 (fields + padding)
        └─ =pattern:                  fields get 0xFE.. pattern;
                                      padding still zeroed (GCC docs)
```

| Choice | Typical use |
|--------|-------------|
| `uninitialized` | Language default; fastest; UB on read before write |
| `zero` | Production hardening: predictable, matches "calloc-shaped" intuition |
| `pattern` | Bug finding: 0xFE repeats stand out in crash dumps; do not rely on the value as API |

## Worked examples

All listings built and run on x86_64 Linux with **GCC 14.2.0** (Debian 14.2.0-19). Clang was not available on the lab host.

### Case 0: does the flag exist?

```bash
gcc -Q --help=optimizers 2>/dev/null | grep trivial-auto-var-init
```

```text
  -ftrivial-auto-var-init=[uninitialized|pattern|zero] 	uninitialized
```

### Case 1: garbage vs zero vs pattern

```c
/* tav_demo.c — stack pollution, then an uninitialized struct */
#include <stdio.h>
#include <stdint.h>

struct Padded {
    char a;   /* offset 0 */
    /* 3 bytes padding */
    int  b;   /* offset 4 */
    char c;   /* offset 8 */
    /* 3 bytes end padding → sizeof 12 on this ABI */
};

__attribute__((noinline)) void pollute_stack(void) {
    volatile unsigned char junk[512];
    volatile unsigned char sink = 0;
    for (int i = 0; i < 512; i++) {
        junk[i] = (unsigned char)(0xA5 ^ (i * 17));
        sink ^= junk[i];
    }
    (void)sink;
}

__attribute__((noinline, optimize("O0"))) void show_uninit(const char *label) {
    struct Padded s; /* no initializer on purpose */
    unsigned char *p = (unsigned char *)&s;
    int nz = 0;
    printf("%s sizeof=%zu bytes:", label, sizeof s);
    for (size_t i = 0; i < sizeof s; i++) {
        printf(" %02x", p[i]);
        if (p[i]) nz++;
    }
    printf("  (nonzero=%d)\n", nz);
}

int main(void) {
    pollute_stack();
    show_uninit("uninit");
    return 0;
}
```

```bash
gcc -O0 tav_demo.c -o tav_def && ./tav_def
gcc -O0 -ftrivial-auto-var-init=zero tav_demo.c -o tav_z && ./tav_z
gcc -O0 -ftrivial-auto-var-init=pattern tav_demo.c -o tav_p && ./tav_p
```

Representative output from this lab (the default line's exact bytes vary; nonzero count is the point):

```text
# default
uninit sizeof=12 bytes: 09 18 6b 7a 55 a4 b7 86 91 e0 f3 c2  (nonzero=12)
# =zero
uninit sizeof=12 bytes: 00 00 00 00 00 00 00 00 00 00 00 00  (nonzero=0)
# =pattern  (0xFE in fields; padding bytes are 00)
uninit sizeof=12 bytes: fe 00 00 00 fe fe fe fe fe 00 00 00  (nonzero=6)
```

Read the pattern line carefully: `a=fe`, padding `00 00 00`, `b=fe fe fe fe`, `c=fe`, end padding `00 00 00`. GCC documents that with this option it **also zeros padding** of automatic structs/unions. Pattern init is for *named members*; padding stays zero.

### Case 2: partial writes still surprise people

```c
/* same struct; write a and b only */
__attribute__((noinline, optimize("O0"))) void show_partial(const char *label) {
    struct Padded s;
    s.a = 'X';           /* 0x58 */
    s.b = 0x11223344;
    /* c never written */
    unsigned char *p = (unsigned char *)&s;
    printf("%s after a+b writes:", label);
    for (size_t i = 0; i < sizeof s; i++) printf(" %02x", p[i]);
    putchar('\n');
}
```

```text
# default (c + padding still garbage from the stack)
partial after a+b writes: 58 e0 f3 c2 44 33 22 11 19 68 7b 4a
# =zero (unwritten c and padding stay 00)
partial after a+b writes: 58 00 00 00 44 33 22 11 00 00 00 00
# =pattern (unwritten c stays 0xFE; padding 00)
partial after a+b writes: 58 00 00 00 44 33 22 11 fe 00 00 00
```

Without the flag, writing two fields does **not** scrub the rest of the object. `memcmp`, `memcpy` of the whole struct, hashing, or putting the bytes on the wire will ship padding and untouched members. With `=zero`, the unwritten pieces stay zero after the compiler's inserted init — until you overwrite them.

### Case 3: unions

```c
union U {
    uint32_t w;
    unsigned char bytes[4];
};

__attribute__((noinline, optimize("O0"))) void show_union(const char *label) {
    union U u; /* no initializer */
    printf("%s union bytes:", label);
    for (int i = 0; i < 4; i++) printf(" %02x", u.bytes[i]);
    putchar('\n');
}
```

```text
# default (example)
union union bytes: 00 02 00 00
# =zero
union union bytes: 00 00 00 00
# =pattern
union union bytes: fe fe fe fe
```

For *uninitialized* autos, trivial-auto-var-init covers the storage. For **explicitly initialized** unions/structs, C's rules about padding are a different story: GCC 15 changed some cases where union padding used to be zeroed and introduced `-fzero-init-padding-bits=`. On GCC 14.2 that flag does not exist (`unrecognized command-line option`). If you need every byte zero under an initializer, `memset(&obj, 0, sizeof obj)` or C23 `{}` remain the portable hammers.

### Case 4: warnings do not go away

```bash
gcc -O0 -Wall -ftrivial-auto-var-init=zero tav_demo.c -o /dev/null
```

You will still see `-Wmaybe-uninitialized` (and friends) on reads of `s` / `u`. That is intentional per GCC docs: the program is patched for safety, but the language-level "this was never initialized" analysis remains. Do not use the flag as an excuse to ignore warnings on hot paths you own.

## The trap

- **Believing `{0}` always zeros padding for automatic structs.** Static-duration objects get zeroed storage; automatic padding has historically been the weak spot. Trivial-auto-var-init helps the *uninitialized* case; explicit initializers need their own discipline (`memset`, C23 `{}`, or GCC 15+ padding flags).  
- **Shipping `=pattern` to production.** 0xFE is for crashing loudly in test builds. Production hardening usually wants `=zero`.  
- **Assuming cost is free.** The compiler inserts stores (often `memset`-shaped). Measure on your hot functions; prefer enabling it globally in security builds and opting out only where profiles demand.  
- **Locals declared between `switch (x)` and the first `case`.** GCC documents that the current implementation cannot initialize those; `-Wtrivial-auto-var-init` reports them. Move declarations into the case scopes or before the switch.  
- **Thinking the flag initializes heap memory.** It does not. `malloc` is still raw; use `calloc` / `memset`.

## The boring rule

New code: initialize on declaration (`= {0}`, C23 `{}`, or real values). Large legacy trees: compile with `-ftrivial-auto-var-init=zero` in hardened profiles, keep `-Wall -Wextra`, and `memset` any object you put on the wire or compare by raw bytes. Re-check GCC release notes when you jump majors — padding knobs have been moving.

## Try this

1. Run Case 1 on your laptop GCC/Clang; confirm `=pattern` padding zeros.  
2. Add `-Wtrivial-auto-var-init` to a `switch`-heavy file and fix any reported locals.  
3. Benchmark one allocator-heavy translation unit with and without `=zero` at `-O2`.

## Sources

- GCC Optimize Options — `-ftrivial-auto-var-init`: <https://gcc.gnu.org/onlinedocs/gcc-14.2.0/gcc/Optimize-Options.html#index-ftrivial-auto-var-init>  
- GCC 15 changes (padding / `-fzero-init-padding-bits`): <https://gcc.gnu.org/gcc-15/changes.html>  
- Memfault — C structure padding initialization (background): <https://interrupt.memfault.com/blog/c-struct-padding-initialization>  
