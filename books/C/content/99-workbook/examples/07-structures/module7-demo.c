/*
 * Module 7 Demonstration Program
 * This program demonstrates all the key concepts from Module 7:
 * - Structure fundamentals (definition, initialization, member access)
 * - Unions and enumerations
 * - Advanced structure concepts (nested structures, arrays of structures)
 * - Abstract data types (linked lists, stacks, queues)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include our custom header files
#include "struct_utils.h"

// Function prototypes for demonstration functions
void demonstrate_structures(void);
void demonstrate_unions_enums(void);
void demonstrate_advanced_structures(void);
void demonstrate_abstract_data_types(void);

// Enumerations
typedef enum {
    RED, GREEN, BLUE, YELLOW, PURPLE
} Color;

typedef enum {
    SUCCESS, FAILURE, WARNING
} Status;

// Unions
typedef union {
    int intValue;
    float floatValue;
    char stringValue[20];
} Data;

// Advanced structures
typedef struct {
    Person person;
    Book favoriteBook;
} LibraryMember;

typedef struct {
    int x, y;
} Point;

typedef struct {
    Point topLeft;
    Point bottomRight;
} Rectangle;

// Function to calculate area of rectangle
int rectangle_area(Rectangle *rect) {
    if (rect == NULL) return 0;
    int width = rect->bottomRight.x - rect->topLeft.x;
    int height = rect->bottomRight.y - rect->topLeft.y;
    return width * height;
}

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 7: Structures, Unions, and Enums Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_structures();
    demonstrate_unions_enums();
    demonstrate_advanced_structures();
    demonstrate_abstract_data_types();
    
    printf("\n========================================\n");
    printf("  Module 7 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate structure fundamentals
 */
void demonstrate_structures() {
    print_separator("Structure Fundamentals");
    
    // Create and initialize structures
    Date birthDate = create_date(15, 6, 1990);
    Person person = create_person("John", "Doe", 33, birthDate);
    
    printf("Person information:\n");
    print_person(&person);
    
    // Direct structure initialization
    Book book = {1001, "The C Programming Language", "Kernighan & Ritchie", 1978, 29.99};
    
    printf("\nBook information:\n");
    print_book(&book);
    
    // Structure assignment
    Book anotherBook = book;
    anotherBook.id = 1002;
    strncpy(anotherBook.title, "C Programming: A Modern Approach", sizeof(anotherBook.title) - 1);
    anotherBook.title[sizeof(anotherBook.title) - 1] = '\0';
    
    printf("\nCopied and modified book:\n");
    print_book(&anotherBook);
    
    // Array of structures
    print_separator("Array of Structures");
    Book library[] = {
        {1, "The C Programming Language", "Kernighan & Ritchie", 1978, 29.99},
        {2, "C Programming: A Modern Approach", "K. N. King", 2008, 39.99},
        {3, "Expert C Programming", "Peter van der Linden", 1994, 34.99}
    };
    
    int librarySize = sizeof(library) / sizeof(library[0]);
    printf("Library catalog:\n");
    for (int i = 0; i < librarySize; i++) {
        printf("\nBook %d:\n", i + 1);
        print_book(&library[i]);
    }
}

/*
 * Demonstrate unions and enumerations
 */
void demonstrate_unions_enums() {
    print_separator("Unions and Enumerations");
    
    // Enumerations
    Color favoriteColor = BLUE;
    printf("Favorite color: ");
    switch (favoriteColor) {
        case RED: printf("Red\n"); break;
        case GREEN: printf("Green\n"); break;
        case BLUE: printf("Blue\n"); break;
        case YELLOW: printf("Yellow\n"); break;
        case PURPLE: printf("Purple\n"); break;
        default: printf("Unknown\n"); break;
    }
    
    Status operationStatus = SUCCESS;
    printf("Operation status: ");
    switch (operationStatus) {
        case SUCCESS: printf("Success\n"); break;
        case FAILURE: printf("Failure\n"); break;
        case WARNING: printf("Warning\n"); break;
    }
    
    // Unions
    Data data;
    
    // Using integer value
    data.intValue = 42;
    printf("\nUnion with integer: %d\n", data.intValue);
    
    // Using float value (overwrites integer)
    data.floatValue = 3.14f;
    printf("Union with float: %.2f\n", data.floatValue);
    
    // Using string value (overwrites float)
    strncpy(data.stringValue, "Hello", sizeof(data.stringValue) - 1);
    data.stringValue[sizeof(data.stringValue) - 1] = '\0';
    printf("Union with string: %s\n", data.stringValue);
    
    printf("Note: Only the last assigned value is meaningful in a union\n");
}

/*
 * Demonstrate advanced structure concepts
 */
void demonstrate_advanced_structures() {
    print_separator("Advanced Structure Concepts");
    
    // Nested structures
    Date birthDate = create_date(20, 3, 1985);
    Person person = create_person("Alice", "Smith", 38, birthDate);
    Book book = {2001, "C Programming Absolute Beginner's Guide", "Greg Perry", 2013, 24.99};
    
    LibraryMember member = {person, book};
    
    printf("Library member information:\n");
    printf("Name: %s %s\n", member.person.firstName, member.person.lastName);
    printf("Favorite book: %s by %s\n", member.favoriteBook.title, member.favoriteBook.author);
    
    // Bit fields
    print_separator("Bit Fields");
    typedef struct {
        unsigned int flag1 : 1;  // 1 bit
        unsigned int flag2 : 1;  // 1 bit
        unsigned int type : 4;   // 4 bits
        unsigned int value : 8;  // 8 bits
    }BitFields;
    
   BitFields bf = {1, 0, 5, 127};
    printf("Bit field values:\n");
    printf("  flag1: %u\n", bf.flag1);
    printf("  flag2: %u\n", bf.flag2);
    printf("  type: %u\n", bf.type);
    printf("  value: %u\n", bf.value);
    
    // Flexible array members (C99 feature)
    print_separator("Flexible Array Members");
    typedef struct {
        int count;
        double data[]; // Flexible array member (must be last)
    } FlexibleArray;
    
    // Note: Flexible array members require dynamic allocation
    size_t size = sizeof(FlexibleArray) + 5 * sizeof(double);
    FlexibleArray *fa = (FlexibleArray*)malloc(size);
    if (fa != NULL) {
        fa->count = 5;
        for (int i = 0; i < fa->count; i++) {
            fa->data[i] = i * 1.5;
        }
        
        printf("Flexible array with %d elements:\n", fa->count);
        for (int i = 0; i < fa->count; i++) {
            printf("  data[%d] = %.1f\n", i, fa->data[i]);
        }
        
        free(fa);
    }
}

/*
 * Demonstrate abstract data types
 */
void demonstrate_abstract_data_types() {
    print_separator("Abstract Data Types");
    
    // Linked list demonstration
    Node *head = NULL;
    
    // Insert elements
    insert_at_beginning(&head, 10);
    insert_at_beginning(&head, 20);
    insert_at_beginning(&head, 30);
    
    printf("Linked list after insertions:\n");
    print_list(head);
    
    // Insert more elements
    insert_at_beginning(&head, 40);
    insert_at_beginning(&head, 50);
    
    printf("Linked list after more insertions:\n");
    print_list(head);
    
    // Free the list
    free_list(head);
    head = NULL;
    
    printf("Linked list freed\n");
    
    // Stack implementation using array
    print_separator("Stack Implementation");
    #define STACK_SIZE 10
    typedef struct {
        int data[STACK_SIZE];
        int top;
    } Stack;
    
    Stack stack = {{0}, -1}; // Initialize top to -1
    
    // Push function
    void push(Stack *s, int value) {
        if (s->top < STACK_SIZE - 1) {
            s->data[++s->top] = value;
            printf("Pushed %d onto stack\n", value);
        } else {
            printf("Stack overflow!\n");
        }
    }
    
    // Pop function
    int pop(Stack *s) {
        if (s->top >= 0) {
            return s->data[s->top--];
        } else {
            printf("Stack underflow!\n");
            return -1;
        }
    }
    
    // Demonstrate stack operations
    push(&stack, 100);
    push(&stack, 200);
    push(&stack, 300);
    
    printf("Popped: %d\n", pop(&stack));
    printf("Popped: %d\n", pop(&stack));
    printf("Popped: %d\n", pop(&stack));
    printf("Popped: %d\n", pop(&stack)); // Should show underflow
    
    // Queue implementation using array
    print_separator("Queue Implementation");
    #define QUEUE_SIZE 10
    typedef struct {
        int data[QUEUE_SIZE];
        int front, rear;
    } Queue;
    
    Queue queue = {{0}, 0, -1}; // Initialize front to 0, rear to -1
    
    // Enqueue function
    void enqueue(Queue *q, int value) {
        if (q->rear < QUEUE_SIZE - 1) {
            q->data[++q->rear] = value;
            printf("Enqueued %d to queue\n", value);
        } else {
            printf("Queue overflow!\n");
        }
    }
    
    // Dequeue function
    int dequeue(Queue *q) {
        if (q->front <= q->rear) {
            return q->data[q->front++];
        } else {
            printf("Queue underflow!\n");
            return -1;
        }
    }
    
    // Demonstrate queue operations
    enqueue(&queue, 1000);
    enqueue(&queue, 2000);
    enqueue(&queue, 3000);
    
    printf("Dequeued: %d\n", dequeue(&queue));
    printf("Dequeued: %d\n", dequeue(&queue));
    printf("Dequeued: %d\n", dequeue(&queue));
    printf("Dequeued: %d\n", dequeue(&queue)); // Should show underflow
}