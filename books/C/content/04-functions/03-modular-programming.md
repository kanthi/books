# Modular Programming

## Introduction

Modular programming organizes code into separate, independent modules that combine into a complete program. In C, you achieve this with header files, source files, and careful linkage. The payoff is reusability, maintainability, and clear separation of concerns.

This chapter walks through a full multi-module project, a production-style Makefile, `static` vs `extern`, static and shared libraries, header design, opaque types, and include hygiene — all with code that compiles under:

```bash
gcc -std=c17 -Wall -Wextra
```

## Header Files and Source Files

### Header Files (`.h`)

Headers declare the **interface** the rest of the program can see:

- Function prototypes
- Type definitions (`struct`, `union`, `enum`, `typedef`)
- Macro definitions
- Global variable **declarations** (`extern`)
- Includes of other headers the interface needs

### Source Files (`.c`)

Source files provide the **implementation**:

- Function definitions
- Global variable **definitions**
- File-scope helpers marked `static`
- Algorithms and data

### Example Layout

```text
project/
  include/
    strstats.h
  src/
    strstats.c
    main.c
  Makefile
```

## Include Guards

Include guards prevent a header from being processed more than once in a translation unit (which would cause redefinition errors).

### Traditional Include Guards

```c
#ifndef STRSTATS_H
#define STRSTATS_H

// Header content goes here

#endif /* STRSTATS_H */
```

### `#pragma once` (Non-standard, Widely Supported)

```c
#pragma once

// Header content goes here
```

Prefer traditional guards for maximum portability; many codebases use both.

## Compilation Units and Linking

Each `.c` file is a **translation unit**. The compiler turns it into an object file (`.o`). The linker then combines object files, resolves symbols, and produces the executable (or library).

```bash
# Compile each unit separately
gcc -std=c17 -Wall -Wextra -c strstats.c -o strstats.o
gcc -std=c17 -Wall -Wextra -c main.c -o main.o

# Link
gcc strstats.o main.o -o program
```

Pipeline summary:

1. **Compile** — syntax check, generate machine code, emit undefined external references
2. **Link** — match calls to definitions, bind addresses, pull in libraries
3. **Load / run** — OS maps the binary and starts `main`

## Linkage: `extern`, `static`, and No Linkage

### External Linkage (Default for File-Scope Functions)

Symbols with external linkage are visible across translation units. Function names at file scope have external linkage by default. Global variables need an `extern` declaration in a header and exactly one definition in one `.c` file.

```c
/* config.h */
#ifndef CONFIG_H
#define CONFIG_H

extern int g_verbose;          /* declaration — many TUs may include this */
int parse_args(int argc, char **argv);

#endif
```

```c
/* config.c */
#include "config.h"

int g_verbose = 0;             /* definition — exactly once in the program */

int parse_args(int argc, char **argv) {
    for (int i = 1; i < argc; i++) {
        if (argv[i][0] == '-' && argv[i][1] == 'v') {
            g_verbose = 1;
        }
    }
    return 0;
}
```

```c
/* main.c */
#include <stdio.h>
#include "config.h"

int main(int argc, char **argv) {
    parse_args(argc, argv);
    if (g_verbose) {
        printf("verbose mode on\n");
    }
    return 0;
}
```

Build:

```bash
gcc -std=c17 -Wall -Wextra -c config.c -o config.o
gcc -std=c17 -Wall -Wextra -c main.c -o main.o
gcc config.o main.o -o config_demo
./config_demo -v
```

### Internal Linkage (`static` at File Scope)

`static` on a file-scope function or variable restricts it to that translation unit. Other `.c` files cannot call or see it — even if they somehow declare the same name.

```c
/* helpers.c */
#include <stdio.h>

/* Only visible inside helpers.c */
static int clamp(int x, int lo, int hi) {
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

static int call_count = 0;   /* private counter */

int public_scale(int x) {
    call_count++;
    return clamp(x, 0, 100);
}

void public_report(void) {
    printf("public_scale called %d times\n", call_count);
}
```

```c
/* main.c — cannot call clamp(); link would fail if it tried */
#include <stdio.h>

int public_scale(int x);
void public_report(void);

int main(void) {
    printf("%d\n", public_scale(150));  /* 100 */
    printf("%d\n", public_scale(-5));   /* 0 */
    public_report();
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra helpers.c main.c -o static_demo
./static_demo
```

### `static` vs `extern` at a Glance

| Keyword / form | Scope | Linkage | Typical use |
|----------------|-------|---------|-------------|
| `int foo(void);` in header | program | external | public API |
| `static int helper(void)` in `.c` | one `.c` file | internal | private helper |
| `extern int g;` in header | program | external | shared global (use sparingly) |
| `static int g;` in `.c` | one `.c` file | internal | module-private state |
| local `int x;` in a function | block | none | ordinary local |

### No Linkage

Parameters and locals have **no linkage**. Each function invocation gets its own stack storage; names are not visible outside the block.

## Complete Multi-Module Project: `string_stats`

A small library that analyzes C strings: length, word count, letter/digit counts, and case-folded copy. Public API lives in a header; implementation and private helpers stay in the `.c` file.

### Project Tree

```text
string_stats/
  strstats.h
  strstats.c
  main.c
  Makefile
```

### `strstats.h` — Public Interface

```c
#ifndef STRSTATS_H
#define STRSTATS_H

#include <stddef.h>  /* size_t */

typedef struct {
    size_t length;       /* characters, excluding '\0' */
    size_t words;        /* whitespace-separated tokens */
    size_t letters;
    size_t digits;
    size_t spaces;
    size_t others;
} StrStats;

/* Analyze src; returns 0 on success, -1 if src is NULL. */
int strstats_analyze(const char *src, StrStats *out);

/* Print a human-readable report to stdout. */
void strstats_print(const StrStats *s);

/*
 * Copy src into dest, converting A–Z to a–z.
 * dest_size is the full buffer size (including room for '\0').
 * Returns 0 on success, -1 on NULL args or if dest is too small.
 */
int strstats_to_lower(char *dest, size_t dest_size, const char *src);

#endif /* STRSTATS_H */
```

### `strstats.c` — Implementation

```c
#include "strstats.h"

#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* File-private: not declared in the header. */
static int is_word_char(unsigned char c) {
    return !isspace(c);
}

int strstats_analyze(const char *src, StrStats *out) {
    if (src == NULL || out == NULL) {
        return -1;
    }

    memset(out, 0, sizeof(*out));

    int in_word = 0;
    for (size_t i = 0; src[i] != '\0'; i++) {
        unsigned char c = (unsigned char)src[i];
        out->length++;

        if (isalpha(c)) {
            out->letters++;
        } else if (isdigit(c)) {
            out->digits++;
        } else if (isspace(c)) {
            out->spaces++;
        } else {
            out->others++;
        }

        if (is_word_char(c)) {
            if (!in_word) {
                out->words++;
                in_word = 1;
            }
        } else {
            in_word = 0;
        }
    }
    return 0;
}

void strstats_print(const StrStats *s) {
    if (s == NULL) {
        return;
    }
    printf("length  : %zu\n", s->length);
    printf("words   : %zu\n", s->words);
    printf("letters : %zu\n", s->letters);
    printf("digits  : %zu\n", s->digits);
    printf("spaces  : %zu\n", s->spaces);
    printf("others  : %zu\n", s->others);
}

int strstats_to_lower(char *dest, size_t dest_size, const char *src) {
    if (dest == NULL || src == NULL || dest_size == 0) {
        return -1;
    }

    size_t need = strlen(src) + 1; /* include '\0' */
    if (need > dest_size) {
        return -1;
    }

    for (size_t i = 0; src[i] != '\0'; i++) {
        dest[i] = (char)tolower((unsigned char)src[i]);
    }
    dest[need - 1] = '\0';
    return 0;
}
```

### `main.c` — Driver

```c
#include <stdio.h>

#include "strstats.h"

int main(void) {
    const char *sample = "Hello, C17 World! 42 cats.";
    StrStats stats;

    if (strstats_analyze(sample, &stats) != 0) {
        fprintf(stderr, "analyze failed\n");
        return 1;
    }

    printf("Input: \"%s\"\n\n", sample);
    strstats_print(&stats);

    char lower[128];
    if (strstats_to_lower(lower, sizeof lower, sample) != 0) {
        fprintf(stderr, "to_lower failed\n");
        return 1;
    }
    printf("\nlower: \"%s\"\n", lower);
    return 0;
}
```

### Manual Build

```bash
gcc -std=c17 -Wall -Wextra -c strstats.c -o strstats.o
gcc -std=c17 -Wall -Wextra -c main.c -o main.o
gcc strstats.o main.o -o string_stats
./string_stats
```

Expected output (abbreviated):

```text
Input: "Hello, C17 World! 42 cats."

length  : 26
words   : 5
letters : 15
digits  : 2
...
lower: "hello, c17 world! 42 cats."
```

## Full Makefile: Debug, Release, and `-MMD` Dependencies

A Makefile that scales beyond one file: separate build directories, automatic header dependency tracking, and clean targets.

```makefile
# Makefile for string_stats
CC      := gcc
STD     := -std=c17
WARN    := -Wall -Wextra -Wpedantic
SRCS    := strstats.c main.c
OBJS    := $(SRCS:.c=.o)
DEPS    := $(OBJS:.o=.d)

TARGET  := string_stats

# Default = debug
BUILD   ?= debug

ifeq ($(BUILD),release)
  CFLAGS  := $(STD) $(WARN) -O2 -DNDEBUG
else
  CFLAGS  := $(STD) $(WARN) -g -O0
endif

# -MMD: write .d dependency files; -MP: phony headers so deletes don't break make
DEPFLAGS := -MMD -MP

.PHONY: all debug release clean run

all: $(TARGET)

debug:
	$(MAKE) BUILD=debug

release:
	$(MAKE) BUILD=release

$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $@

%.o: %.c
	$(CC) $(CFLAGS) $(DEPFLAGS) -c $< -o $@

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJS) $(DEPS) $(TARGET)

# Pull in generated dependency fragments (if present)
-include $(DEPS)
```

Usage:

```bash
make              # debug build
make release      # optimized
make run
make clean
```

Why `-MMD -MP` matters: if you edit `strstats.h`, Make recompiles every `.c` that includes it — without you listing headers by hand.

### Variant with `build/` Directory

```makefile
CC      := gcc
CFLAGS  := -std=c17 -Wall -Wextra -g -O0 -MMD -MP
SRCS    := strstats.c main.c
BUILD   := build
OBJS    := $(addprefix $(BUILD)/,$(SRCS:.c=.o))
DEPS    := $(OBJS:.o=.d)
TARGET  := $(BUILD)/string_stats

.PHONY: all clean

all: $(TARGET)

$(TARGET): $(OBJS) | $(BUILD)
	$(CC) $(OBJS) -o $@

$(BUILD)/%.o: %.c | $(BUILD)
	$(CC) $(CFLAGS) -c $< -o $@

$(BUILD):
	mkdir -p $(BUILD)

clean:
	rm -rf $(BUILD)

-include $(DEPS)
```

## Creating Libraries

### Static Library (`.a`)

Object code is copied into the final executable at link time. No runtime dependency on the `.a` file.

```bash
# Compile objects
gcc -std=c17 -Wall -Wextra -c strstats.c -o strstats.o

# Archive into libstrstats.a
#   r = replace/insert, c = create if needed, s = write symbol index
ar rcs libstrstats.a strstats.o

# Link: -L. looks in current dir; -lstrstats finds libstrstats.a
gcc -std=c17 -Wall -Wextra main.c -L. -lstrstats -o string_stats_static

./string_stats_static
```

Inspect the archive:

```bash
ar t libstrstats.a          # list members
nm libstrstats.a | head     # symbols
```

### Shared Library (`.so` on Linux / macOS)

Shared libraries are loaded at runtime and can be shared by multiple processes.

```bash
# Position-independent code is required for shared objects
gcc -std=c17 -Wall -Wextra -fPIC -c strstats.c -o strstats.o

# Build the shared library
gcc -shared -o libstrstats.so strstats.o

# Link the program against it
gcc -std=c17 -Wall -Wextra main.c -L. -lstrstats -o string_stats_shared

# Runtime: loader must find libstrstats.so
# Linux:
export LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH
# macOS:
export DYLD_LIBRARY_PATH=.:$DYLD_LIBRARY_PATH

./string_stats_shared
```

Check linkage:

```bash
# Linux
ldd ./string_stats_shared
# macOS
otool -L ./string_stats_shared
```

### Static vs Shared

| | Static (`.a`) | Shared (`.so`) |
|--|---------------|----------------|
| Linked when | Build time | Load / run time |
| Binary size | Larger (code copied in) | Smaller |
| Updates | Rebuild app to pick up lib fix | Replace `.so`, restart app |
| Deploy | Single executable (simpler) | Ship binary + libraries |

## Header Design Rules

1. **Headers declare; sources define.** Do not put non-`inline` function bodies or non-`static` data definitions in headers (except `static inline` helpers when appropriate).
2. **Self-contained.** A header should compile after `#include "foo.h"` alone — include what *it* needs (`stddef.h` for `size_t`, etc.).
3. **Include what you use** in `.c` files; do not rely on transitive includes from other headers.
4. **Minimize public surface.** Prefer incomplete types / opaque pointers for private structs.
5. **One module, one header** as a default; split only when the API is large.
6. **Document contracts** in comments: preconditions, ownership, error returns.
7. **Avoid `using` the preprocessor for “namespaces”** beyond a clear prefix (`strstats_`, `vec_`).
8. **Never `#include` a `.c` file** in normal modular code.

### Recommended Include Order

A common, readable order inside a `.c` file:

```c
/* 1. Related header first — proves the header is self-contained */
#include "strstats.h"

/* 2. Other project headers */
#include "config.h"

/* 3. Standard library headers (alphabetical is fine) */
#include <ctype.h>
#include <stdio.h>
#include <string.h>

/* 4. System / third-party headers */
/* #include <unistd.h> */
```

Why related header first: if `strstats.h` forgets a needed include, the compiler fails when compiling `strstats.c` — not later, deep in some other unit.

### Forward Declarations

When you only need a pointer or reference to a type, forward-declare instead of including a heavy header:

```c
/* log.h — does not need the full definition of StrStats */
#ifndef LOG_H
#define LOG_H

struct StrStats;   /* forward declaration (incomplete type) */

void log_stats(const struct StrStats *s);

#endif
```

```c
/* log.c — full type only needed where members are accessed */
#include "log.h"
#include "strstats.h"
#include <stdio.h>

void log_stats(const struct StrStats *s) {
    if (s == NULL) {
        return;
    }
    printf("[log] length=%zu words=%zu\n", s->length, s->words);
}
```

Forward declarations break circular header dependencies and speed up compiles.

## Opaque Pointers / Incomplete Types

Hide the real struct layout so callers cannot poke private fields. The header only names the type; the `.c` file owns the definition.

### `vector.h`

```c
#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>

typedef struct Vector Vector;   /* incomplete — no members visible */

Vector *vector_create(void);
void    vector_destroy(Vector *v);

int     vector_push(Vector *v, double x);   /* 0 ok, -1 OOM / NULL */
size_t  vector_size(const Vector *v);
int     vector_get(const Vector *v, size_t i, double *out);  /* 0 ok, -1 bad index */
void    vector_clear(Vector *v);

#endif /* VECTOR_H */
```

### `vector.c`

```c
#include "vector.h"

#include <stdlib.h>
#include <string.h>

struct Vector {
    double *data;
    size_t  size;
    size_t  capacity;
};

Vector *vector_create(void) {
    Vector *v = calloc(1, sizeof *v);
    return v;  /* NULL if OOM */
}

void vector_destroy(Vector *v) {
    if (v == NULL) {
        return;
    }
    free(v->data);
    free(v);
}

int vector_push(Vector *v, double x) {
    if (v == NULL) {
        return -1;
    }
    if (v->size == v->capacity) {
        size_t new_cap = (v->capacity == 0) ? 8 : v->capacity * 2;
        double *p = realloc(v->data, new_cap * sizeof *p);
        if (p == NULL) {
            return -1;
        }
        v->data = p;
        v->capacity = new_cap;
    }
    v->data[v->size++] = x;
    return 0;
}

size_t vector_size(const Vector *v) {
    return v ? v->size : 0;
}

int vector_get(const Vector *v, size_t i, double *out) {
    if (v == NULL || out == NULL || i >= v->size) {
        return -1;
    }
    *out = v->data[i];
    return 0;
}

void vector_clear(Vector *v) {
    if (v) {
        v->size = 0;
    }
}
```

### `main_vector.c`

```c
#include <stdio.h>
#include "vector.h"

int main(void) {
    Vector *v = vector_create();
    if (v == NULL) {
        return 1;
    }

    vector_push(v, 1.5);
    vector_push(v, 2.5);
    vector_push(v, 3.0);

    for (size_t i = 0; i < vector_size(v); i++) {
        double x;
        if (vector_get(v, i, &x) == 0) {
            printf("v[%zu] = %.1f\n", i, x);
        }
    }

    /* This would NOT compile — incomplete type:
       printf("%zu\n", v->size);
    */

    vector_destroy(v);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra vector.c main_vector.c -o vector_demo
./vector_demo
```

Benefits: you can change `struct Vector` internals without breaking callers, and you force all access through a documented API.

## Alternate Multi-Module Example: 2D Vector Math

Same patterns, different domain — useful if you prefer numeric code over string stats.

### `vec2.h`

```c
#ifndef VEC2_H
#define VEC2_H

typedef struct {
    double x;
    double y;
} Vec2;

Vec2   vec2_add(Vec2 a, Vec2 b);
Vec2   vec2_sub(Vec2 a, Vec2 b);
Vec2   vec2_scale(Vec2 a, double s);
double vec2_dot(Vec2 a, Vec2 b);
double vec2_length(Vec2 a);
void   vec2_print(const char *label, Vec2 a);

#endif
```

### `vec2.c`

```c
#include "vec2.h"

#include <math.h>
#include <stdio.h>

Vec2 vec2_add(Vec2 a, Vec2 b) {
    return (Vec2){a.x + b.x, a.y + b.y};
}

Vec2 vec2_sub(Vec2 a, Vec2 b) {
    return (Vec2){a.x - b.x, a.y - b.y};
}

Vec2 vec2_scale(Vec2 a, double s) {
    return (Vec2){a.x * s, a.y * s};
}

double vec2_dot(Vec2 a, Vec2 b) {
    return a.x * b.x + a.y * b.y;
}

double vec2_length(Vec2 a) {
    return sqrt(vec2_dot(a, a));
}

void vec2_print(const char *label, Vec2 a) {
    printf("%s: (%.3f, %.3f)\n", label ? label : "v", a.x, a.y);
}
```

### `main_vec2.c`

```c
#include "vec2.h"
#include <stdio.h>

int main(void) {
    Vec2 a = {3.0, 4.0};
    Vec2 b = {1.0, 0.0};

    vec2_print("a", a);
    vec2_print("b", b);
    vec2_print("a+b", vec2_add(a, b));
    printf("|a| = %.3f\n", vec2_length(a));
    printf("a·b = %.3f\n", vec2_dot(a, b));
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra vec2.c main_vec2.c -lm -o vec2_demo
./vec2_demo
```

Note: `-lm` links the math library for `sqrt`.

## Callback Interfaces (Flexible Modules)

Function pointers let a module stay generic while callers plug in behavior:

```c
/* map.h */
#ifndef MAP_H
#define MAP_H

typedef int (*map_fn)(int value, void *ctx);

void map_apply(int *arr, int n, map_fn fn, void *ctx);

#endif
```

```c
/* map.c */
#include "map.h"

void map_apply(int *arr, int n, map_fn fn, void *ctx) {
    if (arr == NULL || fn == NULL || n <= 0) {
        return;
    }
    for (int i = 0; i < n; i++) {
        arr[i] = fn(arr[i], ctx);
    }
}
```

```c
/* main_map.c */
#include "map.h"
#include <stdio.h>

static int add_k(int value, void *ctx) {
    int k = *(const int *)ctx;
    return value + k;
}

int main(void) {
    int a[] = {1, 2, 3, 4};
    int k = 10;
    map_apply(a, 4, add_k, &k);
    for (int i = 0; i < 4; i++) {
        printf("%d ", a[i]);  /* 11 12 13 14 */
    }
    printf("\n");
    return 0;
}
```

## Best Practices

1. **Naming** — Prefix public symbols with the module name (`strstats_`, `vector_`).
2. **Error handling** — Return error codes; document them; let callers decide how to report.
3. **Documentation** — Comment the header: parameters, returns, ownership, thread-safety.
4. **Testing** — Prefer unit-testable modules with minimal I/O in the library layer.
5. **Globals** — Prefer parameters and opaque state over `extern` globals.
6. **Versioning** — Keep header and library in lockstep; document API breaks.
7. **Compiler flags** — Always develop with `-std=c17 -Wall -Wextra` (add `-Wpedantic` when practical).

## Exercises

1. **Split a program.** Take any single-file program you have written and split it into `utils.h` / `utils.c` / `main.c`. Add a Makefile with debug/release and `-MMD`.

2. **Extend `string_stats`.** Add `strstats_to_upper` and a function that counts vowels. Keep helpers `static` in the `.c` file.

3. **Static library.** Build `libstrstats.a` and link a second small program that only calls `strstats_analyze`. Confirm with `nm` that symbols come from the archive.

4. **Shared library.** Build `libstrstats.so`, link, and run with the appropriate library path environment variable on your OS.

5. **Opaque counter.** Implement `counter.h` / `counter.c` with `counter_create`, `counter_inc`, `counter_get`, `counter_destroy`. Do not expose the struct layout in the header.

6. **Include audit.** Deliberately break a header’s self-containment (remove a needed `#include`), put the related `#include "mod.h"` first in `mod.c`, and observe the compile error. Fix it correctly.

7. **Forward declarations.** Create two modules that would circularly include each other if you `#include` both headers. Resolve the cycle with a forward declaration and move the full include into a `.c` file.

8. **Vector math library.** Add `vec2_normalize` and unit tests (or a small `assert`-based driver). Link with `-lm`.

## Summary

Modular C rests on a few durable ideas:

1. **Headers declare interfaces; sources define implementations.**
2. **Include guards** keep headers safe to include repeatedly.
3. **Linkage** (`extern` / `static`) controls who can see a symbol.
4. **Makefiles** with `-MMD` keep multi-file projects rebuild-correct.
5. **Static (`.a`) and shared (`.so`) libraries** package modules for reuse.
6. **Opaque pointers** hide representation and stabilize APIs.
7. **Include order and forward declarations** keep dependencies honest and compiles fast.

Master these patterns and you can grow from single-file experiments to maintainable multi-module programs and libraries without fighting the toolchain.
