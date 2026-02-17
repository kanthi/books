# Performance Analysis

## Introduction

Performance analysis is the process of measuring, evaluating, and understanding the runtime behavior of programs to identify bottlenecks and optimization opportunities. In C programming, where performance is often critical, proper performance analysis is essential for creating efficient applications.

This chapter covers various techniques and tools for analyzing program performance, including profiling, benchmarking, and measurement methodologies.

## Performance Metrics

Understanding the right metrics is crucial for effective performance analysis.

### Time Complexity Metrics

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

// Simple timing function
double get_time(void) {
    struct timespec ts;
    clock_gettime(CLOCK_MONOTONIC, &ts);
    return ts.tv_sec + ts.tv_nsec / 1e9;
}

// Example function to measure
void example_function(int n) {
    volatile int sum = 0;
    for (int i = 0; i < n; i++) {
        for (int j = 0; j < n; j++) {
            sum += i * j;
        }
    }
}

// Measure execution time
void measure_execution_time(void) {
    double start_time, end_time;
    
    start_time = get_time();
    example_function(1000);
    end_time = get_time();
    
    printf("Execution time: %.6f seconds\n", end_time - start_time);
}
```

### Memory Usage Metrics

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Memory tracking structure
typedef struct {
    size_t allocated_bytes;
    size_t freed_bytes;
    size_t current_usage;
    size_t peak_usage;
    size_t allocation_count;
    size_t deallocation_count;
} memory_stats_t;

static memory_stats_t mem_stats = {0};

// Custom malloc wrapper for tracking
void* tracked_malloc(size_t size) {
    void* ptr = malloc(size);
    if (ptr != NULL) {
        mem_stats.allocated_bytes += size;
        mem_stats.current_usage += size;
        mem_stats.allocation_count++;
        
        if (mem_stats.current_usage > mem_stats.peak_usage) {
            mem_stats.peak_usage = mem_stats.current_usage;
        }
    }
    return ptr;
}

// Custom free wrapper for tracking
void tracked_free(void* ptr, size_t size) {
    if (ptr != NULL) {
        free(ptr);
        mem_stats.freed_bytes += size;
        mem_stats.current_usage -= size;
        mem_stats.deallocation_count++;
    }
}

// Print memory statistics
void print_memory_stats(void) {
    printf("Memory Statistics:\n");
    printf("  Allocated: %zu bytes\n", mem_stats.allocated_bytes);
    printf("  Freed: %zu bytes\n", mem_stats.freed_bytes);
    printf("  Current Usage: %zu bytes\n", mem_stats.current_usage);
    printf("  Peak Usage: %zu bytes\n", mem_stats.peak_usage);
    printf("  Allocations: %zu\n", mem_stats.allocation_count);
    printf("  Deallocations: %zu\n", mem_stats.deallocation_count);
}

// Reset memory statistics
void reset_memory_stats(void) {
    memset(&mem_stats, 0, sizeof(mem_stats));
}
```

### CPU Usage Metrics

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/resource.h>

// Get CPU time usage
double get_cpu_time(void) {
    struct rusage usage;
    if (getrusage(RUSAGE_SELF, &usage) == 0) {
        return usage.ru_utime.tv_sec + usage.ru_utime.tv_usec / 1e6 +
               usage.ru_stime.tv_sec + usage.ru_stime.tv_usec / 1e6;
    }
    return -1.0;
}

// Example CPU-intensive function
void cpu_intensive_task(void) {
    volatile double result = 0.0;
    for (int i = 0; i < 1000000; i++) {
        result += i * 3.14159;
    }
}

// Measure CPU time
void measure_cpu_time(void) {
    double start_cpu, end_cpu;
    
    start_cpu = get_cpu_time();
    cpu_intensive_task();
    end_cpu = get_cpu_time();
    
    if (start_cpu >= 0 && end_cpu >= 0) {
        printf("CPU time used: %.6f seconds\n", end_cpu - start_cpu);
    }
}
```

## Profiling Tools

Profiling tools provide detailed insights into program execution and resource usage.

### GNU gprof

GNU gprof is a profiling tool that comes with GCC:

```bash
# Compile with profiling enabled
gcc -pg -o program program.c

# Run the program
./program

# Generate profiling report
gprof program gmon.out > analysis.txt
```

Example program for gprof profiling:

```c
#include <stdio.h>
#include <stdlib.h>

// Function to profile
void function_a(void) {
    volatile int sum = 0;
    for (int i = 0; i < 1000000; i++) {
        sum += i;
    }
}

void function_b(void) {
    volatile int product = 1;
    for (int i = 1; i < 1000; i++) {
        product *= i;
    }
}

void function_c(void) {
    volatile double result = 0.0;
    for (int i = 0; i < 500000; i++) {
        result += i * 1.5;
    }
}

int main(void) {
    printf("Starting performance analysis...\n");
    
    // Call functions multiple times
    for (int i = 0; i < 100; i++) {
        function_a();
        if (i % 2 == 0) {
            function_b();
        }
        if (i % 5 == 0) {
            function_c();
        }
    }
    
    printf("Performance analysis complete.\n");
    return 0;
}
```

### Valgrind Callgrind

Valgrind with Callgrind provides detailed call graph profiling:

```bash
# Compile normally
gcc -g -O2 -o program program.c

# Run with callgrind
valgrind --tool=callgrind ./program

# View results with kcachegrind
kcachegrind callgrind.out.*
```

### perf (Linux Performance Events)

perf is a powerful performance analysis tool on Linux:

```bash
# Record performance data
perf record -g ./program

# View report
perf report

# Generate flame graph
perf script | flamegraph.pl > perf.svg
```

## Custom Profiling Framework

Creating a custom profiling framework for specific needs:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_PROFILERS 100

// Profiler structure
typedef struct {
    char name[64];
    struct timespec start_time;
    long long total_time_ns;
    int call_count;
    int is_active;
} profiler_t;

static profiler_t profilers[MAX_PROFILERS];
static int profiler_count = 0;

// Find or create profiler
static profiler_t* get_profiler(const char* name) {
    // Try to find existing profiler
    for (int i = 0; i < profiler_count; i++) {
        if (strcmp(profilers[i].name, name) == 0) {
            return &profilers[i];
        }
    }
    
    // Create new profiler if space available
    if (profiler_count < MAX_PROFILERS) {
        profiler_t* p = &profilers[profiler_count];
        strncpy(p->name, name, sizeof(p->name) - 1);
        p->name[sizeof(p->name) - 1] = '\0';
        p->total_time_ns = 0;
        p->call_count = 0;
        p->is_active = 0;
        profiler_count++;
        return p;
    }
    
    return NULL;
}

// Start profiling a section
void profile_start(const char* name) {
    profiler_t* p = get_profiler(name);
    if (p != NULL && !p->is_active) {
        clock_gettime(CLOCK_MONOTONIC, &p->start_time);
        p->is_active = 1;
    }
}

// Stop profiling a section
void profile_stop(const char* name) {
    profiler_t* p = get_profiler(name);
    if (p != NULL && p->is_active) {
        struct timespec end_time;
        clock_gettime(CLOCK_MONOTONIC, &end_time);
        
        long long elapsed_ns = (end_time.tv_sec - p->start_time.tv_sec) * 1000000000LL +
                              (end_time.tv_nsec - p->start_time.tv_nsec);
        
        p->total_time_ns += elapsed_ns;
        p->call_count++;
        p->is_active = 0;
    }
}

// Print profiling results
void profile_print_results(void) {
    printf("\n=== Profiling Results ===\n");
    printf("%-30s %12s %10s %15s\n", "Function", "Calls", "Time(ms)", "Avg Time(μs)");
    printf("%-30s %12s %10s %15s\n", "--------", "-----", "-------", "------------");
    
    for (int i = 0; i < profiler_count; i++) {
        profiler_t* p = &profilers[i];
        double total_time_ms = p->total_time_ns / 1e6;
        double avg_time_us = (p->call_count > 0) ? 
                            (p->total_time_ns / 1e3) / p->call_count : 0;
        
        printf("%-30s %12d %10.3f %15.3f\n", 
               p->name, p->call_count, total_time_ms, avg_time_us);
    }
}

// Reset profiling data
void profile_reset(void) {
    profiler_count = 0;
    memset(profilers, 0, sizeof(profilers));
}

// Example usage
void example_function_1(void) {
    profile_start("example_function_1");
    
    // Simulate work
    volatile int sum = 0;
    for (int i = 0; i < 100000; i++) {
        sum += i;
    }
    
    profile_stop("example_function_1");
}

void example_function_2(void) {
    profile_start("example_function_2");
    
    // Simulate work
    volatile double product = 1.0;
    for (int i = 1; i < 1000; i++) {
        product *= i * 0.1;
    }
    
    profile_stop("example_function_2");
}

int main(void) {
    printf("Starting custom profiling example...\n");
    
    // Profile different functions
    for (int i = 0; i < 1000; i++) {
        example_function_1();
        if (i % 2 == 0) {
            example_function_2();
        }
    }
    
    // Print results
    profile_print_results();
    
    return 0;
}
```

## Benchmarking Framework

Creating a systematic benchmarking framework:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

// Benchmark result structure
typedef struct {
    double min_time;
    double max_time;
    double avg_time;
    double median_time;
    double stddev;
    int iterations;
} benchmark_result_t;

// Benchmark function type
typedef void (*benchmark_func_t)(void);

// Run benchmark
benchmark_result_t run_benchmark(benchmark_func_t func, int iterations) {
    benchmark_result_t result = {0};
    double* times = malloc(iterations * sizeof(double));
    
    if (times == NULL) {
        result.iterations = -1;
        return result;
    }
    
    struct timespec start, end;
    
    // Warm up
    for (int i = 0; i < 10; i++) {
        func();
    }
    
    // Run benchmark iterations
    for (int i = 0; i < iterations; i++) {
        clock_gettime(CLOCK_MONOTONIC, &start);
        func();
        clock_gettime(CLOCK_MONOTONIC, &end);
        
        times[i] = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    }
    
    // Calculate statistics
    result.iterations = iterations;
    result.min_time = times[0];
    result.max_time = times[0];
    double sum = 0.0;
    
    for (int i = 0; i < iterations; i++) {
        if (times[i] < result.min_time) result.min_time = times[i];
        if (times[i] > result.max_time) result.max_time = times[i];
        sum += times[i];
    }
    
    result.avg_time = sum / iterations;
    
    // Calculate median
    // Sort times array (simplified bubble sort for small arrays)
    for (int i = 0; i < iterations - 1; i++) {
        for (int j = 0; j < iterations - i - 1; j++) {
            if (times[j] > times[j + 1]) {
                double temp = times[j];
                times[j] = times[j + 1];
                times[j + 1] = temp;
            }
        }
    }
    
    if (iterations % 2 == 0) {
        result.median_time = (times[iterations/2 - 1] + times[iterations/2]) / 2.0;
    } else {
        result.median_time = times[iterations/2];
    }
    
    // Calculate standard deviation
    double sum_sq_diff = 0.0;
    for (int i = 0; i < iterations; i++) {
        double diff = times[i] - result.avg_time;
        sum_sq_diff += diff * diff;
    }
    result.stddev = sqrt(sum_sq_diff / iterations);
    
    free(times);
    return result;
}

// Print benchmark results
void print_benchmark_result(const char* name, const benchmark_result_t* result) {
    if (result->iterations < 0) {
        printf("Benchmark '%s' failed\n", name);
        return;
    }
    
    printf("Benchmark: %s\n", name);
    printf("  Iterations: %d\n", result->iterations);
    printf("  Min Time: %.6f ms\n", result->min_time * 1000);
    printf("  Max Time: %.6f ms\n", result->max_time * 1000);
    printf("  Avg Time: %.6f ms\n", result->avg_time * 1000);
    printf("  Median Time: %.6f ms\n", result->median_time * 1000);
    printf("  Std Dev: %.6f ms\n", result->stddev * 1000);
    printf("\n");
}

// Example functions to benchmark
void benchmark_function_1(void) {
    volatile int sum = 0;
    for (int i = 0; i < 10000; i++) {
        sum += i;
    }
}

void benchmark_function_2(void) {
    volatile double product = 1.0;
    for (int i = 1; i < 1000; i++) {
        product *= (i * 0.01);
    }
}

int main(void) {
    printf("Starting benchmark tests...\n\n");
    
    // Run benchmarks
    benchmark_result_t result1 = run_benchmark(benchmark_function_1, 1000);
    print_benchmark_result("Sum Calculation", &result1);
    
    benchmark_result_t result2 = run_benchmark(benchmark_function_2, 1000);
    print_benchmark_result("Product Calculation", &result2);
    
    return 0;
}
```

## Cache Performance Analysis

Understanding cache behavior is crucial for performance optimization:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define CACHE_LINE_SIZE 64
#define ARRAY_SIZE 1000000

// Test cache-friendly access pattern
void cache_friendly_access(int* array, int size) {
    for (int i = 0; i < size; i++) {
        array[i] += 1;
    }
}

// Test cache-unfriendly access pattern
void cache_unfriendly_access(int* array, int size) {
    for (int stride = 1; stride < size; stride *= 2) {
        for (int i = 0; i < size; i += stride) {
            array[i] += 1;
        }
    }
}

// Measure cache performance
void measure_cache_performance(void) {
    int* array = malloc(ARRAY_SIZE * sizeof(int));
    if (array == NULL) {
        printf("Failed to allocate memory\n");
        return;
    }
    
    struct timespec start, end;
    
    // Initialize array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i;
    }
    
    // Measure cache-friendly access
    clock_gettime(CLOCK_MONOTONIC, &start);
    cache_friendly_access(array, ARRAY_SIZE);
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double friendly_time = (end.tv_sec - start.tv_sec) + 
                          (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Reset array
    for (int i = 0; i < ARRAY_SIZE; i++) {
        array[i] = i;
    }
    
    // Measure cache-unfriendly access
    clock_gettime(CLOCK_MONOTONIC, &start);
    cache_unfriendly_access(array, ARRAY_SIZE);
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double unfriendly_time = (end.tv_sec - start.tv_sec) + 
                            (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Cache Performance Analysis:\n");
    printf("  Cache-friendly access time: %.6f seconds\n", friendly_time);
    printf("  Cache-unfriendly access time: %.6f seconds\n", unfriendly_time);
    printf("  Performance ratio: %.2f\n", unfriendly_time / friendly_time);
    
    free(array);
}
```

## Memory Access Pattern Analysis

Analyzing memory access patterns for optimization:

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define MATRIX_SIZE 1000

// Row-major access (cache-friendly)
void row_major_access(int matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            matrix[i][j] += 1;
        }
    }
}

// Column-major access (cache-unfriendly)
void column_major_access(int matrix[MATRIX_SIZE][MATRIX_SIZE]) {
    for (int j = 0; j < MATRIX_SIZE; j++) {
        for (int i = 0; i < MATRIX_SIZE; i++) {
            matrix[i][j] += 1;
        }
    }
}

// Measure memory access patterns
void measure_memory_access_patterns(void) {
    int(*matrix)[MATRIX_SIZE] = malloc(MATRIX_SIZE * sizeof(*matrix));
    if (matrix == NULL) {
        printf("Failed to allocate memory\n");
        return;
    }
    
    struct timespec start, end;
    
    // Initialize matrix
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            matrix[i][j] = i * MATRIX_SIZE + j;
        }
    }
    
    // Measure row-major access
    clock_gettime(CLOCK_MONOTONIC, &start);
    row_major_access(matrix);
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double row_time = (end.tv_sec - start.tv_sec) + 
                     (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Reset matrix
    for (int i = 0; i < MATRIX_SIZE; i++) {
        for (int j = 0; j < MATRIX_SIZE; j++) {
            matrix[i][j] = i * MATRIX_SIZE + j;
        }
    }
    
    // Measure column-major access
    clock_gettime(CLOCK_MONOTONIC, &start);
    column_major_access(matrix);
    clock_gettime(CLOCK_MONOTONIC, &end);
    
    double col_time = (end.tv_sec - start.tv_sec) + 
                     (end.tv_nsec - start.tv_nsec) / 1e9;
    
    printf("Memory Access Pattern Analysis:\n");
    printf("  Row-major access time: %.6f seconds\n", row_time);
    printf("  Column-major access time: %.6f seconds\n", col_time);
    printf("  Performance ratio: %.2f\n", col_time / row_time);
    
    free(matrix);
}
```

## Practical Examples

### Comprehensive Performance Analysis Tool

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Performance analysis tool
typedef struct {
    char name[64];
    double execution_time;
    size_t memory_usage;
    int cpu_cycles;
} performance_data_t;

// Simple hash table implementation for performance data
#define HASH_TABLE_SIZE 101

typedef struct perf_node {
    performance_data_t data;
    struct perf_node* next;
} perf_node_t;

static perf_node_t* hash_table[HASH_TABLE_SIZE];

// Hash function
static unsigned int hash(const char* str) {
    unsigned int hash = 5381;
    int c;
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;
    }
    return hash % HASH_TABLE_SIZE;
}

// Add performance data
void add_performance_data(const char* name, double execution_time, 
                         size_t memory_usage, int cpu_cycles) {
    unsigned int index = hash(name);
    
    perf_node_t* node = malloc(sizeof(perf_node_t));
    if (node == NULL) return;
    
    strncpy(node->data.name, name, sizeof(node->data.name) - 1);
    node->data.name[sizeof(node->data.name) - 1] = '\0';
    node->data.execution_time = execution_time;
    node->data.memory_usage = memory_usage;
    node->data.cpu_cycles = cpu_cycles;
    node->next = hash_table[index];
    hash_table[index] = node;
}

// Find performance data
performance_data_t* find_performance_data(const char* name) {
    unsigned int index = hash(name);
    perf_node_t* node = hash_table[index];
    
    while (node != NULL) {
        if (strcmp(node->data.name, name) == 0) {
            return &node->data;
        }
        node = node->next;
    }
    
    return NULL;
}

// Print all performance data
void print_all_performance_data(void) {
    printf("\n=== Performance Analysis Report ===\n");
    printf("%-30s %12s %15s %12s\n", "Function", "Time (ms)", "Memory (bytes)", "CPU Cycles");
    printf("%-30s %12s %15s %12s\n", "--------", "--------", "-------------", "----------");
    
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        perf_node_t* node = hash_table[i];
        while (node != NULL) {
            printf("%-30s %12.3f %15zu %12d\n",
                   node->data.name,
                   node->data.execution_time * 1000,
                   node->data.memory_usage,
                   node->data.cpu_cycles);
            node = node->next;
        }
    }
}

// Clear performance data
void clear_performance_data(void) {
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        perf_node_t* node = hash_table[i];
        while (node != NULL) {
            perf_node_t* next = node->next;
            free(node);
            node = next;
        }
        hash_table[i] = NULL;
    }
}

// Example performance test functions
void test_function_1(void) {
    volatile int sum = 0;
    for (int i = 0; i < 100000; i++) {
        sum += i;
    }
}

void test_function_2(void) {
    volatile double product = 1.0;
    for (int i = 1; i < 1000; i++) {
        product *= i * 0.1;
    }
}

void test_function_3(void) {
    char* buffer = malloc(1024);
    if (buffer != NULL) {
        memset(buffer, 0, 1024);
        free(buffer);
    }
}

int main(void) {
    struct timespec start, end;
    
    printf("Running comprehensive performance analysis...\n");
    
    // Test function 1
    clock_gettime(CLOCK_MONOTONIC, &start);
    test_function_1();
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time1 = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    add_performance_data("test_function_1", time1, 0, 0);
    
    // Test function 2
    clock_gettime(CLOCK_MONOTONIC, &start);
    test_function_2();
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time2 = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    add_performance_data("test_function_2", time2, 0, 0);
    
    // Test function 3
    clock_gettime(CLOCK_MONOTONIC, &start);
    test_function_3();
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time3 = (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
    add_performance_data("test_function_3", time3, 1024, 0);
    
    // Print results
    print_all_performance_data();
    
    // Clean up
    clear_performance_data();
    
    return 0;
}
```

## Summary

Performance analysis is a critical skill for C programmers, involving:

1. **Metrics Collection** - Time, memory, and CPU usage measurements
2. **Profiling Tools** - gprof, Valgrind, perf, and custom profilers
3. **Benchmarking** - Systematic performance testing with statistical analysis
4. **Cache Analysis** - Understanding memory access patterns and cache behavior
5. **Memory Analysis** - Tracking allocations and identifying memory bottlenecks

Key principles for effective performance analysis:
- Use appropriate tools for different types of analysis
- Measure performance in realistic conditions
- Collect sufficient data for statistical significance
- Understand the trade-offs between accuracy and overhead
- Focus on the most critical performance bottlenecks
- Document performance characteristics for future reference
- Continuously monitor performance during development

These techniques enable developers to create high-performance C applications that efficiently utilize system resources while meeting performance requirements.