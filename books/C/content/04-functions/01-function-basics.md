# Function Fundamentals

## Introduction

Functions are fundamental building blocks in C programming that allow you to break down complex problems into smaller, manageable pieces. They promote code reusability, modularity, and maintainability by encapsulating specific tasks into named, callable units.

A function in C is a self-contained block of code that performs a specific task and can optionally return a value to the caller. Functions help organize code logically, reduce redundancy, and make programs easier to understand and debug.

This chapter will explore the fundamentals of functions in C, including their definition, declaration, calling mechanisms, and parameter passing.

## What is a Function?

A function is a named block of code that performs a specific task and can be called (invoked) from other parts of the program. Functions have several key characteristics:

1. **Name**: A unique identifier used to call the function
2. **Parameters**: Input values passed to the function
3. **Return Type**: The type of value the function returns (or void if none)
4. **Body**: The code that executes when the function is called

## Function Definition

A function definition specifies what the function does and how it does it. It includes the function's return type, name, parameters, and body.

### Basic Syntax

```c
return_type function_name(parameter_list) {
    // Function body
    // Local variable declarations
    // Statements
    // Return statement (if not void)
}
```

### Simple Function Example

```c
#include <stdio.h>

// Function definition
int add(int a, int b) {
    int sum = a + b;
    return sum;
}

int main() {
    int result = add(5, 3);  // Function call
    printf("5 + 3 = %d\n", result);
    return 0;
}
```

### Function with No Parameters

```c
#include <stdio.h>

void print_greeting() {
    printf("Hello, welcome to C programming!\n");
}

int main() {
    print_greeting();  // Function call with no arguments
    return 0;
}
```

### Function with No Return Value (void)

```c
#include <stdio.h>

void print_line() {
    for (int i = 0; i < 20; i++) {
        printf("-");
    }
    printf("\n");
}

int main() {
    print_line();
    printf("Main Content\n");
    print_line();
    return 0;
}
```

## Function Declaration (Prototypes)

A function declaration (also called a prototype) tells the compiler about a function's name, return type, and parameters without providing the implementation. This allows you to call a function before its definition appears in the code.

### Syntax

```c
return_type function_name(parameter_types);
```

### Function Prototype Example

```c
#include <stdio.h>

// Function prototypes
int multiply(int x, int y);
void print_result(int value);
double calculate_average(double a, double b);

int main() {
    int product = multiply(4, 5);
    print_result(product);
    
    double avg = calculate_average(10.5, 20.3);
    printf("Average: %.2f\n", avg);
    
    return 0;
}

// Function definitions (can appear after main)
int multiply(int x, int y) {
    return x * y;
}

void print_result(int value) {
    printf("Result: %d\n", value);
}

double calculate_average(double a, double b) {
    return (a + b) / 2.0;
}
```

## Function Parameters

Function parameters are variables that receive values when the function is called. C uses "pass by value" for parameter passing, meaning that copies of the actual arguments are passed to the function.

### Parameter Passing by Value

```c
#include <stdio.h>

void modify_value(int x) {
    x = 100;  // Only modifies the local copy
    printf("Inside function: x = %d\n", x);
}

int main() {
    int num = 5;
    printf("Before function call: num = %d\n", num);
    modify_value(num);
    printf("After function call: num = %d\n", num);  // Unchanged
    return 0;
}
```

### Multiple Parameters

```c
#include <stdio.h>

int find_maximum(int a, int b, int c) {
    int max = a;
    if (b > max) max = b;
    if (c > max) max = c;
    return max;
}

void print_student_info(char name[], int age, float gpa) {
    printf("Student: %s\n", name);
    printf("Age: %d\n", age);
    printf("GPA: %.2f\n", gpa);
}

int main() {
    int max_value = find_maximum(10, 25, 15);
    printf("Maximum value: %d\n", max_value);
    
    print_student_info("John Doe", 20, 3.75);
    
    return 0;
}
```

## Return Statements

The `return` statement terminates function execution and optionally returns a value to the caller. For functions with a return type other than `void`, a return statement with a value is required.

### Returning Values

```c
#include <stdio.h>

int square(int n) {
    return n * n;
}

float calculate_area(float radius) {
    const float PI = 3.14159f;
    return PI * radius * radius;
}

char get_grade(int score) {
    if (score >= 90) return 'A';
    else if (score >= 80) return 'B';
    else if (score >= 70) return 'C';
    else if (score >= 60) return 'D';
    else return 'F';
}

int main() {
    printf("Square of 5: %d\n", square(5));
    printf("Area of circle (radius 3): %.2f\n", calculate_area(3.0f));
    printf("Grade for score 85: %c\n", get_grade(85));
    
    return 0;
}
```

### Early Returns

```c
#include <stdio.h>

int absolute_value(int n) {
    if (n < 0) {
        return -n;  // Early return for negative numbers
    }
    return n;  // Return positive numbers as-is
}

int find_factorial(int n) {
    if (n < 0) {
        return -1;  // Error case
    }
    if (n == 0 || n == 1) {
        return 1;  // Base cases
    }
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

int main() {
    printf("Absolute value of -5: %d\n", absolute_value(-5));
    printf("Absolute value of 5: %d\n", absolute_value(5));
    
    printf("Factorial of 5: %d\n", find_factorial(5));
    printf("Factorial of -3: %d\n", find_factorial(-3));  // Error case
    
    return 0;
}
```

## Function Scope and Lifetime

Variables declared inside a function have local scope and exist only during the function's execution.

### Local Variables

```c
#include <stdio.h>

void function_a() {
    int local_var = 10;  // Local to function_a
    printf("In function_a: local_var = %d\n", local_var);
}

void function_b() {
    int local_var = 20;  // Different variable, local to function_b
    printf("In function_b: local_var = %d\n", local_var);
}

int main() {
    function_a();
    function_b();
    
    // printf("%d\n", local_var);  // Error: local_var not accessible here
    
    return 0;
}
```

### Static Local Variables

Static local variables retain their values between function calls:

```c
#include <stdio.h>

void counter() {
    static int count = 0;  // Initialized only once
    count++;
    printf("Function called %d time(s)\n", count);
}

int main() {
    counter();  // Output: Function called 1 time(s)
    counter();  // Output: Function called 2 time(s)
    counter();  // Output: Function called 3 time(s)
    
    return 0;
}
```

## Function Naming Conventions

Following consistent naming conventions improves code readability and maintainability:

### Common Naming Styles

```c
#include <stdio.h>

// Snake case (recommended for C)
int calculate_area_rectangle(int width, int height) {
    return width * height;
}

// Camel case (also acceptable)
int calculateAreaRectangle(int width, int height) {
    return width * height;
}

// Descriptive names
void print_student_information(char student_name[], int student_age) {
    printf("Name: %s, Age: %d\n", student_name, student_age);
}

int main() {
    int area1 = calculate_area_rectangle(5, 10);
    int area2 = calculateAreaRectangle(3, 7);
    
    printf("Area 1: %d\n", area1);
    printf("Area 2: %d\n", area2);
    
    print_student_information("Alice Smith", 22);
    
    return 0;
}
```

## Best Practices for Functions

### 1. Single Responsibility Principle

```c
#include <stdio.h>

// Good: Each function has a single, clear purpose
int calculate_rectangle_area(int width, int height) {
    return width * height;
}

int calculate_rectangle_perimeter(int width, int height) {
    return 2 * (width + height);
}

void print_rectangle_info(int width, int height) {
    printf("Rectangle: %d x %d\n", width, height);
    printf("Area: %d\n", calculate_rectangle_area(width, height));
    printf("Perimeter: %d\n", calculate_rectangle_perimeter(width, height));
}

// Avoid: Function doing multiple unrelated things
/*
int calculate_and_print_rectangle(int width, int height) {
    int area = width * height;
    printf("Area: %d\n", area);
    return area;
}
*/

int main() {
    print_rectangle_info(5, 3);
    return 0;
}
```

### 2. Appropriate Function Size

```c
#include <stdio.h>

// Good: Functions are small and focused
int is_even(int number) {
    return number % 2 == 0;
}

int is_positive(int number) {
    return number > 0;
}

int is_valid_input(int number) {
    return is_positive(number) && is_even(number);
}

// Avoid: Functions that are too long
/*
int process_complex_logic(int a, int b, int c, int d, int e) {
    // 100+ lines of code doing many different things
}
*/

int main() {
    int test_number = 10;
    if (is_valid_input(test_number)) {
        printf("%d is valid input\n", test_number);
    }
    
    return 0;
}
```

### 3. Meaningful Parameter Names

```c
#include <stdio.h>

// Good: Descriptive parameter names
double calculate_triangle_area(double base, double height) {
    return 0.5 * base * height;
}

// Avoid: Generic parameter names
/*
double calculate_triangle_area(double b, double h) {
    return 0.5 * b * h;
}
*/

int main() {
    double area = calculate_triangle_area(10.0, 5.0);
    printf("Triangle area: %.2f\n", area);
    
    return 0;
}
```

## Common Pitfalls and How to Avoid Them

### 1. Missing Return Statements

```c
#include <stdio.h>

// Wrong: Missing return statement in non-void function
/*
int calculate_square(int n) {
    int result = n * n;
    // Missing return statement
}
*/

// Correct: Always include return statement
int calculate_square(int n) {
    int result = n * n;
    return result;
}

int main() {
    int square = calculate_square(5);
    printf("Square of 5: %d\n", square);
    
    return 0;
}
```

### 2. Using Uninitialized Variables

```c
#include <stdio.h>

// Wrong: Using uninitialized local variable
/*
int add_numbers(int a, int b) {
    int sum;  // Not initialized
    sum = sum + a + b;  // Using uninitialized variable
    return sum;
}
*/

// Correct: Initialize variables properly
int add_numbers(int a, int b) {
    int sum = 0;  // Properly initialized
    sum = sum + a + b;
    return sum;
}

int main() {
    int result = add_numbers(3, 4);
    printf("3 + 4 = %d\n", result);
    
    return 0;
}
```

### 3. Function Declaration vs Definition Mismatch

```c
#include <stdio.h>

// Function prototype
int multiply(int x, int y);

int main() {
    int result = multiply(5, 3);
    printf("5 * 3 = %d\n", result);
    return 0;
}

// Correct: Definition matches prototype
int multiply(int x, int y) {
    return x * y;
}

// Wrong: Definition doesn't match prototype
/*
int multiply(int a, int b) {  // Different parameter names are OK
    return a * b;
}
// But different types or number of parameters would be wrong
*/
```

## Practical Examples

### Temperature Converter Functions

```c
#include <stdio.h>

// Function prototypes
double celsius_to_fahrenheit(double celsius);
double fahrenheit_to_celsius(double fahrenheit);
void print_temperature_conversion(double celsius, double fahrenheit);

// Convert Celsius to Fahrenheit
double celsius_to_fahrenheit(double celsius) {
    return (celsius * 9.0 / 5.0) + 32.0;
}

// Convert Fahrenheit to Celsius
double fahrenheit_to_celsius(double fahrenheit) {
    return (fahrenheit - 32.0) * 5.0 / 9.0;
}

// Print temperature conversion
void print_temperature_conversion(double celsius, double fahrenheit) {
    printf("%.2f°C = %.2f°F\n", celsius, fahrenheit);
    printf("%.2f°F = %.2f°C\n", fahrenheit, celsius_to_fahrenheit(fahrenheit));
}

int main() {
    double c_temp = 25.0;
    double f_temp = 77.0;
    
    double c_to_f = celsius_to_fahrenheit(c_temp);
    double f_to_c = fahrenheit_to_celsius(f_temp);
    
    printf("Temperature Conversions:\n");
    print_temperature_conversion(c_temp, f_temp);
    
    return 0;
}
```

### Mathematical Utility Functions

```c
#include <stdio.h>

// Function prototypes
int power(int base, int exponent);
int factorial(int n);
int gcd(int a, int b);
int lcm(int a, int b);

// Calculate power (base^exponent)
int power(int base, int exponent) {
    if (exponent < 0) return 0;  // Handle negative exponents
    if (exponent == 0) return 1;
    
    int result = 1;
    for (int i = 0; i < exponent; i++) {
        result *= base;
    }
    return result;
}

// Calculate factorial
int factorial(int n) {
    if (n < 0) return -1;  // Error for negative numbers
    if (n == 0 || n == 1) return 1;
    
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

// Calculate Greatest Common Divisor
int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Calculate Least Common Multiple
int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

int main() {
    printf("Mathematical Utilities:\n");
    printf("2^8 = %d\n", power(2, 8));
    printf("5! = %d\n", factorial(5));
    printf("GCD of 48 and 18 = %d\n", gcd(48, 18));
    printf("LCM of 12 and 18 = %d\n", lcm(12, 18));
    
    return 0;
}
```

### String Processing Functions

```c
#include <stdio.h>
#include <string.h>

// Function prototypes
int string_length(char str[]);
void string_copy(char dest[], char src[]);
int string_compare(char str1[], char str2[]);
void string_reverse(char str[]);

// Calculate string length
int string_length(char str[]) {
    int length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length;
}

// Copy string
void string_copy(char dest[], char src[]) {
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';  // Null terminate
}

// Compare strings
int string_compare(char str1[], char str2[]) {
    int i = 0;
    while (str1[i] != '\0' && str2[i] != '\0') {
        if (str1[i] != str2[i]) {
            return str1[i] - str2[i];
        }
        i++;
    }
    return str1[i] - str2[i];
}

// Reverse string
void string_reverse(char str[]) {
    int length = string_length(str);
    for (int i = 0; i < length / 2; i++) {
        char temp = str[i];
        str[i] = str[length - 1 - i];
        str[length - 1 - i] = temp;
    }
}

int main() {
    char str1[100] = "Hello";
    char str2[100] = "World";
    char str3[100];
    
    printf("String Processing Examples:\n");
    printf("Length of '%s': %d\n", str1, string_length(str1));
    
    string_copy(str3, str1);
    printf("Copied string: %s\n", str3);
    
    printf("Comparison '%s' vs '%s': %d\n", str1, str2, string_compare(str1, str2));
    
    printf("Original: %s\n", str1);
    string_reverse(str1);
    printf("Reversed: %s\n", str1);
    
    return 0;
}
```

## Summary

In this chapter, you've learned about:

1. **Function Basics**: What functions are and why they're important
2. **Function Definition**: How to define functions with proper syntax
3. **Function Declaration**: Using prototypes to declare functions before use
4. **Parameter Passing**: How C passes parameters by value
5. **Return Statements**: Using return to send values back to callers
6. **Scope and Lifetime**: Understanding variable scope in functions
7. **Best Practices**: Writing clean, maintainable functions
8. **Common Pitfalls**: Avoiding typical function-related errors

Functions are essential for organizing code into logical, reusable components. In the next chapter, we'll explore advanced function concepts including recursion, variable arguments, and function pointers.