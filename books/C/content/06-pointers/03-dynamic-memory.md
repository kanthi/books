# Dynamic Memory Management

## Introduction

Dynamic memory management is a crucial aspect of C programming that allows programs to allocate and deallocate memory at runtime. Unlike static memory allocation where the size and lifetime of variables are determined at compile time, dynamic memory allocation provides flexibility for handling data structures whose size is unknown until the program runs. This capability is essential for implementing complex data structures like linked lists, trees, and dynamic arrays.

## Memory Layout in C Programs

### Program Memory Sections
A C program's memory is typically organized into several sections:

1. **Text Segment**: Contains executable code
2. **Data Segment**: Contains global and static variables
3. **Stack**: Contains local variables and function call information
4. **Heap**: Contains dynamically allocated memory

### Stack vs. Heap
```c
// Stack allocation - automatic memory management
void stack_example() {
    int local_array[100];  // Allocated on stack
    // Automatically deallocated when function returns
}

// Heap allocation - manual memory management
void heap_example() {
    int *dynamic_array = malloc(100 * sizeof(int));  // Allocated on heap
    // Must be manually deallocated with free()
    free(dynamic_array);
}
```

## Dynamic Memory Allocation Functions

### malloc()
The `malloc()` function allocates a block of memory of specified size:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate memory for 10 integers
    int *arr = malloc(10 * sizeof(int));
    
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Use the allocated memory
    for (int i = 0; i < 10; i++) {
        arr[i] = i * i;
        printf("arr[%d] = %d\n", i, arr[i]);
    }
    
    // Free the allocated memory
    free(arr);
    arr = NULL;  // Prevent dangling pointer
    
    return 0;
}
```

### calloc()
The `calloc()` function allocates memory and initializes it to zero:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate and zero-initialize memory for 10 integers
    int *arr = calloc(10, sizeof(int));
    
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Memory is already zero-initialized
    for (int i = 0; i < 10; i++) {
        printf("arr[%d] = %d\n", i, arr[i]);  // All zeros
    }
    
    // Free the allocated memory
    free(arr);
    arr = NULL;
    
    return 0;
}
```

### realloc()
The `realloc()` function changes the size of previously allocated memory:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Initial allocation
    int *arr = malloc(5 * sizeof(int));
    if (arr == NULL) {
        printf("Initial allocation failed\n");
        return 1;
    }
    
    // Initialize array
    for (int i = 0; i < 5; i++) {
        arr[i] = i + 1;
    }
    
    printf("Original array: ");
    for (int i = 0; i < 5; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Resize array to hold 10 elements
    arr = realloc(arr, 10 * sizeof(int));
    if (arr == NULL) {
        printf("Reallocation failed\n");
        return 1;
    }
    
    // Initialize new elements
    for (int i = 5; i < 10; i++) {
        arr[i] = (i + 1) * 2;
    }
    
    printf("Resized array: ");
    for (int i = 0; i < 10; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Free memory
    free(arr);
    return 0;
}
```

### free()
The `free()` function deallocates previously allocated memory:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate memory
    int *ptr = malloc(100 * sizeof(int));
    if (ptr == NULL) {
        printf("Allocation failed\n");
        return 1;
    }
    
    // Use memory...
    for (int i = 0; i < 100; i++) {
        ptr[i] = i;
    }
    
    // Deallocate memory
    free(ptr);
    ptr = NULL;  // Prevent dangling pointer
    
    return 0;
}
```

## Memory Allocation Strategies

### Single Element Allocation
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    char name[50];
} Person;

int main() {
    // Allocate single structure
    Person *person = malloc(sizeof(Person));
    if (person == NULL) {
        printf("Allocation failed\n");
        return 1;
    }
    
    // Initialize structure
    person->id = 1;
    strcpy(person->name, "John Doe");
    
    printf("ID: %d, Name: %s\n", person->id, person->name);
    
    // Free memory
    free(person);
    person = NULL;
    
    return 0;
}
```

### Array Allocation
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int size;
    printf("Enter array size: ");
    scanf("%d", &size);
    
    // Allocate dynamic array
    int *arr = malloc(size * sizeof(int));
    if (arr == NULL) {
        printf("Allocation failed\n");
        return 1;
    }
    
    // Initialize array
    for (int i = 0; i < size; i++) {
        arr[i] = i * i;
    }
    
    // Use array
    printf("Array elements: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Free memory
    free(arr);
    arr = NULL;
    
    return 0;
}
```

### 2D Array Allocation
```c
#include <stdio.h>
#include <stdlib.h>

int** create_2d_array(int rows, int cols) {
    // Allocate array of row pointers
    int **matrix = malloc(rows * sizeof(int*));
    if (matrix == NULL) return NULL;
    
    // Allocate each row
    for (int i = 0; i < rows; i++) {
        matrix[i] = malloc(cols * sizeof(int));
        if (matrix[i] == NULL) {
            // Clean up on failure
            for (int j = 0; j < i; j++) {
                free(matrix[j]);
            }
            free(matrix);
            return NULL;
        }
    }
    
    return matrix;
}

void free_2d_array(int **matrix, int rows) {
    for (int i = 0; i < rows; i++) {
        free(matrix[i]);
    }
    free(matrix);
}

int main() {
    int rows = 3, cols = 4;
    int **matrix = create_2d_array(rows, cols);
    
    if (matrix == NULL) {
        printf("Matrix allocation failed\n");
        return 1;
    }
    
    // Initialize matrix
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            matrix[i][j] = i * cols + j;
        }
    }
    
    // Print matrix
    printf("Matrix:\n");
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    // Free memory
    free_2d_array(matrix, rows);
    
    return 0;
}
```

## Memory Management Best Practices

### Error Checking
Always check if memory allocation was successful:

```c
int *ptr = malloc(100 * sizeof(int));
if (ptr == NULL) {
    // Handle allocation failure
    fprintf(stderr, "Memory allocation failed\n");
    exit(EXIT_FAILURE);
}
```

### Preventing Dangling Pointers
Set pointers to NULL after freeing:

```c
free(ptr);
ptr = NULL;  // Prevent dangling pointer
```

### Avoiding Memory Leaks
Ensure every malloc/calloc/realloc has a corresponding free:

```c
// Good practice
int *arr = malloc(10 * sizeof(int));
if (arr != NULL) {
    // Use array...
    free(arr);
    arr = NULL;
}
```

### Memory Reallocation Safety
Handle realloc failure properly:

```c
int *temp = realloc(arr, new_size * sizeof(int));
if (temp == NULL) {
    // realloc failed, original array still valid
    // Handle error without losing original data
    fprintf(stderr, "Reallocation failed\n");
    // arr is still valid
} else {
    // realloc succeeded
    arr = temp;
}
```

## Common Memory Management Patterns

### Dynamic String Handling
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

char* duplicate_string(const char *source) {
    if (source == NULL) return NULL;
    
    size_t len = strlen(source);
    char *copy = malloc((len + 1) * sizeof(char));
    if (copy == NULL) return NULL;
    
    strcpy(copy, source);
    return copy;
}

char* append_strings(const char *str1, const char *str2) {
    if (str1 == NULL || str2 == NULL) return NULL;
    
    size_t len1 = strlen(str1);
    size_t len2 = strlen(str2);
    char *result = malloc((len1 + len2 + 1) * sizeof(char));
    if (result == NULL) return NULL;
    
    strcpy(result, str1);
    strcat(result, str2);
    
    return result;
}

int main() {
    char *original = "Hello, ";
    char *append = "World!";
    
    char *copy = duplicate_string(original);
    char *combined = append_strings(original, append);
    
    if (copy != NULL) {
        printf("Copy: %s\n", copy);
        free(copy);
    }
    
    if (combined != NULL) {
        printf("Combined: %s\n", combined);
        free(combined);
    }
    
    return 0;
}
```

### Dynamic Array with Resizing
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} DynamicArray;

DynamicArray* create_array(size_t initial_capacity) {
    DynamicArray *arr = malloc(sizeof(DynamicArray));
    if (arr == NULL) return NULL;
    
    arr->data = malloc(initial_capacity * sizeof(int));
    if (arr->data == NULL) {
        free(arr);
        return NULL;
    }
    
    arr->size = 0;
    arr->capacity = initial_capacity;
    return arr;
}

void push_back(DynamicArray *arr, int value) {
    if (arr->size >= arr->capacity) {
        // Double the capacity
        size_t new_capacity = arr->capacity * 2;
        int *temp = realloc(arr->data, new_capacity * sizeof(int));
        if (temp == NULL) return;  // Handle allocation failure
        
        arr->data = temp;
        arr->capacity = new_capacity;
    }
    
    arr->data[arr->size] = value;
    arr->size++;
}

void free_array(DynamicArray *arr) {
    if (arr != NULL) {
        free(arr->data);
        free(arr);
    }
}

int main() {
    DynamicArray *arr = create_array(2);
    if (arr == NULL) {
        printf("Array creation failed\n");
        return 1;
    }
    
    // Add elements (will trigger reallocation)
    for (int i = 0; i < 10; i++) {
        push_back(arr, i * i);
    }
    
    // Print elements
    printf("Array elements: ");
    for (size_t i = 0; i < arr->size; i++) {
        printf("%d ", arr->data[i]);
    }
    printf("\n");
    
    // Clean up
    free_array(arr);
    
    return 0;
}
```

## Memory Debugging Tools

### Valgrind (Linux/Unix)
Valgrind is a powerful tool for detecting memory errors:

```bash
# Compile with debugging information
gcc -g -Wall program.c -o program

# Run with Valgrind
valgrind --leak-check=full ./program
```

### AddressSanitizer (GCC/Clang)
AddressSanitizer detects memory errors at runtime:

```bash
# Compile with AddressSanitizer
gcc -fsanitize=address -g program.c -o program

# Run program (errors will be reported automatically)
./program
```

### Static Analysis Tools
Tools like cppcheck can detect potential memory issues:

```bash
# Static analysis
cppcheck --enable=all program.c
```

## Common Memory Errors and Solutions

### Memory Leaks
```c
// Problem: Memory leak
void memory_leak() {
    int *ptr = malloc(100 * sizeof(int));
    // Missing free(ptr) - memory leak!
}

// Solution: Always free allocated memory
void no_memory_leak() {
    int *ptr = malloc(100 * sizeof(int));
    if (ptr != NULL) {
        // Use memory...
        free(ptr);
        ptr = NULL;
    }
}
```

### Dangling Pointers
```c
// Problem: Dangling pointer
void dangling_pointer() {
    int *ptr = malloc(sizeof(int));
    *ptr = 42;
    free(ptr);
    printf("%d\n", *ptr);  // Undefined behavior!
}

// Solution: Set pointer to NULL after freeing
void no_dangling_pointer() {
    int *ptr = malloc(sizeof(int));
    *ptr = 42;
    free(ptr);
    ptr = NULL;
    // if (ptr != NULL) printf("%d\n", *ptr);  // Safe check
}
```

### Buffer Overflows
```c
// Problem: Buffer overflow
void buffer_overflow() {
    int *arr = malloc(5 * sizeof(int));
    for (int i = 0; i < 10; i++) {
        arr[i] = i;  // Writing beyond allocated memory
    }
    free(arr);
}

// Solution: Always check bounds
void no_buffer_overflow() {
    int *arr = malloc(5 * sizeof(int));
    for (int i = 0; i < 5; i++) {  // Correct bound
        arr[i] = i;
    }
    free(arr);
}
```

## Advanced Memory Management (C11 and Later)

### aligned_alloc()
The `aligned_alloc()` function allocates aligned memory (C11):

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Allocate 100 bytes aligned to 16-byte boundary
    void *ptr = aligned_alloc(16, 100);
    if (ptr == NULL) {
        printf("Aligned allocation failed\n");
        return 1;
    }
    
    printf("Allocated address: %p\n", ptr);
    printf("Alignment check: %s\n", 
           ((uintptr_t)ptr % 16 == 0) ? "OK" : "FAIL");
    
    free(ptr);
    return 0;
}
```

## Practical Examples

### Memory Pool Implementation
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    void *memory;
    size_t block_size;
    size_t total_blocks;
    size_t free_blocks;
    char *free_list;
} MemoryPool;

MemoryPool* create_pool(size_t block_size, size_t num_blocks) {
    MemoryPool *pool = malloc(sizeof(MemoryPool));
    if (pool == NULL) return NULL;
    
    pool->memory = malloc(block_size * num_blocks);
    if (pool->memory == NULL) {
        free(pool);
        return NULL;
    }
    
    pool->block_size = block_size;
    pool->total_blocks = num_blocks;
    pool->free_blocks = num_blocks;
    
    // Initialize free list
    pool->free_list = malloc(num_blocks);
    if (pool->free_list == NULL) {
        free(pool->memory);
        free(pool);
        return NULL;
    }
    
    for (size_t i = 0; i < num_blocks; i++) {
        pool->free_list[i] = 1;  // 1 = free, 0 = allocated
    }
    
    return pool;
}

void* pool_alloc(MemoryPool *pool) {
    if (pool->free_blocks == 0) return NULL;
    
    for (size_t i = 0; i < pool->total_blocks; i++) {
        if (pool->free_list[i]) {
            pool->free_list[i] = 0;
            pool->free_blocks--;
            return (char*)pool->memory + (i * pool->block_size);
        }
    }
    
    return NULL;
}

void pool_free(MemoryPool *pool, void *ptr) {
    if (ptr == NULL || ptr < pool->memory || 
        ptr >= (char*)pool->memory + (pool->total_blocks * pool->block_size)) {
        return;
    }
    
    size_t index = ((char*)ptr - (char*)pool->memory) / pool->block_size;
    if (index < pool->total_blocks && !pool->free_list[index]) {
        pool->free_list[index] = 1;
        pool->free_blocks++;
    }
}

void destroy_pool(MemoryPool *pool) {
    if (pool != NULL) {
        free(pool->memory);
        free(pool->free_list);
        free(pool);
    }
}

int main() {
    // Create pool for 10 integers
    MemoryPool *pool = create_pool(sizeof(int), 10);
    if (pool == NULL) {
        printf("Pool creation failed\n");
        return 1;
    }
    
    // Allocate from pool
    int *numbers[5];
    for (int i = 0; i < 5; i++) {
        numbers[i] = (int*)pool_alloc(pool);
        if (numbers[i] != NULL) {
            *numbers[i] = i * 10;
            printf("Allocated %d at %p\n", *numbers[i], (void*)numbers[i]);
        }
    }
    
    // Free some allocations
    pool_free(pool, numbers[2]);
    pool_free(pool, numbers[4]);
    
    // Allocate again (should reuse freed blocks)
    int *new_num = (int*)pool_alloc(pool);
    if (new_num != NULL) {
        *new_num = 999;
        printf("Reallocated %d at %p\n", *new_num, (void*)new_num);
    }
    
    // Clean up
    destroy_pool(pool);
    
    return 0;
}
```

### Smart Pointer-like Implementation
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    void *ptr;
    size_t ref_count;
    void (*destructor)(void*);
} SmartPointer;

SmartPointer* create_smart_pointer(size_t size, void (*destructor)(void*)) {
    SmartPointer *sp = malloc(sizeof(SmartPointer));
    if (sp == NULL) return NULL;
    
    sp->ptr = malloc(size);
    if (sp->ptr == NULL) {
        free(sp);
        return NULL;
    }
    
    sp->ref_count = 1;
    sp->destructor = destructor;
    
    return sp;
}

SmartPointer* smart_pointer_retain(SmartPointer *sp) {
    if (sp != NULL) {
        sp->ref_count++;
    }
    return sp;
}

void smart_pointer_release(SmartPointer *sp) {
    if (sp != NULL) {
        sp->ref_count--;
        if (sp->ref_count == 0) {
            if (sp->destructor != NULL) {
                sp->destructor(sp->ptr);
            } else {
                free(sp->ptr);
            }
            free(sp);
        }
    }
}

int main() {
    // Create smart pointer for integer
    SmartPointer *sp = create_smart_pointer(sizeof(int), NULL);
    if (sp == NULL) {
        printf("Smart pointer creation failed\n");
        return 1;
    }
    
    // Use the smart pointer
    *(int*)sp->ptr = 42;
    printf("Value: %d\n", *(int*)sp->ptr);
    
    // Create another reference
    SmartPointer *sp2 = smart_pointer_retain(sp);
    printf("Reference count: %zu\n", sp->ref_count);
    
    // Release first reference
    smart_pointer_release(sp);
    printf("Reference count after release: %zu\n", sp2->ref_count);
    
    // Release second reference (triggers deallocation)
    smart_pointer_release(sp2);
    
    return 0;
}
```

## Summary

Dynamic memory management is a powerful feature of C that provides flexibility for handling data structures whose size is unknown at compile time. Key points to remember:

1. **Memory Allocation Functions**: malloc, calloc, realloc, and free for memory management
2. **Memory Layout**: Understanding stack vs. heap allocation
3. **Error Handling**: Always check for allocation failures
4. **Memory Safety**: Prevent memory leaks, dangling pointers, and buffer overflows
5. **Best Practices**: Set pointers to NULL after freeing, check bounds, and use debugging tools
6. **Advanced Features**: aligned_alloc for aligned memory (C11+)
7. **Debugging Tools**: Valgrind, AddressSanitizer, and static analysis tools

Proper dynamic memory management is essential for writing robust, efficient C programs and avoiding common memory-related bugs.