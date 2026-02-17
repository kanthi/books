# Abstract Data Types

## Introduction

Abstract Data Types (ADTs) are a fundamental concept in software engineering that separate the interface of a data type from its implementation. In C, ADTs are implemented using structures, function pointers, and information hiding principles to create modular, maintainable, and reusable code. This approach enables programmers to encapsulate data and operations, providing a clean interface while hiding implementation details.

## Information Hiding Principles

### Separation of Interface and Implementation
Information hiding is achieved by separating the public interface (what users can access) from the private implementation (internal details):

```c
// stack.h - Public interface
#ifndef STACK_H
#define STACK_H

#include <stddef.h>

// Opaque pointer - hides implementation details
typedef struct Stack Stack;

// Public functions
Stack* stack_create(size_t capacity);
void stack_destroy(Stack *stack);
int stack_push(Stack *stack, int value);
int stack_pop(Stack *stack);
int stack_peek(const Stack *stack);
int stack_is_empty(const Stack *stack);
int stack_is_full(const Stack *stack);
size_t stack_size(const Stack *stack);

#endif // STACK_H
```

```c
// stack.c - Private implementation
#include "stack.h"
#include <stdlib.h>
#include <stdbool.h>

// Actual structure definition (hidden from users)
struct Stack {
    int *data;
    size_t capacity;
    size_t top;
};

Stack* stack_create(size_t capacity) {
    Stack *stack = malloc(sizeof(Stack));
    if (stack != NULL) {
        stack->data = malloc(capacity * sizeof(int));
        if (stack->data != NULL) {
            stack->capacity = capacity;
            stack->top = 0;
        } else {
            free(stack);
            stack = NULL;
        }
    }
    return stack;
}

void stack_destroy(Stack *stack) {
    if (stack != NULL) {
        free(stack->data);
        free(stack);
    }
}

int stack_push(Stack *stack, int value) {
    if (stack == NULL || stack->top >= stack->capacity) {
        return -1; // Error
    }
    stack->data[stack->top] = value;
    stack->top++;
    return 0; // Success
}

int stack_pop(Stack *stack) {
    if (stack == NULL || stack->top == 0) {
        return -1; // Error
    }
    stack->top--;
    return stack->data[stack->top];
}

int stack_peek(const Stack *stack) {
    if (stack == NULL || stack->top == 0) {
        return -1; // Error
    }
    return stack->data[stack->top - 1];
}

int stack_is_empty(const Stack *stack) {
    return (stack == NULL || stack->top == 0);
}

int stack_is_full(const Stack *stack) {
    return (stack != NULL && stack->top >= stack->capacity);
}

size_t stack_size(const Stack *stack) {
    return (stack != NULL) ? stack->top : 0;
}
```

```c
// main.c - Using the ADT
#include <stdio.h>
#include "stack.h"

int main() {
    Stack *stack = stack_create(10);
    if (stack == NULL) {
        printf("Failed to create stack\n");
        return 1;
    }
    
    // Use the stack
    stack_push(stack, 10);
    stack_push(stack, 20);
    stack_push(stack, 30);
    
    printf("Stack size: %zu\n", stack_size(stack));
    printf("Top element: %d\n", stack_peek(stack));
    
    while (!stack_is_empty(stack)) {
        printf("Popped: %d\n", stack_pop(stack));
    }
    
    stack_destroy(stack);
    return 0;
}
```

## Opaque Pointers

### Creating Opaque Pointers
Opaque pointers hide the implementation details of a data structure by only declaring the structure type in the header file:

```c
// vector.h - Opaque pointer example
#ifndef VECTOR_H
#define VECTOR_H

#include <stddef.h>

// Forward declaration - no structure definition
typedef struct Vector Vector;

// Public interface
Vector* vector_create(size_t initial_capacity);
void vector_destroy(Vector *vector);
int vector_push_back(Vector *vector, int value);
int vector_pop_back(Vector *vector);
int vector_get(const Vector *vector, size_t index);
int vector_set(Vector *vector, size_t index, int value);
size_t vector_size(const Vector *vector);
size_t vector_capacity(const Vector *vector);

#endif // VECTOR_H
```

```c
// vector.c - Implementation with opaque pointer
#include "vector.h"
#include <stdlib.h>

// Actual structure definition (private)
struct Vector {
    int *data;
    size_t size;
    size_t capacity;
};

Vector* vector_create(size_t initial_capacity) {
    Vector *vector = malloc(sizeof(Vector));
    if (vector != NULL) {
        vector->data = malloc(initial_capacity * sizeof(int));
        if (vector->data != NULL) {
            vector->size = 0;
            vector->capacity = initial_capacity;
        } else {
            free(vector);
            vector = NULL;
        }
    }
    return vector;
}

void vector_destroy(Vector *vector) {
    if (vector != NULL) {
        free(vector->data);
        free(vector);
    }
}

int vector_push_back(Vector *vector, int value) {
    if (vector == NULL) return -1;
    
    // Resize if needed
    if (vector->size >= vector->capacity) {
        size_t new_capacity = vector->capacity * 2;
        int *new_data = realloc(vector->data, new_capacity * sizeof(int));
        if (new_data == NULL) return -1;
        
        vector->data = new_data;
        vector->capacity = new_capacity;
    }
    
    vector->data[vector->size] = value;
    vector->size++;
    return 0;
}

int vector_pop_back(Vector *vector) {
    if (vector == NULL || vector->size == 0) return -1;
    vector->size--;
    return vector->data[vector->size];
}

int vector_get(const Vector *vector, size_t index) {
    if (vector == NULL || index >= vector->size) return -1;
    return vector->data[index];
}

int vector_set(Vector *vector, size_t index, int value) {
    if (vector == NULL || index >= vector->size) return -1;
    vector->data[index] = value;
    return 0;
}

size_t vector_size(const Vector *vector) {
    return (vector != NULL) ? vector->size : 0;
}

size_t vector_capacity(const Vector *vector) {
    return (vector != NULL) ? vector->capacity : 0;
}
```

## Constructor and Destructor Patterns

### Resource Acquisition Is Initialization (RAII) in C
Implementing constructor and destructor patterns for proper resource management:

```c
// file_manager.h
#ifndef FILE_MANAGER_H
#define FILE_MANAGER_H

#include <stdio.h>

typedef struct FileManager FileManager;

FileManager* file_manager_create(const char *filename, const char *mode);
void file_manager_destroy(FileManager *fm);
int file_manager_write(FileManager *fm, const char *data);
int file_manager_read(FileManager *fm, char *buffer, size_t size);
long file_manager_get_size(FileManager *fm);

#endif // FILE_MANAGER_H
```

```c
// file_manager.c
#include "file_manager.h"
#include <stdlib.h>
#include <string.h>

struct FileManager {
    FILE *file;
    char *filename;
    char *mode;
};

FileManager* file_manager_create(const char *filename, const char *mode) {
    FileManager *fm = malloc(sizeof(FileManager));
    if (fm == NULL) return NULL;
    
    fm->filename = malloc(strlen(filename) + 1);
    if (fm->filename == NULL) {
        free(fm);
        return NULL;
    }
    
    fm->mode = malloc(strlen(mode) + 1);
    if (fm->mode == NULL) {
        free(fm->filename);
        free(fm);
        return NULL;
    }
    
    strcpy(fm->filename, filename);
    strcpy(fm->mode, mode);
    
    fm->file = fopen(filename, mode);
    if (fm->file == NULL) {
        free(fm->mode);
        free(fm->filename);
        free(fm);
        return NULL;
    }
    
    return fm;
}

void file_manager_destroy(FileManager *fm) {
    if (fm != NULL) {
        if (fm->file != NULL) {
            fclose(fm->file);
        }
        free(fm->mode);
        free(fm->filename);
        free(fm);
    }
}

int file_manager_write(FileManager *fm, const char *data) {
    if (fm == NULL || fm->file == NULL || data == NULL) return -1;
    return fputs(data, fm->file) >= 0 ? 0 : -1;
}

int file_manager_read(FileManager *fm, char *buffer, size_t size) {
    if (fm == NULL || fm->file == NULL || buffer == NULL) return -1;
    return fgets(buffer, (int)size, fm->file) != NULL ? 0 : -1;
}

long file_manager_get_size(FileManager *fm) {
    if (fm == NULL || fm->file == NULL) return -1;
    
    long current_pos = ftell(fm->file);
    fseek(fm->file, 0, SEEK_END);
    long size = ftell(fm->file);
    fseek(fm->file, current_pos, SEEK_SET);
    
    return size;
}
```

## Generic Abstract Data Types

### Using Void Pointers for Generic ADTs
Creating generic ADTs that can work with any data type:

```c
// generic_list.h
#ifndef GENERIC_LIST_H
#define GENERIC_LIST_H

#include <stddef.h>

typedef struct GenericList GenericList;

// Function pointer types for generic operations
typedef void (*destructor_func)(void *data);
typedef int (*compare_func)(const void *a, const void *b);
typedef void (*print_func)(const void *data);

GenericList* generic_list_create(destructor_func destructor);
void generic_list_destroy(GenericList *list);
int generic_list_append(GenericList *list, void *data);
int generic_list_prepend(GenericList *list, void *data);
void* generic_list_get(const GenericList *list, size_t index);
int generic_list_remove(GenericList *list, size_t index);
size_t generic_list_size(const GenericList *list);
void generic_list_print(const GenericList *list, print_func printer);

#endif // GENERIC_LIST_H
```

```c
// generic_list.c
#include "generic_list.h"
#include <stdlib.h>

struct Node {
    void *data;
    struct Node *next;
};

struct GenericList {
    struct Node *head;
    size_t size;
    destructor_func destructor;
};

GenericList* generic_list_create(destructor_func destructor) {
    GenericList *list = malloc(sizeof(GenericList));
    if (list != NULL) {
        list->head = NULL;
        list->size = 0;
        list->destructor = destructor;
    }
    return list;
}

void generic_list_destroy(GenericList *list) {
    if (list != NULL) {
        struct Node *current = list->head;
        while (current != NULL) {
            struct Node *next = current->next;
            if (list->destructor != NULL) {
                list->destructor(current->data);
            }
            free(current);
            current = next;
        }
        free(list);
    }
}

int generic_list_append(GenericList *list, void *data) {
    if (list == NULL) return -1;
    
    struct Node *new_node = malloc(sizeof(struct Node));
    if (new_node == NULL) return -1;
    
    new_node->data = data;
    new_node->next = NULL;
    
    if (list->head == NULL) {
        list->head = new_node;
    } else {
        struct Node *current = list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
    
    list->size++;
    return 0;
}

void* generic_list_get(const GenericList *list, size_t index) {
    if (list == NULL || index >= list->size) return NULL;
    
    struct Node *current = list->head;
    for (size_t i = 0; i < index && current != NULL; i++) {
        current = current->next;
    }
    
    return (current != NULL) ? current->data : NULL;
}

int generic_list_remove(GenericList *list, size_t index) {
    if (list == NULL || index >= list->size) return -1;
    
    struct Node *to_remove;
    if (index == 0) {
        to_remove = list->head;
        list->head = to_remove->next;
    } else {
        struct Node *current = list->head;
        for (size_t i = 0; i < index - 1 && current != NULL; i++) {
            current = current->next;
        }
        if (current == NULL || current->next == NULL) return -1;
        
        to_remove = current->next;
        current->next = to_remove->next;
    }
    
    if (list->destructor != NULL) {
        list->destructor(to_remove->data);
    }
    free(to_remove);
    list->size--;
    
    return 0;
}

size_t generic_list_size(const GenericList *list) {
    return (list != NULL) ? list->size : 0;
}

void generic_list_print(const GenericList *list, print_func printer) {
    if (list == NULL || printer == NULL) return;
    
    struct Node *current = list->head;
    while (current != NULL) {
        printer(current->data);
        current = current->next;
    }
}
```

```c
// Example usage with different data types
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "generic_list.h"

// Integer destructor
void int_destructor(void *data) {
    free(data);
}

// Integer printer
void int_printer(const void *data) {
    printf("%d ", *(int*)data);
}

// String destructor
void string_destructor(void *data) {
    free(data);
}

// String printer
void string_printer(const void *data) {
    printf("%s ", (char*)data);
}

int main() {
    // Integer list
    GenericList *int_list = generic_list_create(int_destructor);
    if (int_list != NULL) {
        for (int i = 1; i <= 5; i++) {
            int *value = malloc(sizeof(int));
            *value = i * 10;
            generic_list_append(int_list, value);
        }
        
        printf("Integer list: ");
        generic_list_print(int_list, int_printer);
        printf("\n");
        
        generic_list_destroy(int_list);
    }
    
    // String list
    GenericList *string_list = generic_list_create(string_destructor);
    if (string_list != NULL) {
        char *str1 = malloc(20);
        char *str2 = malloc(20);
        char *str3 = malloc(20);
        
        strcpy(str1, "Hello");
        strcpy(str2, "World");
        strcpy(str3, "C");
        
        generic_list_append(string_list, str1);
        generic_list_append(string_list, str2);
        generic_list_append(string_list, str3);
        
        printf("String list: ");
        generic_list_print(string_list, string_printer);
        printf("\n");
        
        generic_list_destroy(string_list);
    }
    
    return 0;
}
```

## Interface Design in C

### Designing Clean APIs
Creating well-designed interfaces that are easy to use and maintain:

```c
// hash_table.h - Well-designed hash table interface
#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <stddef.h>
#include <stdbool.h>

typedef struct HashTable HashTable;

// Function pointer types for custom operations
typedef size_t (*hash_func)(const void *key);
typedef int (*compare_func)(const void *key1, const void *key2);
typedef void (*destructor_func)(void *data);

// Error codes
typedef enum {
    HASH_SUCCESS = 0,
    HASH_ERROR_NULL_POINTER = -1,
    HASH_ERROR_MEMORY = -2,
    HASH_ERROR_KEY_NOT_FOUND = -3,
    HASH_ERROR_DUPLICATE_KEY = -4
} HashError;

// Public functions
HashTable* hash_table_create(size_t initial_capacity,
                           hash_func hash_function,
                           compare_func compare_function,
                           destructor_func key_destructor,
                           destructor_func value_destructor);

void hash_table_destroy(HashTable *table);
HashError hash_table_insert(HashTable *table, void *key, void *value);
HashError hash_table_remove(HashTable *table, const void *key);
void* hash_table_lookup(const HashTable *table, const void *key);
bool hash_table_contains(const HashTable *table, const void *key);
size_t hash_table_size(const HashTable *table);
void hash_table_clear(HashTable *table);

// Utility functions
size_t hash_string(const void *key);  // Default string hash function
int compare_strings(const void *key1, const void *key2);  // Default string compare

#endif // HASH_TABLE_H
```

```c
// hash_table.c - Implementation
#include "hash_table.h"
#include <stdlib.h>
#include <string.h>

// Hash table entry
struct Entry {
    void *key;
    void *value;
    struct Entry *next;
};

// Hash table structure
struct HashTable {
    struct Entry **buckets;
    size_t bucket_count;
    size_t size;
    hash_func hash_function;
    compare_func compare_function;
    destructor_func key_destructor;
    destructor_func value_destructor;
};

// Default hash function for strings
size_t hash_string(const void *key) {
    const char *str = (const char*)key;
    size_t hash = 5381;
    int c;
    
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;  // hash * 33 + c
    }
    
    return hash;
}

// Default compare function for strings
int compare_strings(const void *key1, const void *key2) {
    return strcmp((const char*)key1, (const char*)key2);
}

HashTable* hash_table_create(size_t initial_capacity,
                           hash_func hash_function,
                           compare_func compare_function,
                           destructor_func key_destructor,
                           destructor_func value_destructor) {
    HashTable *table = malloc(sizeof(HashTable));
    if (table == NULL) return NULL;
    
    table->buckets = calloc(initial_capacity, sizeof(struct Entry*));
    if (table->buckets == NULL) {
        free(table);
        return NULL;
    }
    
    table->bucket_count = initial_capacity;
    table->size = 0;
    table->hash_function = hash_function ? hash_function : hash_string;
    table->compare_function = compare_function ? compare_function : compare_strings;
    table->key_destructor = key_destructor;
    table->value_destructor = value_destructor;
    
    return table;
}

void hash_table_destroy(HashTable *table) {
    if (table != NULL) {
        hash_table_clear(table);
        free(table->buckets);
        free(table);
    }
}

HashError hash_table_insert(HashTable *table, void *key, void *value) {
    if (table == NULL || key == NULL) return HASH_ERROR_NULL_POINTER;
    
    size_t index = table->hash_function(key) % table->bucket_count;
    
    // Check for duplicate key
    struct Entry *current = table->buckets[index];
    while (current != NULL) {
        if (table->compare_function(current->key, key) == 0) {
            return HASH_ERROR_DUPLICATE_KEY;
        }
        current = current->next;
    }
    
    // Create new entry
    struct Entry *new_entry = malloc(sizeof(struct Entry));
    if (new_entry == NULL) return HASH_ERROR_MEMORY;
    
    new_entry->key = key;
    new_entry->value = value;
    new_entry->next = table->buckets[index];
    table->buckets[index] = new_entry;
    table->size++;
    
    return HASH_SUCCESS;
}

void* hash_table_lookup(const HashTable *table, const void *key) {
    if (table == NULL || key == NULL) return NULL;
    
    size_t index = table->hash_function(key) % table->bucket_count;
    
    struct Entry *current = table->buckets[index];
    while (current != NULL) {
        if (table->compare_function(current->key, key) == 0) {
            return current->value;
        }
        current = current->next;
    }
    
    return NULL;
}

HashError hash_table_remove(HashTable *table, const void *key) {
    if (table == NULL || key == NULL) return HASH_ERROR_NULL_POINTER;
    
    size_t index = table->hash_function(key) % table->bucket_count;
    
    struct Entry *current = table->buckets[index];
    struct Entry *previous = NULL;
    
    while (current != NULL) {
        if (table->compare_function(current->key, key) == 0) {
            if (previous == NULL) {
                table->buckets[index] = current->next;
            } else {
                previous->next = current->next;
            }
            
            if (table->key_destructor != NULL) {
                table->key_destructor(current->key);
            }
            if (table->value_destructor != NULL) {
                table->value_destructor(current->value);
            }
            
            free(current);
            table->size--;
            return HASH_SUCCESS;
        }
        
        previous = current;
        current = current->next;
    }
    
    return HASH_ERROR_KEY_NOT_FOUND;
}

bool hash_table_contains(const HashTable *table, const void *key) {
    return hash_table_lookup(table, key) != NULL;
}

size_t hash_table_size(const HashTable *table) {
    return (table != NULL) ? table->size : 0;
}

void hash_table_clear(HashTable *table) {
    if (table == NULL) return;
    
    for (size_t i = 0; i < table->bucket_count; i++) {
        struct Entry *current = table->buckets[i];
        while (current != NULL) {
            struct Entry *next = current->next;
            
            if (table->key_destructor != NULL) {
                table->key_destructor(current->key);
            }
            if (table->value_destructor != NULL) {
                table->value_destructor(current->value);
            }
            
            free(current);
            current = next;
        }
        table->buckets[i] = NULL;
    }
    
    table->size = 0;
}
```

## Practical Examples

### Complete ADT Implementation: Dynamic Array
A complete implementation of a dynamic array ADT with comprehensive error handling:

```c
// dynamic_array.h
#ifndef DYNAMIC_ARRAY_H
#define DYNAMIC_ARRAY_H

#include <stddef.h>

typedef struct DynamicArray DynamicArray;

// Error codes
typedef enum {
    DYNARRAY_SUCCESS = 0,
    DYNARRAY_ERROR_NULL_POINTER = -1,
    DYNARRAY_ERROR_OUT_OF_BOUNDS = -2,
    DYNARRAY_ERROR_MEMORY = -3,
    DYNARRAY_ERROR_INVALID_SIZE = -4
} DynamicArrayError;

// Function pointer types
typedef void (*destructor_func)(void *data);
typedef int (*compare_func)(const void *a, const void *b);

// Public interface
DynamicArray* dynamic_array_create(size_t element_size, destructor_func destructor);
void dynamic_array_destroy(DynamicArray *array);
DynamicArrayError dynamic_array_push_back(DynamicArray *array, const void *element);
DynamicArrayError dynamic_array_pop_back(DynamicArray *array, void *element);
DynamicArrayError dynamic_array_get(const DynamicArray *array, size_t index, void *element);
DynamicArrayError dynamic_array_set(DynamicArray *array, size_t index, const void *element);
DynamicArrayError dynamic_array_insert(DynamicArray *array, size_t index, const void *element);
DynamicArrayError dynamic_array_remove(DynamicArray *array, size_t index);
size_t dynamic_array_size(const DynamicArray *array);
size_t dynamic_array_capacity(const DynamicArray *array);
DynamicArrayError dynamic_array_resize(DynamicArray *array, size_t new_size);
DynamicArrayError dynamic_array_clear(DynamicArray *array);
DynamicArrayError dynamic_array_sort(DynamicArray *array, compare_func compare);

#endif // DYNAMIC_ARRAY_H
```

```c
// dynamic_array.c
#include "dynamic_array.h"
#include <stdlib.h>
#include <string.h>

#define INITIAL_CAPACITY 8
#define GROWTH_FACTOR 2

struct DynamicArray {
    void *data;
    size_t size;
    size_t capacity;
    size_t element_size;
    destructor_func destructor;
};

DynamicArray* dynamic_array_create(size_t element_size, destructor_func destructor) {
    if (element_size == 0) return NULL;
    
    DynamicArray *array = malloc(sizeof(DynamicArray));
    if (array == NULL) return NULL;
    
    array->data = malloc(INITIAL_CAPACITY * element_size);
    if (array->data == NULL) {
        free(array);
        return NULL;
    }
    
    array->size = 0;
    array->capacity = INITIAL_CAPACITY;
    array->element_size = element_size;
    array->destructor = destructor;
    
    return array;
}

void dynamic_array_destroy(DynamicArray *array) {
    if (array != NULL) {
        dynamic_array_clear(array);
        free(array->data);
        free(array);
    }
}

DynamicArrayError dynamic_array_push_back(DynamicArray *array, const void *element) {
    if (array == NULL || element == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    
    if (array->size >= array->capacity) {
        size_t new_capacity = array->capacity * GROWTH_FACTOR;
        void *new_data = realloc(array->data, new_capacity * array->element_size);
        if (new_data == NULL) return DYNARRAY_ERROR_MEMORY;
        
        array->data = new_data;
        array->capacity = new_capacity;
    }
    
    void *dest = (char*)array->data + array->size * array->element_size;
    memcpy(dest, element, array->element_size);
    array->size++;
    
    return DYNARRAY_SUCCESS;
}

DynamicArrayError dynamic_array_pop_back(DynamicArray *array, void *element) {
    if (array == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    if (array->size == 0) return DYNARRAY_ERROR_OUT_OF_BOUNDS;
    
    if (element != NULL) {
        void *src = (char*)array->data + (array->size - 1) * array->element_size;
        memcpy(element, src, array->element_size);
    }
    
    array->size--;
    return DYNARRAY_SUCCESS;
}

DynamicArrayError dynamic_array_get(const DynamicArray *array, size_t index, void *element) {
    if (array == NULL || element == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    if (index >= array->size) return DYNARRAY_ERROR_OUT_OF_BOUNDS;
    
    void *src = (char*)array->data + index * array->element_size;
    memcpy(element, src, array->element_size);
    
    return DYNARRAY_SUCCESS;
}

DynamicArrayError dynamic_array_set(DynamicArray *array, size_t index, const void *element) {
    if (array == NULL || element == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    if (index >= array->size) return DYNARRAY_ERROR_OUT_OF_BOUNDS;
    
    void *dest = (char*)array->data + index * array->element_size;
    memcpy(dest, element, array->element_size);
    
    return DYNARRAY_SUCCESS;
}

size_t dynamic_array_size(const DynamicArray *array) {
    return (array != NULL) ? array->size : 0;
}

size_t dynamic_array_capacity(const DynamicArray *array) {
    return (array != NULL) ? array->capacity : 0;
}

DynamicArrayError dynamic_array_clear(DynamicArray *array) {
    if (array == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    
    if (array->destructor != NULL) {
        for (size_t i = 0; i < array->size; i++) {
            void *element = (char*)array->data + i * array->element_size;
            array->destructor(element);
        }
    }
    
    array->size = 0;
    return DYNARRAY_SUCCESS;
}

DynamicArrayError dynamic_array_sort(DynamicArray *array, compare_func compare) {
    if (array == NULL || compare == NULL) return DYNARRAY_ERROR_NULL_POINTER;
    
    // Simple bubble sort implementation
    for (size_t i = 0; i < array->size - 1; i++) {
        for (size_t j = 0; j < array->size - i - 1; j++) {
            void *elem1 = (char*)array->data + j * array->element_size;
            void *elem2 = (char*)array->data + (j + 1) * array->element_size;
            
            if (compare(elem1, elem2) > 0) {
                // Swap elements
                char *temp = malloc(array->element_size);
                if (temp == NULL) return DYNARRAY_ERROR_MEMORY;
                
                memcpy(temp, elem1, array->element_size);
                memcpy(elem1, elem2, array->element_size);
                memcpy(elem2, temp, array->element_size);
                
                free(temp);
            }
        }
    }
    
    return DYNARRAY_SUCCESS;
}
```

```c
// Example usage
#include <stdio.h>
#include <stdlib.h>
#include "dynamic_array.h"

// Integer destructor
void int_destructor(void *data) {
    // No special cleanup needed for integers
}

// Integer compare function
int compare_ints(const void *a, const void *b) {
    int int_a = *(const int*)a;
    int int_b = *(const int*)b;
    return (int_a > int_b) - (int_a < int_b);
}

int main() {
    DynamicArray *array = dynamic_array_create(sizeof(int), int_destructor);
    if (array == NULL) {
        printf("Failed to create dynamic array\n");
        return 1;
    }
    
    // Add elements
    for (int i = 10; i >= 1; i--) {
        DynamicArrayError err = dynamic_array_push_back(array, &i);
        if (err != DYNARRAY_SUCCESS) {
            printf("Error adding element: %d\n", err);
            break;
        }
    }
    
    printf("Array size: %zu, capacity: %zu\n", 
           dynamic_array_size(array), dynamic_array_capacity(array));
    
    // Print elements
    printf("Before sorting: ");
    for (size_t i = 0; i < dynamic_array_size(array); i++) {
        int value;
        if (dynamic_array_get(array, i, &value) == DYNARRAY_SUCCESS) {
            printf("%d ", value);
        }
    }
    printf("\n");
    
    // Sort array
    DynamicArrayError err = dynamic_array_sort(array, compare_ints);
    if (err == DYNARRAY_SUCCESS) {
        printf("After sorting: ");
        for (size_t i = 0; i < dynamic_array_size(array); i++) {
            int value;
            if (dynamic_array_get(array, i, &value) == DYNARRAY_SUCCESS) {
                printf("%d ", value);
            }
        }
        printf("\n");
    }
    
    dynamic_array_destroy(array);
    return 0;
}
```

## Summary

Abstract Data Types in C provide a powerful mechanism for creating modular, maintainable, and reusable code:

1. **Information Hiding**: Separate interface from implementation using opaque pointers
2. **Opaque Pointers**: Hide structure details by only declaring types in headers
3. **Constructor/Destructor Patterns**: Ensure proper resource management
4. **Generic ADTs**: Use void pointers and function pointers for type flexibility
5. **Clean Interface Design**: Provide clear, consistent APIs with proper error handling
6. **Memory Management**: Implement proper allocation and deallocation strategies

These concepts enable C programmers to write code that is as maintainable and reusable as code written in object-oriented languages, while maintaining C's performance characteristics and low-level control.