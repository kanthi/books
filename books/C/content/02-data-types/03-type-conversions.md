# Type Conversions

## Introduction

Type conversion, also known as type casting, is the process of converting a value from one data type to another. C provides both implicit (automatic) and explicit (manual) type conversion mechanisms. Understanding how type conversions work is crucial for writing correct and efficient C programs, as improper conversions can lead to unexpected behavior, data loss, or undefined results.

This chapter will explore both implicit and explicit type conversions, their rules, potential pitfalls, and best practices for safe conversions.

## Implicit Type Conversions (Coercion)

Implicit type conversions occur automatically when the compiler converts one data type to another without explicit programmer intervention. These conversions follow specific rules to ensure data integrity while maintaining program functionality.

### Usual Arithmetic Conversions

When operators are applied to operands of different types, C performs usual arithmetic conversions to bring them to a common type:

```c
#include <stdio.h>

int main() {
    int i = 10;
    float f = 3.14f;
    double d = 2.5;
    
    // int + float -> float
    float result1 = i + f;
    printf("int + float = %.2f (float)\n", result1);
    
    // float + double -> double
    double result2 = f + d;
    printf("float + double = %.2f (double)\n", result2);
    
    // int + double -> double
    double result3 = i + d;
    printf("int + double = %.2f (double)\n", result3);
    
    return 0;
}
```

### Integer Promotion

Integer promotion is the automatic conversion of smaller integer types to `int` or `unsigned int`:

```c
#include <stdio.h>

int main() {
    char c = 'A';
    short s = 100;
    
    // char and short are promoted to int in expressions
    int result = c + s;
    printf("char + short = %d (int)\n", result);
    
    // Promotion also happens with unary operators
    int negated = -c;
    printf("Negated char: %d\n", negated);
    
    return 0;
}
```

### Conversion Hierarchy

C follows a specific hierarchy for implicit conversions:

1. **long double** (highest)
2. **double**
3. **float**
4. **unsigned long long**
5. **long long**
6. **unsigned long**
7. **long**
8. **unsigned int**
9. **int** (lowest)

When operands of different types are used together, the lower type is converted to the higher type:

```c
#include <stdio.h>

int main() {
    char c = 'X';
    short s = 1000;
    int i = 50000;
    float f = 3.14f;
    double d = 2.71828;
    
    // All converted to double
    double result = c + s + i + f + d;
    printf("Mixed arithmetic result: %.5f\n", result);
    
    return 0;
}
```

### Boolean Context Conversions

In conditional expressions, all scalar types are implicitly converted to boolean values:

```c
#include <stdio.h>

int main() {
    int number = 42;
    float zero_float = 0.0f;
    char letter = 'A';
    char null_char = '\0';
    
    // Non-zero values are true, zero values are false
    if (number) {
        printf("Number %d is true\n", number);
    }
    
    if (!zero_float) {
        printf("Zero float is false\n");
    }
    
    if (letter) {
        printf("Character '%c' is true\n", letter);
    }
    
    if (!null_char) {
        printf("Null character is false\n");
    }
    
    return 0;
}
```

## Explicit Type Conversions (Casting)

Explicit type conversions, or casting, allow programmers to manually convert values from one type to another using cast operators.

### Cast Operator Syntax

The cast operator has the form `(type)` where `type` is the target data type:

```c
#include <stdio.h>

int main() {
    double pi = 3.14159;
    int integer_pi = (int)pi;  // Cast double to int
    
    printf("Original: %.5f\n", pi);
    printf("Casted: %d\n", integer_pi);
    
    return 0;
}
```

### Common Casting Scenarios

#### Floating-Point to Integer
```c
#include <stdio.h>

int main() {
    float temperature = 98.6f;
    int temp_int = (int)temperature;
    
    printf("Float temperature: %.1f\n", temperature);
    printf("Integer temperature: %d\n", temp_int);
    
    // Note: Truncation, not rounding
    float negative = -3.7f;
    int neg_int = (int)negative;
    printf("Negative float: %.1f -> int: %d\n", negative, neg_int);
    
    return 0;
}
```

#### Integer to Floating-Point
```c
#include <stdio.h>

int main() {
    int total = 100;
    int count = 3;
    
    // Without casting, integer division occurs
    float average_int_div = total / count;
    printf("Integer division: %d / %d = %.1f\n", total, count, average_int_div);
    
    // With casting, floating-point division occurs
    float average_float_div = (float)total / count;
    printf("Float division: %.1f / %d = %.2f\n", (float)total, count, average_float_div);
    
    return 0;
}
```

#### Character to Integer and Vice Versa
```c
#include <stdio.h>

int main() {
    char letter = 'A';
    int ascii_value = (int)letter;
    
    printf("Character: %c\n", letter);
    printf("ASCII value: %d\n", ascii_value);
    
    int number = 66;
    char character = (char)number;
    printf("Number: %d\n", number);
    printf("Character: %c\n", character);
    
    return 0;
}
```

### Pointer Casting

C allows casting between different pointer types:

```c
#include <stdio.h>

int main() {
    int number = 42;
    int *int_ptr = &number;
    
    // Cast int pointer to void pointer
    void *void_ptr = (void*)int_ptr;
    
    // Cast void pointer back to int pointer
    int *new_int_ptr = (int*)void_ptr;
    
    printf("Original number: %d\n", number);
    printf("Via pointer: %d\n", *new_int_ptr);
    
    return 0;
}
```

## Potential Pitfalls and Data Loss

### Truncation
```c
#include <stdio.h>

int main() {
    double large_number = 12345.6789;
    int truncated = (int)large_number;
    
    printf("Original: %.4f\n", large_number);
    printf("Truncated: %d\n", truncated);
    
    return 0;
}
```

### Overflow
```c
#include <stdio.h>
#include <limits.h>

int main() {
    long long big_number = 3000000000LL;  // Larger than INT_MAX
    int overflowed = (int)big_number;
    
    printf("Big number: %lld\n", big_number);
    printf("Overflowed: %d\n", overflowed);  // Undefined behavior
    
    return 0;
}
```

### Precision Loss
```c
#include <stdio.h>

int main() {
    float precise = 0.1f;
    double more_precise = 0.1;
    
    printf("Float: %.20f\n", precise);
    printf("Double: %.20f\n", more_precise);
    
    // Converting double to float loses precision
    float less_precise = (float)more_precise;
    printf("Casted double: %.20f\n", less_precise);
    
    return 0;
}
```

## Safe Conversion Practices

### Checking for Overflow
```c
#include <stdio.h>
#include <limits.h>

int safe_int_cast(long long value) {
    if (value > INT_MAX || value < INT_MIN) {
        printf("Warning: Value %lld cannot fit in int\n", value);
        return (value > 0) ? INT_MAX : INT_MIN;
    }
    return (int)value;
}

int main() {
    long long big_value = 3000000000LL;
    int safe_value = safe_int_cast(big_value);
    
    printf("Safe value: %d\n", safe_value);
    
    return 0;
}
```

### Using Standard Library Functions
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    char number_str[] = "12345";
    long parsed_number = strtol(number_str, NULL, 10);
    
    printf("String: %s\n", number_str);
    printf("Parsed long: %ld\n", parsed_number);
    
    // Safe conversion with range checking
    if (parsed_number <= INT_MAX && parsed_number >= INT_MIN) {
        int converted = (int)parsed_number;
        printf("Converted to int: %d\n", converted);
    } else {
        printf("Number too large for int\n");
    }
    
    return 0;
}
```

## Conversion Functions

### Mathematical Conversions
```c
#include <stdio.h>
#include <math.h>

int main() {
    double value = -3.7;
    
    printf("Original: %.1f\n", value);
    printf("Floor: %.1f\n", floor(value));    // Round down
    printf("Ceil: %.1f\n", ceil(value));     // Round up
    printf("Truncate: %.1f\n", trunc(value)); // Truncate towards zero
    printf("Round: %.1f\n", round(value));   // Round to nearest
    
    return 0;
}
```

### String Conversions
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // String to integer
    char int_str[] = "123";
    int int_val = atoi(int_str);
    printf("atoi(\"%s\") = %d\n", int_str, int_val);
    
    // String to long
    char long_str[] = "123456789";
    long long_val = atol(long_str);
    printf("atol(\"%s\") = %ld\n", long_str, long_val);
    
    // String to double
    char double_str[] = "3.14159";
    double double_val = atof(double_str);
    printf("atof(\"%s\") = %.5f\n", double_str, double_val);
    
    // More robust conversions with error checking
    char *endptr;
    long strtol_val = strtol("456abc", &endptr, 10);
    printf("strtol(\"456abc\") = %ld, stopped at: %s\n", strtol_val, endptr);
    
    return 0;
}
```

## Practical Examples

### Temperature Converter with Type Safety
```c
#include <stdio.h>

// Safe conversion from Fahrenheit to Celsius
double fahrenheit_to_celsius(double fahrenheit) {
    return (fahrenheit - 32.0) * 5.0 / 9.0;
}

// Safe conversion from Celsius to Fahrenheit
double celsius_to_fahrenheit(double celsius) {
    return (celsius * 9.0 / 5.0) + 32.0;
}

int main() {
    float user_input;
    int choice;
    
    printf("Temperature Converter\n");
    printf("1. Fahrenheit to Celsius\n");
    printf("2. Celsius to Fahrenheit\n");
    printf("Enter choice: ");
    scanf("%d", &choice);
    
    if (choice == 1) {
        printf("Enter temperature in Fahrenheit: ");
        scanf("%f", &user_input);
        double result = fahrenheit_to_celsius((double)user_input);
        printf("%.2f°F = %.2f°C\n", user_input, result);
    } else if (choice == 2) {
        printf("Enter temperature in Celsius: ");
        scanf("%f", &user_input);
        double result = celsius_to_fahrenheit((double)user_input);
        printf("%.2f°C = %.2f°F\n", user_input, result);
    } else {
        printf("Invalid choice\n");
    }
    
    return 0;
}
```

### Data Type Range Checker
```c
#include <stdio.h>
#include <limits.h>
#include <float.h>

void check_int_range(long long value) {
    printf("Checking value: %lld\n", value);
    
    if (value > INT_MAX) {
        printf("  Too large for int (max: %d)\n", INT_MAX);
    } else if (value < INT_MIN) {
        printf("  Too small for int (min: %d)\n", INT_MIN);
    } else {
        printf("  Fits in int range\n");
        int converted = (int)value;
        printf("  Converted value: %d\n", converted);
    }
    printf("\n");
}

int main() {
    long long test_values[] = {
        100LL,
        3000000000LL,
        -3000000000LL,
        INT_MAX,
        INT_MIN,
        (long long)INT_MAX + 1,
        (long long)INT_MIN - 1
    };
    
    int num_tests = sizeof(test_values) / sizeof(test_values[0]);
    
    for (int i = 0; i < num_tests; i++) {
        check_int_range(test_values[i]);
    }
    
    return 0;
}
```

### Mixed Type Calculator
```c
#include <stdio.h>

int main() {
    int int_val = 10;
    float float_val = 3.14f;
    double double_val = 2.71828;
    char char_val = 'A';  // ASCII 65
    
    printf("=== Mixed Type Arithmetic ===\n");
    printf("int: %d\n", int_val);
    printf("float: %.2f\n", float_val);
    printf("double: %.5f\n", double_val);
    printf("char: %c (ASCII: %d)\n", char_val, char_val);
    printf("\n");
    
    // Various combinations
    printf("int + char: %d + %d = %d\n", int_val, char_val, int_val + char_val);
    printf("float + int: %.2f + %d = %.2f\n", float_val, int_val, float_val + int_val);
    printf("double + float: %.5f + %.2f = %.5f\n", double_val, float_val, double_val + float_val);
    printf("char + double: %d + %.5f = %.5f\n", char_val, double_val, char_val + double_val);
    
    // Explicit casting examples
    printf("\n=== Explicit Casting ===\n");
    printf("double to int: (int)%.5f = %d\n", double_val, (int)double_val);
    printf("int to float: (float)%d = %.1f\n", int_val, (float)int_val);
    printf("float to char: (char)%.2f = %c\n", float_val, (char)float_val);
    
    return 0;
}
```

## Best Practices

### 1. Be Explicit About Conversions
```c
// Good: Clear intent
float average = (float)total / count;

// Less clear: Relies on implicit conversion
float average = total / (float)count;
```

### 2. Check for Data Loss
```c
// Good: Range checking
if (big_value <= INT_MAX && big_value >= INT_MIN) {
    int small_value = (int)big_value;
}
```

### 3. Use Appropriate Functions for String Conversion
```c
// Good: Error checking with strtol
char *endptr;
long value = strtol(string, &endptr, 10);
if (*endptr != '\0') {
    printf("Invalid number format\n");
}
```

### 4. Understand Truncation vs Rounding
```c
#include <math.h>
// For truncation (default casting)
int truncated = (int)3.7;  // Results in 3

// For proper rounding
int rounded = (int)round(3.7);  // Results in 4
```

### 5. Be Careful with Signed/Unsigned Conversions
```c
// Dangerous conversion
unsigned int u_value = 4000000000U;
int s_value = (int)u_value;  // Implementation-defined behavior
```

## Summary

In this chapter, you've learned about:

1. **Implicit Conversions**: Automatic type conversions following C's hierarchy
2. **Explicit Conversions**: Manual casting using the cast operator
3. **Integer Promotion**: Automatic promotion of smaller types to `int`
4. **Arithmetic Conversions**: Rules for mixed-type arithmetic operations
5. **Potential Pitfalls**: Truncation, overflow, and precision loss
6. **Safe Practices**: Range checking and proper conversion techniques
7. **Standard Library Functions**: atoi, atof, strtol for string conversions
8. **Best Practices**: Writing safe and clear conversion code

Understanding type conversions is essential for writing robust C programs. In the next chapter, we'll explore operators and expressions, which heavily rely on type conversion rules.