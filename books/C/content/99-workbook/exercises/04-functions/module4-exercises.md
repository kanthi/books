# Module 4: Functions and Modular Programming Exercises

## Exercise 1: Basic Function Implementation
Write a program that implements several mathematical functions:
- A function to calculate the area of different shapes (circle, rectangle, triangle)
- A function to convert temperatures between Celsius and Fahrenheit
- A function to calculate compound interest
- A function to determine if a year is a leap year

**Requirements:**
- Use proper function declarations and definitions
- Include appropriate header files
- Handle edge cases and invalid inputs
- Provide clear function documentation
- Use const parameters where appropriate

## Exercise 2: Recursive Functions
Create a program that implements various recursive algorithms:
- Factorial calculation with error handling
- Fibonacci sequence with memoization
- Binary search on a sorted array
- Tower of Hanoi solution
- Greatest Common Divisor (GCD) using Euclidean algorithm

**Requirements:**
- Implement proper base cases to prevent infinite recursion
- Handle negative inputs appropriately
- Include performance timing for comparison with iterative versions
- Document recursion depth limitations
- Provide clear output showing the recursive process

## Exercise 3: Variable Argument Functions
Develop a program that demonstrates variable argument functions:
- A function that calculates the average of a variable number of integers
- A function that finds the maximum value among variable arguments
- A formatted print function similar to printf
- A function that concatenates a variable number of strings

**Requirements:**
- Use stdarg.h for variable argument handling
- Implement proper argument counting and type checking
- Handle memory allocation for string concatenation
- Include error handling for invalid arguments
- Provide examples with different numbers of arguments

## Exercise 4: Function Pointers and Callbacks
Create a program that uses function pointers for various purposes:
- A calculator that uses function pointers for operations
- A sorting function that accepts a comparison function pointer
- A filter function that applies a predicate to an array
- A state machine implementation using function pointers

**Requirements:**
- Implement function pointer arrays for dispatch tables
- Create callback mechanisms for event handling
- Demonstrate function pointer casting
- Include error handling for null function pointers
- Provide clear examples of different use cases

## Exercise 5: Modular Programming with Multiple Files
Design and implement a complete module system:
- Create a statistics library with header and source files
- Implement a string processing module
- Create a configuration management module
- Develop a logging system module
- Write a main program that uses all modules

**Requirements:**
- Use proper include guards in header files
- Separate interface from implementation
- Demonstrate static and external linkage
- Include Makefile or build script for compilation
- Document module dependencies and usage

## Exercise 6: Inline Functions and Macro Functions
Write a program that compares inline functions with macro functions:
- Implement mathematical operations as both inline functions and macros
- Create performance benchmarks for both approaches
- Demonstrate side effects with macros
- Show type safety differences between approaches
- Implement conditional compilation for different optimization levels

**Requirements:**
- Use appropriate compiler flags for inline function support
- Include timing measurements for performance comparison
- Demonstrate macro pitfalls with complex expressions
- Show how inline functions provide type checking
- Document when to use each approach

## Exercise 7: Standard Library Function Practice
Create a comprehensive program that uses various standard library functions:
- String manipulation with functions from string.h
- Mathematical calculations with functions from math.h
- Time and date processing with functions from time.h
- Memory management with functions from stdlib.h
- Character classification with functions from ctype.h

**Requirements:**
- Demonstrate proper error handling for library functions
- Include examples of common pitfalls and how to avoid them
- Show memory management best practices
- Implement proper buffer size checking
- Provide clear output showing function results

## Exercise 8: Advanced Modular Programming
Design a complete application using advanced modular programming techniques:
- Implement an opaque pointer design pattern
- Create a plugin system using dynamic loading (if supported)
- Develop a configuration system with multiple backends
- Implement a thread-safe module with proper synchronization
- Create a unit testing framework for your modules

**Requirements:**
- Use advanced features like function pointers for polymorphism
- Implement proper error handling and resource cleanup
- Include documentation for module interfaces
- Demonstrate proper separation of concerns
- Provide examples of module extensibility

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <math.h>

#define PI 3.14159265359

// Function to calculate area of circle
double circle_area(double radius) {
    if (radius < 0) {
        printf("Error: Radius cannot be negative\n");
        return -1;
    }
    return PI * radius * radius;
}

// Function to calculate area of rectangle
double rectangle_area(double length, double width) {
    if (length < 0 || width < 0) {
        printf("Error: Dimensions cannot be negative\n");
        return -1;
    }
    return length * width;
}

// Function to calculate area of triangle
double triangle_area(double base, double height) {
    if (base < 0 || height < 0) {
        printf("Error: Dimensions cannot be negative\n");
        return -1;
    }
    return 0.5 * base * height;
}

// Function to convert Celsius to Fahrenheit
double celsius_to_fahrenheit(double celsius) {
    return (celsius * 9.0 / 5.0) + 32.0;
}

// Function to convert Fahrenheit to Celsius
double fahrenheit_to_celsius(double fahrenheit) {
    return (fahrenheit - 32.0) * 5.0 / 9.0;
}

// Function to calculate compound interest
double compound_interest(double principal, double rate, int time) {
    if (principal < 0 || rate < 0 || time < 0) {
        printf("Error: Invalid parameters\n");
        return -1;
    }
    return principal * pow(1 + rate / 100.0, time);
}

// Function to check if a year is a leap year
int is_leap_year(int year) {
    if (year % 400 == 0) return 1;
    if (year % 100 == 0) return 0;
    if (year % 4 == 0) return 1;
    return 0;
}

int main() {
    // Test area calculations
    printf("Circle area (radius 5): %.2f\n", circle_area(5));
    printf("Rectangle area (5x3): %.2f\n", rectangle_area(5, 3));
    printf("Triangle area (base 4, height 6): %.2f\n", triangle_area(4, 6));
    
    // Test temperature conversion
    printf("25°C = %.1f°F\n", celsius_to_fahrenheit(25));
    printf("77°F = %.1f°C\n", fahrenheit_to_celsius(77));
    
    // Test compound interest
    printf("Compound interest ($1000, 5%%, 10 years): $%.2f\n", 
           compound_interest(1000, 5, 10));
    
    // Test leap year
    printf("2024 is %s a leap year\n", is_leap_year(2024) ? "" : "not");
    printf("1900 is %s a leap year\n", is_leap_year(1900) ? "" : "not");
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <time.h>

// Simple recursive factorial
long long factorial(int n) {
    if (n < 0) {
        printf("Error: Factorial of negative number\n");
        return -1;
    }
    if (n == 0 || n == 1) return 1;
    return n * factorial(n - 1);
}

// Fibonacci with memoization
long long fib_memo[100] = {0};

long long fibonacci_memo(int n) {
    if (n < 0) {
        printf("Error: Invalid Fibonacci index\n");
        return -1;
    }
    if (n <= 1) return n;
    
    if (fib_memo[n] != 0) return fib_memo[n];
    
    fib_memo[n] = fibonacci_memo(n - 1) + fibonacci_memo(n - 2);
    return fib_memo[n];
}

// Binary search recursive implementation
int binary_search_recursive(int arr[], int left, int right, int target) {
    if (left > right) return -1;  // Not found
    
    int mid = left + (right - left) / 2;
    
    if (arr[mid] == target) return mid;
    if (arr[mid] > target) {
        return binary_search_recursive(arr, left, mid - 1, target);
    } else {
        return binary_search_recursive(arr, mid + 1, right, target);
    }
}

// Tower of Hanoi
void tower_of_hanoi(int n, char from, char to, char aux) {
    if (n == 1) {
        printf("Move disk 1 from %c to %c\n", from, to);
        return;
    }
    
    tower_of_hanoi(n - 1, from, aux, to);
    printf("Move disk %d from %c to %c\n", n, from, to);
    tower_of_hanoi(n - 1, aux, to, from);
}

// GCD using Euclidean algorithm
int gcd_recursive(int a, int b) {
    if (b == 0) return a;
    return gcd_recursive(b, a % b);
}

int main() {
    // Test factorial
    printf("Factorial of 5: %lld\n", factorial(5));
    
    // Test Fibonacci with memoization
    for (int i = 0; i < 10; i++) {
        printf("Fibonacci(%d) = %lld\n", i, fibonacci_memo(i));
    }
    
    // Test binary search
    int arr[] = {1, 3, 5, 7, 9, 11, 13, 15};
    int target = 7;
    int index = binary_search_recursive(arr, 0, 7, target);
    if (index != -1) {
        printf("Found %d at index %d\n", target, index);
    } else {
        printf("%d not found\n", target);
    }
    
    // Test Tower of Hanoi
    printf("\nTower of Hanoi (3 disks):\n");
    tower_of_hanoi(3, 'A', 'C', 'B');
    
    // Test GCD
    printf("\nGCD of 48 and 18: %d\n", gcd_recursive(48, 18));
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <stdarg.h>
#include <string.h>
#include <stdlib.h>

// Function to calculate average of variable integers
double average_ints(int count, ...) {
    if (count <= 0) {
        printf("Error: Invalid count\n");
        return 0;
    }
    
    va_list args;
    va_start(args, count);
    
    int sum = 0;
    for (int i = 0; i < count; i++) {
        sum += va_arg(args, int);
    }
    
    va_end(args);
    return (double)sum / count;
}

// Function to find maximum among variable arguments
int max_ints(int count, ...) {
    if (count <= 0) {
        printf("Error: Invalid count\n");
        return 0;
    }
    
    va_list args;
    va_start(args, count);
    
    int max = va_arg(args, int);
    for (int i = 1; i < count; i++) {
        int current = va_arg(args, int);
        if (current > max) max = current;
    }
    
    va_end(args);
    return max;
}

// Function to concatenate variable strings
char* concat_strings(int count, ...) {
    if (count <= 0) {
        printf("Error: Invalid count\n");
        return NULL;
    }
    
    // First pass: calculate total length
    va_list args;
    va_start(args, count);
    
    int total_length = 0;
    for (int i = 0; i < count; i++) {
        const char* str = va_arg(args, const char*);
        if (str) total_length += strlen(str);
    }
    
    va_end(args);
    
    // Allocate memory for result
    char* result = (char*)malloc(total_length + 1);
    if (!result) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    // Second pass: concatenate strings
    result[0] = '\0';
    va_start(args, count);
    
    for (int i = 0; i < count; i++) {
        const char* str = va_arg(args, const char*);
        if (str) strcat(result, str);
    }
    
    va_end(args);
    return result;
}

int main() {
    // Test average function
    printf("Average of 1, 2, 3, 4, 5: %.2f\n", 
           average_ints(5, 1, 2, 3, 4, 5));
    
    // Test maximum function
    printf("Maximum of 10, 25, 7, 33, 15: %d\n", 
           max_ints(5, 10, 25, 7, 33, 15));
    
    // Test string concatenation
    char* result = concat_strings(4, "Hello", " ", "World", "!");
    if (result) {
        printf("Concatenated string: %s\n", result);
        free(result);
    }
    
    return 0;
}
```

### Exercise 4 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>

// Calculator operations
int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return b != 0 ? a / b : 0; }

// Calculator using function pointers
int calculate(int a, int b, int (*operation)(int, int)) {
    if (operation == NULL) {
        printf("Error: Invalid operation\n");
        return 0;
    }
    return operation(a, b);
}

// Comparison functions for sorting
int compare_ascending(const void *a, const void *b) {
    int int_a = *(const int*)a;
    int int_b = *(const int*)b;
    return (int_a > int_b) - (int_a < int_b);
}

int compare_descending(const void *a, const void *b) {
    int int_a = *(const int*)a;
    int int_b = *(const int*)b;
    return (int_b > int_a) - (int_b < int_a);
}

// Generic sorting function with comparison function pointer
void sort_array(int *arr, int size, int (*compare)(const void*, const void*)) {
    if (arr == NULL || compare == NULL) {
        printf("Error: Invalid parameters\n");
        return;
    }
    qsort(arr, size, sizeof(int), compare);
}

// Filter function with predicate
int* filter_array(int *arr, int size, int (*predicate)(int), int *result_size) {
    if (arr == NULL || predicate == NULL || result_size == NULL) {
        printf("Error: Invalid parameters\n");
        return NULL;
    }
    
    int *result = (int*)malloc(size * sizeof(int));
    if (!result) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    *result_size = 0;
    for (int i = 0; i < size; i++) {
        if (predicate(arr[i])) {
            result[*result_size] = arr[i];
            (*result_size)++;
        }
    }
    
    return result;
}

// Predicate functions
int is_even(int n) { return n % 2 == 0; }
int is_positive(int n) { return n > 0; }
int is_greater_than_10(int n) { return n > 10; }

int main() {
    // Test calculator with function pointers
    printf("Calculator using function pointers:\n");
    printf("10 + 5 = %d\n", calculate(10, 5, add));
    printf("10 - 5 = %d\n", calculate(10, 5, subtract));
    printf("10 * 5 = %d\n", calculate(10, 5, multiply));
    printf("10 / 5 = %d\n", calculate(10, 5, divide));
    
    // Test sorting with function pointers
    int arr[] = {5, 2, 8, 1, 9, 3};
    int size = sizeof(arr) / sizeof(arr[0]);
    
    printf("\nOriginal array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    
    sort_array(arr, size, compare_ascending);
    printf("\nSorted ascending: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    
    sort_array(arr, size, compare_descending);
    printf("\nSorted descending: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    
    // Test filter function
    int numbers[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12};
    int num_size = sizeof(numbers) / sizeof(numbers[0]);
    int filtered_size;
    
    int *evens = filter_array(numbers, num_size, is_even, &filtered_size);
    if (evens) {
        printf("\n\nEven numbers: ");
        for (int i = 0; i < filtered_size; i++) {
            printf("%d ", evens[i]);
        }
        free(evens);
    }
    
    int *greater_than_10 = filter_array(numbers, num_size, is_greater_than_10, &filtered_size);
    if (greater_than_10) {
        printf("\nNumbers > 10: ");
        for (int i = 0; i < filtered_size; i++) {
            printf("%d ", greater_than_10[i]);
        }
        free(greater_than_10);
    }
    
    printf("\n");
    return 0;
}
```

## Common Pitfalls to Avoid

1. **Infinite Recursion**: Always ensure proper base cases
2. **Memory Leaks**: Free dynamically allocated memory
3. **Null Pointer Dereference**: Always check function pointer validity
4. **Buffer Overflows**: Ensure adequate buffer sizes for string operations
5. **Variable Argument Misuse**: Properly count and type-check variable arguments
6. **Linkage Issues**: Understand static vs. external linkage
7. **Include Guard Problems**: Use proper include guards to prevent multiple inclusions
8. **Macro Side Effects**: Be careful with complex expressions in macros
9. **Integer Overflow**: Check for overflow in mathematical operations
10. **Resource Cleanup**: Always clean up resources in error paths

## Compilation Tips
```bash
# Basic compilation with multiple source files
gcc main.c math_utils.c string_utils.c -o program

# With math library for mathematical functions
gcc main.c math_utils.c -lm -o program

# With warnings enabled
gcc -Wall -Wextra main.c math_utils.c -o program

# With debugging information
gcc -g -Wall main.c math_utils.c -o program

# With optimization
gcc -O2 main.c math_utils.c -o program

# Creating object files separately
gcc -c math_utils.c -o math_utils.o
gcc -c string_utils.c -o string_utils.o
gcc main.c math_utils.o string_utils.o -o program
```

Complete these exercises to solidify your understanding of Module 4 concepts. Each exercise builds upon the previous ones, gradually increasing in complexity.