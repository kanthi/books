# Advanced Preprocessor

## Introduction

The C preprocessor is a powerful text processing tool that operates before the actual compilation begins. While often overlooked, mastering advanced preprocessor techniques can lead to more maintainable, efficient, and feature-rich C code. Modern C standards have enhanced preprocessor capabilities, making it even more versatile for metaprogramming and code generation.

This chapter explores advanced preprocessor features including macro definitions, conditional compilation, pragma directives, and token manipulation techniques that enable sophisticated code generation and platform-specific optimizations.

## Macro Definitions and Function-like Macros

Macros are the most fundamental preprocessor feature, allowing for text substitution and code generation.

### Advanced Macro Techniques

```c
#include <stdio.h>
#include <stdlib.h>

// Stringification operator (#)
#define STRINGIFY(x) #x
#define PRINT_VAR(var) printf(#var " = %d\n", var)

// Token pasting operator (##)
#define CONCAT(a, b) a##b
#define DECLARE_VAR(type, name) type CONCAT(my_, name)

// Variadic macros (C99)
#define DEBUG_PRINT(fmt, ...) \
    fprintf(stderr, "[DEBUG] %s:%d: " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)

#define LOG(level, fmt, ...) \
    printf("[" #level "] " fmt "\n", ##__VA_ARGS__)

// Macro overloading based on number of arguments
#define GET_MACRO(_1, _2, _3, NAME, ...) NAME
#define ADD2(a, b) ((a) + (b))
#define ADD3(a, b, c) ((a) + (b) + (c))
#define ADD(...) GET_MACRO(__VA_ARGS__, ADD3, ADD2)(__VA_ARGS__)

int main() {
    int x = 42;
    
    // Stringification
    printf("Value of x: %s\n", STRINGIFY(x));
    PRINT_VAR(x);
    
    // Token pasting
    DECLARE_VAR(int, counter) = 100;
    printf("my_counter = %d\n", my_counter);
    
    // Variadic macros
    DEBUG_PRINT("This is a debug message");
    DEBUG_PRINT("Value of x is %d", x);
    LOG(INFO, "Application started");
    LOG(ERROR, "Failed to open file: %s", "config.txt");
    
    // Macro overloading
    printf("ADD(1, 2) = %d\n", ADD(1, 2));
    printf("ADD(1, 2, 3) = %d\n", ADD(1, 2, 3));
    
    return 0;
}
```

### Generic Programming with Macros

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Generic swap macro
#define SWAP(a, b) do { \
    typeof(a) temp = (a); \
    (a) = (b); \
    (b) = temp; \
} while(0)

// Generic maximum macro
#define MAX(a, b) ({ \
    typeof(a) _a = (a); \
    typeof(b) _b = (b); \
    _a > _b ? _a : _b; \
})

// Generic container_of macro (similar to Linux kernel)
#define container_of(ptr, type, member) ({ \
    const typeof(((type *)0)->member) * __mptr = (ptr); \
    (type *)((char *)__mptr - offsetof(type, member)); \
})

#define offsetof(type, member) ((size_t) &((type *)0)->member)

typedef struct {
    int id;
    char name[50];
    double value;
} Item;

int main() {
    // Generic swap
    int x = 10, y = 20;
    printf("Before swap: x=%d, y=%d\n", x, y);
    SWAP(x, y);
    printf("After swap: x=%d, y=%d\n", x, y);
    
    double a = 3.14, b = 2.71;
    printf("Before swap: a=%.2f, b=%.2f\n", a, b);
    SWAP(a, b);
    printf("After swap: a=%.2f, b=%.2f\n", a, b);
    
    // Generic maximum
    printf("MAX(10, 20) = %d\n", MAX(10, 20));
    printf("MAX(3.14, 2.71) = %.2f\n", MAX(3.14, 2.71));
    
    // Container of example
    Item item = {1, "Test Item", 99.99};
    char *name_ptr = item.name;
    
    // Get the container from a member pointer
    Item *container = container_of(name_ptr, Item, name);
    printf("Container ID: %d, Name: %s, Value: %.2f\n", 
           container->id, container->name, container->value);
    
    return 0;
}
```

## Conditional Compilation

Conditional compilation allows you to include or exclude code based on preprocessor conditions, enabling platform-specific code and feature toggles.

### Platform-Specific Compilation

```c
#include <stdio.h>

// Platform detection
#if defined(_WIN32) || defined(_WIN64)
    #define PLATFORM_WINDOWS
    #include <windows.h>
#elif defined(__linux__)
    #define PLATFORM_LINUX
    #include <unistd.h>
#elif defined(__APPLE__)
    #define PLATFORM_MACOS
    #include <unistd.h>
#endif

// Compiler detection
#if defined(__GNUC__)
    #define COMPILER_GCC
    #define NORETURN __attribute__((noreturn))
    #define UNUSED __attribute__((unused))
#elif defined(_MSC_VER)
    #define COMPILER_MSVC
    #define NORETURN __declspec(noreturn)
    #define UNUSED
#endif

// Feature detection
#if __STDC_VERSION__ >= 202311L
    #define C23_AVAILABLE
    #define HAS_TYPEOF typeof
#elif __STDC_VERSION__ >= 201112L
    #define C11_AVAILABLE
    #define HAS_TYPEOF __typeof__
#else
    #define C99_AVAILABLE
#endif

// Debug vs Release builds
#ifdef DEBUG
    #define DBG_PRINT(fmt, ...) fprintf(stderr, "[DEBUG] " fmt "\n", ##__VA_ARGS__)
    #define ASSERT(condition) do { \
        if (!(condition)) { \
            fprintf(stderr, "Assertion failed: %s at %s:%d\n", \
                    #condition, __FILE__, __LINE__); \
            abort(); \
        } \
    } while(0)
#else
    #define DBG_PRINT(fmt, ...) do {} while(0)
    #define ASSERT(condition) do {} while(0)
#endif

// Feature toggles
#define FEATURE_NETWORKING 1
#define FEATURE_DATABASE 0

#if FEATURE_NETWORKING
    #include <sys/socket.h>
    void init_networking(void) {
        printf("Networking initialized\n");
    }
#else
    void init_networking(void) {
        printf("Networking disabled\n");
    }
#endif

#if FEATURE_DATABASE
    #include <sqlite3.h>
    void init_database(void) {
        printf("Database initialized\n");
    }
#else
    void init_database(void) {
        printf("Database disabled\n");
    }
#endif

int main() {
    printf("Platform: ");
#if defined(PLATFORM_WINDOWS)
    printf("Windows\n");
#elif defined(PLATFORM_LINUX)
    printf("Linux\n");
#elif defined(PLATFORM_MACOS)
    printf("macOS\n");
#else
    printf("Unknown\n");
#endif
    
    printf("Compiler: ");
#ifdef COMPILER_GCC
    printf("GCC\n");
#elif defined(COMPILER_MSVC)
    printf("MSVC\n");
#else
    printf("Unknown\n");
#endif
    
    printf("C Standard: ");
#ifdef C23_AVAILABLE
    printf("C23\n");
#elif defined(C11_AVAILABLE)
    printf("C11\n");
#else
    printf("C99 or earlier\n");
#endif
    
    // Debug printing
    DBG_PRINT("Debug message");
    DBG_PRINT("Value of x: %d", 42);
    
    // Assertions
    int x = 10;
    ASSERT(x > 0);
    
    // Feature initialization
    init_networking();
    init_database();
    
    return 0;
}
```

### Version-Specific Code

```c
#include <stdio.h>

// Version checking macros
#define VERSION_CHECK(major, minor, patch) \
    ((major) * 10000 + (minor) * 100 + (patch))

#define LIBRARY_VERSION VERSION_CHECK(2, 3, 1)

// API version compatibility
#if LIBRARY_VERSION >= VERSION_CHECK(2, 0, 0)
    #define NEW_API_AVAILABLE
    void new_api_function(void) {
        printf("Using new API\n");
    }
#endif

#if LIBRARY_VERSION >= VERSION_CHECK(2, 3, 0)
    #define ENHANCED_API_AVAILABLE
    void enhanced_api_function(void) {
        printf("Using enhanced API\n");
    }
#endif

// Backward compatibility
#if LIBRARY_VERSION < VERSION_CHECK(2, 0, 0)
    void new_api_function(void) {
        printf("Using legacy implementation\n");
    }
#endif

int main() {
    printf("Library version: %d.%d.%d\n", 
           LIBRARY_VERSION / 10000,
           (LIBRARY_VERSION % 10000) / 100,
           LIBRARY_VERSION % 100);
    
#ifdef NEW_API_AVAILABLE
    new_api_function();
#endif

#ifdef ENHANCED_API_AVAILABLE
    enhanced_api_function();
#endif
    
    return 0;
}
```

## Pragma Directives

Pragma directives provide compiler-specific instructions and hints that can optimize code generation and control compilation behavior.

### Common Pragma Directives

```c
#include <stdio.h>
#include <stdlib.h>

// Region folding (supported by many IDEs)
#pragma region Utility Functions

static inline int max(int a, int b) {
    return a > b ? a : b;
}

static inline int min(int a, int b) {
    return a < b ? a : b;
}

#pragma endregion

// Optimization hints
#pragma GCC push_options
#pragma GCC optimize("O3")

// Performance-critical function
double compute_pi(int iterations) {
    double pi = 0.0;
    double denominator = 1.0;
    
    for (int i = 0; i < iterations; i++) {
        if (i % 2 == 0) {
            pi += 4.0 / denominator;
        } else {
            pi -= 4.0 / denominator;
        }
        denominator += 2.0;
    }
    
    return pi;
}

#pragma GCC pop_options

// Warning control
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunused-variable"

void example_with_warnings(void) {
    int unused_var = 42;  // This warning is suppressed
    printf("Function with suppressed warnings\n");
}

#pragma GCC diagnostic pop

// Structure packing
#pragma pack(push, 1)
typedef struct {
    char a;      // 1 byte
    int b;       // 4 bytes (normally padded to offset 4)
    short c;     // 2 bytes (normally padded to offset 8)
} PackedStruct;  // Total size: 7 bytes instead of 12
#pragma pack(pop)

// Once-only inclusion (alternative to include guards)
#pragma once

// Message directives (compiler-specific)
#pragma message("Compiling with advanced preprocessor features")

int main() {
    printf("Max of 10 and 20: %d\n", max(10, 20));
    printf("Min of 10 and 20: %d\n", min(10, 20));
    
    double pi = compute_pi(1000000);
    printf("Computed PI: %.10f\n", pi);
    
    example_with_warnings();
    
    printf("Size of PackedStruct: %zu bytes\n", sizeof(PackedStruct));
    
    return 0;
}
```

### Compiler-Specific Pragmas

```c
#include <stdio.h>

// GCC-specific pragmas
#ifdef __GNUC__
    #pragma GCC diagnostic push
    #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    
    // Function inlining hints
    #pragma GCC push_options
    #pragma GCC optimize("inline-functions-called-once")
    
    static inline void optimized_function(void) {
        printf("This function may be inlined\n");
    }
    
    #pragma GCC pop_options
    #pragma GCC diagnostic pop
#endif

// MSVC-specific pragmas
#ifdef _MSC_VER
    #pragma warning(push)
    #pragma warning(disable: 4996)  // Disable deprecated function warnings
    
    // Function inlining
    #pragma inline_depth(255)
    #pragma inline_recursion(on)
    
    static __inline void msvc_optimized_function(void) {
        printf("MSVC optimized function\n");
    }
    
    #pragma warning(pop)
#endif

// Clang-specific pragmas
#ifdef __clang__
    #pragma clang diagnostic push
    #pragma clang diagnostic ignored "-Wdeprecated-declarations"
    
    // Loop optimization hints
    #pragma clang loop vectorize(enable)
    
    void clang_optimized_loop(int *array, int size) {
        for (int i = 0; i < size; i++) {
            array[i] *= 2;
        }
    }
    
    #pragma clang diagnostic pop
#endif

int main() {
#ifdef __GNUC__
    optimized_function();
#endif

#ifdef _MSC_VER
    msvc_optimized_function();
#endif

#ifdef __clang__
    int array[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    clang_optimized_loop(array, 10);
    printf("Array[0] after optimization: %d\n", array[0]);
#endif
    
    return 0;
}
```

## Predefined Macros

C provides numerous predefined macros that offer information about the compilation environment.

### System and Compiler Information

```c
#include <stdio.h>
#include <time.h>

void print_compilation_info(void) {
    printf("=== Compilation Information ===\n");
    
    // Standard version
    printf("Standard version: %ld\n", __STDC_VERSION__);
#ifdef __STDC_VERSION__
    #if __STDC_VERSION__ >= 202311L
        printf("C Standard: C23\n");
    #elif __STDC_VERSION__ >= 201112L
        printf("C Standard: C11\n");
    #elif __STDC_VERSION__ >= 199901L
        printf("C Standard: C99\n");
    #else
        printf("C Standard: C89/C90\n");
    #endif
#endif
    
    // Compiler information
#ifdef __GNUC__
    printf("Compiler: GCC %d.%d.%d\n", __GNUC__, __GNUC_MINOR__, __GNUC_PATCHLEVEL__);
#endif

#ifdef __clang__
    printf("Compiler: Clang %d.%d.%d\n", __clang_major__, __clang_minor__, __clang_patchlevel__);
#endif

#ifdef _MSC_VER
    printf("Compiler: MSVC %d\n", _MSC_VER);
#endif
    
    // Platform information
#ifdef __x86_64__
    printf("Architecture: x86_64\n");
#elif defined(__i386__)
    printf("Architecture: x86\n");
#elif defined(__aarch64__)
    printf("Architecture: ARM64\n");
#elif defined(__arm__)
    printf("Architecture: ARM\n");
#endif

#ifdef __LP64__
    printf("Data model: LP64\n");
#endif

    // Date and time
    printf("Compilation date: %s\n", __DATE__);
    printf("Compilation time: %s\n", __TIME__);
    
    // File and line information
    printf("Current file: %s\n", __FILE__);
    printf("Current line: %d\n", __LINE__);
    printf("Function name: %s\n", __func__);
    
    printf("\n");
}

// Using predefined macros for debugging
#ifdef DEBUG
    #define TRACE() printf("TRACE: %s() in %s:%d\n", __func__, __FILE__, __LINE__)
#else
    #define TRACE() do {} while(0)
#endif

void function_a(void) {
    TRACE();
    printf("Inside function_a\n");
}

void function_b(void) {
    TRACE();
    printf("Inside function_b\n");
    function_a();
}

int main() {
    print_compilation_info();
    
    function_b();
    
    // Counter macro (implementation-defined)
    printf("This is compilation #%d\n", __COUNTER__);
    printf("This is compilation #%d\n", __COUNTER__);
    
    return 0;
}
```

## Token Manipulation and Advanced Techniques

Advanced preprocessor techniques involve complex token manipulation and metaprogramming.

### Deferred Macro Expansion

```c
#include <stdio.h>

// Deferred expansion technique
#define EMPTY()
#define DEFER(id) id EMPTY()
#define OBSTRUCT(...) __VA_ARGS__ DEFER(EMPTY)()
#define EXPAND(...) __VA_ARGS__

#define EVAL(...) EVAL1(EVAL1(EVAL1(__VA_ARGS__)))
#define EVAL1(...) EVAL2(EVAL2(EVAL2(__VA_ARGS__)))
#define EVAL2(...) EVAL3(EVAL3(EVAL3(__VA_ARGS__)))
#define EVAL3(...) EVAL4(EVAL4(EVAL4(__VA_ARGS__)))
#define EVAL4(...) __VA_ARGS__

// Recursive macro example
#define WHEN(c) IF_##c
#define IF_1(t, f) t
#define IF_0(t, f) f

#define COMMA() ,
#define SEMICOLON() ;

#define REPEAT_0(f, ...)
#define REPEAT_1(f, x, ...) f(x) REPEAT_0(f, __VA_ARGS__)
#define REPEAT_2(f, x, ...) f(x) REPEAT_1(f, __VA_ARGS__)
#define REPEAT_3(f, x, ...) f(x) REPEAT_2(f, __VA_ARGS__)
#define REPEAT_4(f, x, ...) f(x) REPEAT_3(f, __VA_ARGS__)

#define REPEAT_N(n, f, ...) EVAL(REPEAT_##n(f, __VA_ARGS__))

#define PRINT_ARG(x) printf("%s = %d\n", #x, x);

int main() {
    int a = 1, b = 2, c = 3, d = 4;
    
    printf("Repeating PRINT_ARG macro:\n");
    REPEAT_N(4, PRINT_ARG, a, b, c, d)
    
    return 0;
}
```

### X-Macros Pattern

```c
#include <stdio.h>
#include <string.h>

// X-Macros for enumerations and string tables
#define COLOR_TABLE \
    X(RED, "red", 0xFF0000) \
    X(GREEN, "green", 0x00FF00) \
    X(BLUE, "blue", 0x0000FF) \
    X(YELLOW, "yellow", 0xFFFF00) \
    X(PURPLE, "purple", 0xFF00FF) \
    X(CYAN, "cyan", 0x00FFFF) \
    X(WHITE, "white", 0xFFFFFF) \
    X(BLACK, "black", 0x000000)

// Generate enumeration
#define X(name, string, value) COLOR_##name,
typedef enum {
    COLOR_TABLE
    COLOR_COUNT
} Color;
#undef X

// Generate string array
#define X(name, string, value) string,
static const char *color_strings[] = {
    COLOR_TABLE
};
#undef X

// Generate value array
#define X(name, string, value) value,
static const int color_values[] = {
    COLOR_TABLE
};
#undef X

// Generate function to get string
const char *color_to_string(Color color) {
    if (color >= 0 && color < COLOR_COUNT) {
        return color_strings[color];
    }
    return "unknown";
}

// Generate function to get value
int color_to_value(Color color) {
    if (color >= 0 && color < COLOR_COUNT) {
        return color_values[color];
    }
    return 0;
}

// Generate lookup function
Color string_to_color(const char *str) {
    for (int i = 0; i < COLOR_COUNT; i++) {
        if (strcmp(str, color_strings[i]) == 0) {
            return (Color)i;
        }
    }
    return COLOR_COUNT;  // Invalid color
}

int main() {
    printf("Color enumeration:\n");
    for (int i = 0; i < COLOR_COUNT; i++) {
        printf("  %d: %s (0x%06X)\n", i, color_to_string((Color)i), color_to_value((Color)i));
    }
    
    printf("\nString to color lookup:\n");
    const char *test_colors[] = {"red", "blue", "purple", "invalid"};
    for (int i = 0; i < 4; i++) {
        Color c = string_to_color(test_colors[i]);
        if (c < COLOR_COUNT) {
            printf("  %s -> %s (0x%06X)\n", test_colors[i], color_to_string(c), color_to_value(c));
        } else {
            printf("  %s -> invalid color\n", test_colors[i]);
        }
    }
    
    return 0;
}
```

## C23 Enhanced Preprocessor Features

C23 introduces several new preprocessor features that enhance metaprogramming capabilities.

### #elifdef and #elifndef

```c
#include <stdio.h>

// Define some macros for testing
#define DEBUG_MODE
// #define RELEASE_MODE
// #define TESTING_MODE

int main() {
    printf("Preprocessor conditional compilation:\n");
    
#if defined(DEBUG_MODE)
    printf("  Debug mode is enabled\n");
#elifdef RELEASE_MODE
    printf("  Release mode is enabled\n");
#elifndef TESTING_MODE
    printf("  Testing mode is not defined\n");
#else
    printf("  Unknown mode\n");
#endif
    
    return 0;
}
```

### #warning Directive

```c
#include <stdio.h>

// Compiler version check
#if __STDC_VERSION__ < 202311L
    #warning "This code is designed for C23 or later"
#endif

// Platform-specific warnings
#ifdef __APPLE__
    #warning "This code may need adjustments for macOS"
#endif

// Feature availability warnings
#ifndef __STDC_LIB_EXT1__
    #warning "Bounds-checking functions not available"
#endif

int main() {
    printf("Program running with warnings (if any)\n");
    
#ifdef __GNUC__
    #warning "Consider using Clang for better C23 support"
#endif
    
    return 0;
}
```

### Digit Separators in Preprocessor

```c
#include <stdio.h>

// Using digit separators in preprocessor expressions
#define ONE_MILLION 1'000'000
#define MAX_BUFFER_SIZE 10'000
#define BINARY_PATTERN 0b1010'0101'1100'1111

int main() {
    printf("One million: %d\n", ONE_MILLION);
    printf("Max buffer size: %d\n", MAX_BUFFER_SIZE);
    printf("Binary pattern: 0x%X\n", BINARY_PATTERN);
    
    // Using in preprocessor conditionals
#if ONE_MILLION > 500'000
    printf("One million is greater than 500 thousand\n");
#endif
    
    return 0;
}
```

## Practical Examples

### Configuration System Using Preprocessor

```c
#include <stdio.h>

// Configuration system using preprocessor
// Define default values
#ifndef CONFIG_MAX_CONNECTIONS
    #define CONFIG_MAX_CONNECTIONS 100
#endif

#ifndef CONFIG_TIMEOUT
    #define CONFIG_TIMEOUT 30
#endif

#ifndef CONFIG_LOG_LEVEL
    #define CONFIG_LOG_LEVEL 2
#endif

// Feature flags
#define FEATURE_NETWORKING 1
#define FEATURE_DATABASE 1
#define FEATURE_SECURITY 0

// Platform-specific configurations
#ifdef _WIN32
    #define PATH_SEPARATOR '\\'
    #define DEFAULT_CONFIG_FILE "config.ini"
#else
    #define PATH_SEPARATOR '/'
    #define DEFAULT_CONFIG_FILE "/etc/myapp/config.ini"
#endif

// Debug configuration
#ifdef DEBUG
    #define LOG_LEVEL CONFIG_LOG_LEVEL
    #define ENABLE_ASSERTIONS 1
    #define VERBOSE_LOGGING 1
#else
    #define LOG_LEVEL (CONFIG_LOG_LEVEL - 1)
    #define ENABLE_ASSERTIONS 0
    #define VERBOSE_LOGGING 0
#endif

// Conditional compilation based on features
#if FEATURE_NETWORKING
    #include <sys/socket.h>
    #define NETWORK_BUFFER_SIZE 8192
    
    void init_networking(void) {
        printf("Networking initialized with buffer size: %d\n", NETWORK_BUFFER_SIZE);
    }
#else
    void init_networking(void) {
        printf("Networking disabled\n");
    }
#endif

#if FEATURE_DATABASE
    #include <sqlite3.h>
    #define DB_CONNECTION_POOL_SIZE 10
    
    void init_database(void) {
        printf("Database initialized with connection pool size: %d\n", DB_CONNECTION_POOL_SIZE);
    }
#else
    void init_database(void) {
        printf("Database disabled\n");
    }
#endif

#if FEATURE_SECURITY
    #include <openssl/ssl.h>
    #define SSL_ENABLED 1
    
    void init_security(void) {
        printf("Security initialized with SSL enabled\n");
    }
#else
    #define SSL_ENABLED 0
    void init_security(void) {
        printf("Security disabled\n");
    }
#endif

void print_configuration(void) {
    printf("=== Application Configuration ===\n");
    printf("Max connections: %d\n", CONFIG_MAX_CONNECTIONS);
    printf("Timeout: %d seconds\n", CONFIG_TIMEOUT);
    printf("Log level: %d\n", LOG_LEVEL);
    printf("Path separator: '%c'\n", PATH_SEPARATOR);
    printf("Default config file: %s\n", DEFAULT_CONFIG_FILE);
    printf("Assertions: %s\n", ENABLE_ASSERTIONS ? "enabled" : "disabled");
    printf("Verbose logging: %s\n", VERBOSE_LOGGING ? "enabled" : "disabled");
    printf("\n");
    
    printf("=== Feature Status ===\n");
    printf("Networking: %s\n", FEATURE_NETWORKING ? "enabled" : "disabled");
    printf("Database: %s\n", FEATURE_DATABASE ? "enabled" : "disabled");
    printf("Security: %s\n", FEATURE_SECURITY ? "enabled" : "disabled");
    printf("SSL: %s\n", SSL_ENABLED ? "enabled" : "disabled");
    printf("\n");
}

int main() {
    print_configuration();
    
    init_networking();
    init_database();
    init_security();
    
    return 0;
}
```

### Advanced Error Handling with Preprocessor

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

// Advanced error handling macros
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

// Error checking with automatic cleanup
#define CHECK_ERRNO(call) do { \
    errno = 0; \
    call; \
    if (errno != 0) { \
        fprintf(stderr, "Error in %s at %s:%d: %s\n", \
                #call, __FILE__, __LINE__, strerror(errno)); \
        exit(EXIT_FAILURE); \
    } \
} while(0)

// Resource management with automatic cleanup
#define CLEANUP_VAR(type, name, cleanup_func) \
    type name = NULL; \
    defer_cleanup(cleanup_func, &name)

// Defer mechanism (simplified)
typedef struct defer_node {
    void (*func)(void*);
    void *arg;
    struct defer_node *next;
} defer_node_t;

static defer_node_t *defer_stack = NULL;

void defer_cleanup(void (*func)(void*), void *arg) {
    defer_node_t *node = malloc(sizeof(defer_node_t));
    node->func = func;
    node->arg = arg;
    node->next = defer_stack;
    defer_stack = node;
}

void execute_deferred(void) {
    while (defer_stack) {
        defer_node_t *node = defer_stack;
        defer_stack = node->next;
        node->func(node->arg);
        free(node);
    }
}

#define defer(func, arg) defer_cleanup(func, arg)

// Cleanup functions
void free_ptr(void *ptr) {
    free(*(void**)ptr);
}

void fclose_ptr(void *ptr) {
    if (*(FILE**)ptr) {
        fclose(*(FILE**)ptr);
    }
}

int main() {
    printf("Advanced error handling with preprocessor\n");
    
    // File operations with automatic error checking
    CLEANUP_VAR(FILE*, fp, fclose_ptr);
    fp = fopen("test.txt", "w");
    if (!fp) {
        perror("fopen");
        exit(EXIT_FAILURE);
    }
    
    CHECK_ERRNO(fprintf(fp, "Hello, World!\n"));
    CHECK_ERRNO(fflush(fp));
    
    // Memory allocation with automatic cleanup
    CLEANUP_VAR(char*, buffer, free_ptr);
    buffer = malloc(100);
    if (!buffer) {
        fprintf(stderr, "Memory allocation failed\n");
        exit(EXIT_FAILURE);
    }
    
    strcpy(buffer, "This is a test buffer");
    printf("Buffer content: %s\n", buffer);
    
    // Automatic cleanup when scope ends
    execute_deferred();
    
    return 0;
}
```

## Summary

Advanced preprocessor techniques provide powerful metaprogramming capabilities in C:

1. **Macro Definitions**: Stringification, token pasting, variadic macros, and generic programming
2. **Conditional Compilation**: Platform-specific code, feature toggles, and version compatibility
3. **Pragma Directives**: Compiler hints, optimization control, and warning management
4. **Predefined Macros**: System information, compilation context, and debugging support
5. **Token Manipulation**: Deferred expansion, X-Macros, and complex metaprogramming
6. **C23 Enhancements**: Improved conditional directives and digit separators

Mastering these advanced preprocessor techniques enables C developers to write more maintainable, efficient, and feature-rich code while leveraging the full power of the C preprocessor for metaprogramming and code generation.