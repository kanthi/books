# Fundamental Data Types

## Introduction

Data types are the foundation of any programming language, defining the kind of values that can be stored and manipulated in a program. In C, data types determine the size and layout of variables in memory, the range of values they can hold, and the operations that can be performed on them.

Understanding C's fundamental data types is crucial for writing efficient, correct, and portable code. This chapter will explore all the basic data types in C, from the smallest `char` to the largest integer and floating-point types.

## Basic Data Types in C

C provides several fundamental data types that can be categorized into:

1. **Integer Types**: For storing whole numbers
2. **Floating-Point Types**: For storing real numbers with decimal points
3. **Character Types**: For storing single characters
4. **Boolean Types**: For storing true/false values (C99+)

## Integer Types

Integer types are used to store whole numbers (positive, negative, or zero) without fractional components.

### Basic Integer Types

| Type | Size (typical) | Range (typical) | Description |
|------|----------------|-----------------|-------------|
| `char` | 1 byte | -128 to 127 | Character or small integer |
| `short` | 2 bytes | -32,768 to 32,767 | Short integer |
| `int` | 4 bytes | -2,147,483,648 to 2,147,483,647 | Standard integer |
| `long` | 4 or 8 bytes | Varies | Long integer |
| `long long` | 8 bytes | -(2^63) to (2^63)-1 | Long long integer (C99) |

### Unsigned Integer Types

Unsigned integers can only store non-negative values (zero or positive) but have a larger positive range:

| Type | Size (typical) | Range (typical) | Description |
|------|----------------|-----------------|-------------|
| `unsigned char` | 1 byte | 0 to 255 | Unsigned character |
| `unsigned short` | 2 bytes | 0 to 65,535 | Unsigned short integer |
| `unsigned int` | 4 bytes | 0 to 4,294,967,295 | Unsigned standard integer |
| `unsigned long` | 4 or 8 bytes | Varies | Unsigned long integer |
| `unsigned long long` | 8 bytes | 0 to (2^64)-1 | Unsigned long long integer (C99) |

### Size and Limits

The actual size of integer types can vary depending on the system architecture and compiler. To determine the exact sizes and limits on your system, you can use the `limits.h` header:

```c
#include <stdio.h>
#include <limits.h>

int main() {
    printf("Size of char: %zu bytes\n", sizeof(char));
    printf("Size of short: %zu bytes\n", sizeof(short));
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of long: %zu bytes\n", sizeof(long));
    printf("Size of long long: %zu bytes\n", sizeof(long long));
    
    printf("\nCHAR_MIN: %d\n", CHAR_MIN);
    printf("CHAR_MAX: %d\n", CHAR_MAX);
    printf("SHRT_MIN: %d\n", SHRT_MIN);
    printf("SHRT_MAX: %d\n", SHRT_MAX);
    printf("INT_MIN: %d\n", INT_MIN);
    printf("INT_MAX: %d\n", INT_MAX);
    printf("LONG_MIN: %ld\n", LONG_MIN);
    printf("LONG_MAX: %ld\n", LONG_MAX);
    printf("LLONG_MIN: %lld\n", LLONG_MIN);
    printf("LLONG_MAX: %lld\n", LLONG_MAX);
    
    return 0;
}
```

## Floating-Point Types

Floating-point types are used to store real numbers with fractional components.

### Basic Floating-Point Types

| Type | Size (typical) | Precision | Range | Description |
|------|----------------|-----------|-------|-------------|
| `float` | 4 bytes | 6-7 decimal digits | ±3.4×10^38 | Single precision |
| `double` | 8 bytes | 15-16 decimal digits | ±1.7×10^308 | Double precision |
| `long double` | 10-16 bytes | Extended precision | Extended range | Extended precision |

### Floating-Point Limits

To determine the exact characteristics of floating-point types on your system, use the `float.h` header:

```c
#include <stdio.h>
#include <float.h>

int main() {
    printf("Size of float: %zu bytes\n", sizeof(float));
    printf("Size of double: %zu bytes\n", sizeof(double));
    printf("Size of long double: %zu bytes\n", sizeof(long double));
    
    printf("\nFLT_DIG: %d\n", FLT_DIG);
    printf("DBL_DIG: %d\n", DBL_DIG);
    printf("LDBL_DIG: %d\n", LDBL_DIG);
    
    printf("FLT_MIN: %e\n", FLT_MIN);
    printf("FLT_MAX: %e\n", FLT_MAX);
    printf("DBL_MIN: %e\n", DBL_MIN);
    printf("DBL_MAX: %e\n", DBL_MAX);
    
    return 0;
}
```

## Character Types

The `char` type is used to store single characters, but it's fundamentally an integer type that stores ASCII values.

### Basic Character Type

```c
#include <stdio.h>

int main() {
    char letter = 'A';
    char number = 65;  // ASCII value of 'A'
    
    printf("Letter: %c\n", letter);
    printf("Number: %d\n", letter);
    printf("Same as: %c\n", number);
    
    return 0;
}
```

### Signed vs Unsigned Char

The `char` type can be either signed or unsigned, depending on the implementation:

```c
#include <stdio.h>

int main() {
    signed char s_char = -1;
    unsigned char u_char = 255;
    
    printf("Signed char: %d\n", s_char);
    printf("Unsigned char: %u\n", u_char);
    
    return 0;
}
```

## Boolean Type (C99+)

C99 introduced the `_Bool` type for boolean values, and C99+ provides the `bool` type through the `stdbool.h` header.

### Using _Bool

```c
#include <stdio.h>

int main() {
    _Bool is_complete = 1;
    _Bool is_valid = 0;
    
    printf("is_complete: %d\n", is_complete);
    printf("is_valid: %d\n", is_valid);
    
    return 0;
}
```

### Using stdbool.h

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    bool is_complete = true;
    bool is_valid = false;
    
    printf("is_complete: %d\n", is_complete);
    printf("is_valid: %d\n", is_valid);
    
    if (is_complete) {
        printf("Task is complete!\n");
    }
    
    return 0;
}
```

## Fixed-Width Integer Types (C99+)

To ensure portability across different systems, C99 introduced fixed-width integer types in the `stdint.h` header:

### Exact Width Types

| Type | Bits | Range |
|------|------|-------|
| `int8_t` | 8 | -128 to 127 |
| `int16_t` | 16 | -32,768 to 32,767 |
| `int32_t` | 32 | -2,147,483,648 to 2,147,483,647 |
| `int64_t` | 64 | -(2^63) to (2^63)-1 |
| `uint8_t` | 8 | 0 to 255 |
| `uint16_t` | 16 | 0 to 65,535 |
| `uint32_t` | 32 | 0 to 4,294,967,295 |
| `uint64_t` | 64 | 0 to (2^64)-1 |

### Minimum Width Types

| Type | Minimum Bits |
|------|--------------|
| `int_least8_t` | 8 |
| `int_least16_t` | 16 |
| `int_least32_t` | 32 |
| `int_least64_t` | 64 |

### Fastest Minimum Width Types

| Type | Minimum Bits |
|------|--------------|
| `int_fast8_t` | 8 |
| `int_fast16_t` | 16 |
| `int_fast32_t` | 32 |
| `int_fast64_t` | 64 |

### Example Usage

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    int32_t id = 123456789;
    uint16_t age = 25;
    int8_t score = -5;
    
    printf("ID: %" PRId32 "\n", id);
    printf("Age: %" PRIu16 "\n", age);
    printf("Score: %" PRId8 "\n", score);
    
    return 0;
}
```

## Size-Specific Integer Types

The `stdint.h` header also provides types that match the size of pointers and the maximum values:

### Pointer-Sized Types

| Type | Description |
|------|-------------|
| `intptr_t` | Signed integer type capable of holding a pointer |
| `uintptr_t` | Unsigned integer type capable of holding a pointer |

### Maximum Value Types

| Type | Description |
|------|-------------|
| `intmax_t` | Maximum width signed integer type |
| `uintmax_t` | Maximum width unsigned integer type |

## Type Specifiers and Qualifiers

C provides several type specifiers and qualifiers to modify data types:

### Type Specifiers

| Specifier | Description |
|-----------|-------------|
| `signed` | Explicitly signed type |
| `unsigned` | Unsigned type |
| `long` | Long integer or double |
| `short` | Short integer |
| `long long` | Long long integer (C99) |

### Type Qualifiers

| Qualifier | Description |
|-----------|-------------|
| `const` | Constant value (cannot be modified) |
| `volatile` | Value may change unexpectedly |
| `restrict` | Pointer with no aliasing (C99) |

### Examples

```c
#include <stdio.h>

int main() {
    const int max_size = 100;
    volatile int sensor_value;
    long long big_number = 123456789012345LL;
    unsigned short port = 8080;
    
    printf("Max size: %d\n", max_size);
    printf("Big number: %lld\n", big_number);
    printf("Port: %hu\n", port);
    
    return 0;
}
```

## sizeof Operator

The `sizeof` operator returns the size (in bytes) of a data type or variable:

```c
#include <stdio.h>

int main() {
    printf("Size of char: %zu bytes\n", sizeof(char));
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of float: %zu bytes\n", sizeof(float));
    printf("Size of double: %zu bytes\n", sizeof(double));
    printf("Size of long long: %zu bytes\n", sizeof(long long));
    
    int number = 42;
    printf("Size of variable 'number': %zu bytes\n", sizeof(number));
    printf("Size of int: %zu bytes\n", sizeof number);  // Parentheses optional for variables
    
    return 0;
}
```

## Type Conversion and Promotion

C automatically performs type conversions in expressions:

### Integer Promotion

```c
#include <stdio.h>

int main() {
    char c = 'A';
    int i = c;  // char is promoted to int
    
    printf("Character: %c\n", c);
    printf("ASCII value: %d\n", i);
    
    return 0;
}
```

### Usual Arithmetic Conversions

```c
#include <stdio.h>

int main() {
    int i = 10;
    float f = 3.14f;
    double d = i + f;  // int is converted to float, then to double
    
    printf("Result: %f\n", d);
    
    return 0;
}
```

## Practical Examples

### Memory Calculator

```c
#include <stdio.h>
#include <stdint.h>

int main() {
    printf("=== Memory Requirements Calculator ===\n");
    
    size_t char_size = sizeof(char);
    size_t int_size = sizeof(int);
    size_t float_size = sizeof(float);
    size_t double_size = sizeof(double);
    size_t pointer_size = sizeof(void*);
    
    printf("char: %zu byte(s)\n", char_size);
    printf("int: %zu byte(s)\n", int_size);
    printf("float: %zu byte(s)\n", float_size);
    printf("double: %zu byte(s)\n", double_size);
    printf("pointer: %zu byte(s)\n", pointer_size);
    
    // Calculate memory for arrays
    int array_size = 1000;
    printf("\nMemory for %d elements:\n", array_size);
    printf("char array: %zu bytes\n", array_size * sizeof(char));
    printf("int array: %zu bytes\n", array_size * sizeof(int));
    printf("float array: %zu bytes\n", array_size * sizeof(float));
    printf("double array: %zu bytes\n", array_size * sizeof(double));
    
    return 0;
}
```

### Data Type Limits Explorer

```c
#include <stdio.h>
#include <limits.h>
#include <float.h>

int main() {
    printf("=== Data Type Limits Explorer ===\n\n");
    
    // Integer limits
    printf("Integer Limits:\n");
    printf("CHAR_MIN: %d\n", CHAR_MIN);
    printf("CHAR_MAX: %d\n", CHAR_MAX);
    printf("SHRT_MIN: %d\n", SHRT_MIN);
    printf("SHRT_MAX: %d\n", SHRT_MAX);
    printf("INT_MIN: %d\n", INT_MIN);
    printf("INT_MAX: %d\n", INT_MAX);
    printf("LONG_MIN: %ld\n", LONG_MIN);
    printf("LONG_MAX: %ld\n", LONG_MAX);
    printf("LLONG_MIN: %lld\n", LLONG_MIN);
    printf("LLONG_MAX: %lld\n", LLONG_MAX);
    
    // Unsigned integer limits
    printf("\nUnsigned Integer Limits:\n");
    printf("UCHAR_MAX: %u\n", UCHAR_MAX);
    printf("USHRT_MAX: %u\n", USHRT_MAX);
    printf("UINT_MAX: %u\n", UINT_MAX);
    printf("ULONG_MAX: %lu\n", ULONG_MAX);
    printf("ULLONG_MAX: %llu\n", ULLONG_MAX);
    
    // Floating-point limits
    printf("\nFloating-Point Limits:\n");
    printf("FLT_MIN: %e\n", FLT_MIN);
    printf("FLT_MAX: %e\n", FLT_MAX);
    printf("DBL_MIN: %e\n", DBL_MIN);
    printf("DBL_MAX: %e\n", DBL_MAX);
    
    return 0;
}
```

## Best Practices

### 1. Use Fixed-Width Types for Portability
```c
#include <stdint.h>
// Use int32_t instead of int when you need exactly 32 bits
int32_t user_id = 12345;
```

### 2. Check System Limits
```c
#include <limits.h>
if (value > INT_MAX) {
    printf("Value exceeds integer maximum!\n");
}
```

### 3. Use Appropriate Format Specifiers
```c
#include <inttypes.h>
int32_t number = 123456789;
printf("Number: %" PRId32 "\n", number);
```

### 4. Be Aware of Overflow
```c
#include <limits.h>
int result;
if (a > INT_MAX - b) {
    printf("Addition would overflow!\n");
} else {
    result = a + b;
}
```

## Summary

In this chapter, you've learned about:

1. **Integer Types**: char, short, int, long, long long and their unsigned variants
2. **Floating-Point Types**: float, double, long double
3. **Character Types**: char and its signed/unsigned variations
4. **Boolean Types**: _Bool and bool (with stdbool.h)
5. **Fixed-Width Types**: int8_t, int16_t, int32_t, int64_t and their unsigned counterparts
6. **Type Specifiers and Qualifiers**: signed, unsigned, const, volatile, restrict
7. **sizeof Operator**: Determining memory requirements
8. **Type Conversion**: Automatic promotions and conversions

Understanding these fundamental data types is essential for writing efficient C programs. In the next chapter, we'll explore variables and constants in detail, showing you how to declare, initialize, and use these data types effectively in your programs.