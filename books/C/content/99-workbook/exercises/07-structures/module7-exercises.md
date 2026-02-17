# Module 7: Structures, Unions, and Enums Exercises

## Exercise 1: Basic Structure Implementation
Write a program that defines and uses various structures:
- Define a structure to represent a date (day, month, year)
- Define a structure to represent a person (name, age, date of birth)
- Define a structure to represent a book (title, author, ISBN, price)
- Create functions to initialize and print these structures
- Demonstrate structure assignment and comparison

**Requirements:**
- Use proper structure definitions with appropriate data types
- Implement initialization functions for each structure
- Create print functions that display structure contents
- Handle string copying safely to prevent buffer overflows
- Include examples of nested structures

## Exercise 2: Array of Structures
Create a program that manages collections using arrays of structures:
- Implement a student database using an array of student structures
- Create functions to add, search, and remove students
- Implement sorting functions for the student array
- Add functionality to calculate class averages and statistics
- Include file I/O to save and load student data

**Requirements:**
- Use dynamic memory allocation for flexible array sizing
- Implement proper error handling for array bounds
- Include search functions with different criteria
- Handle memory management properly to prevent leaks
- Provide clear user interface for database operations

## Exercise 3: Linked List Implementation
Develop a program that implements a complete linked list:
- Define a node structure for the linked list
- Implement functions to insert, delete, and search nodes
- Create functions to traverse and display the list
- Implement sorting and merging of linked lists
- Include memory management for all list operations

**Requirements:**
- Handle edge cases (empty list, single node, etc.)
- Implement proper memory allocation and deallocation
- Include error checking for all operations
- Provide both iterative and recursive implementations (bonus)
- Document time and space complexity of operations

## Exercise 4: Unions and Bit Fields
Write a program that demonstrates advanced data types:
- Define and use unions for memory-efficient data storage
- Implement structures with bit fields for flags and settings
- Create a program that uses unions for type-generic operations
- Demonstrate memory layout differences between structures and unions
- Implement a simple variant type using unions

**Requirements:**
- Include proper documentation for union usage
- Handle type safety when working with unions
- Demonstrate bit field packing and alignment
- Include examples of practical union applications
- Provide clear explanations of memory usage differences

## Exercise 5: Enumerations and Type Definitions
Create a program that uses enumerations effectively:
- Define enumerations for different categories (status, types, etc.)
- Use typedef to create aliases for complex structure types
- Implement state machines using enumerations
- Create lookup tables using enumerations as indices
- Demonstrate enum-to-string conversion functions

**Requirements:**
- Use meaningful names for enumeration constants
- Include bounds checking for enumeration values
- Implement proper error handling for invalid enum values
- Provide examples of enum-based switch statements
- Document the advantages of using enumerations

## Exercise 6: Advanced Structure Techniques
Write a program that implements advanced structure concepts:
- Create structures with flexible array members (C99)
- Implement opaque pointer design pattern
- Demonstrate structure packing and alignment
- Create self-referential structures for trees and graphs
- Implement structure serialization and deserialization

**Requirements:**
- Handle flexible array members correctly with dynamic allocation
- Include proper memory management for opaque structures
- Demonstrate compiler-specific packing directives
- Implement proper traversal algorithms for tree structures
- Include error checking for serialization operations

## Exercise 7: Structure Memory Management
Create a program that demonstrates safe structure handling:
- Implement a memory pool for structure allocation
- Create functions to track structure usage and leaks
- Demonstrate proper deep copying of structures
- Implement reference counting for shared structures
- Include debugging features for structure validation

**Requirements:**
- Include comprehensive error checking
- Handle all memory allocation failures gracefully
- Provide clear documentation for memory management functions
- Implement proper cleanup procedures
- Include performance measurements for different approaches

## Exercise 8: Comprehensive Structure Application
Design a complete application that integrates all structure concepts:
- Implement a complete data management system
- Create a configuration system using nested structures
- Develop a plugin architecture using function pointers in structures
- Implement a serialization system for data persistence
- Include comprehensive error handling and resource management

**Requirements:**
- Use modular design with clear separation of concerns
- Include proper documentation for all components
- Handle all memory allocation and deallocation properly
- Implement robust error handling throughout
- Provide clear examples and test cases

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <string.h>

// Structure definitions
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char name[50];
    int age;
    Date birth_date;
} Person;

typedef struct {
    char title[100];
    char author[50];
    char isbn[20];
    double price;
} Book;

// Function to initialize a date
Date create_date(int day, int month, int year) {
    Date d = {day, month, year};
    return d;
}

// Function to print a date
void print_date(const Date *d) {
    if (d == NULL) return;
    printf("%02d/%02d/%04d", d->day, d->month, d->year);
}

// Function to initialize a person
Person create_person(const char *name, int age, Date birth_date) {
    Person p;
    strncpy(p.name, name, sizeof(p.name) - 1);
    p.name[sizeof(p.name) - 1] = '\0';
    p.age = age;
    p.birth_date = birth_date;
    return p;
}

// Function to print a person
void print_person(const Person *p) {
    if (p == NULL) return;
    printf("Name: %s\n", p->name);
    printf("Age: %d\n", p->age);
    printf("Birth Date: ");
    print_date(&p->birth_date);
    printf("\n");
}

int main() {
    Date birth = create_date(15, 6, 1990);
    Person person = create_person("John Doe", 33, birth);
    
    printf("Person Information:\n");
    print_person(&person);
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Node structure for linked list
typedef struct Node {
    int data;
    struct Node *next;
} Node;

// Function to create a new node
Node* create_node(int data) {
    Node *new_node = malloc(sizeof(Node));
    if (new_node == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}

// Function to insert at beginning of list
void insert_at_beginning(Node **head, int data) {
    if (head == NULL) return;
    
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    new_node->next = *head;
    *head = new_node;
}

// Function to print the list
void print_list(Node *head) {
    printf("List: ");
    Node *current = head;
    
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

// Function to free the entire list
void free_list(Node *head) {
    Node *current = head;
    Node *next;
    
    while (current != NULL) {
        next = current->next;
        free(current);
        current = next;
    }
}

int main() {
    Node *head = NULL;
    
    // Insert elements
    insert_at_beginning(&head, 10);
    insert_at_beginning(&head, 20);
    insert_at_beginning(&head, 30);
    
    printf("Linked list after insertions:\n");
    print_list(head);
    
    // Free memory
    free_list(head);
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Shallow copying**: Always implement deep copy for structures with pointers
2. **Memory leaks**: Free all allocated memory in structures properly
3. **Buffer overflows**: Check string lengths when copying to fixed-size arrays
4. **Uninitialized structures**: Initialize all structure members properly
5. **Flexible array misuse**: Handle flexible array members with dynamic allocation

### Best Practices:
1. **Consistent naming**: Use clear, consistent names for structures and members
2. **Documentation**: Comment structure purposes and member meanings
3. **Encapsulation**: Hide implementation details using opaque pointers when appropriate
4. **Error handling**: Check all memory allocations and pointer operations
5. **Memory management**: Follow consistent patterns for allocation and deallocation

Complete these exercises to solidify your understanding of structures, unions, and enums in C. Each exercise builds upon the previous ones, gradually increasing in complexity.