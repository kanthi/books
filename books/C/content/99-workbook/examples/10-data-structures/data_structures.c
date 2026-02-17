#include "data_structures.h"
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

// Hash function
static int hash(int key) {
    return key % HASH_TABLE_SIZE;
}

// Stack implementation
Stack* create_stack(int capacity) {
    Stack* stack = (Stack*)malloc(sizeof(Stack));
    if (stack == NULL) return NULL;
    
    stack->data = (int*)malloc(capacity * sizeof(int));
    if (stack->data == NULL) {
        free(stack);
        return NULL;
    }
    
    stack->top = -1;
    stack->capacity = capacity;
    return stack;
}

void destroy_stack(Stack* stack) {
    if (stack != NULL) {
        free(stack->data);
        free(stack);
    }
}

bool push(Stack* stack, int value) {
    if (stack == NULL || is_stack_full(stack)) {
        return false;
    }
    
    stack->data[++stack->top] = value;
    return true;
}

int pop(Stack* stack) {
    if (stack == NULL || is_stack_empty(stack)) {
        return INT_MIN;
    }
    
    return stack->data[stack->top--];
}

int peek(Stack* stack) {
    if (stack == NULL || is_stack_empty(stack)) {
        return INT_MIN;
    }
    
    return stack->data[stack->top];
}

bool is_stack_empty(Stack* stack) {
    return stack == NULL || stack->top == -1;
}

bool is_stack_full(Stack* stack) {
    return stack != NULL && stack->top == stack->capacity - 1;
}

// Queue implementation
Queue* create_queue(int capacity) {
    Queue* queue = (Queue*)malloc(sizeof(Queue));
    if (queue == NULL) return NULL;
    
    queue->data = (int*)malloc(capacity * sizeof(int));
    if (queue->data == NULL) {
        free(queue);
        return NULL;
    }
    
    queue->front = 0;
    queue->rear = -1;
    queue->capacity = capacity;
    queue->size = 0;
    return queue;
}

void destroy_queue(Queue* queue) {
    if (queue != NULL) {
        free(queue->data);
        free(queue);
    }
}

bool enqueue(Queue* queue, int value) {
    if (queue == NULL || is_queue_full(queue)) {
        return false;
    }
    
    queue->rear = (queue->rear + 1) % queue->capacity;
    queue->data[queue->rear] = value;
    queue->size++;
    return true;
}

int dequeue(Queue* queue) {
    if (queue == NULL || is_queue_empty(queue)) {
        return INT_MIN;
    }
    
    int value = queue->data[queue->front];
    queue->front = (queue->front + 1) % queue->capacity;
    queue->size--;
    return value;
}

int front(Queue* queue) {
    if (queue == NULL || is_queue_empty(queue)) {
        return INT_MIN;
    }
    
    return queue->data[queue->front];
}

bool is_queue_empty(Queue* queue) {
    return queue == NULL || queue->size == 0;
}

bool is_queue_full(Queue* queue) {
    return queue != NULL && queue->size == queue->capacity;
}

// Linked list implementation
Node* create_linked_list_node(int data) {
    Node* node = (Node*)malloc(sizeof(Node));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    return node;
}

void insert_at_beginning(Node** head, int data) {
    if (head == NULL) return;
    
    Node* newNode = create_linked_list_node(data);
    if (newNode == NULL) return;
    
    newNode->next = *head;
    *head = newNode;
}

void insert_at_end(Node** head, int data) {
    if (head == NULL) return;
    
    Node* newNode = create_linked_list_node(data);
    if (newNode == NULL) return;
    
    if (*head == NULL) {
        *head = newNode;
        return;
    }
    
    Node* current = *head;
    while (current->next != NULL) {
        current = current->next;
    }
    
    current->next = newNode;
}

void delete_node(Node** head, int key) {
    if (head == NULL || *head == NULL) return;
    
    Node* temp = *head;
    
    // If head node holds the key
    if (temp != NULL && temp->data == key) {
        *head = temp->next;
        free(temp);
        return;
    }
    
    // Search for the key to be deleted
    Node* prev = NULL;
    while (temp != NULL && temp->data != key) {
        prev = temp;
        temp = temp->next;
    }
    
    // If key was not present
    if (temp == NULL) return;
    
    // Unlink the node
    prev->next = temp->next;
    free(temp);
}

void print_linked_list(Node* head) {
    Node* current = head;
    printf("Linked List: ");
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

void free_linked_list(Node* head) {
    Node* current = head;
    Node* next;
    
    while (current != NULL) {
        next = current->next;
        free(current);
        current = next;
    }
}

// Binary tree implementation
TreeNode* create_tree_node(int data) {
    TreeNode* node = (TreeNode*)malloc(sizeof(TreeNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

TreeNode* insert_tree_node(TreeNode* root, int data) {
    if (root == NULL) {
        return create_tree_node(data);
    }
    
    if (data < root->data) {
        root->left = insert_tree_node(root->left, data);
    } else if (data > root->data) {
        root->right = insert_tree_node(root->right, data);
    }
    
    return root;
}

TreeNode* delete_tree_node(TreeNode* root, int data) {
    if (root == NULL) return root;
    
    if (data < root->data) {
        root->left = delete_tree_node(root->left, data);
    } else if (data > root->data) {
        root->right = delete_tree_node(root->right, data);
    } else {
        // Node with only one child or no child
        if (root->left == NULL) {
            TreeNode* temp = root->right;
            free(root);
            return temp;
        } else if (root->right == NULL) {
            TreeNode* temp = root->left;
            free(root);
            return temp;
        }
        
        // Node with two children
        TreeNode* temp = root->right;
        while (temp && temp->left != NULL) {
            temp = temp->left;
        }
        
        root->data = temp->data;
        root->right = delete_tree_node(root->right, temp->data);
    }
    
    return root;
}

TreeNode* search_tree_node(TreeNode* root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search_tree_node(root->left, data);
    }
    
    return search_tree_node(root->right, data);
}

void inorder_traversal(TreeNode* root) {
    if (root != NULL) {
        inorder_traversal(root->left);
        printf("%d ", root->data);
        inorder_traversal(root->right);
    }
}

void preorder_traversal(TreeNode* root) {
    if (root != NULL) {
        printf("%d ", root->data);
        preorder_traversal(root->left);
        preorder_traversal(root->right);
    }
}

void postorder_traversal(TreeNode* root) {
    if (root != NULL) {
        postorder_traversal(root->left);
        postorder_traversal(root->right);
        printf("%d ", root->data);
    }
}

void free_tree(TreeNode* root) {
    if (root != NULL) {
        free_tree(root->left);
        free_tree(root->right);
        free(root);
    }
}

// Hash table implementation
HashTable* create_hash_table() {
    HashTable* table = (HashTable*)malloc(sizeof(HashTable));
    if (table == NULL) return NULL;
    
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        table->buckets[i] = NULL;
    }
    
    return table;
}

void destroy_hash_table(HashTable* table) {
    if (table == NULL) return;
    
    for (int i = 0; i < HASH_TABLE_SIZE; i++) {
        HashNode* node = table->buckets[i];
        while (node != NULL) {
            HashNode* temp = node;
            node = node->next;
            free(temp);
        }
    }
    
    free(table);
}

void hash_table_insert(HashTable* table, int key, int value) {
    if (table == NULL) return;
    
    int index = hash(key);
    HashNode* node = table->buckets[index];
    
    // Check if key already exists
    while (node != NULL) {
        if (node->key == key) {
            node->value = value; // Update value
            return;
        }
        node = node->next;
    }
    
    // Key doesn't exist, create new node
    HashNode* newNode = (HashNode*)malloc(sizeof(HashNode));
    if (newNode == NULL) return;
    
    newNode->key = key;
    newNode->value = value;
    newNode->next = table->buckets[index];
    table->buckets[index] = newNode;
}

int hash_table_search(HashTable* table, int key) {
    if (table == NULL) return INT_MIN;
    
    int index = hash(key);
    HashNode* node = table->buckets[index];
    
    while (node != NULL) {
        if (node->key == key) {
            return node->value;
        }
        node = node->next;
    }
    
    return INT_MIN; // Key not found
}

void hash_table_delete(HashTable* table, int key) {
    if (table == NULL) return;
    
    int index = hash(key);
    HashNode* node = table->buckets[index];
    HashNode* prev = NULL;
    
    while (node != NULL && node->key != key) {
        prev = node;
        node = node->next;
    }
    
    if (node == NULL) return; // Key not found
    
    if (prev == NULL) {
        // Deleting first node
        table->buckets[index] = node->next;
    } else {
        prev->next = node->next;
    }
    
    free(node);
}

// Graph implementation
Graph* create_graph(int vertices) {
    Graph* graph = (Graph*)malloc(sizeof(Graph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    graph->adjLists = (Node**)malloc(vertices * sizeof(Node*));
    if (graph->adjLists == NULL) {
        free(graph);
        return NULL;
    }
    
    graph->visited = (int*)malloc(vertices * sizeof(int));
    if (graph->visited == NULL) {
        free(graph->adjLists);
        free(graph);
        return NULL;
    }
    
    for (int i = 0; i < vertices; i++) {
        graph->adjLists[i] = NULL;
        graph->visited[i] = 0;
    }
    
    return graph;
}

void add_edge(Graph* graph, int src, int dest) {
    if (graph == NULL) return;
    
    // Add edge from src to dest
    Node* newNode = create_linked_list_node(dest);
    if (newNode == NULL) return;
    
    newNode->next = graph->adjLists[src];
    graph->adjLists[src] = newNode;
    
    // Add edge from dest to src (undirected graph)
    newNode = create_linked_list_node(src);
    if (newNode == NULL) return;
    
    newNode->next = graph->adjLists[dest];
    graph->adjLists[dest] = newNode;
}

void bfs(Graph* graph, int startVertex) {
    if (graph == NULL) return;
    
    // Reset visited array
    for (int i = 0; i < graph->vertices; i++) {
        graph->visited[i] = 0;
    }
    
    Queue* queue = create_queue(graph->vertices);
    if (queue == NULL) return;
    
    graph->visited[startVertex] = 1;
    enqueue(queue, startVertex);
    
    printf("BFS traversal: ");
    
    while (!is_queue_empty(queue)) {
        int currentVertex = dequeue(queue);
        printf("%d ", currentVertex);
        
        Node* temp = graph->adjLists[currentVertex];
        while (temp) {
            int adjVertex = temp->data;
            
            if (graph->visited[adjVertex] == 0) {
                graph->visited[adjVertex] = 1;
                enqueue(queue, adjVertex);
            }
            temp = temp->next;
        }
    }
    
    printf("\n");
    destroy_queue(queue);
}

void dfs(Graph* graph, int vertex) {
    if (graph == NULL) return;
    
    Node* adjList = graph->adjLists[vertex];
    Node* temp = adjList;
    
    graph->visited[vertex] = 1;
    printf("%d ", vertex);
    
    while (temp != NULL) {
        int connectedVertex = temp->data;
        
        if (graph->visited[connectedVertex] == 0) {
            dfs(graph, connectedVertex);
        }
        temp = temp->next;
    }
}

void free_graph(Graph* graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        free_linked_list(graph->adjLists[i]);
    }
    
    free(graph->adjLists);
    free(graph->visited);
    free(graph);
}