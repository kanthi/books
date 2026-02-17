# Linear Data Structures

## Introduction

Linear data structures are fundamental building blocks in computer science that organize data elements in a sequential manner. These structures include dynamic arrays, linked lists, stacks, queues, and their variations. Understanding linear data structures is crucial for efficient programming, as they form the foundation for more complex data structures and algorithms.

In this chapter, we'll explore the implementation and usage of various linear data structures in C, focusing on dynamic memory management, performance characteristics, and practical applications.

## Dynamic Arrays (Vectors)

Dynamic arrays, also known as vectors, are resizable arrays that can grow or shrink during program execution. They provide the benefits of arrays (random access, cache locality) with the flexibility of dynamic sizing.

### Basic Dynamic Array Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int *data;
    size_t size;
    size_t capacity;
} DynamicArray;

// Initialize dynamic array
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

// Free dynamic array
void free_array(DynamicArray *arr) {
    if (arr != NULL) {
        free(arr->data);
        free(arr);
    }
}

// Add element to end of array
void push_back(DynamicArray *arr, int value) {
    if (arr->size >= arr->capacity) {
        // Double the capacity
        size_t new_capacity = arr->capacity * 2;
        int *new_data = realloc(arr->data, new_capacity * sizeof(int));
        if (new_data == NULL) return;  // Handle allocation failure
        
        arr->data = new_data;
        arr->capacity = new_capacity;
    }
    
    arr->data[arr->size] = value;
    arr->size++;
}

// Remove element from end of array
int pop_back(DynamicArray *arr) {
    if (arr->size == 0) return 0;  // Handle empty array
    
    arr->size--;
    return arr->data[arr->size];
}

// Access element at index
int at(DynamicArray *arr, size_t index) {
    if (index >= arr->size) return 0;  // Handle out of bounds
    return arr->data[index];
}

// Set element at index
void set(DynamicArray *arr, size_t index, int value) {
    if (index >= arr->size) return;  // Handle out of bounds
    arr->data[index] = value;
}

// Insert element at index
void insert(DynamicArray *arr, size_t index, int value) {
    if (index > arr->size) return;  // Handle invalid index
    
    if (arr->size >= arr->capacity) {
        size_t new_capacity = arr->capacity * 2;
        int *new_data = realloc(arr->data, new_capacity * sizeof(int));
        if (new_data == NULL) return;
        
        arr->data = new_data;
        arr->capacity = new_capacity;
    }
    
    // Shift elements to the right
    for (size_t i = arr->size; i > index; i--) {
        arr->data[i] = arr->data[i - 1];
    }
    
    arr->data[index] = value;
    arr->size++;
}

// Remove element at index
void erase(DynamicArray *arr, size_t index) {
    if (index >= arr->size) return;  // Handle invalid index
    
    // Shift elements to the left
    for (size_t i = index; i < arr->size - 1; i++) {
        arr->data[i] = arr->data[i + 1];
    }
    
    arr->size--;
}

// Print array contents
void print_array(DynamicArray *arr) {
    printf("Array (size=%zu, capacity=%zu): ", arr->size, arr->capacity);
    for (size_t i = 0; i < arr->size; i++) {
        printf("%d ", arr->data[i]);
    }
    printf("\n");
}

int main() {
    DynamicArray *arr = create_array(2);
    if (arr == NULL) {
        printf("Failed to create array\n");
        return 1;
    }
    
    // Test basic operations
    push_back(arr, 10);
    push_back(arr, 20);
    print_array(arr);
    
    push_back(arr, 30);  // This should trigger a resize
    print_array(arr);
    
    insert(arr, 1, 15);
    print_array(arr);
    
    set(arr, 0, 5);
    print_array(arr);
    
    printf("Element at index 2: %d\n", at(arr, 2));
    
    erase(arr, 1);
    print_array(arr);
    
    int popped = pop_back(arr);
    printf("Popped element: %d\n", popped);
    print_array(arr);
    
    free_array(arr);
    return 0;
}
```

### Generic Dynamic Array

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    void **data;
    size_t size;
    size_t capacity;
    size_t element_size;
} GenericArray;

// Create generic array
GenericArray* create_generic_array(size_t initial_capacity, size_t element_size) {
    GenericArray *arr = malloc(sizeof(GenericArray));
    if (arr == NULL) return NULL;
    
    arr->data = malloc(initial_capacity * sizeof(void*));
    if (arr->data == NULL) {
        free(arr);
        return NULL;
    }
    
    arr->size = 0;
    arr->capacity = initial_capacity;
    arr->element_size = element_size;
    return arr;
}

// Free generic array
void free_generic_array(GenericArray *arr) {
    if (arr != NULL) {
        for (size_t i = 0; i < arr->size; i++) {
            free(arr->data[i]);
        }
        free(arr->data);
        free(arr);
    }
}

// Add element to generic array
int push_generic(GenericArray *arr, const void *element) {
    if (arr->size >= arr->capacity) {
        size_t new_capacity = arr->capacity * 2;
        void **new_data = realloc(arr->data, new_capacity * sizeof(void*));
        if (new_data == NULL) return -1;
        
        arr->data = new_data;
        arr->capacity = new_capacity;
    }
    
    arr->data[arr->size] = malloc(arr->element_size);
    if (arr->data[arr->size] == NULL) return -1;
    
    memcpy(arr->data[arr->size], element, arr->element_size);
    arr->size++;
    return 0;
}

// Print generic array with custom print function
void print_generic_array(GenericArray *arr, void (*print_func)(const void*)) {
    printf("Generic Array (size=%zu, capacity=%zu): ", arr->size, arr->capacity);
    for (size_t i = 0; i < arr->size; i++) {
        print_func(arr->data[i]);
        printf(" ");
    }
    printf("\n");
}

// Example with strings
void print_string(const void *str) {
    printf("%s", (const char*)str);
}

int main() {
    // Create array of strings
    GenericArray *str_array = create_generic_array(2, sizeof(char*));
    if (str_array == NULL) {
        printf("Failed to create array\n");
        return 1;
    }
    
    const char *strings[] = {"Hello", "World", "Generic", "Array"};
    
    for (int i = 0; i < 4; i++) {
        push_generic(str_array, &strings[i]);
    }
    
    print_generic_array(str_array, print_string);
    
    free_generic_array(str_array);
    return 0;
}
```

## Linked Lists

Linked lists are linear data structures where elements are stored in nodes, and each node contains a reference to the next node in the sequence. They provide efficient insertion and deletion operations but have slower access times compared to arrays.

### Singly Linked List

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node *next;
} Node;

typedef struct {
    Node *head;
    size_t size;
} LinkedList;

// Create new node
Node* create_node(int data) {
    Node *node = malloc(sizeof(Node));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    return node;
}

// Initialize linked list
LinkedList* create_list(void) {
    LinkedList *list = malloc(sizeof(LinkedList));
    if (list == NULL) return NULL;
    
    list->head = NULL;
    list->size = 0;
    return list;
}

// Free linked list
void free_list(LinkedList *list) {
    if (list == NULL) return;
    
    Node *current = list->head;
    while (current != NULL) {
        Node *next = current->next;
        free(current);
        current = next;
    }
    
    free(list);
}

// Insert at beginning
void push_front(LinkedList *list, int data) {
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    new_node->next = list->head;
    list->head = new_node;
    list->size++;
}

// Insert at end
void push_back(LinkedList *list, int data) {
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    if (list->head == NULL) {
        list->head = new_node;
    } else {
        Node *current = list->head;
        while (current->next != NULL) {
            current = current->next;
        }
        current->next = new_node;
    }
    list->size++;
}

// Remove from beginning
int pop_front(LinkedList *list) {
    if (list->head == NULL) return 0;
    
    Node *temp = list->head;
    int data = temp->data;
    list->head = list->head->next;
    free(temp);
    list->size--;
    
    return data;
}

// Find element
Node* find(LinkedList *list, int data) {
    Node *current = list->head;
    while (current != NULL) {
        if (current->data == data) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Insert after node
void insert_after(Node *node, int data) {
    if (node == NULL) return;
    
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    new_node->next = node->next;
    node->next = new_node;
}

// Delete node with specific data
void delete_node(LinkedList *list, int data) {
    if (list->head == NULL) return;
    
    // If head node holds the data
    if (list->head->data == data) {
        Node *temp = list->head;
        list->head = list->head->next;
        free(temp);
        list->size--;
        return;
    }
    
    // Search for the node to delete
    Node *current = list->head;
    while (current->next != NULL && current->next->data != data) {
        current = current->next;
    }
    
    // If node was found
    if (current->next != NULL) {
        Node *temp = current->next;
        current->next = current->next->next;
        free(temp);
        list->size--;
    }
}

// Print list
void print_list(LinkedList *list) {
    printf("List (size=%zu): ", list->size);
    Node *current = list->head;
    while (current != NULL) {
        printf("%d -> ", current->data);
        current = current->next;
    }
    printf("NULL\n");
}

int main() {
    LinkedList *list = create_list();
    if (list == NULL) {
        printf("Failed to create list\n");
        return 1;
    }
    
    // Test operations
    push_back(list, 10);
    push_back(list, 20);
    push_front(list, 5);
    print_list(list);
    
    insert_after(list->head, 7);
    print_list(list);
    
    Node *found = find(list, 20);
    if (found != NULL) {
        printf("Found node with data: %d\n", found->data);
    }
    
    delete_node(list, 7);
    print_list(list);
    
    int popped = pop_front(list);
    printf("Popped element: %d\n", popped);
    print_list(list);
    
    free_list(list);
    return 0;
}
```

### Doubly Linked List

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct DNode {
    int data;
    struct DNode *next;
    struct DNode *prev;
} DNode;

typedef struct {
    DNode *head;
    DNode *tail;
    size_t size;
} DoublyLinkedList;

// Create new node
DNode* create_dnode(int data) {
    DNode *node = malloc(sizeof(DNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    node->prev = NULL;
    return node;
}

// Initialize doubly linked list
DoublyLinkedList* create_dlist(void) {
    DoublyLinkedList *list = malloc(sizeof(DoublyLinkedList));
    if (list == NULL) return NULL;
    
    list->head = NULL;
    list->tail = NULL;
    list->size = 0;
    return list;
}

// Free doubly linked list
void free_dlist(DoublyLinkedList *list) {
    if (list == NULL) return;
    
    DNode *current = list->head;
    while (current != NULL) {
        DNode *next = current->next;
        free(current);
        current = next;
    }
    
    free(list);
}

// Insert at beginning
void push_front_dlist(DoublyLinkedList *list, int data) {
    DNode *new_node = create_dnode(data);
    if (new_node == NULL) return;
    
    if (list->head == NULL) {
        list->head = list->tail = new_node;
    } else {
        new_node->next = list->head;
        list->head->prev = new_node;
        list->head = new_node;
    }
    list->size++;
}

// Insert at end
void push_back_dlist(DoublyLinkedList *list, int data) {
    DNode *new_node = create_dnode(data);
    if (new_node == NULL) return;
    
    if (list->tail == NULL) {
        list->head = list->tail = new_node;
    } else {
        new_node->prev = list->tail;
        list->tail->next = new_node;
        list->tail = new_node;
    }
    list->size++;
}

// Remove from beginning
int pop_front_dlist(DoublyLinkedList *list) {
    if (list->head == NULL) return 0;
    
    DNode *temp = list->head;
    int data = temp->data;
    
    if (list->head == list->tail) {
        list->head = list->tail = NULL;
    } else {
        list->head = list->head->next;
        list->head->prev = NULL;
    }
    
    free(temp);
    list->size--;
    return data;
}

// Remove from end
int pop_back_dlist(DoublyLinkedList *list) {
    if (list->tail == NULL) return 0;
    
    DNode *temp = list->tail;
    int data = temp->data;
    
    if (list->head == list->tail) {
        list->head = list->tail = NULL;
    } else {
        list->tail = list->tail->prev;
        list->tail->next = NULL;
    }
    
    free(temp);
    list->size--;
    return data;
}

// Print list forward
void print_dlist_forward(DoublyLinkedList *list) {
    printf("Forward: ");
    DNode *current = list->head;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

// Print list backward
void print_dlist_backward(DoublyLinkedList *list) {
    printf("Backward: ");
    DNode *current = list->tail;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->prev;
    }
    printf("\n");
}

int main() {
    DoublyLinkedList *list = create_dlist();
    if (list == NULL) {
        printf("Failed to create list\n");
        return 1;
    }
    
    // Test operations
    push_back_dlist(list, 10);
    push_back_dlist(list, 20);
    push_front_dlist(list, 5);
    push_back_dlist(list, 30);
    
    print_dlist_forward(list);
    print_dlist_backward(list);
    
    int front = pop_front_dlist(list);
    printf("Popped from front: %d\n", front);
    
    int back = pop_back_dlist(list);
    printf("Popped from back: %d\n", back);
    
    print_dlist_forward(list);
    
    free_dlist(list);
    return 0;
}
```

## Stacks

A stack is a Last-In-First-Out (LIFO) data structure where elements are added and removed from the same end, called the top.

### Array-based Stack

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define STACK_SIZE 100

typedef struct {
    int data[STACK_SIZE];
    int top;
} ArrayStack;

// Initialize stack
void init_array_stack(ArrayStack *stack) {
    stack->top = -1;
}

// Check if stack is empty
bool is_empty_array(ArrayStack *stack) {
    return stack->top == -1;
}

// Check if stack is full
bool is_full_array(ArrayStack *stack) {
    return stack->top == STACK_SIZE - 1;
}

// Push element onto stack
bool push_array(ArrayStack *stack, int value) {
    if (is_full_array(stack)) {
        return false;  // Stack overflow
    }
    
    stack->data[++stack->top] = value;
    return true;
}

// Pop element from stack
int pop_array(ArrayStack *stack) {
    if (is_empty_array(stack)) {
        return 0;  // Stack underflow
    }
    
    return stack->data[stack->top--];
}

// Peek at top element
int peek_array(ArrayStack *stack) {
    if (is_empty_array(stack)) {
        return 0;  // Stack is empty
    }
    
    return stack->data[stack->top];
}

// Print stack contents
void print_array_stack(ArrayStack *stack) {
    if (is_empty_array(stack)) {
        printf("Stack is empty\n");
        return;
    }
    
    printf("Stack (top to bottom): ");
    for (int i = stack->top; i >= 0; i--) {
        printf("%d ", stack->data[i]);
    }
    printf("\n");
}

int main() {
    ArrayStack stack;
    init_array_stack(&stack);
    
    // Test stack operations
    push_array(&stack, 10);
    push_array(&stack, 20);
    push_array(&stack, 30);
    
    print_array_stack(&stack);
    
    printf("Top element: %d\n", peek_array(&stack));
    
    int popped = pop_array(&stack);
    printf("Popped element: %d\n", popped);
    
    print_array_stack(&stack);
    
    return 0;
}
```

### Linked List-based Stack

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct StackNode {
    int data;
    struct StackNode *next;
} StackNode;

typedef struct {
    StackNode *top;
    size_t size;
} LinkedStack;

// Create new stack node
StackNode* create_stack_node(int data) {
    StackNode *node = malloc(sizeof(StackNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    return node;
}

// Initialize stack
LinkedStack* create_linked_stack(void) {
    LinkedStack *stack = malloc(sizeof(LinkedStack));
    if (stack == NULL) return NULL;
    
    stack->top = NULL;
    stack->size = 0;
    return stack;
}

// Free stack
void free_linked_stack(LinkedStack *stack) {
    if (stack == NULL) return;
    
    StackNode *current = stack->top;
    while (current != NULL) {
        StackNode *next = current->next;
        free(current);
        current = next;
    }
    
    free(stack);
}

// Check if stack is empty
bool is_empty_linked(LinkedStack *stack) {
    return stack->top == NULL;
}

// Push element onto stack
bool push_linked(LinkedStack *stack, int value) {
    StackNode *new_node = create_stack_node(value);
    if (new_node == NULL) return false;
    
    new_node->next = stack->top;
    stack->top = new_node;
    stack->size++;
    
    return true;
}

// Pop element from stack
int pop_linked(LinkedStack *stack) {
    if (is_empty_linked(stack)) {
        return 0;  // Stack underflow
    }
    
    StackNode *temp = stack->top;
    int data = temp->data;
    stack->top = stack->top->next;
    free(temp);
    stack->size--;
    
    return data;
}

// Peek at top element
int peek_linked(LinkedStack *stack) {
    if (is_empty_linked(stack)) {
        return 0;  // Stack is empty
    }
    
    return stack->top->data;
}

// Print stack contents
void print_linked_stack(LinkedStack *stack) {
    if (is_empty_linked(stack)) {
        printf("Stack is empty\n");
        return;
    }
    
    printf("Stack (top to bottom): ");
    StackNode *current = stack->top;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

int main() {
    LinkedStack *stack = create_linked_stack();
    if (stack == NULL) {
        printf("Failed to create stack\n");
        return 1;
    }
    
    // Test stack operations
    push_linked(stack, 10);
    push_linked(stack, 20);
    push_linked(stack, 30);
    
    print_linked_stack(stack);
    
    printf("Top element: %d\n", peek_linked(stack));
    
    int popped = pop_linked(stack);
    printf("Popped element: %d\n", popped);
    
    print_linked_stack(stack);
    
    free_linked_stack(stack);
    return 0;
}
```

## Queues

A queue is a First-In-First-Out (FIFO) data structure where elements are added at the rear and removed from the front.

### Circular Buffer Queue

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define QUEUE_SIZE 100

typedef struct {
    int data[QUEUE_SIZE];
    int front;
    int rear;
    int size;
} CircularQueue;

// Initialize queue
void init_circular_queue(CircularQueue *queue) {
    queue->front = 0;
    queue->rear = -1;
    queue->size = 0;
}

// Check if queue is empty
bool is_empty_queue(CircularQueue *queue) {
    return queue->size == 0;
}

// Check if queue is full
bool is_full_queue(CircularQueue *queue) {
    return queue->size == QUEUE_SIZE;
}

// Enqueue (add) element to queue
bool enqueue(CircularQueue *queue, int value) {
    if (is_full_queue(queue)) {
        return false;  // Queue overflow
    }
    
    queue->rear = (queue->rear + 1) % QUEUE_SIZE;
    queue->data[queue->rear] = value;
    queue->size++;
    
    return true;
}

// Dequeue (remove) element from queue
int dequeue(CircularQueue *queue) {
    if (is_empty_queue(queue)) {
        return 0;  // Queue underflow
    }
    
    int data = queue->data[queue->front];
    queue->front = (queue->front + 1) % QUEUE_SIZE;
    queue->size--;
    
    return data;
}

// Peek at front element
int front_queue(CircularQueue *queue) {
    if (is_empty_queue(queue)) {
        return 0;  // Queue is empty
    }
    
    return queue->data[queue->front];
}

// Print queue contents
void print_queue(CircularQueue *queue) {
    if (is_empty_queue(queue)) {
        printf("Queue is empty\n");
        return;
    }
    
    printf("Queue (front to rear): ");
    int index = queue->front;
    for (int i = 0; i < queue->size; i++) {
        printf("%d ", queue->data[index]);
        index = (index + 1) % QUEUE_SIZE;
    }
    printf("\n");
}

int main() {
    CircularQueue queue;
    init_circular_queue(&queue);
    
    // Test queue operations
    enqueue(&queue, 10);
    enqueue(&queue, 20);
    enqueue(&queue, 30);
    
    print_queue(&queue);
    
    printf("Front element: %d\n", front_queue(&queue));
    
    int dequeued = dequeue(&queue);
    printf("Dequeued element: %d\n", dequeued);
    
    print_queue(&queue);
    
    return 0;
}
```

### Linked List-based Queue

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct QueueNode {
    int data;
    struct QueueNode *next;
} QueueNode;

typedef struct {
    QueueNode *front;
    QueueNode *rear;
    size_t size;
} LinkedQueue;

// Create new queue node
QueueNode* create_queue_node(int data) {
    QueueNode *node = malloc(sizeof(QueueNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    return node;
}

// Initialize queue
LinkedQueue* create_linked_queue(void) {
    LinkedQueue *queue = malloc(sizeof(LinkedQueue));
    if (queue == NULL) return NULL;
    
    queue->front = NULL;
    queue->rear = NULL;
    queue->size = 0;
    return queue;
}

// Free queue
void free_linked_queue(LinkedQueue *queue) {
    if (queue == NULL) return;
    
    QueueNode *current = queue->front;
    while (current != NULL) {
        QueueNode *next = current->next;
        free(current);
        current = next;
    }
    
    free(queue);
}

// Check if queue is empty
bool is_empty_linked_queue(LinkedQueue *queue) {
    return queue->front == NULL;
}

// Enqueue (add) element to queue
bool enqueue_linked(LinkedQueue *queue, int value) {
    QueueNode *new_node = create_queue_node(value);
    if (new_node == NULL) return false;
    
    if (is_empty_linked_queue(queue)) {
        queue->front = queue->rear = new_node;
    } else {
        queue->rear->next = new_node;
        queue->rear = new_node;
    }
    
    queue->size++;
    return true;
}

// Dequeue (remove) element from queue
int dequeue_linked(LinkedQueue *queue) {
    if (is_empty_linked_queue(queue)) {
        return 0;  // Queue underflow
    }
    
    QueueNode *temp = queue->front;
    int data = temp->data;
    
    queue->front = queue->front->next;
    if (queue->front == NULL) {
        queue->rear = NULL;  // Queue is now empty
    }
    
    free(temp);
    queue->size--;
    
    return data;
}

// Peek at front element
int front_linked_queue(LinkedQueue *queue) {
    if (is_empty_linked_queue(queue)) {
        return 0;  // Queue is empty
    }
    
    return queue->front->data;
}

// Print queue contents
void print_linked_queue(LinkedQueue *queue) {
    if (is_empty_linked_queue(queue)) {
        printf("Queue is empty\n");
        return;
    }
    
    printf("Queue (front to rear): ");
    QueueNode *current = queue->front;
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

int main() {
    LinkedQueue *queue = create_linked_queue();
    if (queue == NULL) {
        printf("Failed to create queue\n");
        return 1;
    }
    
    // Test queue operations
    enqueue_linked(queue, 10);
    enqueue_linked(queue, 20);
    enqueue_linked(queue, 30);
    
    print_linked_queue(queue);
    
    printf("Front element: %d\n", front_linked_queue(queue));
    
    int dequeued = dequeue_linked(queue);
    printf("Dequeued element: %d\n", dequeued);
    
    print_linked_queue(queue);
    
    free_linked_queue(queue);
    return 0;
}
```

## Practical Examples

### Expression Evaluation Using Stacks

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <ctype.h>

#define STACK_SIZE 100

typedef struct {
    int data[STACK_SIZE];
    int top;
} Stack;

void init_stack(Stack *stack) {
    stack->top = -1;
}

bool is_empty(Stack *stack) {
    return stack->top == -1;
}

bool is_full(Stack *stack) {
    return stack->top == STACK_SIZE - 1;
}

bool push(Stack *stack, int value) {
    if (is_full(stack)) return false;
    stack->data[++stack->top] = value;
    return true;
}

int pop(Stack *stack) {
    if (is_empty(stack)) return 0;
    return stack->data[stack->top--];
}

int peek(Stack *stack) {
    if (is_empty(stack)) return 0;
    return stack->data[stack->top];
}

// Check if character is operator
bool is_operator(char c) {
    return (c == '+' || c == '-' || c == '*' || c == '/');
}

// Get precedence of operator
int precedence(char op) {
    switch (op) {
        case '+':
        case '-':
            return 1;
        case '*':
        case '/':
            return 2;
        default:
            return 0;
    }
}

// Convert infix to postfix
void infix_to_postfix(const char *infix, char *postfix) {
    Stack stack;
    init_stack(&stack);
    
    int i, j = 0;
    for (i = 0; infix[i] != '\0'; i++) {
        char c = infix[i];
        
        if (isdigit(c)) {
            postfix[j++] = c;
        } else if (c == '(') {
            push(&stack, c);
        } else if (c == ')') {
            while (!is_empty(&stack) && peek(&stack) != '(') {
                postfix[j++] = pop(&stack);
            }
            pop(&stack);  // Pop '('
        } else if (is_operator(c)) {
            while (!is_empty(&stack) && precedence(peek(&stack)) >= precedence(c)) {
                postfix[j++] = pop(&stack);
            }
            push(&stack, c);
        }
    }
    
    while (!is_empty(&stack)) {
        postfix[j++] = pop(&stack);
    }
    
    postfix[j] = '\0';
}

// Evaluate postfix expression
int evaluate_postfix(const char *postfix) {
    Stack stack;
    init_stack(&stack);
    
    for (int i = 0; postfix[i] != '\0'; i++) {
        char c = postfix[i];
        
        if (isdigit(c)) {
            push(&stack, c - '0');
        } else if (is_operator(c)) {
            int b = pop(&stack);
            int a = pop(&stack);
            
            switch (c) {
                case '+':
                    push(&stack, a + b);
                    break;
                case '-':
                    push(&stack, a - b);
                    break;
                case '*':
                    push(&stack, a * b);
                    break;
                case '/':
                    push(&stack, a / b);
                    break;
            }
        }
    }
    
    return pop(&stack);
}

int main() {
    char infix[] = "3+4*2/(1-5)";
    char postfix[100];
    
    printf("Infix expression: %s\n", infix);
    
    infix_to_postfix(infix, postfix);
    printf("Postfix expression: %s\n", postfix);
    
    int result = evaluate_postfix(postfix);
    printf("Result: %d\n", result);
    
    return 0;
}
```

## Summary

Linear data structures are fundamental to computer science and programming:

1. **Dynamic Arrays**: Provide random access with dynamic resizing capabilities
2. **Linked Lists**: Offer efficient insertion/deletion with sequential access
3. **Stacks**: Implement LIFO behavior for expression evaluation and backtracking
4. **Queues**: Implement FIFO behavior for scheduling and breadth-first processing

Each structure has its own trade-offs in terms of memory usage, access patterns, and performance characteristics. Understanding these trade-offs is crucial for selecting the appropriate data structure for specific applications.

Key considerations when choosing linear data structures:
- **Access Pattern**: Random vs. sequential access
- **Insertion/Deletion Frequency**: At ends vs. middle
- **Memory Constraints**: Fixed vs. dynamic allocation
- **Performance Requirements**: Time complexity for operations
- **Implementation Complexity**: Simple vs. complex structures

Mastering linear data structures provides a solid foundation for understanding more complex data structures and algorithms.