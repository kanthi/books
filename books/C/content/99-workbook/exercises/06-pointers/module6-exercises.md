# Module 6: Pointers Exercises

## Exercise 1: Basic Pointer Operations
Write a program that demonstrates fundamental pointer operations:
- Declare and initialize pointers to different data types
- Perform pointer arithmetic (increment, decrement, addition, subtraction)
- Dereference pointers to modify values
- Swap two variables using pointers
- Calculate the distance between two pointers

**Requirements:**
- Use proper pointer declarations and initialization
- Demonstrate pointer arithmetic with different data types
- Include bounds checking to prevent invalid memory access
- Provide clear output showing address and value changes
- Handle NULL pointer checks appropriately

## Exercise 2: Pointers and Arrays
Create a program that explores the relationship between pointers and arrays:
- Access array elements using pointer notation
- Pass arrays to functions using pointer parameters
- Implement array traversal using pointers
- Demonstrate pointer arithmetic as array indexing
- Compare performance of array indexing vs pointer arithmetic

**Requirements:**
- Implement functions that accept array parameters as pointers
- Show equivalent operations using array and pointer notation
- Include examples with multi-dimensional arrays
- Handle array bounds properly
- Provide timing comparisons where relevant

## Exercise 3: Dynamic Memory Allocation
Develop a program that demonstrates dynamic memory management:
- Allocate memory for single variables using malloc
- Allocate memory for arrays using malloc and calloc
- Resize allocated memory using realloc
- Free allocated memory properly
- Handle memory allocation failures gracefully

**Requirements:**
- Check return values from all memory allocation functions
- Initialize allocated memory appropriately
- Avoid memory leaks by freeing all allocated memory
- Handle reallocation failures properly
- Include memory usage tracking (bonus)

## Exercise 4: Pointer to Pointers
Write a program that works with pointers to pointers:
- Declare and initialize pointers to pointers
- Modify values through multiple levels of indirection
- Implement a function that allocates memory and returns it through a pointer parameter
- Create a dynamic 2D array using pointers to pointers
- Demonstrate proper cleanup of multi-level allocations

**Requirements:**
- Handle multiple levels of pointer dereferencing correctly
- Include proper error checking at each level
- Free memory in the correct order to prevent leaks
- Document the relationship between levels clearly
- Provide examples of practical use cases

## Exercise 5: Function Pointers
Create a program that demonstrates function pointer usage:
- Declare and initialize function pointers
- Call functions through function pointers
- Implement a simple calculator using function pointers
- Create an array of function pointers for dispatch
- Pass function pointers as parameters to other functions

**Requirements:**
- Use proper function pointer syntax and declarations
- Include error checking for NULL function pointers
- Demonstrate different ways to assign functions to pointers
- Implement callback mechanisms using function pointers
- Provide clear examples of practical applications

## Exercise 6: Advanced Pointer Techniques
Write a program that implements advanced pointer concepts:
- Implement a generic swap function using void pointers
- Create a flexible data structure using void pointers
- Demonstrate pointer casting between different types
- Implement a simple memory pool allocator
- Create a basic garbage collection simulation (bonus)

**Requirements:**
- Handle type safety when working with void pointers
- Include proper casting and alignment considerations
- Implement error checking for invalid operations
- Document memory management strategies clearly
- Provide examples of real-world applications

## Exercise 7: Pointer Debugging and Safety
Create a program that demonstrates safe pointer practices:
- Implement a memory debugging system with allocation tracking
- Create functions to detect common pointer errors
- Demonstrate proper error handling for pointer operations
- Implement a simple smart pointer-like mechanism
- Show techniques for preventing dangling pointers

**Requirements:**
- Include comprehensive error checking
- Handle edge cases and invalid operations gracefully
- Provide meaningful error messages
- Implement cleanup procedures for all resources
- Document safety practices and best approaches

## Exercise 8: Comprehensive Pointer Application
Design a complete application that integrates all pointer concepts:
- Implement a dynamic data structure (linked list, tree, etc.)
- Create a memory management system with custom allocators
- Develop a plugin system using function pointers
- Implement a callback-based event system
- Include comprehensive error handling and resource management

**Requirements:**
- Use modular design with separate functions for each major component
- Include proper documentation for all pointer-related functions
- Handle all memory allocation and deallocation properly
- Implement robust error handling throughout
- Provide clear examples and test cases

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>

// Function to swap two integers using pointers
void swap_int(int *a, int *b) {
    if (a == NULL || b == NULL) {
        printf("Error: NULL pointer passed to swap_int\n");
        return;
    }
    
    int temp = *a;
    *a = *b;
    *b = temp;
}

int main() {
    int x = 10, y = 20;
    int *ptr_x = &x;
    int *ptr_y = &y;
    
    printf("Before swap: x = %d, y = %d\n", x, y);
    printf("Addresses: &x = %p, &y = %p\n", (void*)&x, (void*)&y);
    printf("Pointer values: ptr_x = %p, ptr_y = %p\n", (void*)ptr_x, (void*)ptr_y);
    
    swap_int(ptr_x, ptr_y);
    
    printf("After swap: x = %d, y = %d\n", x, y);
    
    // Pointer arithmetic demonstration
    int arr[] = {1, 2, 3, 4, 5};
    int *ptr = arr;
    
    printf("\nArray elements using pointer arithmetic:\n");
    for (int i = 0; i < 5; i++) {
        printf("Element %d: value = %d, address = %p\n", i, *ptr, (void*)ptr);
        ptr++;
    }
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>

// Function to safely allocate memory
int* safe_malloc_int(int count) {
    if (count <= 0) {
        printf("Error: Invalid count %d\n", count);
        return NULL;
    }
    
    int *ptr = malloc(count * sizeof(int));
    if (ptr == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    // Initialize allocated memory
    for (int i = 0; i < count; i++) {
        ptr[i] = 0;
    }
    
    return ptr;
}

int main() {
    // Allocate memory for 5 integers
    int *dynamic_array = safe_malloc_int(5);
    if (dynamic_array == NULL) {
        return 1;
    }
    
    // Use the allocated memory
    for (int i = 0; i < 5; i++) {
        dynamic_array[i] = (i + 1) * 10;
    }
    
    printf("Dynamic array contents: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", dynamic_array[i]);
    }
    printf("\n");
    
    // Resize the array
    int *resized_array = realloc(dynamic_array, 8 * sizeof(int));
    if (resized_array == NULL) {
        printf("Error: Memory reallocation failed\n");
        free(dynamic_array);
        return 1;
    }
    
    dynamic_array = resized_array;
    
    // Initialize new elements
    for (int i = 5; i < 8; i++) {
        dynamic_array[i] = (i + 1) * 10;
    }
    
    printf("Resized array contents: ");
    for (int i = 0; i < 8; i++) {
        printf("%d ", dynamic_array[i]);
    }
    printf("\n");
    
    // Free allocated memory
    free(dynamic_array);
    dynamic_array = NULL; // Prevent dangling pointer
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Uninitialized pointers**: Always initialize pointers to NULL or valid addresses
2. **Dangling pointers**: Set pointers to NULL after freeing memory
3. **Memory leaks**: Free all allocated memory exactly once
4. **Buffer overruns**: Check bounds before pointer arithmetic
5. **Type mismatches**: Use proper casting when changing pointer types

### Best Practices:
1. **NULL checking**: Always check pointers before dereferencing
2. **Consistent naming**: Use clear naming conventions for pointer variables
3. **Documentation**: Comment pointer usage and ownership clearly
4. **Error handling**: Handle allocation failures gracefully
5. **Resource management**: Follow RAII-like patterns for cleanup

Complete these exercises to solidify your understanding of pointers in C. Each exercise builds upon the previous ones, gradually increasing in complexity.