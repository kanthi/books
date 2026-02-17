# Operators and Expressions

## Introduction

Operators are symbols that perform specific operations on operands (variables, constants, or expressions). Expressions are combinations of operators and operands that evaluate to a single value. Understanding operators and how to construct expressions is fundamental to C programming, as they form the building blocks of all program logic.

This chapter will cover all major categories of operators in C, their precedence and associativity rules, and how to write effective expressions.

## Categories of Operators

C provides a rich set of operators that can be categorized as follows:

1. **Arithmetic Operators**: Perform mathematical operations
2. **Relational Operators**: Compare values
3. **Logical Operators**: Combine boolean expressions
4. **Bitwise Operators**: Manipulate individual bits
5. **Assignment Operators**: Assign values to variables
6. **Increment/Decrement Operators**: Modify values by one
7. **Conditional Operator**: Ternary selection operator
8. **Special Operators**: sizeof, address-of, dereference, etc.

## Arithmetic Operators

Arithmetic operators perform basic mathematical operations:

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `+` | Addition | `5 + 3` | 8 |
| `-` | Subtraction | `5 - 3` | 2 |
| `*` | Multiplication | `5 * 3` | 15 |
| `/` | Division | `5 / 3` | 1 (integer division) |
| `%` | Modulus (remainder) | `5 % 3` | 2 |

### Basic Arithmetic Operations

```c
#include <stdio.h>

int main() {
    int a = 10, b = 3;
    
    printf("a = %d, b = %d\n", a, b);
    printf("a + b = %d\n", a + b);
    printf("a - b = %d\n", a - b);
    printf("a * b = %d\n", a * b);
    printf("a / b = %d\n", a / b);  // Integer division
    printf("a %% b = %d\n", a % b); // Modulus
    
    // Floating-point arithmetic
    float x = 10.0f, y = 3.0f;
    printf("\nFloat arithmetic:\n");
    printf("x = %.1f, y = %.1f\n", x, y);
    printf("x / y = %.2f\n", x / y);  // Floating-point division
    
    return 0;
}
```

### Division and Modulus Behavior

```c
#include <stdio.h>

int main() {
    // Integer division truncates toward zero
    printf("Integer division:\n");
    printf("7 / 3 = %d\n", 7 / 3);     // 2
    printf("-7 / 3 = %d\n", -7 / 3);   // -2
    printf("7 / -3 = %d\n", 7 / -3);   // -2
    printf("-7 / -3 = %d\n", -7 / -3); // 2
    
    // Modulus result has the same sign as the dividend
    printf("\nModulus operations:\n");
    printf("7 %% 3 = %d\n", 7 % 3);     // 1
    printf("-7 %% 3 = %d\n", -7 % 3);   // -1
    printf("7 %% -3 = %d\n", 7 % -3);   // 1
    printf("-7 %% -3 = %d\n", -7 % -3); // -1
    
    return 0;
}
```

## Relational Operators

Relational operators compare two values and return a boolean result (1 for true, 0 for false):

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `==` | Equal to | `5 == 3` | 0 (false) |
| `!=` | Not equal to | `5 != 3` | 1 (true) |
| `>` | Greater than | `5 > 3` | 1 (true) |
| `<` | Less than | `5 < 3` | 0 (false) |
| `>=` | Greater than or equal to | `5 >= 5` | 1 (true) |
| `<=` | Less than or equal to | `5 <= 3` | 0 (false) |

### Relational Operations

```c
#include <stdio.h>

int main() {
    int x = 10, y = 20;
    
    printf("x = %d, y = %d\n", x, y);
    printf("x == y: %d\n", x == y);
    printf("x != y: %d\n", x != y);
    printf("x > y: %d\n", x > y);
    printf("x < y: %d\n", x < y);
    printf("x >= y: %d\n", x >= y);
    printf("x <= y: %d\n", x <= y);
    
    // Floating-point comparison (be careful!)
    float a = 0.1f + 0.2f;
    float b = 0.3f;
    printf("\nFloating-point comparison:\n");
    printf("a = %.20f\n", a);
    printf("b = %.20f\n", b);
    printf("a == b: %d\n", a == b);
    
    return 0;
}
```

## Logical Operators

Logical operators work with boolean values and are used to combine or invert conditions:

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `&&` | Logical AND | `1 && 0` | 0 (false) |
| `||` | Logical OR | `1 || 0` | 1 (true) |
| `!` | Logical NOT | `!1` | 0 (false) |

### Logical Operations

```c
#include <stdio.h>

int main() {
    int a = 1, b = 0, c = 1;
    
    printf("a = %d, b = %d, c = %d\n", a, b, c);
    printf("a && b: %d\n", a && b);  // 1 AND 0 = 0
    printf("a || b: %d\n", a || b);  // 1 OR 0 = 1
    printf("!a: %d\n", !a);          // NOT 1 = 0
    printf("a && c: %d\n", a && c);  // 1 AND 1 = 1
    printf("a || (b && c): %d\n", a || (b && c));  // 1 OR (0 AND 1) = 1
    
    // Short-circuit evaluation
    printf("\nShort-circuit evaluation:\n");
    int x = 5, y = 0;
    if (y != 0 && x / y > 1) {  // Second condition not evaluated
        printf("This won't print\n");
    } else {
        printf("Short-circuit prevented division by zero\n");
    }
    
    return 0;
}
```

## Bitwise Operators

Bitwise operators work at the bit level and are particularly useful in systems programming and embedded development:

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `&` | Bitwise AND | `5 & 3` | 1 |
| `|` | Bitwise OR | `5 | 3` | 7 |
| `^` | Bitwise XOR | `5 ^ 3` | 6 |
| `~` | Bitwise NOT | `~5` | -6 |
| `<<` | Left shift | `5 << 1` | 10 |
| `>>` | Right shift | `5 >> 1` | 2 |

### Bitwise Operations

```c
#include <stdio.h>

void print_binary(unsigned int num) {
    for (int i = 31; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
        if (i % 4 == 0) printf(" ");
    }
    printf("\n");
}

int main() {
    unsigned int a = 12;  // Binary: 1100
    unsigned int b = 10;  // Binary: 1010
    
    printf("a = %u, b = %u\n", a, b);
    printf("a in binary: ");
    print_binary(a);
    printf("b in binary: ");
    print_binary(b);
    
    printf("\nBitwise operations:\n");
    printf("a & b = %u (AND)\n", a & b);
    printf("a | b = %u (OR)\n", a | b);
    printf("a ^ b = %u (XOR)\n", a ^ b);
    printf("~a = %u (NOT)\n", ~a);
    printf("a << 1 = %u (Left shift)\n", a << 1);
    printf("a >> 1 = %u (Right shift)\n", a >> 1);
    
    // Practical example: Setting, clearing, and toggling bits
    unsigned char flags = 0b00001010;  // 10 in decimal
    printf("\nFlag operations:\n");
    printf("Original flags: ");
    print_binary(flags);
    
    // Set bit 2 (make it 1)
    flags |= (1 << 2);
    printf("After setting bit 2: ");
    print_binary(flags);
    
    // Clear bit 3 (make it 0)
    flags &= ~(1 << 3);
    printf("After clearing bit 3: ");
    print_binary(flags);
    
    // Toggle bit 1
    flags ^= (1 << 1);
    printf("After toggling bit 1: ");
    print_binary(flags);
    
    return 0;
}
```

## Assignment Operators

Assignment operators assign values to variables. C provides several compound assignment operators for convenience:

| Operator | Description | Equivalent To |
|----------|-------------|---------------|
| `=` | Simple assignment | `a = b` |
| `+=` | Add and assign | `a = a + b` |
| `-=` | Subtract and assign | `a = a - b` |
| `*=` | Multiply and assign | `a = a * b` |
| `/=` | Divide and assign | `a = a / b` |
| `%=` | Modulus and assign | `a = a % b` |
| `&=` | Bitwise AND and assign | `a = a & b` |
| `|=` | Bitwise OR and assign | `a = a | b` |
| `^=` | Bitwise XOR and assign | `a = a ^ b` |
| `<<=` | Left shift and assign | `a = a << b` |
| `>>=` | Right shift and assign | `a = a >> b` |

### Assignment Operations

```c
#include <stdio.h>

int main() {
    int a = 10;
    printf("Initial value: a = %d\n", a);
    
    a += 5;    // a = a + 5
    printf("After a += 5: a = %d\n", a);
    
    a -= 3;    // a = a - 3
    printf("After a -= 3: a = %d\n", a);
    
    a *= 2;    // a = a * 2
    printf("After a *= 2: a = %d\n", a);
    
    a /= 4;    // a = a / 4
    printf("After a /= 4: a = %d\n", a);
    
    a %= 3;    // a = a % 3
    printf("After a %%= 3: a = %d\n", a);
    
    // Multiple assignments
    int x, y, z;
    x = y = z = 5;  // All variables get value 5
    printf("\nMultiple assignment: x = %d, y = %d, z = %d\n", x, y, z);
    
    return 0;
}
```

## Increment and Decrement Operators

These operators increase or decrease a variable's value by 1:

| Operator | Description | Example | Result |
|----------|-------------|---------|--------|
| `++` | Pre-increment | `++a` | Increment a, then use new value |
| `++` | Post-increment | `a++` | Use current value, then increment a |
| `--` | Pre-decrement | `--a` | Decrement a, then use new value |
| `--` | Post-decrement | `a--` | Use current value, then decrement a |

### Increment/Decrement Examples

```c
#include <stdio.h>

int main() {
    int a = 5, b = 5;
    int result1, result2;
    
    printf("Initial: a = %d, b = %d\n", a, b);
    
    // Pre-increment
    result1 = ++a;
    printf("After ++a: a = %d, result1 = %d\n", a, result1);
    
    // Post-increment
    result2 = b++;
    printf("After b++: b = %d, result2 = %d\n", b, result2);
    
    // Practical example in loops
    printf("\nLoop examples:\n");
    
    // Using pre-increment
    printf("Pre-increment loop:\n");
    for (int i = 0; i < 3; ++i) {
        printf("i = %d\n", i);
    }
    
    // Using post-increment
    printf("Post-increment loop:\n");
    for (int i = 0; i < 3; i++) {
        printf("i = %d\n", i);
    }
    
    // Be careful with complex expressions
    int x = 10;
    int y = ++x + x++;  // Undefined behavior!
    printf("\nUndefined behavior example: y = %d\n", y);
    
    return 0;
}
```

## Conditional (Ternary) Operator

The conditional operator is C's only ternary operator, taking three operands:

```c
condition ? value_if_true : value_if_false
```

### Conditional Operator Examples

```c
#include <stdio.h>

int main() {
    int a = 10, b = 20;
    
    // Simple conditional assignment
    int max = (a > b) ? a : b;
    printf("Maximum of %d and %d is %d\n", a, b, max);
    
    // Conditional string selection
    char *message = (a % 2 == 0) ? "even" : "odd";
    printf("%d is %s\n", a, message);
    
    // Nested conditional operators
    int score = 85;
    char *grade = (score >= 90) ? "A" :
                  (score >= 80) ? "B" :
                  (score >= 70) ? "C" :
                  (score >= 60) ? "D" : "F";
    printf("Score %d gets grade %s\n", score, grade);
    
    // Conditional with function calls (be careful with side effects)
    int x = 5, y = 10;
    int result = (x > y) ? (x += 5) : (y += 5);
    printf("After conditional: x = %d, y = %d, result = %d\n", x, y, result);
    
    return 0;
}
```

## Special Operators

### sizeof Operator

Returns the size (in bytes) of a data type or variable:

```c
#include <stdio.h>

int main() {
    printf("Size of char: %zu bytes\n", sizeof(char));
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of float: %zu bytes\n", sizeof(float));
    printf("Size of double: %zu bytes\n", sizeof(double));
    printf("Size of pointer: %zu bytes\n", sizeof(int*));
    
    int array[10];
    printf("Size of array[10]: %zu bytes\n", sizeof(array));
    printf("Size of array element: %zu bytes\n", sizeof(array[0]));
    
    return 0;
}
```

### Address-of (&) and Dereference (*) Operators

Used with pointers (covered in detail in Module 6):

```c
#include <stdio.h>

int main() {
    int number = 42;
    int *ptr = &number;  // Address-of operator
    
    printf("Value of number: %d\n", number);
    printf("Address of number: %p\n", (void*)&number);
    printf("Value of ptr: %p\n", (void*)ptr);
    printf("Value pointed to by ptr: %d\n", *ptr);  // Dereference operator
    
    return 0;
}
```

## Operator Precedence and Associativity

Operators in C have specific precedence levels and associativity rules that determine the order of evaluation in expressions:

### Precedence Levels (Highest to Lowest)

1. **Postfix**: `()`, `[]`, `->`, `.`, `++`, `--` (Left to Right)
2. **Unary**: `++`, `--`, `+`, `-`, `!`, `~`, `(type)`, `*`, `&`, `sizeof` (Right to Left)
3. **Multiplicative**: `*`, `/`, `%` (Left to Right)
4. **Additive**: `+`, `-` (Left to Right)
5. **Shift**: `<<`, `>>` (Left to Right)
6. **Relational**: `<`, `<=`, `>`, `>=` (Left to Right)
7. **Equality**: `==`, `!=` (Left to Right)
8. **Bitwise AND**: `&` (Left to Right)
9. **Bitwise XOR**: `^` (Left to Right)
10. **Bitwise OR**: `|` (Left to Right)
11. **Logical AND**: `&&` (Left to Right)
12. **Logical OR**: `||` (Left to Right)
13. **Conditional**: `?:` (Right to Left)
14. **Assignment**: `=`, `+=`, `-=`, etc. (Right to Left)
15. **Comma**: `,` (Left to Right)

### Precedence Examples

```c
#include <stdio.h>

int main() {
    int a = 5, b = 3, c = 2;
    
    // Multiplication has higher precedence than addition
    int result1 = a + b * c;        // 5 + (3 * 2) = 11
    int result2 = (a + b) * c;      // (5 + 3) * 2 = 16
    
    printf("a + b * c = %d\n", result1);
    printf("(a + b) * c = %d\n", result2);
    
    // Relational operators have lower precedence than arithmetic
    int result3 = a > b + c;        // a > (b + c) = 5 > 5 = 0
    int result4 = (a > b) + c;      // (a > b) + c = 1 + 2 = 3
    
    printf("a > b + c = %d\n", result3);
    printf("(a > b) + c = %d\n", result4);
    
    // Logical operators have lower precedence than relational
    int x = 10, y = 5, z = 15;
    int result5 = x > y && y < z;   // (x > y) && (y < z) = 1 && 1 = 1
    int result6 = x > y & y < z;    // x > (y & y) < z = 10 > 1 < 15 = 1
    
    printf("x > y && y < z = %d\n", result5);
    printf("x > y & y < z = %d\n", result6);
    
    return 0;
}
```

## Practical Examples

### Mathematical Expression Evaluator
```c
#include <stdio.h>

int main() {
    double x, y, z;
    
    printf("Enter three numbers: ");
    scanf("%lf %lf %lf", &x, &y, &z);
    
    // Complex mathematical expression
    double result = (x + y) * z / (x - y) + (x * y - z);
    
    printf("Result of (x + y) * z / (x - y) + (x * y - z):\n");
    printf("= (%.2f + %.2f) * %.2f / (%.2f - %.2f) + (%.2f * %.2f - %.2f)\n", 
           x, y, z, x, y, x, y, z);
    printf("= %.2f\n", result);
    
    return 0;
}
```

### Bit Manipulation Utility
```c
#include <stdio.h>

// Function to check if a bit is set
int is_bit_set(unsigned int num, int position) {
    return (num >> position) & 1;
}

// Function to set a bit
unsigned int set_bit(unsigned int num, int position) {
    return num | (1 << position);
}

// Function to clear a bit
unsigned int clear_bit(unsigned int num, int position) {
    return num & ~(1 << position);
}

// Function to toggle a bit
unsigned int toggle_bit(unsigned int num, int position) {
    return num ^ (1 << position);
}

void print_bits(unsigned int num) {
    printf("Binary: ");
    for (int i = 31; i >= 0; i--) {
        printf("%d", (num >> i) & 1);
        if (i % 4 == 0) printf(" ");
    }
    printf("\n");
}

int main() {
    unsigned int number = 0b10101010;
    
    printf("Original number: %u\n", number);
    print_bits(number);
    
    // Check bit at position 3
    printf("Bit at position 3: %d\n", is_bit_set(number, 3));
    
    // Set bit at position 2
    number = set_bit(number, 2);
    printf("After setting bit 2: %u\n", number);
    print_bits(number);
    
    // Clear bit at position 7
    number = clear_bit(number, 7);
    printf("After clearing bit 7: %u\n", number);
    print_bits(number);
    
    // Toggle bit at position 5
    number = toggle_bit(number, 5);
    printf("After toggling bit 5: %u\n", number);
    print_bits(number);
    
    return 0;
}
```

### Conditional Logic Demonstrator
```c
#include <stdio.h>

int main() {
    int score;
    printf("Enter student score (0-100): ");
    scanf("%d", &score);
    
    // Validate input
    if (score < 0 || score > 100) {
        printf("Invalid score!\n");
        return 1;
    }
    
    // Determine letter grade using conditional operators
    char *letter_grade = (score >= 90) ? "A" :
                        (score >= 80) ? "B" :
                        (score >= 70) ? "C" :
                        (score >= 60) ? "D" : "F";
    
    // Determine pass/fail status
    char *status = (score >= 60) ? "PASS" : "FAIL";
    
    // Provide feedback
    char *feedback = (score >= 90) ? "Excellent!" :
                    (score >= 80) ? "Good job!" :
                    (score >= 70) ? "Satisfactory" :
                    (score >= 60) ? "Needs improvement" : "Failed";
    
    printf("\nResults:\n");
    printf("Score: %d\n", score);
    printf("Grade: %s\n", letter_grade);
    printf("Status: %s\n", status);
    printf("Feedback: %s\n", feedback);
    
    return 0;
}
```

## Best Practices

### 1. Use Parentheses for Clarity
```c
// Good: Clear intent
int result = (a + b) * c;

// Less clear: Relies on precedence knowledge
int result = a + b * c;
```

### 2. Be Careful with Side Effects
```c
// Dangerous: Undefined behavior
int a = 5;
int result = a++ + ++a;

// Safe: Clear separation of operations
int a = 5;
int temp1 = a++;
int temp2 = ++a;
int result = temp1 + temp2;
```

### 3. Use Meaningful Variable Names in Complex Expressions
```c
// Good: Self-documenting
int base_salary = 50000;
int bonus_percentage = 10;
int years_of_service = 5;
int total_compensation = base_salary + (base_salary * bonus_percentage / 100) * years_of_service;

// Less clear
int a = 50000;
int b = 10;
int c = 5;
int d = a + (a * b / 100) * c;
```

### 4. Be Aware of Integer Division
```c
// If you want floating-point result
float average = (float)total / count;

// If you want integer result
int average = total / count;
```

### 5. Use Bitwise Operations for Bit Manipulation
```c
// Good for setting flags
flags |= FLAG_READ;

// Good for clearing flags
flags &= ~FLAG_WRITE;

// Good for checking flags
if (flags & FLAG_EXECUTE) {
    // Execute code
}
```

## Summary

In this chapter, you've learned about:

1. **Arithmetic Operators**: `+`, `-`, `*`, `/`, `%` for mathematical operations
2. **Relational Operators**: `==`, `!=`, `>`, `<`, `>=`, `<=` for comparisons
3. **Logical Operators**: `&&`, `||`, `!` for boolean logic
4. **Bitwise Operators**: `&`, `|`, `^`, `~`, `<<`, `>>` for bit manipulation
5. **Assignment Operators**: `=`, `+=`, `-=`, etc. for value assignment
6. **Increment/Decrement Operators**: `++`, `--` for modifying values by one
7. **Conditional Operator**: `?:` for ternary selection
8. **Special Operators**: `sizeof`, `&`, `*` for specific operations
9. **Operator Precedence**: Rules determining evaluation order
10. **Best Practices**: Writing clear and safe expressions

Understanding operators and expressions is crucial for C programming, as they form the foundation for all program logic. With this knowledge, you're now ready to tackle more complex programming constructs like control flow statements in the next module.