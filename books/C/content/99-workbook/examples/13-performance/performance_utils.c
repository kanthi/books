#include "performance_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifdef _WIN32
    #include <psapi.h>
#else
    #include <sys/resource.h>
#endif

// Simple memory tracking structure
typedef struct MemBlock {
    void* ptr;
    size_t size;
    char file[64];
    int line;
    struct MemBlock* next;
} MemBlock;

static MemBlock* mem_blocks = NULL;
static size_t total_allocated = 0;
static size_t peak_memory = 0;

// Start timer
void timer_start(Timer* timer) {
#ifdef _WIN32
    QueryPerformanceFrequency(&timer->frequency);
    QueryPerformanceCounter(&timer->start);
#else
    gettimeofday(&timer->start, NULL);
#endif
}

// End timer and return elapsed time in milliseconds
double timer_end(Timer* timer) {
#ifdef _WIN32
    QueryPerformanceCounter(&timer->end);
    return (double)(timer->end.QuadPart - timer->start.QuadPart) * 1000.0 / timer->frequency.QuadPart;
#else
    gettimeofday(&timer->end, NULL);
    double elapsed = (timer->end.tv_sec - timer->start.tv_sec) * 1000.0;
    elapsed += (timer->end.tv_usec - timer->start.tv_usec) / 1000.0;
    return elapsed;
#endif
}

// Benchmark a function
void benchmark_function(void (*func)(void), const char* name, int iterations) {
    Timer timer;
    timer_start(&timer);
    
    for (int i = 0; i < iterations; i++) {
        func();
    }
    
    double elapsed = timer_end(&timer);
    double avg_time = elapsed / iterations;
    
    printf("Benchmark: %s\n", name);
    printf("  Iterations: %d\n", iterations);
    printf("  Total time: %.3f ms\n", elapsed);
    printf("  Average time: %.6f ms per call\n", avg_time);
    printf("\n");
}

// Get current memory usage
size_t get_memory_usage(void) {
#ifdef _WIN32
    PROCESS_MEMORY_COUNTERS pmc;
    if (GetProcessMemoryInfo(GetCurrentProcess(), &pmc, sizeof(pmc))) {
        return pmc.WorkingSetSize;
    }
    return 0;
#else
    struct rusage usage;
    if (getrusage(RUSAGE_SELF, &usage) == 0) {
        return usage.ru_maxrss * 1024; // Convert KB to bytes
    }
    return 0;
#endif
}

// Print performance metrics
void print_performance_metrics(const char* operation, double time_ms, size_t memory_used) {
    printf("Performance Metrics for: %s\n", operation);
    printf("  Execution time: %.3f ms\n", time_ms);
    printf("  Memory used: %.2f KB\n", memory_used / 1024.0);
    printf("\n");
}

// Profiled malloc
void* profiled_malloc(size_t size, const char* file, int line) {
    void* ptr = malloc(size);
    if (ptr == NULL) {
        return NULL;
    }
    
    // Track allocation
    MemBlock* block = (MemBlock*)malloc(sizeof(MemBlock));
    if (block == NULL) {
        // If we can't track it, still return the allocated memory
        return ptr;
    }
    
    block->ptr = ptr;
    block->size = size;
    strncpy(block->file, file, sizeof(block->file) - 1);
    block->file[sizeof(block->file) - 1] = '\0';
    block->line = line;
    block->next = mem_blocks;
    mem_blocks = block;
    
    total_allocated += size;
    if (total_allocated > peak_memory) {
        peak_memory = total_allocated;
    }
    
    return ptr;
}

// Profiled free
void profiled_free(void* ptr, const char* file, int line) {
    if (ptr == NULL) return;
    
    // Find and remove tracking block
    MemBlock* current = mem_blocks;
    MemBlock* prev = NULL;
    
    while (current != NULL) {
        if (current->ptr == ptr) {
            total_allocated -= current->size;
            
            if (prev == NULL) {
                mem_blocks = current->next;
            } else {
                prev->next = current->next;
            }
            
            free(current);
            break;
        }
        prev = current;
        current = current->next;
    }
    
    free(ptr);
}

// Print memory profile
void print_memory_profile(void) {
    printf("Memory Profile:\n");
    printf("  Total currently allocated: %.2f KB\n", total_allocated / 1024.0);
    printf("  Peak memory usage: %.2f KB\n", peak_memory / 1024.0);
    
    if (mem_blocks != NULL) {
        printf("  Active allocations:\n");
        MemBlock* current = mem_blocks;
        int count = 0;
        while (current != NULL && count < 10) { // Limit output
            printf("    %s:%d - %zu bytes at %p\n", 
                   current->file, current->line, current->size, current->ptr);
            current = current->next;
            count++;
        }
        if (current != NULL) {
            printf("    ... and %d more allocations\n", count);
        }
    } else {
        printf("  No active allocations\n");
    }
    printf("\n");
}