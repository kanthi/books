# Memory Optimization

## Introduction

Memory optimization is a critical aspect of performance tuning in C programs, especially in resource-constrained environments and high-performance applications. Efficient memory management can significantly impact program performance through improved cache utilization, reduced allocation overhead, and better data locality. This chapter explores techniques for optimizing memory usage, from allocation strategies to cache-friendly data structures.

## Memory Hierarchy and Performance

Understanding the memory hierarchy is fundamental to effective memory optimization. Modern computer systems have multiple levels of memory with vastly different access times.

### Memory Latency Comparison

```c
#include <stdio.h>
#include <time.h>
#include <stdlib.h>

// Example illustrating memory access time differences
void memory_latency_example(void) {
    printf("Typical Access Times:\n");
    printf("- CPU Register: ~0.3 ns\n");
    printf("- L1 Cache:     ~1 ns\n");
    printf("- L2 Cache:     ~4 ns\n");
    printf("- L3 Cache:     ~15 ns\n");
    printf("- Main Memory:  ~100 ns\n");
    printf("- SSD:          ~10 μs\n");
    printf("- HDD:          ~10 ms\n");
}
```

### Cache Behavior Impact

Cache misses can cause significant performance degradation. Understanding how data is accessed affects cache performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_SIZE 1024
#define ITERATIONS 100

// Row-major access (cache-friendly)
double row_major_sum(double matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    double sum = 0.0;
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            sum += matrix[i][j];
        }
    }
    return sum;
}

// Column-major access (cache-unfriendly)
double column_major_sum(double matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    double sum = 0.0;
    for (int j = 0; j < MATRIX_SIZE; j++) {
        for (int i = 0; i < MATRIX_SIZE; i++) {
            sum += matrix[i][j];
        }
    }
    return sum;
}

void cache_performance_comparison(void) {
    double (*matrix)[MATRIX_SIZE] = malloc(MATRIX_SIZE * sizeof(*matrix));
    
    // Initialize matrix
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            matrix[i][j] = (double)(i * MATRIX_SIZE + j);
        }
    }
    
    clock_t start, end;
    
    // Row-major timing
    start = clock();
    for (int i = 0; i < ITERATIONS; i++) {
        volatile double sum = row_major_sum(matrix);
    }
    end = clock();
    double row_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Column-major timing
    start = clock();
    for (int i = 0; i < ITERATIONS; i++) {
        volatile double sum = column_major_sum(matrix);
    }
    end = clock();
    double col_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Row-major time: %.4f seconds\n", row_time);
    printf("Column-major time: %.4f seconds\n", col_time);
    printf("Performance difference: %.2fx\n", col_time / row_time);
    
    free(matrix);
}
```

## Memory Allocation Optimization

Standard memory allocation functions like `malloc()` (see [system programming](../08-file-io/04-system-programming.md)) and `free()` (see [linear structures](../10-data-structures/01-linear-structures.md)) can be significant performance bottlenecks in performance-critical applications.

### Custom Memory Allocators

For specific use cases, custom allocators can provide significant performance improvements:

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>

// Simple pool allocator
typedef struct {
    void *memory_pool;
    size_t pool_size;
    size_t block_size;
    size_t num_blocks;
    uint8_t *free_blocks;
    size_t next_free;
} pool_allocator_t;

// Initialize pool allocator
pool_allocator_t* pool_init(size_t block_size, size_t num_blocks) {
    pool_allocator_t *pool = malloc(sizeof(pool_allocator_t));
    if (!pool) return NULL;
    
    pool->pool_size = block_size * num_blocks;
    pool->memory_pool = malloc(pool->pool_size);
    if (!pool->memory_pool) {
        free(pool);
        return NULL;
    }
    
    pool->block_size = block_size;
    pool->num_blocks = num_blocks;
    pool->free_blocks = calloc(num_blocks, sizeof(uint8_t));
    pool->next_free = 0;
    
    return pool;
}

// Allocate block from pool
void* pool_alloc(pool_allocator_t *pool) {
    if (!pool || pool->next_free >= pool->num_blocks) {
        return NULL;  // Pool exhausted
    }
    
    // Find free block
    for (size_t i = 0; i < pool->num_blocks; i++) {
        size_t index = (pool->next_free + i) % pool->num_blocks;
        if (!pool->free_blocks[index]) {
            pool->free_blocks[index] = 1;
            pool->next_free = (index + 1) % pool->num_blocks;
            return (char*)pool->memory_pool + (index * pool->block_size);
        }
    }
    
    return NULL;  // Should not happen
}

// Free block back to pool
void pool_free(pool_allocator_t *pool, void *ptr) {
    if (!pool || !ptr) return;
    
    // Calculate block index
    ptrdiff_t offset = (char*)ptr - (char*)pool->memory_pool;
    if (offset < 0 || offset >= (ptrdiff_t)pool->pool_size) return;
    
    size_t index = offset / pool->block_size;
    if (index < pool->num_blocks) {
        pool->free_blocks[index] = 0;
        pool->next_free = index;  // Prefer this block for next allocation
    }
}

// Destroy pool allocator
void pool_destroy(pool_allocator_t *pool) {
    if (pool) {
        free(pool->memory_pool);
        free(pool->free_blocks);
        free(pool);
    }
}

// Example usage
void pool_allocator_example(void) {
    // Create pool for 100 blocks of 64 bytes each
    pool_allocator_t *pool = pool_init(64, 100);
    if (!pool) {
        printf("Failed to create pool\n");
        return;
    }
    
    // Allocate some blocks
    void *ptr1 = pool_alloc(pool);
    void *ptr2 = pool_alloc(pool);
    void *ptr3 = pool_alloc(pool);
    
    printf("Allocated 3 blocks\n");
    
    // Free some blocks
    pool_free(pool, ptr1);
    pool_free(pool, ptr3);
    
    printf("Freed 2 blocks\n");
    
    // Allocate more blocks (should reuse freed ones)
    void *ptr4 = pool_alloc(pool);
    void *ptr5 = pool_alloc(pool);
    
    printf("Allocated 2 more blocks\n");
    
    // Cleanup
    pool_destroy(pool);
}
```

### Stack Allocation vs Heap Allocation

Stack allocation is significantly faster than heap allocation but has size and lifetime limitations:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 10000
#define ITERATIONS 100000

// Stack allocation
void stack_allocation_test(void) {
    // Fast allocation on stack
    int array[ARRAY_SIZE];
    
    // Initialize array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i;
    }
}

// Heap allocation
void heap_allocation_test(void) {
    // Slower allocation on heap
    int *array = malloc(ARRAY_SIZE * sizeof(int));
    if (array) {
        // Initialize array
        for (int i = 0; i < ARRAY_SIZE; i++) {
            array[i] = i;
        }
        free(array);
    }
}

void allocation_performance_comparison(void) {
    clock_t start, end;
    
    // Stack allocation timing
    start = clock();
    for (int i = 0; i < ITERATIONS; i++) {
        stack_allocation_test();
    }
    end = clock();
    double stack_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Heap allocation timing
    start = clock();
    for (int i = 0; i < ITERATIONS; i++) {
        heap_allocation_test();
    }
    end = clock();
    double heap_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Stack allocation time: %.4f seconds\n", stack_time);
    printf("Heap allocation time: %.4f seconds\n", heap_time);
    printf("Stack is %.2fx faster\n", heap_time / stack_time);
}
```

## Data Structure Optimization

Choosing the right data structures and organizing them for cache efficiency can dramatically improve performance.

### Structure of Arrays vs Array of Structures

The way data is organized in memory can significantly impact cache performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define NUM_POINTS 1000000

// Array of Structures (AoS) - cache-unfriendly for component-wise operations
typedef struct {
    float x, y, z;
} point_aos_t;

// Structure of Arrays (SoA) - cache-friendly for component-wise operations
typedef struct {
    float *x, *y, *z;
} point_soa_t;

// Initialize AoS
point_aos_t* init_aos(int count) {
    point_aos_t *points = malloc(count * sizeof(point_aos_t));
    for (int i = 0; i < count; i++) {
        points[i].x = (float)i;
        points[i].y = (float)(i * 2);
        points[i].z = (float)(i * 3);
    }
    return points;
}

// Initialize SoA
point_soa_t* init_soa(int count) {
    point_soa_t *points = malloc(sizeof(point_soa_t));
    points->x = malloc(count * sizeof(float));
    points->y = malloc(count * sizeof(float));
    points->z = malloc(count * sizeof(float));
    
    for (int i = 0; i < count; i++) {
        points->x[i] = (float)i;
        points->y[i] = (float)(i * 2);
        points->z[i] = (float)(i * 3);
    }
    return points;
}

// Process all x coordinates (AoS version)
float process_x_aos(point_aos_t *points, int count) {
    float sum = 0.0f;
    for (int i = 0; i < count; i++) {
        sum += points[i].x * 2.0f;
    }
    return sum;
}

// Process all x coordinates (SoA version)
float process_x_soa(point_soa_t *points, int count) {
    float sum = 0.0f;
    for (int i = 0; i < count; i++) {
        sum += points->x[i] * 2.0f;
    }
    return sum;
}

void aos_vs_soa_comparison(void) {
    point_aos_t *aos_points = init_aos(NUM_POINTS);
    point_soa_t *soa_points = init_soa(NUM_POINTS);
    
    clock_t start, end;
    
    // AoS timing
    start = clock();
    volatile float aos_result = process_x_aos(aos_points, NUM_POINTS);
    end = clock();
    double aos_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // SoA timing
    start = clock();
    volatile float soa_result = process_x_soa(soa_points, NUM_POINTS);
    end = clock();
    double soa_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("AoS processing time: %.4f seconds\n", aos_time);
    printf("SoA processing time: %.4f seconds\n", soa_time);
    printf("SoA is %.2fx faster\n", aos_time / soa_time);
    
    // Cleanup
    free(aos_points);
    free(soa_points->x);
    free(soa_points->y);
    free(soa_points->z);
    free(soa_points);
}
```

### Memory Alignment

Proper memory alignment can improve performance by ensuring efficient memory access:

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdalign.h>
#include <time.h>

#define ARRAY_SIZE 1000000

// Unaligned structure
typedef struct {
    char a;      // 1 byte
    int b;       // 4 bytes (3 bytes padding before)
    short c;     // 2 bytes
    // 1 byte padding at end
} unaligned_struct_t;

// Aligned structure
typedef struct {
    alignas(16) int b;    // 4 bytes, aligned to 16-byte boundary
    char a;               // 1 byte
    short c;              // 2 bytes
    // 9 bytes padding at end for 16-byte alignment
} aligned_struct_t;

void alignment_performance_test(void) {
    // Allocate arrays
    unaligned_struct_t *unaligned_array = malloc(ARRAY_SIZE * sizeof(unaligned_struct_t));
    aligned_struct_t *aligned_array = malloc(ARRAY_SIZE * sizeof(aligned_struct_t));
    
    clock_t start, end;
    
    // Test unaligned access
    start = clock();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        unaligned_array[i].b = i * 2;
    }
    end = clock();
    double unaligned_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Test aligned access
    start = clock();
    for (int i = 0; i < ARRAY_SIZE; i++) {
        aligned_array[i].b = i * 2;
    }
    end = clock();
    double aligned_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Unaligned access time: %.4f seconds\n", unaligned_time);
    printf("Aligned access time: %.4f seconds\n", aligned_time);
    printf("Aligned is %.2fx faster\n", unaligned_time / aligned_time);
    
    // Print structure sizes
    printf("Unaligned struct size: %zu bytes\n", sizeof(unaligned_struct_t));
    printf("Aligned struct size: %zu bytes\n", sizeof(aligned_struct_t));
    
    free(unaligned_array);
    free(aligned_array);
}
```

## Memory Layout Optimization

Understanding and optimizing memory layout can lead to significant performance improvements.

### Data Locality

Keeping related data close together in memory improves cache performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_ROWS 1000
#define MATRIX_COLS 1000

// Poor data locality - accessing data with large strides
void poor_locality_example(int **matrix) {
    long sum = 0;
    // Access data column by column (poor cache usage)
    for (int col = 0; col < MATRIX_COLS; col++) {
        for (int row = 0; row < MATRIX_ROWS; row++) {
            sum += matrix[row][col];
        }
    }
    // Prevent optimization
    volatile long dummy = sum;
}

// Good data locality - accessing data sequentially
void good_locality_example(int **matrix) {
    long sum = 0;
    // Access data row by row (good cache usage)
    for (int row = 0; row < MATRIX_ROWS; row++) {
        for (int col = 0; col < MATRIX_COLS; col++) {
            sum += matrix[row][col];
        }
    }
    // Prevent optimization
    volatile long dummy = sum;
}

void data_locality_comparison(void) {
    // Allocate matrix
    int **matrix = malloc(MATRIX_ROWS * sizeof(int*));
    for (int i = 0; i < MATRIX_ROWS; i++) {
        matrix[i] = malloc(MATRIX_COLS * sizeof(int));
        for (int j = 0; j < MATRIX_COLS; j++) {
            matrix[i][j] = i * MATRIX_COLS + j;
        }
    }
    
    clock_t start, end;
    
    // Poor locality timing
    start = clock();
    poor_locality_example(matrix);
    end = clock();
    double poor_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Good locality timing
    start = clock();
    good_locality_example(matrix);
    end = clock();
    double good_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Poor locality time: %.4f seconds\n", poor_time);
    printf("Good locality time: %.4f seconds\n", good_time);
    printf("Good locality is %.2fx faster\n", poor_time / good_time);
    
    // Cleanup
    for (int i = 0; i < MATRIX_ROWS; i++) {
        free(matrix[i]);
    }
    free(matrix);
}
```

### Memory Pooling

Memory pooling can reduce allocation overhead and improve data locality:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define POOL_SIZE 1024 * 1024  // 1MB pool
#define BLOCK_SIZE 256

typedef struct memory_block {
    struct memory_block *next;
    size_t size;
    int in_use;
    char data[1];  // Flexible array member
} memory_block_t;

typedef struct {
    char *pool_start;
    char *pool_end;
    memory_block_t *free_list;
    size_t total_size;
} memory_pool_t;

// Initialize memory pool
memory_pool_t* pool_create(size_t size) {
    memory_pool_t *pool = malloc(sizeof(memory_pool_t));
    if (!pool) return NULL;
    
    pool->pool_start = malloc(size);
    if (!pool->pool_start) {
        free(pool);
        return NULL;
    }
    
    pool->pool_end = pool->pool_start + size;
    pool->total_size = size;
    pool->free_list = (memory_block_t*)pool->pool_start;
    
    // Initialize first block to cover entire pool
    pool->free_list->next = NULL;
    pool->free_list->size = size - sizeof(memory_block_t);
    pool->free_list->in_use = 0;
    
    return pool;
}

// Allocate memory from pool
void* pool_malloc(memory_pool_t *pool, size_t size) {
    if (!pool || size == 0) return NULL;
    
    // Add space for block header
    size_t required_size = sizeof(memory_block_t) + size;
    
    // Find suitable block
    memory_block_t *prev = NULL;
    memory_block_t *current = pool->free_list;
    
    while (current) {
        if (!current->in_use && current->size >= size) {
            // Found suitable block
            current->in_use = 1;
            
            // Split block if large enough
            size_t remaining = current->size - size;
            if (remaining > sizeof(memory_block_t) + 32) {  // Minimum block size
                memory_block_t *new_block = (memory_block_t*)
                    ((char*)current + sizeof(memory_block_t) + size);
                new_block->size = remaining - sizeof(memory_block_t);
                new_block->in_use = 0;
                new_block->next = current->next;
                
                current->size = size;
                current->next = new_block;
            }
            
            return current->data;
        }
        
        prev = current;
        current = current->next;
    }
    
    return NULL;  // No suitable block found
}

// Free memory back to pool
void pool_free(memory_pool_t *pool, void *ptr) {
    if (!pool || !ptr) return;
    
    // Get block header
    memory_block_t *block = (memory_block_t*)((char*)ptr - sizeof(memory_block_t));
    block->in_use = 0;
    
    // Coalesce adjacent free blocks
    memory_block_t *current = pool->free_list;
    while (current) {
        if (!current->in_use) {
            // Check next block
            memory_block_t *next = current->next;
            if (next && !next->in_use) {
                // Merge with next block
                current->size += sizeof(memory_block_t) + next->size;
                current->next = next->next;
                continue;  // Check same block again
            }
        }
        current = current->next;
    }
}

// Destroy memory pool
void pool_destroy(memory_pool_t *pool) {
    if (pool) {
        free(pool->pool_start);
        free(pool);
    }
}

// Example usage
void memory_pool_example(void) {
    memory_pool_t *pool = pool_create(POOL_SIZE);
    if (!pool) {
        printf("Failed to create memory pool\n");
        return;
    }
    
    printf("Created memory pool of %zu bytes\n", POOL_SIZE);
    
    // Allocate some blocks
    void *ptr1 = pool_malloc(pool, 128);
    void *ptr2 = pool_malloc(pool, 256);
    void *ptr3 = pool_malloc(pool, 64);
    
    printf("Allocated 3 blocks\n");
    
    // Free some blocks
    pool_free(pool, ptr1);
    pool_free(pool, ptr3);
    
    printf("Freed 2 blocks\n");
    
    // Allocate more blocks (should reuse freed space)
    void *ptr4 = pool_malloc(pool, 96);
    void *ptr5 = pool_malloc(pool, 160);
    
    printf("Allocated 2 more blocks\n");
    
    // Cleanup
    pool_destroy(pool);
}
```

## Memory Access Patterns

Understanding and optimizing memory access patterns can significantly improve performance.

### Sequential vs Random Access

Sequential memory access is much faster than random access due to cache behavior:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000000
#define ACCESS_COUNT 1000000

void sequential_access_test(int *array) {
    long sum = 0;
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += array[i];
    }
    // Prevent optimization
    volatile long dummy = sum;
}

void random_access_test(int *array) {
    long sum = 0;
    // Access elements in random order
    for (int i = 0; i < ARRAY_SIZE; i++) {
        int index = rand() % ARRAY_SIZE;
        sum += array[index];
    }
    // Prevent optimization
    volatile long dummy = sum;
}

void access_pattern_comparison(void) {
    int *array = malloc(ARRAY_SIZE * sizeof(int));
    if (!array) {
        printf("Failed to allocate array\n");
        return;
    }
    
    // Initialize array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i;
    }
    
    clock_t start, end;
    
    // Sequential access timing
    start = clock();
    sequential_access_test(array);
    end = clock();
    double sequential_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Random access timing
    srand(42);  // Fixed seed for reproducible results
    start = clock();
    random_access_test(array);
    end = clock();
    double random_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Sequential access time: %.4f seconds\n", sequential_time);
    printf("Random access time: %.4f seconds\n", random_time);
    printf("Sequential is %.2fx faster\n", random_time / sequential_time);
    
    free(array);
}
```

## Practical Memory Optimization Techniques

### Reducing Memory Fragmentation

Memory fragmentation can lead to inefficient memory usage and allocation failures:

```c
#include <stdio.h>
#include <stdlib.h>

#define POOL_SIZE 10000

// Simple example showing fragmentation
void fragmentation_example(void) {
    void *ptrs[1000];
    
    printf("Demonstrating memory fragmentation:\n");
    
    // Allocate many small blocks
    for (int i = 0; i < 1000; i++) {
        ptrs[i] = malloc(10);
        if (!ptrs[i]) {
            printf("Allocation failed at %d\n", i);
            return;
        }
    }
    
    // Free every other block
    for (int i = 0; i < 1000; i += 2) {
        free(ptrs[i]);
        ptrs[i] = NULL;
    }
    
    // Try to allocate a larger block
    void *large_block = malloc(500);
    if (large_block) {
        printf("Large block allocation succeeded\n");
        free(large_block);
    } else {
        printf("Large block allocation failed due to fragmentation\n");
    }
    
    // Free remaining blocks
    for (int i = 1; i < 1000; i += 2) {
        if (ptrs[i]) {
            free(ptrs[i]);
        }
    }
}
```

### Memory Prefetching

Modern processors support prefetching instructions to improve memory access performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000000

// Manual prefetching example
void prefetch_example(int *array) {
    long sum = 0;
    
    for (int i = 0; i < ARRAY_SIZE; i++) {
        // Prefetch next cache line (typically 64 bytes)
        if (i + 16 < ARRAY_SIZE) {
            __builtin_prefetch(&array[i + 16], 0, 3);
        }
        
        sum += array[i];
    }
    
    // Prevent optimization
    volatile long dummy = sum;
}

// Without prefetching
void no_prefetch_example(int *array) {
    long sum = 0;
    
    for (int i = 0; i < ARRAY_SIZE; i++) {
        sum += array[i];
    }
    
    // Prevent optimization
    volatile long dummy = sum;
}

void prefetch_comparison(void) {
    int *array = malloc(ARRAY_SIZE * sizeof(int));
    if (!array) {
        printf("Failed to allocate array\n");
        return;
    }
    
    // Initialize array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i;
    }
    
    clock_t start, end;
    
    // Without prefetching
    start = clock();
    no_prefetch_example(array);
    end = clock();
    double no_prefetch_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // With prefetching
    start = clock();
    prefetch_example(array);
    end = clock();
    double prefetch_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Without prefetching: %.4f seconds\n", no_prefetch_time);
    printf("With prefetching: %.4f seconds\n", prefetch_time);
    printf("Prefetching improvement: %.2fx\n", no_prefetch_time / prefetch_time);
    
    free(array);
}
```

## Memory Debugging and Analysis

Tools and techniques for analyzing memory usage and identifying optimization opportunities.

### Simple Memory Tracker

A basic memory tracking system to monitor allocations:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple memory tracker
typedef struct mem_block {
    struct mem_block *next;
    void *ptr;
    size_t size;
    const char *file;
    int line;
} mem_block_t;

static mem_block_t *mem_list = NULL;
static size_t total_allocated = 0;
static size_t peak_allocated = 0;
static size_t allocation_count = 0;

// Track memory allocation
void* tracked_malloc(size_t size, const char *file, int line) {
    void *ptr = malloc(size);
    if (!ptr) return NULL;
    
    // Add to tracking list
    mem_block_t *block = malloc(sizeof(mem_block_t));
    if (!block) {
        free(ptr);
        return NULL;
    }
    
    block->ptr = ptr;
    block->size = size;
    block->file = file;
    block->line = line;
    block->next = mem_list;
    mem_list = block;
    
    total_allocated += size;
    allocation_count++;
    
    if (total_allocated > peak_allocated) {
        peak_allocated = total_allocated;
    }
    
    return ptr;
}

// Track memory deallocation
void tracked_free(void *ptr, const char *file, int line) {
    if (!ptr) return;
    
    // Find and remove from tracking list
    mem_block_t *prev = NULL;
    mem_block_t *current = mem_list;
    
    while (current) {
        if (current->ptr == ptr) {
            if (prev) {
                prev->next = current->next;
            } else {
                mem_list = current->next;
            }
            
            total_allocated -= current->size;
            free(current);
            free(ptr);
            return;
        }
        
        prev = current;
        current = current->next;
    }
    
    // Not found in tracking list - possible double free
    printf("Warning: Attempt to free untracked pointer at %s:%d\n", file, line);
    free(ptr);
}

// Print memory statistics
void print_memory_stats(void) {
    printf("\n=== Memory Statistics ===\n");
    printf("Total allocations: %zu\n", allocation_count);
    printf("Currently allocated: %zu bytes\n", total_allocated);
    printf("Peak allocation: %zu bytes\n", peak_allocated);
    
    if (mem_list) {
        printf("Leaked blocks:\n");
        mem_block_t *current = mem_list;
        while (current) {
            printf("  %p: %zu bytes at %s:%d\n", 
                   current->ptr, current->size, current->file, current->line);
            current = current->next;
        }
    } else {
        printf("No memory leaks detected\n");
    }
}

// Cleanup tracking (call at program exit)
void cleanup_memory_tracking(void) {
    mem_block_t *current = mem_list;
    while (current) {
        mem_block_t *next = current->next;
        free(current->ptr);
        free(current);
        current = next;
    }
    mem_list = NULL;
}

// Macros for easier usage
#define MALLOC(size) tracked_malloc(size, __FILE__, __LINE__)
#define FREE(ptr) tracked_free(ptr, __FILE__, __LINE__)

// Example usage
void memory_tracking_example(void) {
    printf("Memory tracking example:\n");
    
    // Allocate some memory
    int *array1 = (int*)MALLOC(100 * sizeof(int));
    char *string = (char*)MALLOC(50);
    
    // Use the memory
    for (int i = 0; i < 100; i++) {
        array1[i] = i;
    }
    strcpy(string, "Hello, World!");
    
    printf("Allocated array and string\n");
    print_memory_stats();
    
    // Free one block
    FREE(array1);
    printf("Freed array\n");
    print_memory_stats();
    
    // Intentionally leak string to demonstrate leak detection
    printf("Intentionally leaking string...\n");
    print_memory_stats();
    
    // Cleanup
    cleanup_memory_tracking();
}
```

## Summary

Memory optimization is a multifaceted discipline that requires understanding of:

1. **Memory Hierarchy** - How different levels of memory affect performance
2. **Allocation Strategies** - Custom allocators, stack vs heap allocation
3. **Data Structure Design** - Structure of Arrays vs Array of Structures, alignment
4. **Memory Layout** - Data locality, memory pooling
5. **Access Patterns** - Sequential vs random access, prefetching
6. **Fragmentation Management** - Reducing memory fragmentation
7. **Analysis Tools** - Memory tracking and debugging

Key principles for effective memory optimization:

- **Profile First** - Measure before and after optimization to verify improvements
- **Understand Your Data** - Know how your data is accessed and sized
- **Consider the Cache** - Design for cache-friendly access patterns
- **Minimize Allocations** - Reduce allocation frequency and overhead
- **Track Memory Usage** - Monitor for leaks and fragmentation
- **Use Appropriate Tools** - Leverage profilers and analysis tools

These techniques, when applied appropriately, can lead to significant performance improvements in C programs, especially in resource-constrained or performance-critical applications.