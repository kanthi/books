# C11 Features

## Introduction

The C11 standard (ISO/IEC 9899:2011) introduced several important enhancements to the C programming language, focusing on improved type safety, concurrency support, and alignment with modern programming practices. These features addressed many of the limitations and safety concerns that had been identified in earlier versions of the language.

C11 features include static assertions for compile-time checking, anonymous structures and unions for more flexible data organization, thread-local storage for multi-threaded applications, and bounds-checking functions for improved security.

## Static Assertions

Static assertions allow you to perform compile-time checks that can help catch errors early in the development process. This is particularly useful for validating assumptions about data types, structure sizes, or other compile-time constants.

### _Static_assert

```c
#include <stdio.h>
#include <stdint.h>

// Static assertion to ensure int is 32 bits
_Static_assert(sizeof(int) == 4, "int must be 32 bits");

// Static assertion to ensure pointer alignment
_Static_assert(sizeof(void*) >= sizeof(int), "Pointer must be at least as large as int");

typedef struct {
    uint8_t id;
    uint32_t timestamp;
    char data[256];
} Packet;

// Static assertion to ensure structure packing
_Static_assert(sizeof(Packet) == 261, "Packet structure size must be exactly 261 bytes");

int main() {
    printf("All static assertions passed!\n");
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of Packet: %zu bytes\n", sizeof(Packet));
    
    return 0;
}
```

### Practical Static Assertion Examples

```c
#include <stdio.h>
#include <stdint.h>
#include <limits.h>

// Ensure char is 8 bits
_Static_assert(CHAR_BIT == 8, "char must be 8 bits");

// Ensure two's complement representation
_Static_assert(-1 == ~0, "System must use two's complement representation");

// Ensure floating-point format
_Static_assert(sizeof(float) == 4, "float must be 32 bits");
_Static_assert(sizeof(double) == 8, "double must be 64 bits");

// Custom assertion macro for better error messages
#define STATIC_ASSERT(condition, message) _Static_assert(condition, message)

// Assert that a structure has no padding
typedef struct {
    uint32_t a;
    uint16_t b;
    uint8_t c;
    uint8_t d;
} CompactStruct;

STATIC_ASSERT(sizeof(CompactStruct) == 8, "CompactStruct should be exactly 8 bytes");

int main() {
    printf("System characteristics validated at compile time\n");
    printf("Size of CompactStruct: %zu bytes\n", sizeof(CompactStruct));
    
    return 0;
}
```

## Anonymous Structures and Unions

C11 introduced anonymous structures and unions, which allow you to embed structures and unions directly within other structures without requiring a member name.

### Anonymous Structures

```c
#include <stdio.h>

typedef struct {
    int x, y;
} Point;

typedef struct {
    struct {  // Anonymous structure
        int width, height;
    };
    Point position;
} Rectangle;

int main() {
    Rectangle rect = {{100, 50}, {10, 20}};
    
    // Access anonymous structure members directly
    printf("Width: %d, Height: %d\n", rect.width, rect.height);
    printf("Position: (%d, %d)\n", rect.position.x, rect.position.y);
    
    // Modify anonymous structure members
    rect.width = 200;
    rect.height = 100;
    
    printf("Modified Width: %d, Height: %d\n", rect.width, rect.height);
    
    return 0;
}
```

### Anonymous Unions

```c
#include <stdio.h>

typedef struct {
    enum { INTEGER, FLOAT, STRING } type;
    union {  // Anonymous union
        int i;
        float f;
        char *s;
    };
} Value;

void print_value(const Value *v) {
    switch (v->type) {
        case INTEGER:
            printf("Integer: %d\n", v->i);
            break;
        case FLOAT:
            printf("Float: %.2f\n", v->f);
            break;
        case STRING:
            printf("String: %s\n", v->s);
            break;
    }
}

int main() {
    Value values[3];
    
    // Initialize different types of values
    values[0].type = INTEGER;
    values[0].i = 42;
    
    values[1].type = FLOAT;
    values[1].f = 3.14f;
    
    values[2].type = STRING;
    values[2].s = "Hello, World!";
    
    // Print all values
    for (int i = 0; i < 3; i++) {
        print_value(&values[i]);
    }
    
    return 0;
}
```

## Thread-Local Storage

C11 introduced the `_Thread_local` storage class specifier, which allows variables to have separate instances for each thread in a multi-threaded program.

### Basic Thread-Local Storage

```c
#include <stdio.h>
#include <threads.h>
#include <stdlib.h>

// Thread-local variable
_Thread_local int thread_counter = 0;

// Function to be executed by threads
int thread_function(void *arg) {
    int thread_id = *(int*)arg;
    
    // Each thread has its own copy of thread_counter
    for (int i = 0; i < 5; i++) {
        thread_counter++;
        printf("Thread %d: counter = %d\n", thread_id, thread_counter);
        thrd_sleep(&(struct timespec){.tv_sec=1}, NULL);
    }
    
    return 0;
}

int main() {
    thrd_t threads[3];
    int thread_ids[3] = {1, 2, 3};
    
    // Create threads
    for (int i = 0; i < 3; i++) {
        if (thrd_create(&threads[i], thread_function, &thread_ids[i]) != thrd_success) {
            printf("Error creating thread %d\n", i);
            return 1;
        }
    }
    
    // Wait for threads to complete
    for (int i = 0; i < 3; i++) {
        thrd_join(threads[i], NULL);
    }
    
    printf("All threads completed\n");
    return 0;
}
```

### Thread-Local Storage with Initialization

```c
#include <stdio.h>
#include <threads.h>
#include <stdlib.h>
#include <time.h>

// Thread-local variable with initializer
_Thread_local unsigned int thread_seed = 0;

// Function to initialize thread-local seed
void init_thread_seed(void) {
    if (thread_seed == 0) {
        thread_seed = (unsigned int)time(NULL) ^ (unsigned int)(uintptr_t)&thread_seed;
    }
}

int random_thread_function(void *arg) {
    int thread_id = *(int*)arg;
    
    // Initialize thread-local seed
    init_thread_seed();
    
    printf("Thread %d seed: %u\n", thread_id, thread_seed);
    
    // Generate some random numbers
    for (int i = 0; i < 5; i++) {
        int random_num = rand_r(&thread_seed) % 100;
        printf("Thread %d, Random %d: %d\n", thread_id, i, random_num);
        thrd_sleep(&(struct timespec){.tv_sec=0, .tv_nsec=100000000}, NULL);
    }
    
    return 0;
}

int main() {
    thrd_t threads[3];
    int thread_ids[3] = {1, 2, 3};
    
    // Create threads
    for (int i = 0; i < 3; i++) {
        if (thrd_create(&threads[i], random_thread_function, &thread_ids[i]) != thrd_success) {
            printf("Error creating thread %d\n", i);
            return 1;
        }
    }
    
    // Wait for threads to complete
    for (int i = 0; i < 3; i++) {
        thrd_join(threads[i], NULL);
    }
    
    printf("All threads completed\n");
    return 0;
}
```

## Bounds-Checking Functions (Annex K)

C11 introduced bounds-checking functions as an optional extension (Annex K) to improve memory safety and prevent buffer overflows. These functions include additional parameters to specify buffer sizes.

### Safe String Functions

```c
#define __STDC_WANT_LIB_EXT1__ 1
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef __STDC_LIB_EXT1__
// Check if bounds-checking functions are available
void safe_string_operations(void) {
    char buffer[20];
    char source[] = "This is a long string that might overflow";
    errno_t result;
    
    // Safe string copy
    result = strcpy_s(buffer, sizeof(buffer), source);
    if (result != 0) {
        printf("strcpy_s failed: buffer too small\n");
    } else {
        printf("strcpy_s succeeded: %s\n", buffer);
    }
    
    // Safe string concatenation
    char buffer2[50] = "Hello, ";
    char append[] = "World!";
    
    result = strcat_s(buffer2, sizeof(buffer2), append);
    if (result != 0) {
        printf("strcat_s failed\n");
    } else {
        printf("strcat_s succeeded: %s\n", buffer2);
    }
    
    // Safe formatted output
    char formatted[30];
    result = sprintf_s(formatted, sizeof(formatted), "Number: %d, String: %s", 42, "test");
    if (result < 0) {
        printf("sprintf_s failed\n");
    } else {
        printf("sprintf_s succeeded: %s\n", formatted);
    }
}
#else
void safe_string_operations(void) {
    printf("Bounds-checking functions not available\n");
}
#endif

int main() {
    safe_string_operations();
    return 0;
}
```

### Safe Memory Functions

```c
#define __STDC_WANT_LIB_EXT1__ 1
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#ifdef __STDC_LIB_EXT1__
void safe_memory_operations(void) {
    char source[] = "Hello, World!";
    char destination[20];
    errno_t result;
    
    // Safe memory copy
    result = memcpy_s(destination, sizeof(destination), source, strlen(source) + 1);
    if (result != 0) {
        printf("memcpy_s failed\n");
    } else {
        printf("memcpy_s succeeded: %s\n", destination);
    }
    
    // Safe memory set
    char buffer[10];
    result = memset_s(buffer, sizeof(buffer), 'A', sizeof(buffer) - 1);
    if (result != 0) {
        printf("memset_s failed\n");
    } else {
        buffer[sizeof(buffer) - 1] = '\0';
        printf("memset_s succeeded: %s\n", buffer);
    }
}
#else
void safe_memory_operations(void) {
    printf("Bounds-checking functions not available\n");
}
#endif

int main() {
    safe_memory_operations();
    return 0;
}
```

## Generic Selection

C11 introduced the `_Generic` keyword, which allows for type-generic programming by selecting different implementations based on the type of an expression.

### Basic Generic Selection

```c
#include <stdio.h>

// Generic print function using _Generic
#define print(x) _Generic((x), \
    int: print_int, \
    float: print_float, \
    double: print_double, \
    char*: print_string, \
    default: print_unknown \
)(x)

void print_int(int i) {
    printf("Integer: %d\n", i);
}

void print_float(float f) {
    printf("Float: %.2f\n", f);
}

void print_double(double d) {
    printf("Double: %.2f\n", d);
}

void print_string(char *s) {
    printf("String: %s\n", s);
}

void print_unknown(void *p) {
    printf("Unknown type: %p\n", p);
}

int main() {
    int i = 42;
    float f = 3.14f;
    double d = 2.71828;
    char *s = "Hello, World!";
    
    print(i);
    print(f);
    print(d);
    print(s);
    
    return 0;
}
```

### Advanced Generic Selection

```c
#include <stdio.h>
#include <math.h>

// Generic absolute value function
#define abs_val(x) _Generic((x), \
    int: abs, \
    long: labs, \
    long long: llabs, \
    float: fabsf, \
    double: fabs, \
    long double: fabsl \
)(x)

// Generic square function
#define square(x) _Generic((x), \
    int: square_int, \
    float: square_float, \
    double: square_double \
)(x)

int square_int(int x) {
    return x * x;
}

float square_float(float x) {
    return x * x;
}

double square_double(double x) {
    return x * x;
}

int main() {
    int i = -5;
    long l = -1000000L;
    float f = -3.14f;
    double d = -2.71828;
    
    printf("Absolute values:\n");
    printf("abs(%d) = %d\n", i, abs_val(i));
    printf("abs(%ld) = %ld\n", l, abs_val(l));
    printf("abs(%.2f) = %.2f\n", f, abs_val(f));
    printf("abs(%.2f) = %.2f\n", d, abs_val(d));
    
    printf("\nSquares:\n");
    printf("square(%d) = %d\n", i, square(i));
    printf("square(%.2f) = %.2f\n", f, square(f));
    printf("square(%.2f) = %.2f\n", d, square(d));
    
    return 0;
}
```

## Alignment Support

C11 introduced alignment support through the `_Alignas` specifier and `_Alignof` operator, allowing for explicit control over memory alignment.

### Alignment Specifier

```c
#include <stdio.h>
#include <stdalign.h>

// Align structure to 16-byte boundary
struct aligned_struct {
    _Alignas(16) char data[16];
    int value;
};

// Using alignas macro (more portable)
struct portable_aligned {
    alignas(32) double matrix[4][4];
    int id;
};

int main() {
    struct aligned_struct s1;
    struct portable_aligned s2;
    
    printf("Size of aligned_struct: %zu bytes\n", sizeof(s1));
    printf("Alignment of aligned_struct: %zu\n", _Alignof(struct aligned_struct));
    printf("Address of s1.data: %p (aligned to 16: %s)\n", 
           (void*)s1.data, ((uintptr_t)s1.data % 16 == 0) ? "Yes" : "No");
    
    printf("\nSize of portable_aligned: %zu bytes\n", sizeof(s2));
    printf("Alignment of portable_aligned: %zu\n", alignof(struct portable_aligned));
    printf("Address of s2.matrix: %p (aligned to 32: %s)\n", 
           (void*)s2.matrix, ((uintptr_t)s2.matrix % 32 == 0) ? "Yes" : "No");
    
    return 0;
}
```

## Practical Examples

### Thread-Safe Logger with Static Assertions

```c
#include <stdio.h>
#include <threads.h>
#include <time.h>
#include <stdarg.h>

// Static assertions for system requirements
_Static_assert(sizeof(void*) == 8, "64-bit system required");
_Static_assert(CHAR_BIT == 8, "8-bit char required");

// Thread-local logger instance
_Thread_local char log_buffer[1024];
_Thread_local int log_level = 0;

typedef enum {
    LOG_DEBUG,
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR
} LogLevel;

void log_message(LogLevel level, const char *format, ...) {
    const char *level_strings[] = {"DEBUG", "INFO", "WARNING", "ERROR"};
    
    if (level < log_level) return;
    
    // Get current time
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    
    // Format timestamp
    strftime(log_buffer, sizeof(log_buffer), "%Y-%m-%d %H:%M:%S", tm_info);
    
    // Append log level and message
    int offset = strlen(log_buffer);
    snprintf(log_buffer + offset, sizeof(log_buffer) - offset, 
             " [%s] ", level_strings[level]);
    
    // Format the actual message
    va_list args;
    va_start(args, format);
    offset = strlen(log_buffer);
    vsnprintf(log_buffer + offset, sizeof(log_buffer) - offset, format, args);
    va_end(args);
    
    printf("%s\n", log_buffer);
}

int logger_thread(void *arg) {
    int thread_id = *(int*)arg;
    
    // Set different log levels for different threads
    log_level = thread_id % 4;
    
    for (int i = 0; i < 3; i++) {
        log_message(LOG_DEBUG, "Thread %d debug message %d", thread_id, i);
        log_message(LOG_INFO, "Thread %d info message %d", thread_id, i);
        log_message(LOG_WARNING, "Thread %d warning message %d", thread_id, i);
        log_message(LOG_ERROR, "Thread %d error message %d", thread_id, i);
        thrd_sleep(&(struct timespec){.tv_sec=1}, NULL);
    }
    
    return 0;
}

int main() {
    thrd_t threads[3];
    int thread_ids[3] = {1, 2, 3};
    
    printf("Starting multi-threaded logger demo\n");
    
    // Create threads
    for (int i = 0; i < 3; i++) {
        if (thrd_create(&threads[i], logger_thread, &thread_ids[i]) != thrd_success) {
            printf("Error creating thread %d\n", i);
            return 1;
        }
    }
    
    // Wait for threads to complete
    for (int i = 0; i < 3; i++) {
        thrd_join(threads[i], NULL);
    }
    
    printf("Logger demo completed\n");
    return 0;
}
```

## Summary

C11 introduced several important features that enhanced the safety, expressiveness, and concurrency support of the C programming language:

1. **Static Assertions**: Compile-time checks with `_Static_assert`
2. **Anonymous Structures/Unions**: Embed structures directly without member names
3. **Thread-Local Storage**: Per-thread variable instances with `_Thread_local`
4. **Bounds-Checking Functions**: Safer string and memory operations (Annex K)
5. **Generic Selection**: Type-generic programming with `_Generic`
6. **Alignment Support**: Explicit memory alignment control with `_Alignas` and `_Alignof`

These features make C11 a more robust and modern language while maintaining backward compatibility with earlier standards. Understanding and utilizing these features is essential for writing safe, efficient, and maintainable C code in contemporary development environments.