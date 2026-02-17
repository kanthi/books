# Advanced Functions

## Introduction

Building upon the fundamental concepts of functions, this chapter explores advanced function features in C that provide greater flexibility and power. These advanced features include recursive functions, variable argument functions, inline functions, and function pointers. Understanding these concepts is crucial for writing sophisticated C programs and leveraging the full capabilities of the language.

Advanced functions enable you to implement complex algorithms, create flexible interfaces, and build more efficient code. This chapter will dive deep into each of these advanced topics with practical examples and best practices.

## Recursive Functions

Recursion is a powerful programming technique where a function calls itself to solve a problem. Recursive functions are particularly useful for problems that can be broken down into smaller, similar subproblems.

### Basic Recursion Concepts

A recursive function must have:
1. **Base Case**: A condition that stops the recursion
2. **Recursive Case**: The function calling itself with modified parameters

### Simple Recursion Example

```c
#include <stdio.h>

// Calculate factorial using recursion
int factorial(int n) {
    // Base case
    if (n <= 1) {
        return 1;
    }
    
    // Recursive case
    return n * factorial(n - 1);
}

int main() {
    for (int i = 0; i <= 6; i++) {
        printf("%d! = %d\n", i, factorial(i));
    }
    
    return 0;
}
```

### Fibonacci Sequence

```c
#include <stdio.h>

// Calculate Fibonacci number using recursion
int fibonacci(int n) {
    // Base cases
    if (n <= 1) {
        return n;
    }
    
    // Recursive case
    return fibonacci(n - 1) + fibonacci(n - 2);
}

int main() {
    printf("Fibonacci sequence (first 10 numbers):\n");
    for (int i = 0; i < 10; i++) {
        printf("F(%d) = %d\n", i, fibonacci(i));
    }
    
    return 0;
}
```

### Recursive Array Processing

```c
#include <stdio.h>

// Calculate sum of array elements using recursion
int array_sum(int arr[], int size) {
    // Base case
    if (size <= 0) {
        return 0;
    }
    
    // Recursive case
    return arr[size - 1] + array_sum(arr, size - 1);
}

// Find maximum element in array using recursion
int array_max(int arr[], int size) {
    // Base case
    if (size == 1) {
        return arr[0];
    }
    
    // Recursive case
    int max_of_rest = array_max(arr + 1, size - 1);
    return (arr[0] > max_of_rest) ? arr[0] : max_of_rest;
}

int main() {
    int numbers[] = {3, 7, 2, 9, 1, 8, 4};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("Array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    printf("Sum: %d\n", array_sum(numbers, size));
    printf("Maximum: %d\n", array_max(numbers, size));
    
    return 0;
}
```

## Variable Argument Functions

C provides the `<stdarg.h>` header for creating functions that can accept a variable number of arguments. This is useful for functions like `printf()` that can handle different numbers of parameters.

### Basic Variable Argument Functions

```c
#include <stdio.h>
#include <stdarg.h>

// Function that calculates the sum of variable arguments
int sum(int count, ...) {
    va_list args;
    va_start(args, count);
    
    int total = 0;
    for (int i = 0; i < count; i++) {
        int value = va_arg(args, int);
        total += value;
    }
    
    va_end(args);
    return total;
}

// Function that finds maximum among variable arguments
int maximum(int count, ...) {
    if (count <= 0) return 0;
    
    va_list args;
    va_start(args, count);
    
    int max = va_arg(args, int);
    for (int i = 1; i < count; i++) {
        int value = va_arg(args, int);
        if (value > max) {
            max = value;
        }
    }
    
    va_end(args);
    return max;
}

int main() {
    printf("Sum of 3 numbers: %d\n", sum(3, 10, 20, 30));
    printf("Sum of 5 numbers: %d\n", sum(5, 1, 2, 3, 4, 5));
    
    printf("Maximum of 4 numbers: %d\n", maximum(4, 15, 8, 23, 42));
    printf("Maximum of 3 numbers: %d\n", maximum(3, 100, 50, 75));
    
    return 0;
}
```

### Formatted Print Function

```c
#include <stdio.h>
#include <stdarg.h>

// Custom printf-like function
void my_printf(const char *format, ...) {
    va_list args;
    va_start(args, format);
    
    while (*format != '\0') {
        if (*format == '%' && *(format + 1) != '\0') {
            format++;
            switch (*format) {
                case 'd':
                    printf("%d", va_arg(args, int));
                    break;
                case 'f':
                    printf("%f", va_arg(args, double));
                    break;
                case 'c':
                    printf("%c", va_arg(args, int));  // char is promoted to int
                    break;
                case 's':
                    printf("%s", va_arg(args, char*));
                    break;
                default:
                    printf("%%");
                    printf("%c", *format);
                    break;
            }
        } else {
            printf("%c", *format);
        }
        format++;
    }
    
    va_end(args);
}

int main() {
    my_printf("Hello, %s! You are %d years old.\n", "World", 25);
    my_printf("Pi is approximately %f\n", 3.14159);
    my_printf("Character: %c\n", 'A');
    
    return 0;
}
```

## Inline Functions (C99)

Inline functions are a C99 feature that suggests to the compiler that the function code should be inserted directly at the call site, potentially reducing function call overhead.

### Basic Inline Functions

```c
#include <stdio.h>

// Inline function suggestion (C99)
inline int square(int x) {
    return x * x;
}

inline int max(int a, int b) {
    return (a > b) ? a : b;
}

int main() {
    int result1 = square(5);
    int result2 = max(10, 20);
    
    printf("Square of 5: %d\n", result1);
    printf("Maximum of 10 and 20: %d\n", result2);
    
    return 0;
}
```

### Performance Considerations

```c
#include <stdio.h>
#include <time.h>

// Regular function
int regular_square(int x) {
    return x * x;
}

// Inline function
inline int inline_square(int x) {
    return x * x;
}

int main() {
    const int iterations = 100000000;
    clock_t start, end;
    
    // Test regular function
    start = clock();
    volatile int sum1 = 0;
    for (int i = 0; i < iterations; i++) {
        sum1 += regular_square(i % 1000);
    }
    end = clock();
    double regular_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Test inline function
    start = clock();
    volatile int sum2 = 0;
    for (int i = 0; i < iterations; i++) {
        sum2 += inline_square(i % 1000);
    }
    end = clock();
    double inline_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Regular function time: %.4f seconds\n", regular_time);
    printf("Inline function time: %.4f seconds\n", inline_time);
    printf("Results: %d, %d\n", sum1, sum2);
    
    return 0;
}
```

## Function Pointers

Function pointers are variables that store the address of a function. They enable dynamic function selection, callbacks, and more flexible program design.

### Basic Function Pointers

```c
#include <stdio.h>

// Function definitions
int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

int multiply(int a, int b) {
    return a * b;
}

int divide(int a, int b) {
    if (b != 0) {
        return a / b;
    }
    return 0;
}

int main() {
    // Function pointer declaration
    int (*operation)(int, int);
    
    // Assign function addresses to pointer
    operation = add;
    printf("5 + 3 = %d\n", operation(5, 3));
    
    operation = subtract;
    printf("5 - 3 = %d\n", operation(5, 3));
    
    operation = multiply;
    printf("5 * 3 = %d\n", operation(5, 3));
    
    operation = divide;
    printf("6 / 3 = %d\n", operation(6, 3));
    
    return 0;
}
```

### Function Pointer Arrays

```c
#include <stdio.h>

// Mathematical operations
int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return b != 0 ? a / b : 0; }

int main() {
    // Array of function pointers
    int (*operations[])(int, int) = {add, subtract, multiply, divide};
    char *operation_names[] = {"Add", "Subtract", "Multiply", "Divide"};
    
    int x = 10, y = 5;
    
    printf("Operations on %d and %d:\n", x, y);
    for (int i = 0; i < 4; i++) {
        int result = operations[i](x, y);
        printf("%s: %d\n", operation_names[i], result);
    }
    
    return 0;
}
```

### Callback Functions

```c
#include <stdio.h>

// Function that takes a function pointer as parameter
void process_array(int arr[], int size, void (*callback)(int)) {
    for (int i = 0; i < size; i++) {
        callback(arr[i]);
    }
}

// Callback functions
void print_square(int n) {
    printf("%d^2 = %d\n", n, n * n);
}

void print_double(int n) {
    printf("%d * 2 = %d\n", n, n * 2);
}

void print_negative(int n) {
    printf("-%d = %d\n", n, -n);
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("Squares:\n");
    process_array(numbers, size, print_square);
    
    printf("\nDoubles:\n");
    process_array(numbers, size, print_double);
    
    printf("\nNegatives:\n");
    process_array(numbers, size, print_negative);
    
    return 0;
}
```

## Higher-Order Functions

Higher-order functions are functions that take other functions as parameters or return functions as results. While C doesn't support returning functions directly, it can work with function pointers to achieve similar functionality.

### Function Factory Pattern

```c
#include <stdio.h>
#include <stdlib.h>

// Function pointer type for mathematical operations
typedef int (*math_operation)(int, int);

// Function that returns a function pointer
math_operation get_operation(char op) {
    switch (op) {
        case '+': return (math_operation)add;
        case '-': return (math_operation)subtract;
        case '*': return (math_operation)multiply;
        case '/': return (math_operation)divide;
        default: return NULL;
    }
}

// Mathematical operations (defined earlier)
int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return b != 0 ? a / b : 0; }

int main() {
    char operators[] = {'+', '-', '*', '/'};
    int x = 15, y = 3;
    
    for (int i = 0; i < 4; i++) {
        math_operation op = get_operation(operators[i]);
        if (op != NULL) {
            int result = op(x, y);
            printf("%d %c %d = %d\n", x, operators[i], y, result);
        }
    }
    
    return 0;
}
```

## Best Practices for Advanced Functions

### 1. Recursion Best Practices

```c
#include <stdio.h>

// Good: Tail recursion optimization possible
int factorial_tail(int n, int accumulator) {
    if (n <= 1) {
        return accumulator;
    }
    return factorial_tail(n - 1, n * accumulator);
}

int factorial(int n) {
    return factorial_tail(n, 1);
}

// Avoid: Deep recursion that may cause stack overflow
/*
int fibonacci_slow(int n) {
    if (n <= 1) return n;
    return fibonacci_slow(n - 1) + fibonacci_slow(n - 2);  // Exponential time!
}
*/

// Better: Iterative approach or memoization
int fibonacci_fast(int n) {
    if (n <= 1) return n;
    
    int a = 0, b = 1, result;
    for (int i = 2; i <= n; i++) {
        result = a + b;
        a = b;
        b = result;
    }
    return result;
}

int main() {
    printf("Factorial of 5: %d\n", factorial(5));
    printf("Fibonacci of 10: %d\n", fibonacci_fast(10));
    
    return 0;
}
```

### 2. Variable Argument Functions Best Practices

```c
#include <stdio.h>
#include <stdarg.h>

// Good: Clear count parameter
int sum_with_count(int count, ...) {
    if (count <= 0) return 0;
    
    va_list args;
    va_start(args, count);
    
    int total = 0;
    for (int i = 0; i < count; i++) {
        total += va_arg(args, int);
    }
    
    va_end(args);
    return total;
}

// Better: Sentinel-based approach (like printf)
int sum_with_sentinel(int first, ...) {
    if (first == 0) return 0;
    
    va_list args;
    va_start(args, first);
    
    int total = first;
    int value;
    while ((value = va_arg(args, int)) != 0) {
        total += value;
    }
    
    va_end(args);
    return total;
}

int main() {
    printf("Sum with count: %d\n", sum_with_count(4, 1, 2, 3, 4));
    printf("Sum with sentinel: %d\n", sum_with_sentinel(1, 2, 3, 4, 0));
    
    return 0;
}
```

### 3. Function Pointer Best Practices

```c
#include <stdio.h>

// Good: Type-safe function pointers
typedef int (*binary_operation)(int, int);

int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }

// Good: Function pointer validation
int safe_calculate(binary_operation op, int x, int y) {
    if (op == NULL) {
        printf("Error: Invalid operation\n");
        return 0;
    }
    return op(x, y);
}

int main() {
    binary_operation operations[] = {add, subtract, NULL};
    int x = 10, y = 5;
    
    for (int i = 0; operations[i] != NULL; i++) {
        int result = safe_calculate(operations[i], x, y);
        printf("Result: %d\n", result);
    }
    
    // Test with NULL pointer
    int result = safe_calculate(NULL, x, y);
    printf("NULL operation result: %d\n", result);
    
    return 0;
}
```

## Common Pitfalls and How to Avoid Them

### 1. Infinite Recursion

```c
#include <stdio.h>

// Wrong: Missing or incorrect base case
/*
int factorial_wrong(int n) {
    return n * factorial_wrong(n - 1);  // Infinite recursion!
}
*/

// Correct: Proper base case
int factorial_correct(int n) {
    if (n < 0) return -1;  // Handle negative input
    if (n <= 1) return 1;  // Base case
    return n * factorial_correct(n - 1);
}

int main() {
    printf("Factorial of 5: %d\n", factorial_correct(5));
    printf("Factorial of -3: %d\n", factorial_correct(-3));
    
    return 0;
}
```

### 2. Variable Argument Function Errors

```c
#include <stdio.h>
#include <stdarg.h>

// Wrong: Incorrect argument type retrieval
/*
void print_numbers_wrong(int count, ...) {
    va_list args;
    va_start(args, count);
    
    for (int i = 0; i < count; i++) {
        double value = va_arg(args, double);  // Wrong if ints were passed
        printf("%.2f ", value);
    }
    
    va_end(args);
    printf("\n");
}
*/

// Correct: Match argument types
void print_numbers_correct(int count, ...) {
    va_list args;
    va_start(args, count);
    
    for (int i = 0; i < count; i++) {
        int value = va_arg(args, int);  // Correct type
        printf("%d ", value);
    }
    
    va_end(args);
    printf("\n");
}

int main() {
    print_numbers_correct(4, 10, 20, 30, 40);
    
    return 0;
}
```

### 3. Function Pointer Errors

```c
#include <stdio.h>

int add(int a, int b) { return a + b; }

int main() {
    // Wrong: Incorrect function pointer type
    /*
    int (*wrong_ptr)(int) = add;  // Mismatch: add takes 2 params
    */
    
    // Correct: Matching function pointer type
    int (*correct_ptr)(int, int) = add;
    
    int result = correct_ptr(5, 3);
    printf("5 + 3 = %d\n", result);
    
    return 0;
}
```

## Practical Examples

### Recursive Directory Traversal

```c
#include <stdio.h>
#include <string.h>

// Simulate directory structure
typedef struct {
    char name[50];
    int is_directory;
    struct {
        char name[50];
        int is_directory;
    } contents[10];
    int content_count;
} Directory;

// Recursive function to print directory structure
void print_directory(Directory *dir, int depth) {
    // Print indentation
    for (int i = 0; i < depth; i++) {
        printf("  ");
    }
    
    // Print directory name
    printf("%s%s\n", dir->name, dir->is_directory ? "/" : "");
    
    // Recursively print contents
    if (dir->is_directory) {
        for (int i = 0; i < dir->content_count; i++) {
            Directory sub_dir;
            strcpy(sub_dir.name, dir->contents[i].name);
            sub_dir.is_directory = dir->contents[i].is_directory;
            // In real implementation, would load actual directory data
            print_directory(&sub_dir, depth + 1);
        }
    }
}

int main() {
    Directory root = {"root", 1, {{"documents", 1}, {"file1.txt", 0}}, 2};
    print_directory(&root, 0);
    
    return 0;
}
```

### Mathematical Expression Evaluator

```c
#include <stdio.h>
#include <stdarg.h>
#include <string.h>

// Function pointer type for operations
typedef double (*operation_func)(double, double);

// Mathematical operations
double add(double a, double b) { return a + b; }
double subtract(double a, double b) { return a - b; }
double multiply(double a, double b) { return a * b; }
double divide(double a, double b) { return b != 0 ? a / b : 0; }

// Calculator with variable arguments
double calculate(const char *operations, double first, ...) {
    va_list args;
    va_start(args, first);
    
    double result = first;
    int op_index = 0;
    
    while (operations[op_index] != '\0') {
        double operand = va_arg(args, double);
        operation_func op;
        
        switch (operations[op_index]) {
            case '+': op = add; break;
            case '-': op = subtract; break;
            case '*': op = multiply; break;
            case '/': op = divide; break;
            default: op = NULL; break;
        }
        
        if (op != NULL) {
            result = op(result, operand);
        }
        
        op_index++;
    }
    
    va_end(args);
    return result;
}

int main() {
    // Calculate: 10 + 5 * 2 - 3 / 2
    double result = calculate("+-*/", 10.0, 5.0, 2.0, 3.0, 2.0);
    printf("Result: %.2f\n", result);
    
    return 0;
}
```

### Event Handler System

```c
#include <stdio.h>
#include <string.h>

#define MAX_HANDLERS 10

// Event handler function pointer type
typedef void (*event_handler)(const char *event_data);

// Event handler registry
typedef struct {
    char event_name[50];
    event_handler handlers[MAX_HANDLERS];
    int handler_count;
} EventHandlerRegistry;

EventHandlerRegistry registry = {0};

// Register event handler
void register_handler(const char *event_name, event_handler handler) {
    if (registry.handler_count < MAX_HANDLERS) {
        registry.handlers[registry.handler_count] = handler;
        registry.handler_count++;
        strcpy(registry.event_name, event_name);
        printf("Handler registered for event: %s\n", event_name);
    }
}

// Trigger event
void trigger_event(const char *event_name, const char *event_data) {
    printf("Triggering event: %s\n", event_name);
    for (int i = 0; i < registry.handler_count; i++) {
        if (registry.handlers[i] != NULL) {
            registry.handlers[i](event_data);
        }
    }
}

// Sample event handlers
void on_user_login(const char *user_data) {
    printf("User logged in: %s\n", user_data);
}

void on_user_logout(const char *user_data) {
    printf("User logged out: %s\n", user_data);
}

void on_data_update(const char *data) {
    printf("Data updated: %s\n", data);
}

int main() {
    // Register handlers
    register_handler("user_login", on_user_login);
    register_handler("user_logout", on_user_logout);
    register_handler("data_update", on_data_update);
    
    // Trigger events
    trigger_event("user_login", "Alice");
    trigger_event("data_update", "Profile information");
    trigger_event("user_logout", "Alice");
    
    return 0;
}
```

## Summary

In this chapter, you've learned about:

1. **Recursive Functions**: Functions that call themselves to solve problems
2. **Variable Argument Functions**: Functions that accept a variable number of parameters
3. **Inline Functions**: C99 feature for potential performance optimization
4. **Function Pointers**: Variables that store function addresses
5. **Higher-Order Functions**: Functions that work with other functions
6. **Callback Functions**: Functions passed as parameters to other functions
7. **Best Practices**: Writing safe and efficient advanced functions
8. **Common Pitfalls**: Avoiding typical errors with advanced functions

Advanced functions provide powerful mechanisms for creating flexible, efficient, and maintainable C programs. These concepts are essential for implementing complex algorithms, building extensible systems, and leveraging the full power of the C language. In the next chapter, we'll explore modular programming techniques that build upon these advanced function concepts.