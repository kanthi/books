/*
 * Module 4 Demonstration Program
 * This program demonstrates all the key concepts from Module 4:
 * - Function fundamentals (definition, declaration, parameters, return values)
 * - Advanced function concepts (recursion, variable arguments, inline functions, function pointers)
 * - Modular programming (header files, compilation units, linkage)
 * - Standard library functions
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <ctype.h>
#include <time.h>
#include <stdarg.h>
#include <setjmp.h>

// Include our custom header files
#include "math_utils.h"
#include "string_utils.h"

// Function prototypes for demonstration functions
void demonstrate_function_basics(void);
void demonstrate_advanced_functions(void);
void demonstrate_modular_programming(void);
void demonstrate_standard_library(void);

// Helper functions for demonstrations
static void print_separator(const char *title);
static double calculate_average(int count, ...);
static void apply_operation(int a, int b, int (*operation)(int, int));
static int compare_ints(const void *a, const void *b);

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 4: Functions and Modular Programming Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_function_basics();
    demonstrate_advanced_functions();
    demonstrate_modular_programming();
    demonstrate_standard_library();
    
    printf("\n========================================\n");
    printf("  Module 4 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Helper function to print section separators
 */
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Demonstrate function fundamentals
 */
void demonstrate_function_basics() {
    print_separator("Function Fundamentals");
    
    // Basic function calls
    int x = 10, y = 5;
    int sum = add(x, y);
    int difference = subtract(x, y);
    int product = multiply(x, y);
    double quotient = divide((double)x, (double)y);
    
    printf("Basic arithmetic operations:\n");
    printf("  %d + %d = %d\n", x, y, sum);
    printf("  %d - %d = %d\n", x, y, difference);
    printf("  %d * %d = %d\n", x, y, product);
    printf("  %.1f / %.1f = %.2f\n", (double)x, (double)y, quotient);
    
    // Function with no parameters
    print_current_time();
    
    // Function with array parameter
    int numbers[] = {1, 2, 3, 4, 5};
    int array_sum = sum_array(numbers, 5);
    printf("  Sum of array {1,2,3,4,5} = %d\n", array_sum);
    
    // Function returning array (through pointer)
    int *fib_sequence = generate_fibonacci(10);
    if (fib_sequence != NULL) {
        printf("  First 10 Fibonacci numbers: ");
        for (int i = 0; i < 10; i++) {
            printf("%d ", fib_sequence[i]);
        }
        printf("\n");
        free(fib_sequence);  // Don't forget to free allocated memory
    }
}

/*
 * Demonstrate advanced function concepts
 */
void demonstrate_advanced_functions() {
    print_separator("Advanced Function Concepts");
    
    // Recursion
    printf("Recursive functions:\n");
    printf("  Factorial of 5: %d\n", factorial(5));
    printf("  Fibonacci of 10: %d\n", fibonacci(10));
    
    // Variable arguments
    printf("\nVariable argument functions:\n");
    double avg1 = calculate_average(3, 10.0, 20.0, 30.0);
    double avg2 = calculate_average(5, 1.0, 2.0, 3.0, 4.0, 5.0);
    printf("  Average of 10, 20, 30: %.2f\n", avg1);
    printf("  Average of 1, 2, 3, 4, 5: %.2f\n", avg2);
    
    // Inline function (if supported by compiler)
    int a = 15, b = 25;
    int max_val = max(a, b);
    int min_val = min(a, b);
    printf("\nInline functions:\n");
    printf("  Max of %d and %d: %d\n", a, b, max_val);
    printf("  Min of %d and %d: %d\n", a, b, min_val);
    
    // Function pointers
    printf("\nFunction pointers:\n");
    apply_operation(10, 5, add);
    apply_operation(10, 5, subtract);
    apply_operation(10, 5, multiply);
    
    // Function pointer array
    int (*operations[])(int, int) = {add, subtract, multiply, divide_int};
    const char *op_names[] = {"+", "-", "*", "/"};
    
    printf("\nFunction pointer array:\n");
    for (int i = 0; i < 4; i++) {
        int result = operations[i](20, 4);
        printf("  20 %s 4 = %d\n", op_names[i], result);
    }
}

/*
 * Helper function for variable arguments demonstration
 */
static double calculate_average(int count, ...) {
    va_list args;
    va_start(args, count);
    
    double sum = 0.0;
    for (int i = 0; i < count; i++) {
        double value = va_arg(args, double);
        sum += value;
    }
    
    va_end(args);
    return sum / count;
}

/*
 * Helper function for function pointer demonstration
 */
static void apply_operation(int a, int b, int (*operation)(int, int)) {
    int result = operation(a, b);
    printf("  Operation result: %d\n", result);
}

/*
 * Demonstrate modular programming concepts
 */
void demonstrate_modular_programming() {
    print_separator("Modular Programming");
    
    // Using functions from our custom modules
    printf("Using custom math utilities:\n");
    printf("  Is 17 prime? %s\n", is_prime(17) ? "Yes" : "No");
    printf("  GCD of 48 and 18: %d\n", gcd(48, 18));
    printf("  LCM of 12 and 18: %d\n", lcm(12, 18));
    
    // Using string utilities
    char text[] = "Hello, World!";
    printf("\nUsing custom string utilities:\n");
    printf("  Original text: %s\n", text);
    printf("  Reversed text: %s\n", reverse_string(text));
    printf("  Uppercase text: %s\n", to_uppercase(text));
    
    // Demonstrating static functions (internal linkage)
    printf("\nStatic functions (internal linkage):\n");
    printf("  Internal counter value: %d\n", get_internal_counter());
    increment_internal_counter();
    printf("  After increment: %d\n", get_internal_counter());
    
    // Demonstrating include guards
    printf("\nInclude guards prevent multiple inclusions\n");
    printf("  MAX(10, 20) = %d\n", MAX(10, 20));
    printf("  MIN(10, 20) = %d\n", MIN(10, 20));
}

/*
 * Demonstrate standard library functions
 */
void demonstrate_standard_library() {
    print_separator("Standard Library Functions");
    
    // String functions
    printf("String functions:\n");
    char str1[50] = "Hello, ";
    char str2[] = "World!";
    strcat(str1, str2);
    printf("  Concatenated string: %s\n", str1);
    
    // String comparison
    if (strcmp(str1, "Hello, World!") == 0) {
        printf("  Strings are equal\n");
    }
    
    // String searching
    char *found = strstr(str1, "World");
    if (found) {
        printf("  Found 'World' at position: %ld\n", found - str1);
    }
    
    // String length
    printf("  Length of '%s': %lu\n", str1, strlen(str1));
    
    // Mathematical functions
    printf("\nMathematical functions:\n");
    double x = 16.0;
    printf("  Square root of %.1f: %.2f\n", x, sqrt(x));
    printf("  Absolute value of -5.5: %.1f\n", fabs(-5.5));
    printf("  Ceiling of 3.2: %.1f\n", ceil(3.2));
    printf("  Floor of 3.8: %.1f\n", floor(3.8));
    
    // Character functions
    printf("\nCharacter functions:\n");
    char ch = 'A';
    printf("  Character '%c' is %s letter\n", ch, isalpha(ch) ? "an alphabetic" : "not an alphabetic");
    printf("  '%c' in lowercase: '%c'\n", ch, tolower(ch));
    
    // Time functions
    printf("\nTime functions:\n");
    time_t rawtime;
    time(&rawtime);
    printf("  Current time: %s", ctime(&rawtime));
    
    // Memory functions
    printf("\nMemory functions:\n");
    int arr1[] = {1, 2, 3, 4, 5};
    int arr2[5];
    memcpy(arr2, arr1, sizeof(arr1));
    printf("  Copied array: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr2[i]);
    }
    printf("\n");
    
    // Memory setting
    memset(arr2, 0, sizeof(arr2));
    printf("  Zeroed array: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr2[i]);
    }
    printf("\n");
    
    // Memory comparison
    int arr3[] = {1, 2, 3};
    int arr4[] = {1, 2, 3};
    if (memcmp(arr3, arr4, sizeof(arr3)) == 0) {
        printf("  Arrays are identical\n");
    }
    
    // Memory searching
    int arr5[] = {10, 20, 30, 40, 50};
    int *found_ptr = memchr(arr5, 30, sizeof(arr5));
    if (found_ptr) {
        printf("  Found 30 at index: %ld\n", found_ptr - arr5);
    }
    
    // Utility functions
    printf("\nUtility functions:\n");
    char num_str[] = "123";
    int num = atoi(num_str);
    printf("  String '%s' to integer: %d\n", num_str, num);
    
    // Random number generation
    srand((unsigned int)time(NULL));
    printf("  Random numbers: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", rand() % 100);
    }
    printf("\n");
    
    // Searching and sorting
    printf("\nSearching and sorting:\n");
    int arr6[] = {5, 2, 8, 1, 9, 3};
    int search_key = 8;
    int *result = bsearch(&search_key, arr6, 6, sizeof(int), compare_ints);
    if (result) {
        printf("  Found %d in array\n", search_key);
    } else {
        printf("  %d not found in array\n", search_key);
    }
    
    // Sort the array
    qsort(arr6, 6, sizeof(int), compare_ints);
    printf("  Sorted array: ");
    for (int i = 0; i < 6; i++) {
        printf("%d ", arr6[i]);
    }
    printf("\n");
}

/*
 * Helper function for qsort and bsearch
 */
static int compare_ints(const void *a, const void *b) {
    int int_a = *(const int *)a;
    int int_b = *(const int *)b;
    
    if (int_a == int_b) return 0;
    else if (int_a < int_b) return -1;
    else return 1;
}