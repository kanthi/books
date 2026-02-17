# Standard Library Functions

## Introduction

The C standard library is a collection of functions, macros, and type definitions that are part of the C programming language specification. These functions provide essential functionality for input/output operations, string manipulation, mathematical computations, memory management, and more. Understanding and effectively using the standard library is crucial for C programmers as it provides a foundation for building robust applications.

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
// Thread-safe version
struct tm tm_result;
localtime_r(&rawtime, &tm_result);
```

## Summary

The C standard library provides a rich set of functions that form the foundation of most C programs. Mastering these functions is essential for effective C programming. Key points to remember:

1. **String Functions**: Essential for text processing and manipulation
2. **Mathematical Functions**: Provide a wide range of mathematical operations
3. **Character Functions**: Enable character classification and conversion
4. **Time Functions**: Handle time-related operations and formatting
5. **I/O Functions**: Enable file and console input/output operations
6. **Memory Management**: Provide dynamic memory allocation capabilities
7. **Utility Functions**: Offer various helper functions for common tasks

Understanding and properly using these standard library functions will make your C programs more robust, portable, and efficient. Always consult the documentation for specific behavior and error handling requirements of each function.