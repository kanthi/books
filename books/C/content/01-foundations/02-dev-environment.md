# Development Environment Setup

## Introduction

Setting up a proper development environment is crucial for effective C programming. This chapter walks through installing compilers, choosing editors, configuring debuggers, and — most importantly — **real day-to-day workflows**: multi-file builds, Make, a mini CMake project, and GCC vs Clang diagnostics.

Default compile line used throughout this book:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o prog prog.c
```

Clang is a fine drop-in for learning:

```bash
clang -std=c17 -Wall -Wextra -Wpedantic -o prog prog.c
```

## Installing Compilers

### GCC (GNU Compiler Collection)
GCC is the most widely used C compiler, especially on Linux and macOS systems.

#### Linux Installation
```bash
# Ubuntu/Debian
sudo apt update
sudo apt install build-essential

# Fedora/RHEL/CentOS
sudo dnf install gcc gcc-c++ make

# Arch Linux
sudo pacman -S gcc make
```

#### macOS Installation
Install Xcode Command Line Tools:
```bash
xcode-select --install
```

Or use Homebrew:
```bash
brew install gcc
```

#### Windows Installation
1. Install MinGW-w64: https://www.mingw-w64.org/
2. Or use MSYS2: https://www.msys2.org/
3. Or install Visual Studio with C/C++ support

### Clang
Clang is a modern compiler known for excellent error messages and fast compilation.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install clang

# macOS (via Homebrew)
brew install llvm

# Windows (via MSYS2)
pacman -S mingw-w64-x86_64-clang
```

### Microsoft Visual C++ (MSVC)
For Windows development, MSVC is Microsoft's official C/C++ compiler.

#### Installation
1. Download Visual Studio Community (free): https://visualstudio.microsoft.com/
2. During installation, select "Desktop development with C++" workload

## Modern IDEs and Editors

### Visual Studio Code
A lightweight but powerful editor with excellent C/C++ support.

#### Setup Steps
1. Download and install VS Code: https://code.visualstudio.com/
2. Install the C/C++ extension by Microsoft
3. Install additional helpful extensions:
   - C/C++ Extension Pack
   - Code Runner
   - GitLens

#### Configuration
Create a `.vscode` directory in your project with these files:

**tasks.json** (for building):
```json
{
    "version": "2.0.0",
    "tasks": [
        {
            "type": "cppbuild",
            "label": "C/C++: gcc build active file",
            "command": "/usr/bin/gcc",
            "args": [
                "-fdiagnostics-color=always",
                "-g",
                "${file}",
                "-o",
                "${fileDirname}/${fileBasenameNoExtension}",
                "-lm"
            ],
            "options": {
                "cwd": "${fileDirname}"
            },
            "problemMatcher": ["$gcc"],
            "group": {
                "kind": "build",
                "isDefault": true
            },
            "detail": "Compiler: /usr/bin/gcc"
        }
    ]
}
```

**launch.json** (for debugging):
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "C/C++: gcc build and debug active file",
            "type": "cppdbg",
            "request": "launch",
            "program": "${fileDirname}/${fileBasenameNoExtension}",
            "args": [],
            "stopAtEntry": false,
            "cwd": "${fileDirname}",
            "environment": [],
            "externalConsole": false,
            "MIMode": "gdb",
            "setupCommands": [
                {
                    "description": "Enable pretty-printing for gdb",
                    "text": "-enable-pretty-printing",
                    "ignoreFailures": true
                }
            ],
            "preLaunchTask": "C/C++: gcc build active file",
            "miDebuggerPath": "/usr/bin/gdb"
        }
    ]
}
```

### CLion
A full-featured IDE specifically designed for C/C++ development.

#### Features
- Intelligent code completion
- Integrated debugger
- Built-in terminal
- Version control integration
- CMake support

#### Installation
1. Download from JetBrains: https://www.jetbrains.com/clion/
2. Install with a free student license if you're a student
3. Configure toolchain to point to your compiler

### Code::Blocks
A free, open-source C/C++ IDE.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install codeblocks

# macOS (via Homebrew)
brew install --cask codeblocks

# Windows
Download from http://www.codeblocks.org/
```

## Command-Line Tools

### Make
A build automation tool that automatically determines which pieces of a program need to be recompiled.

#### Installation
```bash
# Usually comes with build-essential on Linux
sudo apt install make

# macOS (via Xcode Command Line Tools)
xcode-select --install

# Windows (via MSYS2)
pacman -S make
```

### CMake
A cross-platform build system generator.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install cmake

# macOS (via Homebrew)
brew install cmake

# Windows
Download from https://cmake.org/download/
```

### Git
Version control system essential for modern development.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install git

# macOS
xcode-select --install

# Windows
Download from https://git-scm.com/
```

## Debugging Tools

### GDB (GNU Debugger)
The standard debugger for GCC.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install gdb

# macOS
# Comes with Xcode Command Line Tools

# Windows (via MSYS2)
pacman -S mingw-w64-x86_64-gdb
```

#### Basic Usage
```bash
# Compile with debug symbols
gcc -g -o program program.c

# Start debugging
gdb program

# Common GDB commands
(gdb) run                    # Run the program
(gdb) break main             # Set breakpoint at main function
(gdb) step                   # Step into function
(gdb) next                   # Step over function
(gdb) print variable_name    # Print variable value
(gdb) continue               # Continue execution
(gdb) quit                   # Exit GDB
```

### Valgrind
A powerful tool for detecting memory leaks and errors.

#### Installation
```bash
# Ubuntu/Debian
sudo apt install valgrind

# macOS
brew install valgrind

# Note: Valgrind has limited support on macOS
```

#### Usage
```bash
# Compile with debug symbols
gcc -g -o program program.c

# Run with Valgrind
valgrind --leak-check=full ./program
```

### AddressSanitizer
A fast memory error detector built into GCC and Clang.

#### Usage
```bash
# Compile with AddressSanitizer
gcc -fsanitize=address -g -o program program.c

# Run normally - errors will be reported automatically
./program
```

## Package Management

### vcpkg
Microsoft's C++ package manager that works with C as well.

#### Installation
```bash
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
./bootstrap-vcpkg.sh  # Linux/macOS
./bootstrap-vcpkg.bat # Windows
```

### Conan
A decentralized C/C++ package manager.

#### Installation
```bash
pip install conan
```

## Cloud Development Environments

### GitHub Codespaces
Browser-based development environment with full VS Code features.

#### Setup
1. Create a GitHub repository
2. Go to repository settings
3. Enable Codespaces
4. Create a dev container configuration

### Gitpod
Ready-to-code development environments in the cloud.

#### Setup
1. Create a Gitpod account
2. Add a `.gitpod.yml` file to your repository:
```yaml
image: gitpod/workspace-full
tasks:
  - init: echo "Initializing project"
    command: echo "Starting development environment"
vscode:
  extensions:
    - ms-vscode.cpptools
```

## Cross-Platform Development

### Windows Subsystem for Linux (WSL)
Run Linux development tools on Windows.

#### Installation
1. Open PowerShell as Administrator
2. Run: `wsl --install`
3. Restart your computer
4. Install Ubuntu from Microsoft Store

### Docker
Containerize your development environment.

#### Example Dockerfile
```dockerfile
FROM gcc:latest

WORKDIR /app
COPY . .

RUN gcc -o program program.c

CMD ["./program"]
```

#### Usage
```bash
# Build the container
docker build -t c-program .

# Run the program
docker run c-program
```

## Real Workflows: From One File to a Small Project

Installation is only half the job. This section is the **daily loop** you will use for the rest of the book.

### Single-file recipe

```bash
# write hello.c, then:
gcc -std=c17 -Wall -Wextra -Wpedantic -o hello hello.c
./hello
echo $?          # exit status: 0 means success
```

Debug-friendly variant:

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o hello hello.c
gdb ./hello      # or lldb on macOS
```

Release-ish variant:

```bash
gcc -std=c17 -Wall -Wextra -O2 -o hello hello.c
```

### Multi-file build recipes

Suppose you have:

```
util.h
util.c
main.c
```

**`util.h`**

```c
#ifndef UTIL_H
#define UTIL_H

int add(int a, int b);
void greet(const char *name);

#endif
```

**`util.c`**

```c
#include "util.h"
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

void greet(const char *name) {
    if (name == NULL) {
        name = "(null)";
    }
    printf("Hello, %s!\n", name);
}
```

**`main.c`**

```c
#include <stdio.h>
#include "util.h"

int main(void) {
    greet("C developer");
    printf("2 + 3 = %d\n", add(2, 3));
    return 0;
}
```

#### Recipe A — one-shot link

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o app main.c util.c
./app
```

#### Recipe B — separate compile, then link (scales better)

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -c main.c -o main.o
gcc -std=c17 -Wall -Wextra -Wpedantic -c util.c -o util.o
gcc -o app main.o util.o
./app
```

When you change only `util.c`, recompile that object and re-link:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -c util.c -o util.o
gcc -o app main.o util.o
```

#### Recipe C — show each stage (learning aid)

```bash
gcc -std=c17 -E util.c -o util.i     # preprocess
gcc -std=c17 -S util.c -o util.s     # assembly
gcc -std=c17 -c util.c -o util.o     # object
nm util.o                            # symbols defined/referenced
```

### Full program: tiny CLI calculator (single file)

Type this, compile it, break it on purpose, fix warnings.

```c
/* file: calc.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static void usage(const char *prog) {
    fprintf(stderr, "Usage: %s <add|sub|mul|div> <a> <b>\n", prog);
}

int main(int argc, char *argv[]) {
    double a, b, result;
    char *end;

    if (argc != 4) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    a = strtod(argv[2], &end);
    if (end == argv[2] || *end != '\0') {
        fprintf(stderr, "invalid number: %s\n", argv[2]);
        return EXIT_FAILURE;
    }
    b = strtod(argv[3], &end);
    if (end == argv[3] || *end != '\0') {
        fprintf(stderr, "invalid number: %s\n", argv[3]);
        return EXIT_FAILURE;
    }

    if (strcmp(argv[1], "add") == 0) {
        result = a + b;
    } else if (strcmp(argv[1], "sub") == 0) {
        result = a - b;
    } else if (strcmp(argv[1], "mul") == 0) {
        result = a * b;
    } else if (strcmp(argv[1], "div") == 0) {
        if (b == 0.0) {
            fprintf(stderr, "division by zero\n");
            return EXIT_FAILURE;
        }
        result = a / b;
    } else {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    printf("%.10g\n", result);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o calc calc.c
./calc add 2 3
./calc div 10 4
./calc div 1 0    # should fail cleanly
```

---

## GCC vs Clang (What Actually Differs)

Both implement the C language and understand the same core flags. Prefer **either** for learning; use both occasionally so diagnostics look familiar.

| Topic | GCC | Clang |
|-------|-----|-------|
| Typical binary | `gcc` | `clang` |
| Error style | Compact, classic | Often more “caret” detail / notes |
| Sanitizers | Excellent (`-fsanitize=…`) | Excellent (often slightly clearer reports) |
| Static analysis extras | `-fanalyzer` (GCC) | `clang --analyze` / clang-tidy ecosystem |
| Default on macOS | Homebrew `gcc` or Xcode’s `clang` as `gcc` alias | Xcode CLT is Clang under the hood |

### Side-by-side on the same bug

```c
/* file: warn_me.c — deliberately sloppy */
#include <stdio.h>

int main(void) {
    int x;
    printf("%d\n", x);   /* uninitialized use */
    return 0;
}
```

```bash
gcc   -std=c17 -Wall -Wextra -Wpedantic -o warn_me warn_me.c
clang -std=c17 -Wall -Wextra -Wpedantic -o warn_me warn_me.c
```

Compare messages. Fix:

```c
int x = 0;
```

### Useful shared flags

```bash
# Treat warnings as errors once you are comfortable
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o prog prog.c

# Extra useful warnings (optional)
gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -o prog prog.c

# Sanitizers (Linux/macOS; great for learning memory bugs)
gcc -std=c17 -Wall -Wextra -g -O1 -fsanitize=address,undefined -o prog prog.c
```

### macOS note

`gcc --version` on stock macOS often prints **Apple Clang**. For real GCC:

```bash
brew install gcc
# then use gcc-14 / g++-14 (version may differ)
```

---

## Make: Multi-File Builds Without Typing Everything

### Minimal `Makefile` for the util/main project

```makefile
# Makefile
CC      = gcc
CFLAGS  = -std=c17 -Wall -Wextra -Wpedantic
LDFLAGS =
TARGET  = app
OBJS    = main.o util.o

.PHONY: all clean run

all: $(TARGET)

$(TARGET): $(OBJS)
	$(CC) $(LDFLAGS) -o $@ $(OBJS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Rebuild if headers change (simple approach)
main.o: main.c util.h
util.o: util.c util.h

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f $(OBJS) $(TARGET)
```

```bash
make
make run
make clean
```

### Full program + Make: word count of argv strings

**`wcargs.c`**

```c
/* file: wcargs.c */
#include <stdio.h>
#include <string.h>

int main(int argc, char *argv[]) {
    int i;
    size_t total = 0;

    for (i = 1; i < argc; i++) {
        size_t n = strlen(argv[i]);
        printf("%zu\t%s\n", n, argv[i]);
        total += n;
    }
    printf("%zu\ttotal chars (no spaces between args)\n", total);
    return 0;
}
```

```makefile
# one-file Makefile variant
CC = gcc
CFLAGS = -std=c17 -Wall -Wextra -Wpedantic
wcargs: wcargs.c
	$(CC) $(CFLAGS) -o $@ $<
```

```bash
make wcargs
./wcargs hello world
```

---

## CMake Mini-Project (Practical One-Pager)

CMake generates native build files (Make, Ninja, Xcode, VS). For a tiny C project:

```
mini_cmake/
├── CMakeLists.txt
├── include/
│   └── util.h
└── src/
    ├── util.c
    └── main.c
```

**`CMakeLists.txt`**

```cmake
cmake_minimum_required(VERSION 3.16)
project(mini_app C)

set(CMAKE_C_STANDARD 17)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS OFF)

add_compile_options(-Wall -Wextra -Wpedantic)

add_executable(mini_app
    src/main.c
    src/util.c
)

target_include_directories(mini_app PRIVATE include)
```

Copy the same `util.h` / `util.c` / `main.c` content from the multi-file section (put `util.h` under `include/`, sources under `src/`, and use `#include "util.h"`).

### Configure, build, run

```bash
cd mini_cmake
cmake -S . -B build
cmake --build build
./build/mini_app
```

Debug build:

```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Debug
cmake --build build
```

Out-of-source `build/` keeps sources clean. Delete `build/` anytime and reconfigure.

### Optional: compile_commands.json for editors

```bash
cmake -S . -B build -DCMAKE_EXPORT_COMPILE_COMMANDS=ON
# many editors read build/compile_commands.json (or a symlink at repo root)
```

---

## Editor + Debugger One-Pager

You do not need a heavy IDE. You need: **edit → build → run under a debugger**.

### Terminal editor + GDB (always works)

```bash
# 1. edit files in vim/nano/emacs/VS Code
# 2. build with symbols
gcc -std=c17 -Wall -Wextra -g -O0 -o app main.c util.c

# 3. debug
gdb ./app
```

Essential GDB session:

```text
(gdb) break main
(gdb) run
(gdb) next          # step over
(gdb) step          # step into
(gdb) print a
(gdb) backtrace     # or: bt
(gdb) continue
(gdb) quit
```

### LLDB (macOS default)

```bash
clang -std=c17 -Wall -Wextra -g -O0 -o app main.c util.c
lldb ./app
```

```text
(lldb) b main
(lldb) run
(lldb) n
(lldb) p a
(lldb) bt
(lldb) c
(lldb) q
```

### VS Code (minimum useful setup)

1. Install **C/C++** extension (Microsoft) or clangd-based setup.  
2. Ensure `gcc`/`clang` and `gdb`/`lldb` are on `PATH`.  
3. Use the earlier `tasks.json` / `launch.json`, **or** just open an integrated terminal and run `make` + `gdb`.  
4. Prefer a multi-file task that builds the whole project, not only the active file, once you leave single-file labs.

### GDB against a real bug (complete mini-lab)

```c
/* file: off_by_one.c */
#include <stdio.h>

static int sum_first_n(const int *a, int n) {
    int total = 0;
    int i;
    /* BUG: i <= n reads one past the end when n is the count */
    for (i = 0; i <= n; i++) {
        total += a[i];
    }
    return total;
}

int main(void) {
    int data[5] = {1, 2, 3, 4, 5};
    printf("sum = %d\n", sum_first_n(data, 5));
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o off_by_one off_by_one.c
gdb ./off_by_one
```

```text
(gdb) break sum_first_n
(gdb) run
(gdb) print n
(gdb) print i
(gdb) next
# watch i go to 5 while valid indices are 0..4
```

Fix the loop to `i < n`, rebuild, confirm `sum = 15`.

---

## Sanitizers and Memory Tools (Environment Checklist)

```bash
# Address + undefined behavior (recommended learning default)
gcc -std=c17 -Wall -Wextra -g -O1 -fsanitize=address,undefined -o app main.c util.c
./app

# Valgrind Memcheck (Linux; limited/absent on modern macOS)
gcc -std=c17 -Wall -Wextra -g -O0 -o app main.c util.c
valgrind --leak-check=full ./app
```

Keep a personal alias if you like:

```bash
alias c17='gcc -std=c17 -Wall -Wextra -Wpedantic'
alias c17san='gcc -std=c17 -Wall -Wextra -g -O1 -fsanitize=address,undefined'
```

---

## Modern Development Practices

### Version Control Workflow

1. Initialize a Git repository: `git init`  
2. Create a `.gitignore` for C projects:

```
# Compiled objects
*.o
*.obj

# Executables
*.exe
*.out
a.out
app
calc

# Debug files
*.dSYM/
core
core.*

# Build directories
build/
cmake-build-*/
compile_commands.json

# Editor
.vscode/
.idea/
```

3. Commit early, commit small: “compiles with -Wall” is a good checkpoint.

### Project Structure

```
project/
├── src/           # Source files
├── include/       # Header files
├── tests/         # Test files
├── docs/          # Documentation
├── build/         # Build output (gitignored)
├── CMakeLists.txt # or Makefile
└── README.md
```

### Continuous Integration

```yaml
# .github/workflows/c-ci.yml
name: C CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Compile
        run: gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o app src/*.c -I include
      - name: Run
        run: ./app
```

---

## Verify Your Setup (Smoke Tests)

Run these once after installing tools:

```bash
# Compilers
gcc --version
clang --version   # if installed

# Build tools
make --version
cmake --version

# Debuggers
gdb --version     # or: lldb --version

# Sanitizer smoke
printf '%s\n' '#include <stdio.h>' 'int main(void){puts("ok");}' > t.c
gcc -std=c17 -Wall -Wextra -fsanitize=address,undefined -o t t.c && ./t
```

Expected: versions print without error; `./t` prints `ok`.

---

## Exercises

Compile every program with:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o <name> <sources...>
```

1. **Hello toolchain** — Compile the same `hello.c` with both `gcc` and `clang` (if available). Note any diagnostic differences when you introduce an unused variable.

2. **Multi-file link** — Create `add.h` / `add.c` / `main.c`. Build with Recipe A and Recipe B. Delete `add.o` and rebuild only what is needed.

3. **Makefile** — Write a `Makefile` that builds the multi-file app, supports `make clean` and `make run`, and rebuilds when a header changes.

4. **CMake mini** — Recreate the `mini_cmake` layout. Configure an out-of-source `build/`, build, and run. Then change `util.c`, rebuild, and confirm only the needed objects recompile (watch timestamps / build log).

5. **Debugger lab** — Use GDB or LLDB on `off_by_one.c`. Set a breakpoint, print `i` and `a[i]`, fix the bug, and show the correct sum.

6. **Sanitizer lab** — Write a program that does `int *p = NULL; *p = 1;`. Run it normally (crash), then under AddressSanitizer. Paste the first few lines of the ASan report into a comment in your fixed file.

7. **calc CLI** — Extend `calc.c` with a `mod` operation using integers (`strtol`) and reject non-integers cleanly.

8. **gitignore** — Initialize git in a throwaway folder, build an app, confirm artifacts are ignored, and make one commit of sources only.

---

## Summary

A solid C environment is:

1. **Compiler** — GCC and/or Clang with `-std=c17 -Wall -Wextra`  
2. **Editor** — anything that edits text reliably; IDE optional  
3. **Debugger** — GDB/LLDB with `-g -O0` builds  
4. **Build tools** — one-shot `gcc`, then Make, then CMake as projects grow  
5. **Sanitizers / Valgrind** — treat memory and UB as first-class  
6. **Git** — ignore build products; commit sources  

Master the multi-file and debugger loops now; every later module assumes you can edit, build, run, and inspect without friction.