# Your First C Program

## Introduction

This chapter moves from “what C is” to a working edit–compile–run loop. You will write complete programs, read compiler diagnostics, split a tiny program across multiple files, and finish a short lab (personal info printer + unit converter).

Default compile line for every example:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o prog prog.c
```

---

## The classic “Hello, World!”

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

### Line-by-line

| Piece | Meaning |
|-------|---------|
| `#include <stdio.h>` | Bring in declarations for standard I/O (`printf`, `scanf`, …). |
| `int main(void)` | Entry point; returns an `int` status; no parameters. |
| `printf(...)` | Library call writing to standard output. |
| `\n` | Newline character in the string. |
| `return 0;` | Report success to the operating system / shell. |

### Create, compile, run

```bash
# create hello.c with your editor, then:
gcc -std=c17 -Wall -Wextra -Wpedantic -o hello hello.c
./hello
```

On Windows (MinGW / similar), the executable may be `hello.exe`; run `hello` or `.\hello.exe` depending on your shell.

---

## What the compiler does (short version)

```
hello.c  →  preprocess  →  compile  →  assemble  →  link  →  hello
```

| Stage | Flag to stop here | Output |
|-------|-------------------|--------|
| Preprocess | `-E` | Preprocessed source (`.i`) |
| Compile to assembly | `-S` | Assembly (`.s`) |
| Assemble only | `-c` | Object file (`.o`) |
| Full link | (default) | Executable |

```bash
gcc -std=c17 -E hello.c -o hello.i
gcc -std=c17 -S hello.c -o hello.s
gcc -std=c17 -c hello.c -o hello.o
gcc -o hello hello.o
```

Useful flags you will reuse:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -g -O0 -o hello hello.c   # debug-friendly
gcc -std=c17 -Wall -Wextra -Wpedantic -O2 -o hello hello.c      # optimized release-ish
```

| Flag | Role |
|------|------|
| `-std=c17` | Language dialect |
| `-Wall -Wextra -Wpedantic` | Strong warnings |
| `-g` | Debug symbols (GDB/LLDB) |
| `-O0` / `-O2` | Optimization level |
| `-o name` | Output file name |

---

## Structure of a C program

```c
/* 1. Preprocessor directives */
#include <stdio.h>
#define APP_NAME "demo"

/* 2. Optional global declarations / prototypes */
void greet(const char *who);

/* 3. main — required for hosted programs */
int main(void) {
    greet("World");
    return 0;
}

/* 4. Other function definitions */
void greet(const char *who) {
    printf("Hello, %s!\n", who);
}
```

Order rules of thumb:

1. Includes and macros at the top.
2. Prototypes before first use (or define functions before `main`).
3. One clear `main`.
4. Keep globals rare; prefer locals and parameters.

### Comments

```c
// Single-line comment (C99+)

/*
 * Multi-line comment
 * useful for file headers or longer notes
 */
```

Prefer comments that explain **why** or non-obvious constraints. Restating `i++` as “increment i” adds noise.

---

## More complete single-file examples

### Greeting with command-line arguments

```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    if (argc < 2) {
        printf("Usage: %s <name>\n", argv[0]);
        return 1;
    }

    printf("Hello, %s!\n", argv[1]);
    printf("Argument count: %d\n", argc);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o greeter greeter.c
./greeter Ada
./greeter          # should print usage and exit non-zero
```

`argv[0]` is usually the program name as invoked. `argc` is the count of elements in `argv`.

### Sum of two integers (with validation)

```c
#include <stdio.h>

int main(void) {
    int a, b;

    printf("Enter two integers: ");
    if (scanf("%d %d", &a, &b) != 2) {
        fprintf(stderr, "error: expected two integers\n");
        return 1;
    }

    printf("%d + %d = %d\n", a, b, a + b);
    return 0;
}
```

### Multiple helpers in one file

```c
#include <stdio.h>

static int square(int x) {
    return x * x;
}

static int max2(int a, int b) {
    return (a > b) ? a : b;
}

int main(void) {
    int x = 5;
    int y = 12;

    printf("square(%d) = %d\n", x, square(x));
    printf("max(%d, %d) = %d\n", x, y, max2(x, y));
    return 0;
}
```

`static` on a function at file scope means “internal linkage”: the name is not exported to the linker for other `.c` files. That keeps helpers private to the translation unit.

### Print a small banner

```c
#include <stdio.h>

int main(void) {
    puts("**************************");
    puts("*   My First C Program   *");
    puts("**************************");
    return 0;
}
```

`puts` appends a newline for you and is convenient for simple strings. Prefer `printf` when you need formatting.

---

## Multi-file tiny program

Real projects split declarations (headers) from definitions (source files). Minimal pattern:

**`util.h`**

```c
#ifndef UTIL_H
#define UTIL_H

int add(int a, int b);
void print_sum(int a, int b);

#endif /* UTIL_H */
```

**`util.c`**

```c
#include <stdio.h>
#include "util.h"

int add(int a, int b) {
    return a + b;
}

void print_sum(int a, int b) {
    printf("%d + %d = %d\n", a, b, add(a, b));
}
```

**`main.c`**

```c
#include "util.h"

int main(void) {
    print_sum(3, 4);
    return 0;
}
```

### Build it

```bash
# Separate compile + link
gcc -std=c17 -Wall -Wextra -Wpedantic -c util.c -o util.o
gcc -std=c17 -Wall -Wextra -Wpedantic -c main.c -o main.o
gcc -o multifile main.o util.o

# Or one shot
gcc -std=c17 -Wall -Wextra -Wpedantic -o multifile main.c util.c

./multifile
```

### Why the include guard?

```c
#ifndef UTIL_H
#define UTIL_H
/* declarations */
#endif
```

If two files include `util.h` and a third includes both, guards prevent duplicate declarations in one translation unit.

### Header vs source rules

| Put in `.h` | Put in `.c` |
|-------------|-------------|
| Function prototypes | Function bodies |
| Shared `struct` types (later) | `static` helpers |
| `extern` data declarations (rare) | Definitions of globals |

Include your own headers with quotes: `#include "util.h"`. System headers use angle brackets: `#include <stdio.h>`.

---

## Common compile errors (with explanations)

### Missing semicolon

```c
printf("hi\n")   /* error: expected ';' */
```

**Fix:** statements end with `;`. The diagnostic often points at the *next* line—check the previous statement.

### Missing `#include <stdio.h>`

```c
int main(void) {
    printf("hi\n");
    return 0;
}
```

**Symptom:** implicit declaration / unknown identifier `printf`.  
**Fix:** include the proper header.

### Wrong main spelling or signature

```c
int mian(void) { return 0; }
```

**Symptom:** linker error `undefined reference to main`.  
**Fix:** the entry point must be named `main`.

### Case sensitivity

```c
Printf("hi\n");  /* wrong */
```

**Fix:** `printf`, not `Printf`.

### Undeclared function (multi-file)

`main.c` calls `add` but never includes `util.h` and has no prototype:

**Symptom:** implicit declaration warning/error, sometimes wrong assumptions about types.  
**Fix:** `#include "util.h"` or declare `int add(int, int);` before use.

### Multiple definition of a function

Defining `int add(int a, int b) { ... }` in a header that two `.c` files include.

**Symptom:** linker `multiple definition of add`.  
**Fix:** declare in the header; define in exactly one `.c` file.

### Forgetting to link a file

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o multifile main.c
# undefined reference to print_sum
```

**Fix:** include every translation unit: `main.c util.c`.

### Format / type mismatch (warning)

```c
int x = 3;
printf("%f\n", x);  /* wrong specifier for int */
```

**Fix:** use `%d` for `int`. Enable `-Wall`; modern GCC/Clang catch many of these.

### Using `=` instead of `==` in a condition (logic bug; may still compile)

```c
int x = 0;
if (x = 1) {  /* assignment; always true here */
    printf("oops\n");
}
```

**Mitigation:** `-Wall` often warns about suspicious assignments in conditions. Prefer clear comparisons.

### Unterminated string

```c
printf("hello\n);
```

**Symptom:** missing terminating `"` / stray errors cascading.  
**Fix:** close the string literal; recompile—cascading errors often shrink after the first fix.

### Tips for reading diagnostics

1. Start with the **first** error, not the last.
2. Fix includes and syntax before chasing linker issues.
3. Recompile after each fix; noise often disappears.
4. If the message is opaque, reduce to a 10-line file that still fails.

---

## Lab A — Personal info printer

**Goal:** print a short personal profile using variables and formatted output.

```c
#include <stdio.h>

int main(void) {
    char name[] = "Ada Lovelace";
    int age = 36;
    char city[] = "London";
    char language[] = "C";
    double years_experience = 2.5;

    printf("==============================\n");
    printf("       PERSONAL PROFILE\n");
    printf("==============================\n");
    printf("Name:       %s\n", name);
    printf("Age:        %d\n", age);
    printf("City:       %s\n", city);
    printf("Language:   %s\n", language);
    printf("Experience: %.1f years\n", years_experience);
    printf("==============================\n");

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o profile profile.c
./profile
```

**Lab stretch:**

1. Change the data to your own details.
2. Add a second `printf` block that re-prints the same data as a single comma-separated line.
3. Replace hard-coded values with `scanf` / `fgets` input (after the next chapter if needed).

---

## Lab B — Unit converter

**Goal:** convert between a few everyday units with a tiny menu.

```c
#include <stdio.h>

int main(void) {
    int choice;
    double input;
    double output;

    printf("Unit converter\n");
    printf("  1) kilometers to miles\n");
    printf("  2) miles to kilometers\n");
    printf("  3) kilograms to pounds\n");
    printf("  4) pounds to kilograms\n");
    printf("Select: ");

    if (scanf("%d", &choice) != 1) {
        fprintf(stderr, "Invalid menu selection\n");
        return 1;
    }

    printf("Value: ");
    if (scanf("%lf", &input) != 1) {
        fprintf(stderr, "Invalid numeric value\n");
        return 1;
    }

    switch (choice) {
    case 1:
        output = input * 0.621371;
        printf("%.4f km = %.4f mi\n", input, output);
        break;
    case 2:
        output = input * 1.60934;
        printf("%.4f mi = %.4f km\n", input, output);
        break;
    case 3:
        output = input * 2.20462;
        printf("%.4f kg = %.4f lb\n", input, output);
        break;
    case 4:
        output = input * 0.453592;
        printf("%.4f lb = %.4f kg\n", input, output);
        break;
    default:
        fprintf(stderr, "Unknown option %d\n", choice);
        return 1;
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o units units.c
./units
```

**Lab stretch:**

1. Add Celsius ↔ Fahrenheit (reuse logic from the intro chapter).
2. Split conversion formulas into functions in a second file (`convert.c` / `convert.h`) and link them.
3. Loop the menu until the user chooses `0` to quit (preview of control flow).

---

## Variations worth knowing

### Implicit `return 0` in `main` (C99+)

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
}
```

Legal in C99 and later for `main` only. Prefer an explicit `return` while learning.

### Prototype before `main`

```c
#include <stdio.h>

void print_greeting(void);

int main(void) {
    print_greeting();
    return 0;
}

void print_greeting(void) {
    printf("Hello, World!\n");
}
```

### Using `stderr` for errors

```c
#include <stdio.h>

int main(void) {
    fprintf(stderr, "This goes to standard error\n");
    printf("This goes to standard output\n");
    return 1;
}
```

```bash
./prog >out.txt 2>err.txt
```

---

## Beginner mistakes checklist

| Mistake | Fix |
|---------|-----|
| Missing `;` | Terminate statements |
| Missing header | `#include <stdio.h>` etc. |
| `void main()` | Use `int main(void)` |
| Calling without prototype | Declare or include header |
| Ignoring warnings | Compile with `-Wall -Wextra -Wpedantic` |
| Wrong file extension / dialect | Save as `.c`, pass `-std=c17` |
| Editing the wrong directory | Confirm path before compile |
| Running old binary | Rebuild after every edit |

---

## Summary

- Every hosted C program needs a `main` and usually standard library headers for I/O.
- Compilation is a pipeline; object files link into executables.
- Multi-file programs separate **declarations** (headers) from **definitions** (sources).
- Learn to read the **first** compiler/linker diagnostic.
- Labs: personal profile printer and unit converter reinforce the full cycle.

Next: *Basic Input and Output* — format strings, `scanf` pitfalls, and safer line input with `fgets`.

---

## Exercises

Compile each with:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o exN exN.c
```

1. **Banner** — Print a boxed title using only `printf` or `puts` (no user input).
2. **Three-file arithmetic** — Create `mathx.h`, `mathx.c` (`mul`, `div_safe`), and `main.c`. `div_safe` should return `0` and print an error to `stderr` when dividing by zero (or use an `int` status code—your design, document it).
3. **Argc printer** — Print all command-line arguments, one per line, including `argv[0]`.
4. **Warning hunt** — Write a file that triggers at least two different warnings under `-Wall -Wextra`, then fix them. Save both versions in comments at the bottom of the file.
5. **Profile lab upgrade** — Personal info printer that reads age with `scanf` and name with a fixed string or `scanf("%49s", ...)`.
6. **Converter lab upgrade** — Add an option `0` to exit; use a loop if you already know `while`/`for`, otherwise document that the stretch is deferred.
7. **Explain a log** — Deliberately omit `util.o` from a multi-file link command and paste the linker error into a comment; explain it in one sentence.
8. **Style pass** — Reformat one lab with consistent indentation (4 spaces), braces on the same style throughout, and a one-line file header comment with your name and purpose.
