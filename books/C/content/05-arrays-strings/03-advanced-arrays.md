# Advanced Arrays

## Introduction

Advanced array concepts in C extend beyond basic one-dimensional arrays to include multi-dimensional arrays, variable-length arrays, and specialized array techniques. These concepts are essential for handling complex data structures and implementing efficient algorithms. Understanding advanced arrays enables programmers to work with matrices, tables, and other multi-dimensional data representations.

## Multi-dimensional Arrays

### Two-dimensional Arrays
Two-dimensional arrays are essentially arrays of arrays, often used to represent matrices or tables:

```c
// Declaration
int matrix[3][4];  // 3 rows, 4 columns

// Initialization
int matrix1[2][3] = {{1, 2, 3}, {4, 5, 6}};
int matrix2[2][3] = {1, 2, 3, 4, 5, 6};  // Equivalent to above

// Partial initialization
int matrix3[3][3] = {{1, 2}, {4, 5}};  // Remaining elements set to 0

// Designated initializers (C99)
int matrix4[3][3] = {[0][0] = 1, [1][1] = 5, [2][2] = 9};
```

### Accessing Multi-dimensional Arrays
```c
int matrix[3][4] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}};

// Access individual elements
int element = matrix[1][2];  // Element at row 1, column 2 (value: 7)

// Modify elements
matrix[0][0] = 100;

// Traverse the array
for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 4; j++) {
        printf("%d ", matrix[i][j]);
    }
    printf("\n");
}
```

### Multi-dimensional Array Functions
When passing multi-dimensional arrays to functions, all dimensions except the first must be specified:

```c
// Function that takes a 3x4 matrix
void print_matrix(int matrix[][4], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

// Function with pointer notation (equivalent)
void print_matrix_ptr(int (*matrix)[4], int rows) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < 4; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
}

// Usage
int matrix[3][4] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}};
print_matrix(matrix, 3);
```

## Three-dimensional and Higher-dimensional Arrays

### Three-dimensional Arrays
```c
// Declaration
int cube[2][3][4];  // 2 layers, 3 rows, 4 columns

// Initialization
int cube1[2][2][2] = {
    {{1, 2}, {3, 4}},
    {{5, 6}, {7, 8}}
};

// Accessing elements
int element = cube1[1][0][1];  // Value: 6

// Traversal
for (int i = 0; i < 2; i++) {
    for (int j = 0; j < 2; j++) {
        for (int k = 0; k < 2; k++) {
            printf("cube[%d][%d][%d] = %d\n", i, j, k, cube1[i][j][k]);
        }
    }
}
```

### Higher-dimensional Arrays
While C supports arrays of any dimension, higher-dimensional arrays become increasingly complex:

```c
// Four-dimensional array
int hypercube[2][2][2][2];

// Accessing elements
hypercube[0][1][0][1] = 42;

// Generally, it's better to use structures or dynamic allocation for complex multi-dimensional data
```

## Variable-length Arrays (VLAs) - C99

### Basic VLA Declaration
Variable-length arrays allow the size to be determined at runtime:

```c
#include <stdio.h>

int main() {
    int size;
    printf("Enter array size: ");
    scanf("%d", &size);
    
    // Variable-length array
    int array[size];  // Size determined at runtime
    
    // Initialize and use the array
    for (int i = 0; i < size; i++) {
        array[i] = i * i;
        printf("array[%d] = %d\n", i, array[i]);
    }
    
    return 0;
}
```

### Multi-dimensional VLAs
```c
#include <stdio.h>

int main() {
    int rows, cols;
    printf("Enter rows and columns: ");
    scanf("%d %d", &rows, &cols);
    
    // Multi-dimensional VLA
    int matrix[rows][cols];
    
    // Initialize the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = i * cols + j;
        }
    }
    
    // Print the matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    return 0;
}
```

### VLA Function Parameters
```c
// Function that accepts VLA parameters
void process_matrix(int rows, int cols, int matrix[rows][cols]) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] *= 2;  // Double each element
        }
    }
}

// Usage
int main() {
    int rows = 3, cols = 4;
    int matrix[3][4] = {{1, 2, 3, 4}, {5, 6, 7, 8}, {9, 10, 11, 12}};
    
    process_matrix(rows, cols, matrix);
    
    // Print modified matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    return 0;
}
```

## Array of Arrays vs. Multi-dimensional Arrays

### Array of Arrays
An array of arrays treats each row as a separate array:

```c
// Array of pointers to arrays (jagged array)
int *matrix[3];
matrix[0] = malloc(2 * sizeof(int));  // First row: 2 elements
matrix[1] = malloc(4 * sizeof(int));  // Second row: 4 elements
matrix[2] = malloc(3 * sizeof(int));  // Third row: 3 elements

// Initialize elements
matrix[0][0] = 1; matrix[0][1] = 2;
matrix[1][0] = 3; matrix[1][1] = 4; matrix[1][2] = 5; matrix[1][3] = 6;
matrix[2][0] = 7; matrix[2][1] = 8; matrix[2][2] = 9;

// Free memory
free(matrix[0]);
free(matrix[1]);
free(matrix[2]);
```

### Multi-dimensional Arrays
Multi-dimensional arrays have fixed dimensions and contiguous memory layout:

```c
// True multi-dimensional array
int matrix[3][4];  // Fixed size: 3 rows, 4 columns

// All elements stored contiguously in memory
// Memory layout: [0][0] [0][1] [0][2] [0][3] [1][0] [1][1] ...
```

## Jagged Arrays

### Creating Jagged Arrays
Jagged arrays are arrays of arrays where each sub-array can have different lengths:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Create a jagged array
    int rows = 3;
    int *jagged[3];
    
    // Allocate memory for each row with different sizes
    jagged[0] = malloc(2 * sizeof(int));  // Row 0: 2 elements
    jagged[1] = malloc(4 * sizeof(int));  // Row 1: 4 elements
    jagged[2] = malloc(3 * sizeof(int));  // Row 2: 3 elements
    
    // Initialize elements
    jagged[0][0] = 1; jagged[0][1] = 2;
    jagged[1][0] = 3; jagged[1][1] = 4; jagged[1][2] = 5; jagged[1][3] = 6;
    jagged[2][0] = 7; jagged[2][1] = 8; jagged[2][2] = 9;
    
    // Print the jagged array
    for (int i = 0; i < rows; i++) {
        int cols = (i == 0) ? 2 : (i == 1) ? 4 : 3;
        for (int j = 0; j < cols; j++) {
            printf("%d ", jagged[i][j]);
        }
        printf("\n");
    }
    
    // Free memory
    for (int i = 0; i < rows; i++) {
        free(jagged[i]);
    }
    
    return 0;
}
```

### Jagged Array Functions
```c
// Function to create a jagged array
int** create_jagged_array(int rows, int *col_sizes) {
    int **array = malloc(rows * sizeof(int*));
    
    for (int i = 0; i < rows; i++) {
        array[i] = malloc(col_sizes[i] * sizeof(int));
    }
    
    return array;
}

// Function to free a jagged array
void free_jagged_array(int **array, int rows) {
    for (int i = 0; i < rows; i++) {
        free(array[i]);
    }
    free(array);
}

// Function to print a jagged array
void print_jagged_array(int **array, int rows, int *col_sizes) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < col_sizes[i]; j++) {
            printf("%d ", array[i][j]);
        }
        printf("\n");
    }
}
```

## Array Algorithms and Operations

### Matrix Operations
```c
#include <stdio.h>

#define ROWS 3
#define COLS 3

// Matrix addition
void matrix_add(int a[ROWS][COLS], int b[ROWS][COLS], int result[ROWS][COLS]) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            result[i][j] = a[i][j] + b[i][j];
        }
    }
}

// Matrix multiplication
void matrix_multiply(int a[ROWS][COLS], int b[COLS][ROWS], int result[ROWS][ROWS]) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < ROWS; j++) {
            result[i][j] = 0;
            for (int k = 0; k < COLS; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

// Transpose matrix
void matrix_transpose(int matrix[ROWS][COLS], int transpose[COLS][ROWS]) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            transpose[j][i] = matrix[i][j];
        }
    }
}
```

### Dynamic Array Resizing
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int *data;
    int size;
    int capacity;
} DynamicArray;

// Initialize dynamic array
DynamicArray* create_array(int initial_capacity) {
    DynamicArray *arr = malloc(sizeof(DynamicArray));
    arr->data = malloc(initial_capacity * sizeof(int));
    arr->size = 0;
    arr->capacity = initial_capacity;
    return arr;
}

// Add element to dynamic array
void array_push(DynamicArray *arr, int value) {
    if (arr->size >= arr->capacity) {
        // Double the capacity
        arr->capacity *= 2;
        arr->data = realloc(arr->data, arr->capacity * sizeof(int));
    }
    
    arr->data[arr->size] = value;
    arr->size++;
}

// Free dynamic array
void free_array(DynamicArray *arr) {
    free(arr->data);
    free(arr);
}
```

## Array Performance Considerations

### Memory Layout
Arrays have contiguous memory layout, which provides:
- Cache locality for sequential access
- Predictable memory usage
- Efficient indexing operations

```c
// Row-major order traversal (efficient)
for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
        process(matrix[i][j]);
    }
}

// Column-major order traversal (less efficient for C arrays)
for (int j = 0; j < cols; j++) {
    for (int i = 0; i < rows; i++) {
        process(matrix[i][j]);
    }
}
```

### Cache Performance
```c
#define SIZE 1000

// Good cache performance - sequential access
void good_access_pattern(int matrix[SIZE][SIZE]) {
    for (int i = 0; i < SIZE; i++) {
        for (int j = 0; j < SIZE; j++) {
            matrix[i][j] = i + j;
        }
    }
}

// Poor cache performance - non-sequential access
void poor_access_pattern(int matrix[SIZE][SIZE]) {
    for (int j = 0; j < SIZE; j++) {
        for (int i = 0; i < SIZE; i++) {
            matrix[i][j] = i + j;
        }
    }
}
```

## Advanced Array Techniques

### Array Pointers
```c
// Pointer to array
int (*ptr)[5];  // Pointer to array of 5 integers
int array[5] = {1, 2, 3, 4, 5};
ptr = &array;   // Point to the entire array

// Access elements
printf("%d\n", (*ptr)[2]);  // Access third element
```

### Array of Pointers
```c
// Array of pointers
int *ptr_array[5];  // Array of 5 pointers to integers
int values[5] = {10, 20, 30, 40, 50};

// Point each pointer to an element
for (int i = 0; i < 5; i++) {
    ptr_array[i] = &values[i];
}

// Access through pointers
for (int i = 0; i < 5; i++) {
    printf("%d ", *ptr_array[i]);
}
```

### Compound Literals (C99)
```c
// Compound literal for array
int *ptr = (int[]){1, 2, 3, 4, 5};

// Use in function calls
void process_array(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
}

// Call with compound literal
process_array((int[]){10, 20, 30, 40, 50}, 5);
```

## Practical Examples

### Sudoku Validator
```c
#include <stdio.h>
#include <stdbool.h>

#define SIZE 9

bool is_valid_sudoku(int board[SIZE][SIZE]) {
    // Check rows
    for (int i = 0; i < SIZE; i++) {
        bool seen[SIZE + 1] = {false};
        for (int j = 0; j < SIZE; j++) {
            if (board[i][j] != 0) {
                if (seen[board[i][j]]) return false;
                seen[board[i][j]] = true;
            }
        }
    }
    
    // Check columns
    for (int j = 0; j < SIZE; j++) {
        bool seen[SIZE + 1] = {false};
        for (int i = 0; i < SIZE; i++) {
            if (board[i][j] != 0) {
                if (seen[board[i][j]]) return false;
                seen[board[i][j]] = true;
            }
        }
    }
    
    // Check 3x3 boxes
    for (int box_row = 0; box_row < 3; box_row++) {
        for (int box_col = 0; box_col < 3; box_col++) {
            bool seen[SIZE + 1] = {false};
            for (int i = 0; i < 3; i++) {
                for (int j = 0; j < 3; j++) {
                    int row = box_row * 3 + i;
                    int col = box_col * 3 + j;
                    if (board[row][col] != 0) {
                        if (seen[board[row][col]]) return false;
                        seen[board[row][col]] = true;
                    }
                }
            }
        }
    }
    
    return true;
}

int main() {
    int sudoku[SIZE][SIZE] = {
        {5, 3, 0, 0, 7, 0, 0, 0, 0},
        {6, 0, 0, 1, 9, 5, 0, 0, 0},
        {0, 9, 8, 0, 0, 0, 0, 6, 0},
        {8, 0, 0, 0, 6, 0, 0, 0, 3},
        {4, 0, 0, 8, 0, 3, 0, 0, 1},
        {7, 0, 0, 0, 2, 0, 0, 0, 6},
        {0, 6, 0, 0, 0, 0, 2, 8, 0},
        {0, 0, 0, 4, 1, 9, 0, 0, 5},
        {0, 0, 0, 0, 8, 0, 0, 7, 9}
    };
    
    if (is_valid_sudoku(sudoku)) {
        printf("Valid Sudoku\n");
    } else {
        printf("Invalid Sudoku\n");
    }
    
    return 0;
}
```

### Image Processing Example
```c
#include <stdio.h>
#include <stdlib.h>

#define WIDTH 100
#define HEIGHT 100

// Simple image structure
typedef struct {
    unsigned char pixels[HEIGHT][WIDTH][3];  // RGB pixels
    int width, height;
} Image;

// Convert to grayscale
void grayscale(Image *img) {
    for (int i = 0; i < img->height; i++) {
        for (int j = 0; j < img->width; j++) {
            // Calculate grayscale value
            unsigned char gray = (img->pixels[i][j][0] * 0.3 +
                                img->pixels[i][j][1] * 0.59 +
                                img->pixels[i][j][2] * 0.11);
            
            // Set all channels to grayscale value
            img->pixels[i][j][0] = gray;
            img->pixels[i][j][1] = gray;
            img->pixels[i][j][2] = gray;
        }
    }
}

// Apply simple blur filter
void blur(Image *img) {
    // Create a copy for processing
    unsigned char temp[HEIGHT][WIDTH][3];
    
    for (int i = 1; i < img->height - 1; i++) {
        for (int j = 1; j < img->width - 1; j++) {
            for (int c = 0; c < 3; c++) {
                // Average of 3x3 neighborhood
                int sum = 0;
                for (int di = -1; di <= 1; di++) {
                    for (int dj = -1; dj <= 1; dj++) {
                        sum += img->pixels[i + di][j + dj][c];
                    }
                }
                temp[i][j][c] = sum / 9;
            }
        }
    }
    
    // Copy back to original image
    for (int i = 1; i < img->height - 1; i++) {
        for (int j = 1; j < img->width - 1; j++) {
            for (int c = 0; c < 3; c++) {
                img->pixels[i][j][c] = temp[i][j][c];
            }
        }
    }
}
```

## Summary

Advanced array concepts in C provide powerful tools for handling complex data structures and implementing efficient algorithms. Key points to remember:

1. **Multi-dimensional Arrays**: Arrays of arrays with fixed dimensions and contiguous memory layout
2. **Variable-length Arrays**: C99 feature allowing runtime-determined array sizes
3. **Jagged Arrays**: Arrays of arrays with different sub-array sizes
4. **Memory Layout**: Row-major order storage affects performance characteristics
5. **Array Pointers**: Distinction between pointers to arrays and arrays of pointers
6. **Performance Considerations**: Cache locality and access patterns significantly impact performance
7. **Advanced Techniques**: Compound literals, designated initializers, and dynamic resizing

Understanding these advanced array concepts is essential for efficient C programming, particularly when working with matrices, tables, and complex data structures.