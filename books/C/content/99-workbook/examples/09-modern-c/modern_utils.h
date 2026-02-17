#ifndef MODERN_UTILS_H
#define MODERN_UTILS_H

// Header for modern C features demonstration
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>

// Function prototypes for modern C utilities
void demonstrate_c99_features(void);
void demonstrate_c11_features(void);
void demonstrate_c17_c23_features(void);
void demonstrate_modern_practices(void);

// Inline function example (C99)
inline int max_int(int a, int b) {
    return (a > b) ? a : b;
}

// Static assert example (C11)
#include <assert.h>
#define STATIC_ASSERT(condition, message) _Static_assert(condition, message)

// Generic macro example (C11)
#define MAX_GENERIC(x, y) _Generic((x), \
    int: max_int, \
    float: fmaxf, \
    double: fmax \
)(x, y)

#endif // MODERN_UTILS_H