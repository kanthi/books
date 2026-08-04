# Code Quality

Code quality is a measure of how well software code meets specified requirements and satisfies user needs. High-quality code is not only functional but also maintainable, readable, and efficient. This chapter explores various aspects of code quality in C programming and best practices to achieve it — with **complete programs** you can compile under a strict warning set.

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o prog prog.c
```

Treat `-Werror` as a quality gate once the code is past the first sketch.

## Introduction to Code Quality

Code quality encompasses multiple dimensions that contribute to the overall excellence of software. It's not just about whether the code works, but also about how well it works, how easy it is to maintain, and how reliably it performs over time.

### Dimensions of Code Quality

1. **Correctness**: The code produces the expected results
2. **Reliability**: The code performs consistently under various conditions
3. **Efficiency**: The code uses resources optimally
4. **Maintainability**: The code is easy to modify and extend
5. **Readability**: The code is easy to understand
6. **Testability**: The code can be easily tested
7. **Portability**: The code works across different platforms
8. **Security**: The code is resistant to vulnerabilities

## Coding Standards and Style Guidelines

Consistent coding standards improve code readability and maintainability. They provide a common framework for developers to follow.

### Naming Conventions

```c
// Good naming conventions
int user_age;                    // Descriptive variable names
double calculate_circle_area(double radius);  // Descriptive function names
const int MAX_BUFFER_SIZE = 1024;  // Constants in uppercase

// Avoid cryptic names
int x;          // What does x represent?
int f(int a);   // What does f do?
```

### Code Formatting

Consistent indentation and spacing improve code readability:

```c
// Well-formatted code
int calculate_sum(int array[], int size) {
    int sum = 0;
    
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }
    
    return sum;
}

// Poorly formatted code (avoid this)
int calculate_sum(int array[],int size){
int sum=0;
for(int i=0;i<size;i++){
sum+=array[i];}
return sum;}
```

### Commenting Best Practices

Comments should explain the "why" rather than the "what":

```c
// Good comments - explain the reasoning
void initialize_buffer(Buffer *buf) {
    // Initialize to zero to prevent undefined behavior
    buf->size = 0;
    buf->capacity = INITIAL_CAPACITY;
    
    // Allocate memory with extra space to reduce reallocations
    buf->data = malloc(buf->capacity * sizeof(int));
}

// Avoid redundant comments
int x = 5;  // Set x to 5 (obvious from code)
```

## Code Review Practices

Code reviews are essential for maintaining code quality and sharing knowledge among team members.

### Benefits of Code Reviews

- **Bug Detection**: Catch defects before they reach production
- **Knowledge Sharing**: Spread expertise across the team
- **Consistency**: Ensure adherence to coding standards
- **Mentoring**: Help junior developers improve
- **Design Feedback**: Get input on architectural decisions

### Code Review Checklist

1. **Functionality**: Does the code meet requirements?
2. **Correctness**: Are there any logical errors?
3. **Readability**: Is the code easy to understand?
4. **Maintainability**: Is the code easy to modify?
5. **Performance**: Are there any efficiency concerns?
6. **Security**: Are there potential vulnerabilities?
7. **Standards**: Does the code follow established guidelines?

### Example Code Review

```c
// Before review
int process(int*a,int b){int c=0;for(int d=0;d<b;d++){c+=a[d];}return c;}

// After review
/**
 * Calculate the sum of integers in an array.
 * 
 * @param array Array of integers to sum
 * @param size Number of elements in the array
 * @return Sum of all elements in the array
 */
int calculate_array_sum(int *array, int size) {
    // Validate input parameters
    if (array == NULL || size < 0) {
        return -1; // Error case
    }
    
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }
    
    return sum;
}
```

## Static Analysis Tools

Static analysis tools examine source code without executing it to find potential issues.

### GCC with Warnings

GCC provides extensive warning options to catch common issues:

```bash
# Compile with comprehensive warnings
gcc -Wall -Wextra -Werror -pedantic -std=c99 program.c

# Explanation of flags:
# -Wall: Enable most warning messages
# -Wextra: Enable additional warnings
# -Werror: Treat warnings as errors
# -pedantic: Issue warnings for non-standard C
# -std=c99: Specify C standard
```

### Cppcheck

Cppcheck is a static analysis tool specifically designed for C/C++:

```bash
# Basic usage
cppcheck program.c

# More thorough analysis
cppcheck --enable=all --inconclusive program.c

# Check specific directories
cppcheck --enable=all src/
```

### Clang Static Analyzer

The Clang Static Analyzer detects bugs and potential issues:

```bash
# Analyze with Clang
clang --analyze program.c

# Generate HTML reports
scan-build make
```

## Code Formatting and Style Tools

Automated tools help maintain consistent code style across projects.

### Clang-Format

Clang-Format automatically formats C code according to specified rules:

```bash
# Format a single file
clang-format -i program.c

# Format multiple files
find . -name "*.c" -o -name "*.h" | xargs clang-format -i

# Use a specific style
clang-format -style=Google -i program.c
```

### AStyle (Artistic Style)

AStyle is another popular code formatter:

```bash
# Format with Allman style
astyle --style=allman *.c *.h

# Format with K&R style
astyle --style=kr *.c *.h
```

## Test Coverage Analysis

Test coverage measures how much of your code is exercised by tests.

### GCC with Coverage

GCC can generate coverage information:

```bash
# Compile with coverage instrumentation
gcc -fprofile-arcs -ftest-coverage -o program program.c

# Run the program
./program

# Generate coverage report
gcov program.c

# Generate HTML report with lcov
lcov --capture --directory . --output-file coverage.info
genhtml coverage.info --output-directory coverage_report
```

### Coverage Metrics

1. **Statement Coverage**: Percentage of statements executed
2. **Branch Coverage**: Percentage of branches taken
3. **Function Coverage**: Percentage of functions called
4. **Line Coverage**: Percentage of lines executed

## Performance Analysis

Performance analysis helps identify bottlenecks and optimize code.

### Profiling with gprof

gprof provides function-level profiling information:

```bash
# Compile with profiling enabled
gcc -pg -o program program.c

# Run the program
./program

# Generate profiling report
gprof program gmon.out > analysis.txt
```

### Profiling with perf

perf is a powerful Linux profiling tool:

```bash
# Profile a program
perf record ./program

# Analyze results
perf report

# View call graph
perf record -g ./program
perf report -g
```

## Security Best Practices

Security should be considered throughout the development process.

### Input Validation

Always validate input to prevent buffer overflows and injection attacks:

```c
#include <stdio.h>
#include <string.h>

// Unsafe function (vulnerable to buffer overflow)
void unsafe_copy(char *dest, char *src) {
    strcpy(dest, src);  // Dangerous!
}

// Safe function with bounds checking
int safe_copy(char *dest, size_t dest_size, const char *src) {
    if (dest == NULL || src == NULL || dest_size == 0) {
        return -1; // Error
    }
    
    size_t src_len = strlen(src);
    if (src_len >= dest_size) {
        return -1; // Buffer too small
    }
    
    strcpy(dest, src);
    return 0; // Success
}
```

### Memory Safety

Proper memory management prevents common security vulnerabilities:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Secure memory handling
char* duplicate_string(const char *source) {
    if (source == NULL) {
        return NULL;
    }
    
    size_t len = strlen(source);
    char *copy = malloc(len + 1);
    
    if (copy == NULL) {
        return NULL; // Allocation failed
    }
    
    strcpy(copy, source);
    return copy;
}

void free_string(char *str) {
    if (str != NULL) {
        free(str);
        str = NULL; // Prevent dangling pointer (local copy only)
    }
}
```

### Secure Coding Practices

1. **Use Safe Functions**: Prefer `strncpy` over `strcpy`, `snprintf` over `sprintf`
2. **Validate Pointers**: Always check for NULL pointers
3. **Bounds Checking**: Verify array indices and buffer sizes
4. **Integer Overflow**: Check for arithmetic overflow
5. **Format Strings**: Use constant format strings with printf/scanf

## Documentation and Code Comments

Good documentation is essential for code quality and maintainability.

### Self-Documenting Code

Write code that is easy to understand without excessive comments:

```c
// Self-documenting approach
typedef enum {
    USER_STATUS_ACTIVE,
    USER_STATUS_INACTIVE,
    USER_STATUS_SUSPENDED
} UserStatus;

typedef struct {
    char username[50];
    UserStatus status;
    time_t last_login;
} User;

int is_user_active(const User *user) {
    return user != NULL && user->status == USER_STATUS_ACTIVE;
}

// Avoid unclear code
int check_user(int a, int b) {  // What do a and b represent?
    return a == 1 && b > 0;     // What does this check mean?
}
```

### API Documentation

Document public APIs with clear descriptions and examples:

```c
/**
 * @brief Calculate the factorial of a non-negative integer.
 * 
 * This function calculates the factorial of a given non-negative integer
 * using an iterative approach. The factorial of n is the product of all
 * positive integers less than or equal to n.
 * 
 * @param n The non-negative integer to calculate factorial for
 * @return The factorial of n, or -1 if n is negative
 * 
 * @note This function can overflow for large values of n (n > 20)
 * 
 * Example usage:
 * @code
 * int result = factorial(5);  // Returns 120
 * @endcode
 */
int factorial(int n) {
    if (n < 0) {
        return -1; // Error case
    }
    
    if (n == 0 || n == 1) {
        return 1;
    }
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    
    return result;
}
```

## Refactoring and Code Improvement

Regular refactoring improves code quality over time.

### Code Smells to Avoid

1. **Long Functions**: Functions that are too long and complex
2. **Duplicated Code**: Same or similar code in multiple places
3. **Complex Conditionals**: Overly complex if/else statements
4. **Magic Numbers**: Unexplained numeric constants in code
5. **Inappropriate Intimacy**: Functions that access internal data directly

### Refactoring Example

```c
// Before refactoring - complex and hard to understand
double calculate_discount(double price, int customer_type, int quantity) {
    if (customer_type == 1) {
        if (quantity > 100) {
            return price * 0.2;
        } else if (quantity > 50) {
            return price * 0.15;
        } else {
            return price * 0.1;
        }
    } else if (customer_type == 2) {
        if (quantity > 100) {
            return price * 0.3;
        } else if (quantity > 50) {
            return price * 0.25;
        } else {
            return price * 0.2;
        }
    } else {
        if (quantity > 100) {
            return price * 0.1;
        } else if (quantity > 50) {
            return price * 0.05;
        } else {
            return 0;
        }
    }
}

// After refactoring - clean and maintainable
typedef enum {
    CUSTOMER_REGULAR,
    CUSTOMER_PREMIUM,
    CUSTOMER_VIP
} CustomerType;

typedef struct {
    double threshold_100;
    double threshold_50;
    double base_rate;
} DiscountRates;

static const DiscountRates DISCOUNT_RATES[] = {
    [CUSTOMER_REGULAR] = {0.2, 0.15, 0.1},
    [CUSTOMER_PREMIUM] = {0.3, 0.25, 0.2},
    [CUSTOMER_VIP] = {0.1, 0.05, 0.0}
};

double calculate_discount(double price, CustomerType customer_type, int quantity) {
    if (customer_type < 0 || customer_type >= sizeof(DISCOUNT_RATES)) {
        return 0; // Invalid customer type
    }
    
    const DiscountRates *rates = &DISCOUNT_RATES[customer_type];
    
    if (quantity > 100) {
        return price * rates->threshold_100;
    } else if (quantity > 50) {
        return price * rates->threshold_50;
    } else {
        return price * rates->base_rate;
    }
}
```

## Full Programs: Quality Gates You Can Run Locally

### Program 1 — Strict-warning “clean” module (`clamp_lib`)

A small pure function plus a self-test binary. Clean under `-Werror`.

```c
/* file: clamp.c */
#include <stdio.h>
#include <stdlib.h>
#include <limits.h>

/* Returns x clamped to [lo, hi]. If lo > hi, returns lo (documented choice). */
int clamp(int x, int lo, int hi) {
    if (lo > hi) {
        return lo;
    }
    if (x < lo) {
        return lo;
    }
    if (x > hi) {
        return hi;
    }
    return x;
}

#ifdef CLAMP_MAIN
int main(void) {
    struct {
        int x, lo, hi, want;
    } cases[] = {
        {5, 0, 10, 5},
        {-1, 0, 10, 0},
        {99, 0, 10, 10},
        {0, 0, 0, 0},
        {INT_MAX, 0, 10, 10},
        {INT_MIN, -10, 10, -10},
    };
    size_t i;
    int failed = 0;

    for (i = 0; i < sizeof cases / sizeof cases[0]; i++) {
        int got = clamp(cases[i].x, cases[i].lo, cases[i].hi);
        if (got != cases[i].want) {
            fprintf(stderr, "case %zu: clamp(%d,%d,%d)=%d want %d\n",
                    i, cases[i].x, cases[i].lo, cases[i].hi, got, cases[i].want);
            failed = 1;
        }
    }
    if (failed) {
        return EXIT_FAILURE;
    }
    puts("clamp: all cases passed");
    return EXIT_SUCCESS;
}
#endif
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -DCLAMP_MAIN -o clamp_test clamp.c
./clamp_test
```

### Program 2 — Warning archaeology (`smell.c` → `clean.c`)

Start with a deliberately smelly program, record warnings, then fix.

```c
/* file: smell.c — DO NOT ship; for warning lab only */
#include <stdio.h>
#include <string.h>

int helper();  /* no prototype details */

int main() {
    int unused;
    char buf[8];
    char *p = 0;

    strcpy(buf, "toolongforbuffer");  /* overflow risk */
    if (p)
        printf("%s\n", p);
    printf("%d\n", helper(1, 2));
    return 0;
}

int helper(int a, int b) {
    return a + b;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -c smell.c 2> smell_warnings.txt
cat smell_warnings.txt
```

Clean rewrite:

```c
/* file: clean.c */
#include <stdio.h>
#include <string.h>

static int helper(int a, int b);

int main(void) {
    char buf[8];

    /* bounded copy + explicit truncation detection */
    if (snprintf(buf, sizeof buf, "%s", "toolongforbuffer") >= (int)sizeof buf) {
        fprintf(stderr, "warning: truncated\n");
    }
    printf("buf=\"%s\"\n", buf);
    printf("sum=%d\n", helper(1, 2));
    return 0;
}

static int helper(int a, int b) {
    return a + b;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o clean clean.c
./clean
```

### Program 3 — Complexity reduction: nested ifs → early return

```c
/* file: access.c */
#include <stdio.h>
#include <stdbool.h>

struct User {
    bool active;
    bool banned;
    int age;
    int role;  /* 0 guest, 1 user, 2 admin */
};

/* Opaque quality: one exit path per failure reason, easy to test. */
const char *can_edit(const struct User *u) {
    if (u == NULL) {
        return "null user";
    }
    if (!u->active) {
        return "inactive";
    }
    if (u->banned) {
        return "banned";
    }
    if (u->age < 13) {
        return "underage";
    }
    if (u->role < 1) {
        return "guest cannot edit";
    }
    return NULL;  /* allowed */
}

int main(void) {
    struct User samples[] = {
        {true, false, 20, 1},
        {false, false, 20, 1},
        {true, true, 20, 2},
        {true, false, 10, 1},
        {true, false, 25, 0},
    };
    size_t i;

    for (i = 0; i < sizeof samples / sizeof samples[0]; i++) {
        const char *err = can_edit(&samples[i]);
        if (err == NULL) {
            printf("sample %zu: OK\n", i);
        } else {
            printf("sample %zu: DENY (%s)\n", i, err);
        }
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o access access.c
./access
```

### Program 4 — Static assertions and size contracts

```c
/* file: layout_check.c */
#include <stdio.h>
#include <stddef.h>
#include <stdint.h>
#include <assert.h>

struct PacketHdr {
    uint16_t type;
    uint16_t len;
    uint32_t id;
};

/* Catch ABI surprises at compile time */
_Static_assert(sizeof(struct PacketHdr) == 8, "PacketHdr must be 8 bytes");
_Static_assert(offsetof(struct PacketHdr, id) == 4, "id offset");

int main(void) {
    struct PacketHdr h = {1, 16, 42};
    printf("type=%u len=%u id=%u size=%zu\n",
           h.type, h.len, h.id, sizeof h);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o layout_check layout_check.c
./layout_check
```

### Program 5 — Local quality script (`check.sh` + target)

```c
/* file: avg.c */
#include <stdio.h>
#include <stdlib.h>

double average(const int *a, size_t n) {
    size_t i;
    long sum = 0;

    if (a == NULL || n == 0) {
        return 0.0;
    }
    for (i = 0; i < n; i++) {
        sum += a[i];
    }
    return (double)sum / (double)n;
}

int main(void) {
    int v[] = {1, 2, 3, 4};
    printf("%.2f\n", average(v, 4));
    return 0;
}
```

```bash
# file: check.sh
#!/usr/bin/env bash
set -euo pipefail
CFLAGS=(-std=c17 -Wall -Wextra -Wpedantic -Werror -g)
gcc "${CFLAGS[@]}" -o avg avg.c
./avg
# optional tools if installed:
if command -v cppcheck >/dev/null; then
  cppcheck --enable=warning,style --error-exitcode=1 avg.c
fi
if command -v valgrind >/dev/null; then
  valgrind --error-exitcode=1 --leak-check=full ./avg
fi
echo "quality gate: OK"
```

```bash
chmod +x check.sh
./check.sh
```

### Program 6 — Review checklist applied to a PR-sized change

Before you merge any non-trivial C change, walk this list (paste into PR template if you want):

```text
[ ] Builds with -std=c17 -Wall -Wextra (and -Werror in CI)
[ ] No new compiler warnings
[ ] Every public function documents ownership (who frees?)
[ ] Error paths free / close what success paths free / close
[ ] No unbounded strcpy/sprintf/gets
[ ] Integer sizes / casts reviewed for truncation
[ ] Tests or a tiny main demo for the changed logic
[ ] Sanitizer or Valgrind run if memory/pointers touched
```

Example “before” (fails several checks):

```c
char *load(const char *path) {
    FILE *fp = fopen(path, "r");
    char *buf = malloc(1024);
    fread(buf, 1, 1024, fp);  /* no checks, no NUL, leak on error */
    return buf;
}
```

Example “after”:

```c
/* file: load_text.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

/* Caller frees the returned buffer. Returns NULL on error. */
char *load_text(const char *path, size_t max_n) {
    FILE *fp;
    char *buf;
    size_t n;

    if (path == NULL || max_n == 0) {
        return NULL;
    }
    fp = fopen(path, "rb");
    if (fp == NULL) {
        return NULL;
    }
    buf = malloc(max_n + 1);
    if (buf == NULL) {
        fclose(fp);
        return NULL;
    }
    n = fread(buf, 1, max_n, fp);
    if (ferror(fp)) {
        free(buf);
        fclose(fp);
        return NULL;
    }
    buf[n] = '\0';
    fclose(fp);
    return buf;
}

int main(int argc, char *argv[]) {
    char *s;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        return EXIT_FAILURE;
    }
    s = load_text(argv[1], 4096);
    if (s == NULL) {
        fprintf(stderr, "load failed: %s\n", strerror(errno));
        return EXIT_FAILURE;
    }
    fputs(s, stdout);
    free(s);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o load_text load_text.c
echo 'hello quality' > t.txt
./load_text t.txt
```

---

## Continuous Integration and Quality Gates

Continuous Integration (CI) helps maintain code quality by automatically testing and validating changes.

### CI Pipeline Components

1. **Automated Builds**: Compile code on every change
2. **Static Analysis**: Run code quality tools automatically
3. **Unit Tests**: Execute test suite on every change
4. **Code Coverage**: Measure test coverage
5. **Security Scans**: Check for vulnerabilities
6. **Deployment**: Automatically deploy passing builds

### Example CI Configuration

```yaml
# .github/workflows/ci.yml
name: C CI

on: [push, pull_request]

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v4

    - name: Install dependencies
      run: |
        sudo apt-get update
        sudo apt-get install -y gcc valgrind cppcheck

    - name: Compile with warnings as errors
      run: gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o program program.c

    - name: Static analysis
      run: cppcheck --enable=warning,style --error-exitcode=1 .

    - name: Run tests
      run: ./run_tests.sh

    - name: Memory check
      run: valgrind --error-exitcode=1 --leak-check=full ./program
```

### Local gate ≈ CI gate

If it does not pass `check.sh` on your laptop, it should not pass in CI. Keep the same flags in both places.

---

## Exercises

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -Werror -o exN exN.c
```

1. **Warning farm** — Write a 20-line file that triggers at least four distinct `-Wall -Wextra` diagnostics. Fix them one by one until `-Werror` is clean. Keep the smelly version in a comment.

2. **`clamp` table** — Add five more edge cases to `clamp_test` (including `lo > hi`) and make the policy explicit in a comment.

3. **Refactor nest** — Take a function with three nested `if`s from your own code (or invent one) and rewrite with early returns. Confirm behavior with a small table of cases.

4. **`_Static_assert`** — Define a struct with intentional padding; assert `sizeof` and an `offsetof`. Change a field type and watch the assert fire.

5. **`load_text` growth** — Extend `load_text` to grow with `realloc` until EOF (cap at e.g. 1 MiB). Prove no leaks under Valgrind or ASan.

6. **`check.sh` for multi-file** — Point the script at `main.c` + `util.c`, fail the script if any command fails, and add an optional sanitizer build.

7. **Review role-play** — Review `smell.c` as if it were a PR. Write five bullet comments a reviewer should leave.

8. **Complexity budget** — Count decision points (`if`/`case`/`&&`/`||`/`for`/`while`) in one function; if over 10, split it.

---

## Conclusion

Code quality is not a one-time achievement but an ongoing commitment. By following established coding standards, conducting regular code reviews, using automated tools, and continuously refactoring, developers can maintain high-quality codebases that are robust, maintainable, and secure.

Practical baseline for this book:

| Gate | Command / habit |
|------|------------------|
| Warnings | `-Wall -Wextra -Wpedantic` (+ `-Werror` in CI) |
| Memory | ASan/UBSan or Valgrind on pointer-heavy changes |
| Structure | Early returns, clear ownership, small functions |
| Proof | Table-driven tests or a tiny self-check `main` |
| Process | Checklist + same flags locally and in CI |

The investment in code quality pays dividends throughout the software lifecycle, reducing bugs, improving maintainability, and enhancing the overall developer experience.