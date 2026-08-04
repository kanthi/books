# File Operations

File operations let programs persist data, process large datasets, and talk to the rest of the system. In C, the high-level interface lives in `<stdio.h>`: open a stream (`FILE *`), read or write, then close it. This chapter focuses on **Linux/POSIX** practice with complete, buildable programs.

**Compile everything with:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
```

## File Pointers and the `FILE` Structure

All stdio file work goes through a `FILE *`:

```c
#include <stdio.h>

FILE *fp;  /* stream handle */
```

The exact layout of `FILE` is implementation-defined. Conceptually it holds buffering state, current position, error/EOF flags, and the underlying file descriptor.

Standard streams (already open):

| Stream | Meaning | Typical fd |
|--------|---------|------------|
| `stdin` | Standard input | 0 |
| `stdout` | Standard output | 1 |
| `stderr` | Standard error | 2 |

## Opening Files: `fopen`

```c
FILE *fopen(const char *filename, const char *mode);
```

Returns a stream on success, or `NULL` on failure (check `errno`).

### Modes

| Mode | Access | Position | Create? | Truncate? |
|------|--------|----------|---------|-----------|
| `"r"` | read | start | no | no |
| `"w"` | write | start | yes | yes |
| `"a"` | write | end | yes | no |
| `"r+"` | read/write | start | no | no |
| `"w+"` | read/write | start | yes | yes |
| `"a+"` | read/write | end (writes) | yes | no |

Append `b` for binary (`"rb"`, `"wb"`, …). On Linux, `"b"` has little effect (no CRLF translation), but **always use it for non-text data** for portability and clarity.

### Minimal open / close

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *fp = fopen("data.txt", "r");
    if (fp == NULL) {
        perror("fopen data.txt");
        return EXIT_FAILURE;
    }

    /* ... use fp ... */

    if (fclose(fp) != 0) {
        perror("fclose");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

## Text vs Binary Mode (Caveats)

### Text mode (`"r"`, `"w"`, …)

- Oriented toward characters and lines  
- On some systems (notably Windows), `\n` may be translated to `\r\n` on write and the reverse on read  
- On Linux, translation is typically a no-op, but programs that care about **exact bytes** should still use binary mode  

### Binary mode (`"rb"`, `"wb"`, …)

- Bytes in, bytes out — no newline translation  
- Correct choice for images, compressed data, structs dumped as bytes, executables  
- **Caveat:** writing a raw `struct` with `fwrite` is **not** a portable file format (padding, endianness, alignment). Prefer explicit serialization for interchange  

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *tf = fopen("note.txt", "w");
    FILE *bf = fopen("nums.bin", "wb");
    int nums[] = {1, 2, 3, 4, 5};

    if (tf == NULL || bf == NULL) {
        perror("fopen");
        return EXIT_FAILURE;
    }

    fprintf(tf, "Hello, World!\n");
    if (fwrite(nums, sizeof nums[0], 5, bf) != 5) {
        fprintf(stderr, "short write or error on nums.bin\n");
    }

    fclose(tf);
    fclose(bf);
    return 0;
}
```

**Portability note:** Never assume `sizeof(int)` or endianness when exchanging binary files across machines. Use fixed-width types (`uint32_t`) and explicit byte order if the file leaves your process.

## Closing and Buffering

```c
int fclose(FILE *stream);   /* 0 success, EOF failure */
int fflush(FILE *stream);   /* flush buffers to OS */
```

- **Always** `fclose` streams you opened (and check the result after writes — buffered data may fail only at flush/close).  
- `fflush(stdout)` after prompts when you need the user to see text before a blocking read.  
- `setvbuf` can change buffering mode (`_IOFBF`, `_IOLBF`, `_IONBF`).  

```c
#include <stdio.h>

int main(void) {
    printf("Enter name: ");
    fflush(stdout);  /* ensure prompt appears */

    char name[64];
    if (fgets(name, sizeof name, stdin) == NULL) {
        return 1;
    }
    printf("Hi, %s", name);
    return 0;
}
```

## Error Handling: `fopen`, `ferror`, `errno`

### Check every open

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int main(void) {
    FILE *fp = fopen("missing.txt", "r");
    if (fp == NULL) {
        /* perror uses errno */
        perror("fopen missing.txt");

        /* or format yourself */
        fprintf(stderr, "fopen failed: %s (errno=%d)\n",
                strerror(errno), errno);
        return EXIT_FAILURE;
    }
    fclose(fp);
    return 0;
}
```

Common failure reasons: file not found (`ENOENT`), permission denied (`EACCES`), is a directory, too many open files, disk full on write.

### Distinguish EOF from error

`fgetc` returns `EOF` both at end-of-file **and** on error. Use `feof` / `ferror`:

```c
#include <stdio.h>
#include <stdlib.h>

int main(void) {
    FILE *fp = fopen("example.txt", "r");
    int ch;

    if (fp == NULL) {
        perror("fopen");
        return EXIT_FAILURE;
    }

    while ((ch = fgetc(fp)) != EOF) {
        putchar(ch);
    }

    if (ferror(fp)) {
        fprintf(stderr, "read error on example.txt\n");
        clearerr(fp);
        fclose(fp);
        return EXIT_FAILURE;
    }
    if (feof(fp)) {
        /* normal end */
    }

    fclose(fp);
    return 0;
}
```

| Function | Role |
|----------|------|
| `feof(fp)` | Non-zero if EOF indicator is set |
| `ferror(fp)` | Non-zero if error indicator is set |
| `clearerr(fp)` | Clears both indicators |
| `perror(msg)` | Prints `msg: <strerror(errno)>\n` to stderr |
| `strerror(errno)` | Thread-aware alternatives exist (`strerror_r`) on POSIX |

### Pattern: cleanup on partial failure

When multiple resources open, close what you already opened before returning:

```c
FILE *in = fopen(src, "rb");
if (!in) {
    perror(src);
    return 1;
}
FILE *out = fopen(dst, "wb");
if (!out) {
    perror(dst);
    fclose(in);
    return 1;
}
/* ... */
fclose(out);
fclose(in);
```

---

## Full Program 1: Copy a File

Binary-safe copy with block reads (faster than byte-at-a-time for large files):

```c
/* file: fcopy.c */
#include <stdio.h>
#include <stdlib.h>

#define BUFSZ 8192

int main(int argc, char *argv[]) {
    FILE *src = NULL;
    FILE *dst = NULL;
    unsigned char buf[BUFSZ];
    size_t n;
    int status = EXIT_SUCCESS;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <source> <destination>\n", argv[0]);
        return EXIT_FAILURE;
    }

    src = fopen(argv[1], "rb");
    if (src == NULL) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    dst = fopen(argv[2], "wb");
    if (dst == NULL) {
        perror(argv[2]);
        fclose(src);
        return EXIT_FAILURE;
    }

    while ((n = fread(buf, 1, sizeof buf, src)) > 0) {
        if (fwrite(buf, 1, n, dst) != n) {
            fprintf(stderr, "write error: %s\n", argv[2]);
            status = EXIT_FAILURE;
            break;
        }
    }

    if (ferror(src)) {
        fprintf(stderr, "read error: %s\n", argv[1]);
        status = EXIT_FAILURE;
    }

    if (fclose(dst) != 0) {
        perror("fclose destination");
        status = EXIT_FAILURE;
    }
    if (fclose(src) != 0) {
        perror("fclose source");
        status = EXIT_FAILURE;
    }

    if (status == EXIT_SUCCESS) {
        fprintf(stderr, "copied %s -> %s\n", argv[1], argv[2]);
    }
    return status;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o fcopy fcopy.c
./fcopy photo.jpg photo.bak
cmp photo.jpg photo.bak && echo identical
```

---

## Full Program 2: Simplified `wc` (Lines, Words, Bytes)

Counts lines, words (whitespace-separated tokens), and bytes — like a small `wc`:

```c
/* file: mywc.c */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <stdbool.h>

struct counts {
    unsigned long lines;
    unsigned long words;
    unsigned long bytes;
};

static int count_stream(FILE *fp, struct counts *c) {
    int ch;
    bool in_word = false;

    c->lines = c->words = c->bytes = 0;

    while ((ch = fgetc(fp)) != EOF) {
        c->bytes++;

        if (ch == '\n') {
            c->lines++;
        }

        if (isspace((unsigned char)ch)) {
            in_word = false;
        } else if (!in_word) {
            in_word = true;
            c->words++;
        }
    }

    if (ferror(fp)) {
        return -1;
    }
    return 0;
}

static void print_counts(const struct counts *c, const char *name) {
    if (name != NULL) {
        printf("%8lu %8lu %8lu %s\n", c->lines, c->words, c->bytes, name);
    } else {
        printf("%8lu %8lu %8lu\n", c->lines, c->words, c->bytes);
    }
}

int main(int argc, char *argv[]) {
    struct counts total = {0, 0, 0};
    int i;
    int status = EXIT_SUCCESS;

    if (argc == 1) {
        struct counts c;
        if (count_stream(stdin, &c) != 0) {
            fprintf(stderr, "read error on stdin\n");
            return EXIT_FAILURE;
        }
        print_counts(&c, NULL);
        return EXIT_SUCCESS;
    }

    for (i = 1; i < argc; i++) {
        FILE *fp = fopen(argv[i], "rb");
        struct counts c;

        if (fp == NULL) {
            perror(argv[i]);
            status = EXIT_FAILURE;
            continue;
        }

        if (count_stream(fp, &c) != 0) {
            fprintf(stderr, "read error: %s\n", argv[i]);
            status = EXIT_FAILURE;
            fclose(fp);
            continue;
        }
        fclose(fp);

        print_counts(&c, argv[i]);
        total.lines += c.lines;
        total.words += c.words;
        total.bytes += c.bytes;
    }

    if (argc > 2) {
        print_counts(&total, "total");
    }

    return status;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o mywc mywc.c
echo -e "hello world\nfoo" > sample.txt
./mywc sample.txt
./mywc sample.txt sample.txt
printf 'a b c' | ./mywc
```

**Notes**

- Binary mode avoids surprises on platforms with newline translation when counting bytes.  
- `isspace((unsigned char)ch)` avoids undefined behavior for negative `char` values.  
- Words follow a simple “transition into non-space” definition, similar in spirit to classic `wc`.  

---

## Full Program 3: Append Log Lines with Timestamps

Append-only log with ISO-like local timestamps:

```c
/* file: logappend.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <errno.h>

static int timestamp_now(char *buf, size_t buflen) {
    time_t t = time(NULL);
    struct tm tm_now;

    if (t == (time_t)-1) {
        return -1;
    }
    if (localtime_r(&t, &tm_now) == NULL) {
        return -1;
    }
    /* YYYY-MM-DD HH:MM:SS */
    if (strftime(buf, buflen, "%Y-%m-%d %H:%M:%S", &tm_now) == 0) {
        return -1;
    }
    return 0;
}

int main(int argc, char *argv[]) {
    const char *path;
    FILE *fp;
    char ts[32];
    char line[1024];

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <logfile>\n", argv[0]);
        fprintf(stderr, "Reads lines from stdin and appends them with timestamps.\n");
        return EXIT_FAILURE;
    }
    path = argv[1];

    fp = fopen(path, "a");
    if (fp == NULL) {
        fprintf(stderr, "fopen %s: %s\n", path, strerror(errno));
        return EXIT_FAILURE;
    }

    while (fgets(line, sizeof line, stdin) != NULL) {
        size_t len = strlen(line);

        /* strip trailing newline for clean log formatting */
        if (len > 0 && line[len - 1] == '\n') {
            line[len - 1] = '\0';
        }

        if (timestamp_now(ts, sizeof ts) != 0) {
            fprintf(stderr, "timestamp failed\n");
            fclose(fp);
            return EXIT_FAILURE;
        }

        if (fprintf(fp, "[%s] %s\n", ts, line) < 0) {
            fprintf(stderr, "write failed: %s\n", strerror(errno));
            fclose(fp);
            return EXIT_FAILURE;
        }
        if (fflush(fp) != 0) {
            perror("fflush");
            fclose(fp);
            return EXIT_FAILURE;
        }
    }

    if (ferror(stdin)) {
        fprintf(stderr, "error reading stdin\n");
        fclose(fp);
        return EXIT_FAILURE;
    }

    if (fclose(fp) != 0) {
        perror("fclose");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o logappend logappend.c
echo "server started" | ./logappend app.log
echo "accepted client" | ./logappend app.log
cat app.log
# [2026-04-01 14:22:10] server started
# [2026-04-01 14:22:11] accepted client
```

`fopen(..., "a")` guarantees writes append even if another process also appends (with the usual caveats about line atomicity for large writes).

---

## File Size and Status Helpers

```c
/* file: fsize.c */
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *fp;
    long size;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <file>\n", argv[0]);
        return EXIT_FAILURE;
    }

    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        perror(argv[1]);
        return EXIT_FAILURE;
    }

    if (fseek(fp, 0, SEEK_END) != 0) {
        perror("fseek");
        fclose(fp);
        return EXIT_FAILURE;
    }
    size = ftell(fp);
    if (size < 0) {
        perror("ftell");
        fclose(fp);
        return EXIT_FAILURE;
    }

    printf("%s: %ld bytes\n", argv[1], size);
    fclose(fp);
    return 0;
}
```

For huge files, prefer `fseeko` / `ftello` and `off_t` (define `_FILE_OFFSET_BITS=64` on some 32-bit systems). POSIX `stat()` is often clearer for metadata.

---

## Best Practices

1. **Check** `fopen`, `fread`/`fwrite` counts, `ferror`, and `fclose` after writes.  
2. **Close** everything you open; use reverse-order cleanup on error paths.  
3. Use **`"rb"`/`"wb"`** for non-text or exact byte copies.  
4. Prefer **block I/O** (`fread`/`fwrite` with an 4–64 KiB buffer) over `fgetc` for bulk data.  
5. Use **`perror` / `strerror(errno)`** so users know *why* open failed.  
6. **`fflush`** when the next operation needs data on disk or the user needs a prompt.  
7. Do not ignore **short writes** — disks fill up; pipes break.  
8. Treat raw `struct` dumps as non-portable binary unless you control every reader.  

---

## Exercises

### Exercise 1 — Safe truncate-free write

Write `write_all.txt` using mode `"w"`. Then change the program to open with `"r+"` and overwrite only the first line without truncating the rest of the file. Explain when `"w"` would destroy data.

### Exercise 2 — Byte-at-a-time vs block copy

Implement file copy with `fgetc`/`fputc` and again with an 8 KiB buffer. Time both on a ~50 MB file (`time ./fcopy ...`). Record the difference.

### Exercise 3 — Extend `mywc`

Add a `-l` flag that prints only the line count (like `wc -l`). Keep the multi-file total behavior.

### Exercise 4 — Rotating log

Modify `logappend` so that if the log exceeds 10000 bytes (`ftell` after open with `"a+"` and seek end), it renames `app.log` to `app.log.1` (use `rename(2)`) and opens a fresh log.

### Exercise 5 — Error path drill

Point `fcopy` at a source you can read and a destination on a full filesystem or a path without write permission. Confirm you get a useful message and a non-zero exit code, and that the source stream is closed.

### Exercise 6 — Binary round-trip

Write an array of ten `uint32_t` values to `data.bin` with `fwrite`, then read them back and print in hex. Re-open the same file in text mode and discuss whether anything appears different on Linux (and what would change on Windows).

---

## Summary

| Topic | Key API / idea |
|-------|----------------|
| Open / close | `fopen`, `fclose` |
| Modes | `"r"`/`"w"`/`"a"` and `+` / `b` variants |
| Text vs binary | Use `b` for exact bytes; watch portability of structs |
| Errors | `NULL` from `fopen`, `errno`, `ferror` vs `feof` |
| Bulk I/O | `fread` / `fwrite` with a fixed buffer |
| Practice programs | `fcopy`, `mywc`, `logappend` |

Mastering careful open/check/copy/close patterns is the foundation for every later file-processing and system program in C.
