---
title: "GCC 16: What Changed for C"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# GCC 16: What Changed for C

## Thesis

GCC **16.1** shipped on **30 April 2026**. The headline everyone saw on social media was the C++ default flipping from GNU C++17 to GNU C++20. That matters for C++ shops. For **C** shops the story is quieter but not empty: new GNU extensions (`_Maxof` / `_Minof`, richer `counted_by`), more C2y diagnostics treated as constraint violations, SARIF becoming the only machine-readable diagnostic sink (`json` removed), and stricter levels for `-Wunused-but-set-*` when you enable `-Wall` / `-Wextra`.

This chapter is the C migration checklist. It cites the [GCC 16 changes page](https://gcc.gnu.org/gcc-16/changes.html) and the companion porting notes. **GCC 16 is not installed on this lab box** (Debian ships **14.2.0**). Runnable probes below use 14.2; GCC 16 behaviour is documented from upstream, not invented.

## Where things stand (2026-10)

| Toolchain | Status for this chapter |
|-----------|-------------------------|
| **GCC 14.2.0** (Debian on this lab) | Default C dialect is **GNU C17**. `-ftrivial-auto-var-init` and C23 flags work; no `_Maxof` / `_Minof`. |
| **GCC 15** | Default C dialect moved to **GNU C23** (`-std=gnu23`). Still the baseline many distros will hold through late 2026. |
| **GCC 16.1 / 16.2** | C++ default → `gnu++20`. C keeps the C23-era default; adds the C section features listed below. Do **not** assume "builds on 15 ⇒ builds on 16" without pinning `-std=` and re-reading warnings. |

## Mental model

```text
  Your Makefile / meson / cmake
           │
           ├─ never pins -std= …  →  you silently inherit the compiler default
           │                         (C17 on GCC 14, C23/gnu23 on 15+, C++20 on GCC 16++)
           └─ pins -std=gnu23 / c23 / gnu17 …
                                     →  behaviour-stable across toolchain bumps

  Machine-readable diagnostics
           │
           ├─ GCC ≤15:  -fdiagnostics-format=json   (removed in 16)
           └─ GCC 16+:  SARIF only (−fdiagnostics-format=sarif / add-output=sarif)
```

| Rule | Consequence |
|------|-------------|
| Pin the language dialect in the build | A default change never surprises CI |
| Treat warning-level bumps as build breaks | `-Werror` plus stricter unused-but-set levels will fail overnight |
| Prefer SARIF for bots | Text scrapers and the old `json` sink die with GCC 16 |
| Read the **C** section of the changes page | Do not migrate a C codebase off C++-only advice |

## What actually changed for C in GCC 16

From the official **C** section of the GCC 16 changes page (mirrored; `gcc.gnu.org` sometimes returns 403 to automated fetchers):

### GNU extensions

1. **`counted_by` on pointer members.** The attribute that tells the analyzer / bounds sanitizers how long a flexible array is can now annotate **pointer** members as well as flexible-array members. Useful for "pointer + length" structs that never used a trailing array.
2. **`_Maxof` and `_Minof`.** Operators that yield the maximum / minimum representable value of an integer type — the compile-time cousin of `<limits.h>` macros, without naming the type twice.
3. **Compound literals with empty initializers and a variable size.** A VLA-shaped compound literal ` (T[n]){} ` is now accepted where the older front end rejected it.
4. **Nested functions that do not touch the enclosing frame** are guaranteed **not** to need a trampoline, even at `-O0`. That removes a classic executable-stack surprise for pure helpers nested for scope only.

### C2y alignment

GCC 16 also lands more of the C2y draft:

- Static assertions usable **inside expressions**.
- Unspecified and variably-modified arrays usable as type names in `_Generic` associations.
- Situations that were silent undefined behaviour in older modes and are now **constraint violations** (hard diagnostics).

None of these require you to pass `-std=c2y` tomorrow morning; they matter when you *do* raise the dialect and when you read new errors on old code.

### Diagnostics and tooling (C and C++ share these)

- The diagnostic format named **`json`** for `-fdiagnostics-format=` is **removed**. Machine consumers must move to **SARIF**.
- SARIF sinks respect the dump / output directory, nest logical locations, and can carry control-flow kinds (`throw`, `catch`, `setjmp`, …).
- Optional HTML diagnostic output via `-fdiagnostics-add-output=experimental-html`.
- `-fanalyzer` gained more C++ awareness; for pure C it remains useful. New `-fanalyzer-assume-nothrow` quiets exception-shaped assumptions when you compile C with `-fexceptions` only for C++ interop.

### Warnings: unused-but-set levels

The porting guide (community write-ups quoting it, including the ELCSoftware migration note of 3 May 2026) documents that **`-Wunused-but-set-variable`** and **`-Wunused-but-set-parameter`** now have **levels**, and the defaults attached to `-Wall` / `-Wextra` are **stricter**. Patterns that only touch a variable through `++` / `--` / compound assignment can newly warn. Mitigation if you cannot fix the code yet:

```bash
-Wunused-but-set-variable=1 -Wunused-but-set-parameter=1
```

Prefer deleting the dead store, using the value, or `(void)x`.

## Worked examples

All runnable cases: **GCC 14.2.0** on x86_64 Linux (Debian). Cases marked "docs only" describe GCC 16 APIs that 14.2 does not implement.

### Case 0: what default dialect do we actually get?

```bash
# probe_default_std.sh — ask cc1 what language it thinks it is compiling
echo 'int main(void){return 0;}' > /tmp/probe.c
gcc -v -c /tmp/probe.c -o /tmp/probe.o 2>&1 | grep 'GNU C'
```

```text
GNU C17 (Debian 14.2.0-19) version 14.2.0 (x86_64-linux-gnu)
```

On this box the default is still **C17**. On a GCC 15/16 install you should see **GNU C23** (or whichever default that release documents). Pin anyway:

```bash
CFLAGS ?= -std=gnu23 -Wall -Wextra
```

### Case 1: pin the standard so GCC 16 cannot surprise you

```c
/* pin_std.c — force the dialect; works on 14, 15, and 16 */
#if !defined(__STDC_VERSION__)
#  error "expected a C compiler"
#endif

#include <stdio.h>

int main(void) {
    printf("STDC_VERSION=%ld\n", (long)__STDC_VERSION__);
#if defined(__GNUC__)
    printf("GCC %d.%d\n", __GNUC__, __GNUC_MINOR__);
#endif
    return 0;
}
```

```bash
gcc -std=gnu17 pin_std.c -o pin17 && ./pin17
gcc -std=gnu23 pin_std.c -o pin23 && ./pin23
```

Representative output on GCC 14.2:

```text
STDC_VERSION=201710
GCC 14.2
STDC_VERSION=202000
GCC 14.2
```

(`202000L` is GCC's current stand-in for C23; the exact macro value can move as WG14 finalises.)

### Case 2: `_Maxof` / `_Minof` (GCC 16 — docs only on this lab)

```c
/* maxof_demo.c — requires GCC 16+; will not compile on 14.2 */
#include <stdio.h>

int main(void) {
    printf("max int = %d\n", (int)_Maxof(int));
    printf("min int = %d\n", (int)_Minof(int));
    printf("max unsigned = %u\n", (unsigned)_Maxof(unsigned));
    return 0;
}
```

```bash
# On this lab (GCC 14.2):
gcc -std=gnu23 maxof_demo.c -o maxof_demo
# error: '_Maxof' undeclared (expected — feature is GCC 16)

# On GCC 16 (from docs; not run here):
# gcc-16 -std=gnu23 maxof_demo.c -o maxof_demo && ./maxof_demo
```

Honest status: **not run** — GCC 16 is not installed, and this scout run must not `apt install` toolchains. When you have `gcc-16`, the listing above is the smoke test.

### Case 3: `counted_by` on a pointer member (shape for GCC 16)

```c
/* counted_by_ptr.c — attribute shape; analyzer benefit is GCC 16+ */
#include <stddef.h>
#include <stdlib.h>

struct Buf {
    size_t n;
    char *data __attribute__((counted_by(n)));
};

struct Buf *make(size_t n) {
    struct Buf *b = malloc(sizeof *b);
    if (!b) return NULL;
    b->n = n;
    b->data = calloc(n, 1);
    if (!b->data) { free(b); return NULL; }
    return b;
}
```

On older GCC the attribute on a **pointer** member was ignored or rejected; GCC 16 documents pointer-member support. Keep the length field authoritative and update it before the pointer when you grow the buffer — the attribute does not magically track realloc.

### Case 4: SARIF instead of `json`

```bash
# Before GCC 16 (still works on 14.2):
gcc -fdiagnostics-format=json -c pin_std.c -o /tmp/x.o 2>&1 | head -c 120; echo

# GCC 16 migration (docs; flag names from the changes page):
# gcc-16 -fdiagnostics-add-output=sarif -c pin_std.c -o build/pin_std.o
# → writes build/pin_std.c.sarif next to the object (dump-dir aware)
```

If an internal bot still passes `-fdiagnostics-format=json`, it will fail hard on GCC 16. Switch the consumer to SARIF before the toolchain bump, not after.

### Case 5: unused-but-set under `-Wall`

```c
/* unused_but_set.c */
int f(int x) {
    int y = x;
    y++;          /* value of y never read */
    return x;
}
```

```bash
gcc -Wall -Wextra -c unused_but_set.c -o /tmp/ubs.o 2>&1 || true
```

On **GCC 14.2** this particular pattern may still be silent depending on exact warning configuration (observed: no diagnostic on this lab). On **GCC 16**, porting notes warn that the default level attached to `-Wall`/`-Wextra` is stricter and can flag increments that never feed a read. Fix the code; only then dial the level back.

## The trap

- **Reading a C++ migration thread and applying it to C.** `concept` / `requires` as identifiers, `operator!=` synthesis, `char8_t` — those are C++20 problems. Your `.c` files do not care. Your shared headers compiled as C++ might.
- **Assuming the lab GCC is the release you are writing policy for.** Document the version in the PR / runbook: "verified on 14.2; required on 16.1+".
- **Leaving diagnostic scrapers on `json`.** That format is gone in 16; the failure mode is empty annotations, not a soft warning.
- **Installing GCC 16 with `apt`/`sudo` in a scout sandbox.** Policy for these books: cite upstream and skip the install. Reproduce on a real workstation or CI image that already has the toolchain.

## The boring rule

Pin `-std=` (usually `-std=gnu23` for new C), pin warning policy, migrate bots to SARIF **before** the GCC 16 bump, and treat every new `_Maxof` / `counted_by` use as an explicit dependency on GCC ≥ 16.

## Try this

1. Print your CI image's `gcc -v` line and record the default `GNU Cxx` dialect.
2. Add `-std=gnu23 -Wall -Wextra` to a leaf library and fix what breaks on your current compiler first.
3. Point one diagnostic consumer at SARIF on GCC 15 (where both sinks may still exist) so the GCC 16 cut-over is a no-op.
4. When you do get `gcc-16`, compile Case 2 and Case 3 and paste the real output into this chapter's next revision.

## Sources

- [GCC 16 Release Series — Changes](https://gcc.gnu.org/gcc-16/changes.html) (also mirrored at `gcc.sourceware.org`)
- Porting to GCC 16 (linked from the changes page; same 403 caveats on some fetchers)
- Community migration notes summarising the porting guide (e.g. ELCSoftware, 3 May 2026) for warning-level details
- Inspiration: [linuxiac on X — GCC 16.1 / C++20 default](https://x.com/linuxiac/status/2050911413183434803) (C++ headline; this chapter covers the C side)
