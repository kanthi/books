# Appendix B: C Language Reference

## C Keywords

### Standard C Keywords (C17/C18)
```c
auto     break    case     char     const    continue  default  do
double   else     enum     extern   float    for       goto     if
inline   int      long     register return   short     signed   sizeof
static   struct   switch   typedef  union    unsigned  void     volatile
while    _Alignas _Alignof _Atomic  _Bool    _Complex _Generic
_Imaginary _Noreturn _Static_assert _Thread_local
```

### Deprecated Keywords
- `restrict` (C99-C17, still available but not commonly used)

## Data Types and Sizes

### Basic Data Types
| Type | Typical Size (64-bit) | Range |
|------|----------------------|-------|
| char | 1 byte | -128 to 127 or 0 to 255 |
| unsigned char | 1 byte | 0 to 255 |
| short | 2 bytes | -32,768 to 32,767 |
| unsigned short | 2 bytes | 0 to 65,535 |
| int | 4 bytes | -2,147,483,648 to 2,147,483,647 |
| unsigned int | 4 bytes | 0 to 4,294,967,295 |
| long | 8 bytes | -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 |
| unsigned long | 8 bytes | 0 to 18,446,744,073,709,551,615 |
| float | 4 bytes | 1.2E-38 to 3.4E+38 (6 decimal places) |
| double | 8 bytes | 2.3E-308 to 1.7E+308 (15 decimal places) |
| long double | 16 bytes | 3.4E-4932 to 1.1E+4932 (19 decimal places) |

### Type Specifiers
- `signed`: Explicitly signed integers
- `unsigned`: Non-negative integers
- `short`: Shorter integers
- `long`: Longer integers
- `long long`: Even longer integers (C99)

### Type Qualifiers
- `const`: Read-only data
- `volatile`: Data that may change unexpectedly
- `restrict`: Pointer optimization hint (C99)
- `_Atomic`: Atomic operations (C11)

## Operators

### Arithmetic Operators
| Operator | Description | Example |
|----------|-------------|---------|
| + | Addition | a + b |
| - | Subtraction | a - b |
| * | Multiplication | a * b |
| / | Division | a / b |
| % | Modulus (remainder) | a % b |
| ++ | Increment | ++a or a++ |
| -- | Decrement | --a or a-- |

### Relational Operators
| Operator | Description | Example |
|----------|-------------|---------|
| == | Equal to | a == b |
| != | Not equal to | a != b |
| > | Greater than | a > b |
| < | Less than | a < b |
| >= | Greater than or equal to | a >= b |
| <= | Less than or equal to | a <= b |

### Logical Operators
| Operator | Description | Example |
|----------|-------------|---------|
| && | Logical AND | a && b |
| \|\| | Logical OR | a \|\| b |
| ! | Logical NOT | !a |

### Bitwise Operators
| Operator | Description | Example |
|----------|-------------|---------|
| & | Bitwise AND | a & b |
| \| | Bitwise OR | a \| b |
| ^ | Bitwise XOR | a ^ b |
| ~ | Bitwise NOT (one's complement) | ~a |
| << | Left shift | a << b |
| >> | Right shift | a >> b |

### Assignment Operators
| Operator | Description | Example | Equivalent |
|----------|-------------|---------|------------|
| = | Simple assignment | a = b | a = b |
| += | Add and assign | a += b | a = a + b |
| -= | Subtract and assign | a -= b | a = a - b |
| *= | Multiply and assign | a *= b | a = a * b |
| /= | Divide and assign | a /= b | a = a / b |
| %= | Modulus and assign | a %= b | a = a % b |
| &= | Bitwise AND and assign | a &= b | a = a & b |
| \|= | Bitwise OR and assign | a \|= b | a = a \| b |
| ^= | Bitwise XOR and assign | a ^= b | a = a ^ b |
| <<= | Left shift and assign | a <<= b | a = a << b |
| >>= | Right shift and assign | a >>= b | a = a >> b |

### Other Operators
| Operator | Description | Example |
|----------|-------------|---------|
| sizeof | Size of data type or variable | sizeof(int) |
| & | Address of | &a |
| * | Value at address (dereference) | *ptr |
| ?: | Conditional (ternary) | condition ? a : b |
| , | Comma | a, b |
| . | Member access | struct.member |
| -> | Pointer member access | ptr->member |
| [] | Array subscript | arr[i] |
| () | Function call | func() |

## Standard Library Functions

### Input/Output Functions (<stdio.h>)
```c
// Formatted I/O
int printf(const char *format, ...);
int scanf(const char *format, ...);
int fprintf(FILE *stream, const char *format, ...);
int fscanf(FILE *stream, const char *format, ...);
int sprintf(char *str, const char *format, ...);
int snprintf(char *str, size_t size, const char *format, ...);

// Character I/O
int getchar(void);
int putchar(int c);
int fgetc(FILE *stream);
int fputc(int c, FILE *stream);

// String I/O
char *fgets(char *str, int n, FILE *stream);
int fputs(const char *str, FILE *stream);

// File operations
FILE *fopen(const char *filename, const char *mode);
int fclose(FILE *stream);
size_t fread(void *ptr, size_t size, size_t nmemb, FILE *stream);
size_t fwrite(const void *ptr, size_t size, size_t nmemb, FILE *stream);
int fseek(FILE *stream, long offset, int whence);
long ftell(FILE *stream);
void rewind(FILE *stream);
```

### String Functions (<string.h>)
```c
// String copying
char *strcpy(char *dest, const char *src);
char *strncpy(char *dest, const char *src, size_t n);

// String concatenation
char *strcat(char *dest, const char *src);
char *strncat(char *dest, const char *src, size_t n);

// String comparison
int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, size_t n);

// String searching
char *strchr(const char *s, int c);
char *strrchr(const char *s, int c);
char *strstr(const char *haystack, const char *needle);
size_t strlen(const char *s);

// Memory operations
void *memcpy(void *dest, const void *src, size_t n);
void *memmove(void *dest, const void *src, size_t n);
int memcmp(const void *s1, const void *s2, size_t n);
void *memset(void *s, int c, size_t n);
```

### Memory Management Functions (<stdlib.h>)
```c
void *malloc(size_t size);
void *calloc(size_t nmemb, size_t size);
void *realloc(void *ptr, size_t size);
void free(void *ptr);
```

### Mathematical Functions (<math.h>)
```c
// Trigonometric functions
double sin(double x);
double cos(double x);
double tan(double x);
double asin(double x);
double acos(double x);
double atan(double x);
double atan2(double y, double x);

// Hyperbolic functions
double sinh(double x);
double cosh(double x);
double tanh(double x);

// Exponential and logarithmic functions
double exp(double x);
double log(double x);    // Natural logarithm
double log10(double x);  // Base-10 logarithm
double pow(double x, double y);
double sqrt(double x);

// Rounding and absolute value
double ceil(double x);
double floor(double x);
double fabs(double x);
double fmod(double x, double y);
```

### Utility Functions (<stdlib.h>)
```c
// Conversion functions
int atoi(const char *nptr);
long atol(const char *nptr);
double atof(const char *nptr);
long int strtol(const char *nptr, char **endptr, int base);
unsigned long int strtoul(const char *nptr, char **endptr, int base);

// Random number generation
int rand(void);
void srand(unsigned int seed);

// Searching and sorting
void *bsearch(const void *key, const void *base,
              size_t nmemb, size_t size,
              int (*compar)(const void *, const void *));
void qsort(void *base, size_t nmemb, size_t size,
           int (*compar)(const void *, const void *));

// Process control
void exit(int status);
void abort(void);
int atexit(void (*func)(void));
```

### Time Functions (<time.h>)
```c
time_t time(time_t *tloc);
char *ctime(const time_t *timep);
struct tm *localtime(const time_t *timep);
struct tm *gmtime(const time_t *timep);
time_t mktime(struct tm *tm);
size_t strftime(char *s, size_t max, const char *format,
                const struct tm *tm);
```

## Preprocessor Directives

### Common Directives
```c
#define MACRO_NAME value
#undef MACRO_NAME
#include <header.h>
#include "file.h"
#if condition
#ifdef MACRO
#ifndef MACRO
#else
#elif condition
#endif
#error message
#pragma directive
#line number "filename"
```

### Standard Macros
```c
__LINE__     // Current line number
__FILE__     // Current filename
__DATE__     // Compilation date
__TIME__     // Compilation time
__STDC__     // Standard C compliance
__STDC_VERSION__ // C standard version
__STDC_HOSTED__  // Hosted implementation
```

## Format Specifiers

### printf Format Specifiers
| Specifier | Description | Example |
|-----------|-------------|---------|
| %d, %i | Signed decimal integer | printf("%d", 42); |
| %u | Unsigned decimal integer | printf("%u", 42u); |
| %o | Octal integer | printf("%o", 42); |
| %x, %X | Hexadecimal integer | printf("%x", 42); |
| %f, %F | Decimal floating point | printf("%f", 3.14); |
| %e, %E | Scientific notation | printf("%e", 3.14); |
| %g, %G | Use %f or %e, whichever is shorter | printf("%g", 3.14); |
| %c | Character | printf("%c", 'A'); |
| %s | String | printf("%s", "Hello"); |
| %p | Pointer address | printf("%p", ptr); |
| %n | Number of characters written so far | printf("%n", &count); |

### scanf Format Specifiers
| Specifier | Description | Example |
|-----------|-------------|---------|
| %d | Signed decimal integer | scanf("%d", &num); |
| %u | Unsigned decimal integer | scanf("%u", &num); |
| %o | Octal integer | scanf("%o", &num); |
| %x | Hexadecimal integer | scanf("%x", &num); |
| %f | Floating point | scanf("%f", &num); |
| %e | Floating point | scanf("%e", &num); |
| %g | Floating point | scanf("%g", &num); |
| %c | Character | scanf("%c", &ch); |
| %s | String | scanf("%s", str); |
| %p | Pointer | scanf("%p", &ptr); |
| %[...] | Character set | scanf("%[aeiou]", str); |

### Format Modifiers
| Modifier | Description | Example |
|----------|-------------|---------|
| hh | char (char) | printf("%hhd", c); |
| h | short (short) | printf("%hd", s); |
| l | long (long) | printf("%ld", l); |
| ll | long long (long long) | printf("%lld", ll); |
| j | intmax_t | printf("%jd", imax); |
| z | size_t | printf("%zd", sz); |
| t | ptrdiff_t | printf("%td", ptrdiff); |
| L | long double | printf("%Lf", ld); |

## Escape Sequences

### Standard Escape Sequences
| Sequence | Description | ASCII Value |
|----------|-------------|-------------|
| \\a | Alert (bell) | 007 |
| \\b | Backspace | 008 |
| \\f | Form feed | 012 |
| \\n | New line | 010 |
| \\r | Carriage return | 013 |
| \\t | Horizontal tab | 009 |
| \\v | Vertical tab | 011 |
| \\\\ | Backslash | 092 |
| \\' | Single quote | 039 |
| \\" | Double quote | 034 |
| \\? | Question mark | 063 |
| \\0 | Null character | 000 |

### Octal and Hexadecimal Escapes
| Sequence | Description | Example |
|----------|-------------|---------|
| \\\\ooo | Octal character | \\\\040 (space) |
| \\\\xhh | Hexadecimal character | \\\\x20 (space) |

## Storage Classes

### Storage Class Specifiers
| Specifier | Storage Duration | Linkage | Scope |
|-----------|------------------|---------|-------|
| auto | Automatic | None | Block |
| register | Automatic | None | Block |
| static | Static | Internal | File/Block |
| extern | Static | External | File |
| typedef | N/A | N/A | File |

## Error Handling

### errno Values (<errno.h>)
```c
EDOM     // Domain error
ERANGE   // Range error
EILSEQ   // Illegal byte sequence
```

### Assertions (<assert.h>)
```c
void assert(int expression);
```

## Signal Handling (<signal.h>)

### Signal Types
```c
SIGABRT  // Abnormal termination
SIGFPE   // Floating-point error
SIGILL   // Illegal instruction
SIGINT   // Interactive attention signal
SIGSEGV  // Invalid memory access
SIGTERM  // Termination request
```

### Signal Functions
```c
void (*signal(int sig, void (*func)(int)))(int);
int raise(int sig);
```

## File Operations Modes

### fopen Modes
| Mode | Description | File Position | File Creation |
|------|-------------|---------------|---------------|
| "r" | Read only | Beginning | No |
| "w" | Write only | Beginning | Yes (truncates) |
| "a" | Append only | End | Yes |
| "r+" | Read/Write | Beginning | No |
| "w+" | Read/Write | Beginning | Yes (truncates) |
| "a+" | Read/Append | End | Yes |

### Binary Mode Suffix
Add 'b' to any mode for binary files (e.g., "rb", "wb", "ab")

## Standard Streams

### Predefined Streams
```c
stdin   // Standard input (keyboard)
stdout  // Standard output (screen)
stderr  // Standard error (screen)
```

## Limits and Constants

### Implementation Limits (<limits.h>)
```c
CHAR_BIT     // Bits in a char (8)
CHAR_MAX     // Maximum char value
CHAR_MIN     // Minimum char value
INT_MAX      // Maximum int value
INT_MIN      // Minimum int value
LONG_MAX     // Maximum long value
LONG_MIN     // Minimum long value
SCHAR_MAX    // Maximum signed char value
SCHAR_MIN    // Minimum signed char value
SHRT_MAX     // Maximum short value
SHRT_MIN     // Minimum short value
UCHAR_MAX    // Maximum unsigned char value
UINT_MAX     // Maximum unsigned int value
ULONG_MAX    // Maximum unsigned long value
USHRT_MAX    // Maximum unsigned short value
```

### Floating-Point Limits (<float.h>)
```c
FLT_DIG      // Decimal digits of precision
FLT_EPSILON  // Smallest x where 1.0 + x != 1.0
FLT_MANT_DIG // Number of digits in mantissa
FLT_MAX      // Maximum float value
FLT_MAX_10_EXP // Maximum decimal exponent
FLT_MIN      // Minimum float value
FLT_MIN_10_EXP // Minimum decimal exponent
DBL_DIG      // Decimal digits of precision (double)
```

## Thread Support (C11) (<threads.h>)

### Thread Functions
```c
int thrd_create(thrd_t *thr, thrd_start_t func, void *arg);
int thrd_equal(thrd_t thr0, thrd_t thr1);
thrd_t thrd_current(void);
int thrd_sleep(const struct timespec *duration, struct timespec *remaining);
void thrd_yield(void);
_Noreturn void thrd_exit(int res);
int thrd_detach(thrd_t thr);
int thrd_join(thrd_t thr, int *res);
```

### Mutex Functions
```c
int mtx_init(mtx_t *mtx, int type);
void mtx_destroy(mtx_t *mtx);
int mtx_lock(mtx_t *mtx);
int mtx_timedlock(mtx_t *mtx, const struct timespec *ts);
int mtx_trylock(mtx_t *mtx);
int mtx_unlock(mtx_t *mtx);
```

### Condition Variable Functions
```c
int cnd_init(cnd_t *cond);
void cnd_destroy(cnd_t *cond);
int cnd_signal(cnd_t *cond);
int cnd_broadcast(cnd_t *cond);
int cnd_wait(cnd_t *cond, mtx_t *mtx);
int cnd_timedwait(cnd_t *cond, mtx_t *mtx, const struct timespec *ts);
```

## Atomic Operations (C11) (<stdatomic.h>)

### Atomic Types
```c
_Atomic bool
_Atomic char
_Atomic short
_Atomic int
_Atomic long
_Atomic long long
_Atomic unsigned char
_Atomic unsigned short
_Atomic unsigned int
_Atomic unsigned long
_Atomic unsigned long long
```

### Atomic Operations
```c
memory_order memory_order_relaxed;
memory_order memory_order_consume;
memory_order memory_order_acquire;
memory_order memory_order_release;
memory_order memory_order_acq_rel;
memory_order memory_order_seq_cst;

#define ATOMIC_VAR_INIT(value)
#define ATOMIC_FLAG_INIT

bool atomic_flag_test_and_set(volatile atomic_flag *object);
void atomic_flag_clear(volatile atomic_flag *object);
```

## Generic Selection (C11) (<stdnoreturn.h>)

### _Generic Keyword
```c
#define MAX(x, y) _Generic((x), \
    int: max_int, \
    float: max_float, \
    double: max_double \
)(x, y)
```

## Alignment (C11) (<stdalign.h>)

### Alignment Specifiers
```c
_Alignas(expression)
alignas(type)
_Alignof(type)
alignof(type)
```

This reference appendix provides a comprehensive overview of the C programming language, covering keywords, operators, standard library functions, and other essential elements. It serves as a quick reference for C programmers of all levels.