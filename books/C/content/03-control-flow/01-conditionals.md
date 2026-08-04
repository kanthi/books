# Conditional Statements

## Introduction

Conditional statements are fundamental control structures that allow programs to make decisions and execute different code paths based on specific conditions. They enable programs to respond dynamically to varying inputs, user interactions, and runtime conditions.

In C, conditional statements provide the foundation for implementing logic, validation, error handling, and complex decision-making processes. This chapter explores `if` / `else`, `switch`, nested conditions, the ternary operator, common pitfalls, and several full worked programs you can compile on Linux.

**Compile flag convention used throughout this book:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
./program
```

## The if Statement

The `if` statement is the most basic conditional construct in C. It executes a block of code only if a specified condition evaluates to true (non-zero).

### Basic Syntax

```c
if (condition) {
    // Code to execute if condition is true
}
```

### Simple if Statement

```c
#include <stdio.h>

int main(void) {
    int age = 20;

    if (age >= 18) {
        printf("You are eligible to vote.\n");
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o if_simple if_simple.c
./if_simple
```

### if-else Statement

The `if-else` construct allows you to specify alternative code paths for when the condition is true or false:

```c
#include <stdio.h>

int main(void) {
    int number = 15;

    if (number % 2 == 0) {
        printf("%d is even.\n", number);
    } else {
        printf("%d is odd.\n", number);
    }

    return 0;
}
```

### if-else if-else Chain

For multiple conditions, chain `if-else if-else` statements. Order matters: the first true branch wins.

```c
#include <stdio.h>

int main(void) {
    int score = 85;

    if (score >= 90) {
        printf("Grade: A\n");
    } else if (score >= 80) {
        printf("Grade: B\n");
    } else if (score >= 70) {
        printf("Grade: C\n");
    } else if (score >= 60) {
        printf("Grade: D\n");
    } else {
        printf("Grade: F\n");
    }

    return 0;
}
```

## The switch Statement

The `switch` statement provides an alternative to long `if-else if` chains when comparing a single expression against multiple **constant integer** values (including character constants).

### Basic Syntax

```c
switch (expression) {
    case constant1:
        // Code for constant1
        break;
    case constant2:
        // Code for constant2
        break;
    default:
        // Code for no match
        break;
}
```

### Simple switch Example

```c
#include <stdio.h>

int main(void) {
    int day = 3;

    switch (day) {
        case 1:  printf("Monday\n");    break;
        case 2:  printf("Tuesday\n");   break;
        case 3:  printf("Wednesday\n"); break;
        case 4:  printf("Thursday\n");  break;
        case 5:  printf("Friday\n");    break;
        case 6:  printf("Saturday\n");  break;
        case 7:  printf("Sunday\n");    break;
        default: printf("Invalid day\n"); break;
    }

    return 0;
}
```

### Intentional Fall-Through

Without `break`, control falls into the next case. Use this only deliberately, and document it:

```c
#include <stdio.h>

int main(void) {
    int month = 2;

    switch (month) {
        case 12:
        case 1:
        case 2:
            printf("Winter\n");
            break;
        case 3:
        case 4:
        case 5:
            printf("Spring\n");
            break;
        case 6:
        case 7:
        case 8:
            printf("Summer\n");
            break;
        case 9:
        case 10:
        case 11:
            printf("Autumn\n");
            break;
        default:
            printf("Invalid month\n");
            break;
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o seasons seasons.c
./seasons
```

## Nested Conditionals

Conditionals can be nested to handle multi-factor decisions:

```c
#include <stdio.h>
#include <stdbool.h>

int main(void) {
    int age = 25;
    bool has_license = true;

    if (age >= 18) {
        if (has_license) {
            printf("You can drive legally.\n");
        } else {
            printf("You need to get a license.\n");
        }
    } else {
        printf("You are not old enough to drive.\n");
    }

    return 0;
}
```

### Nested Condition Pitfalls

Deep nesting is hard to read and easy to get wrong. Prefer early returns or combined boolean expressions when the logic allows.

```c
#include <stdio.h>
#include <stdbool.h>

/* Nested — correct but noisy */
static void check_access_nested(int age, bool licensed, bool insured) {
    if (age >= 18) {
        if (licensed) {
            if (insured) {
                printf("Drive allowed.\n");
            } else {
                printf("Need insurance.\n");
            }
        } else {
            printf("Need license.\n");
        }
    } else {
        printf("Too young.\n");
    }
}

/* Flattened with early exits — usually clearer */
static void check_access_flat(int age, bool licensed, bool insured) {
    if (age < 18) {
        printf("Too young.\n");
        return;
    }
    if (!licensed) {
        printf("Need license.\n");
        return;
    }
    if (!insured) {
        printf("Need insurance.\n");
        return;
    }
    printf("Drive allowed.\n");
}

int main(void) {
    check_access_nested(20, true, false);
    check_access_flat(20, true, false);
    return 0;
}
```

## The Dangling else (Else-Bind Ambiguity)

In C, an `else` always binds to the **nearest unmatched** `if`. Without braces this can surprise you.

```c
#include <stdio.h>

int main(void) {
    int x = 0;
    int y = 1;

    /* DANGEROUS style (shown only to illustrate binding):
     *
     * if (x)
     *     if (y)
     *         printf("both\n");
     * else
     *     printf("x was false?\n");   // actually binds to if (y)!
     *
     * Always use braces:
     */

    if (x) {
        if (y) {
            printf("both\n");
        }
    } else {
        printf("x was false (this else belongs to if (x))\n");
    }

    /* Explicit binding for the inner else */
    if (x) {
        if (y) {
            printf("both\n");
        } else {
            printf("x true, y false\n");
        }
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o dangling_else dangling_else.c
./dangling_else
```

**Rule:** always brace `if` / `else` bodies, even one-liners. It eliminates the ambiguity.

## Conditional (Ternary) Expressions

C supports the conditional operator as a shorthand for simple value selection:

```c
#include <stdio.h>

int main(void) {
    int a = 10, b = 20;

    int max_if;
    if (a > b) {
        max_if = a;
    } else {
        max_if = b;
    }

    int max_ternary = (a > b) ? a : b;

    printf("Max (if-else): %d\n", max_if);
    printf("Max (ternary): %d\n", max_ternary);

    int age = 17;
    const char *status = (age >= 18) ? "adult" : "minor";
    printf("Status: %s\n", status);

    return 0;
}
```

### Ternary Best Practices

| Prefer ternary when… | Prefer if/else when… |
|----------------------|----------------------|
| Selecting a **value** for assignment/return | The branches have **side effects** (I/O, mutations) |
| Expression stays on one readable line | Nested ternaries would appear (`a ? b : c ? d : e`) |
| Types of both arms match cleanly | Branches need multiple statements |

```c
#include <stdio.h>

/* Good: pure value selection */
static int clamp(int v, int lo, int hi) {
    return (v < lo) ? lo : (v > hi) ? hi : v;  /* nested: still OK if tiny */
}

/* Better readability for nested selection */
static int clamp_clear(int v, int lo, int hi) {
    if (v < lo) {
        return lo;
    }
    if (v > hi) {
        return hi;
    }
    return v;
}

/* Bad: side effects buried in a ternary */
static void bad_style(int flag) {
    /* avoid: flag ? printf("yes\n") : printf("no\n"); */
    if (flag) {
        printf("yes\n");
    } else {
        printf("no\n");
    }
}

int main(void) {
    printf("clamp(150, 0, 100) = %d\n", clamp(150, 0, 100));
    printf("clamp_clear(-5, 0, 100) = %d\n", clamp_clear(-5, 0, 100));
    bad_style(1);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o ternary_style ternary_style.c
./ternary_style
```

## Best Practices for Conditionals

### 1. Use Braces Consistently

```c
/* Good */
if (condition) {
    do_something();
}

/* Avoid: inconsistent / brace-less style */
if (condition)
    do_something();
else
    do_something_else();
```

### 2. Handle All Cases in switch

Always include `default` for unexpected values (or document why it is impossible). Always `break` unless fall-through is intentional and commented.

### 3. Prefer Early Returns Over Deep Nesting

```c
int process_data(int data) {
    if (data < 0) {
        return -1;
    }
    if (data > 100) {
        return -2;
    }
    return data * 2;
}
```

### 4. Name Complex Conditions

```c
int is_adult = (age >= 18);
int has_permission = (permission_level > 0);

if (is_adult && has_permission) {
    grant_access();
}
```

## Common Pitfalls

### 1. Assignment vs Comparison

```c
#include <stdio.h>

int main(void) {
    int x = 5;

    /* Wrong: assignment; condition is always true here after assign */
    if (x = 10) {
        printf("Assigned and truthy: x = %d\n", x);
    }

    /* Correct comparison */
    if (x == 10) {
        printf("x equals 10\n");
    }

    /* Yoda style some teams use to catch typos: if (10 == x) */
    if (10 == x) {
        printf("Yoda comparison OK\n");
    }

    return 0;
}
```

With `-Wall`, `gcc` warns about assignment used as a condition unless you add extra parentheses: `if ((x = 10))`.

### 2. Floating-Point Comparisons

```c
#include <stdio.h>
#include <math.h>

int main(void) {
    double a = 0.1 + 0.2;
    double b = 0.3;

    if (a == b) {
        printf("Equal\n");
    } else {
        printf("Not bit-equal (a = %.20f, b = %.20f)\n", a, b);
    }

    const double epsilon = 1e-9;
    if (fabs(a - b) < epsilon) {
        printf("Approximately equal\n");
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o fp_cmp fp_cmp.c -lm
./fp_cmp
```

### 3. Missing break in switch

Fall-through without intent is a classic bug. Enable and respect warnings; some projects use `/* fallthrough */` comments for intentional cases (GCC recognizes them).

---

## Worked Example 1: Full Grading System

Letter grade, pass/fail, GPA-style points, and input validation.

```c
/* grade_system.c — interactive grading helper */
#include <stdio.h>

static char letter_grade(float score) {
    if (score >= 90.0f) {
        return 'A';
    }
    if (score >= 80.0f) {
        return 'B';
    }
    if (score >= 70.0f) {
        return 'C';
    }
    if (score >= 60.0f) {
        return 'D';
    }
    return 'F';
}

static float grade_points(char letter) {
    switch (letter) {
        case 'A': return 4.0f;
        case 'B': return 3.0f;
        case 'C': return 2.0f;
        case 'D': return 1.0f;
        default:  return 0.0f;
    }
}

static const char *feedback(char letter) {
    switch (letter) {
        case 'A': return "Excellent";
        case 'B': return "Good";
        case 'C': return "Satisfactory";
        case 'D': return "Needs improvement";
        default:  return "Failing — retake recommended";
    }
}

int main(void) {
    float score;

    printf("Enter student score (0-100): ");
    if (scanf("%f", &score) != 1) {
        printf("Invalid input (not a number).\n");
        return 1;
    }

    if (score < 0.0f || score > 100.0f) {
        printf("Invalid score! Enter a value between 0 and 100.\n");
        return 1;
    }

    char letter = letter_grade(score);
    float gpa = grade_points(letter);

    printf("Score : %.1f\n", score);
    printf("Grade : %c (%s)\n", letter, feedback(letter));
    printf("Points: %.1f / 4.0\n", gpa);

    if (score >= 60.0f) {
        printf("Result: PASS\n");
    } else {
        printf("Result: FAIL\n");
    }

    /* Plus/minus band using nested conditions */
    if (letter != 'F') {
        int band = (int)score % 10;
        if (band >= 7 || score >= 97.0f) {
            printf("Band  : %c+\n", letter);
        } else if (band <= 2 && score < 90.0f) {
            printf("Band  : %c-\n", letter);
        } else {
            printf("Band  : %c\n", letter);
        }
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o grade_system grade_system.c
echo "87.5" | ./grade_system
```

---

## Worked Example 2: Leap Year (Rules + Nested Form)

Gregorian rule: divisible by 4, except centuries unless also divisible by 400.

```c
/* leap_year.c */
#include <stdio.h>
#include <stdbool.h>

static bool is_leap_flat(int year) {
    return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

static bool is_leap_nested(int year) {
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0) {
                return true;
            }
            return false;
        }
        return true;
    }
    return false;
}

int main(void) {
    int year;

    printf("Enter a year: ");
    if (scanf("%d", &year) != 1) {
        printf("Invalid input.\n");
        return 1;
    }

    if (year <= 0) {
        printf("Use a positive year (Gregorian-style check).\n");
        return 1;
    }

    bool flat = is_leap_flat(year);
    bool nest = is_leap_nested(year);

    printf("%d is %sa leap year (flat).\n", year, flat ? "" : "not ");
    printf("%d is %sa leap year (nested).\n", year, nest ? "" : "not ");

    /* Spot-check known cases without user input */
    int samples[] = {1900, 2000, 2024, 2023};
    printf("\nSelf-check:\n");
    for (int i = 0; i < 4; i++) {
        int y = samples[i];
        printf("  %d -> %s\n", y, is_leap_flat(y) ? "leap" : "common");
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o leap_year leap_year.c
echo "2000" | ./leap_year
```

Expected self-check: 1900 common, 2000 leap, 2024 leap, 2023 common.

---

## Worked Example 3: Simple ATM Menu with switch

Balance, deposit, withdraw, and PIN check — menu loop with `switch`.

```c
/* atm_menu.c — console ATM simulation */
#include <stdio.h>
#include <stdbool.h>

#define PIN_CODE 1234
#define MAX_TRIES 3

int main(void) {
    double balance = 1000.00;
    int pin;
    int tries = 0;
    bool authenticated = false;

    printf("=== Mini ATM ===\n");
    while (tries < MAX_TRIES) {
        printf("Enter PIN: ");
        if (scanf("%d", &pin) != 1) {
            printf("Invalid input.\n");
            /* drain line */
            int ch;
            while ((ch = getchar()) != '\n' && ch != EOF) {
            }
            tries++;
            continue;
        }
        if (pin == PIN_CODE) {
            authenticated = true;
            break;
        }
        tries++;
        printf("Wrong PIN (%d/%d).\n", tries, MAX_TRIES);
    }

    if (!authenticated) {
        printf("Card locked. Goodbye.\n");
        return 1;
    }

    int choice = -1;
    do {
        printf("\n--- Menu ---\n");
        printf("1. Check balance\n");
        printf("2. Deposit\n");
        printf("3. Withdraw\n");
        printf("4. Quick $50 withdraw\n");
        printf("0. Exit\n");
        printf("Choice: ");

        if (scanf("%d", &choice) != 1) {
            printf("Please enter a number.\n");
            int ch;
            while ((ch = getchar()) != '\n' && ch != EOF) {
            }
            choice = -1;
            continue;
        }

        switch (choice) {
            case 1:
                printf("Balance: $%.2f\n", balance);
                break;

            case 2: {
                double amount;
                printf("Deposit amount: ");
                if (scanf("%lf", &amount) != 1 || amount <= 0.0) {
                    printf("Invalid amount.\n");
                    break;
                }
                balance += amount;
                printf("Deposited. New balance: $%.2f\n", balance);
                break;
            }

            case 3: {
                double amount;
                printf("Withdraw amount: ");
                if (scanf("%lf", &amount) != 1 || amount <= 0.0) {
                    printf("Invalid amount.\n");
                    break;
                }
                if (amount > balance) {
                    printf("Insufficient funds.\n");
                } else {
                    balance -= amount;
                    printf("Withdrawn. New balance: $%.2f\n", balance);
                }
                break;
            }

            case 4:
                if (balance < 50.0) {
                    printf("Insufficient funds for quick withdraw.\n");
                } else {
                    balance -= 50.0;
                    printf("Dispensed $50.00. Balance: $%.2f\n", balance);
                }
                break;

            case 0:
                printf("Thank you. Session ended.\n");
                break;

            default:
                printf("Unknown option.\n");
                break;
        }
    } while (choice != 0);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o atm_menu atm_menu.c
# Interactive: enter PIN 1234, then try menu options
./atm_menu
```

---

## Short-Circuit Evaluation

`&&` and `||` stop evaluating once the result is known. Use this to guard expensive or unsafe operations:

```c
#include <stdio.h>

int main(void) {
    int a = 5, b = 0;

    /* Safe: a / b never runs when b == 0 */
    if (b != 0 && a / b > 1) {
        printf("Division is safe and result > 1\n");
    } else {
        printf("Skipped unsafe division or result not > 1\n");
    }

    int calls = 0;
    if (a > 10 && (++calls > 0)) {
        printf("Won't print\n");
    }
    printf("Side-effect calls: %d (short-circuit skipped ++)\n", calls);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o short_circuit short_circuit.c
./short_circuit
```

---

## Exercises

### Exercise 1 — Triangle classifier

Read three side lengths. Print whether they form a valid triangle, and if so whether it is equilateral, isosceles, or scalene. Reject non-positive sides.

**Solution sketch:**

```c
/* Valid if a+b>c, a+c>b, b+c>a for all permutations.
 * Then: all equal → equilateral; any two equal → isosceles; else scalene.
 * Use if / else if chain; avoid floating equality issues by using int sides first.
 */
```

```bash
gcc -std=c17 -Wall -Wextra -o triangle triangle.c
```

### Exercise 2 — Rock–paper–scissors

Map chars `r`/`p`/`s` (or integers 0/1/2) for player and computer. Use `switch` for the winner matrix. Print win/lose/draw.

**Solution sketch:**

```c
/* switch (player) {
 *   case 'r': if (cpu=='s') win; else if (cpu=='p') lose; else draw; break;
 *   ...
 * }
 * Or encode both as ints and use (player - cpu + 3) % 3.
 */
```

### Exercise 3 — BMI category

Read weight (kg) and height (m). Compute BMI = kg / m². Categories: underweight <18.5, normal <25, overweight <30, obese ≥30. Guard height ≤ 0.

**Solution sketch:**

```c
/* if (height <= 0) error;
 * double bmi = weight / (height * height);
 * else-if ladder on thresholds; print bmi with %.1f
 */
```

### Exercise 4 — Rewrite dangling-else trap

Given brace-less nested `if`/`else` that misclassifies, rewrite with braces so the `else` binds to the outer `if`. Add a unit-style table of `(x,y)` inputs and expected messages.

### Exercise 5 — ATM extension

Extend `atm_menu.c` with a transfer option (case 5) that subtracts from balance only if funds suffice, and logs a fake destination account id. Add a daily withdraw limit with a nested check.

---

## Summary

In this chapter you covered:

1. **if / if-else / else-if** — ordered multi-way branching  
2. **switch** — integer/character multi-way with break and intentional fall-through  
3. **Nested conditions** — when needed, and how to flatten  
4. **Dangling else** — else binds to nearest unmatched if; always use braces  
5. **Ternary** — value selection; avoid side effects and deep nesting  
6. **Worked programs** — grading system, leap year, ATM menu  
7. **Pitfalls** — `=` vs `==`, float compares, missing `break`, short-circuit  
8. **Exercises** — triangle, RPS, BMI, else-binding, ATM extensions  

Next: loops (`while`, `do-while`, `for`) for repetition and iterative algorithms.
