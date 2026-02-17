#ifndef DATA_STRUCTURES_H
#define DATA_STRUCTURES_H

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

// Node structures for various data structures
typedef struct Node {
    int data;
    struct Node* next;
} Node;

typedef struct DNode {
    int data;
    struct DNode* next;
    struct DNode* prev;
} DNode;

typedef struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;

// Stack implementation
typedef struct {
    int* data;
    int top;
    int capacity;
} Stack;

// Queue implementation
typedef struct {
    int* data;
    int front;
    int rear;
    int capacity;
    int size;
} Queue;

// Hash table implementation
#define HASH_TABLE_SIZE 100
typedef struct HashNode {
    int key;
    int value;
    struct HashNode* next;
} HashNode;

typedef struct {
    HashNode* buckets[HASH_TABLE_SIZE];
} HashTable;

// Graph implementation
typedef struct Graph {
    int vertices;
    struct Node** adjLists;
    int* visited;
} Graph;

// Function prototypes for data structures
Stack* create_stack(int capacity);
void destroy_stack(Stack* stack);
bool push(Stack* stack, int value);
int pop(Stack* stack);
int peek(Stack* stack);
bool is_stack_empty(Stack* stack);
bool is_stack_full(Stack* stack);

Queue* create_queue(int capacity);
void destroy_queue(Queue* queue);
bool enqueue(Queue* queue, int value);
int dequeue(Queue* queue);
int front(Queue* queue);
bool is_queue_empty(Queue* queue);
bool is_queue_full(Queue* queue);

Node* create_linked_list_node(int data);
void insert_at_beginning(Node** head, int data);
void insert_at_end(Node** head, int data);
void delete_node(Node** head, int key);
void print_linked_list(Node* head);
void free_linked_list(Node* head);

TreeNode* create_tree_node(int data);
TreeNode* insert_tree_node(TreeNode* root, int data);
TreeNode* delete_tree_node(TreeNode* root, int data);
TreeNode* search_tree_node(TreeNode* root, int data);
void inorder_traversal(TreeNode* root);
void preorder_traversal(TreeNode* root);
void postorder_traversal(TreeNode* root);
void free_tree(TreeNode* root);

HashTable* create_hash_table();
void destroy_hash_table(HashTable* table);
void hash_table_insert(HashTable* table, int key, int value);
int hash_table_search(HashTable* table, int key);
void hash_table_delete(HashTable* table, int key);

Graph* create_graph(int vertices);
void add_edge(Graph* graph, int src, int dest);
void bfs(Graph* graph, int startVertex);
void dfs(Graph* graph, int vertex);
void free_graph(Graph* graph);

#endif // DATA_STRUCTURES_H