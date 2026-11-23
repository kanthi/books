# Basic Input and Output

## Introduction

Almost every useful program talks to the outside world. In C, console I/O goes through the **standard streams**:

| Stream | Pointer | Typical use |
|--------|---------|-------------|
| Standard input | `stdin` | Keyboard (or redirected file) |
| Standard output | `stdout` | Normal program output |
| Standard error | `stderr` | Diagnostics and errors |

The declarations live in `<stdio.h>`. This chapter covers formatted I/O (`printf` / `scanf`), character I/O, safer line input with `fgets`, buffer pitfalls, and a checked integer-input mini-project.

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

Checking that count is necessary but not sufficient for arbitrary numeric input: if the converted value cannot be represented in the destination, C does not define the behavior. The demonstrations below assume values in range; use the checked line parser later for untrusted input.

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

This introductory demonstration assumes controlled, in-range numeric input. Assignment counts detect matching failures, but do not make numeric conversions safe for arbitrary input; see the checked mini-project below.

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

After a matching failure or partial read, discard through newline. This example assumes numeric input is in `int` range; use the checked parser below for arbitrary input:

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
    int result;
    while ((result = scanf("%d", &n)) != 1) {
        if (result == EOF) {
            fprintf(stderr, "Input ended or failed.\n");
            return 1;
        }
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

Use `int` for the variable that holds `getchar()` so its result can be compared with `EOF`. `EOF` is a negative macro; do not assume its numeric value. On ordinary systems, `int` can represent every `unsigned char` value as well as `EOF`.

---

## Reading lines safely with `fgets`

### Prototype

```c
char *fgets(char *s, int size, FILE *stream);
```

Reads at most `size - 1` characters into `s`, stops early on newline, always null-terminates on success. Returns `s` on success, `NULL` on EOF/error.

### Basic pattern

This short echo demonstrates bounded storage; it prints only the first chunk if the line is longer than the buffer. It assumes text without embedded NUL bytes.

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

**Option A — read whole lines**, then parse and validate each line. The checked mini-project below demonstrates this with `strtol`, including range checks and rejection of trailing text.

**Option B — after `scanf`, drain the line** before the next `fgets`. The numeric input here is assumed to be in range:

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

### Detecting incomplete lines

A successful `fgets` without a newline does **not** by itself prove truncation: the input might end without a newline, or the buffer may hold exactly the characters before a newline that remains unread. A program that needs a complete line must distinguish these cases and handle the remainder. Embedded NUL bytes also make string functions unable to inspect the entire input read by `fgets`. The mini-project below uses a character-at-a-time reader with an explicit maximum, drains overlong lines, and accepts a final unterminated line.

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

This fixed literal is controlled and in range. For arbitrary numeric input, a successful assignment count does not guarantee safe range handling or that the whole line was consumed. The checked parser below uses `strtol` and validates both.

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

## Mini-project — read and add two integers

This complete program accepts a decimal integer on each line, rejects extra text and out-of-range values, and checks the sum before adding. Save it as `checked_add.c`. The line reader accepts at most 63 bytes before a newline; longer lines and embedded NUL bytes are rejected and drained so the next prompt starts on a fresh line. A final line without a newline is accepted. EOF before a new line ends the program instead of retrying forever.

```c
#include <ctype.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>

/* 1 = line, 0 = EOF before a line, -1 = invalid/overlong, -2 = I/O error */
static int read_line(char *buf, size_t capacity) {
    size_t used = 0;
    int c;
    int bad = 0;
    int saw_input = 0;

    while ((c = getchar()) != EOF && c != '\n') {
        saw_input = 1;
        if (c == '\0' || used + 1 >= capacity) {
            bad = 1;
        } else if (!bad) {
            buf[used++] = (char)c;
        }
    }
    if (c == EOF && ferror(stdin)) return -2;
    if (c == EOF && !saw_input) return 0;
    buf[used] = '\0';
    return bad ? -1 : 1;
}

static int parse_int(const char *text, int *out) {
    char *end;
    long value;

    errno = 0;
    value = strtol(text, &end, 10);
    if (end == text || errno == ERANGE || value < INT_MIN || value > INT_MAX)
        return 0;
    while (isspace((unsigned char)*end)) end++;
    if (*end != '\0') return 0;
    *out = (int)value;
    return 1;
}

/* 1 = success, 0 = end of input, -1 = stream error */
static int ask_int(const char *prompt, int *out) {
    char line[64];
    for (;;) {
        fputs(prompt, stdout);
        fflush(stdout); /* show prompt even if stdout is buffered */
        int result = read_line(line, sizeof line);
        if (result == 0) return 0;
        if (result == -2) return -1;
        if (result == 1 && parse_int(line, out)) return 1;
        fprintf(stderr, "Enter one in-range decimal integer.\n");
    }
}

int main(void) {
    int a, b;
    int result = ask_int("First integer: ", &a);
    if (result != 1) return result < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
    result = ask_int("Second integer: ", &b);
    if (result != 1) return result < 0 ? EXIT_FAILURE : EXIT_SUCCESS;

    if ((b > 0 && a > INT_MAX - b) ||
        (b < 0 && a < INT_MIN - b)) {
        fprintf(stderr, "The sum is outside the range of int.\n");
        return EXIT_FAILURE;
    }
    printf("%d + %d = %d\n", a, b, a + b);
    return EXIT_SUCCESS;
}
```

```sh
gcc -std=c17 -Wall -Wextra -Wpedantic -o checked_add checked_add.c
printf '12\n-5\n' | ./checked_add
printf '12x\n12\n-5\n' | ./checked_add
./checked_add < /dev/null
```

The first run prints `12 + -5 = 7` after the prompts. In the second, `12x` is rejected and the next line is read as the first integer. The third exits at EOF. To test the addition boundary on your implementation, use the values printed by a program using `INT_MAX` and `INT_MIN` from `<limits.h>`, then add 1 to the maximum; do not assume that `int` has a particular width.

`strtol` skips leading whitespace and reports where conversion stopped through `end`. Resetting `errno` matters because a successful call need not clear an old error. Check for no digits, `ERANGE`, the narrower `int` range, and any non-whitespace suffix **before** casting. The `isspace` cast is required because its argument must be `EOF` or representable as `unsigned char`. The addition guard evaluates only representable expressions: it avoids computing `a + b` until the result is known to fit.

The example handles ordinary text input and embedded NULs explicitly. It does not implement locale-independent Unicode parsing or a general-purpose line library. Output errors are not handled in this compact exercise; applications that must guarantee output delivery should check writes and final flush/close as well.

For details, see the [C11 committee draft, sections 7.21.6.2 and 7.22.1.4](https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1570.pdf) and the [POSIX `strtol` specification](https://pubs.opengroup.org/onlinepubs/9799919799/functions/strtol.html).

---

## Best practices (quick reference)

1. **Check return values** of `scanf`, `fgets`, and parsing helpers.
2. **Bound every string read** (`%49s`, `fgets(..., sizeof buf, ...)`).
3. **Read complete lines and use `strtol`/`strtod` with range and end-pointer checks** for arbitrary numeric input.
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
- `fgets` bounds writes; check whether you received a complete line before treating it as one record.
- Validate the entire input, its numeric range, and the result of arithmetic in interactive programs.

Next module: data types and variables—so the values you print and scan have precise sizes, ranges, and conversion rules.

---

## Exercises

Use `-std=c17 -Wall -Wextra -Wpedantic` for all of these.

1. **Specifier drill** — Print the same integer as decimal, octal, and hex on one line.
2. **Column report** — Print three rows of “name / quantity / price” using width specifiers so columns align.
3. **Scanf trap lab** — Demonstrate the leftover-newline bug with `%d` followed by `%c` *without* a leading space, then show the fixed version.
4. **Line reverser (partial)** — Read a line with `fgets` and print its length (excluding newline). Full reverse can wait until arrays/strings if needed; do it now if you already can.
5. **Retry loop** — Adapt the checked mini-project to accept only integers from 1 to 10, and exit on EOF.
6. **Range test** — Test the checked addition program at `INT_MIN` and `INT_MAX` and with an overflowing sum.
7. **Line limit** — Supply 63 and 64 characters followed by a newline to the mini-project; explain the different outcomes.
8. **stderr routing** — Write a program that prints `OK` to stdout and `BAD` to stderr; run with redirects and show both files.
9. **`snprintf` card** — Build a string `"ID=###;NAME=..."` into a 64-byte buffer and report truncation if it occurs.
10. **Char histogram (lite)** — Read characters until EOF and count how many were digits (`'0'`–`'9'`). Print the count.
