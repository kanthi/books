#ifndef ADVANCED_UTILS_H
#define ADVANCED_UTILS_H

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>
#include <setjmp.h>

// Macro for container_of pattern (getting parent struct from member)
#define container_of(ptr, type, member) \
    ((type *)((char *)(ptr) - offsetof(type, member)))

// Macro to calculate offset of a member in a struct
#define offsetof(type, member) ((size_t) &((type *)0)->member)

// Variadic macro for debugging
#ifdef DEBUG
#define DBG(fmt, ...) \
    fprintf(stderr, "DEBUG %s:%d: " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#else
#define DBG(fmt, ...)
#endif

// Static assert (C11 style)
#define STATIC_ASSERT(condition, message) \
    typedef char static_assertion_##message[(condition) ? 1 : -1]

// Function pointers for callback mechanisms
typedef void (*callback_func)(void* data);
typedef int (*compare_func)(const void* a, const void* b);

// Error handling with setjmp/longjmp
extern jmp_buf error_buf;
extern bool error_occurred;

// Function prototypes for advanced utilities
void register_error_handler(void);
void throw_error(const char* message);
void safe_function_call(void (*func)(void), const char* func_name);
void demonstrate_function_pointers(void);
void demonstrate_callback_mechanism(callback_func callback, void* data);
int generic_compare(const void* a, const void* b, size_t size, compare_func cmp);
void demonstrate_macros_and_preprocessor(void);
void demonstrate_bit_manipulation(void);

#endif // ADVANCED_UTILS_H