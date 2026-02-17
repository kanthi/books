/*
 * Module 10 Demonstration Program
 * This program demonstrates all the key concepts from Module 10:
 * - Linear structures (arrays, linked lists, stacks, queues, deques)
 * - Tree structures (binary trees, binary search trees, AVL trees, heaps)
 * - Hash tables (implementation, collision resolution)
 * - Graph algorithms (representations, traversal, shortest path)
 * - Sorting and searching algorithms
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Include our custom header files
#include "data_structures.h"

// Function prototypes for demonstration functions
void demonstrate_linear_structures(void);
void demonstrate_tree_structures(void);
void demonstrate_hash_tables(void);
void demonstrate_graph_algorithms(void);
void demonstrate_sorting_searching(void);

// Helper functions for sorting demonstrations
void bubble_sort(int arr[], int n);
void quick_sort(int arr[], int low, int high);
int partition(int arr[], int low, int high);
void print_array(int arr[], int n);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 10: Data Structures Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_linear_structures();
    demonstrate_tree_structures();
    demonstrate_hash_tables();
    demonstrate_graph_algorithms();
    demonstrate_sorting_searching();
    
    printf("\n========================================\n");
    printf("  Module 10 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate linear structures
 */
void demonstrate_linear_structures() {
    print_separator("Linear Structures");
    
    // Stack demonstration
    printf("1. Stack (LIFO - Last In, First Out):\n");
    Stack* stack = create_stack(5);
    if (stack != NULL) {
        printf("  Pushing elements: 10, 20, 30, 40, 50\n");
        for (int i = 10; i <= 50; i += 10) {
            push(stack, i);
        }
        
        printf("  Stack contents (top to bottom): ");
        while (!is_stack_empty(stack)) {
            printf("%d ", peek(stack));
            pop(stack);
        }
        printf("\n");
        
        destroy_stack(stack);
    }
    
    // Queue demonstration
    printf("\n2. Queue (FIFO - First In, First Out):\n");
    Queue* queue = create_queue(5);
    if (queue != NULL) {
        printf("  Enqueuing elements: 10, 20, 30, 40, 50\n");
        for (int i = 10; i <= 50; i += 10) {
            enqueue(queue, i);
        }
        
        printf("  Queue contents (front to rear): ");
        while (!is_queue_empty(queue)) {
            printf("%d ", front(queue));
            dequeue(queue);
        }
        printf("\n");
        
        destroy_queue(queue);
    }
    
    // Linked list demonstration
    printf("\n3. Linked List:\n");
    Node* head = NULL;
    
    printf("  Inserting at beginning: 30, 20, 10\n");
    insert_at_beginning(&head, 30);
    insert_at_beginning(&head, 20);
    insert_at_beginning(&head, 10);
    print_linked_list(head);
    
    printf("  Inserting at end: 40, 50\n");
    insert_at_end(&head, 40);
    insert_at_end(&head, 50);
    print_linked_list(head);
    
    printf("  Deleting node with value 30\n");
    delete_node(&head, 30);
    print_linked_list(head);
    
    free_linked_list(head);
}

/*
 * Demonstrate tree structures
 */
void demonstrate_tree_structures() {
    print_separator("Tree Structures");
    
    // Binary Search Tree demonstration
    printf("1. Binary Search Tree:\n");
    TreeNode* root = NULL;
    
    printf("  Inserting elements: 50, 30, 70, 20, 40, 60, 80\n");
    int values[] = {50, 30, 70, 20, 40, 60, 80};
    int n = sizeof(values) / sizeof(values[0]);
    
    for (int i = 0; i < n; i++) {
        root = insert_tree_node(root, values[i]);
    }
    
    printf("  Inorder traversal (sorted): ");
    inorder_traversal(root);
    printf("\n");
    
    printf("  Preorder traversal: ");
    preorder_traversal(root);
    printf("\n");
    
    printf("  Postorder traversal: ");
    postorder_traversal(root);
    printf("\n");
    
    printf("  Searching for 40: ");
    TreeNode* found = search_tree_node(root, 40);
    if (found != NULL) {
        printf("Found\n");
    } else {
        printf("Not found\n");
    }
    
    printf("  Deleting node with value 30\n");
    root = delete_tree_node(root, 30);
    printf("  Inorder traversal after deletion: ");
    inorder_traversal(root);
    printf("\n");
    
    free_tree(root);
    
    // AVL tree concept explanation
    printf("\n2. AVL Tree (Self-balancing BST):\n");
    printf("  AVL trees maintain balance through rotations\n");
    printf("  Balance factor: height(left subtree) - height(right subtree)\n");
    printf("  Rotations: LL, RR, LR, RL\n");
    
    // Heap concept explanation
    printf("\n3. Heap:\n");
    printf("  Max Heap: Parent >= Children\n");
    printf("  Min Heap: Parent <= Children\n");
    printf("  Applications: Priority queues, heap sort\n");
}

/*
 * Demonstrate hash tables
 */
void demonstrate_hash_tables() {
    print_separator("Hash Tables");
    
    HashTable* table = create_hash_table();
    if (table != NULL) {
        printf("1. Inserting key-value pairs:\n");
        hash_table_insert(table, 1, 100);
        hash_table_insert(table, 2, 200);
        hash_table_insert(table, 3, 300);
        hash_table_insert(table, 101, 1000); // Collision with key 1
        hash_table_insert(table, 102, 2000); // Collision with key 2
        
        printf("  (1, 100), (2, 200), (3, 300), (101, 1000), (102, 2000)\n");
        
        printf("\n2. Searching for keys:\n");
        int keys[] = {1, 2, 3, 101, 102, 999}; // 999 doesn't exist
        int num_keys = sizeof(keys) / sizeof(keys[0]);
        
        for (int i = 0; i < num_keys; i++) {
            int value = hash_table_search(table, keys[i]);
            if (value != INT_MIN) {
                printf("  Key %d: Value %d\n", keys[i], value);
            } else {
                printf("  Key %d: Not found\n", keys[i]);
            }
        }
        
        printf("\n3. Deleting key 2\n");
        hash_table_delete(table, 2);
        
        printf("  Searching for key 2 after deletion: ");
        int value = hash_table_search(table, 2);
        if (value != INT_MIN) {
            printf("Value %d\n", value);
        } else {
            printf("Not found\n");
        }
        
        destroy_hash_table(table);
    }
    
    printf("\n4. Collision Resolution Methods:\n");
    printf("  Chaining: Store colliding elements in a linked list\n");
    printf("  Open Addressing: Find another empty slot\n");
    printf("    - Linear probing: (hash + i) % table_size\n");
    printf("    - Quadratic probing: (hash + i*i) % table_size\n");
    printf("    - Double hashing: (hash1 + i * hash2) % table_size\n");
}

/*
 * Demonstrate graph algorithms
 */
void demonstrate_graph_algorithms() {
    print_separator("Graph Algorithms");
    
    // Create a graph with 6 vertices
    Graph* graph = create_graph(6);
    if (graph != NULL) {
        // Add edges to create a sample graph
        add_edge(graph, 0, 1);
        add_edge(graph, 0, 2);
        add_edge(graph, 1, 3);
        add_edge(graph, 2, 3);
        add_edge(graph, 3, 4);
        add_edge(graph, 4, 5);
        
        printf("1. Graph representation (Adjacency List):\n");
        printf("  Vertex 0: -> 2 -> 1\n");
        printf("  Vertex 1: -> 3 -> 0\n");
        printf("  Vertex 2: -> 3 -> 0\n");
        printf("  Vertex 3: -> 4 -> 2 -> 1\n");
        printf("  Vertex 4: -> 5 -> 3\n");
        printf("  Vertex 5: -> 4\n");
        
        printf("\n2. Breadth-First Search (BFS) from vertex 0:\n");
        bfs(graph, 0);
        
        // Reset visited array for DFS
        for (int i = 0; i < graph->vertices; i++) {
            graph->visited[i] = 0;
        }
        
        printf("\n3. Depth-First Search (DFS) from vertex 0:\n");
        printf("  DFS traversal: ");
        dfs(graph, 0);
        printf("\n");
        
        free_graph(graph);
    }
    
    printf("\n4. Graph representations:\n");
    printf("  Adjacency Matrix: 2D array where matrix[i][j] = 1 if edge exists\n");
    printf("  Adjacency List: Array of lists, each list contains neighbors\n");
    
    printf("\n5. Shortest path algorithms:\n");
    printf("  Dijkstra's Algorithm: For weighted graphs with non-negative weights\n");
    printf("  Bellman-Ford Algorithm: For graphs with negative weights\n");
    printf("  Floyd-Warshall Algorithm: For all-pairs shortest paths\n");
    
    printf("\n6. Minimum Spanning Tree:\n");
    printf("  Prim's Algorithm: Greedy approach starting from a vertex\n");
    printf("  Kruskal's Algorithm: Greedy approach using sorted edges\n");
}

/*
 * Demonstrate sorting and searching algorithms
 */
void demonstrate_sorting_searching() {
    print_separator("Sorting and Searching Algorithms");
    
    // Bubble sort demonstration
    printf("1. Bubble Sort:\n");
    int arr1[] = {64, 34, 25, 12, 22, 11, 90};
    int n1 = sizeof(arr1) / sizeof(arr1[0]);
    
    printf("  Original array: ");
    print_array(arr1, n1);
    
    bubble_sort(arr1, n1);
    
    printf("  Sorted array: ");
    print_array(arr1, n1);
    
    // Quick sort demonstration
    printf("\n2. Quick Sort:\n");
    int arr2[] = {64, 34, 25, 12, 22, 11, 90};
    int n2 = sizeof(arr2) / sizeof(arr2[0]);
    
    printf("  Original array: ");
    print_array(arr2, n2);
    
    quick_sort(arr2, 0, n2 - 1);
    
    printf("  Sorted array: ");
    print_array(arr2, n2);
    
    // Binary search demonstration
    printf("\n3. Binary Search:\n");
    int sorted_arr[] = {11, 12, 22, 25, 34, 64, 90};
    int n3 = sizeof(sorted_arr) / sizeof(sorted_arr[0]);
    int target = 25;
    
    printf("  Searching for %d in array: ", target);
    print_array(sorted_arr, n3);
    
    // Linear search implementation
    int found_index = -1;
    for (int i = 0; i < n3; i++) {
        if (sorted_arr[i] == target) {
            found_index = i;
            break;
        }
    }
    
    if (found_index != -1) {
        printf("  Found %d at index %d\n", target, found_index);
    } else {
        printf("  %d not found in array\n", target);
    }
    
    printf("\n4. Algorithm Complexities:\n");
    printf("  Sorting:\n");
    printf("    Bubble Sort: O(n²) time, O(1) space\n");
    printf("    Quick Sort: O(n log n) average, O(n²) worst time, O(log n) space\n");
    printf("    Merge Sort: O(n log n) time, O(n) space\n");
    printf("    Heap Sort: O(n log n) time, O(1) space\n");
    printf("  Searching:\n");
    printf("    Linear Search: O(n) time\n");
    printf("    Binary Search: O(log n) time (requires sorted array)\n");
    printf("  Data Structures:\n");
    printf("    Array Access: O(1) time\n");
    printf("    Linked List Access: O(n) time\n");
    printf("    Binary Search Tree Search: O(log n) average, O(n) worst\n");
    printf("    Hash Table Search: O(1) average, O(n) worst\n");
}

// Helper function implementations
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap elements
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = (low - 1);
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            // Swap elements
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    
    // Swap pivot to correct position
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    
    return (i + 1);
}

void quick_sort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}