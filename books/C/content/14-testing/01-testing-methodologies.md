# Testing Methodologies

Testing ensures C code behaves correctly under normal use, edge cases, and failure conditions. This chapter focuses on **practical unit testing in C on Linux/POSIX**: small harnesses you can compile with `gcc`, table-driven tests, TDD, boundary analysis, coverage with `gcov`/`lcov`, and sanitizers.

**Build flags used throughout this chapter:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
```

Add `-g` for debugging symbols, and sanitizer flags when hunting memory/UB bugs (covered below).

## Why Testing Matters

- **Bug detection early**: cheaper than production incidents
- **Documentation**: tests show intended API contracts
- **Safe refactoring**: change internals without fear if tests pass
- **Regression control**: catch breakages when you touch old code

## Types of Testing (C-focused)

| Level | What you test | Typical tools in C |
|-------|----------------|--------------------|
| **Unit** | One function / small module | `assert`, custom macros, Unity, CUnit |
| **Integration** | Several `.c` files / libraries together | Same harness + real I/O stubs |
| **System** | Whole binary (CLI, server) | Shell scripts, golden files |
| **Regression** | “This used to work” cases | Any automated suite in CI |

### Unit testing characteristics

- **Small and focused** — one behavior per test when possible  
- **Fast** — milliseconds, not minutes  
- **Independent** — no order dependence  
- **Repeatable** — same result every run  
- **Automated** — no human clicks  

---

## Style 1: `assert.h` Unit Tests

`<assert.h>` is enough for tiny libraries. Failed asserts abort the process (good for local runs; less pretty for large suites).

```c
/* file: test_add.c */
#include <assert.h>
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

void test_add(void) {
    assert(add(2, 3) == 5);
    assert(add(-1, 1) == 0);
    assert(add(0, 0) == 0);
    assert(add(1000000, 2000000) == 3000000);
}

int main(void) {
    test_add();
    printf("all asserts passed\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o test_add test_add.c
./test_add
```

**Note:** In release builds, `NDEBUG` disables asserts. Keep tests in a separate binary that never defines `NDEBUG`.

---

## Style 2: Minimal Custom `TEST` Macro Harness

A few macros give you named tests, a pass/fail counter, and a non-zero exit code — without external libraries.

```c
/* file: mini_test.h */
#ifndef MINI_TEST_H
#define MINI_TEST_H

#include <stdio.h>
#include <string.h>

static int g_tests_run;
static int g_tests_failed;

#define TEST_BEGIN() \
    do { g_tests_run = 0; g_tests_failed = 0; } while (0)

#define TEST_END()                                                        \
    do {                                                                  \
        printf("\n%d tests, %d failed\n", g_tests_run, g_tests_failed);   \
        return g_tests_failed ? 1 : 0;                                    \
    } while (0)

#define RUN_TEST(fn)                                                      \
    do {                                                                  \
        g_tests_run++;                                                    \
        printf("  RUN  %s ... ", #fn);                                    \
        fflush(stdout);                                                   \
        if ((fn)() == 0) {                                                \
            printf("OK\n");                                               \
        } else {                                                          \
            g_tests_failed++;                                             \
            printf("FAIL\n");                                             \
        }                                                                 \
    } while (0)

/* Return 0 on success, 1 on failure from these macros */
#define EXPECT_EQ_INT(actual, expected)                                   \
    do {                                                                  \
        int _a = (actual);                                                \
        int _e = (expected);                                              \
        if (_a != _e) {                                                   \
            fprintf(stderr, "\n    %s:%d: expected %d, got %d\n",         \
                    __FILE__, __LINE__, _e, _a);                          \
            return 1;                                                     \
        }                                                                 \
    } while (0)

#define EXPECT_TRUE(cond)                                                 \
    do {                                                                  \
        if (!(cond)) {                                                    \
            fprintf(stderr, "\n    %s:%d: condition false: %s\n",         \
                    __FILE__, __LINE__, #cond);                           \
            return 1;                                                     \
        }                                                                 \
    } while (0)

#define EXPECT_STREQ(actual, expected)                                    \
    do {                                                                  \
        const char *_a = (actual);                                        \
        const char *_e = (expected);                                      \
        if (_a == NULL || _e == NULL || strcmp(_a, _e) != 0) {            \
            fprintf(stderr, "\n    %s:%d: expected \"%s\", got \"%s\"\n", \
                    __FILE__, __LINE__,                                   \
                    _e ? _e : "(null)", _a ? _a : "(null)");              \
            return 1;                                                     \
        }                                                                 \
    } while (0)

#endif /* MINI_TEST_H */
```

```c
/* file: test_clamp.c — uses mini_test.h */
#include "mini_test.h"

int clamp(int x, int lo, int hi) {
    if (x < lo) {
        return lo;
    }
    if (x > hi) {
        return hi;
    }
    return x;
}

static int test_clamp_inside(void) {
    EXPECT_EQ_INT(clamp(5, 0, 10), 5);
    return 0;
}

static int test_clamp_below(void) {
    EXPECT_EQ_INT(clamp(-3, 0, 10), 0);
    return 0;
}

static int test_clamp_above(void) {
    EXPECT_EQ_INT(clamp(99, 0, 10), 10);
    return 0;
}

int main(void) {
    TEST_BEGIN();
    RUN_TEST(test_clamp_inside);
    RUN_TEST(test_clamp_below);
    RUN_TEST(test_clamp_above);
    TEST_END();
}
```

```bash
gcc -std=c17 -Wall -Wextra -o test_clamp test_clamp.c
./test_clamp
```

---

## Style 3: Unity-Style Suite That Actually Builds

[Unity](https://github.com/ThrowTheSwitch/Unity) is a popular embedded-friendly C unit framework. You can either vendor its sources or use a **Unity-compatible subset** that builds as a single file for learning.

### Option A — Self-contained “unity-like” runner (no download)

```c
/* file: unity_lite.h — small subset of Unity API names */
#ifndef UNITY_LITE_H
#define UNITY_LITE_H

#include <stdio.h>
#include <string.h>

static int Unity_tests;
static int Unity_failures;
static const char *Unity_current;

#define UNITY_BEGIN() \
    do { Unity_tests = 0; Unity_failures = 0; printf("Unity-lite\n"); } while (0)

#define UNITY_END()                                                           \
    do {                                                                      \
        printf("------------\n%d Tests %d Failures\n",                        \
               Unity_tests, Unity_failures);                                  \
        return Unity_failures ? 1 : 0;                                        \
    } while (0)

#define RUN_TEST(fn)                                                          \
    do {                                                                      \
        Unity_tests++;                                                        \
        Unity_current = #fn;                                                  \
        printf("TEST(%s)\n", Unity_current);                                  \
        fn();                                                                 \
    } while (0)

#define TEST_ASSERT_EQUAL_INT(expected, actual)                               \
    do {                                                                      \
        int _e = (int)(expected);                                             \
        int _a = (int)(actual);                                               \
        if (_e != _a) {                                                       \
            Unity_failures++;                                                 \
            printf("  FAIL: %s:%d expected %d was %d\n",                      \
                   __FILE__, __LINE__, _e, _a);                               \
        }                                                                     \
    } while (0)

#define TEST_ASSERT_TRUE(cond)                                                \
    do {                                                                      \
        if (!(cond)) {                                                        \
            Unity_failures++;                                                 \
            printf("  FAIL: %s:%d %s is false\n",                             \
                   __FILE__, __LINE__, #cond);                                \
        }                                                                     \
    } while (0)

#define TEST_ASSERT_EQUAL_STRING(expected, actual)                            \
    do {                                                                      \
        const char *_e = (expected);                                          \
        const char *_a = (actual);                                            \
        if (_e == NULL || _a == NULL || strcmp(_e, _a) != 0) {                \
            Unity_failures++;                                                 \
            printf("  FAIL: %s:%d expected \"%s\" was \"%s\"\n",              \
                   __FILE__, __LINE__,                                        \
                   _e ? _e : "(null)", _a ? _a : "(null)");                   \
        }                                                                     \
    } while (0)

#endif
```

```c
/* file: test_leap_unity.c */
#include "unity_lite.h"

/* Production code under test */
int is_leap_year(int year) {
    if (year % 400 == 0) {
        return 1;
    }
    if (year % 100 == 0) {
        return 0;
    }
    if (year % 4 == 0) {
        return 1;
    }
    return 0;
}

void test_common_year(void) {
    TEST_ASSERT_EQUAL_INT(0, is_leap_year(2019));
}

void test_leap_divisible_by_4(void) {
    TEST_ASSERT_EQUAL_INT(1, is_leap_year(2020));
}

void test_century_not_leap(void) {
    TEST_ASSERT_EQUAL_INT(0, is_leap_year(1900));
}

void test_400_year_leap(void) {
    TEST_ASSERT_EQUAL_INT(1, is_leap_year(2000));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_common_year);
    RUN_TEST(test_leap_divisible_by_4);
    RUN_TEST(test_century_not_leap);
    RUN_TEST(test_400_year_leap);
    return UNITY_END();
}
```

```bash
gcc -std=c17 -Wall -Wextra -o test_leap test_leap_unity.c
./test_leap
```

### Option B — Real Unity (vendored)

If you clone Unity into `third_party/Unity`:

```bash
# Example layout
# third_party/Unity/src/unity.c
# third_party/Unity/src/unity.h
# third_party/Unity/src/unity_internals.h

gcc -std=c17 -Wall -Wextra \
  -I third_party/Unity/src \
  -o test_leap \
  test_leap_unity_real.c third_party/Unity/src/unity.c
```

Real Unity uses the same names (`UNITY_BEGIN`, `RUN_TEST`, `TEST_ASSERT_EQUAL_INT`, `UNITY_END`). Your tests stay almost identical to Option A.

---

## Test-Driven Development (TDD) Walkthrough: `is_leap_year()`

TDD cycle: **Red → Green → Refactor**.

We implement Gregorian leap-year rules:

- Divisible by 400 → leap  
- Else divisible by 100 → not leap  
- Else divisible by 4 → leap  
- Else → not leap  

### Step 0 — Scaffold (no real logic yet)

```c
/* leap.c + test_leap_tdd.c evolution */

int is_leap_year(int year) {
    (void)year;
    return 0; /* deliberately wrong / incomplete */
}
```

### Step 1 — RED: first failing test

```c
/* test_leap_tdd.c */
#include "unity_lite.h"

int is_leap_year(int year); /* or #include "leap.h" */

void test_2020_is_leap(void) {
    TEST_ASSERT_EQUAL_INT(1, is_leap_year(2020));
}

int main(void) {
    UNITY_BEGIN();
    RUN_TEST(test_2020_is_leap);
    return UNITY_END();
}
```

```bash
gcc -std=c17 -Wall -Wextra -o test_leap_tdd test_leap_tdd.c leap.c
./test_leap_tdd
# FAIL: expected 1 was 0
```

### Step 2 — GREEN: minimal code that passes

```c
/* leap.c — first green */
int is_leap_year(int year) {
    return year % 4 == 0;
}
```

```bash
./test_leap_tdd
# OK for 2020
```

### Step 3 — RED: century rule

```c
void test_1900_not_leap(void) {
    TEST_ASSERT_EQUAL_INT(0, is_leap_year(1900));
}

/* main: also RUN_TEST(test_1900_not_leap); */
```

```bash
./test_leap_tdd
# FAIL for 1900 (1900 % 4 == 0 with naive rule)
```

### Step 4 — GREEN: handle centuries

```c
int is_leap_year(int year) {
    if (year % 100 == 0) {
        return 0;
    }
    return year % 4 == 0;
}
```

### Step 5 — RED: year 2000 must be leap

```c
void test_2000_is_leap(void) {
    TEST_ASSERT_EQUAL_INT(1, is_leap_year(2000));
}
```

### Step 6 — GREEN: full Gregorian rule

```c
int is_leap_year(int year) {
    if (year % 400 == 0) {
        return 1;
    }
    if (year % 100 == 0) {
        return 0;
    }
    if (year % 4 == 0) {
        return 1;
    }
    return 0;
}
```

### Step 7 — REFACTOR: keep tests green

```c
int is_leap_year(int year) {
    return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0);
}
```

Re-run the suite after every refactor. All four (or more) tests should still pass.

### Alternate TDD target: `clamp()`

Same cycle with fewer domain rules:

| Phase | Test idea | Implementation |
|-------|-----------|----------------|
| Red | `clamp(5,0,10)==5` | `return 0;` fails |
| Green | return `x` if in range | `return x;` (too simple) |
| Red | `clamp(-1,0,10)==0` | fails |
| Green | lower bound | `if (x < lo) return lo; return x;` |
| Red | `clamp(99,0,10)==10` | fails |
| Green | upper bound | full clamp |
| Refactor | assert `lo <= hi` or document | keep tests green |

---

## Boundary Value Testing

Bugs cluster at edges. Design cases for **just inside**, **on**, and **just outside** valid ranges.

### Integers

```c
#include "unity_lite.h"
#include <limits.h>

int clamp(int x, int lo, int hi) {
    if (x < lo) return lo;
    if (x > hi) return hi;
    return x;
}

void test_clamp_boundaries(void) {
    /* lo / hi themselves */
    TEST_ASSERT_EQUAL_INT(0, clamp(0, 0, 10));
    TEST_ASSERT_EQUAL_INT(10, clamp(10, 0, 10));

    /* just outside */
    TEST_ASSERT_EQUAL_INT(0, clamp(-1, 0, 10));
    TEST_ASSERT_EQUAL_INT(10, clamp(11, 0, 10));

    /* extreme ints */
    TEST_ASSERT_EQUAL_INT(INT_MIN, clamp(INT_MIN, INT_MIN, INT_MAX));
    TEST_ASSERT_EQUAL_INT(INT_MAX, clamp(INT_MAX, INT_MIN, INT_MAX));
    TEST_ASSERT_EQUAL_INT(0, clamp(INT_MIN, 0, 10));
    TEST_ASSERT_EQUAL_INT(10, clamp(INT_MAX, 0, 10));
}
```

### Strings

```c
#include <string.h>
#include <stddef.h>

/* Returns length, or (size_t)-1 on NULL; never walks past maxn */
size_t safe_strnlen(const char *s, size_t maxn) {
    size_t i;
    if (s == NULL) {
        return (size_t)-1;
    }
    for (i = 0; i < maxn; i++) {
        if (s[i] == '\0') {
            return i;
        }
    }
    return maxn;
}

void test_safe_strnlen_boundaries(void) {
    TEST_ASSERT_EQUAL_INT((int)(size_t)-1, (int)safe_strnlen(NULL, 10));
    TEST_ASSERT_EQUAL_INT(0, (int)safe_strnlen("", 10));
    TEST_ASSERT_EQUAL_INT(0, (int)safe_strnlen("abc", 0));
    TEST_ASSERT_EQUAL_INT(3, (int)safe_strnlen("abc", 3));
    TEST_ASSERT_EQUAL_INT(3, (int)safe_strnlen("abc", 100));
    TEST_ASSERT_EQUAL_INT(3, (int)safe_strnlen("abcdef", 3)); /* capped */
}
```

**Boundary checklist for strings**

- `NULL`  
- empty `""`  
- length 1  
- exact buffer size  
- longer than limit  
- non-ASCII / embedded `\0` if relevant  

---

## Table-Driven Tests in C

Encode many cases in an array of structs. One loop runs them all — easy to extend.

```c
/* file: test_leap_table.c */
#include <stdio.h>

int is_leap_year(int year) {
    return (year % 400 == 0) || (year % 4 == 0 && year % 100 != 0);
}

struct leap_case {
    int year;
    int expected; /* 1 leap, 0 not */
    const char *note;
};

static const struct leap_case cases[] = {
    {2019, 0, "common"},
    {2020, 1, "div by 4"},
    {1900, 0, "century"},
    {2000, 1, "div by 400"},
    {1600, 1, "div by 400"},
    {2100, 0, "century"},
    {1,    0, "year 1"},
    {4,    1, "year 4"},
};

int main(void) {
    int failed = 0;
    size_t i;
    size_t n = sizeof cases / sizeof cases[0];

    for (i = 0; i < n; i++) {
        int got = is_leap_year(cases[i].year);
        if (got != cases[i].expected) {
            fprintf(stderr, "FAIL year=%d (%s): expected %d got %d\n",
                    cases[i].year, cases[i].note,
                    cases[i].expected, got);
            failed++;
        } else {
            printf("OK   year=%d (%s)\n", cases[i].year, cases[i].note);
        }
    }

    printf("%zu cases, %d failed\n", n, failed);
    return failed ? 1 : 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o test_leap_table test_leap_table.c
./test_leap_table
```

Table-driven style also works for `clamp`, parsers, and error-code matrices.

---

## Code Coverage with `gcov` / `lcov`

Coverage shows which lines ran during tests — not that logic is correct, but that untested paths exist.

### Instrument and run

```bash
# Compile with coverage (debug-friendly)
gcc -std=c17 -Wall -Wextra -g --coverage \
  -o test_leap test_leap_unity.c

./test_leap

# Per-file summary
gcov test_leap_unity.c
# creates test_leap_unity.c.gcov — open in an editor

# Optional pretty HTML report (install lcov)
lcov --capture --directory . --output-file coverage.info
genhtml coverage.info --output-directory coverage_html
# open coverage_html/index.html
```

**Tips**

- Clean between runs: `rm -f *.gcda *.gcno *.gcov coverage.info`  
- Link with `--coverage` (or `-lgcov` on some toolchains) when splitting objects  
- Aim for high branch coverage on pure logic; 100% line coverage ≠ bug-free  

Example `.gcov` line prefixes:

- `#####:` — never executed  
- `    1:` — executed once  
- `branch  0 taken 0%` — branch never taken (needs another case)  

---

## Sanitizers: Address and Undefined Behavior

GCC/Clang sanitizers catch classes of bugs tests alone may miss.

### AddressSanitizer (ASan)

Detects heap/stack buffer overflows, use-after-free, some leaks.

```c
/* file: bug_overflow.c */
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *p = malloc(4 * sizeof(int));
    if (!p) {
        return 1;
    }
    p[4] = 42; /* one past the end — undefined behavior */
    printf("%d\n", p[0]);
    free(p);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -fsanitize=address -o bug_overflow bug_overflow.c
./bug_overflow
# ASan prints stack of the bad write and the allocation site
```

### UndefinedBehaviorSanitizer (UBSan)

```c
/* file: bug_ub.c */
#include <limits.h>
#include <stdio.h>

int main(void) {
    int x = INT_MAX;
    x = x + 1; /* signed overflow — UB */
    printf("%d\n", x);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -g -fsanitize=undefined -o bug_ub bug_ub.c
./bug_ub
```

### Combined (common for tests)

```bash
gcc -std=c17 -Wall -Wextra -g \
  -fsanitize=address,undefined \
  -o test_leap test_leap_unity.c
./test_leap
```

**CI idea:** run the unit suite under ASan+UBSan on every commit.

ThreadSanitizer (`-fsanitize=thread`) is for races; requires pthreads and is slower.

---

## Integration and System Testing (brief)

- **Integration**: link `module_a.o` + `module_b.o` and exercise the boundary API.  
- **System**: run the finished CLI with shell scripts:

```bash
#!/usr/bin/env bash
set -euo pipefail
./myprog --input sample.txt > out.txt
diff -u expected.txt out.txt
```

- **Regression**: keep golden files under `tests/fixtures/` and fail the pipeline on diff.

---

## Black-Box vs White-Box (quick map)

| Approach | You know | Techniques |
|----------|----------|------------|
| Black box | Spec only | Equivalence classes, boundaries, decision tables |
| White box | Source | Statement/branch/path coverage, data-flow |
| Gray box | Partial | Spec + known module structure |

In unit tests you usually do **white/gray box**; acceptance tests stay closer to black box.

## FIRST and AAA

- **FIRST**: Fast, Independent, Repeatable, Self-validating, Timely  
- **AAA**: Arrange (setup) → Act (call SUT) → Assert (check)  

```c
void test_clamp_above(void) {
    /* Arrange */
    int x = 99, lo = 0, hi = 10;
    /* Act */
    int got = clamp(x, lo, hi);
    /* Assert */
    TEST_ASSERT_EQUAL_INT(10, got);
}
```

---

## Best Practices

1. Keep production code free of test-only `#ifdef` noise when possible — separate `*_test.c` files.  
2. Prefer pure functions for hard logic (easy to table-test).  
3. One clear reason to fail per test (or clearly named multi-assert tests).  
4. Run tests and sanitizers before every push.  
5. Treat flaky tests as bugs (timing, order, shared files).  
6. Do not commit coverage HTML; generate it in CI artifacts.  

---

## Exercises

### Exercise 1 — Custom harness for `clamp`

Implement `int clamp(int x, int lo, int hi)` and a `mini_test.h` suite covering inside, below, above, and `INT_MIN`/`INT_MAX`. Build with:

```bash
gcc -std=c17 -Wall -Wextra -o test_clamp test_clamp.c
```

### Exercise 2 — TDD `int max3(int a, int b, int c)`

Write failing tests first, implement, then refactor. Include cases where the max is in the first, second, and third argument, and all equal.

### Exercise 3 — Table-driven string trim

Write `void trim_inplace(char *s)` that removes leading/trailing ASCII spaces. Drive tests from a table of `{input, expected}` pairs (use a writable buffer per case). Include empty string, all spaces, no spaces, and mixed.

### Exercise 4 — Coverage gap hunt

Take `is_leap_year` and deliberately omit the year-2000 test. Run `gcov` and show which branch is under-tested. Add the missing case and re-check.

### Exercise 5 — Sanitizer lab

Write a small program with a deliberate heap overflow. Confirm it “works” without sanitizers (undefined — may print garbage or crash). Rebuild with `-fsanitize=address` and capture the report. Fix the bug and re-run clean.

### Exercise 6 — Boundary design

For a function `int parse_port(const char *s, int *out)` that accepts `"1"`…`"65535"`, list at least ten boundary/equivalence cases (NULL, `""`, `"0"`, `"1"`, `"65535"`, `"65536"`, leading zeros, non-digits, etc.) and implement tests.

---

## Summary

| Technique | When to use |
|-----------|-------------|
| `assert` | Tiny checks, throwaway scripts |
| Custom `TEST` macros | Portable unit suites with no deps |
| Unity-style runner | Familiar API / embeddable projects |
| TDD | New pure logic, clear contracts |
| Table-driven tests | Many similar cases |
| Boundary analysis | Ranges, sizes, parsers |
| `gcov`/`lcov` | Find untested lines/branches |
| ASan/UBSan | Memory safety and undefined behavior |

Testing in C is mostly **discipline and tooling**, not language magic. A small harness plus tables, boundaries, coverage, and sanitizers will catch most defects before they leave your machine.
