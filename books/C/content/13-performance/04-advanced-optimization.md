# Advanced Optimization

## Introduction

Advanced optimization techniques go beyond basic algorithmic improvements to leverage hardware-specific features, compiler optimizations, and parallel processing capabilities. This chapter explores sophisticated methods for maximizing performance in C programs, including vectorization, parallel processing, compiler-assisted optimizations, and specialized techniques for specific architectures.

## Compiler Optimization

Modern compilers provide powerful optimization capabilities that can significantly improve performance with minimal programmer effort.

### Optimization Levels

Different compiler optimization levels offer varying degrees of optimization:

```c
// Example showing the impact of different optimization levels
// Compile with: gcc -O0, -O1, -O2, -O3, -Os

#include <stdio.h>
#include <time.h>

#define ITERATIONS 100000000

// Simple loop that can be optimized
int compute_sum(int n) {
    int sum = 0;
    for (int i = 0; i < n; i++) {
        sum += i * 2 + 1;
    }
    return sum;
}

void optimization_levels_demo(void) {
    clock_t start = clock();
    volatile int result = compute_sum(ITERATIONS);
    clock_t end = clock();
    
    double time_spent = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Computation time: %.4f seconds\n", time_spent);
}
```

### Compiler Hints and Pragmas

Compiler hints can guide optimization decisions:

```c
#include <stdio.h>
#include <stdlib.h>

// Function likely to be called frequently
__attribute__((hot)) 
int hot_function(int x) {
    return x * x + 2 * x + 1;
}

// Function unlikely to be called
__attribute__((cold)) 
void error_handler(void) {
    printf("Error occurred!\n");
    exit(1);
}

// Loop unrolling hint
void loop_unrolling_example(void) {
    int array[1000];
    
    // Hint to unroll this loop
    #pragma GCC unroll 4
    for (int i = 0; i < 1000; i++) {
        array[i] = i * i;
    }
}

// Vectorization hints
void vectorization_example(float *a, float *b, float *c, int n) {
    // Tell compiler this loop can be vectorized
    #pragma GCC ivdep
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}
```

### Profile-Guided Optimization (PGO)

PGO uses runtime profiling data to optimize code placement and branch prediction:

```c
// Example of code that benefits from PGO
#include <stdio.h>

int process_data(int data) {
    // Branch that depends on input data
    if (data < 100) {
        // Common case
        return data * 2;
    } else if (data < 1000) {
        // Less common case
        return data + 100;
    } else {
        // Rare case
        return data / 2;
    }
}

void pgo_example(void) {
    // In a real PGO scenario, you would run the program with
    // representative data to generate profile data
    for (int i = 0; i < 10000; i++) {
        int result = process_data(i);
        // Use result to prevent optimization
        volatile int dummy = result;
    }
}
```

## Vectorization

Vectorization allows processing multiple data elements simultaneously using SIMD (Single Instruction, Multiple Data) instructions.

### Manual Vectorization with Intrinsics

Using compiler intrinsics for explicit vectorization:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#ifdef __SSE__
#include <xmmintrin.h>  // SSE
#endif

#ifdef __AVX__
#include <immintrin.h>  // AVX
#endif

// Scalar addition
void scalar_add(float *a, float *b, float *c, int n) {
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

#ifdef __SSE__
// SSE vectorized addition
void sse_add(float *a, float *b, float *c, int n) {
    int i = 0;
    
    // Process 4 elements at a time
    for (; i <= n - 4; i += 4) {
        __m128 va = _mm_load_ps(&a[i]);
        __m128 vb = _mm_load_ps(&b[i]);
        __m128 vc = _mm_add_ps(va, vb);
        _mm_store_ps(&c[i], vc);
    }
    
    // Handle remaining elements
    for (; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}
#endif

#ifdef __AVX__
// AVX vectorized addition
void avx_add(float *a, float *b, float *c, int n) {
    int i = 0;
    
    // Process 8 elements at a time
    for (; i <= n - 8; i += 8) {
        __m256 va = _mm256_load_ps(&a[i]);
        __m256 vb = _mm256_load_ps(&b[i]);
        __m256 vc = _mm256_add_ps(va, vb);
        _mm256_store_ps(&c[i], vc);
    }
    
    // Handle remaining elements
    for (; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}
#endif

void vectorization_comparison(void) {
    const int size = 1000000;
    float *a = malloc(size * sizeof(float));
    float *b = malloc(size * sizeof(float));
    float *c = malloc(size * sizeof(float));
    
    // Initialize arrays
    for (int i = 0; i < size; i++) {
        a[i] = (float)i;
        b[i] = (float)(i * 2);
    }
    
    clock_t start, end;
    
    // Scalar version
    start = clock();
    scalar_add(a, b, c, size);
    end = clock();
    double scalar_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
#ifdef __SSE__
    // SSE version
    start = clock();
    sse_add(a, b, c, size);
    end = clock();
    double sse_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("SSE time: %.4f seconds (%.2fx speedup)\n", 
           sse_time, scalar_time / sse_time);
#endif

#ifdef __AVX__
    // AVX version
    start = clock();
    avx_add(a, b, c, size);
    end = clock();
    double avx_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("AVX time: %.4f seconds (%.2fx speedup)\n", 
           avx_time, scalar_time / avx_time);
#endif
    
    printf("Scalar time: %.4f seconds\n", scalar_time);
    
    free(a);
    free(b);
    free(c);
}
```

### Auto-Vectorization

Modern compilers can automatically vectorize suitable loops:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000000

// Compiler can auto-vectorize this function
void auto_vectorizable_loop(float *a, float *b, float *c, int n) {
    // Conditions for auto-vectorization:
    // 1. No dependencies between iterations
    // 2. Simple arithmetic operations
    // 3. Contiguous memory access
    // 4. Known loop bounds
    
    for (int i = 0; i < n; i++) {
        c[i] = a[i] * b[i] + 1.0f;
    }
}

// This loop cannot be auto-vectorized due to dependency
void non_vectorizable_loop(int *a, int n) {
    // Each iteration depends on the previous one
    for (int i = 1; i < n; i++) {
        a[i] = a[i-1] + i;
    }
}

void auto_vectorization_example(void) {
    float *a = malloc(ARRAY_SIZE * sizeof(float));
    float *b = malloc(ARRAY_SIZE * sizeof(float));
    float *c = malloc(ARRAY_SIZE * sizeof(float));
    
    // Initialize arrays
    for (int i = 0; i < ARRAY_SIZE; i++) {
        a[i] = (float)i;
        b[i] = (float)(i * 2);
    }
    
    clock_t start = clock();
    auto_vectorizable_loop(a, b, c, ARRAY_SIZE);
    clock_t end = clock();
    
    double time_spent = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("Auto-vectorized loop time: %.4f seconds\n", time_spent);
    
    // Verify result (check first few elements)
    printf("First 5 results: ");
    for (int i = 0; i < 5; i++) {
        printf("%.0f ", c[i]);
    }
    printf("\n");
    
    free(a);
    free(b);
    free(c);
}
```

## Parallel Processing

Utilizing multiple CPU cores can dramatically improve performance for suitable workloads.

### OpenMP for Shared-Memory Parallelism

OpenMP provides a simple way to parallelize loops and sections:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <omp.h>

#define ARRAY_SIZE 1000000

// Sequential matrix multiplication
void sequential_matrix_mult(int n, double *a, double *b, double *c) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double sum = 0.0;
            for (int k = 0; k < n; k++) {
                sum += a[i * n + k] * b[k * n + j];
            }
            c[i * n + j] = sum;
        }
    }
}

// Parallel matrix multiplication with OpenMP
void parallel_matrix_mult(int n, double *a, double *b, double *c) {
    #pragma omp parallel for
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            double sum = 0.0;
            for (int k = 0; k < n; k++) {
                sum += a[i * n + k] * b[k * n + j];
            }
            c[i * n + j] = sum;
        }
    }
}

// Parallel reduction example
double parallel_sum(double *array, int n) {
    double sum = 0.0;
    
    #pragma omp parallel for reduction(+:sum)
    for (int i = 0; i < n; i++) {
        sum += array[i];
    }
    
    return sum;
}

void openmp_example(void) {
    const int size = 1000;
    double *a = malloc(size * size * sizeof(double));
    double *b = malloc(size * size * sizeof(double));
    double *c = malloc(size * size * sizeof(double));
    
    // Initialize matrices
    for (int i = 0; i < size * size; i++) {
        a[i] = (double)(i % 100);
        b[i] = (double)((i + 1) % 100);
    }
    
    // Measure sequential version
    clock_t start = clock();
    sequential_matrix_mult(size, a, b, c);
    clock_t end = clock();
    double sequential_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Measure parallel version
    start = clock();
    parallel_matrix_mult(size, a, b, c);
    end = clock();
    double parallel_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Sequential time: %.4f seconds\n", sequential_time);
    printf("Parallel time: %.4f seconds\n", parallel_time);
    printf("Speedup: %.2fx\n", sequential_time / parallel_time);
    
    // Show number of threads
    printf("Number of OpenMP threads: %d\n", omp_get_max_threads());
    
    free(a);
    free(b);
    free(c);
}
```

### Thread-Level Parallelism with Pthreads

Manual thread management for fine-grained control:

```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <time.h>

#define NUM_THREADS 4
#define ARRAY_SIZE 1000000

typedef struct {
    int *array;
    int start;
    int end;
    long long sum;
} thread_data_t;

// Thread function to compute partial sum
void* compute_partial_sum(void *arg) {
    thread_data_t *data = (thread_data_t*)arg;
    
    data->sum = 0;
    for (int i = data->start; i < data->end; i++) {
        data->sum += data->array[i];
    }
    
    return NULL;
}

long long parallel_sum_pthreads(int *array, int n) {
    pthread_t threads[NUM_THREADS];
    thread_data_t thread_data[NUM_THREADS];
    
    // Divide work among threads
    int chunk_size = n / NUM_THREADS;
    
    for (int i = 0; i < NUM_THREADS; i++) {
        thread_data[i].array = array;
        thread_data[i].start = i * chunk_size;
        thread_data[i].end = (i == NUM_THREADS - 1) ? n : (i + 1) * chunk_size;
        
        pthread_create(&threads[i], NULL, compute_partial_sum, &thread_data[i]);
    }
    
    // Wait for all threads and accumulate results
    long long total_sum = 0;
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(threads[i], NULL);
        total_sum += thread_data[i].sum;
    }
    
    return total_sum;
}

long long sequential_sum(int *array, int n) {
    long long sum = 0;
    for (int i = 0; i < n; i++) {
        sum += array[i];
    }
    return sum;
}

void pthreads_example(void) {
    int *array = malloc(ARRAY_SIZE * sizeof(int));
    
    // Initialize array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i % 1000;
    }
    
    // Sequential sum
    clock_t start = clock();
    long long seq_sum = sequential_sum(array, ARRAY_SIZE);
    clock_t end = clock();
    double sequential_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Parallel sum
    start = clock();
    long long par_sum = parallel_sum_pthreads(array, ARRAY_SIZE);
    end = clock();
    double parallel_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Sequential sum: %lld (time: %.4f seconds)\n", seq_sum, sequential_time);
    printf("Parallel sum: %lld (time: %.4f seconds)\n", par_sum, parallel_time);
    printf("Speedup: %.2fx\n", sequential_time / parallel_time);
    
    free(array);
}
```

## Architecture-Specific Optimizations

Different CPU architectures have unique features that can be leveraged for performance.

### Cache Optimization Techniques

Optimizing for cache hierarchy and behavior:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_SIZE 1024

// Cache-unfriendly matrix transpose
void transpose_unfriendly(int n, int *src, int *dst) {
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            dst[j * n + i] = src[i * n + j];
        }
    }
}

// Cache-friendly matrix transpose with blocking
void transpose_blocked(int n, int *src, int *dst) {
    const int block_size = 32;  // Should match cache line size
    
    for (int ii = 0; ii < n; ii += block_size) {
        for (int jj = 0; jj < n; jj += block_size) {
            for (int i = ii; i < ii + block_size && i < n; i++) {
                for (int j = jj; j < jj + block_size && j < n; j++) {
                    dst[j * n + i] = src[i * n + j];
                }
            }
        }
    }
}

void cache_optimization_example(void) {
    int *matrix = malloc(MATRIX_SIZE * MATRIX_SIZE * sizeof(int));
    int *transposed = malloc(MATRIX_SIZE * MATRIX_SIZE * sizeof(int));
    
    // Initialize matrix
    for (int i = 0; i < MATRIX_SIZE * MATRIX_SIZE; i++) {
        matrix[i] = i;
    }
    
    clock_t start, end;
    
    // Unfriendly transpose
    start = clock();
    transpose_unfriendly(MATRIX_SIZE, matrix, transposed);
    end = clock();
    double unfriendly_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Blocked transpose
    start = clock();
    transpose_blocked(MATRIX_SIZE, matrix, transposed);
    end = clock();
    double blocked_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Unfriendly transpose: %.4f seconds\n", unfriendly_time);
    printf("Blocked transpose: %.4f seconds\n", blocked_time);
    printf("Improvement: %.2fx\n", unfriendly_time / blocked_time);
    
    free(matrix);
    free(transposed);
}
```

### Branch Prediction Optimization

Improving branch prediction accuracy for better performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000000

// Function with unpredictable branches
void unpredictable_branches(int *array, int n) {
    for (int i = 0; i < n; i++) {
        // Random condition leads to poor branch prediction
        if (rand() % 2) {
            array[i] *= 2;
        } else {
            array[i] += 1;
        }
    }
}

// Function with predictable branches
void predictable_branches(int *array, int n) {
    // Process even indices differently from odd indices
    for (int i = 0; i < n; i++) {
        if (i % 2 == 0) {
            array[i] *= 2;
        } else {
            array[i] += 1;
        }
    }
}

// Branchless version using conditional moves
void branchless_version(int *array, int n) {
    for (int i = 0; i < n; i++) {
        int is_even = (i % 2 == 0);
        array[i] = array[i] * (1 + is_even) + (1 - is_even);
    }
}

void branch_prediction_example(void) {
    int *array1 = malloc(ARRAY_SIZE * sizeof(int));
    int *array2 = malloc(ARRAY_SIZE * sizeof(int));
    int *array3 = malloc(ARRAY_SIZE * sizeof(int));
    
    // Initialize arrays
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array1[i] = array2[i] = array3[i] = i;
    }
    
    clock_t start, end;
    
    // Unpredictable branches
    srand(42);
    start = clock();
    unpredictable_branches(array1, ARRAY_SIZE);
    end = clock();
    double unpredictable_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Predictable branches
    start = clock();
    predictable_branches(array2, ARRAY_SIZE);
    end = clock();
    double predictable_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    // Branchless version
    start = clock();
    branchless_version(array3, ARRAY_SIZE);
    end = clock();
    double branchless_time = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Unpredictable branches: %.4f seconds\n", unpredictable_time);
    printf("Predictable branches: %.4f seconds\n", predictable_time);
    printf("Branchless version: %.4f seconds\n", branchless_time);
    printf("Predictable improvement: %.2fx\n", unpredictable_time / predictable_time);
    printf("Branchless improvement: %.2fx\n", unpredictable_time / branchless_time);
    
    free(array1);
    free(array2);
    free(array3);
}
```

## Memory-Level Parallelism

Exploiting memory-level parallelism to hide latency:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ARRAY_SIZE 1000000

// Function that can benefit from memory-level parallelism
void memory_parallelism_example(void) {
    double *a = malloc(ARRAY_SIZE * sizeof(double));
    double *b = malloc(ARRAY_SIZE * sizeof(double));
    double *c = malloc(ARRAY_SIZE * sizeof(double));
    double *d = malloc(ARRAY_SIZE * sizeof(double));
    
    // Initialize arrays
    for (int i = 0; i < ARRAY_SIZE; i++) {
        a[i] = (double)i;
        b[i] = (double)(i * 2);
        c[i] = (double)(i * 3);
        d[i] = 0.0;
    }
    
    clock_t start = clock();
    
    // Independent operations that can be executed in parallel
    // Modern processors can execute multiple loads/stores simultaneously
    for (int i = 0; i < ARRAY_SIZE; i++) {
        d[i] = a[i] + b[i] + c[i];
    }
    
    clock_t end = clock();
    double time_spent = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("Memory parallelism example time: %.4f seconds\n", time_spent);
    printf("First few results: ");
    for (int i = 0; i < 5; i++) {
        printf("%.0f ", d[i]);
    }
    printf("\n");
    
    free(a);
    free(b);
    free(c);
    free(d);
}
```

## Advanced Profiling and Analysis

Using sophisticated tools for performance analysis:

```c
#include <stdio.h>
#include <stdlib.h>

#ifdef __linux__
#include <sys/resource.h>
#endif

// Function to measure memory usage
void print_memory_usage(void) {
#ifdef __linux__
    struct rusage usage;
    if (getrusage(RUSAGE_SELF, &usage) == 0) {
        printf("Maximum resident set size: %ld KB\n", usage.ru_maxrss);
        printf("Page reclaims: %ld\n", usage.ru_minflt);
        printf("Page faults: %ld\n", usage.ru_majflt);
    }
#endif
}

// Function to demonstrate performance counters (conceptual)
void performance_counter_example(void) {
    printf("Performance counter example:\n");
    printf("- Instructions per cycle (IPC)\n");
    printf("- Cache miss rates\n");
    printf("- Branch misprediction rate\n");
    printf("- Memory bandwidth utilization\n");
    
    // In practice, you would use tools like:
    // - perf (Linux)
    // - Intel VTune
    // - Apple Instruments
    // - GNU gprof
}
```

## Optimization Decision Making

Making informed decisions about which optimizations to apply:

```c
#include <stdio.h>
#include <time.h>

// Example showing when optimization matters
void optimization_decision_example(void) {
    printf("When to optimize:\n");
    printf("1. Profile first - identify actual bottlenecks\n");
    printf("2. Consider algorithmic improvements before micro-optimizations\n");
    printf("3. Optimize hot paths - functions called frequently\n");
    printf("4. Balance performance with maintainability\n");
    printf("5. Consider target platform and constraints\n");
    printf("6. Measure impact of each optimization\n");
    
    // Simple example of measuring optimization impact
    const int iterations = 100000000;
    
    clock_t start = clock();
    volatile long long sum = 0;
    for (int i = 0; i < iterations; i++) {
        sum += i;
    }
    clock_t end = clock();
    
    double time_spent = ((double)(end - start)) / CLOCKS_PER_SEC;
    printf("\nSimple loop time: %.4f seconds\n", time_spent);
}
```

## Practical Optimization Workflow

A systematic approach to performance optimization:

```c
#include <stdio.h>

void optimization_workflow(void) {
    printf("Performance Optimization Workflow:\n\n");
    
    printf("1. Profiling and Measurement\n");
    printf("   - Use profiling tools to identify bottlenecks\n");
    printf("   - Measure baseline performance\n");
    printf("   - Set performance goals\n\n");
    
    printf("2. Algorithmic Analysis\n");
    printf("   - Review algorithmic complexity\n");
    printf("   - Consider alternative algorithms\n");
    printf("   - Optimize data structures\n\n");
    
    printf("3. Implementation Optimization\n");
    printf("   - Apply compiler optimizations\n");
    printf("   - Use appropriate data layouts\n");
    printf("   - Minimize memory allocations\n\n");
    
    printf("4. Hardware-Specific Tuning\n");
    printf("   - Leverage SIMD instructions\n");
    printf("   - Utilize multiple cores\n");
    printf("   - Optimize for cache hierarchy\n\n");
    
    printf("5. Validation and Testing\n");
    printf("   - Verify correctness after optimization\n");
    printf("   - Measure performance improvements\n");
    printf("   - Test on target hardware\n\n");
    
    printf("6. Documentation and Maintenance\n");
    printf("   - Document optimization decisions\n");
    printf("   - Monitor performance over time\n");
    printf("   - Maintain balance between performance and readability\n");
}
```

## Summary

Advanced optimization techniques require a deep understanding of both the problem domain and the underlying hardware. Key takeaways include:

1. **Compiler Optimization** - Leverage compiler flags and hints for automatic improvements
2. **Vectorization** - Use SIMD instructions to process multiple data elements simultaneously
3. **Parallel Processing** - Distribute work across multiple CPU cores using OpenMP or pthreads
4. **Architecture-Specific Optimizations** - Tailor code for specific CPU features and cache behaviors
5. **Memory-Level Parallelism** - Exploit the ability to perform multiple memory operations simultaneously
6. **Branch Prediction** - Structure code to improve CPU branch prediction accuracy
7. **Systematic Approach** - Follow a methodical workflow for identifying and addressing performance bottlenecks

Important principles to remember:

- **Profile First** - Always measure before and after optimization
- **Algorithmic Improvements** - Often provide bigger gains than micro-optimizations
- **Platform Awareness** - Consider target hardware characteristics
- **Maintainability** - Balance performance with code readability and maintainability
- **Verification** - Ensure optimizations don't introduce bugs or change behavior

These advanced techniques, when applied appropriately, can yield substantial performance improvements in performance-critical C applications. However, they should be used judiciously and only after identifying actual bottlenecks through profiling.