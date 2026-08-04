# Introduction to C Programming

## What is C?

C is a general-purpose, procedural programming language developed in the early 1970s by Dennis Ritchie at Bell Labs. It was created to rewrite the UNIX operating system in a portable high-level language, and it still sits at the foundation of modern systems software.

C is often called a "middle-level" language: it has high-level control structures and types, yet it exposes memory addresses, integer sizes, and hardware-friendly representations. That combination is why kernels, drivers, embedded firmware, databases, and language runtimes are still written in C (or in languages that interoperate closely with C).

You will write source files ending in `.c`, compile them into machine code, and run the resulting process. This chapter explains what that pipeline does, how a running C program is laid out in memory, and how to read a simple program line by line.

## A short history (enough to orient you)

| Era | Milestone |
|-----|-----------|
| 1969–1972 | C evolves from B (and BCPL) on early UNIX at Bell Labs |
| 1973 | UNIX kernel rewritten in C |
| 1978 | Kernighan & Ritchie publish *The C Programming Language* (K&R C) |
| 1989 / 1990 | ANSI C (C89), then ISO C (C90) |
| 1999 | C99: `//` comments, `long long`, VLAs, mixed declarations |
| 2011 | C11: atomics, threads API, better Unicode support |
| 2018 | C17: mostly clarifications and defect fixes of C11 |
| 2024 | C23: binary literals, `typeof`, attributes, more library work |

This book defaults to **C17** for portable examples (`-std=c17`). When a feature needs C23 or is C99-only, the text says so.

## Why learn C?

- **Control**: you decide layout, lifetimes, and how memory is used.
- **Performance**: little runtime magic between your code and the CPU.
- **Systems literacy**: APIs for operating systems and libraries are often C (or C-shaped).
- **Transferable mental model**: C++, Rust, Go, Zig, and many VMs make more sense after you understand C's model of memory, linking, and calling conventions.
- **Career relevance**: kernels, embedded, networking, game engines, databases, security tooling, and high-performance services still need C-fluent engineers.

C is not the only systems language. It is still the lingua franca of low-level interfaces.

---

## From source to process: how a C program runs

A `.c` file is not what the CPU executes. The build tools turn text into a binary image; the operating system loads that image as a **process**.

```
  source.c
      │
      ▼
 ┌─────────────┐
 │ Preprocess  │  #include, #define, conditional compilation
 └──────┬──────┘
      .i (optional intermediate)
      │
      ▼
 ┌─────────────┐
 │  Compile    │  C → assembly (or straight to object on some toolchains)
 └──────┬──────┘
      .s
      │
      ▼
 ┌─────────────┐
 │  Assemble   │  assembly → machine code in a relocatable object
 └──────┬──────┘
      .o
      │
      ▼
 ┌─────────────┐
 │    Link     │  resolve symbols, pull in libc, produce executable
 └──────┬──────┘
   a.out / hello
      │
      ▼
 ┌─────────────┐
 │     Run     │  OS loads program → process with its own address space
 └─────────────┘
```

### What each stage does

1. **Preprocess** — text-level expansion. `#include <stdio.h>` is replaced by the contents of that header (plus nested includes). Macros like `#define N 10` become substitutions.
2. **Compile** — the compiler checks types and syntax, then generates assembly (or an internal IR that becomes object code).
3. **Assemble** — assembly becomes a **relocatable object file** (`.o`): machine instructions and data with unresolved external references (for example, `printf`).
4. **Link** — the linker stitches object files and libraries together, assigns final addresses, and produces an **executable**.
5. **Run** — the OS creates a process, maps the executable (and shared libraries) into memory, sets up the stack, and jumps to the program entry point (which eventually calls `main`).

### Watching the stages with GCC

Save this as `hello.c`:

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

Recommended compile line (use this habit throughout the book):

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o hello hello.c
./hello
```

Inspect stages individually:

```bash
# Preprocessed source (huge; useful when macros go wrong)
gcc -std=c17 -E hello.c -o hello.i

# Assembly listing
gcc -std=c17 -S hello.c -o hello.s

# Object file without linking
gcc -std=c17 -c hello.c -o hello.o

# Link the object into an executable
gcc -o hello hello.o
```

You do not need to memorize assembly. You do need the mental model: **source → translation unit → object → executable → process**.

---

## Memory model intro: text, data, stack, heap

When your program runs, the process address space is divided into regions. Details differ by OS and architecture, but this classic picture is enough for foundations:

```
High addresses
┌──────────────────────────────┐
│          stack               │  grows downward ← local vars, call frames
│             │                │
│             ▼                │
│                              │
│          (free)              │
│                              │
│             ▲                │
│             │                │
│          heap                │  grows upward ← malloc / free
├──────────────────────────────┤
│   BSS (uninitialized data)   │  global/static zeros
├──────────────────────────────┤
│   data (initialized)         │  global/static with values
├──────────────────────────────┤
│   text (code)                │  machine instructions (often read-only)
└──────────────────────────────┘
Low addresses
```

| Region | Typical contents | Lifetime |
|--------|------------------|----------|
| **text** | Compiled instructions | Whole program |
| **data** | Initialized globals / statics | Whole program |
| **BSS** | Zero-initialized globals / statics | Whole program |
| **heap** | `malloc` / `calloc` / `realloc` memory | Until `free` (or exit) |
| **stack** | Locals, parameters, return addresses | Function call |

Early chapters use **stack** locals and string literals. Dynamic **heap** allocation appears later with pointers. The important habit now: every object has a **storage duration** (automatic, static, or allocated) and a **scope** (where its name is visible). Confusing those two is a common source of bugs.

Minimal illustration of where things live (you are not expected to print addresses yet—this is orientation):

```c
#include <stdio.h>
#include <stdlib.h>

int g_count = 1;          /* data (initialized global) */
int g_zero;               /* BSS (zero-initialized global) */

int main(void) {
    int local = 42;       /* stack */
    static int sticky = 7;/* data/BSS, survives across calls */
    int *p = malloc(sizeof *p); /* heap (if malloc succeeds) */

    if (p == NULL) {
        fprintf(stderr, "malloc failed\n");
        return 1;
    }
    *p = 99;

    printf("local=%d sticky=%d *p=%d g_count=%d g_zero=%d\n",
           local, sticky, *p, g_count, g_zero);

    free(p);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o mem_regions mem_regions.c
./mem_regions
```

---

## Hello, World — anatomy line by line

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

| Line | Role |
|------|------|
| `#include <stdio.h>` | Preprocessor pulls in declarations for standard I/O, including `printf`. Angle brackets mean “search system include paths.” |
| `int main(void)` | Program entry from the C language's point of view. `int` is the return type. `(void)` means “no parameters” (preferred over empty `()` in C). |
| `{ ... }` | Function body. Execution of `main` starts at the first statement. |
| `printf("Hello, World!\n");` | Call into the C library to write to standard output. `\n` is a newline. Statement ends with `;`. |
| `return 0;` | Exit status for the process. By convention, `0` means success; non-zero means failure. |

### Small but important details

- **C is case-sensitive**: `Printf` is not `printf`.
- **Headers declare; libraries define**: including `<stdio.h>` is not optional if you call `printf`—without a declaration, modern compilers reject or warn about implicit declarations.
- **`main` forms**: `int main(void)` or `int main(int argc, char *argv[])` are the portable forms. Returning from `main` is equivalent to calling `exit` with that status.
- **In C99+**, falling off the end of `main` without a `return` is treated as returning `0`. Still write `return 0;` while you are learning—clarity beats cleverness.

### Compile and run

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o hello hello.c
./hello
echo $?    # shell shows exit status: 0 on success
```

---

## Full mini-programs

These programs are complete and compilable. Type them yourself; do not only read them.

### 1. Temperature converter (°C ↔ °F)

```c
#include <stdio.h>

int main(void) {
    int choice;
    double value;
    double result;

    printf("Temperature converter\n");
    printf("  1) Celsius to Fahrenheit\n");
    printf("  2) Fahrenheit to Celsius\n");
    printf("Choice: ");

    if (scanf("%d", &choice) != 1) {
        fprintf(stderr, "Invalid choice input\n");
        return 1;
    }

    printf("Value: ");
    if (scanf("%lf", &value) != 1) {
        fprintf(stderr, "Invalid number\n");
        return 1;
    }

    if (choice == 1) {
        result = value * 9.0 / 5.0 + 32.0;
        printf("%.2f C = %.2f F\n", value, result);
    } else if (choice == 2) {
        result = (value - 32.0) * 5.0 / 9.0;
        printf("%.2f F = %.2f C\n", value, result);
    } else {
        fprintf(stderr, "Choice must be 1 or 2\n");
        return 1;
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o temp_convert temp_convert.c
./temp_convert
```

Notes:

- `scanf("%lf", &value)` is required for `double` (`%f` is for `float` with `scanf`).
- Always check that `scanf` returned the number of items you expected.

### 2. Maximum of three integers

```c
#include <stdio.h>

int main(void) {
    int a, b, c;
    int max;

    printf("Enter three integers: ");
    if (scanf("%d %d %d", &a, &b, &c) != 3) {
        fprintf(stderr, "Expected three integers\n");
        return 1;
    }

    max = a;
    if (b > max) {
        max = b;
    }
    if (c > max) {
        max = c;
    }

    printf("max(%d, %d, %d) = %d\n", a, b, c, max);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o max3 max3.c
./max3
# sample input: 9 -2 7
```

This is deliberately free of arrays and functions so you can focus on comparison logic. Later modules rewrite the same idea with loops and helpers.

### 3. Simple calculator CLI

```c
#include <stdio.h>

int main(void) {
    double left, right, result;
    char op;

    printf("Enter expression (e.g. 3.5 * 2): ");
    if (scanf("%lf %c %lf", &left, &op, &right) != 3) {
        fprintf(stderr, "Could not parse expression\n");
        return 1;
    }

    switch (op) {
    case '+':
        result = left + right;
        break;
    case '-':
        result = left - right;
        break;
    case '*':
        result = left * right;
        break;
    case '/':
        if (right == 0.0) {
            fprintf(stderr, "Division by zero\n");
            return 1;
        }
        result = left / right;
        break;
    default:
        fprintf(stderr, "Unsupported operator '%c'\n", op);
        return 1;
    }

    printf("%.10g %c %.10g = %.10g\n", left, op, right, result);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o calc calc.c
./calc
# sample input: 12.5 / 2.5
```

`%.10g` prints a readable floating-point form without forcing fixed decimals. Division by zero is checked for `/` only—floating-point edge cases (`NaN`, overflow) come later.

### 4. Exit status practice

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int code;

    printf("Enter exit code (0-255 recommended): ");
    if (scanf("%d", &code) != 1) {
        return EXIT_FAILURE;
    }

    if (code == 0) {
        printf("Reporting success\n");
        return EXIT_SUCCESS;
    }

    fprintf(stderr, "Reporting failure with code %d\n", code);
    return code;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o exitdemo exitdemo.c
./exitdemo
echo $?
```

---

## Common misconceptions

### “C is basically the same as C++”

No. C++ accepts a large amount of C-looking code, but they are different languages:

- C has no classes, references, templates, or RAII.
- Valid C is not always valid C++ (`void *` assignments, designated initializers historically differed, `restrict`, compound literals, etc.).
- Compile C with a **C** compiler and `-std=c17`. Do not learn C by pasting into a C++ project and “fixing until it builds.”

### “If it compiles, it is correct”

C allows **undefined behavior** (UB): the standard places no requirements on what the program may do. Classic examples include signed integer overflow, using an uninitialized value, buffer overruns, and dangling pointers. The program may crash, appear to work, or corrupt data later—and the behavior can change with optimization level.

```c
/* Illustrating a class of bug — do NOT treat the result as meaningful */
#include <stdio.h>

int main(void) {
    int x;
    /* x is indeterminate; reading it is undefined behavior */
    /* printf("%d\n", x); */
    printf("Uncommenting the printf above would be undefined behavior.\n");
    return 0;
}
```

Enable warnings and treat them seriously:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -O2 -o prog prog.c
```

Later: AddressSanitizer (`-fsanitize=address`), undefined-behavior sanitizer (`-fsanitize=undefined`), and tools like Valgrind.

### “The compiler is just a translator; any compiler is fine”

Compilers differ in diagnostics, optimization, and default dialects. A program that “works” with loose defaults may fail under stricter flags or another vendor. Standardize on:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic
```

Add `-Werror` in CI when you want warnings to fail the build. Clang is an excellent alternative with often clearer messages; the same flags apply in spirit (`clang -std=c17 -Wall -Wextra -Wpedantic`).

### “I need to master every standard library function first”

You need a core loop: edit → compile with warnings → run → fix. Learn I/O, types, control flow, functions, then pointers and memory. The library is large; this book introduces pieces when you have a use for them.

### “`void main()` is fine”

Not for hosted (normal OS) programs. Use `int main(void)` or `int main(int argc, char *argv[])`.

---

## How this book is organized

The C book under `books/C/` is a modular library, not a 90-day calendar:

| Module | Path | Focus |
|--------|------|--------|
| 1 Foundations | `content/01-foundations/` | Tooling, first programs, console I/O |
| 2 Data types | `content/02-data-types/` | Types, variables, operators, conversions |
| 3 Control flow | `content/03-control-flow/` | `if`, loops, `switch`, jumps |
| 4 Functions | `content/04-functions/` | Design, scope, modularity, libc overview |
| 5 Arrays & strings | `content/05-arrays-strings/` | Contiguous data and text |
| 6 Pointers | `content/06-pointers/` | Addresses, dynamic memory, pitfalls |
| 7 Structures | `content/07-structures/` | `struct`, `union`, `enum`, simple ADTs |
| 8 File I/O | `content/08-file-io/` | Streams and system-facing I/O |
| 9 Modern C | `content/09-modern-c/` | C99–C23 and modern practice |
| 10 Data structures | `content/10-data-structures/` | Lists, trees, tables, graphs, sorting |
| 11 Network | `content/11-network/` | Sockets and protocols |
| 12 Embedded | `content/12-embedded/` | Bare-metal-oriented techniques |
| 13 Performance | `content/13-performance/` | Measurement and optimization |
| 14 Testing | `content/14-testing/` | Debug, test, harden |
| 15 Advanced | `content/15-advanced/` | Threads, systems topics, capstone |
| Workbook | `content/99-workbook/` | Extra demos, exercises, projects |
| Appendices | `content/appendices/` | Resources, reference, solution notes |

### What to practice first

1. Install a compiler and confirm `gcc --version` (or `clang --version`).
2. Compile Hello World with `-std=c17 -Wall -Wextra -Wpedantic`.
3. Type the temperature converter and calculator by hand; break them on purpose and read the diagnostics.
4. Complete the exercises at the end of this chapter before racing ahead to pointers.
5. Use the workbook (`content/99-workbook/examples/01-foundations/`) as optional extra drills—not a substitute for typing chapter programs.

Recommended daily loop for Module 1:

```text
read a section → type one full program → compile with warnings → run →
change one thing → explain the new behavior out loud or in a comment
```

---

## Applications of C (why the language stays relevant)

- **Operating systems and runtimes**: kernels, process loaders, language VMs.
- **Embedded and IoT**: microcontrollers, sensors, firmware with tight RAM/flash budgets.
- **Infrastructure**: databases, web servers, container tooling, networking stacks.
- **Performance-critical domains**: games, HFT-adjacent tooling, scientific kernels, codecs.
- **Interoperability**: foreign-function interfaces almost always speak C ABIs.

Relationship sketch (not a full language survey):

| Language | Relation to C |
|----------|----------------|
| C++ | Historically grew from C; different language and type system |
| Rust / Go / Zig | Modern systems languages; often call C libraries via FFI |
| Java / C# | Syntax influenced by C-family; managed runtimes |
| Python / scripting | Many interpreters and extension modules are C under the hood |

---

## Summary

- C is a systems-oriented language with a small core and a large ecosystem of libraries and platforms.
- A program is **preprocessed, compiled, assembled, linked**, then loaded as a **process**.
- Running processes have **text, data/BSS, heap, and stack** regions; know what lives where at a high level.
- Hello World teaches includes, `main`, library calls, and exit status.
- Prefer **`gcc -std=c17 -Wall -Wextra -Wpedantic`**, check I/O return values, and treat undefined behavior as a first-class hazard.
- Work module by module; use the **workbook** for extra practice after the chapter programs.

Next: set up (or verify) your toolchain in *Development Environment Setup*, then deepen compilation and multi-file builds in *Your First C Program*.

---

## Exercises

Do these with `-std=c17 -Wall -Wextra -Wpedantic`. Fix every warning.

1. **Hello variants** — Print three lines: your name, today's focus topic, and the value of `sizeof(int)`.
2. **Stage tour** — For `hello.c`, produce `.i`, `.s`, and `.o` artifacts. Open the `.s` file and find the string `Hello` (or a reference to it). You do not need to understand every instruction.
3. **Exit codes** — Write a program that returns `0` if the user enters an even integer and `1` otherwise. Inspect `$?` in the shell.
4. **Swap print** — Read two integers and print them in reverse order without using a third variable *for output only* is optional; using a temporary is fine. Focus on correct `scanf` checks.
5. **Fahrenheit table** — Print a table of Celsius from 0 to 100 in steps of 10 with the Fahrenheit equivalent (no user input required).
6. **Max of three — self-test** — Extend the max program to also print the minimum.
7. **Calculator harden** — Reject invalid operators and division by zero; print errors to `stderr`.
8. **Comment audit** — Take any mini-program above and add brief comments describing each stage of execution in `main` (not line-by-line noise).
9. **Broken on purpose** — Remove `#include <stdio.h>` and compile. Record the diagnostic. Restore it. Then misspell `main` as `mian` and record what happens.
10. **Mental model** — In 5–8 sentences, explain the difference between an object file (`.o`) and an executable, and between stack storage and heap storage.

Optional stretch: time yourself rewriting the temperature converter from memory after a short break. Accuracy and clean compile matter more than speed.
