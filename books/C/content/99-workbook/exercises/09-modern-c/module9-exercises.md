# Module 9: Modern C Features Exercises

## Exercise 1: C99 Features Implementation
Write a program that demonstrates key C99 features:
- Use mixed declarations and code within blocks
- Implement designated initializers for structures
- Create functions using inline keyword for performance
- Use compound literals for temporary objects
- Demonstrate variable-length arrays (VLAs)

**Requirements:**
- Use proper C99 compilation flags
- Include examples of improved flexibility with mixed declarations
- Demonstrate the benefits of designated initializers
- Show performance comparisons with inline functions
- Handle VLA size checking to prevent stack overflow

## Exercise 2: C11 Standard Features
Create a program that utilizes C11 features:
- Implement static assertions for compile-time checks
- Use generic selections for type-generic programming
- Create programs with anonymous structures and unions
- Demonstrate alignment specifications
- Use thread-local storage for multi-threading

**Requirements:**
- Use appropriate C11 compilation flags
- Include comprehensive static assertion examples
- Implement generic functions using _Generic
- Show practical uses of anonymous structures
- Document thread-local storage behavior

## Exercise 3: C17/C23 New Features
Develop a program that explores recent C standard features:
- Use UTF-8 string literals for international text
- Implement binary literals and digit separators
- Create programs with enhanced enumeration features
- Use nullptr constant (C23) for safer pointer handling
- Demonstrate standard attributes like [[deprecated]]

**Requirements:**
- Use appropriate C17/C23 compilation flags
- Include examples of UTF-8 handling
- Show benefits of binary literals and digit separators
- Implement proper nullptr usage patterns
- Document attribute-based code annotations

## Exercise 4: Type Safety and Modern Practices
Write a program that emphasizes modern C safety practices:
- Use stdbool.h for boolean types
- Implement fixed-width integer types from stdint.h
- Create safe string handling functions
- Use restrict keyword for optimization hints
- Demonstrate proper const correctness

**Requirements:**
- Include comprehensive examples of type-safe programming
- Show performance benefits of restrict keyword
- Implement bounds-checked string functions
- Document const correctness principles
- Provide examples of portable integer types

## Exercise 5: Advanced Preprocessor Techniques
Create a program that demonstrates modern preprocessor capabilities:
- Implement complex macro functions with error checking
- Use variadic macros for flexible logging
- Create X-macros for data-driven code generation
- Demonstrate conditional compilation with modern features
- Implement include guards and pragma once

**Requirements:**
- Include proper macro hygiene practices
- Show benefits of variadic macros
- Document X-macro patterns and use cases
- Implement cross-platform conditional compilation
- Provide examples of modern header organization

## Exercise 6: Memory Management and Allocation
Write a program that implements modern memory management:
- Use aligned_alloc for specific alignment requirements
- Implement custom allocators with modern features
- Create memory debugging tools with modern C
- Demonstrate safe memory handling practices
- Include performance profiling for allocation strategies

**Requirements:**
- Include proper error checking for allocation functions
- Show benefits of aligned memory access
- Implement comprehensive memory tracking
- Document safe memory handling patterns
- Provide performance comparison data

## Exercise 7: Error Handling and Diagnostics
Create a program that demonstrates modern error handling:
- Implement detailed error reporting with errno.h
- Use static assertions for design-by-contract
- Create comprehensive logging systems
- Demonstrate proper resource cleanup with modern techniques
- Include debugging aids and diagnostic tools

**Requirements:**
- Include comprehensive error classification
- Show benefits of static assertions for validation
- Implement structured logging with timestamps
- Document proper cleanup patterns
- Provide debugging support functions

## Exercise 8: Comprehensive Modern C Application
Design a complete application that integrates all modern C features:
- Implement a data processing pipeline with modern C
- Create a configuration system using modern features
- Develop a plugin architecture with dynamic loading
- Include comprehensive testing and validation
- Provide detailed documentation and examples

**Requirements:**
- Use modular design with clear separation of concerns
- Include proper documentation for all components
- Handle all resource management properly
- Implement robust error handling throughout
- Provide clear examples and test cases

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Structure with designated initializers
typedef struct {
    int id;
    char name[32];
    double value;
    bool active;
} Item;

// Inline function for performance
inline int max_int(int a, int b) {
    return (a > b) ? a : b;
}

int main() {
    // Mixed declarations and code (C99)
    for (int i = 0; i < 5; i++) {
        int square = i * i;  // Declaration inside block
        printf("Square of %d is %d\n", i, square);
    }
    
    // Designated initializers (C99)
    Item item = {
        .id = 100,
        .name = "Sample Item",
        .value = 99.99,
        .active = true
    };
    
    printf("Item: ID=%d, Name=%s, Value=%.2f, Active=%s\n",
           item.id, item.name, item.value, 
           item.active ? "true" : "false");
    
    // Compound literals (C99)
    int *arr = (int[]){1, 2, 3, 4, 5};
    printf("Array from compound literal: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Variable-length array (C99)
    int size;
    printf("Enter array size: ");
    scanf("%d", &size);
    
    if (size > 0 && size <= 1000) {
        int vla[size];  // VLA declaration
        for (int i = 0; i < size; i++) {
            vla[i] = i * i;
        }
        
        printf("VLA contents: ");
        for (int i = 0; i < size && i < 10; i++) {  // Limit output
            printf("%d ", vla[i]);
        }
        printf("\n");
    }
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdalign.h>
#include <assert.h>

// Static assertion example (C11)
_Static_assert(sizeof(int) >= 4, "int must be at least 4 bytes");

// Generic selection example (C11)
#define MAX_GENERIC(x, y) _Generic((x), \
    int: max_int, \
    float: fmaxf, \
    double: fmax \
)(x, y)

inline int max_int(int a, int b) {
    return (a > b) ? a : b;
}

// Anonymous union example (C11)
typedef struct {
    enum { INT_TYPE, FLOAT_TYPE, STRING_TYPE } type;
    union {
        int int_value;
        float float_value;
        char string_value[32];
    };  // Anonymous union
} Variant;

int main() {
    // Generic selection usage
    int a = 10, b = 20;
    float x = 1.5f, y = 2.5f;
    
    printf("Max of %d and %d: %d\n", a, b, MAX_GENERIC(a, b));
    printf("Max of %.1f and %.1f: %.1f\n", x, y, MAX_GENERIC(x, y));
    
    // Anonymous union usage
    Variant v;
    
    v.type = INT_TYPE;
    v.int_value = 42;
    printf("Integer variant: %d\n", v.int_value);
    
    v.type = STRING_TYPE;
    snprintf(v.string_value, sizeof(v.string_value), "Hello, C11!");
    printf("String variant: %s\n", v.string_value);
    
    // Alignment specification (C11)
    alignas(16) char aligned_buffer[64];
    printf("Aligned buffer address: %p\n", (void*)aligned_buffer);
    printf("Alignment check: %s\n", 
           ((uintptr_t)aligned_buffer % 16 == 0) ? "Aligned" : "Not aligned");
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Compiler compatibility**: Not all compilers support all modern features
2. **Feature detection**: Always check for feature availability before use
3. **Performance assumptions**: Measure actual performance benefits
4. **Portability issues**: Consider cross-platform compatibility
5. **Complexity creep**: Don't over-engineer with modern features

### Best Practices:
1. **Feature detection**: Use preprocessor checks for feature availability
2. **Gradual adoption**: Introduce modern features incrementally
3. **Documentation**: Comment modern feature usage clearly
4. **Testing**: Verify behavior across different compilers
5. **Fallbacks**: Provide alternatives for older compiler versions

Complete these exercises to solidify your understanding of modern C features. Each exercise builds upon the previous ones, gradually increasing in complexity.