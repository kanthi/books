#include "advanced_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Global variables for error handling
jmp_buf error_buf;
bool error_occurred = false;

// Register error handler
void register_error_handler(void) {
    int result = setjmp(error_buf);
    if (result != 0) {
        error_occurred = true;
        printf("Error handler registered and triggered\n");
    }
}

// Throw error using longjmp
void throw_error(const char* message) {
    printf("Error: %s\n", message);
    if (!error_occurred) {
        longjmp(error_buf, 1);
    }
}

// Safe function call with error handling
void safe_function_call(void (*func)(void), const char* func_name) {
    printf("Calling function: %s\n", func_name);
    
    // Set up error handler
    jmp_buf local_buf;
    memcpy(local_buf, error_buf, sizeof(jmp_buf));
    
    int result = setjmp(error_buf);
    if (result == 0) {
        // Call the function
        func();
        printf("Function %s completed successfully\n", func_name);
    } else {
        // Error occurred
        printf("Function %s failed with error\n", func_name);
    }
    
    // Restore error handler
    memcpy(error_buf, local_buf, sizeof(jmp_buf));
}

// Demonstrate function pointers
void demonstrate_function_pointers(void) {
    printf("Function pointer demonstration:\n");
    
    // Simple function pointer
    int (*add_ptr)(int, int) = NULL;
    
    // Array of function pointers
    void (*demonstrations[])(void) = {
        demonstrate_callback_mechanism,
        demonstrate_macros_and_preprocessor,
        demonstrate_bit_manipulation
    };
    
    printf("  Array of function pointers with %zu elements\n", 
           sizeof(demonstrations) / sizeof(demonstrations[0]));
}

// Demonstrate callback mechanism
void demonstrate_callback_mechanism(callback_func callback, void* data) {
    printf("Callback mechanism demonstration:\n");
    if (callback != NULL) {
        printf("  Calling callback function with data: %p\n", data);
        callback(data);
    } else {
        printf("  No callback function provided\n");
    }
}

// Generic comparison function
int generic_compare(const void* a, const void* b, size_t size, compare_func cmp) {
    if (a == NULL || b == NULL) {
        return (a == NULL) ? (b == NULL ? 0 : -1) : 1;
    }
    
    if (cmp != NULL) {
        return cmp(a, b);
    }
    
    // Default comparison (memcmp)
    return memcmp(a, b, size);
}

// Demonstrate macros and preprocessor
void demonstrate_macros_and_preprocessor(void) {
    printf("Macros and preprocessor demonstration:\n");
    
    // Conditional compilation
#ifdef DEBUG
    printf("  DEBUG mode is enabled\n");
#else
    printf("  DEBUG mode is disabled\n");
#endif
    
    // Macro with parameters
#define MAX(a, b) ((a) > (b) ? (a) : (b))
    int x = 10, y = 20;
    printf("  MAX(%d, %d) = %d\n", x, y, MAX(x, y));
    
    // Stringify macro
#define STRINGIFY(x) #x
    printf("  Value of x as string: %s\n", STRINGIFY(x));
    
    // Concatenation macro
#define CONCAT(a, b) a##b
    int xy = 30;
    printf("  Variable name concatenation: %s = %d\n", "xy", xy);
    
    // Static assert
    STATIC_ASSERT(sizeof(int) >= 4, int_must_be_at_least_4_bytes);
    printf("  Static assertion passed: int is at least 4 bytes\n");
}

// Demonstrate bit manipulation
void demonstrate_bit_manipulation(void) {
    printf("Bit manipulation demonstration:\n");
    
    uint32_t value = 0b10101010101010101010101010101010;
    printf("  Original value: 0x%08X\n", value);
    
    // Bit extraction
    uint32_t mask = 0x000000FF; // Extract lowest 8 bits
    uint32_t extracted = value & mask;
    printf("  Extracted bits (mask 0x%08X): 0x%02X\n", mask, extracted);
    
    // Bit setting
    value |= (1 << 5); // Set bit 5
    printf("  After setting bit 5: 0x%08X\n", value);
    
    // Bit clearing
    value &= ~(1 << 7); // Clear bit 7
    printf("  After clearing bit 7: 0x%08X\n", value);
    
    // Bit toggling
    value ^= (1 << 3); // Toggle bit 3
    printf("  After toggling bit 3: 0x%08X\n", value);
    
    // Bit rotation (left)
    uint32_t rotated = (value << 4) | (value >> (32 - 4));
    printf("  Left rotated by 4: 0x%08X\n", rotated);
    
    // Population count (count of 1 bits)
    int count = 0;
    uint32_t temp = value;
    while (temp) {
        count += temp & 1;
        temp >>= 1;
    }
    printf("  Population count: %d\n", count);
}