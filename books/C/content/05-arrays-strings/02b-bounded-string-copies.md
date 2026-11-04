---
title: "Bounded String Copies: strncpy, strlcpy, memccpy and strscpy Compared"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# Bounded String Copies: strncpy, strlcpy, memccpy and strscpy Compared

After this page you will know exactly which bytes `strncpy`, `strlcpy`, `memccpy`, `snprintf` and a kernel-style `strscpy` write, how each one tells you about truncation, and which one to use when.

## The problem: truncation, termination, and detection

Copying a C string into a fixed-size buffer sounds simple, but string operations in C present three distinct requirements that standard library functions fulfill differently:

1. **Guaranteed null termination:** Ensuring that the destination buffer always ends with a `'\0'` byte when `size > 0`, preventing subsequent read operations like `strlen` or `printf` from scanning past the allocated memory.
2. **Controlled bounds and safety:** Never writing past the allocated byte capacity of the destination buffer, and avoiding unnecessary reads past unmapped memory boundaries when processing untrusted input.
3. **Explicit truncation detection:** Providing a simple, unambiguous way for the caller to determine whether the source string fit entirely inside the destination buffer or was truncated.

`strcpy` has no bound at all. The bounded function that has been in ISO C since C89, `strncpy`, was designed for fixed-width, NUL-padded record fields, not for C strings. So it leaves the result unterminated when the source doesn't fit, and it writes padding NULs you didn't ask for when the source is short.

The alternatives are `strlcpy` (from OpenBSD, in glibc since 2.38 and in POSIX.1-2024), `memccpy` (POSIX for a long time, ISO C since C23), `snprintf`, and the Linux kernel's `strscpy`. They differ in whether they terminate, how far they read, how they report truncation and where they are available.

## The lab

The program below fills an 8-byte buffer with `#` before each call, so bytes a function did not touch stay visible, and prints NUL bytes as `\0`. `strscpy` is a kernel API, not part of any libc, so `my_strscpy` is a small userspace equivalent written for this lab.

<!-- file: copies.c -->
```c
#define _DEFAULT_SOURCE /* glibc 2.38+ declares strlcpy under this */
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <sys/types.h>

/* Kernel-style strscpy: copy at most size-1 bytes, always terminate
 * (when size > 0), return the copied length or -E2BIG on truncation. */
static ssize_t my_strscpy(char *dst, const char *src, size_t size) {
    if (size == 0)
        return -E2BIG;
    size_t i = 0;
    for (; i < size - 1 && src[i] != '\0'; i++)
        dst[i] = src[i];
    dst[i] = '\0';
    return src[i] == '\0' ? (ssize_t)i : -E2BIG;
}

static void show(const char *label, const char *buf, size_t n) {
    printf("%-9s [", label);
    for (size_t i = 0; i < n; i++) {
        unsigned char c = (unsigned char)buf[i];
        if (c == '\0')
            printf("\\0");
        else if (c == '#')
            printf("#");
        else
            putchar(c);
    }
    printf("]\n");
}

int main(void) {
    const char *src = "hostname-too-long";
    char buf[8];

    /* strncpy: pads with NULs when short, does NOT terminate when long. */
    memset(buf, '#', sizeof buf);
    strncpy(buf, "ok", sizeof buf);
    show("strncpy", buf, sizeof buf);
    memset(buf, '#', sizeof buf);
    strncpy(buf, src, sizeof buf);
    show("strncpy", buf, sizeof buf);
    printf("          terminated? %s\n", memchr(buf, '\0', sizeof buf) ? "yes" : "NO");

    /* strlcpy: always terminates, returns strlen(src) to detect truncation. */
    memset(buf, '#', sizeof buf);
    size_t need = strlcpy(buf, src, sizeof buf);
    show("strlcpy", buf, sizeof buf);
    printf("          returned %zu, truncated? %s\n", need, need >= sizeof buf ? "yes" : "no");

    /* memccpy (C23): stops after copying the terminator, returns NULL if absent. */
    memset(buf, '#', sizeof buf);
    char *end = memccpy(buf, "ok", '\0', sizeof buf);
    show("memccpy", buf, sizeof buf);
    printf("          returned %s\n", end ? "pointer past the NUL" : "NULL");
    memset(buf, '#', sizeof buf);
    end = memccpy(buf, src, '\0', sizeof buf);
    if (!end)
        buf[sizeof buf - 1] = '\0'; /* caller must terminate on truncation */
    show("memccpy", buf, sizeof buf);
    printf("          returned %s\n", end ? "pointer past the NUL" : "NULL (truncated)");

    /* snprintf: always terminates, returns the length it wanted to write. */
    memset(buf, '#', sizeof buf);
    int want = snprintf(buf, sizeof buf, "%s", src);
    show("snprintf", buf, sizeof buf);
    printf("          returned %d, truncated? %s\n", want, (size_t)want >= sizeof buf ? "yes" : "no");

    /* strscpy-style: length or -E2BIG. */
    memset(buf, '#', sizeof buf);
    ssize_t r = my_strscpy(buf, src, sizeof buf);
    show("strscpy", buf, sizeof buf);
    printf("          returned %zd (%s)\n", r, r == -E2BIG ? "-E2BIG" : "length");
    memset(buf, '#', sizeof buf);
    r = my_strscpy(buf, "ok", sizeof buf);
    show("strscpy", buf, sizeof buf);
    printf("          returned %zd\n", r);
    return 0;
}
```

It was compiled with gcc 14.2.0 and glibc 2.41. `_DEFAULT_SOURCE` at the top is needed because glibc only declares `strlcpy` under it (or `_GNU_SOURCE`) when you ask for strict `-std=c23`:

```bash
gcc -std=c23 -Wall -Wextra -O2 -o copies copies.c
```

GCC warned about two of the calls (more on that below):

```text
copies.c: In function ‘main’:
copies.c:42:5: warning: ‘strncpy’ output truncated copying 8 bytes from a string of length 17 [-Wstringop-truncation]
   42 |     strncpy(buf, src, sizeof buf);
      |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
copies.c:66:43: warning: ‘%s’ directive output truncated writing 17 bytes into a region of size 8 [-Wformat-truncation=]
   34 |     const char *src = "hostname-too-long";
      |                       ~~~~~~~~~~~~~~~~~~~  
......
   66 |     int want = snprintf(buf, sizeof buf, "%s", src);
      |                                           ^~
copies.c:66:16: note: ‘snprintf’ output 18 bytes into a destination of size 8
   66 |     int want = snprintf(buf, sizeof buf, "%s", src);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```

Running `./copies` printed:

```text
strncpy   [ok\0\0\0\0\0\0]
strncpy   [hostname]
          terminated? NO
strlcpy   [hostnam\0]
          returned 17, truncated? yes
memccpy   [ok\0#####]
          returned pointer past the NUL
memccpy   [hostnam\0]
          returned NULL (truncated)
snprintf  [hostnam\0]
          returned 17, truncated? yes
strscpy   [hostnam\0]
          returned -7 (-E2BIG)
strscpy   [ok\0#####]
          returned 2
```

The build is otherwise clean, and it also runs clean under `-fsanitize=address,undefined`.

## Reading the results byte by byte

Understanding how each function behaves requires looking closely at the 8-byte destination array `buf` after each copy operation.

### `strncpy`
When copying `"ok"` (2 characters plus NUL) into the 8-byte buffer, `strncpy` writes `'o'`, `'k'`, and then fills the remaining 6 bytes with `'\0'`. This padding ensures fixed-width record fields are completely zeroed out, preventing leftover garbage memory from leaking into disk structures or network packets.

However, when copying `"hostname-too-long"` (17 characters plus NUL) into the 8-byte buffer, `strncpy` writes exactly 8 bytes (`"hostname"`) and stops immediately without appending a `'\0'`. The memory contains no null byte anywhere inside the 8-byte boundary. Passing this non-terminated buffer to `printf("%s")` or `strlen` results in an out-of-bounds read until an arbitrary zero byte is encountered in surrounding memory. Furthermore, `strncpy` returns `dst` (a pointer to `buf`), providing no signal to the caller that the string was cut off.

### `strlcpy`
When copying `"hostname-too-long"` into `buf`, `strlcpy` copies 7 bytes (`"hostnam"`), writes `'\0'` into the 8th position, and returns 17 (the length of the source string `strlen(src)`). 

Because the returned length (17) is greater than or equal to the buffer capacity (8), the caller easily detects truncation by checking `return_value >= sizeof(buf)`. However, to compute that return value, `strlcpy` must scan through all 17 characters of `src` to find its terminating null byte, even though it only writes 8 bytes into `buf`. If `src` is an untrusted or non-null-terminated buffer, `strlcpy` will read memory past the intended bounds.

### `memccpy`
The `memccpy` function searches for a stop character (here `'\0'`) while copying up to $n$ bytes. When copying `"ok"`, it copies `'o'`, `'k'`, `'\0'`, stops immediately without padding the remaining 5 bytes, and returns a pointer to the byte directly after `'\0'` in `buf`.

When copying `"hostname-too-long"` into the 8-byte buffer, `memccpy` copies 8 bytes (`"hostname"`) without finding `'\0'`. It stops and returns `NULL`. The destination buffer is left unterminated, but because `NULL` clearly signals truncation, the caller can explicitly set `buf[sizeof(buf) - 1] = '\0'` to guarantee safety. Crucially, `memccpy` never reads past the specified limit of 8 bytes in `src`.

### `snprintf`
Calling `snprintf(buf, sizeof(buf), "%s", src)` copies 7 bytes, appends `'\0'` at index 7, and returns 17 (the total number of characters that would have been written had space been infinite).

While `snprintf` guarantees null termination, formatting engines introduce extra CPU overhead compared to direct string byte copies. Like `strlcpy`, `snprintf` reads the entire source string to calculate its full un-truncated return length.

### `strscpy`
The kernel-style function `my_strscpy` copies at most `size - 1` bytes and guarantees null termination whenever `size > 0`. When copying `"hostname-too-long"` into `buf`, it writes `"hostnam\0"` (7 characters plus NUL) and returns `-E2BIG`, which prints as `-7` because `E2BIG` is 7 on Linux.

When copying `"ok"`, `my_strscpy` writes `'o'`, `'k'`, `'\0'`, leaves untouched bytes (`#`) intact, and returns 2 (the number of non-null characters copied). It reads at most `size` bytes of the source and stops at its terminator, so an unterminated source can't make it run off the end.

## Function comparison table

The table below summarizes the key operational differences between the five copy mechanisms.

| Function | Guaranteed `'\0'`? | Zero-Pads Buffer? | Reads Past `size` Bytes? | How Truncation Is Detected | Standard / Standardized In |
| :--- | :--- | :--- | :--- | :--- | :--- |
| `strncpy(dst, src, n)` | No (if `strlen(src) >= n`) | Yes (fills rest with `\0`) | No | Cannot be detected from return value alone (returns `dst`) | C89 / POSIX.1-2001 |
| `strlcpy(dst, src, size)` | Yes (when `size > 0`) | No | Yes (scans full `strlen(src)`) | `return_value >= size` | POSIX.1-2024, BSDs, glibc 2.38+; not ISO C |
| `memccpy(dst, src, c, n)` | No (caller must set `dst[n-1] = '\0'` on `NULL`) | No | No | `return_value == NULL` | ISO C23; POSIX (XSI) before that |
| `snprintf(dst, size, "%s", src)` | Yes (when `size > 0`) | No | Yes (scans full `strlen(src)`) | `return_value >= size` | C99 / POSIX.1-2001 |
| `strscpy(dst, src, size)` | Yes (when `size > 0`) | No | No | `return_value == -E2BIG` | Linux kernel only; write your own helper in userspace |

## Choosing the right copy function

Select string copy implementations based on your buffer boundary requirements and input trust level:

- **Fixed-width, NUL-padded record fields:** Use `strncpy` intentionally. This is appropriate for legacy binary record structures (such as database headers or fixed tar archive headers) where trailing bytes must be zero-cleared and strings do not rely on standard null termination.
- **General null-terminated C string copying (trusted input):** Use `strlcpy` (POSIX.1-2024, glibc 2.38+, the BSDs) or, where that isn't available, `snprintf`. Both functions guarantee null termination and allow simple truncation checks via `return_value >= size`.
- **Untrusted or potentially unterminated input:** Use `memccpy` or a `strscpy`-style helper. Because these functions stop reading as soon as either the destination capacity or the source null terminator is reached, they prevent out-of-bounds read vulnerabilities when handling raw network buffers or unbounded user inputs.
- **Whatever you pick:** check for truncation and treat it as an error. A truncated path, hostname or key is a different value, not a shorter version of the same one. The Linux kernel has deprecated `strncpy` and `strlcpy` in favour of `strscpy` for these reasons (see its deprecated-interfaces document).

## Compiler warnings help detect misuse

Modern compilers help detect string buffer misuse statically. GCC has two warnings for this, both turned on by `-Wall`:

1. **`-Wstringop-truncation`:** Warns when `strncpy` is called with a destination bound equal to or smaller than the source string length, indicating that the destination will lack a terminating null byte.
2. **`-Wformat-truncation`:** Warns when calls to `snprintf` can be proven at compile time to result in truncated output.

When compiling `copies.c`, GCC emits diagnostic warnings for the `strncpy` call copying `src` into `buf`, as well as the `snprintf` call with a fixed 8-byte buffer. Using `-Werror` during build integration converts these warnings into build failures, forcing developers to fix improper string size assumptions.

## Common mistakes

### 1. Passing total buffer size to `strncat` instead of remaining space
Unlike `strncpy` or `strlcpy`, the third parameter of `strncat(dst, src, count)` is the *maximum number of bytes to append*, not the total capacity of `dst`.

```c
/* BUG: strncat appends up to sizeof(buf) bytes AFTER dst's current content */
char buf[16] = "hello";
strncat(buf, extra, sizeof(buf)); /* WRONG: result can need 5 + 16 + 1 = 22 bytes */

/* CORRECT: pass remaining available space minus space for '\0' */
size_t len = strlen(buf);
if (len < sizeof(buf)) {
    strncat(buf, extra, sizeof(buf) - len - 1);
}
```

### 2. Calling `sizeof` on a pointer parameter
Using `sizeof` on a function parameter declared as `char dst[]` or `char *dst` evaluates to the size of the pointer (typically 8 bytes on 64-bit architectures), not the size of the underlying array buffer.

```c
void copy_path(char dst[256], const char *src) {
    /* BUG: sizeof(dst) evaluates to sizeof(char *), which is 8, not 256 */
    strlcpy(dst, src, sizeof(dst)); 
}

/* CORRECT: pass capacity explicitly */
void copy_path_correct(char *dst, size_t cap, const char *src) {
    strlcpy(dst, src, cap);
}
```

### 3. Ignoring the return value of `strlcpy` or `snprintf`
Calling `strlcpy` without checking its return value guarantees that the string is terminated, but ignores data loss.

```c
/* BUG: Truncation occurs silently if src > sizeof(buf) */
strlcpy(buf, src, sizeof(buf));

/* CORRECT: Check return value for truncation */
size_t ret = strlcpy(buf, src, sizeof(buf));
if (ret >= sizeof(buf)) {
    /* Handle truncation error */
}
```

### 4. Off-by-one errors with `size` versus `size - 1`
Functions like `strlcpy`, `snprintf`, and `strscpy` take the full capacity of the buffer (`sizeof(buf)`), internally reserving the last byte for `'\0'`. Subtracting 1 manually when calling these functions reduces available capacity unnecessarily.

```c
/* WRONG: subtracting 1 reduces 8-byte buffer capacity to 7 bytes */
strlcpy(buf, src, sizeof(buf) - 1);

/* CORRECT: pass full buffer size */
strlcpy(buf, src, sizeof(buf));
```

The `- 1` belongs only where you terminate by hand, as in the `memccpy` case: on `NULL`, write `buf[sizeof buf - 1] = '\0'`.

## Key takeaways

- `strncpy` was designed for fixed-width NUL-padded fields, not C strings. It does not guarantee null termination when the source length equals or exceeds the destination size, and it zero-fills remaining buffer space.
- `strlcpy` and `snprintf` guarantee null termination when `size > 0` and simplify truncation detection (`ret >= size`), but both scan the entire source string, which can cause reading past expected bounds on untrusted input.
- `memccpy` and a `strscpy`-style helper bound both reads and writes, which makes them the right choice for untrusted or possibly unterminated input. `memccpy` leaves termination to you.
- Compiler flags `-Wall -Wextra` flag unsafe `strncpy` usage (`-Wstringop-truncation`) and format truncation (`-Wformat-truncation`).

## Sources

- [cppreference: strncpy](https://en.cppreference.com/w/c/string/byte/strncpy)
- [cppreference: memccpy](https://en.cppreference.com/w/c/string/byte/memccpy)
- [man7: strlcpy(3)](https://man7.org/linux/man-pages/man3/strlcpy.3.html)
- [man7: string_copying(7)](https://man7.org/linux/man-pages/man7/string_copying.7.html)
- [Linux Kernel Documentation: Deprecated Interfaces](https://docs.kernel.org/process/deprecated.html)
- [GNU C Library release 2.38 notes](https://sourceware.org/glibc/wiki/Release/2.38)
- [POSIX.1-2024 strlcpy documentation](https://pubs.opengroup.org/onlinepubs/9799919799/functions/strlcpy.html)
