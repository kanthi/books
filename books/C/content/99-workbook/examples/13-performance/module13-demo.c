/*
 * Module 13 Demonstration Program
 * This program demonstrates all the key concepts from Module 13:
 * - Performance analysis (profiling, benchmarking, metrics)
 * - Optimization techniques (algorithmic, code-level, compiler)
 * - Memory optimization (allocation strategies, pooling, leaks)
 * - Advanced optimization (parallel processing, vectorization)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <time.h>

// Include our custom header files
#include "performance_utils.h"

// Function prototypes for demonstration functions
void demonstrate_performance_analysis(void);
void demonstrate_optimization_techniques(void);
void demonstrate_memory_optimization(void);
void demonstrate_advanced_optimization(void);

// Test functions for benchmarking
void inefficient_function(void);
void optimized_function(void);
void memory_intensive_function(void);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 13: Performance Optimization Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_performance_analysis();
    demonstrate_optimization_techniques();
    demonstrate_memory_optimization();
    demonstrate_advanced_optimization();
    
    printf("\n========================================\n");
    printf("  Module 13 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate performance analysis
 */
void demonstrate_performance_analysis() {
    print_separator("Performance Analysis");
    
    printf("1. Profiling Tools:\n");
    printf("  GNU gprof: Function-level profiling\n");
    printf("  Valgrind: Memory and cache profiling\n");
    printf("  perf: Linux performance monitoring\n");
    printf("  Intel VTune: Advanced performance analysis\n");
    
    printf("\n2. Benchmarking:\n");
    printf("  Measuring execution time of code segments\n");
    printf("  Comparing different implementations\n");
    printf("  Identifying performance bottlenecks\n");
    
    // Demonstrate benchmarking
    printf("\n  Benchmarking demonstration:\n");
    benchmark_function(inefficient_function, "Inefficient Function", 1000);
    benchmark_function(optimized_function, "Optimized Function", 1000);
    
    printf("3. Performance Metrics:\n");
    printf("  Execution time\n");
    printf("  CPU utilization\n");
    printf("  Memory usage\n");
    printf("  Cache hit/miss rates\n");
    printf("  I/O operations\n");
    
    // Demonstrate performance metrics
    Timer timer;
    timer_start(&timer);
    memory_intensive_function();
    double elapsed = timer_end(&timer);
    size_t memory_used = get_memory_usage();
    print_performance_metrics("Memory Intensive Function", elapsed, memory_used);
}

/*
 * Demonstrate optimization techniques
 */
void demonstrate_optimization_techniques() {
    print_separator("Optimization Techniques");
    
    printf("1. Algorithmic Optimization:\n");
    printf("  Choosing efficient algorithms and data structures\n");
    printf("  Example: Binary search O(log n) vs Linear search O(n)\n");
    printf("  Example: Hash table O(1) vs Array O(n) for lookups\n");
    
    printf("\n2. Code-Level Optimization:\n");
    printf("  Loop optimization:\n");
    printf("    - Loop unrolling\n");
    printf("    - Loop fusion\n");
    printf("    - Loop invariant code motion\n");
    printf("  Function inlining\n");
    printf("  Strength reduction (e.g., multiplication to shift)\n");
    printf("  Avoiding expensive operations\n");
    
    printf("\n  Example of inefficient vs optimized code:\n");
    printf("  Inefficient:\n");
    printf("    for (int i = 0; i < strlen(str); i++) { ... }\n");
    printf("  Optimized:\n");
    printf("    int len = strlen(str);\n");
    printf("    for (int i = 0; i < len; i++) { ... }\n");
    
    printf("\n3. Compiler Optimization:\n");
    printf("  GCC optimization levels:\n");
    printf("    -O0: No optimization (default)\n");
    printf("    -O1: Basic optimizations\n");
    printf("    -O2: More aggressive optimizations\n");
    printf("    -O3: Even more aggressive, including loop unrolling\n");
    printf("    -Os: Optimize for size\n");
    printf("  Profile-guided optimization (PGO)\n");
    printf("  Link-time optimization (LTO)\n");
    
    printf("\n4. Compiler Flags:\n");
    printf("  -march=native: Optimize for current CPU\n");
    printf("  -ffast-math: Relax IEEE compliance for speed\n");
    printf("  -funroll-loops: Unroll loops\n");
    printf("  -flto: Link-time optimization\n");
}

/*
 * Demonstrate memory optimization
 */
void demonstrate_memory_optimization() {
    print_separator("Memory Optimization");
    
    printf("1. Memory Allocation Strategies:\n");
    printf("  Stack vs Heap allocation\n");
    printf("  Pre-allocating large blocks\n");
    printf("  Memory pools\n");
    printf("  Object reuse\n");
    
    printf("\n2. Memory Pool Example:\n");
    typedef struct {
        int id;
        char data[64];
    } Object;
    
    // Simple memory pool
    #define POOL_SIZE 100
    static Object object_pool[POOL_SIZE];
    static int pool_index = 0;
    
    // Function to get object from pool
    Object* get_object_from_pool(void) {
        if (pool_index < POOL_SIZE) {
            Object* obj = &object_pool[pool_index++];
            obj->id = pool_index;
            return obj;
        }
        return NULL; // Pool exhausted
    }
    
    // Function to return object to pool
    void return_object_to_pool(Object* obj) {
        if (obj >= &object_pool[0] && obj < &object_pool[POOL_SIZE]) {
            // Reset object
            memset(obj, 0, sizeof(Object));
            // In a real implementation, we'd manage the free list
            // For simplicity, we just decrement the index
            if (pool_index > 0) {
                pool_index--;
            }
        }
    }
    
    printf("  Memory pool with %d objects\n", POOL_SIZE);
    Object* obj1 = get_object_from_pool();
    Object* obj2 = get_object_from_pool();
    printf("  Allocated objects: %p, %p\n", (void*)obj1, (void*)obj2);
    return_object_to_pool(obj1);
    printf("  Returned one object to pool\n");
    
    printf("\n3. Memory Leak Detection:\n");
    printf("  Using memory profiling tools\n");
    printf("  Custom memory tracking\n");
    
    // Demonstrate memory profiling
    printf("\n  Memory profiling demonstration:\n");
    int* array1 = (int*)MALLOC(1000 * sizeof(int));
    double* array2 = (double*)MALLOC(500 * sizeof(double));
    
    print_memory_profile();
    
    FREE(array1);
    print_memory_profile();
    
    FREE(array2);
    print_memory_profile();
    
    printf("\n4. Cache Optimization:\n");
    printf("  Data locality\n");
    printf("  Cache-friendly data structures\n");
    printf("  Loop optimization for cache\n");
    
    printf("\n  Example of cache-unfriendly vs cache-friendly access:\n");
    printf("  // Cache-unfriendly (column-major access)\n");
    printf("  for (int j = 0; j < cols; j++)\n");
    printf("    for (int i = 0; i < rows; i++)\n");
    printf("      matrix[i][j] = value;\n");
    printf("  \n");
    printf("  // Cache-friendly (row-major access)\n");
    printf("  for (int i = 0; i < rows; i++)\n");
    printf("    for (int j = 0; j < cols; j++)\n");
    printf("      matrix[i][j] = value;\n");
}

/*
 * Demonstrate advanced optimization
 */
void demonstrate_advanced_optimization() {
    print_separator("Advanced Optimization");
    
    printf("1. Parallel Processing:\n");
    printf("  Multi-threading with pthreads\n");
    printf("  OpenMP for shared-memory parallelism\n");
    printf("  SIMD (Single Instruction, Multiple Data)\n");
    
    printf("\n  OpenMP example:\n");
    printf("  #pragma omp parallel for\n");
    printf("  for (int i = 0; i < n; i++) {\n");
    printf("    result[i] = compute(data[i]);\n");
    printf("  }\n");
    
    printf("\n2. Vectorization:\n");
    printf("  Using SIMD instructions (SSE, AVX)\n");
    printf("  Compiler auto-vectorization\n");
    printf("  Vector libraries (Intel MKL, etc.)\n");
    
    printf("\n  Example of vectorizable loop:\n");
    printf("  for (int i = 0; i < n; i++) {\n");
    printf("    c[i] = a[i] + b[i];\n");
    printf("  }\n");
    
    printf("\n3. GPU Acceleration:\n");
    printf("  CUDA for NVIDIA GPUs\n");
    printf("  OpenCL for heterogeneous platforms\n");
    printf("  Compute shaders for graphics APIs\n");
    
    printf("\n4. Profile-Guided Optimization (PGO):\n");
    printf("  1. Compile with profiling instrumentation\n");
    printf("  2. Run representative workload\n");
    printf("  3. Compile again with profile data\n");
    printf("  4. Optimized binary with hot paths optimized\n");
    
    printf("\n5. Advanced Compiler Techniques:\n");
    printf("  Link-time optimization (LTO)\n");
    printf("  Whole-program optimization\n");
    printf("  Inter-procedural analysis\n");
    printf("  Dead code elimination\n");
    
    printf("\n6. Hardware-Specific Optimization:\n");
    printf("  CPU-specific instruction sets\n");
    printf("  Cache hierarchy awareness\n");
    printf("  Branch prediction optimization\n");
    printf("  Memory alignment\n");
}

// Test functions for benchmarking
void inefficient_function(void) {
    // Inefficient implementation with repeated strlen calls
    char str[1000];
    for (int i = 0; i < 100; i++) {
        sprintf(str, "Test string %d", i);
        // Inefficient: strlen called in each iteration
        for (int j = 0; j < strlen(str); j++) {
            str[j] = toupper(str[j]);
        }
    }
}

void optimized_function(void) {
    // Optimized implementation with cached strlen
    char str[1000];
    for (int i = 0; i < 100; i++) {
        sprintf(str, "Test string %d", i);
        // Optimized: strlen called once
        int len = strlen(str);
        for (int j = 0; j < len; j++) {
            str[j] = toupper(str[j]);
        }
    }
}

void memory_intensive_function(void) {
    // Function that allocates and uses memory
    const int size = 10000;
    double* array = (double*)MALLOC(size * sizeof(double));
    
    if (array != NULL) {
        // Initialize array
        for (int i = 0; i < size; i++) {
            array[i] = sin(i * 0.01);
        }
        
        // Perform some computation
        double sum = 0.0;
        for (int i = 0; i < size; i++) {
            sum += array[i] * array[i];
        }
        
        FREE(array);
    }
}