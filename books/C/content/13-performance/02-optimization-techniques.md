# Optimization Techniques

## Introduction

Performance optimization in C programming involves applying various techniques to improve execution speed, reduce memory usage, and enhance overall efficiency. This chapter explores fundamental and advanced optimization strategies, including algorithmic improvements, loop optimizations, data structure selection, and compiler-assisted optimizations.

## Algorithmic Optimization

The most significant performance improvements often come from choosing better algorithms and data structures.

### Time Complexity Analysis

Understanding algorithmic complexity is fundamental to optimization:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// O(n^2) bubble sort
void bubble_sort(int* arr, int n) {
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
void quick_sort(int* arr, int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

int partition(int* arr, int low, int high) {
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

// O(n log n) merge sort
void merge_sort(int* arr, int l, int r) {
    if (l < r) {
        int m = l + (r - l) / 2;
        merge_sort(arr, l, m);
        merge_sort(arr, m + 1, r);
        merge(arr, l, m, r);
    }
}

void merge(int* arr, int l, int m, int r) {
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;
    
    int* L = malloc(n1 * sizeof(int));
    int* R = malloc(n2 * sizeof(int));
    
    for (i = 0; i < n1; i++)
        L[i] = arr[l + i];
    for (j = 0; j < n2; j++)
        R[j] = arr[m + 1 + j];
    
    i = 0;
    j = 0;
    k = l;
    
    while (i < n1 && j < n2) {
        if (L[i] <= R[j]) {
            arr[k] = L[i];
            i++;
        } else {
            arr[k] = R[j];
            j++;
        }
        k++;
    }
    
    while (i < n1) {
        arr[k] = L[i];
        i++;
        k++;
    }
    
    while (j < n2) {
        arr[k] = R[j];
        j++;
        k++;
    }
    
    free(L);
    free(R);
}

// Performance comparison
void compare_sorting_algorithms(void) {
    const int size = 10000;
    int* arr1 = malloc(size * sizeof(int));
    int* arr2 = malloc(size * sizeof(int));
    int* arr3 = malloc(size * sizeof(int));
    
    // Initialize arrays with random data
    for (int i = 0; i < size; i++) {
        arr1[i] = arr2[i] = arr3[i] = rand() % 10000;
    }
    
    struct timespec start, end;
    
    // Test bubble sort
    clock_gettime(CLOCK_MONOTONIC, &start);
    bubble_sort(arr1, size);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double bubble_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test quick sort
    clock_gettime(CLOCK_MONOTONIC, &start);
    quick_sort(arr2, 0, size - 1);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double quick_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test merge sort
    clock_gettime(CLOCK_MONOTONIC, &start);
    merge_sort(arr3, 0, size - 1);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double merge_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Sorting Algorithm Performance (n=%d):\n", size);
    printf("  Bubble Sort: %.6f seconds\n", bubble_time);
    printf("  Quick Sort:  %.6f seconds\n", quick_time);
    printf("  Merge Sort:  %.6f seconds\n", merge_time);
    
    free(arr1);
    free(arr2);
    free(arr3);
}
```

### Search Algorithm Optimization

Choosing the right search algorithm can dramatically improve performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// O(n) linear search
int linear_search(int* arr, int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;
        }
    }
    return -1;
}

// O(log n) binary search (requires sorted array)
int binary_search(int* arr, int n, int target) {
    int left = 0;
    int right = n - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid;
        }
        
        if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    return -1;
}

// Hash table implementation for O(1) average case search
#define HASH_TABLE_SIZE 1009

typedef struct hash_node {
    int key;
    int value;
    struct hash_node* next;
} hash_node_t;

static hash_node_t* hash_table[HASH_TABLE_SIZE];

unsigned int hash_function(int key) {
    return (unsigned int)(key % HASH_TABLE_SIZE);
}

void hash_table_insert(int key, int value) {
    unsigned int index = hash_function(key);
    
    hash_node_t* node = malloc(sizeof(hash_node_t));
    node->key = key;
    node->value = value;
    node->next = hash_table[index];
    hash_table[index] = node;
}

int hash_table_search(int key) {
    unsigned int index = hash_function(key);
    hash_node_t* node = hash_table[index];
    
    while (node != NULL) {
        if (node->key == key) {
            return node->value;
        }
        node = node->next;
    }
    
    return -1;
}

void hash_table_clear(void) {
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        hash_node_t* node = hash_table[i];
        while (node != NULL) {
            hash_node_t* next = node->next;
            free(node);
            node = next;
        }
        hash_table[i] = NULL;
    }
}

// Performance comparison
void compare_search_algorithms(void) {
    const int size = 100000;
    int* sorted_array = malloc(size * sizeof(int));
    int* unsorted_array = malloc(size * sizeof(int));
    
    // Initialize arrays
    for (int i = 0; i < size; i++) {
        sorted_array[i] = i * 2;  // Even numbers
        unsorted_array[i] = rand() % (size * 2);
        hash_table_insert(unsorted_array[i], i);
    }
    
    int target = sorted_array[size / 2];  // Target in middle
    
    struct timespec start, end;
    
    // Test linear search
    clock_gettime(CLOCK_MONOTONIC, &start);
    int linear_result = linear_search(unsorted_array, size, target);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double linear_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test binary search
    clock_gettime(CLOCK_MONOTONIC, &start);
    int binary_result = binary_search(sorted_array, size, target);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double binary_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test hash table search
    clock_gettime(CLOCK_MONOTONIC, &start);
    int hash_result = hash_table_search(target);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double hash_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Search Algorithm Performance (n=%d):\n", size);
    printf("  Linear Search: %.9f seconds (result: %d)\n", linear_time, linear_result);
    printf("  Binary Search: %.9f seconds (result: %d)\n", binary_time, binary_result);
    printf("  Hash Search:   %.9f seconds (result: %d)\n", hash_time, hash_result);
    
    free(sorted_array);
    free(unsorted_array);
    hash_table_clear();
}
```

## Loop Optimization

Loop optimization techniques can significantly improve performance by reducing overhead and improving cache locality.

### Loop Unrolling

Loop unrolling reduces loop overhead by processing multiple iterations in each loop cycle:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Standard loop
void standard_loop(int* arr, int n) {
    for (int i = 0; i < n; i++) {
        arr[i] = arr[i] * 2 + 1;
    }
}

// Unrolled loop (factor of 4)
void unrolled_loop(int* arr, int n) {
    int i;
    // Process 4 elements per iteration
    for (i = 0; i < n - 3; i += 4) {
        arr[i] = arr[i] * 2 + 1;
        arr[i + 1] = arr[i + 1] * 2 + 1;
        arr[i + 2] = arr[i + 2] * 2 + 1;
        arr[i + 3] = arr[i + 3] * 2 + 1;
    }
    
    // Handle remaining elements
    for (; i < n; i++) {
        arr[i] = arr[i] * 2 + 1;
    }
}

// Duff's device (advanced loop unrolling)
void duff_device(int* to, int* from, int count) {
    int n = (count + 7) / 8;
    switch (count % 8) {
        case 0: do { *to++ = *from++;
        case 7:      *to++ = *from++;
        case 6:      *to++ = *from++;
        case 5:      *to++ = *from++;
        case 4:      *to++ = *from++;
        case 3:      *to++ = *from++;
        case 2:      *to++ = *from++;
        case 1:      *to++ = *from++;
                } while (--n > 0);
    }
}

// Performance comparison
void compare_loop_optimizations(void) {
    const int size = 1000000;
    int* arr1 = malloc(size * sizeof(int));
    int* arr2 = malloc(size * sizeof(int));
    
    // Initialize arrays
    for (int i = 0; i < size; i++) {
        arr1[i] = arr2[i] = i;
    }
    
    struct timespec start, end;
    
    // Test standard loop
    clock_gettime(CLOCK_MONOTONIC, &start);
    standard_loop(arr1, size);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double standard_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test unrolled loop
    clock_gettime(CLOCK_MONOTONIC, &start);
    unrolled_loop(arr2, size);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double unrolled_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Loop Optimization Performance (n=%d):\n", size);
    printf("  Standard Loop: %.6f seconds\n", standard_time);
    printf("  Unrolled Loop: %.6f seconds\n", unrolled_time);
    printf("  Speedup: %.2fx\n", standard_time / unrolled_time);
    
    free(arr1);
    free(arr2);
}
```

### Loop Fusion and Fission

Combining or splitting loops can improve cache performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 1000000

// Loop fusion example
void fused_loops(float* a, float* b, float* c, float* d, int n) {
    for (int i = 0; i < n; i++) {
        a[i] = b[i] + c[i];  // First operation
        d[i] = a[i] * 2.0f;  // Second operation (depends on first)
    }
}

// Loop fission example
void fissioned_loops(float* a, float* b, float* c, float* d, int n) {
    // First loop
    for (int i = 0; i < n; i++) {
        a[i] = b[i] + c[i];
    }
    
    // Second loop
    for (int i = 0; i < n; i++) {
        d[i] = a[i] * 2.0f;
    }
}

// Cache-friendly loop fusion
void cache_friendly_fusion(float* a, float* b, float* c, float* d, int n) {
    const int block_size = 1024;  // Cache line friendly
    
    for (int block = 0; block < n; block += block_size) {
        int end = (block + block_size < n) ? block + block_size : n;
        
        // Process block
        for (int i = block; i < end; i++) {
            a[i] = b[i] + c[i];
            d[i] = a[i] * 2.0f;
        }
    }
}

// Performance comparison
void compare_loop_transformations(void) {
    float* a1 = malloc(SIZE * sizeof(float));
    float* b1 = malloc(SIZE * sizeof(float));
    float* c1 = malloc(SIZE * sizeof(float));
    float* d1 = malloc(SIZE * sizeof(float));
    
    float* a2 = malloc(SIZE * sizeof(float));
    float* b2 = malloc(SIZE * sizeof(float));
    float* c2 = malloc(SIZE * sizeof(float));
    float* d2 = malloc(SIZE * sizeof(float));
    
    float* a3 = malloc(SIZE * sizeof(float));
    float* b3 = malloc(SIZE * sizeof(float));
    float* c3 = malloc(SIZE * sizeof(float));
    float* d3 = malloc(SIZE * sizeof(float));
    
    // Initialize arrays
    for (int i = 0; i < SIZE; i++) {
        b1[i] = b2[i] = b3[i] = (float)i;
        c1[i] = c2[i] = c3[i] = (float)(i * 2);
    }
    
    struct timespec start, end;
    
    // Test fused loops
    clock_gettime(CLOCK_MONOTONIC, &start);
    fused_loops(a1, b1, c1, d1, SIZE);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double fused_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test fissioned loops
    clock_gettime(CLOCK_MONOTONIC, &start);
    fissioned_loops(a2, b2, c2, d2, SIZE);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double fissioned_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test cache-friendly fusion
    clock_gettime(CLOCK_MONOTONIC, &start);
    cache_friendly_fusion(a3, b3, c3, d3, SIZE);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double cache_friendly_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Loop Transformation Performance (n=%d):\n", SIZE);
    printf("  Fused Loops:        %.6f seconds\n", fused_time);
    printf("  Fissioned Loops:    %.6f seconds\n", fissioned_time);
    printf("  Cache-Friendly:     %.6f seconds\n", cache_friendly_time);
    
    free(a1); free(b1); free(c1); free(d1);
    free(a2); free(b2); free(c2); free(d2);
    free(a3); free(b3); free(c3); free(d3);
}
```

## Data Structure Optimization

Choosing the right data structures can have a dramatic impact on performance.

### Array vs Linked List

Different data structures have different performance characteristics:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Array-based implementation
typedef struct {
    int* data;
    int size;
    int capacity;
} array_list_t;

array_list_t* array_list_create(int initial_capacity) {
    array_list_t* list = malloc(sizeof(array_list_t));
    list->data = malloc(initial_capacity * sizeof(int));
    list->size = 0;
    list->capacity = initial_capacity;
    return list;
}

void array_list_append(array_list_t* list, int value) {
    if (list->size >= list->capacity) {
        list->capacity *= 2;
        list->data = realloc(list->data, list->capacity * sizeof(int));
    }
    list->data[list->size++] = value;
}

int array_list_get(array_list_t* list, int index) {
    if (index >= 0 && index < list->size) {
        return list->data[index];
    }
    return -1;
}

void array_list_free(array_list_t* list) {
    free(list->data);
    free(list);
}

// Linked list implementation
typedef struct node {
    int data;
    struct node* next;
} node_t;

typedef struct {
    node_t* head;
    int size;
} linked_list_t;

linked_list_t* linked_list_create(void) {
    linked_list_t* list = malloc(sizeof(linked_list_t));
    list->head = NULL;
    list->size = 0;
    return list;
}

void linked_list_append(linked_list_t* list, int value) {
    node_t* new_node = malloc(sizeof(node_t));
    new_node->data = value;
    new_node->next = NULL;
    
    if (list->head == NULL) {
        list->head = new_node;
    } else {
        node_t* current = list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
    list->size++;
}

int linked_list_get(linked_list_t* list, int index) {
    node_t* current = list->head;
    for (int i = 0; i < index && current != NULL; i++) {
        current = current->next;
    }
    return (current != NULL) ? current->data : -1;
}

void linked_list_free(linked_list_t* list) {
    node_t* current = list->head;
    while (current != NULL) {
        node_t* next = current->next;
        free(current);
        current = next;
    }
    free(list);
}

// Performance comparison
void compare_data_structures(void) {
    const int size = 100000;
    
    struct timespec start, end;
    
    // Test array list
    clock_gettime(CLOCK_MONOTONIC, &start);
    array_list_t* arr_list = array_list_create(1000);
    for (int i = 0; i < size; i++) {
        array_list_append(arr_list, i);
    }
    for (int i = 0; i < size; i += 100) {
        array_list_get(arr_list, i);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double array_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test linked list
    clock_gettime(CLOCK_MONOTONIC, &start);
    linked_list_t* link_list = linked_list_create();
    for (int i = 0; i < size; i++) {
        linked_list_append(link_list, i);
    }
    for (int i = 0; i < size; i += 100) {
        linked_list_get(link_list, i);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double linked_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Data Structure Performance (n=%d):\n", size);
    printf("  Array List:  %.6f seconds\n", array_time);
    printf("  Linked List: %.6f seconds\n", linked_time);
    printf("  Ratio: %.2fx\n", linked_time / array_time);
    
    array_list_free(arr_list);
    linked_list_free(link_list);
}
```

## Compiler Optimization Techniques

Understanding and leveraging compiler optimizations is crucial for performance.

### Compiler Flags and Pragmas

```c
#include <stdio.h>
#include <stdlib.h>

// Function inlining hints
static inline int fast_add(int a, int b) {
    return a + b;
}

// Restrict keyword for pointer aliasing
void vector_add(float* restrict a, float* restrict b, float* restrict c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

// Loop unrolling pragma
void optimized_loop(float* arr, int n) {
    #pragma GCC unroll 4
    for (int i = 0; i < n; i++) {
        arr[i] = arr[i] * 2.0f + 1.0f;
    }
}

// Vectorization hints
void vectorized_operation(float* arr, int n) {
    #pragma GCC ivdep
    for (int i = 0; i < n; i++) {
        arr[i] = arr[i] * arr[i] + 2.0f * arr[i] + 1.0f;
    }
}

// Branch prediction hints
void branch_prediction_example(int* arr, int n) {
    for (int i = 0; i < n; i++) {
        if (__builtin_expect(arr[i] > 0, 1)) {  // Likely true
            arr[i] *= 2;
        } else {
            arr[i] = 0;
        }
    }
}

// Memory alignment
struct aligned_struct {
    int a;
    double b;
    char c;
} __attribute__((aligned(16)));

// Example usage
void compiler_optimization_examples(void) {
    const int size = 1000000;
    float* a = malloc(size * sizeof(float));
    float* b = malloc(size * sizeof(float));
    float* c = malloc(size * sizeof(float));
    
    // Initialize arrays
    for (int i = 0; i < size; i++) {
        a[i] = b[i] = (float)i;
    }
    
    // Test optimized operations
    vector_add(a, b, c, size);
    optimized_loop(c, size);
    vectorized_operation(c, size);
    
    printf("Compiler optimization examples completed\n");
    
    free(a);
    free(b);
    free(c);
}
```

## Mathematical Optimization

Mathematical optimizations can significantly improve performance in numerical computations.

### Fast Mathematical Operations

```c
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>

// Fast integer square root (Newton's method)
int fast_sqrt(int x) {
    if (x == 0) return 0;
    
    int guess = x;
    int better_guess;
    
    do {
        better_guess = (guess + x / guess) / 2;
        if (better_guess >= guess) break;
        guess = better_guess;
    } while (1);
    
    return guess;
}

// Fast integer power
int fast_power(int base, int exp) {
    int result = 1;
    while (exp > 0) {
        if (exp & 1) {
            result *= base;
        }
        base *= base;
        exp >>= 1;
    }
    return result;
}

// Bit manipulation for multiplication by powers of 2
int multiply_by_power_of_2(int value, int power) {
    return value << power;  // Equivalent to value * (2^power)
}

// Bit manipulation for division by powers of 2
int divide_by_power_of_2(int value, int power) {
    return value >> power;  // Equivalent to value / (2^power) for positive numbers
}

// Fast absolute value
int fast_abs(int x) {
    int mask = x >> (sizeof(int) * 8 - 1);
    return (x + mask) ^ mask;
}

// Performance comparison
void compare_mathematical_optimizations(void) {
    const int iterations = 1000000;
    
    struct timespec start, end;
    
    // Test standard sqrt
    clock_gettime(CLOCK_MONOTONIC, &start);
    volatile double sum1 = 0;
    for (int i = 1; i <= iterations; i++) {
        sum1 += sqrt(i);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double sqrt_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test fast sqrt
    clock_gettime(CLOCK_MONOTONIC, &start);
    volatile int sum2 = 0;
    for (int i = 1; i <= iterations; i++) {
        sum2 += fast_sqrt(i);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double fast_sqrt_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test standard power
    clock_gettime(CLOCK_MONOTONIC, &start);
    volatile int sum3 = 0;
    for (int i = 1; i <= 1000; i++) {
        sum3 += (int)pow(2, i % 10);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double power_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test fast power
    clock_gettime(CLOCK_MONOTONIC, &start);
    volatile int sum4 = 0;
    for (int i = 1; i <= 1000; i++) {
        sum4 += fast_power(2, i % 10);
    }
    clock_gettime(CLOCK_MONOTONIC, &end);
    double fast_power_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Mathematical Optimization Performance:\n");
    printf("  Standard sqrt: %.6f seconds\n", sqrt_time);
    printf("  Fast sqrt:     %.6f seconds\n", fast_sqrt_time);
    printf("  Standard power: %.6f seconds\n", power_time);
    printf("  Fast power:     %.6f seconds\n", fast_power_time);
}
```

## Practical Examples

### Image Processing Optimization

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define IMAGE_WIDTH 1920
#define IMAGE_HEIGHT 1080

// Simple image structure
typedef struct {
    unsigned char* data;
    int width;
    int height;
} image_t;

// Create image
image_t* create_image(int width, int height) {
    image_t* img = malloc(sizeof(image_t));
    img->data = malloc(width * height * sizeof(unsigned char));
    img->width = width;
    img->height = height;
    return img;
}

// Free image
void free_image(image_t* img) {
    free(img->data);
    free(img);
}

// Naive blur implementation
void naive_blur(image_t* src, image_t* dst) {
    for (int y = 1; y < src->height - 1; y++) {
        for (int x = 1; x < src->width - 1; x++) {
            int sum = 0;
            for (int ky = -1; ky <= 1; ky++) {
                for (int kx = -1; kx <= 1; kx++) {
                    sum += src->data[(y + ky) * src->width + (x + kx)];
                }
            }
            dst->data[y * src->width + x] = sum / 9;
        }
    }
}

// Optimized blur with loop unrolling
void optimized_blur(image_t* src, image_t* dst) {
    for (int y = 1; y < src->height - 1; y++) {
        for (int x = 1; x < src->width - 1; x++) {
            // Unroll the inner loops
            int sum = src->data[(y-1) * src->width + (x-1)] +
                      src->data[(y-1) * src->width + x] +
                      src->data[(y-1) * src->width + (x+1)] +
                      src->data[y * src->width + (x-1)] +
                      src->data[y * src->width + x] +
                      src->data[y * src->width + (x+1)] +
                      src->data[(y+1) * src->width + (x-1)] +
                      src->data[(y+1) * src->width + x] +
                      src->data[(y+1) * src->width + (x+1)];
            dst->data[y * src->width + x] = sum / 9;
        }
    }
}

// SIMD-style optimization using multiple operations per loop
void simd_style_blur(image_t* src, image_t* dst) {
    for (int y = 1; y < src->height - 1; y++) {
        // Process 4 pixels at a time
        for (int x = 1; x < src->width - 4; x += 4) {
            // Process 4 pixels in parallel (simplified)
            for (int i = 0; i < 4; i++) {
                int sum = src->data[(y-1) * src->width + (x+i-1)] +
                          src->data[(y-1) * src->width + (x+i)] +
                          src->data[(y-1) * src->width + (x+i+1)] +
                          src->data[y * src->width + (x+i-1)] +
                          src->data[y * src->width + (x+i)] +
                          src->data[y * src->width + (x+i+1)] +
                          src->data[(y+1) * src->width + (x+i-1)] +
                          src->data[(y+1) * src->width + (x+i)] +
                          src->data[(y+1) * src->width + (x+i+1)];
                dst->data[y * src->width + (x+i)] = sum / 9;
            }
        }
    }
}

// Performance comparison
void compare_image_processing(void) {
    image_t* src = create_image(IMAGE_WIDTH, IMAGE_HEIGHT);
    image_t* dst1 = create_image(IMAGE_WIDTH, IMAGE_HEIGHT);
    image_t* dst2 = create_image(IMAGE_WIDTH, IMAGE_HEIGHT);
    image_t* dst3 = create_image(IMAGE_WIDTH, IMAGE_HEIGHT);
    
    // Initialize source image with random data
    for (int i = 0; i < IMAGE_WIDTH * IMAGE_HEIGHT; i++) {
        src->data[i] = rand() % 256;
    }
    
    struct timespec start, end;
    
    // Test naive blur
    clock_gettime(CLOCK_MONOTONIC, &start);
    naive_blur(src, dst1);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double naive_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test optimized blur
    clock_gettime(CLOCK_MONOTONIC, &start);
    optimized_blur(src, dst2);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double optimized_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Test SIMD-style blur
    clock_gettime(CLOCK_MONOTONIC, &start);
    simd_style_blur(src, dst3);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double simd_time = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Image Processing Performance (%dx%d):\n", IMAGE_WIDTH, IMAGE_HEIGHT);
    printf("  Naive Blur:     %.6f seconds\n", naive_time);
    printf("  Optimized Blur: %.6f seconds\n", optimized_time);
    printf("  SIMD-style:     %.6f seconds\n", simd_time);
    printf("  Speedup:        %.2fx\n", naive_time / simd_time);
    
    free_image(src);
    free_image(dst1);
    free_image(dst2);
    free_image(dst3);
}
```

## Summary

Optimization techniques in C programming encompass a wide range of approaches:

1. **Algorithmic Optimization** - Choosing better algorithms and data structures
2. **Loop Optimization** - Unrolling, fusion, and restructuring loops
3. **Data Structure Optimization** - Selecting appropriate data structures for the task
4. **Compiler Optimization** - Leveraging compiler features and flags
5. **Mathematical Optimization** - Fast mathematical operations and bit manipulation
6. **Memory Access Optimization** - Improving cache locality and reducing memory overhead

Key principles for effective optimization:
- Profile first to identify actual bottlenecks
- Focus on algorithmic improvements before micro-optimizations
- Understand the trade-offs between performance and maintainability
- Use appropriate compiler optimization flags
- Consider the target hardware architecture
- Test optimizations thoroughly to ensure correctness
- Document optimization decisions for future maintenance

These techniques enable developers to create high-performance C applications that efficiently utilize system resources while maintaining code quality and readability.