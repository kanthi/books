# Module 13: Performance Optimization Exercises

## Exercise 1: Algorithm Complexity Analysis
Write a program that demonstrates algorithm complexity analysis and optimization:
- Implement multiple versions of common algorithms with different complexities
- Create functions to measure execution time of algorithms
- Demonstrate the impact of algorithmic complexity on performance
- Show how to profile code to identify bottlenecks
- Implement optimized versions of inefficient algorithms

**Requirements:**
- Include examples of O(1), O(log n), O(n), O(n log n), and O(n²) algorithms
- Implement accurate timing functions for performance measurement
- Provide clear visualization of performance differences
- Include examples of common algorithmic optimizations
- Document the analysis process and findings

## Exercise 2: Memory Access Patterns Optimization
Create a program that demonstrates memory access pattern optimization:
- Implement functions with different memory access patterns
- Show the impact of cache locality on performance
- Demonstrate proper use of memory alignment
- Implement techniques for reducing cache misses
- Show how to optimize data structure layouts

**Requirements:**
- Include examples of sequential, random, and strided memory access
- Implement cache-friendly data structures
- Demonstrate proper memory alignment techniques
- Show the impact of data structure padding and packing
- Provide clear performance comparisons between different approaches

## Exercise 3: Compiler Optimization Techniques
Develop a program that demonstrates compiler optimization techniques:
- Implement code that showcases different compiler optimization levels
- Show how to use compiler hints and attributes effectively
- Demonstrate proper use of inline functions and macros
- Implement examples of loop optimization techniques
- Show how to prevent unwanted compiler optimizations for testing

**Requirements:**
- Include examples of common compiler optimization flags
- Demonstrate proper use of restrict keyword and volatile
- Show how to use compiler-specific attributes and pragmas
- Implement examples of manual loop unrolling and vectorization
- Provide clear documentation of optimization techniques

## Exercise 4: Data Structure Optimization
Write a program that demonstrates data structure optimization:
- Implement multiple versions of common data structures
- Show the impact of different data structure choices on performance
- Demonstrate proper use of memory pools and object pools
- Implement custom allocators for specific use cases
- Show how to optimize data structures for specific access patterns

**Requirements:**
- Include examples of array vs linked list performance trade-offs
- Implement cache-oblivious data structures
- Demonstrate proper use of memory preallocation
- Show how to optimize data structures for concurrent access
- Provide clear performance comparisons and analysis

## Exercise 5: Parallel Processing Implementation
Create a program that implements parallel processing techniques:
- Implement multi-threaded versions of compute-intensive tasks
- Show how to use OpenMP or pthreads effectively
- Demonstrate proper synchronization techniques
- Implement lock-free data structures (bonus)
- Show how to measure and optimize parallel performance

**Requirements:**
- Include examples of task parallelism and data parallelism
- Demonstrate proper use of thread pools
- Show how to avoid common parallel programming pitfalls
- Implement proper load balancing techniques
- Provide clear scalability analysis and measurements

## Exercise 6: SIMD and Vectorization
Write a program that demonstrates SIMD (Single Instruction, Multiple Data) optimization:
- Implement vectorized versions of compute-intensive functions
- Show how to use SSE, AVX, or other SIMD instruction sets
- Demonstrate proper data alignment for SIMD operations
- Implement fallback implementations for different architectures
- Show how to measure SIMD performance improvements

**Requirements:**
- Include examples of manual vectorization and compiler auto-vectorization
- Demonstrate proper handling of data alignment requirements
- Show how to handle different vector widths and instruction sets
- Implement proper error handling for SIMD operations
- Provide clear performance comparisons between scalar and vector versions

## Exercise 7: Memory Management Optimization
Create a program that demonstrates memory management optimization:
- Implement custom memory allocators for specific use cases
- Show how to reduce memory fragmentation
- Demonstrate proper use of memory pools and arenas
- Implement garbage collection-like mechanisms (bonus)
- Show how to profile and optimize memory usage

**Requirements:**
- Include examples of stack vs heap allocation performance
- Demonstrate proper use of memory preallocation techniques
- Show how to implement efficient memory pooling strategies
- Implement proper memory leak detection and prevention
- Provide clear memory usage analysis and optimization

## Exercise 8: Comprehensive Performance Optimization
Design a complete application that demonstrates all performance optimization techniques:
- Implement a compute-intensive application with multiple components
- Apply all optimization techniques learned in previous exercises
- Include comprehensive performance profiling and analysis
- Demonstrate proper trade-offs between different optimization approaches
- Provide clear documentation and performance results

**Requirements:**
- Use modular design with clear performance boundaries
- Include comprehensive profiling and benchmarking
- Demonstrate proper optimization prioritization
- Implement robust performance monitoring throughout the application
- Provide clear examples and performance comparisons

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// Timing function
double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

// O(n²) bubble sort
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// O(n log n) quick sort
void quick_sort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = (low - 1);
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    return (i + 1);
}

// O(n) linear search
int linear_search(int arr[], int n, int key) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == key) {
            return i;
        }
    }
    return -1;
}

// O(log n) binary search
int binary_search(int arr[], int low, int high, int key) {
    if (high >= low) {
        int mid = low + (high - low) / 2;
        if (arr[mid] == key) {
            return mid;
        }
        if (arr[mid] > key) {
            return binary_search(arr, low, mid - 1, key);
        }
        return binary_search(arr, mid + 1, high, key);
    }
    return -1;
}

// Performance testing function
void test_algorithms() {
    const int sizes[] = {1000, 5000, 10000, 20000};
    const int num_sizes = sizeof(sizes) / sizeof(sizes[0]);
    
    for (int s = 0; s < num_sizes; s++) {
        int n = sizes[s];
        int *arr1 = malloc(n * sizeof(int));
        int *arr2 = malloc(n * sizeof(int));
        
        // Fill arrays with random data
        for (int i = 0; i < n; i++) {
            arr1[i] = rand() % 10000;
            arr2[i] = arr1[i];
        }
        
        struct timespec start, end;
        
        // Test bubble sort
        clock_gettime(CLOCK_MONOTONIC, &start);
        bubble_sort(arr1, n);
        clock_gettime(CLOCK_MONOTONIC, &end);
        double bubble_time = get_time_diff(start, end);
        
        // Test quick sort
        clock_gettime(CLOCK_MONOTONIC, &start);
        quick_sort(arr2, 0, n - 1);
        clock_gettime(CLOCK_MONOTONIC, &end);
        double quick_time = get_time_diff(start, end);
        
        printf("Array size: %d\n", n);
        printf("Bubble sort time: %.6f seconds\n", bubble_time);
        printf("Quick sort time: %.6f seconds\n", quick_time);
        printf("Speedup: %.2fx\n\n", bubble_time / quick_time);
        
        free(arr1);
        free(arr2);
    }
}

int main() {
    srand(time(NULL));
    test_algorithms();
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define MATRIX_SIZE 1000
#define CACHE_LINE_SIZE 64

// Matrix structure with proper alignment
typedef struct {
    int rows;
    int cols;
    int *data;
} matrix_t;

// Create matrix with specified alignment
matrix_t* create_matrix(int rows, int cols) {
    matrix_t *mat = malloc(sizeof(matrix_t));
    mat->rows = rows;
    mat->cols = cols;
    // Allocate aligned memory for better cache performance
    posix_memalign((void**)&mat->data, CACHE_LINE_SIZE, rows * cols * sizeof(int));
    return mat;
}

void free_matrix(matrix_t *mat) {
    free(mat->data);
    free(mat);
}

// Initialize matrix with random values
void init_matrix(matrix_t *mat) {
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        mat->data[i] = rand() % 100;
    }
}

// Matrix multiplication - ijk order (poor cache performance)
void matrix_multiply_ijk(matrix_t *a, matrix_t *b, matrix_t *c) {
    for (int i = 0; i < a->rows; i++) {
        for (int j = 0; j < b->cols; j++) {
            c->data[i * c->cols + j] = 0;
            for (int k = 0; k < a->cols; k++) {
                c->data[i * c->cols + j] += 
                    a->data[i * a->cols + k] * b->data[k * b->cols + j];
            }
        }
    }
}

// Matrix multiplication - ikj order (better cache performance)
void matrix_multiply_ikj(matrix_t *a, matrix_t *b, matrix_t *c) {
    // Initialize result matrix
    memset(c->data, 0, c->rows * c->cols * sizeof(int));
    
    for (int i = 0; i < a->rows; i++) {
        for (int k = 0; k < a->cols; k++) {
            int temp = a->data[i * a->cols + k];
            for (int j = 0; j < b->cols; j++) {
                c->data[i * c->cols + j] += temp * b->data[k * b->cols + j];
            }
        }
    }
}

// Performance comparison
void compare_matrix_multiplication() {
    matrix_t *a = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *b = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *c1 = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *c2 = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    
    init_matrix(a);
    init_matrix(b);
    
    struct timespec start, end;
    
    // Test ijk order
    clock_gettime(CLOCK_MONOTONIC, &start);
    matrix_multiply_ijk(a, b, c1);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time_ijk = get_time_diff(start, end);
    
    // Test ikj order
    clock_gettime(CLOCK_MONOTONIC, &start);
    matrix_multiply_ikj(a, b, c2);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time_ikj = get_time_diff(start, end);
    
    printf("Matrix multiplication performance comparison:\n");
    printf("Matrix size: %dx%d\n", MATRIX_SIZE, MATRIX_SIZE);
    printf("ijk order time: %.6f seconds\n", time_ijk);
    printf("ikj order time: %.6f seconds\n", time_ikj);
    printf("Performance improvement: %.2fx\n", time_ijk / time_ikj);
    
    // Verify results are the same
    int diff_count = 0;
    for (int i = 0; i < c1->rows * c1->cols; i++) {
        if (c1->data[i] != c2->data[i]) {
            diff_count++;
        }
    }
    printf("Results match: %s\n", diff_count == 0 ? "Yes" : "No");
    
    free_matrix(a);
    free_matrix(b);
    free_matrix(c1);
    free_matrix(c2);
}

double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

int main() {
    srand(time(NULL));
    compare_matrix_multiplication();
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Premature optimization**: Always profile before optimizing
2. **Algorithmic vs implementation optimization**: Focus on algorithmic improvements first
3. **Micro-optimizations**: Avoid micro-optimizations that hurt readability without significant gains
4. **Platform-specific optimizations**: Consider portability when optimizing
5. **Over-optimization**: Balance performance with maintainability and correctness

### Best Practices:
1. **Profile-driven optimization**: Use profiling tools to identify real bottlenecks
2. **Algorithmic improvements**: Focus on better algorithms before low-level optimizations
3. **Memory locality**: Optimize for cache-friendly access patterns
4. **Compiler assistance**: Use compiler optimization flags and hints effectively
5. **Measurement and validation**: Always measure performance improvements and verify correctness

Complete these exercises to solidify your understanding of performance optimization in C. Each exercise builds upon the previous ones, gradually increasing in complexity.