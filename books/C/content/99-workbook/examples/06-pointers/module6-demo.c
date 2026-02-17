/*
 * Module 6 Demonstration Program
 * This program demonstrates all the key concepts from Module 6:
 * - Pointer fundamentals (declaration, initialization, dereferencing)
 * - Pointers and arrays
 * - Dynamic memory allocation
 * - Advanced pointer concepts (pointer to pointers, function pointers)
 * - Common pointer pitfalls
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include our custom header files
#include "pointer_utils.h"

// Function prototypes for demonstration functions
void demonstrate_pointer_basics(void);
void demonstrate_pointers_arrays(void);
void demonstrate_dynamic_memory(void);
void demonstrate_advanced_pointers(void);
void demonstrate_pointer_pitfalls(void);

// Function for function pointer demonstration
int add(int a, int b) {
    return a + b;
}

int multiply(int a, int b) {
    return a * b;
}

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 6: Pointers Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_pointer_basics();
    demonstrate_pointers_arrays();
    demonstrate_dynamic_memory();
    demonstrate_advanced_pointers();
    demonstrate_pointer_pitfalls();
    
    printf("\n========================================\n");
    printf("  Module 6 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate pointer fundamentals
 */
void demonstrate_pointer_basics() {
    print_separator("Pointer Fundamentals");
    
    // Basic pointer declaration and initialization
    int num = 42;
    int *ptr = &num;
    
    printf("Value of num: %d\n", num);
    printf("Address of num: %p\n", (void*)&num);
    printf("Value of ptr: %p\n", (void*)ptr);
    printf("Value pointed to by ptr: %d\n", *ptr);
    
    // Modifying value through pointer
    *ptr = 100;
    printf("After modifying through pointer, num = %d\n", num);
    
    // Pointer arithmetic
    printf("\nPointer arithmetic:\n");
    int arr[] = {10, 20, 30, 40, 50};
    int *arr_ptr = arr;
    
    printf("arr[0] = %d, *arr_ptr = %d\n", arr[0], *arr_ptr);
    arr_ptr++;
    printf("arr[1] = %d, *arr_ptr = %d\n", arr[1], *arr_ptr);
    
    // Pointer comparison
    int *ptr1 = &arr[0];
    int *ptr2 = &arr[2];
    printf("\nPointer comparison:\n");
    printf("ptr1 < ptr2: %s\n", (ptr1 < ptr2) ? "true" : "false");
    printf("Difference: %ld elements\n", ptr2 - ptr1);
    
    // Using utility functions
    print_separator("Pointer Utility Functions");
    int a = 10, b = 20;
    printf("Before swap: a = %d, b = %d\n", a, b);
    swap_int(&a, &b);
    printf("After swap: a = %d, b = %d\n", a, b);
    
    increment_ptr(&a);
    printf("After incrementing a: a = %d\n", a);
}

/*
 * Demonstrate pointers and arrays
 */
void demonstrate_pointers_arrays() {
    print_separator("Pointers and Arrays");
    
    int arr[] = {5, 10, 15, 20, 25};
    int size = sizeof(arr) / sizeof(arr[0]);
    
    printf("Array elements using array notation: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    printf("Array elements using pointer notation: ");
    print_array_ptr(arr, size);
    
    // Find maximum using pointer
    int *max_ptr = find_max_ptr(arr, size);
    if (max_ptr != NULL) {
        printf("Maximum element: %d at address %p\n", *max_ptr, (void*)max_ptr);
    }
    
    // Pointer to array vs array of pointers
    print_separator("Pointer to Array vs Array of Pointers");
    
    // Pointer to array
    int (*ptr_to_array)[5] = &arr;
    printf("Pointer to array: (*ptr_to_array)[0] = %d\n", (*ptr_to_array)[0]);
    
    // Array of pointers
    int x = 100, y = 200, z = 300;
    int *ptr_array[] = {&x, &y, &z};
    printf("Array of pointers: ");
    for (int i = 0; i < 3; i++) {
        printf("%d ", *ptr_array[i]);
    }
    printf("\n");
}

/*
 * Demonstrate dynamic memory allocation
 */
void demonstrate_dynamic_memory() {
    print_separator("Dynamic Memory Allocation");
    
    // Allocate memory for integer
    int *dynamic_int = (int*)malloc(sizeof(int));
    if (dynamic_int != NULL) {
        *dynamic_int = 42;
        printf("Dynamically allocated integer: %d\n", *dynamic_int);
        free(dynamic_int);
    }
    
    // Allocate memory for array
    int size = 5;
    int *dynamic_array = allocate_array(size);
    if (dynamic_array != NULL) {
        // Initialize array
        for (int i = 0; i < size; i++) {
            dynamic_array[i] = (i + 1) * 10;
        }
        
        printf("Dynamically allocated array: ");
        print_array_ptr(dynamic_array, size);
        
        // Resize array using realloc
        size = 8;
        int *resized_array = (int*)realloc(dynamic_array, size * sizeof(int));
        if (resized_array != NULL) {
            dynamic_array = resized_array;
            // Initialize new elements
            for (int i = 5; i < size; i++) {
                dynamic_array[i] = (i + 1) * 10;
            }
            
            printf("Resized array: ");
            print_array_ptr(dynamic_array, size);
        }
        
        free_array(dynamic_array);
    }
    
    // Allocate memory for 2D array
    print_separator("2D Array Allocation");
    int rows = 3, cols = 4;
    int **matrix = (int**)malloc(rows * sizeof(int*));
    if (matrix != NULL) {
        for (int i = 0; i < rows; i++) {
            matrix[i] = (int*)malloc(cols * sizeof(int));
            if (matrix[i] != NULL) {
                // Initialize matrix
                for (int j = 0; j < cols; j++) {
                    matrix[i][j] = i * cols + j;
                }
            }
        }
        
        printf("2D Matrix:\n");
        for (int i = 0; i < rows; i++) {
            for (int j = 0; j < cols; j++) {
                printf("%3d ", matrix[i][j]);
            }
            printf("\n");
        }
        
        // Free 2D array
        for (int i = 0; i < rows; i++) {
            free(matrix[i]);
        }
        free(matrix);
    }
}

/*
 * Demonstrate advanced pointer concepts
 */
void demonstrate_advanced_pointers() {
    print_separator("Advanced Pointer Concepts");
    
    // Pointer to pointer
    int num = 100;
    int *ptr = &num;
    int **ptr_to_ptr = &ptr;
    
    printf("Value: %d\n", num);
    printf("Value through pointer: %d\n", *ptr);
    printf("Value through pointer to pointer: %d\n", **ptr_to_ptr);
    
    // Function pointers
    print_separator("Function Pointers");
    int (*operation)(int, int);
    
    operation = add;
    printf("Addition using function pointer: 5 + 3 = %d\n", operation(5, 3));
    
    operation = multiply;
    printf("Multiplication using function pointer: 5 * 3 = %d\n", operation(5, 3));
    
    // Array of function pointers
    int (*operations[])(int, int) = {add, multiply};
    const char *op_names[] = {"Add", "Multiply"};
    
    printf("\nArray of function pointers:\n");
    for (int i = 0; i < 2; i++) {
        int result = operations[i](10, 5);
        printf("%s: 10 and 5 = %d\n", op_names[i], result);
    }
    
    // Void pointers
    print_separator("Void Pointers");
    int int_val = 42;
    double double_val = 3.14;
    char char_val = 'A';
    
    void *void_ptr;
    
    void_ptr = &int_val;
    printf("Void pointer to int: %d\n", *(int*)void_ptr);
    
    void_ptr = &double_val;
    printf("Void pointer to double: %.2f\n", *(double*)void_ptr);
    
    void_ptr = &char_val;
    printf("Void pointer to char: %c\n", *(char*)void_ptr);
}

/*
 * Demonstrate common pointer pitfalls
 */
void demonstrate_pointer_pitfalls() {
    print_separator("Common Pointer Pitfalls");
    
    // Uninitialized pointer
    printf("1. Uninitialized pointer:\n");
    int *uninit_ptr; // Dangerous! Contains garbage value
    // *uninit_ptr = 42; // This would cause undefined behavior!
    printf("   Never dereference uninitialized pointers!\n");
    
    // Dangling pointer
    printf("\n2. Dangling pointer:\n");
    int *dangling_ptr = (int*)malloc(sizeof(int));
    if (dangling_ptr != NULL) {
        *dangling_ptr = 100;
        printf("   Value before free: %d\n", *dangling_ptr);
        free(dangling_ptr);
        // dangling_ptr now points to freed memory
        // printf("   Value after free: %d\n", *dangling_ptr); // Undefined behavior!
        dangling_ptr = NULL; // Good practice to set to NULL after freeing
        printf("   Set pointer to NULL after freeing\n");
    }
    
    // Memory leak
    printf("\n3. Memory leak prevention:\n");
    int *leak_ptr = (int*)malloc(sizeof(int));
    if (leak_ptr != NULL) {
        *leak_ptr = 200;
        printf("   Allocated memory: %d\n", *leak_ptr);
        free(leak_ptr); // Always free allocated memory
        leak_ptr = NULL; // Prevent accidental reuse
        printf("   Memory freed properly\n");
    }
    
    // Array bounds
    printf("\n4. Array bounds violation:\n");
    int arr[5] = {1, 2, 3, 4, 5};
    printf("   Array elements: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n   Never access arr[5] or beyond!\n");
}