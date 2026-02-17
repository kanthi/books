#ifndef PERFORMANCE_UTILS_H
#define PERFORMANCE_UTILS_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <time.h>

#ifdef _WIN32
    #include <windows.h>
#else
    #include <sys/time.h>
#endif

// High-resolution timer structures
typedef struct {
#ifdef _WIN32
    LARGE_INTEGER frequency;
    LARGE_INTEGER start;
    LARGE_INTEGER end;
#else
    struct timeval start;
    struct timeval end;
#endif
} Timer;

// Function prototypes for performance utilities
void timer_start(Timer* timer);
double timer_end(Timer* timer);
void benchmark_function(void (*func)(void), const char* name, int iterations);
size_t get_memory_usage(void);
void print_performance_metrics(const char* operation, double time_ms, size_t memory_used);

// Memory profiling functions
void* profiled_malloc(size_t size, const char* file, int line);
void profiled_free(void* ptr, const char* file, int line);
void print_memory_profile(void);

// Macro for easier memory profiling
#define MALLOC(size) profiled_malloc(size, __FILE__, __LINE__)
#define FREE(ptr) profiled_free(ptr, __FILE__, __LINE__)

#endif // PERFORMANCE_UTILS_H