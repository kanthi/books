/*
 * Module 9 Demonstration Program
 * This program demonstrates all the key concepts from Module 9:
 * - C99 features (inline functions, variable declarations, designated initializers)
 * - C11 features (static assertions, generic selections, anonymous structures)
 * - C17/C23 features (improvements and new features)
 * - Modern C practices (safe programming, best practices)
 * - Advanced preprocessor techniques
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <stdint.h>
#include <math.h>
#include <time.h>

// Include our custom header files
#include "modern_utils.h"

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 9: Modern C Features Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_c99_features();
    demonstrate_c11_features();
    demonstrate_c17_c23_features();
    demonstrate_modern_practices();
    
    printf("\n========================================\n");
    printf("  Module 9 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate C99 features
 */
void demonstrate_c99_features() {
    print_separator("C99 Features");
    
    // Variable declarations anywhere in block
    printf("1. Variable declarations anywhere in block:\n");
    for (int i = 0; i < 3; i++) {
        int square = i * i; // Declared inside for loop
        printf("  %d squared = %d\n", i, square);
    }
    
    // Designated initializers
    printf("\n2. Designated initializers:\n");
    struct {
        int id;
        char name[20];
        double value;
    } item = {
        .id = 100,
        .name = "Sample Item",
        .value = 99.99
    };
    
    printf("  Item: ID=%d, Name=%s, Value=%.2f\n", 
           item.id, item.name, item.value);
    
    // Compound literals
    printf("\n3. Compound literals:\n");
    int *arr = (int[]){1, 2, 3, 4, 5};
    printf("  Array from compound literal: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Flexible array members
    printf("\n4. Flexible array members:\n");
    typedef struct {
        int count;
        double data[]; // Flexible array member
    } FlexArray;
    
    // Allocate memory for structure + array
    size_t size = sizeof(FlexArray) + 3 * sizeof(double);
    FlexArray *flex = (FlexArray*)malloc(size);
    if (flex != NULL) {
        flex->count = 3;
        flex->data[0] = 1.1;
        flex->data[1] = 2.2;
        flex->data[2] = 3.3;
        
        printf("  Flexible array: ");
        for (int i = 0; i < flex->count; i++) {
            printf("%.1f ", flex->data[i]);
        }
        printf("\n");
        
        free(flex);
    }
    
    // Inline functions
    printf("\n5. Inline functions:\n");
    int a = 10, b = 20;
    printf("  Max of %d and %d: %d\n", a, b, max_int(a, b));
    
    // Long long integers
    printf("\n6. Long long integers:\n");
    long long big_number = 123456789012345LL;
    printf("  Long long value: %lld\n", big_number);
    
    // Boolean type
    printf("\n7. Boolean type:\n");
    bool is_valid = true;
    bool is_error = false;
    printf("  is_valid = %s, is_error = %s\n", 
           is_valid ? "true" : "false", 
           is_error ? "true" : "false");
}

/*
 * Demonstrate C11 features
 */
void demonstrate_c11_features() {
    print_separator("C11 Features");
    
    // Static assertions
    printf("1. Static assertions:\n");
    STATIC_ASSERT(sizeof(int) >= 4, "int must be at least 4 bytes");
    printf("  Static assertion passed: int is at least 4 bytes\n");
    
    // Generic selections
    printf("\n2. Generic selections:\n");
    int a = 10, b = 20;
    double x = 1.5, y = 2.5;
    
    printf("  Max of %d and %d: %d\n", a, b, MAX_GENERIC(a, b));
    printf("  Max of %.1f and %.1f: %.1f\n", x, y, MAX_GENERIC(x, y));
    
    // Anonymous structures and unions
    printf("\n3. Anonymous structures and unions:\n");
    struct {
        int type;
        union {
            int int_value;
            double double_value;
            char string_value[20];
        }; // Anonymous union
    } data;
    
    data.type = 1;
    data.int_value = 42;
    printf("  Anonymous union int value: %d\n", data.int_value);
    
    data.type = 2;
    data.double_value = 3.14;
    printf("  Anonymous union double value: %.2f\n", data.double_value);
    
    // Alignment
    printf("\n4. Alignment:\n");
    printf("  Alignment of int: %zu\n", _Alignof(int));
    printf("  Alignment of double: %zu\n", _Alignof(double));
    
    // Noreturn attribute
    printf("\n5. Noreturn attribute:\n");
    printf("  Functions can be marked with _Noreturn to indicate they never return\n");
    
    // Thread-local storage
    printf("\n6. Thread-local storage:\n");
    printf("  Variables can be declared with _Thread_local for thread-specific storage\n");
}

/*
 * Demonstrate C17/C23 features
 */
void demonstrate_c17_c23_features() {
    print_separator("C17/C23 Features");
    
    // C17 is mostly a bug-fix release, so focusing on C23 features
    
    // UTF-8 string literals (C23)
    printf("1. UTF-8 string literals (C23):\n");
    char utf8_string[] = u8"Hello, 世界! 🌍";
    printf("  UTF-8 string: %s\n", utf8_string);
    
    // Binary literals (C23)
    printf("\n2. Binary literals (C23):\n");
    int binary_value = 0b101010; // Binary 101010 = decimal 42
    printf("  Binary 0b101010 = Decimal %d\n", binary_value);
    
    // Digit separators (C23)
    printf("\n3. Digit separators (C23):\n");
    long big_number = 1'000'000'000; // Same as 1000000000
    printf("  1'000'000'000 = %ld\n", big_number);
    
    // nullptr constant (C23)
    printf("\n4. nullptr constant (C23):\n");
    printf("  C23 introduces nullptr as a type-generic null pointer constant\n");
    
    // Auto keyword for type deduction (C23)
    printf("\n5. Auto keyword for type deduction (C23):\n");
    printf("  C23 extends auto to allow type deduction similar to C++\n");
    
    // Enumerations with underlying types (C23)
    printf("\n6. Enumerations with underlying types (C23):\n");
    printf("  C23 allows specifying the underlying type for enumerations\n");
    
    // Attributes (C23)
    printf("\n7. Attributes (C23):\n");
    printf("  C23 introduces standard attributes like [[deprecated]]\n");
}

/*
 * Demonstrate modern C practices
 */
void demonstrate_modern_practices() {
    print_separator("Modern C Practices");
    
    // Safe string functions (if available)
    printf("1. Safe string functions:\n");
    char buffer[50];
    const char *source = "This is a test string";
    
    // Using strncpy with proper null termination
    strncpy(buffer, source, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0'; // Ensure null termination
    printf("  Safe string copy: %s\n", buffer);
    
    // Error handling
    printf("\n2. Error handling:\n");
    FILE *file = fopen("nonexistent.txt", "r");
    if (file == NULL) {
        printf("  Properly handled file open error\n");
    } else {
        fclose(file);
    }
    
    // Resource management
    printf("\n3. Resource management:\n");
    int *dynamic_array = malloc(10 * sizeof(int));
    if (dynamic_array != NULL) {
        // Use the array
        for (int i = 0; i < 10; i++) {
            dynamic_array[i] = i * i;
        }
        
        // Always free allocated memory
        free(dynamic_array);
        dynamic_array = NULL; // Prevent dangling pointer
        printf("  Properly managed dynamic memory\n");
    }
    
    // Const correctness
    printf("\n4. Const correctness:\n");
    const int constant_value = 42;
    printf("  Constant value: %d\n", constant_value);
    
    const char *const_string = "This string is constant";
    printf("  Constant string: %s\n", const_string);
    
    // Size_t for array indexing
    printf("\n5. Size_t for array indexing:\n");
    int array[] = {1, 2, 3, 4, 5};
    size_t array_size = sizeof(array) / sizeof(array[0]);
    
    printf("  Array elements: ");
    for (size_t i = 0; i < array_size; i++) {
        printf("%d ", array[i]);
    }
    printf("\n");
    
    // Boolean logic
    printf("\n6. Boolean logic:\n");
    bool condition1 = true;
    bool condition2 = false;
    
    if (condition1 && !condition2) {
        printf("  Complex boolean expression evaluates to true\n");
    }
    
    // Modern preprocessor
    printf("\n7. Modern preprocessor:\n");
    #define SQUARE(x) ((x) * (x))
    int value = 5;
    printf("  SQUARE(%d) = %d\n", value, SQUARE(value));
    
    // Debug macros
    #ifdef DEBUG
    printf("  Debug mode is enabled\n");
    #else
    printf("  Debug mode is disabled\n");
    #endif
    
    // Static analysis hints
    printf("\n8. Static analysis hints:\n");
    printf("  Using static keyword in function parameters for array size hints\n");
    printf("  Using restrict keyword for pointer aliasing optimization\n");
}