# Loops

## Introduction

Loops are control structures that allow programs to repeat a block of code multiple times. They are essential for processing collections of data, implementing algorithms, and automating repetitive tasks. C provides three main loop kinds: `while`, `do-while`, and `for`.

This chapter covers syntax, a **for vs while vs do-while** decision guide, nested patterns, infinite loops for servers/embedded-style code, worked examples (primes, FizzBuzz, tables, running average), and exercises.

**Compile convention:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
./program
```

## The while Loop

The `while` loop is a **pre-test** loop: the condition is evaluated before each iteration. The body may run zero times.

### Basic Syntax

```c
while (condition) {
    // Code to execute repeatedly
}
```

### Simple while Loop

```c
#include <stdio.h>

int main(void) {
    int count = 1;

    while (count <= 5) {
        printf("Count: %d\n", count);
        count++;  /* must update the control variable */
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o while_simple while_simple.c
./while_simple
```

### while with User Input

```c
#include <stdio.h>

int main(void) {
    int number;

    printf("Enter positive numbers (0 to stop):\n");
    if (scanf("%d", &number) != 1) {
        return 1;
    }

    while (number > 0) {
        printf("You entered: %d\n", number);
        if (scanf("%d", &number) != 1) {
            break;
        }
    }

    printf("Loop ended.\n");
    return 0;
}
```

## The do-while Loop

The `do-while` loop is a **post-test** loop: the body runs **at least once**, then the condition is checked.

### Basic Syntax

```c
do {
    // Code to execute
} while (condition);  /* note the trailing semicolon */
```

### Simple do-while

```c
#include <stdio.h>

int main(void) {
    int count = 1;

    do {
        printf("Count: %d\n", count);
        count++;
    } while (count <= 5);

    return 0;
}
```

### Menu Pattern (classic do-while use)

```c
#include <stdio.h>

int main(void) {
    int choice;

    do {
        printf("\n=== Menu ===\n");
        printf("1. Option 1\n");
        printf("2. Option 2\n");
        printf("0. Exit\n");
        printf("Choice: ");
        if (scanf("%d", &choice) != 1) {
            int ch;
            while ((ch = getchar()) != '\n' && ch != EOF) {
            }
            choice = -1;
            continue;
        }

        switch (choice) {
            case 1: printf("Option 1\n"); break;
            case 2: printf("Option 2\n"); break;
            case 0: printf("Exiting...\n"); break;
            default: printf("Invalid choice.\n"); break;
        }
    } while (choice != 0);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o menu_do menu_do.c
./menu_do
```

## The for Loop

The `for` loop packs initialization, condition, and update in one place. Ideal when iteration count or index range is clear.

### Basic Syntax

```c
for (initialization; condition; update) {
    // body
}
```

### Simple for Loop

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 5; i++) {
        printf("Count: %d\n", i);
    }
    return 0;
}
```

### for with Arrays

```c
#include <stdio.h>

int main(void) {
    int numbers[] = {10, 20, 30, 40, 50};
    int size = (int)(sizeof numbers / sizeof numbers[0]);

    for (int i = 0; i < size; i++) {
        printf("numbers[%d] = %d\n", i, numbers[i]);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o for_array for_array.c
./for_array
```

Any of the three `for` clauses may be empty:

```c
int i = 0;
for (; i < 10; ) {
    printf("%d\n", i);
    i++;
}
```

---

## Decision Guide: for vs while vs do-while

| Situation | Prefer | Why |
|-----------|--------|-----|
| Known count / index over a range | **`for`** | Init, test, and step live together; hard to forget the step |
| Iterate until a **runtime condition** (file ends, sentinel input) | **`while`** | Condition is the story; body may not run |
| Must show a menu / prompt **at least once** | **`do-while`** | Post-test guarantees one execution |
| Event loop / server / firmware “forever” | **`while (1)` or `for (;;)`** | Exit only via `break`, return, or signal |
| Multiple control variables advanced together | **`for`** (multi-update) | e.g. `for (i = 0, j = n-1; i < j; i++, j--)` |

### Same Task Three Ways

Sum integers from 1 to `n`:

```c
#include <stdio.h>

int main(void) {
    int n = 10;
    long sum;

    /* for — clearest for counted range */
    sum = 0;
    for (int i = 1; i <= n; i++) {
        sum += i;
    }
    printf("for:      %ld\n", sum);

    /* while — same logic, control variable outside */
    sum = 0;
    int i = 1;
    while (i <= n) {
        sum += i;
        i++;
    }
    printf("while:    %ld\n", sum);

    /* do-while — awkward if n could be 0; body always runs once */
    sum = 0;
    i = 1;
    if (n >= 1) {
        do {
            sum += i;
            i++;
        } while (i <= n);
    }
    printf("do-while: %ld\n", sum);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o sum_three sum_three.c
./sum_three
```

### When while Beats for

Reading until failure — the “next value” is also the loop condition:

```c
#include <stdio.h>

int main(void) {
    int x;
    long sum = 0;
    int count = 0;

    printf("Enter integers; non-numeric or EOF ends input:\n");
    while (scanf("%d", &x) == 1) {
        sum += x;
        count++;
    }

    if (count == 0) {
        printf("No numbers.\n");
    } else {
        printf("count=%d sum=%ld avg=%.2f\n",
               count, sum, (double)sum / count);
    }
    return 0;
}
```

---

## Loop Control: break and continue

### break

Leaves the **innermost** loop immediately.

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 10; i++) {
        if (i == 5) {
            break;
        }
        printf("%d ", i);
    }
    printf("\nDone.\n");
    return 0;
}
```

### continue

Skips the rest of the current iteration and proceeds to the next test/update.

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 10; i++) {
        if (i % 2 == 0) {
            continue;  /* skip evens */
        }
        printf("%d ", i);
    }
    printf("\n");
    return 0;
}
```

---

## Nested Loops

### Multiplication Table Pattern

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 5; j++) {
            printf("%4d", i * j);
        }
        printf("\n");
    }
    return 0;
}
```

### Nested break/continue Scope

`break` and `continue` affect only the **inner** loop unless you use flags or `goto` (rare) for multi-level exit.

```c
#include <stdio.h>

int main(void) {
    for (int i = 1; i <= 3; i++) {
        printf("outer %d\n", i);
        for (int j = 1; j <= 5; j++) {
            if (j == 3) {
                continue;  /* next j */
            }
            if (i == 2 && j == 4) {
                break;     /* leave inner only */
            }
            printf("  inner %d\n", j);
        }
    }
    return 0;
}
```

### Nested Loop Patterns Cheatsheet

| Pattern | Structure | Use |
|---------|-----------|-----|
| Rectangle | outer rows × inner cols | grids, matrices, tables |
| Triangle | inner runs to `i` or `n-i` | patterns, combinations prefix |
| Pairwise | `for i` / `for j = i+1` | unique pairs without double count |
| 2D walk | `for r` / `for c` over `a[r][c]` | images, boards |

```c
#include <stdio.h>

int main(void) {
    int n = 4;

    printf("Triangle:\n");
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }

    printf("\nUnique pairs (i < j):\n");
    for (int i = 0; i < n; i++) {
        for (int j = i + 1; j < n; j++) {
            printf("(%d,%d) ", i, j);
        }
    }
    printf("\n");
    return 0;
}
```

---

## Infinite Loops (Servers, Embedded, Tools)

Infinite loops are normal when the process should run until an explicit stop condition.

### Forms

```c
while (1) { /* ... */ }
while (true) { /* need stdbool.h */ }
for (;;) { /* idiomatic “forever” */ }
```

### Pattern: Event Loop with break Conditions

```c
/* event_loop_demo.c — desktop stand-in for a service loop */
#include <stdio.h>
#include <stdbool.h>
#include <string.h>

int main(void) {
    char line[128];
    bool running = true;
    unsigned long ticks = 0;

    printf("Commands: status | quit | panic\n");

    while (running) {
        ticks++;
        printf("> ");
        if (!fgets(line, sizeof line, stdin)) {
            /* EOF: clean shutdown */
            break;
        }

        /* strip newline */
        line[strcspn(line, "\n")] = '\0';

        if (strcmp(line, "quit") == 0) {
            running = false;          /* graceful flag */
        } else if (strcmp(line, "panic") == 0) {
            printf("Fatal: breaking out immediately.\n");
            break;                    /* hard exit from loop */
        } else if (strcmp(line, "status") == 0) {
            printf("ticks=%lu running=%d\n", ticks, running);
        } else if (line[0] != '\0') {
            printf("Unknown command: %s\n", line);
        }

        /* In a real server: poll sockets, handle timers, etc. here */
    }

    printf("Shutdown after %lu loop iterations.\n", ticks);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o event_loop_demo event_loop_demo.c
printf 'status\nquit\n' | ./event_loop_demo
```

### Pattern: Embedded-Style Superloop

```c
#include <stdio.h>
#include <stdbool.h>

/* Simulated “hardware” flags */
static volatile bool g_button_irq;
static volatile bool g_shutdown;

static void poll_inputs(void) {
    /* On bare metal: read GPIO. Here we fake nothing. */
}

static void service_button(void) {
    if (g_button_irq) {
        g_button_irq = false;
        printf("button handled\n");
    }
}

/* Call this many times; break when shutdown requested */
static void superloop_iteration(void) {
    poll_inputs();
    service_button();
    /* feed watchdog, sleep until interrupt, etc. */
}

int main(void) {
    int simulated_cycles = 0;

    for (;;) {
        superloop_iteration();
        simulated_cycles++;

        /* Host demo stop conditions */
        if (simulated_cycles >= 3) {
            g_shutdown = true;
        }
        if (g_shutdown) {
            break;
        }
    }

    printf("MCU superloop exited cleanly.\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o superloop superloop.c
./superloop
```

### Pattern: Retry with Cap (avoid true infinite hang)

```c
#include <stdio.h>
#include <stdbool.h>

static bool try_connect(int attempt) {
    printf("connect attempt %d\n", attempt);
    return attempt >= 3;  /* succeed on 3rd try in this demo */
}

int main(void) {
    const int max_attempts = 5;
    int attempt = 0;
    bool ok = false;

    while (attempt < max_attempts) {
        attempt++;
        if (try_connect(attempt)) {
            ok = true;
            break;
        }
    }

    printf(ok ? "Connected.\n" : "Gave up.\n");
    return ok ? 0 : 1;
}
```

---

## Worked Example 1: Prime Check

```c
/* prime_check.c */
#include <stdio.h>
#include <stdbool.h>
#include <math.h>

static bool is_prime(long n) {
    if (n <= 1) {
        return false;
    }
    if (n <= 3) {
        return true;
    }
    if (n % 2 == 0 || n % 3 == 0) {
        return false;
    }
    /* check 6k ± 1 up to sqrt(n) */
    for (long i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) {
            return false;
        }
    }
    return true;
}

int main(void) {
    long n;
    printf("Enter integer: ");
    if (scanf("%ld", &n) != 1) {
        printf("Invalid input.\n");
        return 1;
    }

    if (is_prime(n)) {
        printf("%ld is prime.\n", n);
    } else {
        printf("%ld is not prime.\n", n);
    }

    printf("Primes up to 50: ");
    for (long i = 2; i <= 50; i++) {
        if (is_prime(i)) {
            printf("%ld ", i);
        }
    }
    printf("\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o prime_check prime_check.c
echo 97 | ./prime_check
```

---

## Worked Example 2: FizzBuzz

```c
/* fizzbuzz.c */
#include <stdio.h>

int main(void) {
    int limit = 30;

    for (int i = 1; i <= limit; i++) {
        if (i % 15 == 0) {
            printf("FizzBuzz\n");
        } else if (i % 3 == 0) {
            printf("Fizz\n");
        } else if (i % 5 == 0) {
            printf("Buzz\n");
        } else {
            printf("%d\n", i);
        }
    }

    /* Compact variant with continue-style layering */
    printf("--- compact ---\n");
    for (int i = 1; i <= 15; i++) {
        int printed = 0;
        if (i % 3 == 0) {
            printf("Fizz");
            printed = 1;
        }
        if (i % 5 == 0) {
            printf("Buzz");
            printed = 1;
        }
        if (!printed) {
            printf("%d", i);
        }
        printf("\n");
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o fizzbuzz fizzbuzz.c
./fizzbuzz
```

---

## Worked Example 3: Multiplication Table

```c
/* mult_table.c */
#include <stdio.h>

int main(void) {
    int n;

    printf("Table size (1-12): ");
    if (scanf("%d", &n) != 1 || n < 1 || n > 12) {
        printf("Use an integer from 1 to 12.\n");
        return 1;
    }

    printf("    ");
    for (int c = 1; c <= n; c++) {
        printf("%4d", c);
    }
    printf("\n");

    for (int r = 1; r <= n; r++) {
        printf("%4d", r);
        for (int c = 1; c <= n; c++) {
            printf("%4d", r * c);
        }
        printf("\n");
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o mult_table mult_table.c
echo 10 | ./mult_table
```

---

## Worked Example 4: Running Average from Input

Read numbers until a sentinel (or EOF); maintain count and sum for a live average.

```c
/* running_avg.c */
#include <stdio.h>

int main(void) {
    double x;
    double sum = 0.0;
    int count = 0;

    printf("Enter numbers (non-numeric or Ctrl-D to finish):\n");

    while (scanf("%lf", &x) == 1) {
        count++;
        sum += x;
        printf("  n=%d  last=%.4f  sum=%.4f  avg=%.4f\n",
               count, x, sum, sum / count);
    }

    if (count == 0) {
        printf("No data.\n");
        return 1;
    }

    printf("Final average of %d values: %.4f\n", count, sum / count);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o running_avg running_avg.c
printf '10 20 30 40\n' | ./running_avg
```

**Sentinel variant** (stop on a magic value without relying on EOF):

```c
/* running_avg_sentinel.c */
#include <stdio.h>

int main(void) {
    double x, sum = 0.0;
    int count = 0;

    printf("Enter numbers; enter -999 to stop:\n");
    while (scanf("%lf", &x) == 1) {
        if (x == -999.0) {
            break;
        }
        count++;
        sum += x;
        printf("  running avg = %.4f\n", sum / count);
    }
    if (count > 0) {
        printf("Final avg = %.4f\n", sum / count);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o running_avg_sentinel running_avg_sentinel.c
printf '2 4 6 -999\n' | ./running_avg_sentinel
```

---

## Performance Notes

```c
#include <stdio.h>

int main(void) {
    int array[1000];
    const int n = (int)(sizeof array / sizeof array[0]);

    /* Hoist invariant size (here already a constant) */
    for (int i = 0; i < n; i++) {
        array[i] = i;
    }

    long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += array[i];
    }
    printf("sum=%ld\n", sum);
    return 0;
}
```

Avoid `float`/`double` as the primary loop counter (precision can skip or overshoot the end test). Use integer counters and derive floats inside the body.

---

## Best Practices

1. **Initialize** control variables clearly; prefer `for (int i = 0; ...)` (C99+).  
2. **Name** indices meaningfully in complex loops (`row`, `col`, `student_i`).  
3. Prefer **`break` / flags** over mutating the loop index mid-body.  
4. Match **loop kind** to the problem (see decision guide).  
5. Always ensure a **progress condition** (or intentional infinite loop with external exit).

## Common Pitfalls

### Infinite loop by forgetting the update

```c
int i = 0;
while (i < 10) {
    printf("%d\n", i);
    /* missing i++ */
}
```

### Off-by-one

```c
int a[5];
for (int i = 0; i <= 5; i++) {  /* BAD: i==5 is out of bounds */
    a[i] = 0;
}
/* Correct: i < 5 or i < n */
```

### Floating loop variable

```c
/* Fragile */
for (float x = 0.0f; x != 1.0f; x += 0.1f) { }

/* Robust */
for (int i = 0; i < 10; i++) {
    float x = (float)i * 0.1f;
}
```

---

## More Practical Examples

### Number Patterns

```c
#include <stdio.h>

int main(void) {
    int rows = 5;

    printf("Right triangle:\n");
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }

    printf("\nPyramid:\n");
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= rows - i; j++) {
            printf(" ");
        }
        for (int k = 1; k <= 2 * i - 1; k++) {
            printf("*");
        }
        printf("\n");
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o patterns patterns.c
./patterns
```

### Array Stats and Reverse

```c
#include <stdio.h>

int main(void) {
    int numbers[] = {12, 7, 23, 8, 15, 3, 19, 11, 5, 17};
    int size = (int)(sizeof numbers / sizeof numbers[0]);

    int max = numbers[0];
    for (int i = 1; i < size; i++) {
        if (numbers[i] > max) {
            max = numbers[i];
        }
    }
    printf("Max: %d\n", max);

    long sum = 0;
    for (int i = 0; i < size; i++) {
        sum += numbers[i];
    }
    printf("Average: %.2f\n", (double)sum / size);

    for (int i = 0, j = size - 1; i < j; i++, j--) {
        int tmp = numbers[i];
        numbers[i] = numbers[j];
        numbers[j] = tmp;
    }

    printf("Reversed: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o array_stats array_stats.c
./array_stats
```

---

## Exercises

### Exercise 1 — Collatz steps

Read a positive integer `n`. While `n != 1`, if even set `n = n/2`, else `n = 3n+1`. Count steps. Print the sequence.

**Sketch:** `while (n != 1) { print; if (n%2==0) n/=2; else n=3*n+1; steps++; }` Guard overflow with `long`.

```bash
gcc -std=c17 -Wall -Wextra -o collatz collatz.c
```

### Exercise 2 — Nested loop: prime pairs

Find all pairs `(p, q)` with `2 ≤ p ≤ q ≤ 50` where both are prime and `p + q == 50` (Goldbach-style for 50).

**Sketch:** outer `p`, inner not needed if `q = 50-p` and `q >= p`; reuse `is_prime`.

### Exercise 3 — Choose the right loop

Implement three programs that read a password until correct:

1. `while` — re-prompt only if first read failed validation  
2. `do-while` — always prompt at least once  
3. `for` — at most 5 attempts  

Document which feels most natural and why.

### Exercise 4 — FizzBuzz customization

Accept `n`, `a`, `b` from the command line or stdin. Print 1..`n` with Fizz for multiples of `a`, Buzz for `b`, FizzBuzz for both.

### Exercise 5 — Server-style loop

Write a `for (;;)` loop that reads lines; commands `inc`, `dec`, `show`, `quit`. Maintain a counter. Reject unknown commands without exiting. Exit only on `quit` or EOF.

### Exercise 6 — Running variance (optional stretch)

Extend running average to track sum of squares and print population variance each step:  
`var = (sumsq / n) - mean²` (careful with floating error; fine for a learning demo).

---

## Summary

1. **while** — pre-test; zero or more iterations  
2. **do-while** — post-test; at least once (menus)  
3. **for** — counted ranges and clear index updates  
4. **Decision guide** — pick the loop that matches the story  
5. **break / continue** — innermost loop only  
6. **Nested loops** — tables, patterns, pairs  
7. **Infinite loops** — servers/superloops with explicit exit conditions  
8. **Worked examples** — primes, FizzBuzz, mult table, running average  
9. **Pitfalls** — forgotten updates, off-by-one, float counters  

Next: advanced flow control (`goto` rarity, multi-level exit patterns, structured alternatives).
