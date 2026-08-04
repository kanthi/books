# Module 14: Testing

This module turns “it seems to work” into **evidence**. You will unit-test pure C with portable harnesses, drive design with TDD, hunt bugs with GDB and Valgrind, handle errors without exceptions, and raise code quality with warnings, sanitizers, and review habits.

**Environment:** Linux/POSIX, `gcc -std=c17 -Wall -Wextra`, plus optional `gcov`/`lcov`, Valgrind, and sanitizers.

## Learning goals

By the end of this module you should be able to:

- Write **automated unit tests** with `assert`, a tiny custom macro harness, or a Unity-style runner  
- Apply **TDD** (red → green → refactor) to small pure functions  
- Design **boundary** and **table-driven** cases for integers and strings  
- Measure **coverage** with `gcov`/`lcov` and interpret gaps  
- Run tests under **AddressSanitizer** and **UndefinedBehaviorSanitizer**  
- Drive **GDB** sessions (break, print, backtrace, watch) and read **core dumps**  
- Detect leaks and invalid access with **Valgrind Memcheck**  
- Use **strace**/**ltrace** and structured **DEBUG_LOG** macros  
- Choose return codes, `errno`, and cleanup patterns for robust APIs  
- Apply practical **quality** gates: `-Werror`, static analysis, review checklists, local `check.sh`  

## Chapters (map)

| # | Chapter | What you will practice |
|---|---------|-------------------------|
| 1 | [Testing Methodologies](01-testing-methodologies.md) | Unit harnesses, Unity-style suites, TDD (`is_leap_year` / `clamp`), boundaries, table-driven tests, `gcov`/`lcov`, ASan/UBSan |
| 2 | [Debugging Techniques](02-debugging-techniques.md) | GDB transcripts, `DEBUG_LOG`, Valgrind, strace/ltrace, core dumps, systematic isolation |
| 3 | [Error Handling](03-error-handling.md) | Return codes, enums, `errno`, cleanup on failure, partial-success pitfalls |
| 4 | [Code Quality](04-code-quality.md) | Warning archaeology, early-return design, `_Static_assert`, load/ownership patterns, CI-style local gates |

## Suggested order

1. **Testing Methodologies** first — build a harness and a few pure functions you trust.  
2. **Debugging Techniques** — deliberately break code and recover with GDB/Valgrind.  
3. **Error Handling** — make APIs fail loudly and cleanly.  
4. **Code Quality** — lock in habits that keep the above sustainable (`-Werror`, checklists, scripts).

## Tooling cheat sheet

```bash
# Unit test binary
gcc -std=c17 -Wall -Wextra -g -o test_foo test_foo.c
./test_foo

# Coverage
gcc -std=c17 -Wall -Wextra -g --coverage -o test_foo test_foo.c
./test_foo && gcov test_foo.c

# Sanitizers
gcc -std=c17 -Wall -Wextra -g -fsanitize=address,undefined -o test_foo test_foo.c

# Strict quality compile
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o prog prog.c

# Debug
gcc -std=c17 -Wall -Wextra -g -O0 -o prog prog.c
gdb ./prog
valgrind --leak-check=full ./prog
```

## How this module connects

- **Earlier modules** (functions, pointers, memory, file I/O) supply the bugs and APIs you will test.  
- **Later practice** (projects, networking) should inherit the same habit: small tests for pure logic, integration checks for I/O and sockets.  
- Treat Module 14 as a **skill overlay**: re-test older chapters’ utilities under a harness once you have one.

## Module self-check

Each chapter ends with exercises. A solid bar for Module 14:

- [ ] A multi-test binary exits non-zero on failure  
- [ ] At least one function was written strictly with TDD  
- [ ] A table of ≥8 cases drives a pure function  
- [ ] `gcov` (or HTML via `lcov`) reviewed once  
- [ ] ASan or Valgrind used to find a planted memory bug  
- [ ] A GDB `backtrace` obtained from a segfault or core file  
- [ ] A “smelly” file cleaned until `-Werror` is silent  
- [ ] One PR-style checklist applied to a small change  

Work through the chapters in order, keep every example compiling with `-Wall -Wextra`, and prefer **complete programs** you can re-run when you change the code under test.

## Estimated time

- Reading: 5–8 hours  
- Labs (tests + GDB + sanitizers + quality gates): 8–12 hours  

## Next

Apply these habits to **Module 15 (Advanced)** projects and to any workbook project: ship tests and a quality script with the feature, not after.
