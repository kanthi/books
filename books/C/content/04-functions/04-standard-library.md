# Standard Library Functions

## Introduction

The C standard library is a collection of functions, macros, and type definitions that are part of the C programming language specification. These functions provide essential functionality for input/output operations, string manipulation, mathematical computations, memory management, and more. Understanding and effectively using the standard library is crucial for C programmers as it provides a foundation for building robust applications.

This chapter mixes **API maps** with **complete, compilable programs**. Prefer the programs: type them, break them, and re-run.

```bash
gcc -std=c17 -Wall -Wextra -o prog prog.c
# math examples need the math library on many systems:
gcc -std=c17 -Wall -Wextra -o prog prog.c -lm
```

## String Functions (<string.h>)

### String Copying
```c
#include <string.h>

char *strcpy(char *dest, const char *src);
char *strncpy(char *dest, const char *src, size_t n);
char *strdup(const char *s);        // C23 standard
char *strndup(const char *s, size_t n); // C23 standard
```

### String Concatenation
```c
char *strcat(char *dest, const char *src);
char *strncat(char *dest, const char *src, size_t n);
```

### String Comparison
```c
int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, size_t n);
int strcoll(const char *s1, const char *s2);  // Locale-specific
```

### String Searching
```c
char *strchr(const char *s, int c);     // Find first occurrence
char *strrchr(const char *s, int c);    // Find last occurrence
char *strstr(const char *haystack, const char *needle);  // Find substring
size_t strcspn(const char *s, const char *reject);       // Span of non-matching chars
size_t strspn(const char *s, const char *accept);        // Span of matching chars
char *strpbrk(const char *s, const char *accept);        // Find any of a set of chars
```

### String Tokenization
```c
char *strtok(char *str, const char *delim);
```

### String Length
```c
size_t strlen(const char *s);
size_t strnlen(const char *s, size_t maxlen);  // C23 standard
```

### Memory Functions (<string.h>)

### Memory Copying
```c
void *memcpy(void *dest, const void *src, size_t n);
void *memmove(void *dest, const void *src, size_t n);
```

### Memory Setting
```c
void *memset(void *s, int c, size_t n);
```

### Memory Comparison
```c
int memcmp(const void *s1, const void *s2, size_t n);
```

### Memory Searching
```c
void *memchr(const void *s, int c, size_t n);
```

## Mathematical Functions (<math.h>)

### Basic Mathematical Functions
```c
#include <math.h>

double fabs(double x);          // Absolute value
double ceil(double x);          // Ceiling function
double floor(double x);         // Floor function
double round(double x);         // Round to nearest integer
double trunc(double x);         // Truncate towards zero

double sqrt(double x);          // Square root
double cbrt(double x);          // Cube root
double pow(double x, double y); // Power function
double exp(double x);           // Exponential function
double log(double x);           // Natural logarithm
double log10(double x);         // Base-10 logarithm
double log2(double x);          // Base-2 logarithm

double sin(double x);           // Sine function
double cos(double x);           // Cosine function
double tan(double x);           // Tangent function
double asin(double x);          // Arc sine
double acos(double x);          // Arc cosine
double atan(double x);          // Arc tangent
double atan2(double y, double x); // Arc tangent with two arguments
```

### Hyperbolic Functions
```c
double sinh(double x);          // Hyperbolic sine
double cosh(double x);          // Hyperbolic cosine
double tanh(double x);          // Hyperbolic tangent
```

### Floating-Point Functions
```c
double fmod(double x, double y);    // Floating-point remainder
double remainder(double x, double y); // IEEE remainder
double copysign(double x, double y);  // Copy sign
double nextafter(double x, double y); // Next representable value
```

### Classification and Comparison Functions
```c
int isfinite(double x);         // Check if finite
int isinf(double x);            // Check if infinite
int isnan(double x);            // Check if NaN
int isnormal(double x);         // Check if normal
int signbit(double x);          // Check sign
```

## Character Classification (<ctype.h>)

### Character Testing
```c
#include <ctype.h>

int isalnum(int c);             // Alphanumeric character
int isalpha(int c);             // Alphabetic character
int isdigit(int c);             // Decimal digit
int isxdigit(int c);            // Hexadecimal digit
int islower(int c);             // Lowercase letter
int isupper(int c);             // Uppercase letter
int isblank(int c);             // Blank character (space or tab)
int isspace(int c);             // Whitespace character
int iscntrl(int c);             // Control character
int isprint(int c);             // Printable character
int isgraph(int c);             // Graphic character
int ispunct(int c);             // Punctuation character
```

### Character Conversion
```c
int tolower(int c);             // Convert to lowercase
int toupper(int c);             // Convert to uppercase
```

## Time Functions (<time.h>)

### Time Types
```c
#include <time.h>

typedef long time_t;            // Calendar time
typedef long clock_t;           // Processor time
struct tm {                     // Broken-down time
    int tm_sec;                 // Seconds (0-60)
    int tm_min;                 // Minutes (0-59)
    int tm_hour;                // Hours (0-23)
    int tm_mday;                // Day of month (1-31)
    int tm_mon;                 // Month (0-11)
    int tm_year;                // Year since 1900
    int tm_wday;                // Day of week (0-6, Sunday = 0)
    int tm_yday;                // Day of year (0-365)
    int tm_isdst;               // Daylight saving time flag
};
```

### Time Functions
```c
time_t time(time_t *tloc);      // Get current time
double difftime(time_t time1, time_t time0);  // Difference between two times
time_t mktime(struct tm *tm);   // Convert broken-down time to calendar time
char *asctime(const struct tm *tm);  // Convert to string
char *ctime(const time_t *timep);    // Convert to string
struct tm *gmtime(const time_t *timep);  // Convert to UTC
struct tm *localtime(const time_t *timep);  // Convert to local time
size_t strftime(char *s, size_t max, const char *format, const struct tm *tm);
```

## Input/Output Functions (<stdio.h>)

### File Operations
```c
#include <stdio.h>

FILE *fopen(const char *pathname, const char *mode);
int fclose(FILE *stream);
int fflush(FILE *stream);
FILE *freopen(const char *pathname, const char *mode, FILE *stream);
FILE *fdopen(int fd, const char *mode);
FILE *fmemopen(void *buf, size_t size, const char *mode);  // C23 standard
```

### Formatted I/O
```c
int printf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int sprintf(char *str, const char *format, ...);
int snprintf(char *str, size_t size, const char *format, ...);  // C99

int scanf(const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sscanf(const char *str, const char *format, ...);
```

### Character I/O
```c
int fgetc(FILE *stream);
char *fgets(char *s, int size, FILE *stream);
int fputc(int c, FILE *stream);
int fputs(const char *s, FILE *stream);
int getchar(void);
char *gets(char *s);            // Deprecated, unsafe
int putchar(int c);
int puts(const char *s);
int ungetc(int c, FILE *stream);
```

### Direct I/O
```c
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
```

### File Positioning
```c
int fseek(FILE *stream, long offset, int whence);
long ftell(FILE *stream);
void rewind(FILE *stream);
int fgetpos(FILE *stream, fpos_t *pos);
int fsetpos(FILE *stream, const fpos_t *pos);
```

### Error Handling
```c
void clearerr(FILE *stream);
int feof(FILE *stream);
int ferror(FILE *stream);
void perror(const char *s);
```

## Memory Management (<stdlib.h>)

### Dynamic Memory Allocation
```c
#include <stdlib.h>

void *malloc(size_t size);
void *calloc(size_t nmemb, size_t size);
void *realloc(void *ptr, size_t size);
void free(void *ptr);
void *aligned_alloc(size_t alignment, size_t size);  // C11 standard
```

### Utility Functions
```c
double atof(const char *nptr);          // Convert string to double
int atoi(const char *nptr);             // Convert string to int
long atol(const char *nptr);            // Convert string to long
long long atoll(const char *nptr);      // Convert string to long long (C99)

double strtod(const char *nptr, char **endptr);     // Convert string to double
float strtof(const char *nptr, char **endptr);      // Convert string to float (C99)
long double strtold(const char *nptr, char **endptr); // Convert string to long double (C99)
long strtol(const char *nptr, char **endptr, int base);
long long strtoll(const char *nptr, char **endptr, int base);  // C99
unsigned long strtoul(const char *nptr, char **endptr, int base);
unsigned long long strtoull(const char *nptr, char **endptr, int base);  // C99
```

### Random Number Generation
```c
int rand(void);                 // Generate pseudo-random number
void srand(unsigned int seed);  // Seed the random number generator
```

### Environment Functions
```c
void abort(void);               // Cause abnormal program termination
int atexit(void (*func)(void)); // Register function to be called at exit
int at_quick_exit(void (*func)(void));  // Register function for quick exit (C11)
void exit(int status);          // Terminate program normally
void _Exit(int status);         // Terminate program immediately (C99)
void quick_exit(int status);    // Quick program termination (C11)
char *getenv(const char *name); // Get environment variable
int system(const char *command); // Execute system command
```

### Searching and Sorting
```c
void *bsearch(const void *key, const void *base,
              size_t nmemb, size_t size,
              int (*compar)(const void *, const void *));
void qsort(void *base, size_t nmemb, size_t size,
           int (*compar)(const void *, const void *));
```

### Integer Arithmetic
```c
int abs(int j);                 // Absolute value of int
long labs(long j);              // Absolute value of long
long long llabs(long long j);   // Absolute value of long long (C99)
div_t div(int numer, int denom);  // Integer division
ldiv_t ldiv(long numer, long denom);  // Long integer division
lldiv_t lldiv(long long numer, long long denom);  // Long long integer division (C99)
```

## Advanced Standard Library Features (C23)

### New String Functions
```c
// C23 additions
char *strdup(const char *s);
char *strndup(const char *s, size_t n);
size_t strnlen(const char *s, size_t maxlen);
```

### Enhanced Memory Functions
```c
// Bounds-checking functions (Annex K, optional in C23)
errno_t memcpy_s(void *dest, rsize_t destsz,
                 const void *src, rsize_t count);
errno_t strcpy_s(char *dest, rsize_t destsz,
                 const char *src);
```

## Practical Examples

### String Manipulation Example
```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    char str1[50] = "Hello, ";
    char str2[] = "World!";
    char str3[100];
    
    // String concatenation
    strcpy(str3, str1);
    strcat(str3, str2);
    printf("Concatenated: %s\n", str3);
    
    // String comparison
    if (strcmp(str1, str2) == 0) {
        printf("Strings are equal\n");
    } else {
        printf("Strings are different\n");
    }
    
    // String searching
    char *found = strstr(str3, "World");
    if (found) {
        printf("Found 'World' at position: %ld\n", found - str3);
    }
    
    // String tokenization
    char sentence[] = "This is a sample sentence";
    char *token = strtok(sentence, " ");
    while (token != NULL) {
        printf("Token: %s\n", token);
        token = strtok(NULL, " ");
    }
    
    return 0;
}
```

### Mathematical Functions Example
```c
#include <stdio.h>
#include <math.h>

int main() {
    double x = 4.0;
    double y = 3.0;
    
    printf("Square root of %.2f: %.2f\n", x, sqrt(x));
    printf("%.2f raised to the power of %.2f: %.2f\n", x, y, pow(x, y));
    printf("Sine of %.2f radians: %.2f\n", x, sin(x));
    printf("Natural log of %.2f: %.2f\n", x, log(x));
    
    // Rounding functions
    double value = 3.7;
    printf("Value: %.2f\n", value);
    printf("Ceiling: %.2f\n", ceil(value));
    printf("Floor: %.2f\n", floor(value));
    printf("Round: %.2f\n", round(value));
    
    return 0;
}
```

### Time Functions Example
```c
#include <stdio.h>
#include <time.h>

int main() {
    // Get current time
    time_t rawtime;
    struct tm *timeinfo;
    char buffer[80];
    
    time(&rawtime);
    timeinfo = localtime(&rawtime);
    
    printf("Current local time: %s", asctime(timeinfo));
    
    // Format time
    strftime(buffer, sizeof(buffer), "%Y-%m-%d %H:%M:%S", timeinfo);
    printf("Formatted time: %s\n", buffer);
    
    // Calculate time difference
    time_t start_time = time(NULL);
    
    // Simulate some work
    for (int i = 0; i < 1000000; i++) {
        // Busy loop
    }
    
    time_t end_time = time(NULL);
    double elapsed = difftime(end_time, start_time);
    printf("Elapsed time: %.0f seconds\n", elapsed);
    
    return 0;
}
```

### Memory Management Example
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    // Dynamic memory allocation
    int n = 5;
    int *arr = (int*)malloc(n * sizeof(int));
    
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Initialize array
    for (int i = 0; i < n; i++) {
        arr[i] = i + 1;
        printf("arr[%d] = %d\n", i, arr[i]);
    }
    
    // Resize array
    n = 10;
    arr = (int*)realloc(arr, n * sizeof(int));
    
    if (arr == NULL) {
        printf("Memory reallocation failed\n");
        return 1;
    }
    
    // Initialize new elements
    for (int i = 5; i < n; i++) {
        arr[i] = i + 1;
        printf("arr[%d] = %d\n", i, arr[i]);
    }
    
    // Free memory
    free(arr);
    arr = NULL;  // Good practice to avoid dangling pointers
    
    return 0;
}
```

## Full Programs: Standard Library in Practice

The snippets above are reference maps. The programs below are meant to be **typed, compiled, and run**.

### Program 1 — Safe string toolbox (`strtool.c`)

Demonstrates length, bounded copy, search, tokenize, and compare without buffer overflows.

```c
/* file: strtool.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

/* Copy src into dest; always NUL-terminates if dest_sz > 0.
 * Returns 0 on full copy, -1 if truncated or bad args. */
static int str_copy(char *dest, size_t dest_sz, const char *src) {
    size_t i;

    if (dest == NULL || src == NULL || dest_sz == 0) {
        return -1;
    }
    for (i = 0; i + 1 < dest_sz && src[i] != '\0'; i++) {
        dest[i] = src[i];
    }
    dest[i] = '\0';
    return (src[i] == '\0') ? 0 : -1;
}

static void trim_inplace(char *s) {
    char *start, *end;
    size_t len;

    if (s == NULL) {
        return;
    }
    start = s;
    while (*start != '\0' && isspace((unsigned char)*start)) {
        start++;
    }
    if (*start == '\0') {
        s[0] = '\0';
        return;
    }
    end = start + strlen(start) - 1;
    while (end > start && isspace((unsigned char)*end)) {
        end--;
    }
    len = (size_t)(end - start + 1);
    memmove(s, start, len);
    s[len] = '\0';
}

int main(void) {
    char line[128];
    char key[32];
    char *tok;
    const char *hay = "the quick brown fox jumps over the lazy dog";
    const char *needle = "fox";
    char *found;

    printf("strlen(hay) = %zu\n", strlen(hay));
    found = strstr(hay, needle);
    if (found != NULL) {
        printf("strstr: \"%s\" at offset %td\n", needle, found - hay);
    }

    if (str_copy(key, sizeof key, "port=8080#comment") != 0) {
        fprintf(stderr, "key truncated\n");
    }
    printf("copy: \"%s\"\n", key);

    /* strtok is standard C (not reentrant — fine for this demo) */
    {
        char mutable[] = "alice,bob,carol";
        printf("tokens:");
        for (tok = strtok(mutable, ","); tok != NULL; tok = strtok(NULL, ",")) {
            printf(" [%s]", tok);
        }
        printf("\n");
    }

    printf("Enter a line to trim: ");
    if (fgets(line, sizeof line, stdin) == NULL) {
        return EXIT_FAILURE;
    }
    /* strip newline then trim spaces */
    line[strcspn(line, "\n")] = '\0';
    trim_inplace(line);
    printf("trimmed: \"%s\"\n", line);

    if (strcmp(line, "quit") == 0) {
        printf("matched quit\n");
    } else {
        printf("strcmp vs \"quit\": %d\n", strcmp(line, "quit"));
    }

    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o strtool strtool.c
./strtool
```

**Notes**

- Prefer `strcspn` / manual copies / `snprintf` over unbounded `strcpy`/`strcat`.  
- Cast to `unsigned char` before `isspace` / `ctype.h` macros.  
- `strtok` modifies its buffer and keeps hidden state — fine for simple tools; avoid in threaded code.

### Program 2 — Math lab: vectors and roots (`mathlab.c`)

```c
/* file: mathlab.c */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <errno.h>

struct Vec2 {
    double x;
    double y;
};

static double vec_len(struct Vec2 v) {
    return hypot(v.x, v.y);  /* safer than sqrt(x*x + y*y) for large values */
}

static struct Vec2 vec_norm(struct Vec2 v) {
    double len = vec_len(v);
    struct Vec2 out = {0.0, 0.0};
    if (len > 0.0) {
        out.x = v.x / len;
        out.y = v.y / len;
    }
    return out;
}

static int safe_sqrt(double x, double *out) {
    if (out == NULL) {
        return -1;
    }
    if (x < 0.0) {
        errno = EDOM;
        return -1;
    }
    *out = sqrt(x);
    return 0;
}

int main(void) {
    struct Vec2 a = {3.0, 4.0};
    struct Vec2 n = vec_norm(a);
    double root;
    double angle;

    printf("|a| = %.6f\n", vec_len(a));
    printf("unit(a) = (%.6f, %.6f)\n", n.x, n.y);

    angle = atan2(a.y, a.x);
    printf("atan2(y,x) = %.6f rad (%.2f deg)\n",
           angle, angle * 180.0 / 3.14159265358979323846);

    if (safe_sqrt(2.0, &root) == 0) {
        printf("sqrt(2) = %.10f\n", root);
    }
    if (safe_sqrt(-1.0, &root) != 0) {
        printf("sqrt(-1) rejected (errno may be EDOM)\n");
    }

    printf("pow(2,10) = %.0f\n", pow(2.0, 10.0));
    printf("floor(3.7)=%.1f ceil(3.2)=%.1f round(3.5)=%.1f\n",
           floor(3.7), ceil(3.2), round(3.5));

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o mathlab mathlab.c -lm
./mathlab
```

### Program 3 — Character classifier report (`ctype_report.c`)

```c
/* file: ctype_report.c */
#include <stdio.h>
#include <ctype.h>
#include <string.h>

static void classify(int ch) {
    unsigned char c = (unsigned char)ch;
    printf("'%c' (0x%02x):", (c >= 32 && c < 127) ? c : '?', c);
    if (isdigit(c))  printf(" digit");
    if (isalpha(c))  printf(" alpha");
    if (isalnum(c))  printf(" alnum");
    if (isspace(c))  printf(" space");
    if (ispunct(c))  printf(" punct");
    if (isupper(c))  printf(" upper");
    if (islower(c))  printf(" lower");
    printf(" -> upper='%c' lower='%c'\n",
           toupper(c), tolower(c));
}

int main(int argc, char *argv[]) {
    const char *s;
    size_t i;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <string>\n", argv[0]);
        return 1;
    }
    s = argv[1];
    for (i = 0; s[i] != '\0'; i++) {
        classify((unsigned char)s[i]);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o ctype_report ctype_report.c
./ctype_report 'Hi 42!'
```

### Program 4 — Time stamps and elapsed work (`timelab.c`)

```c
/* file: timelab.c */
#include <stdio.h>
#include <time.h>
#include <string.h>

int main(void) {
    time_t now;
    struct tm local_tm;
    char buf[64];
    clock_t t0, t1;
    volatile double sink = 0.0;
    long i;

    now = time(NULL);
    if (now == (time_t)-1) {
        perror("time");
        return 1;
    }

#if defined(_POSIX_VERSION)
    if (localtime_r(&now, &local_tm) == NULL) {
        perror("localtime_r");
        return 1;
    }
#else
    {
        struct tm *p = localtime(&now);
        if (p == NULL) {
            return 1;
        }
        local_tm = *p;
    }
#endif

    if (strftime(buf, sizeof buf, "%Y-%m-%d %H:%M:%S %Z", &local_tm) == 0) {
        fprintf(stderr, "strftime failed\n");
        return 1;
    }
    printf("local: %s\n", buf);
    printf("asctime: %s", asctime(&local_tm));  /* includes newline */

    t0 = clock();
    for (i = 0; i < 10000000L; i++) {
        sink += 1.0;
    }
    t1 = clock();
    printf("busy loop: %.3f seconds of CPU (clock)\n",
           (double)(t1 - t0) / (double)CLOCKS_PER_SEC);
    printf("sink=%.0f\n", sink);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o timelab timelab.c
./timelab
```

### Program 5 — `qsort` + `bsearch` + `stdlib` utilities (`sortlab.c`)

```c
/* file: sortlab.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static int cmp_int_asc(const void *a, const void *b) {
    int x = *(const int *)a;
    int y = *(const int *)b;
    return (x > y) - (x < y);
}

static int cmp_str(const void *a, const void *b) {
    const char *const *sa = a;
    const char *const *sb = b;
    return strcmp(*sa, *sb);
}

int main(void) {
    int nums[] = {42, 7, 19, 3, 100, 19};
    size_t n = sizeof nums / sizeof nums[0];
    int key = 19;
    int *found;
    const char *words[] = {"pear", "apple", "orange", "banana"};
    size_t wn = sizeof words / sizeof words[0];
    size_t i;
    char *end;
    long port;

    qsort(nums, n, sizeof nums[0], cmp_int_asc);
    printf("sorted ints:");
    for (i = 0; i < n; i++) {
        printf(" %d", nums[i]);
    }
    printf("\n");

    found = bsearch(&key, nums, n, sizeof nums[0], cmp_int_asc);
    if (found != NULL) {
        printf("bsearch %d -> index %td\n", key, found - nums);
    }

    qsort(words, wn, sizeof words[0], cmp_str);
    printf("sorted words:");
    for (i = 0; i < wn; i++) {
        printf(" %s", words[i]);
    }
    printf("\n");

    port = strtol("8080", &end, 10);
    if (end != NULL && *end == '\0' && port > 0 && port <= 65535) {
        printf("parsed port: %ld\n", port);
    }

    printf("abs(-12)=%d, RAND_MAX=%d, rand sample=%d\n",
           abs(-12), RAND_MAX, rand() % 100);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o sortlab sortlab.c
./sortlab
```

### Program 6 — Mini word frequency with `string.h` + heap (`wfreq.c`)

```c
/* file: wfreq.c — counts words from stdin (letters/digits only) */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define MAX_WORD 64
#define MAX_ENTRIES 256

struct Entry {
    char word[MAX_WORD];
    int count;
};

static int find_or_add(struct Entry *tab, int *n, const char *w) {
    int i;
    for (i = 0; i < *n; i++) {
        if (strcmp(tab[i].word, w) == 0) {
            tab[i].count++;
            return 0;
        }
    }
    if (*n >= MAX_ENTRIES) {
        return -1;
    }
    if (strlen(w) >= MAX_WORD) {
        return -1;
    }
    strcpy(tab[*n].word, w);  /* bounded by check above */
    tab[*n].count = 1;
    (*n)++;
    return 0;
}

static int cmp_entry_desc(const void *a, const void *b) {
    const struct Entry *ea = a;
    const struct Entry *eb = b;
    if (ea->count != eb->count) {
        return eb->count - ea->count;
    }
    return strcmp(ea->word, eb->word);
}

int main(void) {
    struct Entry table[MAX_ENTRIES];
    int n = 0;
    char word[MAX_WORD];
    int wi = 0;
    int ch;
    int i;

    while ((ch = getchar()) != EOF) {
        if (isalnum((unsigned char)ch)) {
            if (wi + 1 < MAX_WORD) {
                word[wi++] = (char)tolower((unsigned char)ch);
            }
        } else if (wi > 0) {
            word[wi] = '\0';
            if (find_or_add(table, &n, word) != 0) {
                fprintf(stderr, "table full or word too long\n");
                return EXIT_FAILURE;
            }
            wi = 0;
        }
    }
    if (wi > 0) {
        word[wi] = '\0';
        find_or_add(table, &n, word);
    }

    qsort(table, (size_t)n, sizeof table[0], cmp_entry_desc);
    for (i = 0; i < n; i++) {
        printf("%4d  %s\n", table[i].count, table[i].word);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o wfreq wfreq.c
echo 'To be or not to be' | ./wfreq
```

---

## Best Practices for Using Standard Library Functions

### 1. Error Checking
Always check return values for error conditions:
```c
FILE *file = fopen("data.txt", "r");
if (file == NULL) {
    perror("Error opening file");
    return 1;
}
```

### 2. Buffer Safety
Use safe versions of functions when available and ensure adequate buffer sizes:
```c
char buffer[100];
// Safe approach
if (fgets(buffer, sizeof(buffer), stdin) != NULL) {
    // Process input
}
```

Prefer `snprintf` over `sprintf`:

```c
char path[64];
int n = snprintf(path, sizeof path, "/tmp/%s.log", "app");
if (n < 0 || (size_t)n >= sizeof path) {
    /* truncated or error */
}
```

### 3. Memory Management
Always free dynamically allocated memory:
```c
int *ptr = malloc(10 * sizeof(int));
if (ptr != NULL) {
    // Use memory
    free(ptr);
    ptr = NULL;  // Prevent dangling pointer
}
```

### 4. Locale Awareness
Be aware of locale-specific functions:
```c
#include <locale.h>

setlocale(LC_ALL, "");  // Use system locale
```

### 5. Thread Safety
Some standard library functions are not thread-safe. Use reentrant versions when needed:
```c
// Thread-safe version (POSIX)
struct tm tm_result;
localtime_r(&rawtime, &tm_result);
```

### 6. Link math explicitly
On many Linux toolchains, math symbols live in `libm`:

```bash
gcc -std=c17 -Wall -Wextra -o mathlab mathlab.c -lm
```

---

## Exercises

```bash
gcc -std=c17 -Wall -Wextra -o exN exN.c    # add -lm when using <math.h>
```

1. **Bounded concat** — Write `int str_cat(char *dest, size_t dest_sz, const char *src)` that appends without overflow and always NUL-terminates. Unit-test with full and almost-full buffers.

2. **`strtol` port parser** — Accept a string; accept only `1`…`65535`; reject junk, empty, negatives, and overflow. Return status codes, not just print.

3. **Case-insensitive compare** — Implement `int str_casecmp(const char *a, const char *b)` with `tolower((unsigned char)…)` and test `"Hello"` vs `"hello"`.

4. **Math: distance** — Given two `Vec2` points, print Euclidean distance with `hypot`. Compare naive `sqrt(dx*dx+dy*dy)` on large coordinates (optional exploration).

5. **`qsort` structs** — Sort an array of `{name, score}` by score descending, then name ascending.

6. **Time format** — Print “days since epoch” and a `strftime` format `YYYY-MM-DDThh:mm:ss`.

7. **`wfreq` upgrade** — Read from a filename in `argv[1]` instead of stdin; print only the top 10 words.

8. **ctype filter** — Read stdin, write only alphanumeric characters and spaces to stdout (like a crude sanitizer).

---

## Summary

The C standard library provides a rich set of functions that form the foundation of most C programs. Mastering these functions is essential for effective C programming. Key points to remember:

1. **String Functions**: Essential for text processing and manipulation — prefer bounded copies and `snprintf`
2. **Mathematical Functions**: Provide a wide range of mathematical operations — link with `-lm`
3. **Character Functions**: Enable character classification and conversion — cast to `unsigned char`
4. **Time Functions**: Handle time-related operations and formatting — prefer reentrant APIs when available
5. **I/O Functions**: Enable file and console input/output operations — always check returns
6. **Memory Management**: Provide dynamic memory allocation capabilities — pair every `malloc` with `free`
7. **Utility Functions**: `qsort`, `bsearch`, `strtol`, `abs`, `rand` cover many everyday needs

Understanding and properly using these standard library functions will make your C programs more robust, portable, and efficient. Always consult the documentation for specific behavior and error handling requirements of each function.