# C23 `#embed`, `nullptr`, and `constexpr`

## Overview

C23 (ISO/IEC 9899:2024) finally gives C three everyday tools other languages took for granted: **binary assets as first-class data** (`#embed`), a distinct **null pointer constant** (`nullptr`), and **`constexpr` objects** for values fixed at translation time. The overview chapter in this part mentions them briefly; this page is the operator-depth pass — what to type, what the compiler guarantees, and how to keep builds portable while toolchains catch up.

Baseline for the labs: **GCC 14+** or **Clang 19+** with `-std=c23` (or `-std=gnu23`). Check your compiler before relying on `#embed` in CI.

```bash
cc -std=c23 -Wall -Wextra -O2 embed_demo.c -o embed_demo
```

## `#embed` — ship bytes without `xxd` hacks

`#embed` is a preprocessor directive that injects the contents of a file as a comma-separated list of integer constant expressions (by default, `unsigned char` values). Typical use: icons, small lookup tables, default config blobs, shader snippets — anything you used to generate with `xxd -i` or `ld -r -b binary`.

### Basic embed into an array

```c
/* embed_demo.c — C23 */
#include <stdio.h>
#include <stddef.h>

static const unsigned char logo[] = {
#embed "logo.png"
};

int main(void) {
    printf("logo.png: %zu bytes\n", sizeof logo);
    if (sizeof logo >= 8) {
        printf("header:");
        for (size_t i = 0; i < 8; i++) {
            printf(" %02x", logo[i]);
        }
        puts("");
    }
    return 0;
}
```

Place a small `logo.png` next to the source (or pass an absolute path). The array length is exactly the file size. Rebuilding picks up file changes — no separate codegen step.

### Resource limits and empty files

```c
/* Truncate or reject oversized assets at compile time */
static const unsigned char tip[] = {
#embed "tip.txt" limit(256)
};

/* Optional: custom empty-file expansion */
static const int maybe_empty[] = {
#embed "optional.bin" if_empty(0)
};
```

| Clause | Meaning |
|--------|---------|
| `limit(N)` | Embed at most `N` elements; longer files are truncated for the directive (prefer failing the build in policy if truncation is unsafe — see Notes) |
| `prefix(…)` / `suffix(…)` | Extra constant expressions before/after the file bytes |
| `if_empty(…)` | Replacement list when the file has zero size |
| `offset(N)` (where supported) | Skip the first `N` bytes — confirm against your compiler’s C23 embed support matrix |

`#embed` paths are resolved like include paths (implementation-defined search rules; quote form usually searches relative to the current file). Keep assets inside the repo; do not `#embed` secrets from a home directory in shared builds.

### When not to use `#embed`

- Multi-megabyte assets: prefer runtime files or `mmap` unless you intentionally want them in the binary.
- Generated code that must stay human-editable as C — keep a `.c` file.
- Toolchains stuck on C17: fall back to `xxd -i` or a small Python codegen in the Makefile until CI compilers move.

## `nullptr` — a real null pointer constant

Historically `NULL` was `0` or `(void*)0`, which made overload-like `_Generic` selections and some warnings awkward. C23 adds `nullptr` of type `nullptr_t` (from `<stddef.h>`), which **only** converts to pointer types.

```c
#include <stddef.h>
#include <stdio.h>

void greet(const char *name) {
    if (name == nullptr) {
        puts("hello, stranger");
        return;
    }
    printf("hello, %s\n", name);
}

int main(void) {
    greet(nullptr);
    greet("desk");
    /* nullptr is not an integer — good */
    /* int x = nullptr; */  /* constraint violation */
    return 0;
}
```

Prefer `nullptr` in new C23 code. `NULL` remains valid for compatibility. In headers shared with C++, `nullptr` matches C++ spelling and intent.

## `constexpr` objects

C23 `constexpr` on object definitions requires an initializer that is a constant expression, and the object may be used in contexts that need true constants (where an ordinary `const` integer sometimes was not enough for every implementation).

```c
#include <stdio.h>

constexpr int max_widgets = 64;
constexpr unsigned mask = (1u << 5) - 1u;

static int table[max_widgets]; /* size is a real constant */

int main(void) {
    printf("max=%d mask=%u\n", max_widgets, mask);
    return 0;
}
```

Use `constexpr` for protocol limits, shift masks, and array sizes you previously stuffed into `#define` macros. Macros remain appropriate for token pasting and include guards; prefer `constexpr` for typed values.

## Combined sketch

```c
/* banner.c — C23 */
#include <stddef.h>
#include <stdio.h>

constexpr size_t banner_cap = 128;

static const unsigned char banner[] = {
#embed "banner.txt" limit(banner_cap)
};

void print_banner(const unsigned char *p, size_t n) {
    if (p == nullptr || n == 0) {
        return;
    }
    fwrite(p, 1, n, stdout);
}

int main(void) {
    print_banner(banner, sizeof banner);
    return 0;
}
```

## Portability checklist

| Feature | Gate |
|---------|------|
| Language mode | `-std=c23` / `__STDC_VERSION__ >= 202311L` |
| `#embed` | Compiler + version matrix; provide `xxd` fallback in Makefile for older CI |
| `nullptr` | C23; polyfill as `#define nullptr ((void*)0)` only in transitional headers with care |
| `constexpr` | C23; older code keeps `#define` or `enum` constants |

```c
#if __STDC_VERSION__ >= 202311L
#  define DESK_NULL nullptr
#else
#  define DESK_NULL NULL
#endif
```

## Safety

- Do not `#embed` credentials, private keys, or production `.env` files into binaries you distribute.
- Treat `#embed` data as **untrusted input** if the file can be replaced in the build environment — validate magic headers at runtime when it matters.
- `nullptr` checks do not replace bounds checks on the objects you open after a non-null test.
- Huge embeds inflate binaries and caches; budget size like any other asset pipeline.

## Try this

1. Create `tip.txt`, embed it with and without `limit(16)`, and print `sizeof` both ways.
2. Compile a one-line `int x = nullptr;` under `-std=c23` and read the diagnostic.
3. Replace a `#define MAX 32` array size with `constexpr int max = 32;` and confirm the project still builds at `-std=c23`.
4. Add a Makefile rule: if the compiler rejects `#embed`, generate `logo.h` with `xxd -i` as a fallback and document the flag that flips modes.

## Sources

- ISO/IEC 9899:2024 (C23) — `#embed`, `nullptr` / `nullptr_t`, `constexpr` objects
- [cppreference — `#embed`](https://en.cppreference.com/w/c/preprocessor/embed)
- [cppreference — `nullptr`](https://en.cppreference.com/w/c/language/nullptr)
- GCC / Clang C23 status notes for your distro toolchain (`cc --version`)
