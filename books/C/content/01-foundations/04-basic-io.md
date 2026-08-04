# Basic Input and Output

## Introduction

Almost every useful program talks to the outside world. In C, console I/O goes through the **standard streams**:

| Stream | Pointer | Typical use |
|--------|---------|-------------|
| Standard input | `stdin` | Keyboard (or redirected file) |
| Standard output | `stdout` | Normal program output |
| Standard error | `stderr` | Diagnostics and errors |

The declarations live in `<stdio.h>`. This chapter covers formatted I/O (`printf` / `scanf`), character I/O, safer line input with `fgets`, buffer pitfalls, and two mini-projects: a menu-driven CLI and a simple invoice printer.

Compile examples with:

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o prog prog.c
```

---

## The `<stdio.h>` library

```c
#include <stdio.h>
```

You get:

- Formatted I/O: `printf`, `fprintf`, `sprintf`, `snprintf`, `scanf`, `fscanf`, `sscanf`
- Character I/O: `getchar`, `putchar`, `fgetc`, `fputc`
- Line I/O: `fgets`, `fputs`
- File operations (later module): `fopen`, `fclose`, …

---

## Output with `printf`

### Prototype (conceptual)

```c
int printf(const char *format, ...);
```

Returns the number of characters written, or a negative value on error.

### Minimal example

```c
#include <stdio.h>

int main(void) {
    printf("Hello, World!\n");
    return 0;
}
```

### Format specifier table

| Specifier | Typical argument | Meaning |
|-----------|------------------|---------|
| `%d` / `%i` | `int` | Signed decimal |
| `%u` | `unsigned int` | Unsigned decimal |
| `%ld` / `%lu` | `long` / `unsigned long` | Long variants |
| `%lld` / `%llu` | `long long` / `unsigned long long` | Long long variants |
| `%f` | `double` (for `printf`) | Fixed-point floating |
| `%e` / `%E` | `double` | Scientific notation |
| `%g` / `%G` | `double` | Compact float format |
| `%c` | `int` (promoted `char`) | Character |
| `%s` | `char *` | String (must be null-terminated) |
| `%x` / `%X` | `unsigned` | Hexadecimal |
| `%o` | `unsigned` | Octal |
| `%p` | `void *` | Pointer address |
| `%zu` | `size_t` | Size type (C99+) |
| `%%` | — | Literal `%` |

**Important:** for `printf`, `float` is promoted to `double`, so `%f` is used for both. For `scanf`, `%f` is `float *` and `%lf` is `double *`.

### Runnable demo — mixed types

```c
#include <stdio.h>

int main(void) {
    int age = 25;
    unsigned int score = 9001u;
    double height = 1.75;
    char initial = 'J';
    char name[] = "Jordan";
    void *self = &age;

    printf("Name:    %s\n", name);
    printf("Initial: %c\n", initial);
    printf("Age:     %d\n", age);
    printf("Score:   %u\n", score);
    printf("Height:  %.2f m\n", height);
    printf("Hex age: 0x%x\n", (unsigned)age);
    printf("Pointer: %p\n", self);
    printf("Percent: 100%% done\n");

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o print_types print_types.c
./print_types
```

### Width, precision, flags

```c
#include <stdio.h>

int main(void) {
    int n = 42;
    double pi = 3.1415926535;
    char word[] = "HelloWorld";

    printf("|%10d|\n", n);      /* right-align in width 10 */
    printf("|%-10d|\n", n);     /* left-align */
    printf("|%010d|\n", n);     /* zero-pad */
    printf("|%.2f|\n", pi);     /* 2 digits after decimal */
    printf("|%8.2f|\n", pi);    /* width 8, 2 decimals */
    printf("|%.5s|\n", word);   /* at most 5 chars from string */

    return 0;
}
```

| Pattern | Effect |
|---------|--------|
| `%10d` | Minimum width 10, right-aligned |
| `%-10d` | Left-aligned |
| `%010d` | Zero-filled to width 10 |
| `%.2f` | Two digits after decimal point |
| `%.5s` | Print at most 5 characters of a string |
| `%#x` | Hex with `0x` prefix (alternate form) |

### `fprintf` and streams

```c
#include <stdio.h>

int main(void) {
    printf("normal message\n");
    fprintf(stdout, "also normal\n");
    fprintf(stderr, "something went wrong\n");
    return 1;
}
```

Redirect separately:

```bash
./prog >out.txt 2>err.txt
```

### `snprintf` — safe string formatting

Prefer `snprintf` over `sprintf` to avoid buffer overruns:

```c
#include <stdio.h>

int main(void) {
    char buf[32];
    int age = 30;
    int n = snprintf(buf, sizeof buf, "age=%d", age);

    if (n < 0) {
        fprintf(stderr, "encoding error\n");
        return 1;
    }
    if ((size_t)n >= sizeof buf) {
        fprintf(stderr, "output truncated\n");
    }

    printf("%s\n", buf);
    return 0;
}
```

---

## Input with `scanf`

### Prototype (conceptual)

```c
int scanf(const char *format, ...);
```

Returns the number of input **items** assigned, or `EOF` on input failure before any assignment.

### Address operator

`scanf` needs **pointers** to the objects it will write:

```c
int number;
scanf("%d", &number);   /* correct */
/* scanf("%d", number); // wrong: passes value, not address */
```

Arrays (and string buffers) already decay to pointers:

```c
char name[50];
scanf("%49s", name);    /* no & for the array */
```

### Specifier table for `scanf` (common cases)

| Specifier | Argument type | Notes |
|-----------|---------------|-------|
| `%d` | `int *` | Signed int |
| `%u` | `unsigned int *` | Unsigned |
| `%ld` | `long *` | Long |
| `%f` | `float *` | Float |
| `%lf` | `double *` | Double — easy to forget |
| `%c` | `char *` | Does **not** skip whitespace unless you force it |
| `%s` | `char *` | Stops at whitespace; always set a max width |
| `%x` | `unsigned int *` | Hex input |

### Full demo — reading several fields

```c
#include <stdio.h>

int main(void) {
    int age;
    double height;
    char initial;
    char name[50];

    printf("Enter age: ");
    if (scanf("%d", &age) != 1) {
        fprintf(stderr, "bad age\n");
        return 1;
    }

    printf("Enter height (meters): ");
    if (scanf("%lf", &height) != 1) {
        fprintf(stderr, "bad height\n");
        return 1;
    }

    printf("Enter middle initial: ");
    if (scanf(" %c", &initial) != 1) { /* leading space skips whitespace */
        fprintf(stderr, "bad initial\n");
        return 1;
    }

    printf("Enter first name (no spaces): ");
    if (scanf("%49s", name) != 1) {
        fprintf(stderr, "bad name\n");
        return 1;
    }

    printf("\n--- Profile ---\n");
    printf("%s %c. age=%d height=%.2f\n", name, initial, age, height);
    return 0;
}
```

---

## Buffer caveats with `scanf`

### Leftover newlines

`scanf("%d", &n)` reads the number but leaves the terminating newline in the input buffer. A following `%c` can read that newline instead of the character you meant.

```c
#include <stdio.h>

int main(void) {
    int n;
    char ch;

    printf("Enter an integer: ");
    if (scanf("%d", &n) != 1) {
        return 1;
    }

    printf("Enter a character: ");
    /* Without the leading space, ch often becomes '\n' */
    if (scanf(" %c", &ch) != 1) {
        return 1;
    }

    printf("n=%d ch='%c' (code %d)\n", n, ch, ch);
    return 0;
}
```

**Rule of thumb:** use a leading space in the format for `%c` when you want to skip leftover whitespace: `scanf(" %c", &ch)`.

### `%s` stops at whitespace

`scanf("%s", buf)` cannot read `"Ada Lovelace"` as one field—it stops at the space. Use `fgets` for full lines (below).

### Always bound string width

```c
char name[20];
scanf("%19s", name);   /* leave room for '\0' */
```

Unbounded `%s` is a classic buffer overflow.

### Failed conversions leave bad data

If the user types `abc` for `%d`, `scanf` returns `0` and does not update the `int` reliably for your purposes—check the return value before using the variable.

### Clearing the rest of a line

After a failed or partial read, discard through newline:

```c
#include <stdio.h>

static void clear_line(void) {
    int c;
    while ((c = getchar()) != '\n' && c != EOF) {
        /* discard */
    }
}

int main(void) {
    int n;

    printf("Enter integer: ");
    while (scanf("%d", &n) != 1) {
        fprintf(stderr, "Not an integer. Try again: ");
        clear_line();
    }
    clear_line(); /* eat trailing newline after a good read if needed later */

    printf("Got %d\n", n);
    return 0;
}
```

---

## Character I/O: `getchar` and `putchar`

```c
int getchar(void);   /* returns unsigned char cast to int, or EOF */
int putchar(int c);
```

### Echo a character

```c
#include <stdio.h>

int main(void) {
    int ch;

    printf("Press a key then Enter: ");
    ch = getchar();
    if (ch == EOF) {
        return 1;
    }

    printf("You typed: ");
    putchar(ch);
    putchar('\n');
    return 0;
}
```

### Copy stdin to stdout until EOF

```c
#include <stdio.h>

int main(void) {
    int ch;

    while ((ch = getchar()) != EOF) {
        putchar(ch);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o catish catish.c
./catish < some_file.txt
# interactive: type text, end with Ctrl+D (Unix) or Ctrl+Z then Enter (Windows consoles)
```

### Count characters and lines

```c
#include <stdio.h>

int main(void) {
    int ch;
    unsigned long chars = 0;
    unsigned long lines = 0;

    while ((ch = getchar()) != EOF) {
        chars++;
        if (ch == '\n') {
            lines++;
        }
    }

    printf("chars=%lu lines=%lu\n", chars, lines);
    return 0;
}
```

Use `int` for the variable that holds `getchar()` so `EOF` (−1) is distinguishable from a byte value `0xFF`.

---

## Reading lines safely with `fgets`

### Prototype

```c
char *fgets(char *s, int size, FILE *stream);
```

Reads at most `size - 1` characters into `s`, stops early on newline, always null-terminates on success. Returns `s` on success, `NULL` on EOF/error.

### Basic pattern

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char line[128];

    printf("Enter a line: ");
    if (fgets(line, sizeof line, stdin) == NULL) {
        fprintf(stderr, "no input\n");
        return 1;
    }

    /* strip trailing newline if present */
    line[strcspn(line, "\n")] = '\0';

    printf("You said: \"%s\"\n", line);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o line_echo line_echo.c
./line_echo
```

### Why prefer `fgets` for text lines?

| Approach | Risk |
|----------|------|
| `gets` | **Removed from C11** — never use; unbounded |
| `scanf("%s")` | Stops at space; easy to overflow without width |
| `scanf("%[^\\n]")` | Awkward; still easy to get wrong |
| `fgets` | Bounded; keeps spaces; predictable |

### Mixing `fgets` and `scanf`

Leftover newlines still bite. Patterns that work:

**Option A — prefer `fgets` for everything**, then parse with `sscanf`:

```c
#include <stdio.h>

int main(void) {
    char line[64];
    int age;

    printf("Age: ");
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 1;
    }
    if (sscanf(line, "%d", &age) != 1) {
        fprintf(stderr, "invalid age\n");
        return 1;
    }

    printf("age=%d\n", age);
    return 0;
}
```

**Option B — after `scanf`, drain the line** before the next `fgets`:

```c
#include <stdio.h>
#include <string.h>

static void clear_line(void) {
    int c;
    while ((c = getchar()) != '\n' && c != EOF) { }
}

int main(void) {
    int id;
    char name[64];

    printf("id: ");
    if (scanf("%d", &id) != 1) {
        return 1;
    }
    clear_line();

    printf("full name: ");
    if (fgets(name, sizeof name, stdin) == NULL) {
        return 1;
    }
    name[strcspn(name, "\n")] = '\0';

    printf("id=%d name=\"%s\"\n", id, name);
    return 0;
}
```

### Detecting truncated lines

If `fgets` fills the buffer without seeing `\n`, the line was longer than the buffer:

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char line[16];

    printf("Short buffer demo (type a long line):\n");
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 1;
    }

    if (strchr(line, '\n') == NULL) {
        fprintf(stderr, "warning: line truncated\n");
        /* optional: drain the rest of the line */
        int c;
        while ((c = getchar()) != '\n' && c != EOF) { }
    } else {
        line[strcspn(line, "\n")] = '\0';
    }

    printf("stored: \"%s\"\n", line);
    return 0;
}
```

---

## `sscanf` — parse from a string

```c
#include <stdio.h>

int main(void) {
    const char *input = "Jordan 25 1.75";
    char name[32];
    int age;
    double height;

    if (sscanf(input, "%31s %d %lf", name, &age, &height) != 3) {
        fprintf(stderr, "parse failed\n");
        return 1;
    }

    printf("%s is %d years old and %.2f m\n", name, age, height);
    return 0;
}
```

Useful when you already have a full line from `fgets` and want conversion with error checking.

---

## Checking return values

### `printf`

```c
int n = printf("Hello\n");
if (n < 0) {
    /* rare on console; more relevant with broken streams */
}
```

### `scanf`

```c
int a, b;
int got = scanf("%d %d", &a, &b);
if (got != 2) {
    fprintf(stderr, "expected two integers, got %d\n", got);
    return 1;
}
```

Treat return-value checks as part of correct I/O, not optional polish.

---

## Mini-project 1 — Menu-driven CLI

A small loop that presents options until the user quits. Uses `fgets` + `sscanf` to avoid buffer traps.

```c
#include <stdio.h>
#include <string.h>

static int read_int(const char *prompt, int *out) {
    char line[64];

    printf("%s", prompt);
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 0;
    }
    return sscanf(line, "%d", out) == 1;
}

int main(void) {
    char line[64];
    int choice;
    int running = 1;

    while (running) {
        printf("\n==== Mini CLI ====\n");
        printf("1) Echo a line\n");
        printf("2) Add two integers\n");
        printf("3) Show ASCII code of a character\n");
        printf("0) Quit\n");
        printf("Select: ");

        if (fgets(line, sizeof line, stdin) == NULL) {
            break;
        }
        if (sscanf(line, "%d", &choice) != 1) {
            printf("Please enter a number from the menu.\n");
            continue;
        }

        switch (choice) {
        case 0:
            running = 0;
            printf("Bye.\n");
            break;
        case 1: {
            char text[128];
            printf("Text: ");
            if (fgets(text, sizeof text, stdin) == NULL) {
                running = 0;
                break;
            }
            text[strcspn(text, "\n")] = '\0';
            printf("Echo: %s\n", text);
            break;
        }
        case 2: {
            int a, b;
            if (!read_int("a = ", &a) || !read_int("b = ", &b)) {
                printf("Invalid integer input.\n");
                break;
            }
            printf("%d + %d = %d\n", a, b, a + b);
            break;
        }
        case 3: {
            char raw[16];
            printf("Character: ");
            if (fgets(raw, sizeof raw, stdin) == NULL) {
                running = 0;
                break;
            }
            if (raw[0] == '\0' || raw[0] == '\n') {
                printf("No character entered.\n");
                break;
            }
            printf("'%c' has code %d\n", raw[0], (unsigned char)raw[0]);
            break;
        }
        default:
            printf("Unknown option.\n");
            break;
        }
    }

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o menu_cli menu_cli.c
./menu_cli
```

---

## Mini-project 2 — Simple invoice printer

Reads a few line items and prints a formatted invoice on `stdout`.

```c
#include <stdio.h>
#include <string.h>

#define MAX_ITEMS 5
#define NAME_LEN  48

int main(void) {
    char customer[64];
    char names[MAX_ITEMS][NAME_LEN];
    int quantities[MAX_ITEMS];
    double prices[MAX_ITEMS];
    int count = 0;
    double subtotal = 0.0;
    const double tax_rate = 0.08;
    char line[128];

    printf("Customer name: ");
    if (fgets(customer, sizeof customer, stdin) == NULL) {
        return 1;
    }
    customer[strcspn(customer, "\n")] = '\0';

    printf("How many line items (1-%d)? ", MAX_ITEMS);
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 1;
    }
    if (sscanf(line, "%d", &count) != 1 || count < 1 || count > MAX_ITEMS) {
        fprintf(stderr, "Invalid item count\n");
        return 1;
    }

    for (int i = 0; i < count; i++) {
        printf("\nItem %d name: ", i + 1);
        if (fgets(names[i], NAME_LEN, stdin) == NULL) {
            return 1;
        }
        names[i][strcspn(names[i], "\n")] = '\0';

        printf("Quantity: ");
        if (fgets(line, sizeof line, stdin) == NULL) {
            return 1;
        }
        if (sscanf(line, "%d", &quantities[i]) != 1 || quantities[i] < 0) {
            fprintf(stderr, "Invalid quantity\n");
            return 1;
        }

        printf("Unit price: ");
        if (fgets(line, sizeof line, stdin) == NULL) {
            return 1;
        }
        if (sscanf(line, "%lf", &prices[i]) != 1 || prices[i] < 0.0) {
            fprintf(stderr, "Invalid price\n");
            return 1;
        }
    }

    printf("\n========================================\n");
    printf("              INVOICE\n");
    printf("========================================\n");
    printf("Customer: %s\n\n", customer);
    printf("%-20s %5s %10s %10s\n", "Item", "Qty", "Unit", "Line");
    printf("----------------------------------------\n");

    for (int i = 0; i < count; i++) {
        double line_total = quantities[i] * prices[i];
        subtotal += line_total;
        printf("%-20.20s %5d %10.2f %10.2f\n",
               names[i], quantities[i], prices[i], line_total);
    }

    double tax = subtotal * tax_rate;
    double total = subtotal + tax;

    printf("----------------------------------------\n");
    printf("%-28s %10.2f\n", "Subtotal", subtotal);
    printf("%-28s %10.2f\n", "Tax (8%)", tax);
    printf("%-28s %10.2f\n", "TOTAL", total);
    printf("========================================\n");

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -Wpedantic -o invoice invoice.c
./invoice
```

This uses a C99-style `for (int i = 0; ...)` loop (fine under `-std=c17`). Arrays show up formally in a later module; here they are only storage for the demo.

---

## Practical calculator (formatted I/O review)

```c
#include <stdio.h>

int main(void) {
    double num1, num2, result;
    char op;
    char line[128];

    printf("Enter expression (e.g. 3.5 * 2): ");
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 1;
    }
    if (sscanf(line, "%lf %c %lf", &num1, &op, &num2) != 3) {
        fprintf(stderr, "Could not parse expression\n");
        return 1;
    }

    switch (op) {
    case '+': result = num1 + num2; break;
    case '-': result = num1 - num2; break;
    case '*': result = num1 * num2; break;
    case '/':
        if (num2 == 0.0) {
            fprintf(stderr, "Division by zero\n");
            return 1;
        }
        result = num1 / num2;
        break;
    default:
        fprintf(stderr, "Invalid operator '%c'\n", op);
        return 1;
    }

    printf("%.10g %c %.10g = %.10g\n", num1, op, num2, result);
    return 0;
}
```

---

## Best practices (quick reference)

1. **Check return values** of `scanf`, `fgets`, and parsing helpers.
2. **Bound every string read** (`%49s`, `fgets(..., sizeof buf, ...)`).
3. **Prefer `fgets` + `sscanf`** for interactive line-oriented tools.
4. **Never use `gets`.**
5. **Send errors to `stderr`** with `fprintf(stderr, ...)`.
6. **Mind whitespace** when mixing `%d` and `%c`, or `scanf` and `fgets`.
7. **Use `snprintf`**, not unbounded `sprintf`, when building strings.
8. **Compile with** `-std=c17 -Wall -Wextra -Wpedantic`.

---

## Summary

- `printf` formats output; width and precision control alignment and detail.
- `scanf` reads tokens; always pass addresses (except arrays), check the return count, and bound `%s`.
- Character I/O with `getchar` / `putchar` is simple and stream-friendly; store results in `int`.
- `fgets` is the default safe way to read a line; strip `\n` with `strcspn` or equivalent.
- Menu CLIs and small printers are good practice for real interactive programs.

Next module: data types and variables—so the values you print and scan have precise sizes, ranges, and conversion rules.

---

## Exercises

Use `-std=c17 -Wall -Wextra -Wpedantic` for all of these.

1. **Specifier drill** — Print the same integer as decimal, octal, and hex on one line.
2. **Column report** — Print three rows of “name / quantity / price” using width specifiers so columns align.
3. **Scanf trap lab** — Demonstrate the leftover-newline bug with `%d` followed by `%c` *without* a leading space, then show the fixed version.
4. **Line reverser (partial)** — Read a line with `fgets` and print its length (excluding newline). Full reverse can wait until arrays/strings if needed; do it now if you already can.
5. **Retry loop** — Keep asking for an integer until `sscanf` after `fgets` succeeds.
6. **Menu extension** — Add a fourth menu option that converts Celsius to Fahrenheit.
7. **Invoice tax flag** — Modify the invoice program to ask whether tax applies (`y`/`n`) before printing totals.
8. **stderr routing** — Write a program that prints `OK` to stdout and `BAD` to stderr; run with redirects and show both files.
9. **`snprintf` card** — Build a string `"ID=###;NAME=..."` into a 64-byte buffer and report truncation if it occurs.
10. **Char histogram (lite)** — Read characters until EOF and count how many were digits (`'0'`–`'9'`). Print the count.
