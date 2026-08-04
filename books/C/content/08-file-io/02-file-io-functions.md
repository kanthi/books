# File I/O Functions

## Introduction

C provides a rich set of functions for performing input and output operations on files. These functions can be categorized into character I/O, line I/O, formatted I/O, and binary I/O functions. Each category serves different purposes and offers varying levels of control and convenience for file processing tasks.

Understanding these functions is crucial for effectively reading from and writing to files, whether you're processing text data, binary data, or structured information.

**Compile everything with:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
```

Prefer complete programs: create input files, run tools, inspect outputs.

## Character I/O Functions

Character I/O functions allow reading and writing files one character at a time. These functions are useful for simple text processing and when fine-grained control over file operations is needed.

### fgetc() and getc()

Both functions read a single character from a file:

```c
int fgetc(FILE *stream);
int getc(FILE *stream);
```

**Key Points:**
- Returns the character read as an `unsigned char` cast to `int`
- Returns `EOF` on end of file or error
- `fgetc()` is a function, `getc()` may be a macro

### fputc() and putc()

Both functions write a single character to a file:

```c
int fputc(int char, FILE *stream);
int putc(int char, FILE *stream);
```

**Key Points:**
- Writes the character (cast to `unsigned char`) to the file
- Returns the written character on success
- Returns `EOF` on error
- `fputc()` is a function, `putc()` may be a macro

### ungetc()

Pushes a character back onto the input stream:

```c
int ungetc(int char, FILE *stream);
```

**Key Points:**
- Allows "unread" operations for parsing
- Only one character can be pushed back
- Returns the character on success, `EOF` on failure

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main() {
    FILE *input, *output;
    int ch;
    
    input = fopen("input.txt", "r");
    output = fopen("output.txt", "w");
    
    if (input == NULL || output == NULL) {
        printf("Error opening files\n");
        exit(EXIT_FAILURE);
    }
    
    // Convert lowercase to uppercase
    while ((ch = fgetc(input)) != EOF) {
        if (islower(ch)) {
            ch = toupper(ch);
        }
        fputc(ch, output);
    }
    
    // Demonstrate ungetc
    ch = fgetc(input);
    if (ch != EOF) {
        ungetc(ch, input);  // Push character back
        ch = fgetc(input);  // Read it again
        printf("Character read twice: %c\n", ch);
    }
    
    fclose(input);
    fclose(output);
    
    return 0;
}
```

## Line I/O Functions

Line I/O functions are designed for reading and writing entire lines of text, making them ideal for processing text files where data is organized in lines.

### fgets()

Reads a line from a file:

```c
char *fgets(char *str, int count, FILE *stream);
```

**Key Points:**
- Reads at most `count-1` characters
- Stops at newline or end of file
- Always null-terminates the string
- Stores newline in the buffer (if space available)
- Returns `str` on success, `NULL` on error or EOF

### fputs()

Writes a string to a file:

```c
int fputs(const char *str, FILE *stream);
```

**Key Points:**
- Writes string without null terminator
- Does not append newline automatically
- Returns non-negative value on success
- Returns `EOF` on error

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *fp;
    char line[256];
    
    fp = fopen("lines.txt", "w");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    // Write lines to file
    fputs("First line\n", fp);
    fputs("Second line\n", fp);
    fputs("Third line\n", fp);
    
    fclose(fp);
    
    // Read lines from file
    fp = fopen("lines.txt", "r");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    while (fgets(line, sizeof(line), fp) != NULL) {
        // Remove newline if present
        line[strcspn(line, "\n")] = '\0';
        printf("Read line: '%s'\n", line);
    }
    
    fclose(fp);
    return 0;
}
```

## Formatted I/O Functions

Formatted I/O functions provide high-level input and output operations similar to `printf()` and `scanf()`, but operate on files instead of standard streams.

### fprintf()

Writes formatted output to a file:

```c
int fprintf(FILE *stream, const char *format, ...);
```

**Key Points:**
- Works like `printf()` but writes to a file
- Returns number of characters written
- Returns negative value on error

### fscanf()

Reads formatted input from a file:

```c
int fscanf(FILE *stream, const char *format, ...);
```

**Key Points:**
- Works like `scanf()` but reads from a file
- Returns number of items successfully read
- Returns `EOF` on error or end of file

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    char name[50];
    double salary;
} Employee;

int main() {
    FILE *fp;
    Employee emp;
    
    // Write structured data to file
    fp = fopen("employees.txt", "w");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    fprintf(fp, "%d %s %.2f\n", 1, "John Doe", 50000.0);
    fprintf(fp, "%d %s %.2f\n", 2, "Jane Smith", 60000.0);
    fprintf(fp, "%d %s %.2f\n", 3, "Bob Johnson", 55000.0);
    
    fclose(fp);
    
    // Read structured data from file
    fp = fopen("employees.txt", "r");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    printf("Employee Records:\n");
    while (fscanf(fp, "%d %s %lf", &emp.id, emp.name, &emp.salary) == 3) {
        printf("ID: %d, Name: %s, Salary: %.2f\n", 
               emp.id, emp.name, emp.salary);
    }
    
    fclose(fp);
    return 0;
}
```

## Binary I/O Functions

Binary I/O functions allow reading and writing raw data in binary format, preserving the exact bit patterns of the data. These functions are essential for working with binary files like images, executables, or structured data.

### fwrite()

Writes binary data to a file:

```c
size_t fwrite(const void *ptr, size_t size, size_t count, FILE *stream);
```

**Key Points:**
- Writes `count` items of `size` bytes each
- Returns number of items successfully written
- Returns value less than `count` on error

### fread()

Reads binary data from a file:

```c
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);
```

**Key Points:**
- Reads `count` items of `size` bytes each
- Returns number of items successfully read
- Returns value less than `count` on error or EOF

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    char name[20];
    double value;
} Record;

int main() {
    FILE *fp;
    Record records[] = {
        {1, "Record1", 100.5},
        {2, "Record2", 200.75},
        {3, "Record3", 300.25}
    };
    Record read_records[3];
    size_t written, read;
    
    // Write binary data
    fp = fopen("records.bin", "wb");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    written = fwrite(records, sizeof(Record), 3, fp);
    if (written != 3) {
        printf("Error writing records\n");
    }
    
    fclose(fp);
    
    // Read binary data
    fp = fopen("records.bin", "rb");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    read = fread(read_records, sizeof(Record), 3, fp);
    if (read != 3) {
        printf("Error reading records\n");
    }
    
    fclose(fp);
    
    // Display read data
    printf("Read Records:\n");
    for (int i = 0; i < 3; i++) {
        printf("ID: %d, Name: %s, Value: %.2f\n",
               read_records[i].id, read_records[i].name, read_records[i].value);
    }
    
    return 0;
}
```

## Practical Examples

### CSV File Processor
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int id;
    char name[50];
    int age;
    double salary;
} Employee;

int main() {
    FILE *input, *output;
    char line[256];
    Employee emp;
    double total_salary = 0;
    int count = 0;
    
    input = fopen("employees.csv", "r");
    output = fopen("report.txt", "w");
    
    if (input == NULL || output == NULL) {
        printf("Error opening files\n");
        exit(EXIT_FAILURE);
    }
    
    // Skip header line
    fgets(line, sizeof(line), input);
    
    fprintf(output, "Employee Report\n");
    fprintf(output, "===============\n");
    
    // Process each line
    while (fgets(line, sizeof(line), input) != NULL) {
        // Remove newline
        line[strcspn(line, "\n")] = '\0';
        
        // Parse CSV line
        if (sscanf(line, "%d,%[^,],%d,%lf", 
                   &emp.id, emp.name, &emp.age, &emp.salary) == 4) {
            fprintf(output, "ID: %d, Name: %s, Age: %d, Salary: %.2f\n",
                    emp.id, emp.name, emp.age, emp.salary);
            total_salary += emp.salary;
            count++;
        }
    }
    
    if (count > 0) {
        fprintf(output, "\nAverage Salary: %.2f\n", total_salary / count);
    }
    
    fclose(input);
    fclose(output);
    
    printf("Report generated successfully\n");
    return 0;
}
```

### Binary File Analyzer
```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *fp;
    unsigned char buffer[16];
    long offset = 0;
    size_t bytes_read;
    
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    printf("Offset  Hex Dump                  ASCII\n");
    printf("------  --------                  -----\n");
    
    while ((bytes_read = fread(buffer, 1, sizeof(buffer), fp)) > 0) {
        // Print offset
        printf("%06lx  ", offset);
        
        // Print hex values
        for (size_t i = 0; i < sizeof(buffer); i++) {
            if (i < bytes_read) {
                printf("%02x ", buffer[i]);
            } else {
                printf("   ");
            }
            
            // Add extra space after 8 bytes
            if (i == 7) printf(" ");
        }
        
        printf(" ");
        
        // Print ASCII representation
        for (size_t i = 0; i < bytes_read; i++) {
            if (buffer[i] >= 32 && buffer[i] <= 126) {
                printf("%c", buffer[i]);
            } else {
                printf(".");
            }
        }
        
        printf("\n");
        offset += bytes_read;
    }
    
    fclose(fp);
    return 0;
}
```

## Error Handling and Best Practices

### Comprehensive Error Checking
```c
#include <stdio.h>
#include <stdlib.h>

int safe_file_copy(const char *source, const char *destination) {
    FILE *src, *dst;
    int ch;
    
    // Open source file
    src = fopen(source, "rb");
    if (src == NULL) {
        perror("Error opening source file");
        return -1;
    }
    
    // Open destination file
    dst = fopen(destination, "wb");
    if (dst == NULL) {
        perror("Error opening destination file");
        fclose(src);
        return -1;
    }
    
    // Copy data
    while ((ch = fgetc(src)) != EOF) {
        if (fputc(ch, dst) == EOF) {
            perror("Error writing to destination file");
            fclose(src);
            fclose(dst);
            return -1;
        }
    }
    
    // Check for read errors
    if (ferror(src)) {
        perror("Error reading source file");
        fclose(src);
        fclose(dst);
        return -1;
    }
    
    // Close files
    if (fclose(src) != 0) {
        perror("Error closing source file");
        fclose(dst);
        return -1;
    }
    
    if (fclose(dst) != 0) {
        perror("Error closing destination file");
        return -1;
    }
    
    return 0;  // Success
}

int main() {
    if (safe_file_copy("source.txt", "destination.txt") == 0) {
        printf("File copied successfully\n");
    } else {
        printf("File copy failed\n");
    }
    
    return 0;
}
```

## Full Programs: Character, Line, Formatted, Binary

### Program 1 — ROT13 filter (`rot13.c`)

Character I/O over stdin/stdout (and optional files via shell redirection).

```c
/* file: rot13.c */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

static int rot13_char(int ch) {
    if (ch >= 'a' && ch <= 'z') {
        return 'a' + (ch - 'a' + 13) % 26;
    }
    if (ch >= 'A' && ch <= 'Z') {
        return 'A' + (ch - 'A' + 13) % 26;
    }
    return ch;
}

int main(void) {
    int ch;
    while ((ch = fgetc(stdin)) != EOF) {
        if (fputc(rot13_char(ch), stdout) == EOF) {
            perror("fputc");
            return EXIT_FAILURE;
        }
    }
    if (ferror(stdin)) {
        perror("fgetc");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o rot13 rot13.c
echo 'Hello, World!' | ./rot13
echo 'Hello, World!' | ./rot13 | ./rot13   # identity
./rot13 < input.txt > output.txt
```

### Program 2 — Line numberer with long-line handling (`nlnum.c`)

```c
/* file: nlnum.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    FILE *in = stdin;
    char buf[64];
    unsigned long lineno = 0;
    int in_line = 0;  /* true if we already printed a number for current logical line */

    if (argc > 2) {
        fprintf(stderr, "Usage: %s [file]\n", argv[0]);
        return EXIT_FAILURE;
    }
    if (argc == 2) {
        in = fopen(argv[1], "r");
        if (in == NULL) {
            perror(argv[1]);
            return EXIT_FAILURE;
        }
    }

    while (fgets(buf, sizeof buf, in) != NULL) {
        if (!in_line) {
            lineno++;
            printf("%6lu\t", lineno);
            in_line = 1;
        }
        fputs(buf, stdout);
        if (strchr(buf, '\n') != NULL) {
            in_line = 0;  /* finished a full line */
        }
    }

    if (ferror(in)) {
        perror("read");
        if (in != stdin) {
            fclose(in);
        }
        return EXIT_FAILURE;
    }
    if (in != stdin) {
        fclose(in);
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o nlnum nlnum.c
printf 'short\n' > sample.txt
# a line longer than the buffer still gets one line number:
python3 -c 'print("x"*100)' >> sample.txt
./nlnum sample.txt
```

### Program 3 — CSV-ish records with `fprintf` / `fscanf` (`scores_io.c`)

```c
/* file: scores_io.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

struct Score {
    char name[32];
    int points;
};

static int write_scores(const char *path, const struct Score *rows, size_t n) {
    FILE *fp = fopen(path, "w");
    size_t i;

    if (fp == NULL) {
        fprintf(stderr, "fopen %s: %s\n", path, strerror(errno));
        return -1;
    }
    for (i = 0; i < n; i++) {
        if (fprintf(fp, "%s %d\n", rows[i].name, rows[i].points) < 0) {
            perror("fprintf");
            fclose(fp);
            return -1;
        }
    }
    if (fclose(fp) != 0) {
        perror("fclose");
        return -1;
    }
    return 0;
}

static int read_scores(const char *path) {
    FILE *fp = fopen(path, "r");
    char name[32];
    int points;
    int nread;

    if (fp == NULL) {
        fprintf(stderr, "fopen %s: %s\n", path, strerror(errno));
        return -1;
    }

    printf("name\tpoints\n");
    printf("----\t------\n");
    while ((nread = fscanf(fp, "%31s %d", name, &points)) == 2) {
        printf("%s\t%d\n", name, points);
    }
    if (ferror(fp)) {
        perror("fscanf");
        fclose(fp);
        return -1;
    }
    /* nread==EOF or failed match ends loop — OK for this simple format */
    fclose(fp);
    return 0;
}

int main(void) {
    struct Score rows[] = {
        {"alice", 120},
        {"bob", 95},
        {"carol", 140}
    };

    if (write_scores("scores.txt", rows, 3) != 0) {
        return EXIT_FAILURE;
    }
    if (read_scores("scores.txt") != 0) {
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o scores_io scores_io.c
./scores_io
cat scores.txt
```

**Caveat:** `fscanf("%31s")` stops at whitespace — names with spaces need a different format (or `fgets` + parse).

### Program 4 — Binary record dump / load (`binrec.c`)

```c
/* file: binrec.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <errno.h>

struct Rec {
    uint32_t id;
    int32_t  value;
    char     tag[8];  /* fixed field; not a portable interchange format */
};

static int save_recs(const char *path, const struct Rec *recs, size_t n) {
    FILE *fp = fopen(path, "wb");
    size_t wrote;

    if (fp == NULL) {
        fprintf(stderr, "fopen %s: %s\n", path, strerror(errno));
        return -1;
    }
    wrote = fwrite(recs, sizeof recs[0], n, fp);
    if (wrote != n) {
        fprintf(stderr, "short write (%zu of %zu)\n", wrote, n);
        fclose(fp);
        return -1;
    }
    if (fclose(fp) != 0) {
        perror("fclose");
        return -1;
    }
    return 0;
}

static int load_and_print(const char *path) {
    FILE *fp = fopen(path, "rb");
    struct Rec r;
    size_t n;

    if (fp == NULL) {
        fprintf(stderr, "fopen %s: %s\n", path, strerror(errno));
        return -1;
    }
    while ((n = fread(&r, sizeof r, 1, fp)) == 1) {
        /* ensure tag is printable for display */
        char tag[9];
        memcpy(tag, r.tag, 8);
        tag[8] = '\0';
        printf("id=%u value=%d tag=\"%s\"\n", r.id, r.value, tag);
    }
    if (ferror(fp)) {
        perror("fread");
        fclose(fp);
        return -1;
    }
    fclose(fp);
    return 0;
}

int main(void) {
    struct Rec data[2];

    memset(data, 0, sizeof data);
    data[0].id = 1;
    data[0].value = 42;
    memcpy(data[0].tag, "alpha", 6);
    data[1].id = 2;
    data[1].value = -7;
    memcpy(data[1].tag, "beta", 5);

    if (save_recs("recs.bin", data, 2) != 0) {
        return EXIT_FAILURE;
    }
    if (load_and_print("recs.bin") != 0) {
        return EXIT_FAILURE;
    }

    /* hex peek of the file */
    {
        FILE *fp = fopen("recs.bin", "rb");
        unsigned char buf[16];
        size_t n;
        size_t i;
        if (fp) {
            n = fread(buf, 1, sizeof buf, fp);
            printf("first %zu bytes:", n);
            for (i = 0; i < n; i++) {
                printf(" %02x", buf[i]);
            }
            printf("\n");
            fclose(fp);
        }
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o binrec binrec.c
./binrec
xxd recs.bin | head
```

**Portability note:** raw `struct` dumps depend on padding and endianness. Fine for same-machine cache files; use explicit serialization for network or long-term formats.

### Program 5 — `ungetc` simple number peek (`peek_num.c`)

```c
/* file: peek_num.c */
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

/* Read an integer from stdin; first non-digit is pushed back. */
static int read_int(int *out) {
    int ch;
    int sign = 1;
    long val = 0;
    int digits = 0;

    ch = fgetc(stdin);
    while (ch != EOF && isspace((unsigned char)ch)) {
        ch = fgetc(stdin);
    }
    if (ch == '+' || ch == '-') {
        sign = (ch == '-') ? -1 : 1;
        ch = fgetc(stdin);
    }
    while (ch != EOF && isdigit((unsigned char)ch)) {
        digits++;
        val = val * 10 + (ch - '0');
        ch = fgetc(stdin);
    }
    if (ch != EOF) {
        if (ungetc(ch, stdin) == EOF) {
            return -1;
        }
    }
    if (digits == 0) {
        return -1;
    }
    *out = (int)(sign * val);
    return 0;
}

int main(void) {
    int a, b;
    int ch;

    printf("Type: <int><op><int> e.g. 12+34\n");
    if (read_int(&a) != 0) {
        fprintf(stderr, "expected integer\n");
        return EXIT_FAILURE;
    }
    ch = fgetc(stdin);
    if (ch != '+' && ch != '-' && ch != '*' ) {
        fprintf(stderr, "expected operator, got %d\n", ch);
        return EXIT_FAILURE;
    }
    if (read_int(&b) != 0) {
        fprintf(stderr, "expected second integer\n");
        return EXIT_FAILURE;
    }

    switch (ch) {
    case '+': printf("%d\n", a + b); break;
    case '-': printf("%d\n", a - b); break;
    case '*': printf("%d\n", a * b); break;
    default:  return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o peek_num peek_num.c
printf '12+34\n' | ./peek_num
```

### Program 6 — Block copy with progress (`bcopy.c`)

```c
/* file: bcopy.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

#define BUF_SZ 4096

int main(int argc, char *argv[]) {
    FILE *in, *out;
    unsigned char buf[BUF_SZ];
    size_t n;
    unsigned long long total = 0;

    if (argc != 3) {
        fprintf(stderr, "Usage: %s <src> <dst>\n", argv[0]);
        return EXIT_FAILURE;
    }

    in = fopen(argv[1], "rb");
    if (in == NULL) {
        fprintf(stderr, "open %s: %s\n", argv[1], strerror(errno));
        return EXIT_FAILURE;
    }
    out = fopen(argv[2], "wb");
    if (out == NULL) {
        fprintf(stderr, "open %s: %s\n", argv[2], strerror(errno));
        fclose(in);
        return EXIT_FAILURE;
    }

    while ((n = fread(buf, 1, sizeof buf, in)) > 0) {
        size_t off = 0;
        while (off < n) {
            size_t w = fwrite(buf + off, 1, n - off, out);
            if (w == 0) {
                perror("fwrite");
                fclose(in);
                fclose(out);
                return EXIT_FAILURE;
            }
            off += w;
        }
        total += n;
    }
    if (ferror(in)) {
        perror("fread");
        fclose(in);
        fclose(out);
        return EXIT_FAILURE;
    }

    if (fclose(in) != 0 || fclose(out) != 0) {
        perror("fclose");
        return EXIT_FAILURE;
    }
    fprintf(stderr, "copied %llu bytes\n", total);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o bcopy bcopy.c
./bcopy scores.txt scores.bak
```

---

## Error Handling Patterns (Quick Reference)

| Function | Success | Failure / EOF |
|----------|---------|----------------|
| `fgetc` / `getc` | character as `int` | `EOF` — then check `ferror` vs `feof` |
| `fputc` / `putc` | character written | `EOF` |
| `fgets` | `str` pointer | `NULL` |
| `fputs` | non-negative | `EOF` |
| `fprintf` | char count ≥ 0 | negative |
| `fscanf` | count of assigned fields | `EOF` or short count |
| `fread` / `fwrite` | items transferred | short count — check `ferror` |

```c
int ch = fgetc(fp);
if (ch == EOF) {
    if (ferror(fp)) {
        perror("read");
    } else {
        /* clean EOF */
    }
}
```

---

## Summary

C's file I/O functions provide comprehensive capabilities for working with files:

1. **Character I/O**: `fgetc()`, `fputc()`, `ungetc()` for single character operations
2. **Line I/O**: `fgets()`, `fputs()` for line-based text processing
3. **Formatted I/O**: `fprintf()`, `fscanf()` for structured data input/output
4. **Binary I/O**: `fwrite()`, `fread()` for raw binary data operations

Each category of functions serves specific purposes and offers different levels of control and convenience. Proper error handling and understanding of text vs. binary modes are essential for robust file processing applications.

---

## Exercises

```bash
gcc -std=c17 -Wall -Wextra -o exN exN.c
```

1. **Case flip** — Write a filter that toggles case of letters (`Hello` → `hELLO`) using `fgetc`/`fputc` and `ctype.h`.

2. **`nlnum` width** — Add `-w N` to control line-number field width (default 6).

3. **TSV writer** — Store three columns (string, int, double) with `fprintf` as tab-separated values; read them back with `fscanf` or `fgets`+parse.

4. **Binary double array** — Write 100 `double` values with `fwrite`, read them back, print the sum. Confirm file size is `100 * sizeof(double)`.

5. **Short write drill** — Modify `bcopy` to write in 1-byte `fwrite` loops (slow) and compare; still handle short writes correctly.

6. **`ungetc` comment skipper** — Skip C-style `//` comments from stdin: when you see `/` then `/`, discard until newline; use `ungetc` when the second char is not `/`.

7. **EOF vs error** — Open a directory as a file (e.g. `fopen(".", "r")` on Linux may fail) or force an error path; print whether you hit `ferror` or clean EOF on a normal file.