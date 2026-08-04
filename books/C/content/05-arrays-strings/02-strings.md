# Strings

## Introduction

In C, a string is a contiguous sequence of characters ending with a null terminator `'\0'`. There is no built-in string type: you work with `char` arrays and `char *`, plus the helpers in `<string.h>` and careful buffer management.

This chapter covers representation, standard functions, **safe** copy/format patterns, DIY `strlen` / `strcpy` / `strcmp`, CSV parsing with `strtok_r` and manual scanners, buffer overflow awareness with safe alternatives, and exercises.

Compile with:

```bash
gcc -std=c17 -Wall -Wextra program.c -o program
```

## String Representation

### Character Arrays and Literals

```c
char str1[6] = {'H', 'e', 'l', 'l', 'o', '\0'};
char str2[6] = "Hello";   /* same content; size includes '\0' */
char str3[]  = "Hello";   /* size 6 inferred */

char *lit = "Hello";      /* pointer to string literal — treat as read-only */
char buf[] = "Hello";     /* mutable copy in your array */
```

### Memory Layout

```text
char s[] = "Hi";

 index:  0    1    2
       ┌────┬────┬────┐
       │'H' │'i' │'\0'│
       └────┴────┴────┘
 length strlen(s) == 2
 storage size sizeof s == 3
```

### Literals Must Not Be Modified

```c
char *p = "Hello";
/* p[0] = 'h'; */   /* undefined behavior — may crash */

char a[] = "Hello";
a[0] = 'h';         /* OK — a is a mutable array */
```

Prefer `const char *p = "Hello";` so the compiler helps you avoid writes.

## Declaration Patterns

```c
char name[64] = "Ada";     /* modifiable, fixed capacity */
char empty[32] = "";       /* just '\0' */
char raw[32];              /* uninitialized — do not read as a string yet */
char *msg = "ready";       /* points at literal */

#include <string.h>
memset(raw, 0, sizeof raw);  /* explicit clear */
```

## Standard Library Overview

```c
#include <string.h>

size_t strlen(const char *s);
char  *strcpy(char *dst, const char *src);           /* unsafe if dst too small */
char  *strncpy(char *dst, const char *src, size_t n);/* subtle; see below */
int    strcmp(const char *a, const char *b);
int    strncmp(const char *a, const char *b, size_t n);
char  *strcat(char *dst, const char *src);           /* unsafe if dst too small */
char  *strncat(char *dst, const char *src, size_t n);
char  *strchr(const char *s, int c);
char  *strstr(const char *haystack, const char *needle);
```

Also useful: `snprintf` from `<stdio.h>` for bounded formatting into a buffer.

## Safe String Handling Patterns

### Prefer `snprintf` over bare `strcpy` / `strcat`

`snprintf` always null-terminates when the buffer size is greater than zero, and it tells you how many characters would have been written.

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char buf[16];
    const char *user = "Ada Lovelace";

    int n = snprintf(buf, sizeof buf, "hi %s", user);
    if (n < 0) {
        /* encoding error (rare) */
        return 1;
    }
    if ((size_t)n >= sizeof buf) {
        /* truncated — buf is still a valid C string */
        printf("truncated: \"%s\" (needed %d bytes incl. nul logic)\n", buf, n + 1);
    } else {
        printf("full: \"%s\"\n", buf);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra snip.c -o snip
./snip
```

### Building Paths or Messages Safely

```c
#include <stdio.h>

static int join3(char *out, size_t out_sz,
                 const char *a, const char *b, const char *c) {
    int n = snprintf(out, out_sz, "%s/%s/%s", a, b, c);
    if (n < 0) {
        return -1;
    }
    if ((size_t)n >= out_sz) {
        return -2;  /* truncated */
    }
    return 0;
}

int main(void) {
    char path[32];
    if (join3(path, sizeof path, "home", "ada", "notes.txt") == 0) {
        printf("%s\n", path);
    }
    return 0;
}
```

### `strncpy` vs `snprintf` — Know the Trap

`strncpy` is **not** a “safe strcpy.” It pads with zeros up to `n`, and if `src` length is ≥ `n`, it **does not** write a `'\0'`.

```c
#include <stdio.h>
#include <string.h>

int main(void) {
    char dest[8];
    const char *src = "OVERFLOW!";  /* longer than dest */

    /* TRAP: dest may be not null-terminated */
    strncpy(dest, src, sizeof dest);
    /* dest has 8 chars, no '\0' — using it as a string is UB */

    /* Repair pattern if you must use strncpy: */
    dest[sizeof dest - 1] = '\0';

    /* BETTER: */
    char dest2[8];
    snprintf(dest2, sizeof dest2, "%s", src);  /* always terminated if size > 0 */

    printf("dest2 = \"%s\"\n", dest2);
    return 0;
}
```

### Bounded Copy Helper (Recommended Pattern)

```c
#include <stdio.h>
#include <string.h>

/* Returns 0 on full copy, -1 on truncation or bad args. Always terminates if dst_sz > 0. */
static int str_copy(char *dst, size_t dst_sz, const char *src) {
    if (dst == NULL || src == NULL || dst_sz == 0) {
        return -1;
    }
    int n = snprintf(dst, dst_sz, "%s", src);
    if (n < 0 || (size_t)n >= dst_sz) {
        return -1;
    }
    return 0;
}

int main(void) {
    char b[8];
    if (str_copy(b, sizeof b, "hello") == 0) {
        printf("ok: %s\n", b);
    }
    if (str_copy(b, sizeof b, "toolong!") != 0) {
        printf("truncated-or-fail: \"%s\"\n", b);
    }
    return 0;
}
```

### Safe Concatenation

```c
#include <stdio.h>
#include <string.h>

static int str_append(char *dst, size_t dst_sz, const char *src) {
    if (dst == NULL || src == NULL || dst_sz == 0) {
        return -1;
    }
    size_t used = strlen(dst);
    if (used >= dst_sz) {
        return -1;  /* dst already not a valid sized string */
    }
    int n = snprintf(dst + used, dst_sz - used, "%s", src);
    if (n < 0 || (size_t)n >= dst_sz - used) {
        return -1;
    }
    return 0;
}

int main(void) {
    char msg[32] = "Hello";
    str_append(msg, sizeof msg, ", ");
    str_append(msg, sizeof msg, "world");
    printf("%s\n", msg);
    return 0;
}
```

### Input: Prefer `fgets` + Strip Newline

```c
#include <stdio.h>
#include <string.h>

static void strip_newline(char *s) {
    size_t n = strlen(s);
    if (n > 0 && s[n - 1] == '\n') {
        s[n - 1] = '\0';
    }
}

int main(void) {
    char line[64];

    /* BAD: scanf("%s") — no bounds unless you set a width */
    /* BAD: gets — removed from C; never use */

    printf("name: ");
    if (fgets(line, sizeof line, stdin) == NULL) {
        return 1;
    }
    strip_newline(line);
    printf("hello, %s\n", line);
    return 0;
}
```

If you use `scanf` for a single token, always set a maximum field width: `scanf("%63s", line)` for a 64-byte buffer.

## Implement `strlen` / `strcpy` / `strcmp` Yourself

Writing these clarifies how C strings work. Production code should still prefer the standard library and bounded helpers.

### Full Learning Program

```c
#include <stdio.h>
#include <assert.h>

static size_t my_strlen(const char *s) {
    const char *p = s;
    while (*p != '\0') {
        p++;
    }
    return (size_t)(p - s);
}

/* Classic unbounded copy — destination must be large enough (like strcpy). */
static char *my_strcpy(char *dst, const char *src) {
    char *out = dst;
    while ((*dst++ = *src++) != '\0') {
        /* copy including '\0' */
    }
    return out;
}

/* Like strcmp: <0, 0, >0 */
static int my_strcmp(const char *a, const char *b) {
    while (*a != '\0' && *a == *b) {
        a++;
        b++;
    }
    return (unsigned char)*a - (unsigned char)*b;
}

/* Bounded copy: always writes '\0' if dst_sz > 0. Returns total length of src
   (as snprintf does conceptually) so caller can detect truncation. */
static size_t my_strlcpy(char *dst, const char *src, size_t dst_sz) {
    size_t src_len = my_strlen(src);
    if (dst_sz == 0) {
        return src_len;
    }
    size_t copy = (src_len < dst_sz - 1) ? src_len : dst_sz - 1;
    for (size_t i = 0; i < copy; i++) {
        dst[i] = src[i];
    }
    dst[copy] = '\0';
    return src_len;
}

int main(void) {
    const char *s = "Hello";
    assert(my_strlen(s) == 5);
    assert(my_strlen("") == 0);

    char buf[16];
    my_strcpy(buf, s);
    assert(my_strcmp(buf, "Hello") == 0);
    assert(my_strcmp("abc", "abd") < 0);
    assert(my_strcmp("abd", "abc") > 0);

    char small[4];
    size_t need = my_strlcpy(small, "Hello", sizeof small);
    printf("small=\"%s\" need=%zu truncated=%s\n",
           small, need, (need >= sizeof small) ? "yes" : "no");

    printf("all my_string tests passed\n");
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra my_string.c -o my_string
./my_string
```

Notes:

- Cast to `unsigned char` in compare so high-bit characters sort consistently.
- Unbounded `my_strcpy` is for learning; use `my_strlcpy` / `snprintf` in real code.

## Tokenizing and CSV Parsing

### `strtok` vs `strtok_r`

`strtok` keeps hidden static state — **not reentrant**, awkward in libraries and threads. Prefer **`strtok_r`** (POSIX) with an explicit context pointer, or parse manually for full control.

### Full Program: CSV Line with `strtok_r`

```c
#include <stdio.h>
#include <string.h>

enum { MAX_FIELDS = 16, FIELD_LEN = 64 };

/*
 * Split a mutable CSV line on commas into fields[][].
 * Note: strtok_r mutates the line (writes '\0' over delimiters).
 * Returns field count, or -1 on overflow of MAX_FIELDS.
 */
static int split_csv_strtok_r(char *line, char fields[][FIELD_LEN], int max_fields) {
    int count = 0;
    char *save = NULL;
    char *tok = strtok_r(line, ",", &save);

    while (tok != NULL) {
        if (count >= max_fields) {
            return -1;
        }
        /* Bounded copy into fixed field buffer */
        snprintf(fields[count], FIELD_LEN, "%s", tok);
        count++;
        tok = strtok_r(NULL, ",", &save);
    }
    return count;
}

int main(void) {
    char line[] = "ada,lovelace,36,math";  /* mutable */
    char fields[MAX_FIELDS][FIELD_LEN];

    int n = split_csv_strtok_r(line, fields, MAX_FIELDS);
    if (n < 0) {
        fprintf(stderr, "too many fields\n");
        return 1;
    }

    for (int i = 0; i < n; i++) {
        printf("field[%d] = \"%s\"\n", i, fields[i]);
    }
    /* Warning: original line is now shredded into tokens */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra csv_strtok.c -o csv_strtok
./csv_strtok
```

On platforms without `strtok_r`, use the manual parser below (portable C17).

### Full Program: Manual CSV Parse (No `strtok`)

Does not need POSIX; leaves the original string intact if you copy fields out.

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

enum { MAX_FIELDS = 16, FIELD_LEN = 64 };

static void trim_inplace(char *s) {
    /* leading */
    char *start = s;
    while (*start != '\0' && isspace((unsigned char)*start)) {
        start++;
    }
    if (start != s) {
        memmove(s, start, strlen(start) + 1);
    }
    /* trailing */
    size_t n = strlen(s);
    while (n > 0 && isspace((unsigned char)s[n - 1])) {
        s[--n] = '\0';
    }
}

/*
 * Parse comma-separated fields from src into fields.
 * Returns count or -1 if a field would not fit FIELD_LEN or too many fields.
 */
static int split_csv_manual(const char *src,
                            char fields[][FIELD_LEN],
                            int max_fields) {
    int count = 0;
    const char *p = src;

    while (*p != '\0') {
        if (count >= max_fields) {
            return -1;
        }
        /* skip leading spaces in field */
        while (*p != '\0' && *p != ',' && isspace((unsigned char)*p)) {
            p++;
        }
        const char *start = p;
        while (*p != '\0' && *p != ',') {
            p++;
        }
        size_t len = (size_t)(p - start);
        /* trim trailing spaces from the slice */
        while (len > 0 && isspace((unsigned char)start[len - 1])) {
            len--;
        }
        if (len + 1 > FIELD_LEN) {
            return -1;
        }
        memcpy(fields[count], start, len);
        fields[count][len] = '\0';
        count++;

        if (*p == ',') {
            p++;  /* consume comma */
        }
    }
    return count;
}

int main(void) {
    const char *line = " ada , lovelace , 36 , math ";
    char fields[MAX_FIELDS][FIELD_LEN];

    int n = split_csv_manual(line, fields, MAX_FIELDS);
    if (n < 0) {
        fprintf(stderr, "parse error\n");
        return 1;
    }
    printf("original still: \"%s\"\n", line);
    for (int i = 0; i < n; i++) {
        printf("field[%d] = \"%s\"\n", i, fields[i]);
    }
    (void)trim_inplace; /* available for whole-string trimming if needed */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra csv_manual.c -o csv_manual
./csv_manual
```

### Simple Key=Value Line

```c
#include <stdio.h>
#include <string.h>

/* Parse "key=value" into key/value buffers. Returns 0 on success. */
static int parse_kv(const char *line,
                    char *key, size_t key_sz,
                    char *val, size_t val_sz) {
    const char *eq = strchr(line, '=');
    if (eq == NULL) {
        return -1;
    }
    size_t klen = (size_t)(eq - line);
    if (klen + 1 > key_sz) {
        return -1;
    }
    memcpy(key, line, klen);
    key[klen] = '\0';

    if (snprintf(val, val_sz, "%s", eq + 1) < 0) {
        return -1;
    }
    if (strlen(eq + 1) >= val_sz) {
        return -1;  /* truncated */
    }
    return 0;
}

int main(void) {
    char k[32], v[64];
    if (parse_kv("port=8080", k, sizeof k, v, sizeof v) == 0) {
        printf("key=\"%s\" val=\"%s\"\n", k, v);
    }
    return 0;
}
```

## Buffer Overflows: Awareness and Safe Alternatives

A **buffer overflow** happens when code writes past the end of an array. With strings, the usual causes are unbounded copies, missing null terminators, and `scanf("%s")` without a width.

This section is **defensive**. Do not use these ideas to attack systems. The goal is to recognize fragile patterns and replace them with bounded APIs.

### Fragile Pattern (Do Not Ship)

```c
/* ILLUSTRATION ONLY — unbounded write into a fixed buffer */
void fragile_copy(char *dst, const char *src) {
    while (*src) {
        *dst++ = *src++;  /* no length check */
    }
    *dst = '\0';
}
```

If `src` is longer than the space behind `dst`, memory after the buffer is overwritten. That can crash the program or corrupt other data. Treat it as a bug to eliminate.

### Safe Alternatives Checklist

| Fragile | Prefer |
|---------|--------|
| `gets` | `fgets(buf, sizeof buf, stdin)` |
| `scanf("%s", buf)` | `scanf("%63s", buf)` or `fgets` |
| `strcpy(dst, src)` | `snprintf(dst, dst_sz, "%s", src)` |
| `strcat(dst, src)` | `str_append` helper with remaining size |
| `strncpy` without forced `'\0'` | `snprintf` or copy + `dst[sz-1]='\0'` |
| `sprintf(dst, …)` | `snprintf(dst, dst_sz, …)` |
| DIY loops without `n` | index loops with `i + 1 < sz` |

### Full Program: Safe Line Reader and Copy

```c
#include <stdio.h>
#include <string.h>

enum { LINE_MAX = 128 };

static int read_line(char *buf, size_t buf_sz) {
    if (buf == NULL || buf_sz == 0) {
        return -1;
    }
    if (fgets(buf, (int)buf_sz, stdin) == NULL) {
        return -1;
    }
    size_t n = strlen(buf);
    if (n > 0 && buf[n - 1] == '\n') {
        buf[n - 1] = '\0';
    } else {
        /* Line may have been longer than buffer — drain rest of line */
        int c;
        int overflow = (n == buf_sz - 1);
        if (overflow) {
            while ((c = getchar()) != '\n' && c != EOF) {
                /* discard */
            }
            return -2;  /* truncated */
        }
    }
    return 0;
}

int main(void) {
    char name[LINE_MAX];
    char greeting[LINE_MAX];

    printf("Enter your name: ");
    int rc = read_line(name, sizeof name);
    if (rc == -1) {
        fprintf(stderr, "no input\n");
        return 1;
    }
    if (rc == -2) {
        fprintf(stderr, "input too long (truncated)\n");
    }

    if (snprintf(greeting, sizeof greeting, "Hello, %s!", name) < 0) {
        return 1;
    }
    printf("%s\n", greeting);
    return 0;
}
```

### Compiler Help

```bash
gcc -std=c17 -Wall -Wextra -Wformat -Wformat-security program.c -o program
```

Some platforms also offer fortified library functions when optimization is on (`_FORTIFY_SOURCE`). Still write correct sizes yourself — fortification is a backstop, not a design.

## More String Techniques

### Remove Newline, Reverse, Case

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

static void strip_newline(char *s) {
    size_t n = strlen(s);
    if (n > 0 && s[n - 1] == '\n') {
        s[n - 1] = '\0';
    }
}

static void reverse_inplace(char *s) {
    size_t n = strlen(s);
    for (size_t i = 0; i < n / 2; i++) {
        char t = s[i];
        s[i] = s[n - 1 - i];
        s[n - 1 - i] = t;
    }
}

static void to_lower_inplace(char *s) {
    for (; *s; s++) {
        *s = (char)tolower((unsigned char)*s);
    }
}

int main(void) {
    char s[] = "AbCdeF";
    to_lower_inplace(s);
    reverse_inplace(s);
    printf("%s\n", s);  /* fedcba */
    (void)strip_newline;
    return 0;
}
```

### Palindrome Check

```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

static int is_palindrome(const char *str) {
    size_t i = 0;
    size_t j = strlen(str);
    if (j == 0) {
        return 1;
    }
    j--;
    while (i < j) {
        while (i < j && !isalnum((unsigned char)str[i])) i++;
        while (i < j && !isalnum((unsigned char)str[j])) j--;
        if (tolower((unsigned char)str[i]) != tolower((unsigned char)str[j])) {
            return 0;
        }
        i++;
        j--;
    }
    return 1;
}

int main(void) {
    printf("%d\n", is_palindrome("A man, a plan, a canal: Panama")); /* 1 */
    printf("%d\n", is_palindrome("hello")); /* 0 */
    return 0;
}
```

### Word Count

```c
#include <stdio.h>
#include <ctype.h>

static int count_words(const char *str) {
    int count = 0;
    int in_word = 0;
    for (size_t i = 0; str[i] != '\0'; i++) {
        if (isspace((unsigned char)str[i])) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            count++;
        }
    }
    return count;
}

int main(void) {
    printf("%d\n", count_words("  hello   c strings "));  /* 3 */
    return 0;
}
```

### Character Class Statistics

```c
#include <stdio.h>
#include <ctype.h>
#include <string.h>

static void analyze(const char *str) {
    size_t letters = 0, digits = 0, spaces = 0, others = 0;
    for (size_t i = 0; str[i] != '\0'; i++) {
        unsigned char c = (unsigned char)str[i];
        if (isalpha(c)) letters++;
        else if (isdigit(c)) digits++;
        else if (isspace(c)) spaces++;
        else others++;
    }
    printf("letters=%zu digits=%zu spaces=%zu others=%zu len=%zu\n",
           letters, digits, spaces, others, strlen(str));
}

int main(void) {
    analyze("Hello, C17! 42");
    return 0;
}
```

## Pitfalls Recap

1. **Forgetting `'\0'`** after manual copies.
2. **`sizeof` on `char *`** — that is pointer size, not string length.
3. **Modifying string literals.**
4. **`strncpy` without terminator.**
5. **Using `strtok` in concurrent or nested tokenization** — prefer `strtok_r` or manual parse.
6. **Assuming `scanf("%s")` is safe** without a width.

## Exercises

1. **Bounded library.** Implement `str_copy`, `str_append`, and `str_eq` (boolean compare) with full size parameters and tests.

2. **DIY suite.** Write `my_strlen`, `my_strcmp`, `my_strncmp`, and `my_strlcpy`. Compare results against the C library for a table of sample strings.

3. **CSV grades.** Parse lines like `name,score` from a hardcoded multi-line string; compute average score. Use the manual splitter (no `strtok`).

4. **`strtok_r` word counter.** Tokenize on whitespace with `strtok_r` and count tokens. Then reimplement without mutating a second copy.

5. **Safe login prompt.** Read username and password with `fgets` into fixed buffers; reject truncated lines; never use `gets` or unbounded `scanf`.

6. **URL path join.** `join_url(char *out, size_t n, const char *base, const char *path)` using `snprintf`, handling trailing/leading slashes cleanly.

7. **Find and replace first occurrence.** Replace the first occurrence of a substring with another (same length for simplicity, or build into a second buffer with size checks).

8. **Overflow hunt.** Take a small program that uses `strcpy`/`sprintf` and rewrite every call site to a bounded form. List each change in comments.

## Summary

1. C strings are **`char` sequences with `'\0'`** — capacity and length are not the same.
2. Prefer **`snprintf`**, **`fgets`**, and explicit sizes over `strcpy` / `gets` / bare `scanf("%s")`.
3. **`strncpy` is easy to misuse**; force termination or switch to `snprintf`.
4. Implementing **`strlen` / `strcpy` / `strcmp`** teaches the model; ship bounded wrappers.
5. **`strtok_r` or manual parsing** beats classic `strtok` for reentrancy and clarity.
6. Treat buffer overflows as **bugs to prevent** with correct sizes and safer APIs — never as something to exploit.

With disciplined buffer handling, C string code can be both efficient and robust.
