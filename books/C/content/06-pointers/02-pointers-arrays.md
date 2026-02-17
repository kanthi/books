# Pointers and Arrays

## Introduction

One of the most important relationships in C programming is between pointers and arrays. In fact, arrays and pointers are closely related concepts, with arrays often being treated as pointers in many contexts. Understanding this relationship is crucial for effective C programming, as it enables efficient array manipulation, dynamic memory allocation, and implementation of complex data structures.

## Array-Pointer Equivalence

### Arrays as Pointers
In most contexts, an array name is treated as a pointer to its first element:

```c
int arr[5] = {10, 20, 30, 40, 50};

// These are equivalent:
int *ptr1 = arr;        // Array name decays to pointer
int *ptr2 = &arr[0];    // Explicit address of first element

printf("arr[0] = %d, *ptr1 = %d, *ptr2 = %d\n", arr[0], *ptr1, *ptr2);
```

### Important Distinction
While arrays and pointers are often interchangeable, they are not identical:

```c
int arr[5] = {1, 2, 3, 4, 5};
int *ptr = arr;

// Arrays have fixed size
sizeof(arr);  // Returns 20 bytes (5 * sizeof(int))

// Pointers have size of address
sizeof(ptr);  // Returns 8 bytes on 64-bit system (size of pointer)

// Arrays cannot be reassigned
// arr = ptr;  // Error: Cannot assign to array

// Pointers can be reassigned
ptr = &arr[2];  // OK: Pointer can be changed
```

## Pointer Subscripting

### Using Pointers as Arrays
Pointers can be used with array subscript notation:

```c
int arr[5] = {10, 20, 30, 40, 50};
int *ptr = arr;

// These are equivalent:
printf("arr[2] = %d\n", arr[2]);
printf("ptr[2] = %d\n", ptr[2]);
printf("*(arr + 2) = %d\n", *(arr + 2));
printf("*(ptr + 2) = %d\n", *(ptr + 2));
```

### Array Access Methods
There are multiple equivalent ways to access array elements:

```c
int arr[5] = {10, 20, 30, 40, 50};

// Method 1: Array subscript notation
int value1 = arr[2];

// Method 2: Pointer arithmetic with dereference
int value2 = *(arr + 2);

// Method 3: Using pointer variable
int *ptr = arr;
int value3 = *(ptr + 2);
int value4 = ptr[2];

// All methods produce the same result
printf("%d %d %d %d\n", value1, value2, value3, value4);  // 30 30 30 30
```

## Pointer Arithmetic with Arrays

### Incrementing Pointers
Pointers can be incremented to traverse arrays:

```c
int arr[5] = {10, 20, 30, 40, 50};
int *ptr = arr;

// Traverse array using pointer arithmetic
for (int i = 0; i < 5; i++) {
    printf("Element %d: %d\n", i, *ptr);
    ptr++;  // Move to next element
}

// Reset pointer to beginning
ptr = arr;

// Alternative traversal
for (int i = 0; i < 5; i++) {
    printf("Element %d: %d\n", i, *(ptr + i));
}
```

### Pointer Difference
The difference between two pointers gives the number of elements between them:

```c
int arr[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
int *ptr1 = &arr[2];
int *ptr2 = &arr[8];

// Number of elements between ptr1 and ptr2
ptrdiff_t distance = ptr2 - ptr1;  // 6
printf("Distance: %td\n", distance);

// Check if pointer is within array bounds
if (ptr1 >= arr && ptr1 < arr + 10) {
    printf("ptr1 is within array bounds\n");
}
```

## Multi-dimensional Arrays and Pointers

### Two-dimensional Arrays
Two-dimensional arrays can be accessed using various pointer techniques:

```c
int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
};

// Method 1: Standard array notation
printf("matrix[1][2] = %d\n", matrix[1][2]);  // 7

// Method 2: Pointer to array
int (*ptr_to_row)[4] = matrix;  // Pointer to array of 4 integers
printf("ptr_to_row[1][2] = %d\n", ptr_to_row[1][2]);  // 7

// Method 3: Pointer to first element
int *ptr_to_element = &matrix[0][0];
printf("*(ptr_to_element + 1*4 + 2) = %d\n", *(ptr_to_element + 1*4 + 2));  // 7
```

### Row-wise Traversal
```c
int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
};

// Traverse row by row
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
        printf("%d ", matrix[i][j]);
    }
    printf("\n");
}

// Using pointer arithmetic
int *ptr = &matrix[0][0];
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
        printf("%d ", *ptr);
        ptr++;
    }
    printf("\n");
}
```

## Arrays as Function Parameters

### Array Decay to Pointers
When arrays are passed to functions, they decay to pointers:

```c
// These function declarations are equivalent:
void process_array1(int arr[]);
void process_array2(int *arr);
void process_array3(int arr[10]);  // Size is ignored

// Implementation
void process_array(int arr[], int size) {
    // sizeof(arr) returns pointer size, not array size!
    for (int i = 0; i < size; i++) {
        printf("Element %d: %d\n", i, arr[i]);
        // Equivalent to: printf("Element %d: %d\n", i, *(arr + i));
    }
}

int main() {
    int numbers[5] = {10, 20, 30, 40, 50};
    process_array(numbers, 5);  // Pass array and size
    return 0;
}
```

### Multi-dimensional Array Parameters
For multi-dimensional arrays, all dimensions except the first must be specified:

```c
// Function accepting 2D array - second dimension must be specified
void process_matrix(int matrix[][4], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

// Alternative using pointer notation
void process_matrix_ptr(int (*matrix)[4], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

int main() {
    int matrix[3][4] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
    };
    
    process_matrix(matrix, 3);
    return 0;
}
```

## Dynamic Arrays with Pointers

### Allocating Dynamic Arrays
Pointers enable dynamic array allocation:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int size;
    printf("Enter array size: ");
    scanf("%d", &size);
    
    // Allocate dynamic array
    int *arr = malloc(size * sizeof(int));
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Initialize array
    for (int i = 0; i < size; i++) {
        arr[i] = i * i;
    }
    
    // Use array
    for (int i = 0; i < size; i++) {
        printf("arr[%d] = %d\n", i, arr[i]);
    }
    
    // Free memory
    free(arr);
    arr = NULL;  // Prevent dangling pointer
    
    return 0;
}
```

### Resizing Dynamic Arrays
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int *arr = malloc(5 * sizeof(int));
    int size = 5;
    
    // Initialize array
    for (int i = 0; i < size; i++) {
        arr[i] = i + 1;
    }
    
    printf("Original array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Resize array
    size = 10;
    arr = realloc(arr, size * sizeof(int));
    if (arr == NULL) {
        printf("Memory reallocation failed\n");
        return 1;
    }
    
    // Initialize new elements
    for (int i = 5; i < size; i++) {
        arr[i] = (i + 1) * 2;
    }
    
    printf("Resized array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Free memory
    free(arr);
    return 0;
}
```

## Pointer Arrays vs. Arrays of Pointers

### Array of Pointers
An array of pointers stores multiple pointer values:

```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main() {
    // Array of string pointers
    char *strings[4] = {
        "Hello",
        "World",
        "C Programming",
        "Pointers"
    };
    
    // Print all strings
    for (int i = 0; i < 4; i++) {
        printf("String %d: %s\n", i, strings[i]);
    }
    
    // Dynamic string array
    char **dynamic_strings = malloc(3 * sizeof(char*));
    dynamic_strings[0] = malloc(6 * sizeof(char));
    strcpy(dynamic_strings[0], "First");
    
    dynamic_strings[1] = malloc(7 * sizeof(char));
    strcpy(dynamic_strings[1], "Second");
    
    dynamic_strings[2] = malloc(6 * sizeof(char));
    strcpy(dynamic_strings[2], "Third");
    
    // Print dynamic strings
    for (int i = 0; i < 3; i++) {
        printf("Dynamic string %d: %s\n", i, dynamic_strings[i]);
    }
    
    // Free dynamic memory
    for (int i = 0; i < 3; i++) {
        free(dynamic_strings[i]);
    }
    free(dynamic_strings);
    
    return 0;
}
```

### Pointer to Array
A pointer to an array points to the entire array:

```c
int arr[5] = {1, 2, 3, 4, 5};

// Pointer to array of 5 integers
int (*ptr_to_array)[5] = &arr;

// Access elements
printf("First element: %d\n", (*ptr_to_array)[0]);
printf("Third element: %d\n", (*ptr_to_array)[2]);

// Increment pointer (moves by entire array size)
ptr_to_array++;  // Points to next array of 5 integers
```

## Advanced Array-Pointer Techniques

### Pointer Arithmetic for Multi-dimensional Arrays
```c
int matrix[3][4] = {
    {1, 2, 3, 4},
    {5, 6, 7, 8},
    {9, 10, 11, 12}
};

// Treat 2D array as 1D array
int *ptr = &matrix[0][0];
for (int i = 0; i < 12; i++) {
    printf("%d ", ptr[i]);
    if ((i + 1) % 4 == 0) printf("\n");
}
```

### Function Pointers for Array Operations
```c
#include <stdio.h>

// Function pointer type for array operations
typedef int (*array_operation)(int);

// Array operation functions
int square(int x) { return x * x; }
int cube(int x) { return x * x * x; }
int double_value(int x) { return x * 2; }

// Apply operation to array
void apply_operation(int *arr, int size, array_operation op) {
    for (int i = 0; i < size; i++) {
        arr[i] = op(arr[i]);
    }
}

int main() {
    int numbers[5] = {1, 2, 3, 4, 5};
    int size = 5;
    
    printf("Original: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    // Apply square operation
    apply_operation(numbers, size, square);
    
    printf("Squared: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    return 0;
}
```

## Practical Examples

### Matrix Transpose Using Pointers
```c
#include <stdio.h>

void transpose_matrix(int *matrix, int *transpose, int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            // matrix[i][j] becomes transpose[j][i]
            *(transpose + j * rows + i) = *(matrix + i * cols + j);
        }
    }
}

int main() {
    int matrix[3][4] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
    };
    
    int transpose[4][3];
    
    transpose_matrix(&matrix[0][0], &transpose[0][0], 3, 4);
    
    printf("Original matrix:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    printf("\nTransposed matrix:\n");
    for (int i = 0; i < 4; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", transpose[i][j]);
        }
        printf("\n");
    }
    
    return 0;
}
```

### String Array Sorting
```c
#include <stdio.h>
#include <string.h>

void sort_strings(char *strings[], int count) {
    for (int i = 0; i < count - 1; i++) {
        for (int j = 0; j < count - i - 1; j++) {
            if (strcmp(strings[j], strings[j + 1]) > 0) {
                // Swap pointers
                char *temp = strings[j];
                strings[j] = strings[j + 1];
                strings[j + 1] = temp;
            }
        }
    }
}

int main() {
    char *fruits[] = {"apple", "orange", "banana", "pear", "grape"};
    int count = 5;
    
    printf("Original order:\n");
    for (int i = 0; i < count; i++) {
        printf("%s ", fruits[i]);
    }
    printf("\n");
    
    sort_strings(fruits, count);
    
    printf("Sorted order:\n");
    for (int i = 0; i < count; i++) {
        printf("%s ", fruits[i]);
    }
    printf("\n");
    
    return 0;
}
```

### Dynamic 2D Array
```c
#include <stdio.h>
#include <stdlib.h>

int** create_2d_array(int rows, int cols) {
    // Allocate array of row pointers
    int **matrix = malloc(rows * sizeof(int*));
    if (matrix == NULL) return NULL;
    
    // Allocate each row
    for (int i = 0; i < rows; i++) {
        matrix[i] = malloc(cols * sizeof(int));
        if (matrix[i] == NULL) {
            // Clean up on failure
            for (int j = 0; j < i; j++) {
                free(matrix[j]);
            }
            free(matrix);
            return NULL;
        }
    }
    
    return matrix;
}

void free_2d_array(int **matrix, int rows) {
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

int main() {
    int rows = 3, cols = 4;
    int **matrix = create_2d_array(rows, cols);
    
    if (matrix == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Initialize matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = i * cols + j;
        }
    }
    
    // Print matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    // Free memory
    free_2d_array(matrix, rows);
    
    return 0;
}
```

## Summary

The relationship between pointers and arrays is fundamental to C programming. Key points to remember:

1. **Array-Pointer Equivalence**: Arrays decay to pointers in most contexts
2. **Pointer Subscripting**: Pointers can use array notation and vice versa
3. **Pointer Arithmetic**: Operations are scaled by data type size
4. **Function Parameters**: Arrays pass as pointers to functions
5. **Dynamic Arrays**: Pointers enable runtime array allocation
6. **Multi-dimensional Arrays**: Various pointer techniques for 2D arrays
7. **Memory Management**: Proper allocation and deallocation of dynamic arrays

Understanding this relationship enables efficient array manipulation, dynamic memory allocation, and implementation of complex data structures in C.