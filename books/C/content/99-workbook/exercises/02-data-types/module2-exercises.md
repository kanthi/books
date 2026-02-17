# Module 2: Data Types and Variables Exercises

## Exercise 1: Data Type Explorer
Write a program that displays the size and range of all fundamental data types on your system. Include:
- All integer types (char, short, int, long, long long) and their unsigned variants
- All floating-point types (float, double, long double)
- Fixed-width integer types (int8_t, int16_t, int32_t, int64_t)
- Boolean type

**Requirements:**
- Use `sizeof` operator to determine sizes
- Use `limits.h`, `float.h`, and `stdint.h` headers for range information
- Format output clearly with labels
- Include both signed and unsigned variants where applicable

## Exercise 2: Variable Declaration Challenge
Create a program that declares variables using different naming conventions and demonstrates proper initialization:
- Declare 5 variables using snake_case convention
- Declare 5 variables using camelCase convention
- Initialize all variables at declaration
- Demonstrate the use of const variables
- Show examples of multiple variable declarations in single statements

**Requirements:**
- Use at least 3 different data types
- Include both global and local variables
- Demonstrate scope differences
- Use meaningful variable names related to a real-world scenario (e.g., student records, inventory system)

## Exercise 3: Constants Comparison
Write a program that demonstrates the three methods of creating constants in C:
- Using `#define` preprocessor directive
- Using `const` qualifier
- Using `enum` enumeration

Create constants for a real-world application (e.g., a calendar system with months, days, or a game with difficulty levels).

**Requirements:**
- Implement all three constant creation methods
- Show advantages and disadvantages of each method
- Demonstrate usage in calculations or conditional statements
- Include string constants where appropriate

## Exercise 4: Storage Class Demonstrator
Create a program that demonstrates the behavior of different storage classes:
- `auto` (automatic)
- `static` (static)
- `register` (register)
- `extern` (external)

For `extern`, create two source files to demonstrate external linkage.

**Requirements:**
- Show how static variables retain values between function calls
- Demonstrate the difference between local and global scope
- Show how register variables might be optimized
- Implement proper extern usage with header files

## Exercise 5: Type Conversion Safety
Write a program that safely handles type conversions between different data types:
- Integer to floating-point and vice versa
- Large integer to smaller integer (handle overflow)
- Signed to unsigned and vice versa
- Character to integer conversions

Include error checking and validation for unsafe conversions.

**Requirements:**
- Check for potential overflow before conversion
- Handle truncation appropriately
- Use standard library functions for string conversion (strtol, strtod)
- Provide meaningful error messages for failed conversions

## Exercise 6: Operator Expression Builder
Create a program that evaluates complex mathematical expressions using various operators:
- Arithmetic operators with mixed data types
- Relational and logical operators in compound expressions
- Bitwise operators for bit manipulation
- Assignment operators for cumulative calculations
- Conditional operators for decision making

**Requirements:**
- Include expressions with different precedence levels
- Use parentheses to clarify intent
- Demonstrate short-circuit evaluation
- Show the difference between pre and post increment/decrement

## Exercise 7: Bit Manipulation Toolkit
Develop a set of functions that perform common bit manipulation operations:
- Function to check if a specific bit is set
- Function to set a specific bit
- Function to clear a specific bit
- Function to toggle a specific bit
- Function to count the number of set bits
- Function to reverse all bits in a byte

**Requirements:**
- Implement all functions using bitwise operators
- Include parameter validation
- Provide clear documentation for each function
- Test with various input values

## Exercise 8: Data Type Selection Advisor
Create a program that helps users select appropriate data types based on their requirements:
- Input: Range of values, precision requirements, memory constraints
- Output: Recommended data type with justification
- Include considerations for portability and performance

**Requirements:**
- Consider both value range and memory usage
- Account for signed vs unsigned requirements
- Include fixed-width type recommendations
- Provide warnings for potential overflow situations

## Exercise 9: Comprehensive Calculator
Implement a calculator that demonstrates advanced use of operators and type handling:
- Basic arithmetic operations
- Bitwise operations
- Logical operations
- Type-safe conversions
- Error handling for invalid operations (division by zero, etc.)

**Requirements:**
- Support both integer and floating-point modes
- Handle operator precedence correctly
- Include memory functions (store/recall)
- Provide clear error messages
- Support both interactive and batch modes

## Exercise 10: Real-World Application
Design and implement a complete program that integrates all Module 2 concepts:
- A student grade management system
- An inventory tracking system
- A simple banking application
- A measurement conversion tool

**Requirements:**
- Use appropriate data types for all values
- Implement proper variable scoping
- Include constants for fixed values
- Handle type conversions safely
- Use operators effectively for calculations
- Apply storage classes where appropriate
- Include comprehensive error checking

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <limits.h>
#include <float.h>
#include <stdint.h>

int main() {
    printf("=== Data Type Explorer ===\n\n");
    
    // Integer types
    printf("Integer Types:\n");
    printf("char: %zu bytes, range %d to %d\n", sizeof(char), CHAR_MIN, CHAR_MAX);
    printf("unsigned char: %zu bytes, range 0 to %u\n", sizeof(unsigned char), UCHAR_MAX);
    printf("short: %zu bytes, range %d to %d\n", sizeof(short), SHRT_MIN, SHRT_MAX);
    printf("unsigned short: %zu bytes, range 0 to %u\n", sizeof(unsigned short), USHRT_MAX);
    // ... continue for other types
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>

// Using #define
#define MAX_STUDENTS 100
#define UNIVERSITY_NAME "Tech University"

// Using const
const float PI = 3.14159f;
const int PASSING_GRADE = 60;

// Using enum
enum Difficulty {
    EASY = 1,
    MEDIUM = 2,
    HARD = 3
};

enum Days {
    MONDAY = 1,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
};

int main() {
    printf("University: %s\n", UNIVERSITY_NAME);
    printf("Max students: %d\n", MAX_STUDENTS);
    printf("PI: %.5f\n", PI);
    printf("Passing grade: %d\n", PASSING_GRADE);
    printf("Difficulty level: %d\n", MEDIUM);
    printf("Day of week: %d\n", WEDNESDAY);
    
    return 0;
}
```

### Exercise 6 Solution Example:
```c
#include <stdio.h>

int main() {
    int a = 10, b = 3;
    float x = 15.7f, y = 4.2f;
    
    // Mixed arithmetic with precedence
    int result1 = a + b * 2;           // 10 + (3 * 2) = 16
    float result2 = (a + b) * x / y;   // ((10 + 3) * 15.7) / 4.2
    
    printf("Integer expression: %d + %d * 2 = %d\n", a, b, result1);
    printf("Float expression: (%d + %d) * %.1f / %.1f = %.2f\n", a, b, x, y, result2);
    
    // Logical expressions with short-circuit
    if (b != 0 && a / b > 1) {
        printf("Division is safe and result > 1\n");
    }
    
    // Conditional operator
    char *status = (a > b) ? "Greater" : "Less or Equal";
    printf("Status: %s\n", status);
    
    return 0;
}
```

### Exercise 7 Solution Example:
```c
#include <stdio.h>

// Check if bit at position is set
int is_bit_set(unsigned int num, int position) {
    return (num >> position) & 1;
}

// Set bit at position
unsigned int set_bit(unsigned int num, int position) {
    return num | (1 << position);
}

// Clear bit at position
unsigned int clear_bit(unsigned int num, int position) {
    return num & ~(1 << position);
}

// Toggle bit at position
unsigned int toggle_bit(unsigned int num, int position) {
    return num ^ (1 << position);
}

int main() {
    unsigned int number = 0b10101010;
    
    printf("Original: %08b\n", number);
    printf("Bit 3 set? %d\n", is_bit_set(number, 3));
    
    number = set_bit(number, 2);
    printf("After setting bit 2: %08b\n", number);
    
    number = clear_bit(number, 7);
    printf("After clearing bit 7: %08b\n", number);
    
    number = toggle_bit(number, 5);
    printf("After toggling bit 5: %08b\n", number);
    
    return 0;
}
```

## Common Pitfalls to Avoid

1. **Uninitialized Variables**: Always initialize variables at declaration
2. **Integer Overflow**: Check ranges before conversions
3. **Division by Zero**: Always validate divisors
4. **Implicit Conversions**: Be aware of precision loss
5. **Operator Precedence**: Use parentheses for clarity
6. **Side Effects in Expressions**: Avoid undefined behavior with ++/-- operators
7. **Signed/Unsigned Comparisons**: Be careful when mixing signed and unsigned types
8. **Bitwise vs Logical Operators**: Use &/| for bit operations, &&/|| for logical operations

## Compilation Tips
```bash
# Basic compilation
gcc program.c -o program

# With warnings for type safety
gcc -Wall -Wextra program.c -o program

# With standard specification
gcc -std=c99 program.c -o program

# With debugging information
gcc -g -Wall program.c -o program
```

Complete these exercises to solidify your understanding of Module 2 concepts. Each exercise builds upon the previous ones, gradually increasing in complexity.