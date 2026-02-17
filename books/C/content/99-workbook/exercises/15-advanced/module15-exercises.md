# Module 15: Advanced Topics Exercises

## Exercise 1: Metaprogramming with Macros
Write a program that demonstrates advanced macro techniques:
- Implement complex macros with conditional compilation
- Create macros that generate code based on parameters
- Demonstrate proper use of token concatenation and stringification
- Show how to implement compile-time assertions
- Implement a simple domain-specific language using macros

**Requirements:**
- Include examples of advanced preprocessor features
- Demonstrate proper macro hygiene and scoping
- Show how to handle macro expansion edge cases
- Implement useful utility macros for common patterns
- Provide clear documentation of macro behavior

## Exercise 2: Generic Programming Techniques
Create a program that demonstrates generic programming in C:
- Implement type-generic data structures using void pointers
- Show how to use function pointers for polymorphic behavior
- Demonstrate proper type safety in generic code
- Implement a simple container library with generic operations
- Show how to handle memory management in generic code

**Requirements:**
- Include examples of generic containers (lists, trees, etc.)
- Demonstrate proper error handling in generic functions
- Show how to implement type-safe generic interfaces
- Implement proper memory management for generic data
- Provide clear documentation of generic programming techniques

## Exercise 3: Coroutines and Cooperative Multitasking
Develop a program that implements coroutines and cooperative multitasking:
- Create a simple coroutine framework
- Implement yield and resume mechanisms
- Show how to manage coroutine state and context
- Demonstrate proper coroutine scheduling
- Implement a simple cooperative multitasking system

**Requirements:**
- Include examples of coroutine usage patterns
- Demonstrate proper context switching mechanisms
- Show how to handle coroutine lifecycle management
- Implement proper error handling in coroutine systems
- Provide clear documentation of coroutine concepts

## Exercise 4: Reflection and Introspection
Write a program that demonstrates reflection and introspection techniques:
- Implement a simple type system with runtime type information
- Create functions for inspecting data structure layouts
- Show how to implement serialization and deserialization
- Demonstrate proper metadata generation and usage
- Implement a simple object model with reflection capabilities

**Requirements:**
- Include examples of runtime type inspection
- Demonstrate proper serialization techniques
- Show how to implement metadata-driven programming
- Implement proper error handling for reflection operations
- Provide clear documentation of reflection mechanisms

## Exercise 5: Template Metaprogramming Simulation
Create a program that simulates template metaprogramming techniques:
- Implement compile-time computation and type manipulation
- Show how to use preprocessor metaprogramming
- Demonstrate proper use of constexpr-like constructs
- Implement a simple compile-time data structure library
- Show how to optimize code through compile-time evaluation

**Requirements:**
- Include examples of compile-time algorithms
- Demonstrate proper use of preprocessor for metaprogramming
- Show how to implement type traits and compile-time checks
- Implement proper error reporting for metaprogramming errors
- Provide clear documentation of metaprogramming techniques

## Exercise 6: Memory Model and Concurrency
Write a program that demonstrates advanced memory model and concurrency concepts:
- Implement lock-free data structures
- Show how to use atomic operations effectively
- Demonstrate proper memory ordering and synchronization
- Implement a simple memory model simulator
- Show how to handle race conditions and data races

**Requirements:**
- Include examples of atomic operations and memory barriers
- Demonstrate proper use of concurrent data structures
- Show how to implement lock-free algorithms
- Implement proper testing for concurrent code
- Provide clear documentation of memory model concepts

## Exercise 7: Language Interoperability
Create a program that demonstrates language interoperability:
- Implement a C library that can be called from other languages
- Show how to interface with C++ code
- Demonstrate proper use of foreign function interfaces
- Implement a simple binding generator (bonus)
- Show how to handle different calling conventions

**Requirements:**
- Include examples of C API design for language interoperability
- Demonstrate proper handling of data type conversions
- Show how to implement proper error handling across language boundaries
- Implement proper resource management for interop scenarios
- Provide clear documentation of interoperability techniques

## Exercise 8: Comprehensive Advanced Application
Design a complete application that integrates all advanced concepts:
- Implement a sophisticated system using multiple advanced techniques
- Create a domain-specific language or framework
- Demonstrate proper architecture and design patterns
- Include comprehensive testing and validation
- Provide clear documentation and examples

**Requirements:**
- Use modular design with clear separation of concerns
- Include comprehensive error handling and recovery mechanisms
- Demonstrate proper resource management throughout the application
- Implement robust testing and validation procedures
- Provide clear examples and documentation

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Advanced macro techniques

// Stringification macro
#define STRINGIFY(x) #x
#define TOSTRING(x) STRINGIFY(x)

// Token concatenation macros
#define CONCAT(a, b) a##b
#define PASTE(a, b) CONCAT(a, b)

// Conditional compilation based on parameters
#define DEBUG_LEVEL 2

#if DEBUG_LEVEL >= 2
    #define DEBUG_PRINT(fmt, ...) \
        fprintf(stderr, "[DEBUG] %s:%d: " fmt "\n", __FILE__, __LINE__, ##__VA_ARGS__)
#elif DEBUG_LEVEL == 1
    #define DEBUG_PRINT(fmt, ...) \
        fprintf(stderr, "[INFO] " fmt "\n", ##__VA_ARGS__)
#else
    #define DEBUG_PRINT(fmt, ...) do {} while(0)
#endif

// Compile-time assertion
#define STATIC_ASSERT(condition, message) \
    typedef char PASTE(static_assert_, __LINE__)[(condition) ? 1 : -1]

// Macro for generating function declarations
#define DECLARE_FUNCTION(return_type, name, ...) \
    return_type name(__VA_ARGS__);

// Macro for generating function definitions with logging
#define DEFINE_FUNCTION(return_type, name, params, body) \
    return_type name params { \
        DEBUG_PRINT("Entering function %s", TOSTRING(name)); \
        body \
        DEBUG_PRINT("Exiting function %s", TOSTRING(name)); \
    }

// Macro for creating a simple DSL for defining structures
#define BEGIN_STRUCT(name) typedef struct {
#define FIELD(type, name) type name;
#define END_STRUCT(name) } name##_t;

// Example usage of the DSL
BEGIN_STRUCT(person)
    FIELD(char*, name)
    FIELD(int, age)
    FIELD(float, height)
END_STRUCT(person)

// Generic max macro
#define MAX(a, b) ((a) > (b) ? (a) : (b))
#define MAX3(a, b, c) MAX(MAX(a, b), c)

// Type-generic print macro
#define PRINT_VALUE(x) _Generic((x), \
    int: printf("int: %d\n", (x)), \
    float: printf("float: %f\n", (x)), \
    double: printf("double: %f\n", (x)), \
    char*: printf("string: %s\n", (x)), \
    default: printf("unknown type\n"))

// Compile-time assertions
STATIC_ASSERT(sizeof(int) >= 4, "int must be at least 4 bytes");
STATIC_ASSERT(sizeof(void*) == 8 || sizeof(void*) == 4, "Pointer size must be 4 or 8 bytes");

int main() {
    // Test stringification
    printf("File: %s\n", __FILE__);
    printf("Line: %d\n", __LINE__);
    printf("Function: %s\n", TOSTRING(main));
    
    // Test debug printing
    DEBUG_PRINT("This is a debug message with value %d", 42);
    
    // Test generic max
    int max_int = MAX3(10, 20, 15);
    printf("Max of 10, 20, 15: %d\n", max_int);
    
    // Test type-generic print
    int a = 42;
    float b = 3.14f;
    char *c = "Hello";
    PRINT_VALUE(a);
    PRINT_VALUE(b);
    PRINT_VALUE(c);
    
    // Test DSL-generated structure
    person_t person = {"Alice", 30, 5.5f};
    printf("Person: %s, Age: %d, Height: %.1f\n", 
           person.name, person.age, person.height);
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Generic programming techniques

// Generic list node
typedef struct list_node {
    void *data;
    struct list_node *next;
} list_node_t;

// Generic list structure
typedef struct {
    list_node_t *head;
    size_t data_size;
    int (*compare)(const void *a, const void *b);
    void (*print)(const void *data);
} generic_list_t;

// Create a new generic list
generic_list_t* list_create(size_t data_size, 
                           int (*compare)(const void *a, const void *b),
                           void (*print)(const void *data)) {
    generic_list_t *list = malloc(sizeof(generic_list_t));
    if (list) {
        list->head = NULL;
        list->data_size = data_size;
        list->compare = compare;
        list->print = print;
    }
    return list;
}

// Add an element to the list
int list_add(generic_list_t *list, const void *data) {
    list_node_t *node = malloc(sizeof(list_node_t));
    if (!node) return 0;
    
    node->data = malloc(list->data_size);
    if (!node->data) {
        free(node);
        return 0;
    }
    
    memcpy(node->data, data, list->data_size);
    node->next = list->head;
    list->head = node;
    return 1;
}

// Find an element in the list
void* list_find(generic_list_t *list, const void *key) {
    for (list_node_t *node = list->head; node; node = node->next) {
        if (list->compare(node->data, key) == 0) {
            return node->data;
        }
    }
    return NULL;
}

// Print all elements in the list
void list_print(generic_list_t *list) {
    for (list_node_t *node = list->head; node; node = node->next) {
        list->print(node->data);
    }
}

// Free the list
void list_destroy(generic_list_t *list) {
    list_node_t *node = list->head;
    while (node) {
        list_node_t *next = node->next;
        free(node->data);
        free(node);
        node = next;
    }
    free(list);
}

// Comparison functions for different types
int int_compare(const void *a, const void *b) {
    int ia = *(const int*)a;
    int ib = *(const int*)b;
    return (ia > ib) - (ia < ib);
}

int string_compare(const void *a, const void *b) {
    return strcmp(*(const char**)a, *(const char**)b);
}

// Print functions for different types
void int_print(const void *data) {
    printf("%d ", *(const int*)data);
}

void string_print(const void *data) {
    printf("%s ", *(const char**)data);
}

int main() {
    // Test with integers
    printf("Testing integer list:\n");
    generic_list_t *int_list = list_create(sizeof(int), int_compare, int_print);
    
    int values[] = {10, 20, 30, 40, 50};
    for (int i = 0; i < 5; i++) {
        list_add(int_list, &values[i]);
    }
    
    printf("List contents: ");
    list_print(int_list);
    printf("\n");
    
    int search_key = 30;
    int *found = (int*)list_find(int_list, &search_key);
    if (found) {
        printf("Found: %d\n", *found);
    } else {
        printf("Not found: %d\n", search_key);
    }
    
    list_destroy(int_list);
    
    // Test with strings
    printf("\nTesting string list:\n");
    generic_list_t *string_list = list_create(sizeof(char*), string_compare, string_print);
    
    const char *strings[] = {"apple", "banana", "cherry", "date", "elderberry"};
    for (int i = 0; i < 5; i++) {
        list_add(string_list, &strings[i]);
    }
    
    printf("List contents: ");
    list_print(string_list);
    printf("\n");
    
    const char *search_string = "cherry";
    char **found_string = (char**)list_find(string_list, &search_string);
    if (found_string) {
        printf("Found: %s\n", *found_string);
    } else {
        printf("Not found: %s\n", search_string);
    }
    
    list_destroy(string_list);
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Macro complexity**: Avoid overly complex macros that hurt readability
2. **Type safety**: Maintain type safety when using generic programming techniques
3. **Memory management**: Properly handle memory in generic and advanced code
4. **Portability**: Consider platform differences in advanced features
5. **Debugging difficulty**: Advanced techniques can make debugging more challenging

### Best Practices:
1. **Clear documentation**: Document advanced techniques thoroughly
2. **Gradual complexity**: Introduce advanced concepts incrementally
3. **Error handling**: Implement robust error handling for advanced features
4. **Testing**: Include comprehensive tests for advanced functionality
5. **Maintainability**: Balance advanced features with code maintainability

Complete these exercises to solidify your understanding of advanced topics in C. Each exercise builds upon the previous ones, gradually increasing in complexity.