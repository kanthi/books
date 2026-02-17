# Hash Tables

## Introduction

Hash tables (also known as hash maps) are data structures that store key-value pairs and provide efficient insertion, deletion, and lookup operations with an average time complexity of O(1). They achieve this efficiency by using a hash function to compute an index into an array of buckets or slots, from which the desired value can be found.

Hash tables are fundamental in computer science and are used extensively in databases, caches, sets, and many other applications where fast data retrieval is essential.

## Hash Function Design

A good hash function is crucial for the performance of a hash table. It should distribute keys uniformly across the hash table to minimize collisions and ensure efficient operations.

### Basic Hash Functions

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

// Simple hash function for integers
unsigned int hash_int(int key, int table_size) {
    return key % table_size;
}

// Simple hash function for strings (djb2 algorithm)
unsigned int hash_string(const char *str, int table_size) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c;  // hash * 33 + c
    }
    
    return hash % table_size;
}

// Simple hash function for strings (sdbm algorithm)
unsigned int hash_string_sdbm(const char *str, int table_size) {
    unsigned long hash = 0;
    int c;
    
    while ((c = *str++)) {
        hash = c + (hash << 6) + (hash << 16) - hash;
    }
    
    return hash % table_size;
}

// Universal hash function
unsigned int hash_universal(unsigned int key, int table_size, 
                           unsigned int a, unsigned int b, unsigned int p) {
    // Universal hashing: h(key) = ((a * key + b) mod p) mod table_size
    // where p is a prime number >= table_size
    return ((a * key + b) % p) % table_size;
}

int main() {
    int table_size = 100;
    
    // Test integer hash function
    printf("Hash values for integers:\n");
    for (int i = 1; i <= 10; i++) {
        printf("Key %d -> Hash %u\n", i, hash_int(i, table_size));
    }
    
    printf("\nHash values for strings (djb2):\n");
    const char *strings[] = {"hello", "world", "hash", "table", "example"};
    for (int i = 0; i < 5; i++) {
        printf("Key '%s' -> Hash %u\n", strings[i], hash_string(strings[i], table_size));
    }
    
    printf("\nHash values for strings (sdbm):\n");
    for (int i = 0; i < 5; i++) {
        printf("Key '%s' -> Hash %u\n", strings[i], hash_string_sdbm(strings[i], table_size));
    }
    
    return 0;
}
```

## Collision Resolution Strategies

When two keys hash to the same index, a collision occurs. There are several strategies to handle collisions:

### Chaining

In chaining, each bucket contains a linked list of elements that hash to the same index.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define TABLE_SIZE 10

typedef struct HashNode {
    char key[100];
    int value;
    struct HashNode *next;
} HashNode;

typedef struct {
    HashNode *buckets[TABLE_SIZE];
    int size;
} HashTable;

// Create new hash node
HashNode* create_hash_node(const char *key, int value) {
    HashNode *node = malloc(sizeof(HashNode));
    if (node == NULL) return NULL;
    
    strncpy(node->key, key, sizeof(node->key) - 1);
    node->key[sizeof(node->key) - 1] = '\0';
    node->value = value;
    node->next = NULL;
    
    return node;
}

// Initialize hash table
HashTable* create_hash_table(void) {
    HashTable *table = malloc(sizeof(HashTable));
    if (table == NULL) return NULL;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    
    table->size = 0;
    return table;
}

// Free hash table
void free_hash_table(HashTable *table) {
    if (table == NULL) return;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        HashNode *current = table->buckets[i];
        while (current != NULL) {
            HashNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(table);
}

// Hash function for strings
unsigned int hash(const char *key) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash % TABLE_SIZE;
}

// Insert key-value pair
bool hash_table_insert(HashTable *table, const char *key, int value) {
    if (table == NULL || key == NULL) return false;
    
    unsigned int index = hash(key);
    
    // Check if key already exists
    HashNode *current = table->buckets[index];
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            current->value = value;  // Update existing value
            return true;
        }
        current = current->next;
    }
    
    // Create new node and insert at beginning of chain
    HashNode *new_node = create_hash_node(key, value);
    if (new_node == NULL) return false;
    
    new_node->next = table->buckets[index];
    table->buckets[index] = new_node;
    table->size++;
    
    return true;
}

// Search for key
bool hash_table_search(HashTable *table, const char *key, int *value) {
    if (table == NULL || key == NULL) return false;
    
    unsigned int index = hash(key);
    
    HashNode *current = table->buckets[index];
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            if (value != NULL) {
                *value = current->value;
            }
            return true;
        }
        current = current->next;
    }
    
    return false;
}

// Delete key
bool hash_table_delete(HashTable *table, const char *key) {
    if (table == NULL || key == NULL) return false;
    
    unsigned int index = hash(key);
    
    HashNode *current = table->buckets[index];
    HashNode *prev = NULL;
    
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            if (prev == NULL) {
                // First node in chain
                table->buckets[index] = current->next;
            } else {
                prev->next = current->next;
            }
            
            free(current);
            table->size--;
            return true;
        }
        
        prev = current;
        current = current->next;
    }
    
    return false;
}

// Print hash table
void print_hash_table(HashTable *table) {
    if (table == NULL) return;
    
    printf("Hash Table (size: %d):\n", table->size);
    for (int i = 0; i < TABLE_SIZE; i++) {
        printf("Bucket %d: ", i);
        
        HashNode *current = table->buckets[i];
        if (current == NULL) {
            printf("empty\n");
        } else {
            while (current != NULL) {
                printf("(%s: %d) -> ", current->key, current->value);
                current = current->next;
            }
            printf("NULL\n");
        }
    }
}

int main() {
    HashTable *table = create_hash_table();
    if (table == NULL) {
        printf("Failed to create hash table\n");
        return 1;
    }
    
    // Insert key-value pairs
    hash_table_insert(table, "apple", 5);
    hash_table_insert(table, "banana", 3);
    hash_table_insert(table, "orange", 8);
    hash_table_insert(table, "grape", 12);
    hash_table_insert(table, "kiwi", 7);
    
    print_hash_table(table);
    
    // Search for keys
    int value;
    if (hash_table_search(table, "apple", &value)) {
        printf("Found 'apple': %d\n", value);
    }
    
    if (hash_table_search(table, "mango", &value)) {
        printf("Found 'mango': %d\n", value);
    } else {
        printf("'mango' not found\n");
    }
    
    // Update existing key
    hash_table_insert(table, "apple", 10);
    printf("After updating 'apple':\n");
    if (hash_table_search(table, "apple", &value)) {
        printf("Found 'apple': %d\n", value);
    }
    
    // Delete key
    if (hash_table_delete(table, "banana")) {
        printf("Deleted 'banana'\n");
    }
    
    print_hash_table(table);
    
    free_hash_table(table);
    return 0;
}
```

### Open Addressing

In open addressing, all elements are stored in the hash table itself. When a collision occurs, alternative slots are probed until an empty slot is found.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define TABLE_SIZE 13
#define EMPTY_CELL -1
#define DELETED_CELL -2

typedef struct {
    char key[100];
    int value;
    int status;  // EMPTY_CELL, DELETED_CELL, or occupied
} HashEntry;

typedef struct {
    HashEntry entries[TABLE_SIZE];
    int size;
} OpenHashTable;

// Initialize open hash table
OpenHashTable* create_open_hash_table(void) {
    OpenHashTable *table = malloc(sizeof(OpenHashTable));
    if (table == NULL) return NULL;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->entries[i].status = EMPTY_CELL;
    }
    
    table->size = 0;
    return table;
}

// Free open hash table
void free_open_hash_table(OpenHashTable *table) {
    free(table);
}

// Hash function
unsigned int hash_open(const char *key) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash % TABLE_SIZE;
}

// Linear probing hash function
unsigned int hash_linear_probe(const char *key, int attempt) {
    return (hash_open(key) + attempt) % TABLE_SIZE;
}

// Quadratic probing hash function
unsigned int hash_quadratic_probe(const char *key, int attempt) {
    return (hash_open(key) + attempt * attempt) % TABLE_SIZE;
}

// Double hashing
unsigned int hash_double(const char *key, int attempt) {
    unsigned int hash1 = hash_open(key);
    unsigned int hash2 = 7 - (hash_open(key) % 7);  // Second hash function
    return (hash1 + attempt * hash2) % TABLE_SIZE;
}

// Insert with linear probing
bool open_hash_table_insert(OpenHashTable *table, const char *key, int value) {
    if (table == NULL || key == NULL) return false;
    
    int attempt = 0;
    unsigned int index;
    
    do {
        index = hash_linear_probe(key, attempt);
        
        if (table->entries[index].status == EMPTY_CELL || 
            table->entries[index].status == DELETED_CELL) {
            // Found empty or deleted slot
            strncpy(table->entries[index].key, key, sizeof(table->entries[index].key) - 1);
            table->entries[index].key[sizeof(table->entries[index].key) - 1] = '\0';
            table->entries[index].value = value;
            table->entries[index].status = 0;  // Occupied
            table->size++;
            return true;
        } else if (strcmp(table->entries[index].key, key) == 0) {
            // Key already exists, update value
            table->entries[index].value = value;
            return true;
        }
        
        attempt++;
    } while (attempt < TABLE_SIZE);
    
    // Hash table is full
    return false;
}

// Search with linear probing
bool open_hash_table_search(OpenHashTable *table, const char *key, int *value) {
    if (table == NULL || key == NULL) return false;
    
    int attempt = 0;
    unsigned int index;
    
    do {
        index = hash_linear_probe(key, attempt);
        
        if (table->entries[index].status == EMPTY_CELL) {
            // Key not found
            return false;
        } else if (table->entries[index].status != DELETED_CELL && 
                   strcmp(table->entries[index].key, key) == 0) {
            // Key found
            if (value != NULL) {
                *value = table->entries[index].value;
            }
            return true;
        }
        
        attempt++;
    } while (attempt < TABLE_SIZE);
    
    // Key not found
    return false;
}

// Delete with linear probing
bool open_hash_table_delete(OpenHashTable *table, const char *key) {
    if (table == NULL || key == NULL) return false;
    
    int attempt = 0;
    unsigned int index;
    
    do {
        index = hash_linear_probe(key, attempt);
        
        if (table->entries[index].status == EMPTY_CELL) {
            // Key not found
            return false;
        } else if (table->entries[index].status != DELETED_CELL && 
                   strcmp(table->entries[index].key, key) == 0) {
            // Key found, mark as deleted
            table->entries[index].status = DELETED_CELL;
            table->size--;
            return true;
        }
        
        attempt++;
    } while (attempt < TABLE_SIZE);
    
    // Key not found
    return false;
}

// Print open hash table
void print_open_hash_table(OpenHashTable *table) {
    if (table == NULL) return;
    
    printf("Open Hash Table (size: %d):\n", table->size);
    for (int i = 0; i < TABLE_SIZE; i++) {
        printf("Index %d: ", i);
        if (table->entries[i].status == EMPTY_CELL) {
            printf("EMPTY\n");
        } else if (table->entries[i].status == DELETED_CELL) {
            printf("DELETED\n");
        } else {
            printf("(%s: %d)\n", table->entries[i].key, table->entries[i].value);
        }
    }
}

int main() {
    OpenHashTable *table = create_open_hash_table();
    if (table == NULL) {
        printf("Failed to create hash table\n");
        return 1;
    }
    
    // Insert key-value pairs
    open_hash_table_insert(table, "apple", 5);
    open_hash_table_insert(table, "banana", 3);
    open_hash_table_insert(table, "orange", 8);
    open_hash_table_insert(table, "grape", 12);
    open_hash_table_insert(table, "kiwi", 7);
    
    print_open_hash_table(table);
    
    // Search for keys
    int value;
    if (open_hash_table_search(table, "apple", &value)) {
        printf("Found 'apple': %d\n", value);
    }
    
    if (open_hash_table_search(table, "mango", &value)) {
        printf("Found 'mango': %d\n", value);
    } else {
        printf("'mango' not found\n");
    }
    
    // Update existing key
    open_hash_table_insert(table, "apple", 10);
    printf("After updating 'apple':\n");
    if (open_hash_table_search(table, "apple", &value)) {
        printf("Found 'apple': %d\n", value);
    }
    
    // Delete key
    if (open_hash_table_delete(table, "banana")) {
        printf("Deleted 'banana'\n");
    }
    
    print_open_hash_table(table);
    
    free_open_hash_table(table);
    return 0;
}
```

## Dynamic Hash Tables

Dynamic hash tables can resize themselves when the load factor becomes too high, ensuring efficient performance.

### Resizable Hash Table with Chaining

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define INITIAL_SIZE 8
#define LOAD_FACTOR_THRESHOLD 0.75

typedef struct DynamicHashNode {
    char key[100];
    int value;
    struct DynamicHashNode *next;
} DynamicHashNode;

typedef struct {
    DynamicHashNode **buckets;
    int size;
    int capacity;
} DynamicHashTable;

// Create new hash node
DynamicHashNode* create_dynamic_hash_node(const char *key, int value) {
    DynamicHashNode *node = malloc(sizeof(DynamicHashNode));
    if (node == NULL) return NULL;
    
    strncpy(node->key, key, sizeof(node->key) - 1);
    node->key[sizeof(node->key) - 1] = '\0';
    node->value = value;
    node->next = NULL;
    
    return node;
}

// Initialize dynamic hash table
DynamicHashTable* create_dynamic_hash_table(void) {
    DynamicHashTable *table = malloc(sizeof(DynamicHashTable));
    if (table == NULL) return NULL;
    
    table->buckets = calloc(INITIAL_SIZE, sizeof(DynamicHashNode*));
    if (table->buckets == NULL) {
        free(table);
        return NULL;
    }
    
    table->size = 0;
    table->capacity = INITIAL_SIZE;
    return table;
}

// Free dynamic hash table
void free_dynamic_hash_table(DynamicHashTable *table) {
    if (table == NULL) return;
    
    for (int i = 0; i < table->capacity; i++) {
        DynamicHashNode *current = table->buckets[i];
        while (current != NULL) {
            DynamicHashNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(table->buckets);
    free(table);
}

// Hash function
unsigned int dynamic_hash(const char *key, int capacity) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash % capacity;
}

// Resize hash table
bool resize_hash_table(DynamicHashTable *table) {
    int old_capacity = table->capacity;
    int new_capacity = old_capacity * 2;
    
    DynamicHashNode **old_buckets = table->buckets;
    DynamicHashNode **new_buckets = calloc(new_capacity, sizeof(DynamicHashNode*));
    if (new_buckets == NULL) return false;
    
    table->buckets = new_buckets;
    table->capacity = new_capacity;
    
    // Rehash all elements
    for (int i = 0; i < old_capacity; i++) {
        DynamicHashNode *current = old_buckets[i];
        while (current != NULL) {
            DynamicHashNode *next = current->next;
            
            unsigned int new_index = dynamic_hash(current->key, new_capacity);
            current->next = table->buckets[new_index];
            table->buckets[new_index] = current;
            
            current = next;
        }
    }
    
    free(old_buckets);
    return true;
}

// Insert key-value pair
bool dynamic_hash_table_insert(DynamicHashTable *table, const char *key, int value) {
    if (table == NULL || key == NULL) return false;
    
    // Check if resize is needed
    double load_factor = (double)table->size / table->capacity;
    if (load_factor > LOAD_FACTOR_THRESHOLD) {
        if (!resize_hash_table(table)) {
            return false;
        }
    }
    
    unsigned int index = dynamic_hash(key, table->capacity);
    
    // Check if key already exists
    DynamicHashNode *current = table->buckets[index];
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            current->value = value;  // Update existing value
            return true;
        }
        current = current->next;
    }
    
    // Create new node and insert at beginning of chain
    DynamicHashNode *new_node = create_dynamic_hash_node(key, value);
    if (new_node == NULL) return false;
    
    new_node->next = table->buckets[index];
    table->buckets[index] = new_node;
    table->size++;
    
    return true;
}

// Search for key
bool dynamic_hash_table_search(DynamicHashTable *table, const char *key, int *value) {
    if (table == NULL || key == NULL) return false;
    
    unsigned int index = dynamic_hash(key, table->capacity);
    
    DynamicHashNode *current = table->buckets[index];
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            if (value != NULL) {
                *value = current->value;
            }
            return true;
        }
        current = current->next;
    }
    
    return false;
}

// Delete key
bool dynamic_hash_table_delete(DynamicHashTable *table, const char *key) {
    if (table == NULL || key == NULL) return false;
    
    unsigned int index = dynamic_hash(key, table->capacity);
    
    DynamicHashNode *current = table->buckets[index];
    DynamicHashNode *prev = NULL;
    
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            if (prev == NULL) {
                // First node in chain
                table->buckets[index] = current->next;
            } else {
                prev->next = current->next;
            }
            
            free(current);
            table->size--;
            return true;
        }
        
        prev = current;
        current = current->next;
    }
    
    return false;
}

// Print dynamic hash table
void print_dynamic_hash_table(DynamicHashTable *table) {
    if (table == NULL) return;
    
    printf("Dynamic Hash Table (size: %d, capacity: %d, load factor: %.2f):\n", 
           table->size, table->capacity, (double)table->size / table->capacity);
    
    for (int i = 0; i < table->capacity; i++) {
        printf("Bucket %d: ", i);
        
        DynamicHashNode *current = table->buckets[i];
        if (current == NULL) {
            printf("empty\n");
        } else {
            while (current != NULL) {
                printf("(%s: %d) -> ", current->key, current->value);
                current = current->next;
            }
            printf("NULL\n");
        }
    }
}

int main() {
    DynamicHashTable *table = create_dynamic_hash_table();
    if (table == NULL) {
        printf("Failed to create hash table\n");
        return 1;
    }
    
    // Insert many key-value pairs to trigger resizing
    char key[20];
    for (int i = 0; i < 20; i++) {
        sprintf(key, "key%d", i);
        dynamic_hash_table_insert(table, key, i * 10);
        
        // Print status periodically
        if (i % 5 == 4) {
            printf("After inserting %d elements:\n", i + 1);
            print_dynamic_hash_table(table);
            printf("\n");
        }
    }
    
    // Search for some keys
    int value;
    if (dynamic_hash_table_search(table, "key5", &value)) {
        printf("Found 'key5': %d\n", value);
    }
    
    if (dynamic_hash_table_search(table, "key15", &value)) {
        printf("Found 'key15': %d\n", value);
    }
    
    // Delete some keys
    if (dynamic_hash_table_delete(table, "key10")) {
        printf("Deleted 'key10'\n");
    }
    
    printf("Final hash table:\n");
    print_dynamic_hash_table(table);
    
    free_dynamic_hash_table(table);
    return 0;
}
```

## Hash Table Performance Analysis

### Load Factor and Performance

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define TABLE_SIZE 1000

typedef struct PerfNode {
    int key;
    int value;
    struct PerfNode *next;
} PerfNode;

typedef struct {
    PerfNode *buckets[TABLE_SIZE];
    int size;
} PerfHashTable;

// Create performance hash table
PerfHashTable* create_perf_hash_table(void) {
    PerfHashTable *table = malloc(sizeof(PerfHashTable));
    if (table == NULL) return NULL;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    
    table->size = 0;
    return table;
}

// Free performance hash table
void free_perf_hash_table(PerfHashTable *table) {
    if (table == NULL) return;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        PerfNode *current = table->buckets[i];
        while (current != NULL) {
            PerfNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(table);
}

// Hash function
unsigned int perf_hash(int key) {
    return key % TABLE_SIZE;
}

// Insert with performance measurement
bool perf_hash_table_insert(PerfHashTable *table, int key, int value) {
    if (table == NULL) return false;
    
    unsigned int index = perf_hash(key);
    
    PerfNode *new_node = malloc(sizeof(PerfNode));
    if (new_node == NULL) return false;
    
    new_node->key = key;
    new_node->value = value;
    new_node->next = table->buckets[index];
    table->buckets[index] = new_node;
    table->size++;
    
    return true;
}

// Calculate average chain length
double calculate_average_chain_length(PerfHashTable *table) {
    if (table == NULL) return 0.0;
    
    int total_length = 0;
    int non_empty_buckets = 0;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        if (table->buckets[i] != NULL) {
            non_empty_buckets++;
            int length = 0;
            PerfNode *current = table->buckets[i];
            while (current != NULL) {
                length++;
                current = current->next;
            }
            total_length += length;
        }
    }
    
    return non_empty_buckets > 0 ? (double)total_length / non_empty_buckets : 0.0;
}

// Calculate load factor
double calculate_load_factor(PerfHashTable *table) {
    if (table == NULL) return 0.0;
    return (double)table->size / TABLE_SIZE;
}

// Find maximum chain length
int find_max_chain_length(PerfHashTable *table) {
    if (table == NULL) return 0;
    
    int max_length = 0;
    
    for (int i = 0; i < TABLE_SIZE; i++) {
        int length = 0;
        PerfNode *current = table->buckets[i];
        while (current != NULL) {
            length++;
            current = current->next;
        }
        if (length > max_length) {
            max_length = length;
        }
    }
    
    return max_length;
}

int main() {
    PerfHashTable *table = create_perf_hash_table();
    if (table == NULL) {
        printf("Failed to create hash table\n");
        return 1;
    }
    
    // Insert elements with different patterns
    printf("Performance Analysis of Hash Table:\n");
    printf("====================================\n\n");
    
    // Pattern 1: Sequential keys
    printf("Inserting 500 sequential keys (0-499):\n");
    clock_t start = clock();
    for (int i = 0; i < 500; i++) {
        perf_hash_table_insert(table, i, i * 2);
    }
    clock_t end = clock();
    
    printf("Time taken: %f seconds\n", ((double)(end - start)) / CLOCKS_PER_SEC);
    printf("Load factor: %.2f\n", calculate_load_factor(table));
    printf("Average chain length: %.2f\n", calculate_average_chain_length(table));
    printf("Maximum chain length: %d\n\n", find_max_chain_length(table));
    
    // Pattern 2: Random keys
    printf("Inserting 500 random keys:\n");
    srand(42);  // Fixed seed for reproducibility
    start = clock();
    for (int i = 0; i < 500; i++) {
        int random_key = rand() % 10000;
        perf_hash_table_insert(table, random_key, random_key * 2);
    }
    end = clock();
    
    printf("Time taken: %f seconds\n", ((double)(end - start)) / CLOCKS_PER_SEC);
    printf("Load factor: %.2f\n", calculate_load_factor(table));
    printf("Average chain length: %.2f\n", calculate_average_chain_length(table));
    printf("Maximum chain length: %d\n\n", find_max_chain_length(table));
    
    free_perf_hash_table(table);
    return 0;
}
```

## Practical Examples

### Symbol Table Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define SYMBOL_TABLE_SIZE 101

typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STRING,
    TYPE_FUNCTION
} SymbolType;

typedef struct Symbol {
    char name[100];
    SymbolType type;
    union {
        int int_val;
        float float_val;
        char *string_val;
        void (*func_ptr)(void);
    } value;
    struct Symbol *next;
} Symbol;

typedef struct {
    Symbol *buckets[SYMBOL_TABLE_SIZE];
} SymbolTable;

// Create symbol table
SymbolTable* create_symbol_table(void) {
    SymbolTable *table = malloc(sizeof(SymbolTable));
    if (table == NULL) return NULL;
    
    for (int i = 0; i < SYMBOL_TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    
    return table;
}

// Free symbol table
void free_symbol_table(SymbolTable *table) {
    if (table == NULL) return;
    
    for (int i = 0; i < SYMBOL_TABLE_SIZE; i++) {
        Symbol *current = table->buckets[i];
        while (current != NULL) {
            Symbol *next = current->next;
            if (current->type == TYPE_STRING) {
                free(current->value.string_val);
            }
            free(current);
            current = next;
        }
    }
    
    free(table);
}

// Hash function for symbol names
unsigned int symbol_hash(const char *name) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *name++)) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash % SYMBOL_TABLE_SIZE;
}

// Add integer symbol
bool add_integer_symbol(SymbolTable *table, const char *name, int value) {
    if (table == NULL || name == NULL) return false;
    
    unsigned int index = symbol_hash(name);
    
    Symbol *new_symbol = malloc(sizeof(Symbol));
    if (new_symbol == NULL) return false;
    
    strncpy(new_symbol->name, name, sizeof(new_symbol->name) - 1);
    new_symbol->name[sizeof(new_symbol->name) - 1] = '\0';
    new_symbol->type = TYPE_INT;
    new_symbol->value.int_val = value;
    new_symbol->next = table->buckets[index];
    table->buckets[index] = new_symbol;
    
    return true;
}

// Add float symbol
bool add_float_symbol(SymbolTable *table, const char *name, float value) {
    if (table == NULL || name == NULL) return false;
    
    unsigned int index = symbol_hash(name);
    
    Symbol *new_symbol = malloc(sizeof(Symbol));
    if (new_symbol == NULL) return false;
    
    strncpy(new_symbol->name, name, sizeof(new_symbol->name) - 1);
    new_symbol->name[sizeof(new_symbol->name) - 1] = '\0';
    new_symbol->type = TYPE_FLOAT;
    new_symbol->value.float_val = value;
    new_symbol->next = table->buckets[index];
    table->buckets[index] = new_symbol;
    
    return true;
}

// Add string symbol
bool add_string_symbol(SymbolTable *table, const char *name, const char *value) {
    if (table == NULL || name == NULL || value == NULL) return false;
    
    unsigned int index = symbol_hash(name);
    
    Symbol *new_symbol = malloc(sizeof(Symbol));
    if (new_symbol == NULL) return false;
    
    strncpy(new_symbol->name, name, sizeof(new_symbol->name) - 1);
    new_symbol->name[sizeof(new_symbol->name) - 1] = '\0';
    new_symbol->type = TYPE_STRING;
    new_symbol->value.string_val = malloc(strlen(value) + 1);
    if (new_symbol->value.string_val == NULL) {
        free(new_symbol);
        return false;
    }
    strcpy(new_symbol->value.string_val, value);
    new_symbol->next = table->buckets[index];
    table->buckets[index] = new_symbol;
    
    return true;
}

// Lookup symbol
Symbol* lookup_symbol(SymbolTable *table, const char *name) {
    if (table == NULL || name == NULL) return NULL;
    
    unsigned int index = symbol_hash(name);
    
    Symbol *current = table->buckets[index];
    while (current != NULL) {
        if (strcmp(current->name, name) == 0) {
            return current;
        }
        current = current->next;
    }
    
    return NULL;
}

// Print symbol table
void print_symbol_table(SymbolTable *table) {
    if (table == NULL) return;
    
    printf("Symbol Table:\n");
    printf("=============\n");
    
    for (int i = 0; i < SYMBOL_TABLE_SIZE; i++) {
        Symbol *current = table->buckets[i];
        while (current != NULL) {
            printf("Name: %-15s Type: ", current->name);
            
            switch (current->type) {
                case TYPE_INT:
                    printf("int     Value: %d\n", current->value.int_val);
                    break;
                case TYPE_FLOAT:
                    printf("float   Value: %.2f\n", current->value.float_val);
                    break;
                case TYPE_STRING:
                    printf("string  Value: %s\n", current->value.string_val);
                    break;
                case TYPE_FUNCTION:
                    printf("function\n");
                    break;
            }
            
            current = current->next;
        }
    }
}

int main() {
    SymbolTable *table = create_symbol_table();
    if (table == NULL) {
        printf("Failed to create symbol table\n");
        return 1;
    }
    
    // Add various symbols
    add_integer_symbol(table, "count", 42);
    add_integer_symbol(table, "max_size", 1000);
    add_float_symbol(table, "pi", 3.14159f);
    add_float_symbol(table, "e", 2.71828f);
    add_string_symbol(table, "name", "John Doe");
    add_string_symbol(table, "version", "1.0.0");
    
    printf("Symbol table contents:\n");
    print_symbol_table(table);
    
    // Lookup symbols
    printf("\nSymbol lookups:\n");
    printf("===============\n");
    
    Symbol *symbol = lookup_symbol(table, "count");
    if (symbol != NULL) {
        printf("Found 'count': %d\n", symbol->value.int_val);
    }
    
    symbol = lookup_symbol(table, "pi");
    if (symbol != NULL) {
        printf("Found 'pi': %.5f\n", symbol->value.float_val);
    }
    
    symbol = lookup_symbol(table, "name");
    if (symbol != NULL) {
        printf("Found 'name': %s\n", symbol->value.string_val);
    }
    
    symbol = lookup_symbol(table, "nonexistent");
    if (symbol != NULL) {
        printf("Found 'nonexistent'\n");
    } else {
        printf("'nonexistent' not found\n");
    }
    
    free_symbol_table(table);
    return 0;
}
```

### Cache Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#include <time.h>

#define CACHE_SIZE 16
#define MAX_KEY_LENGTH 100
#define MAX_VALUE_LENGTH 1000

typedef struct CacheNode {
    char key[MAX_KEY_LENGTH];
    char value[MAX_VALUE_LENGTH];
    time_t timestamp;
    int access_count;
    struct CacheNode *next;
} CacheNode;

typedef struct {
    CacheNode *buckets[CACHE_SIZE];
    int size;
    int max_size;
} LRUCache;

// Create LRU cache
LRUCache* create_lru_cache(int max_size) {
    LRUCache *cache = malloc(sizeof(LRUCache));
    if (cache == NULL) return NULL;
    
    for (int i = 0; i < CACHE_SIZE; i++) {
        cache->buckets[i] = NULL;
    }
    
    cache->size = 0;
    cache->max_size = max_size;
    return cache;
}

// Free LRU cache
void free_lru_cache(LRUCache *cache) {
    if (cache == NULL) return;
    
    for (int i = 0; i < CACHE_SIZE; i++) {
        CacheNode *current = cache->buckets[i];
        while (current != NULL) {
            CacheNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(cache);
}

// Hash function
unsigned int cache_hash(const char *key) {
    unsigned long hash = 5381;
    int c;
    
    while ((c = *key++)) {
        hash = ((hash << 5) + hash) + c;
    }
    
    return hash % CACHE_SIZE;
}

// Remove least recently used item
void remove_lru_item(LRUCache *cache) {
    if (cache == NULL || cache->size == 0) return;
    
    time_t oldest_time = time(NULL);
    CacheNode *oldest_node = NULL;
    int oldest_bucket = -1;
    CacheNode *oldest_prev = NULL;
    
    // Find the oldest accessed item
    for (int i = 0; i < CACHE_SIZE; i++) {
        CacheNode *current = cache->buckets[i];
        CacheNode *prev = NULL;
        
        while (current != NULL) {
            if (current->timestamp < oldest_time) {
                oldest_time = current->timestamp;
                oldest_node = current;
                oldest_bucket = i;
                oldest_prev = prev;
            }
            prev = current;
            current = current->next;
        }
    }
    
    // Remove the oldest item
    if (oldest_node != NULL) {
        if (oldest_prev == NULL) {
            cache->buckets[oldest_bucket] = oldest_node->next;
        } else {
            oldest_prev->next = oldest_node->next;
        }
        free(oldest_node);
        cache->size--;
    }
}

// Put item in cache
bool cache_put(LRUCache *cache, const char *key, const char *value) {
    if (cache == NULL || key == NULL || value == NULL) return false;
    
    // Check if key already exists
    unsigned int index = cache_hash(key);
    CacheNode *current = cache->buckets[index];
    CacheNode *prev = NULL;
    
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            // Update existing item
            strncpy(current->value, value, MAX_VALUE_LENGTH - 1);
            current->value[MAX_VALUE_LENGTH - 1] = '\0';
            current->timestamp = time(NULL);
            current->access_count++;
            return true;
        }
        prev = current;
        current = current->next;
    }
    
    // Check if cache is full
    if (cache->size >= cache->max_size) {
        remove_lru_item(cache);
    }
    
    // Create new cache node
    CacheNode *new_node = malloc(sizeof(CacheNode));
    if (new_node == NULL) return false;
    
    strncpy(new_node->key, key, MAX_KEY_LENGTH - 1);
    new_node->key[MAX_KEY_LENGTH - 1] = '\0';
    strncpy(new_node->value, value, MAX_VALUE_LENGTH - 1);
    new_node->value[MAX_VALUE_LENGTH - 1] = '\0';
    new_node->timestamp = time(NULL);
    new_node->access_count = 1;
    new_node->next = cache->buckets[index];
    cache->buckets[index] = new_node;
    cache->size++;
    
    return true;
}

// Get item from cache
bool cache_get(LRUCache *cache, const char *key, char *value, size_t value_size) {
    if (cache == NULL || key == NULL || value == NULL) return false;
    
    unsigned int index = cache_hash(key);
    CacheNode *current = cache->buckets[index];
    
    while (current != NULL) {
        if (strcmp(current->key, key) == 0) {
            // Found item, update timestamp and access count
            strncpy(value, current->value, value_size - 1);
            value[value_size - 1] = '\0';
            current->timestamp = time(NULL);
            current->access_count++;
            return true;
        }
        current = current->next;
    }
    
    return false;
}

// Print cache statistics
void print_cache_stats(LRUCache *cache) {
    if (cache == NULL) return;
    
    printf("Cache Statistics:\n");
    printf("  Size: %d/%d\n", cache->size, cache->max_size);
    printf("  Buckets:\n");
    
    for (int i = 0; i < CACHE_SIZE; i++) {
        CacheNode *current = cache->buckets[i];
        if (current != NULL) {
            printf("    Bucket %d:\n", i);
            while (current != NULL) {
                printf("      Key: %-15s Value: %-20s Accesses: %d\n", 
                       current->key, current->value, current->access_count);
                current = current->next;
            }
        }
    }
}

int main() {
    LRUCache *cache = create_lru_cache(5);
    if (cache == NULL) {
        printf("Failed to create cache\n");
        return 1;
    }
    
    // Add items to cache
    cache_put(cache, "user1", "John Doe");
    cache_put(cache, "user2", "Jane Smith");
    cache_put(cache, "config", "debug=true");
    cache_put(cache, "version", "1.2.3");
    cache_put(cache, "theme", "dark");
    
    printf("Initial cache state:\n");
    print_cache_stats(cache);
    
    // Access some items
    char value[100];
    if (cache_get(cache, "user1", value, sizeof(value))) {
        printf("\nRetrieved 'user1': %s\n", value);
    }
    
    if (cache_get(cache, "config", value, sizeof(value))) {
        printf("Retrieved 'config': %s\n", value);
    }
    
    // Add more items to trigger LRU eviction
    cache_put(cache, "new_item1", "value1");
    cache_put(cache, "new_item2", "value2");
    
    printf("\nCache after adding new items:\n");
    print_cache_stats(cache);
    
    // Try to access evicted item
    if (cache_get(cache, "user2", value, sizeof(value))) {
        printf("\nRetrieved 'user2': %s\n", value);
    } else {
        printf("\n'user2' was evicted from cache\n");
    }
    
    free_lru_cache(cache);
    return 0;
}
```

## Summary

Hash tables are powerful data structures that provide efficient key-value storage and retrieval:

1. **Hash Functions**: Critical for distributing keys uniformly across the table
2. **Collision Resolution**: 
   - Chaining: Store collided elements in linked lists
   - Open Addressing: Probe for alternative slots in the table
3. **Dynamic Resizing**: Maintain performance by resizing when load factor is too high
4. **Performance Characteristics**:
   - Average case: O(1) for insert, delete, and search
   - Worst case: O(n) when all keys collide
   - Space complexity: O(n)

Key considerations when implementing hash tables:
- **Hash Function Quality**: Should minimize collisions and distribute keys uniformly
- **Load Factor Management**: Resize when load factor exceeds threshold
- **Collision Resolution Strategy**: Choose based on use case and performance requirements
- **Memory Management**: Properly handle dynamic allocation and deallocation

Hash tables are widely used in:
- Database indexing
- Caching systems
- Symbol tables in compilers
- Sets and maps in programming languages
- Network routers and switches
- Cryptographic applications

Understanding hash table implementation and optimization techniques is essential for building high-performance applications that require fast data access.