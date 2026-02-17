# C99 Features

## Introduction

The C99 standard (ISO/IEC 9899:1999) introduced numerous significant enhancements to the C programming language, making it more powerful, expressive, and suitable for modern programming tasks. These features addressed many limitations of the previous C89/C90 standard and brought C closer to contemporary programming language capabilities.

C99 features include new data types, improved control structures, enhanced initialization syntax, and better support for numerical computing. Understanding these features is essential for writing modern, efficient C code.

## Variable-Length Arrays (VLAs)

One of the most significant additions in C99 was Variable-Length Arrays (VLAs), which allow the size of an array to be determined at runtime rather than compile time.

### Basic VLA Declaration

```c
#include <stdio.h>

int main() {
    int size;
    
    printf("Enter array size: ");
    scanf("%d", &size);
    
    // Variable-length array - size determined at runtime
    int array[size];
    
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
    
    // Multi-dimensional variable-length array
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
            printf("%4d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    return 0;
}
```

### VLA Function Parameters

```c
#include <stdio.h>

// Function that accepts VLA parameters
void process_matrix(int rows, int cols, int matrix[rows][cols]) {
    printf("Processing %dx%d matrix:\n", rows, cols);
    
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] *= 2;  // Double each element
        }
    }
}

// Function to print a matrix
void print_matrix(int rows, int cols, int matrix[rows][cols]) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%4d ", matrix[i][j]);
        }
        printf("\n");
    }
}

int main() {
    int rows = 3, cols = 4;
    
    // Declare and initialize a VLA
    int matrix[rows][cols] = {
        {1, 2, 3, 4},
        {5, 6, 7, 8},
        {9, 10, 11, 12}
    };
    
    printf("Original matrix:\n");
    print_matrix(rows, cols, matrix);
    
    // Process the matrix
    process_matrix(rows, cols, matrix);
    
    printf("\nModified matrix:\n");
    print_matrix(rows, cols, matrix);
    
    return 0;
}
```

## Designated Initializers

C99 introduced designated initializers, which allow you to initialize specific elements of arrays and structures by specifying their indices or member names.

### Array Designated Initializers

```c
#include <stdio.h>

int main() {
    // Traditional initialization
    int array1[10] = {0, 0, 5, 0, 0, 0, 0, 8, 0, 0};
    
    // Designated initializers - only initialize specific elements
    int array2[10] = {[2] = 5, [7] = 8};
    
    // Mixed initialization
    int array3[10] = {1, 2, [5] = 10, 11, 12};
    
    printf("Array 1: ");
    for (int i = 0; i < 10; i++) {
        printf("%d ", array1[i]);
    }
    printf("\n");
    
    printf("Array 2: ");
    for (int i = 0; i < 10; i++) {
        printf("%d ", array2[i]);
    }
    printf("\n");
    
    printf("Array 3: ");
    for (int i = 0; i < 10; i++) {
        printf("%d ", array3[i]);
    }
    printf("\n");
    
    return 0;
}
```

### Structure Designated Initializers

```c
#include <stdio.h>
#include <string.h>

typedef struct {
    int id;
    char name[50];
    double salary;
    int age;
} Employee;

int main() {
    // Traditional initialization (order matters)
    Employee emp1 = {1, "John Doe", 50000.0, 30};
    
    // Designated initializers (order doesn't matter)
    Employee emp2 = {
        .id = 2,
        .name = "Jane Smith",
        .salary = 60000.0,
        .age = 28
    };
    
    // Partial initialization with designated initializers
    Employee emp3 = {
        .id = 3,
        .name = "Bob Johnson"
        // salary and age will be zero-initialized
    };
    
    printf("Employee 1: ID=%d, Name=%s, Salary=%.2f, Age=%d\n",
           emp1.id, emp1.name, emp1.salary, emp1.age);
    
    printf("Employee 2: ID=%d, Name=%s, Salary=%.2f, Age=%d\n",
           emp2.id, emp2.name, emp2.salary, emp2.age);
    
    printf("Employee 3: ID=%d, Name=%s, Salary=%.2f, Age=%d\n",
           emp3.id, emp3.name, emp3.salary, emp3.age);
    
    return 0;
}
```

## Compound Literals

Compound literals allow you to create unnamed objects of any data type, including arrays and structures.

### Array Compound Literals

```c
#include <stdio.h>
#include <string.h>

void print_array(int size, int arr[size]) {
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    // Traditional approach
    int temp_array[] = {1, 2, 3, 4, 5};
    print_array(5, temp_array);
    
    // Using compound literal
    print_array(5, (int[]){1, 2, 3, 4, 5});
    
    // Compound literal with VLA
    int size = 3;
    print_array(size, (int[size]){10, 20, 30});
    
    return 0;
}
```

### Structure Compound Literals

```c
#include <stdio.h>
#include <string.h>

typedef struct {
    int x, y;
} Point;

typedef struct {
    Point center;
    double radius;
} Circle;

void print_point(Point p) {
    printf("Point(%d, %d)\n", p.x, p.y);
}

void print_circle(Circle c) {
    printf("Circle(center=(%d, %d), radius=%.2f)\n", 
           c.center.x, c.center.y, c.radius);
}

int main() {
    // Traditional approach
    Point p1 = {10, 20};
    print_point(p1);
    
    // Using compound literal
    print_point((Point){30, 40});
    
    // Structure with nested structure
    Circle c1 = {{0, 0}, 5.0};
    print_circle(c1);
    
    // Using compound literals for nested structures
    print_circle((Circle){{10, 10}, 7.5});
    
    return 0;
}
```

## New Data Types

C99 introduced several new data types to improve numerical computing capabilities.

### long long Type

```c
#include <stdio.h>
#include <limits.h>

int main() {
    long long big_number = 123456789012345LL;
    unsigned long long huge_number = 1234567890123456789ULL;
    
    printf("long long value: %lld\n", big_number);
    printf("unsigned long long value: %llu\n", huge_number);
    
    printf("LLONG_MIN: %lld\n", LLONG_MIN);
    printf("LLONG_MAX: %lld\n", LLONG_MAX);
    printf("ULLONG_MAX: %llu\n", ULLONG_MAX);
    
    return 0;
}
```

### _Bool Type

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    // Using _Bool (C99)
    _Bool flag1 = 1;
    _Bool flag2 = 0;
    
    // Using bool with stdbool.h (recommended)
    bool is_valid = true;
    bool is_error = false;
    
    printf("_Bool values: %d, %d\n", flag1, flag2);
    printf("bool values: %d, %d\n", is_valid, is_error);
    
    // Boolean expressions
    int x = 10, y = 20;
    bool result = (x < y);
    printf("x < y: %s\n", result ? "true" : "false");
    
    return 0;
}
```

## Inline Functions

The `inline` keyword suggests to the compiler that a function should be inlined to reduce function call overhead.

```c
#include <stdio.h>

// Inline function suggestion
inline int square(int x) {
    return x * x;
}

// Static inline function (more portable)
static inline int cube(int x) {
    return x * x * x;
}

int main() {
    int num = 5;
    
    printf("Square of %d: %d\n", num, square(num));
    printf("Cube of %d: %d\n", num, cube(num));
    
    // Inline functions work in loops without function call overhead
    for (int i = 1; i <= 5; i++) {
        printf("Square of %d: %d\n", i, square(i));
    }
    
    return 0;
}
```

## restrict Keyword

The `restrict` keyword is a hint to the compiler that a pointer is the only way to access a particular memory region, allowing for better optimization.

```c
#include <stdio.h>

// Without restrict - compiler must be conservative
void add_arrays_normal(int n, int *a, int *b, int *result) {
    for (int i = 0; i < n; i++) {
        result[i] = a[i] + b[i];
    }
}

// With restrict - compiler can optimize more aggressively
void add_arrays_restrict(int n, int *restrict a, int *restrict b, int *restrict result) {
    for (int i = 0; i < n; i++) {
        result[i] = a[i] + b[i];
    }
}

int main() {
    int a[5] = {1, 2, 3, 4, 5};
    int b[5] = {10, 20, 30, 40, 50};
    int result1[5], result2[5];
    
    add_arrays_normal(5, a, b, result1);
    add_arrays_restrict(5, a, b, result2);
    
    printf("Normal addition: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", result1[i]);
    }
    printf("\n");
    
    printf("Restrict addition: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", result2[i]);
    }
    printf("\n");
    
    return 0;
}
```

## Flexible Array Members

C99 introduced flexible array members, allowing structures to have arrays of variable size at the end.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int count;
    double data[];  // Flexible array member (must be last)
} DynamicArray;

DynamicArray* create_dynamic_array(int count) {
    // Allocate memory for structure + array
    DynamicArray *arr = malloc(sizeof(DynamicArray) + count * sizeof(double));
    if (arr != NULL) {
        arr->count = count;
    }
    return arr;
}

void free_dynamic_array(DynamicArray *arr) {
    free(arr);
}

int main() {
    int size = 5;
    DynamicArray *arr = create_dynamic_array(size);
    
    if (arr != NULL) {
        // Initialize the flexible array
        for (int i = 0; i < arr->count; i++) {
            arr->data[i] = i * 1.5;
        }
        
        // Print the array
        printf("Dynamic array contents: ");
        for (int i = 0; i < arr->count; i++) {
            printf("%.1f ", arr->data[i]);
        }
        printf("\n");
        
        free_dynamic_array(arr);
    }
    
    return 0;
}
```

## Practical Examples

### Matrix Library Using C99 Features

```c
#include <stdio.h>
#include <stdlib.h>

// Matrix structure using flexible array member
typedef struct {
    int rows, cols;
    double data[];  // Flexible array member
} Matrix;

// Create matrix
Matrix* create_matrix(int rows, int cols) {
    Matrix *m = malloc(sizeof(Matrix) + rows * cols * sizeof(double));
    if (m != NULL) {
        m->rows = rows;
        m->cols = cols;
    }
    return m;
}

// Free matrix
void free_matrix(Matrix *m) {
    free(m);
}

// Initialize matrix with designated initializers
void init_matrix(Matrix *m, double values[m->rows][m->cols]) {
    for (int i = 0; i < m->rows; i++) {
        for (int j = 0; j < m->cols; j++) {
            m->data[i * m->cols + j] = values[i][j];
        }
    }
}

// Print matrix
void print_matrix(const Matrix *m) {
    for (int i = 0; i < m->rows; i++) {
        for (int j = 0; j < m->cols; j++) {
            printf("%8.2f ", m->data[i * m->cols + j]);
        }
        printf("\n");
    }
}

// Matrix multiplication using VLAs
Matrix* multiply_matrices(const Matrix *a, const Matrix *b) {
    if (a->cols != b->rows) {
        printf("Error: Incompatible matrix dimensions\n");
        return NULL;
    }
    
    Matrix *result = create_matrix(a->rows, b->cols);
    if (result == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    // Use VLA for computation
    int rows = a->rows, cols = b->cols, inner = a->cols;
    double a_data[rows][inner], b_data[inner][cols], result_data[rows][cols];
    
    // Copy data to VLAs for easier access
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < inner; j++) {
            a_data[i][j] = a->data[i * a->cols + j];
        }
    }
    
    for (int i = 0; i < inner; i++) {
        for (int j = 0; j < cols; j++) {
            b_data[i][j] = b->data[i * b->cols + j];
        }
    }
    
    // Perform multiplication
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result_data[i][j] = 0;
            for (int k = 0; k < inner; k++) {
                result_data[i][j] += a_data[i][k] * b_data[k][j];
            }
        }
    }
    
    // Copy result back to matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result->data[i * cols + j] = result_data[i][j];
        }
    }
    
    return result;
}

int main() {
    // Create matrices using compound literals
    Matrix *m1 = create_matrix(2, 3);
    Matrix *m2 = create_matrix(3, 2);
    
    if (m1 == NULL || m2 == NULL) {
        printf("Error: Memory allocation failed\n");
        return 1;
    }
    
    // Initialize matrices
    double values1[2][3] = {{1, 2, 3}, {4, 5, 6}};
    double values2[3][2] = {{7, 8}, {9, 10}, {11, 12}};
    
    init_matrix(m1, values1);
    init_matrix(m2, values2);
    
    printf("Matrix 1:\n");
    print_matrix(m1);
    
    printf("\nMatrix 2:\n");
    print_matrix(m2);
    
    // Multiply matrices
    Matrix *result = multiply_matrices(m1, m2);
    if (result != NULL) {
        printf("\nResult of multiplication:\n");
        print_matrix(result);
        free_matrix(result);
    }
    
    free_matrix(m1);
    free_matrix(m2);
    
    return 0;
}
```

## Summary

C99 introduced several powerful features that significantly enhanced the C programming language:

1. **Variable-Length Arrays (VLAs)**: Runtime-determined array sizes
2. **Designated Initializers**: Initialize specific array elements or structure members
3. **Compound Literals**: Create unnamed objects of any type
4. **New Data Types**: `long long`, `_Bool` for better numerical computing
5. **Inline Functions**: Suggest function inlining for performance
6. **restrict Keyword**: Hint for compiler optimization
7. **Flexible Array Members**: Variable-size arrays at structure end

These features make C99 code more expressive, efficient, and easier to write and maintain. Understanding and utilizing these features is essential for modern C programming.