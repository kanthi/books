# Module 10: Data Structures Exercises

## Exercise 1: Linear Data Structures Implementation
Write a program that implements fundamental linear data structures:
- Implement a complete stack with push, pop, and peek operations
- Create a queue with enqueue and dequeue functions
- Develop a deque (double-ended queue) with operations on both ends
- Implement a circular buffer for efficient memory usage
- Include comprehensive error handling and boundary checks

**Requirements:**
- Use dynamic memory allocation for flexible sizing
- Include proper initialization and cleanup functions
- Implement comprehensive error checking
- Provide performance analysis for operations
- Include examples of practical applications

## Exercise 2: Linked List Variations
Create a program that implements various linked list types:
- Singly linked list with insert, delete, and search operations
- Doubly linked list with forward and backward traversal
- Circular linked list with proper termination handling
- Implement sorted insertion and merge operations
- Include memory management and leak prevention

**Requirements:**
- Handle all edge cases (empty list, single node, etc.)
- Implement both iterative and recursive algorithms
- Include performance comparisons between list types
- Provide comprehensive test cases
- Document time and space complexity

## Exercise 3: Tree Data Structures
Develop a program that implements tree structures:
- Binary search tree with insert, delete, and search operations
- AVL tree with automatic balancing
- Heap implementation (min-heap and max-heap)
- Trie for string storage and retrieval
- Include traversal algorithms (inorder, preorder, postorder, level-order)

**Requirements:**
- Implement proper balancing algorithms for AVL trees
- Include visualization functions for tree structures
- Handle memory management correctly
- Provide performance analysis for operations
- Include comprehensive error handling

## Exercise 4: Hash Tables and Associative Arrays
Write a program that implements hash-based data structures:
- Hash table with collision resolution (chaining or open addressing)
- Implement different hash functions and compare their performance
- Create an associative array (dictionary) interface
- Include dynamic resizing based on load factor
- Provide statistics on collision rates and performance

**Requirements:**
- Implement multiple collision resolution strategies
- Include proper hash function selection and testing
- Handle dynamic resizing efficiently
- Provide performance profiling tools
- Include comprehensive error handling

## Exercise 5: Graph Representations and Algorithms
Create a program that works with graph data structures:
- Implement adjacency list and adjacency matrix representations
- Create graph traversal algorithms (BFS and DFS)
- Implement shortest path algorithms (Dijkstra, Bellman-Ford)
- Develop minimum spanning tree algorithms (Prim, Kruskal)
- Include cycle detection and topological sorting

**Requirements:**
- Handle both directed and undirected graphs
- Implement weighted and unweighted graph versions
- Include proper memory management for graph structures
- Provide visualization tools for graph algorithms
- Document algorithm complexity and use cases

## Exercise 6: Advanced Data Structures
Write a program that implements specialized data structures:
- Implement a priority queue using heap
- Create a disjoint-set (union-find) data structure
- Develop a segment tree for range queries
- Implement a B-tree for database indexing
- Include a bloom filter for probabilistic set membership

**Requirements:**
- Include comprehensive documentation for each structure
- Provide performance analysis and use case examples
- Handle edge cases and error conditions properly
- Include testing frameworks for verification
- Document implementation details and optimizations

## Exercise 7: Data Structure Performance Analysis
Create a program that analyzes and compares data structures:
- Implement benchmarking tools for different operations
- Create performance profiling for various data structures
- Compare memory usage and cache efficiency
- Analyze time complexity with empirical data
- Include visualization of performance characteristics

**Requirements:**
- Include comprehensive benchmarking framework
- Provide statistical analysis of results
- Handle large datasets for meaningful comparisons
- Include cross-platform performance considerations
- Document methodology and findings clearly

## Exercise 8: Comprehensive Data Structure Application
Design a complete application that integrates multiple data structures:
- Implement a database system using various data structures
- Create a file system simulator with directory structures
- Develop a network routing system with graph algorithms
- Include a caching system with hash tables and LRU eviction
- Provide comprehensive testing and validation

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
#include <limits.h>

// Stack implementation
typedef struct {
    int *data;
    int top;
    int capacity;
} Stack;

// Function to create a stack
Stack* create_stack(int capacity) {
    Stack *stack = malloc(sizeof(Stack));
    if (stack == NULL) return NULL;
    
    stack->data = malloc(capacity * sizeof(int));
    if (stack->data == NULL) {
        free(stack);
        return NULL;
    }
    
    stack->top = -1;
    stack->capacity = capacity;
    return stack;
}

// Function to check if stack is empty
bool is_stack_empty(Stack *stack) {
    return stack == NULL || stack->top == -1;
}

// Function to check if stack is full
bool is_stack_full(Stack *stack) {
    return stack != NULL && stack->top == stack->capacity - 1;
}

// Function to push element onto stack
bool push(Stack *stack, int value) {
    if (is_stack_full(stack)) {
        printf("Error: Stack overflow\n");
        return false;
    }
    
    stack->data[++stack->top] = value;
    return true;
}

// Function to pop element from stack
int pop(Stack *stack) {
    if (is_stack_empty(stack)) {
        printf("Error: Stack underflow\n");
        return INT_MIN;
    }
    
    return stack->data[stack->top--];
}

// Function to peek at top element
int peek(Stack *stack) {
    if (is_stack_empty(stack)) {
        printf("Error: Stack is empty\n");
        return INT_MIN;
    }
    
    return stack->data[stack->top];
}

// Function to free stack memory
void free_stack(Stack *stack) {
    if (stack != NULL) {
        free(stack->data);
        free(stack);
    }
}

int main() {
    Stack *stack = create_stack(5);
    if (stack == NULL) {
        printf("Error: Failed to create stack\n");
        return 1;
    }
    
    // Test stack operations
    printf("Testing stack operations:\n");
    
    // Push elements
    for (int i = 1; i <= 5; i++) {
        if (push(stack, i * 10)) {
            printf("Pushed %d onto stack\n", i * 10);
        }
    }
    
    // Try to push to full stack
    if (!push(stack, 60)) {
        printf("Successfully handled stack overflow\n");
    }
    
    // Peek at top element
    printf("Top element: %d\n", peek(stack));
    
    // Pop elements
    while (!is_stack_empty(stack)) {
        int value = pop(stack);
        printf("Popped %d from stack\n", value);
    }
    
    // Try to pop from empty stack
    int empty_pop = pop(stack);
    if (empty_pop == INT_MIN) {
        printf("Successfully handled stack underflow\n");
    }
    
    free_stack(stack);
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Binary Search Tree Node
typedef struct TreeNode {
    int data;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

// Function to create a new tree node
TreeNode* create_node(int data) {
    TreeNode *node = malloc(sizeof(TreeNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

// Function to insert a node into BST
TreeNode* insert_bst(TreeNode *root, int data) {
    if (root == NULL) {
        return create_node(data);
    }
    
    if (data < root->data) {
        root->left = insert_bst(root->left, data);
    } else if (data > root->data) {
        root->right = insert_bst(root->right, data);
    }
    // If data == root->data, we don't insert duplicates
    
    return root;
}

// Function for inorder traversal
void inorder_traversal(TreeNode *root) {
    if (root != NULL) {
        inorder_traversal(root->left);
        printf("%d ", root->data);
        inorder_traversal(root->right);
    }
}

// Function to search for a value in BST
TreeNode* search_bst(TreeNode *root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search_bst(root->left, data);
    } else {
        return search_bst(root->right, data);
    }
}

// Function to find minimum value node
TreeNode* find_min(TreeNode *node) {
    while (node && node->left != NULL) {
        node = node->left;
    }
    return node;
}

// Function to delete a node from BST
TreeNode* delete_bst(TreeNode *root, int data) {
    if (root == NULL) return root;
    
    if (data < root->data) {
        root->left = delete_bst(root->left, data);
    } else if (data > root->data) {
        root->right = delete_bst(root->right, data);
    } else {
        // Node to be deleted found
        if (root->left == NULL) {
            TreeNode *temp = root->right;
            free(root);
            return temp;
        } else if (root->right == NULL) {
            TreeNode *temp = root->left;
            free(root);
            return temp;
        }
        
        // Node with two children
        TreeNode *temp = find_min(root->right);
        root->data = temp->data;
        root->right = delete_bst(root->right, temp->data);
    }
    
    return root;
}

// Function to free entire tree
void free_tree(TreeNode *root) {
    if (root != NULL) {
        free_tree(root->left);
        free_tree(root->right);
        free(root);
    }
}

int main() {
    TreeNode *root = NULL;
    
    // Insert elements into BST
    int values[] = {50, 30, 70, 20, 40, 60, 80};
    int n = sizeof(values) / sizeof(values[0]);
    
    printf("Inserting values into BST: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", values[i]);
        root = insert_bst(root, values[i]);
    }
    printf("\n");
    
    // Inorder traversal (should be sorted)
    printf("Inorder traversal: ");
    inorder_traversal(root);
    printf("\n");
    
    // Search for values
    int search_values[] = {40, 90};
    for (int i = 0; i < 2; i++) {
        TreeNode *result = search_bst(root, search_values[i]);
        if (result != NULL) {
            printf("Found %d in BST\n", search_values[i]);
        } else {
            printf("%d not found in BST\n", search_values[i]);
        }
    }
    
    // Delete a node
    printf("Deleting 30 from BST\n");
    root = delete_bst(root, 30);
    
    printf("Inorder traversal after deletion: ");
    inorder_traversal(root);
    printf("\n");
    
    // Free memory
    free_tree(root);
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Memory leaks**: Always free allocated memory for dynamic structures
2. **Null pointer dereference**: Check pointers before dereferencing
3. **Boundary conditions**: Handle empty structures and edge cases properly
4. **Infinite recursion**: Ensure proper base cases for recursive algorithms
5. **Performance degradation**: Choose appropriate data structures for use cases

### Best Practices:
1. **Modular design**: Implement each data structure as separate modules
2. **Error handling**: Include comprehensive error checking and reporting
3. **Documentation**: Comment interface functions and implementation details
4. **Testing**: Provide thorough test cases for all operations
5. **Performance analysis**: Include complexity analysis and benchmarking

Complete these exercises to solidify your understanding of data structures in C. Each exercise builds upon the previous ones, gradually increasing in complexity.