# Debugging Techniques

Debugging is the systematic process of finding and fixing defects. On Linux, the core toolkit is **GDB**, **printf/logging macros**, **Valgrind Memcheck**, **strace/ltrace**, **core dumps**, and compiler sanitizers (see the testing chapter for ASan/UBSan).

**Always compile with symbols when debugging:**

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o program program.c
```

`-O0` keeps the mapping between source lines and machine code straightforward. Optimized builds (`-O2`) can reorder code and eliminate variables, which confuses stepping.

## The Debugging Process

1. **Reproduce** — reliable steps beat intermittent luck  
2. **Isolate** — smallest input / fewest modules that fail  
3. **Hypothesize** — what would make the observed symptoms true?  
4. **Observe** — debugger, logs, sanitizers, traces  
5. **Fix** — change the root cause, not the symptom  
6. **Verify** — re-run failing case + nearby regression tests  

---

## GDB: Session-Style Walkthroughs

GDB (GNU Debugger) inspects a running or crashed process: breakpoints, stepping, printing, stack traces, and watchpoints.

### Program under study

```c
/* file: buggy_sum.c */
#include <stdio.h>

int sum_range(int n) {
    int total = 0;
    int i;
    /* Off-by-one: should be i <= n for inclusive sum 1..n */
    for (i = 1; i < n; i++) {
        total += i;
    }
    return total;
}

int main(void) {
    int n = 5;
    int s = sum_range(n);
    printf("sum 1..%d = %d (expected 15)\n", n, s);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o buggy_sum buggy_sum.c
gdb ./buggy_sum
```

### Transcript 1 — break, run, print, next, continue

```text
$ gdb ./buggy_sum
(gdb) break main
Breakpoint 1 at 0x11a9: file buggy_sum.c, line 14.
(gdb) run
Starting program: .../buggy_sum

Breakpoint 1, main () at buggy_sum.c:14
14          int n = 5;
(gdb) next
15          int s = sum_range(n);
(gdb) print n
$1 = 5
(gdb) step
sum_range (n=5) at buggy_sum.c:5
5           int total = 0;
(gdb) next
7           for (i = 1; i < n; i++) {
(gdb) print i
$2 = 0
(gdb) next
8               total += i;
(gdb) print i
$3 = 1
(gdb) print total
$4 = 0
(gdb) next
7           for (i = 1; i < n; i++) {
(gdb) print total
$5 = 1
(gdb) break buggy_sum.c:9
Breakpoint 2 at 0x1178: file buggy_sum.c, line 9.
(gdb) continue
Continuing.

Breakpoint 2, sum_range (n=5) at buggy_sum.c:9
9           return total;
(gdb) print total
$6 = 10
(gdb) print n
$7 = 5
(gdb) quit
```

Observation: for `n = 5`, loop runs `i = 1..4` so total is 10, not 15. Fix: `i <= n`.

### Transcript 2 — backtrace on a crash

```c
/* file: crash_null.c */
#include <stdio.h>

void boom(int *p) {
    *p = 42; /* segfault if p is NULL */
}

void middle(void) {
    int *p = NULL;
    boom(p);
}

int main(void) {
    middle();
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o crash_null crash_null.c
gdb ./crash_null
```

```text
(gdb) run
Program received signal SIGSEGV, Segmentation fault.
0x0000555555555155 in boom (p=0x0) at crash_null.c:5
5           *p = 42;
(gdb) backtrace
#0  boom (p=0x0) at crash_null.c:5
#1  0x0000555555555170 in middle () at crash_null.c:10
#2  0x0000555555555185 in main () at crash_null.c:14
(gdb) frame 1
#1  middle () at crash_null.c:10
10          boom(p);
(gdb) print p
$1 = (int *) 0x0
(gdb) info locals
p = 0x0
(gdb) list
```

**Commands to memorize**

| Command | Purpose |
|---------|---------|
| `break main` / `b file.c:42` | Set breakpoint |
| `break foo if x > 5` | Conditional breakpoint |
| `run` / `r` | Start program (args: `run arg1 arg2`) |
| `next` / `n` | Step over |
| `step` / `s` | Step into |
| `continue` / `c` | Resume |
| `print expr` / `p` | Evaluate expression |
| `backtrace` / `bt` | Call stack |
| `frame N` | Select stack frame |
| `info locals` | Locals in current frame |
| `list` | Show source |
| `quit` | Exit |

### Transcript 3 — watchpoints

```c
/* file: watch_demo.c */
#include <stdio.h>

int main(void) {
    int counter = 0;
    int i;
    for (i = 0; i < 5; i++) {
        counter += i;
    }
    printf("%d\n", counter);
    return 0;
}
```

```text
(gdb) break main
(gdb) run
(gdb) next
(gdb) watch counter
Hardware watchpoint 2: counter
(gdb) continue
Hardware watchpoint 2: counter

Old value = 0
New value = 1
main () at watch_demo.c:8
(gdb) continue
...
(gdb) delete 2
```

Use `watch *pointer` for heap locations after they are allocated. Software watchpoints are slower; hardware watchpoints are limited in count but efficient.

### Handy GDB extras

```text
(gdb) break 10 if x > 5
(gdb) info breakpoints
(gdb) delete 1
(gdb) set var i = 99
(gdb) finish          # run until current function returns
(gdb) until 40        # continue until line 40 in this frame
(gdb) disassemble main
(gdb) info registers
```

TUI mode (source + assembly panes): start with `gdb -tui ./program` or press `C-x a` inside GDB.

---

## `printf` Debugging and `DEBUG_LOG` Macros

Print debugging is fast for I/O-heavy paths and remote systems without an interactive debugger. Make it **toggleable** and **location-aware**.

```c
/* file: debug_log.h */
#ifndef DEBUG_LOG_H
#define DEBUG_LOG_H

#include <stdio.h>

/* Compile with -DDEBUG=1 to enable, or #define DEBUG 1 before include */
#ifndef DEBUG
#define DEBUG 0
#endif

#if DEBUG
#define DEBUG_LOG(fmt, ...)                                                   \
    do {                                                                      \
        fprintf(stderr, "[DEBUG] %s:%d:%s(): " fmt "\n",                      \
                __FILE__, __LINE__, __func__, ##__VA_ARGS__);                 \
    } while (0)
#else
#define DEBUG_LOG(fmt, ...)                                                   \
    do { /* no-op */ } while (0)
#endif

/* Always-on diagnostic (errors, rare paths) */
#define ERROR_LOG(fmt, ...)                                                   \
    do {                                                                      \
        fprintf(stderr, "[ERROR] %s:%d:%s(): " fmt "\n",                      \
                __FILE__, __LINE__, __func__, ##__VA_ARGS__);                 \
    } while (0)

#endif
```

```c
/* file: sum_debug.c */
#include "debug_log.h"

int sum_range(int n) {
    int total = 0;
    int i;
    DEBUG_LOG("enter n=%d", n);
    for (i = 1; i <= n; i++) {
        total += i;
        DEBUG_LOG("i=%d total=%d", i, total);
    }
    DEBUG_LOG("leave total=%d", total);
    return total;
}

int main(void) {
    int s = sum_range(5);
    printf("sum=%d\n", s);
    return 0;
}
```

```bash
# Logs on
gcc -std=c17 -Wall -Wextra -DDEBUG=1 -o sum_debug sum_debug.c
./sum_debug

# Logs compiled out
gcc -std=c17 -Wall -Wextra -o sum_debug sum_debug.c
./sum_debug
```

**Patterns**

- Log **entry/exit** of suspect functions with key arguments  
- Log **loop indices** only for small `n` or every Nth iteration  
- Prefer `stderr` so stdout can still be piped/compared  
- Never leave secrets (passwords, tokens) in permanent logs  
- For binary data, log lengths and a few hex bytes, not megabytes  

```c
/* Hex dump snippet */
static void dump_bytes(const unsigned char *p, size_t n) {
    size_t i;
    for (i = 0; i < n; i++) {
        fprintf(stderr, "%02x%s", p[i], ((i + 1) % 16 == 0) ? "\n" : " ");
    }
    if (n % 16) {
        fputc('\n', stderr);
    }
}
```

### Rubber duck and binary-search debugging

- **Rubber duck**: explain each line aloud; contradictions surface quickly.  
- **Binary search**: comment out half the work (or `git bisect`) until the bad change is isolated.  

```bash
git bisect start
git bisect bad                # current broken revision
git bisect good v1.0          # known good tag
# build + test each checkout, then:
git bisect good   # or: git bisect bad
git bisect reset
```

---

## Valgrind Memcheck: Intentional Leak and Reading the Report

[Valgrind](https://valgrind.org/) Memcheck detects invalid reads/writes, use of uninitialized values, double-free, and leaks.

### Example program with a real leak and a bad read

```c
/* file: leaky.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char *make_greeting(const char *name) {
    size_t n = strlen(name);
    char *buf = malloc(n + 8); /* enough for "Hello, " + name + NUL roughly */
    if (buf == NULL) {
        return NULL;
    }
    /* Intentionally wrong size path for demo: we allocated n+8, use carefully */
    sprintf(buf, "Hello, %s", name);
    return buf; /* caller must free — we will "forget" */
}

int main(void) {
    char *msg = make_greeting("Ada");
    if (msg == NULL) {
        return 1;
    }
    printf("%s\n", msg);

    /* Invalid read demo (optional): read one past strlen */
    /* printf("past end byte maybe junk: %d\n", msg[strlen(msg) + 1]); */

    /* BUG: forgot free(msg) — definite leak */
    /* free(msg); */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o leaky leaky.c
valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all \
  --track-origins=yes ./leaky
```

### How to read typical output

```text
==12345== HEAP SUMMARY:
==12345==     in use at exit: 11 bytes in 1 blocks
==12345==   total heap usage: 1 allocs, 0 frees, 11 bytes allocated
==12345==
==12345== 11 bytes in 1 blocks are definitely lost in loss record 1 of 1
==12345==    at 0x...: malloc (vg_replace_malloc.c:...)
==12345==    by 0x...: make_greeting (leaky.c:8)
==12345==    by 0x...: main (leaky.c:18)
```

| Phrase | Meaning |
|--------|---------|
| **definitely lost** | No pointer to the block remains — real leak |
| **indirectly lost** | Lost because a root pointer was lost (e.g. list head) |
| **possibly lost** | Interior pointer only (suspicious) |
| **still reachable** | Pointers exist at exit (globals, caches) — may be intentional |
| **Invalid read/write** | Access outside allocated region or after free |
| **Conditional jump depends on uninitialised value** | Branch on garbage |
| **Invalid free** / **Mismatched free** | Double free or `free` vs `delete` style issues |

Fix for the demo: `free(msg);` before `return 0`.

### Common Memcheck flags

```bash
valgrind --leak-check=full --show-leak-kinds=all \
  --track-origins=yes --errors-for-leak-kinds=all \
  ./program args...
```

Run under the same `-g` build you use for GDB. Suppressions (`.supp` files) hide known third-party noise — use sparingly.

---

## `strace` and `ltrace` (brief)

### `strace` — system calls

Shows what the kernel sees: open, read, write, connect, etc.

```bash
# Trace a simple program
strace -o strace.log ./buggy_sum
# Follow forks (servers, shells)
strace -f -o strace.log ./server
# Only file-related calls
strace -e trace=file ./myprog
# Network-related
strace -e trace=network ./client
```

Example snippet when a file is missing:

```text
openat(AT_FDCWD, "config.txt", O_RDONLY) = -1 ENOENT (No such file or directory)
```

That single line often beats minutes of guessing about path logic.

### `ltrace` — library calls

```bash
ltrace -o ltrace.log ./leaky
# Focus on malloc family
ltrace -e malloc+free+realloc ./leaky
```

Useful when you care about libc (`malloc`, `printf`, `connect`) rather than raw syscalls. Availability varies by distro/package.

---

## Core Dumps: Capture and Analyze

When a process dies with a fatal signal (e.g. `SIGSEGV`), the kernel can write a **core** image of memory for post-mortem GDB.

### Enable dumps

```bash
# Current shell only
ulimit -c unlimited

# Check limit
ulimit -c

# On many systems, core pattern is controlled by:
cat /proc/sys/kernel/core_pattern
# Example patterns: core, core.%p, or systemd-coredump pipes
```

If `core_pattern` pipes to `systemd-coredump`, use:

```bash
coredumpctl list
coredumpctl gdb ./crash_null
# or: coredumpctl dump -o core.crash
```

### Produce a core

```bash
gcc -std=c17 -Wall -Wextra -g -O0 -o crash_null crash_null.c
ulimit -c unlimited
./crash_null
# may create file "core" or "core.<pid>" depending on system
ls -l core*
```

### Analyze with GDB

```bash
gdb ./crash_null core
# or: gdb ./crash_null core.12345
```

```text
(gdb) bt
#0  boom (p=0x0) at crash_null.c:5
#1  middle () at crash_null.c:10
#2  main () at crash_null.c:14
(gdb) print p
$1 = (int *) 0x0
(gdb) list
```

Same skills as live debugging: `bt`, `frame`, `print`, `info locals`.

**Tips**

- The binary path and **build ID** should match the one that crashed  
- Keep `-g` builds (or separate debug packages) for production post-mortems  
- Never ship secrets in cores; cores can contain full memory  

---

## Common Failure Modes

### Segmentation faults

Typical causes:

- Null or wild pointer dereference  
- Buffer overflow past array/heap end  
- Use after free  
- Stack overflow (deep recursion)  

Workflow: GDB `bt` → inspect pointer → Valgrind or ASan if memory corruption is subtle.

### Logic errors

Program runs, wrong answer. Prefer:

- Unit tests with known golden values  
- GDB watchpoints on intermediate results  
- Temporary `DEBUG_LOG` of invariants  

### Memory leaks and corruption

Valgrind / ASan first; then fix ownership (who allocates, who frees).

### Race conditions (threads)

```bash
gcc -std=c17 -Wall -Wextra -g -fsanitize=thread -o races races.c -pthread
./races
```

Combine with careful locking; races are hard to reproduce with `printf` alone.

---

## Static Analysis (quick)

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Wshadow -Wconversion -c file.c
cppcheck --enable=all --inconclusive --std=c17 file.c
```

Static tools do not replace runtime debugging; they reduce the number of bugs that reach GDB.

---

## Debugging Best Practices

1. **Reproduce first** — write a failing test or a minimal input file.  
2. **One change at a time** — random edits hide the real fix.  
3. **Trust tools more than memory** — print the actual value of `errno`, sizes, indices.  
4. **Keep a short log** — hypothesis, experiment, result.  
5. **Prefer `-g -O0` while hunting**, then re-test optimized builds.  
6. **Use version control** — `git bisect` for regressions.  
7. **Take breaks** — fatigue creates new bugs.  

---

## Exercises

### Exercise 1 — GDB fix of `sum_range`

Use the buggy `sum_range` that uses `i < n`. Under GDB, break in the loop, print `i` and `total` for `n = 5`, confirm the off-by-one, fix the loop, and re-run outside GDB so the program prints `15`.

### Exercise 2 — `DEBUG_LOG` toggle

Add `debug_log.h` to a small multi-function program. Build once with `-DDEBUG=1` and once without. Confirm the non-debug binary produces no debug lines and is smaller / quieter.

### Exercise 3 — Valgrind leak

Write a program that allocates a linked list of 10 nodes and “forgets” to free them. Run Memcheck with `--leak-check=full`. Then free the list correctly and show a clean report (`All heap blocks were freed -- no leaks are possible`).

### Exercise 4 — Invalid write

Allocate `malloc(4)` and write 8 bytes. Compare:

1. Normal run (may appear to work — UB)  
2. `valgrind ./prog`  
3. `gcc -fsanitize=address`  

Describe which tool gave the clearest diagnosis.

### Exercise 5 — Core dump

Enable `ulimit -c unlimited`, run `crash_null`, open the core in GDB, and paste (or retype) the `bt` output. Identify the null pointer in which frame.

### Exercise 6 — `strace` detective

Write a program that tries to open three paths in order until one succeeds. Hide the working path among missing ones. Use `strace -e openat` (or `trace=file`) to determine which path was used without reading the source.

---

## Summary

| Tool | Best for |
|------|----------|
| **GDB** | Breakpoints, stack traces, watchpoints, live state |
| **DEBUG_LOG** | Fast insight, remote/headless runs |
| **Valgrind Memcheck** | Leaks, invalid access, uninit values |
| **ASan/UBSan** | Fast memory/UB checks (see testing chapter) |
| **strace** | “Why did open/connect fail?” |
| **ltrace** | Library call sequences |
| **Core + GDB** | Post-crash forensics |

Debugging is a skill of **observation under control**. Master GDB and Memcheck early; use logs and traces when interactivity is limited; always finish with a regression test so the same bug stays fixed.
