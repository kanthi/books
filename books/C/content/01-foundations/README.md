# Module 1: Foundations and Environment Setup

## Overview

This module is the **on-ramp** for the C book: what C is, how to install and drive a toolchain, the edit–compile–run loop, and console I/O. Finish it before jumping to data types and control flow unless you already ship C daily.

**Default compile line (memorize it):**

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o prog prog.c
```

Clang is fine: replace `gcc` with `clang`.

## Learning goals

By the end of this module you should be able to:

- Explain where C sits (systems language, standards C17/C23) and when it is the right tool  
- Install **GCC** and/or **Clang**, a debugger (**GDB**/**LLDB**), and optional **CMake** / Make  
- Write, compile, and run small programs; read common compiler diagnostics  
- Split a program across `.c` / `.h` files and link object files  
- Use `printf` / `scanf` / `fgets` carefully (check return values, avoid unbounded `%s`)  
- Prefer `-g -O0` when debugging and treat warnings as signal, not noise  

## Chapters (map)

| # | Chapter | What you practice |
|---|---------|-------------------|
| 1 | [Introduction to C](01-intro-to-c.md) | History, standards, “Hello”, mini converters, mental model of compile/link |
| 2 | [Development Environment](02-dev-environment.md) | Install compilers; **multi-file recipes**; Make; **mini CMake**; GCC vs Clang; GDB one-pager; sanitizers |
| 3 | [First C Program](03-first-program.md) | Program structure, flags, multi-file lab, personal-info / converter labs |
| 4 | [Basic Input/Output](04-basic-io.md) | `printf`/`scanf`, format specs, `fgets`, mixing line and token input safely |

## Suggested path

1. Skim **Intro** so the compile pipeline and `main` form are clear.  
2. Do **Environment** *for real* — multi-file build + one debugger session, not only install notes.  
3. Type every program in **First Program**.  
4. Complete **Basic I/O** exercises before Module 2; I/O bugs dominate early frustration.

## Tooling cheat sheet

```bash
# single file
gcc -std=c17 -Wall -Wextra -Wpedantic -o hello hello.c && ./hello

# multi-file
gcc -std=c17 -Wall -Wextra -Wpedantic -c main.c util.c
gcc -o app main.o util.o

# debug
gcc -std=c17 -Wall -Wextra -g -O0 -o app main.c util.c
gdb ./app    # or: lldb ./app

# memory / UB (Linux/macOS)
gcc -std=c17 -Wall -Wextra -g -O1 -fsanitize=address,undefined -o app app.c
```

## Prerequisites

- Basic computer literacy and a terminal  
- Ability to install packages (apt, brew, MSYS2, or Xcode CLT)  
- No prior C required for Path A (see book landing page)

## Self-check before Module 2

- [ ] `hello.c` builds with zero warnings under `-Wall -Wextra`  
- [ ] Multi-file program links (`main.c` + `util.c`)  
- [ ] One GDB/LLDB session: breakpoint, `print`, continue  
- [ ] Program reads an integer and a line of text without leftover-newline confusion  
- [ ] You know how to show the compiler’s version and the executable’s exit status (`echo $?`)

## Estimated time

- Reading: 4–6 hours  
- Typing examples + exercises: 6–10 hours  
- Optional: CMake mini-project and sanitizer lab from chapter 2  

## Next module

**Module 2: Data Types and Variables** — types, sizes, constants, conversions, operators.

## Resources

- K&R *The C Programming Language* (classic reference, older dialect)  
- GCC / Clang manuals for flag details  
- Book appendices for reference tables and solutions pointers  
