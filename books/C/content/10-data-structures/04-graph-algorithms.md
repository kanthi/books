# Graph Algorithms

## Introduction

Graphs are fundamental data structures used to model relationships between objects. A graph consists of vertices (nodes) connected by edges, and can represent various real-world scenarios such as social networks, transportation networks, computer networks, and dependency relationships.

In this chapter, we'll explore graph representations, traversal algorithms, shortest path algorithms, and minimum spanning tree algorithms. We'll implement these algorithms in C and examine their applications and performance characteristics.

## Graph Representations

Graphs can be represented in several ways, each with its own advantages and disadvantages.

### Adjacency Matrix

An adjacency matrix is a 2D array where the cell at position (i, j) indicates whether there is an edge from vertex i to vertex j.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

#define MAX_VERTICES 100

typedef struct {
    int vertices;
    int matrix[MAX_VERTICES][MAX_VERTICES];
} AdjMatrixGraph;

// Create adjacency matrix graph
AdjMatrixGraph* create_adj_matrix_graph(int vertices) {
    AdjMatrixGraph *graph = malloc(sizeof(AdjMatrixGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    
    // Initialize matrix with 0s (no edges)
    for (int i = 0; i < vertices; i++) {
        for (int j = 0; j < vertices; j++) {
            graph->matrix[i][j] = 0;
        }
    }
    
    return graph;
}

// Add edge to adjacency matrix graph
void add_edge_matrix(AdjMatrixGraph *graph, int src, int dest, int weight) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    graph->matrix[src][dest] = weight;
    // For undirected graph, also add reverse edge
    graph->matrix[dest][src] = weight;
}

// Remove edge from adjacency matrix graph
void remove_edge_matrix(AdjMatrixGraph *graph, int src, int dest) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    graph->matrix[src][dest] = 0;
    graph->matrix[dest][src] = 0;
}

// Check if edge exists
bool has_edge_matrix(AdjMatrixGraph *graph, int src, int dest) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return false;
    }
    
    return graph->matrix[src][dest] != 0;
}

// Print adjacency matrix
void print_adj_matrix(AdjMatrixGraph *graph) {
    if (graph == NULL) return;
    
    printf("Adjacency Matrix:\n");
    printf("    ");
    for (int i = 0; i < graph->vertices; i++) {
        printf("%3d", i);
    }
    printf("\n");
    
    for (int i = 0; i < graph->vertices; i++) {
        printf("%3d ", i);
        for (int j = 0; j < graph->vertices; j++) {
            printf("%3d", graph->matrix[i][j]);
        }
        printf("\n");
    }
}

int main() {
    AdjMatrixGraph *graph = create_adj_matrix_graph(5);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add edges
    add_edge_matrix(graph, 0, 1, 1);
    add_edge_matrix(graph, 0, 4, 1);
    add_edge_matrix(graph, 1, 2, 1);
    add_edge_matrix(graph, 1, 3, 1);
    add_edge_matrix(graph, 1, 4, 1);
    add_edge_matrix(graph, 2, 3, 1);
    add_edge_matrix(graph, 3, 4, 1);
    
    print_adj_matrix(graph);
    
    printf("\nEdge checks:\n");
    printf("Edge (0,1): %s\n", has_edge_matrix(graph, 0, 1) ? "Yes" : "No");
    printf("Edge (0,2): %s\n", has_edge_matrix(graph, 0, 2) ? "Yes" : "No");
    
    free(graph);
    return 0;
}
```

### Adjacency List

An adjacency list represents a graph as an array of lists, where each list contains the neighbors of a vertex.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_VERTICES 100

typedef struct AdjListNode {
    int vertex;
    int weight;
    struct AdjListNode *next;
} AdjListNode;

typedef struct {
    int vertices;
    AdjListNode *adj_list[MAX_VERTICES];
} AdjListGraph;

// Create new adjacency list node
AdjListNode* create_adj_list_node(int vertex, int weight) {
    AdjListNode *node = malloc(sizeof(AdjListNode));
    if (node == NULL) return NULL;
    
    node->vertex = vertex;
    node->weight = weight;
    node->next = NULL;
    return node;
}

// Create adjacency list graph
AdjListGraph* create_adj_list_graph(int vertices) {
    AdjListGraph *graph = malloc(sizeof(AdjListGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    
    // Initialize adjacency lists
    for (int i = 0; i < vertices; i++) {
        graph->adj_list[i] = NULL;
    }
    
    return graph;
}

// Free adjacency list graph
void free_adj_list_graph(AdjListGraph *graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        AdjListNode *current = graph->adj_list[i];
        while (current != NULL) {
            AdjListNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(graph);
}

// Add edge to adjacency list graph
void add_edge_list(AdjListGraph *graph, int src, int dest, int weight) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Add edge from src to dest
    AdjListNode *new_node = create_adj_list_node(dest, weight);
    new_node->next = graph->adj_list[src];
    graph->adj_list[src] = new_node;
    
    // For undirected graph, also add reverse edge
    new_node = create_adj_list_node(src, weight);
    new_node->next = graph->adj_list[dest];
    graph->adj_list[dest] = new_node;
}

// Remove edge from adjacency list graph
void remove_edge_list(AdjListGraph *graph, int src, int dest) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Remove edge from src to dest
    AdjListNode *current = graph->adj_list[src];
    AdjListNode *prev = NULL;
    
    while (current != NULL) {
        if (current->vertex == dest) {
            if (prev == NULL) {
                graph->adj_list[src] = current->next;
            } else {
                prev->next = current->next;
            }
            free(current);
            break;
        }
        prev = current;
        current = current->next;
    }
    
    // Remove edge from dest to src
    current = graph->adj_list[dest];
    prev = NULL;
    
    while (current != NULL) {
        if (current->vertex == src) {
            if (prev == NULL) {
                graph->adj_list[dest] = current->next;
            } else {
                prev->next = current->next;
            }
            free(current);
            break;
        }
        prev = current;
        current = current->next;
    }
}

// Print adjacency list
void print_adj_list(AdjListGraph *graph) {
    if (graph == NULL) return;
    
    printf("Adjacency List:\n");
    for (int i = 0; i < graph->vertices; i++) {
        printf("%d: ", i);
        AdjListNode *current = graph->adj_list[i];
        while (current != NULL) {
            printf("(%d, %d) -> ", current->vertex, current->weight);
            current = current->next;
        }
        printf("NULL\n");
    }
}

int main() {
    AdjListGraph *graph = create_adj_list_graph(5);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add edges
    add_edge_list(graph, 0, 1, 1);
    add_edge_list(graph, 0, 4, 1);
    add_edge_list(graph, 1, 2, 1);
    add_edge_list(graph, 1, 3, 1);
    add_edge_list(graph, 1, 4, 1);
    add_edge_list(graph, 2, 3, 1);
    add_edge_list(graph, 3, 4, 1);
    
    print_adj_list(graph);
    
    free_adj_list_graph(graph);
    return 0;
}
```

## Graph Traversal Algorithms

### Breadth-First Search (BFS)

BFS explores vertices level by level, visiting all neighbors of a vertex before moving to the next level.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_VERTICES 100

typedef struct Queue {
    int items[MAX_VERTICES];
    int front;
    int rear;
} Queue;

// Initialize queue
Queue* create_queue(void) {
    Queue *queue = malloc(sizeof(Queue));
    if (queue == NULL) return NULL;
    
    queue->front = 0;
    queue->rear = -1;
    return queue;
}

// Check if queue is empty
bool is_queue_empty(Queue *queue) {
    return queue->rear < queue->front;
}

// Enqueue
void enqueue(Queue *queue, int item) {
    if (queue->rear < MAX_VERTICES - 1) {
        queue->items[++queue->rear] = item;
    }
}

// Dequeue
int dequeue(Queue *queue) {
    if (is_queue_empty(queue)) {
        return -1;
    }
    return queue->items[queue->front++];
}

typedef struct BFSGraph {
    int vertices;
    struct AdjListNode **adj_list;
} BFSGraph;

typedef struct AdjListNode {
    int vertex;
    struct AdjListNode *next;
} AdjListNode;

// Create new adjacency list node
AdjListNode* create_bfs_node(int vertex) {
    AdjListNode *node = malloc(sizeof(AdjListNode));
    if (node == NULL) return NULL;
    
    node->vertex = vertex;
    node->next = NULL;
    return node;
}

// Create BFS graph
BFSGraph* create_bfs_graph(int vertices) {
    BFSGraph *graph = malloc(sizeof(BFSGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    graph->adj_list = malloc(vertices * sizeof(AdjListNode*));
    if (graph->adj_list == NULL) {
        free(graph);
        return NULL;
    }
    
    for (int i = 0; i < vertices; i++) {
        graph->adj_list[i] = NULL;
    }
    
    return graph;
}

// Free BFS graph
void free_bfs_graph(BFSGraph *graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        AdjListNode *current = graph->adj_list[i];
        while (current != NULL) {
            AdjListNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(graph->adj_list);
    free(graph);
}

// Add edge to BFS graph
void add_bfs_edge(BFSGraph *graph, int src, int dest) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Add edge from src to dest
    AdjListNode *new_node = create_bfs_node(dest);
    new_node->next = graph->adj_list[src];
    graph->adj_list[src] = new_node;
    
    // For undirected graph, also add reverse edge
    new_node = create_bfs_node(src);
    new_node->next = graph->adj_list[dest];
    graph->adj_list[dest] = new_node;
}

// BFS traversal
void bfs(BFSGraph *graph, int start_vertex) {
    if (graph == NULL || start_vertex < 0 || start_vertex >= graph->vertices) {
        return;
    }
    
    bool *visited = calloc(graph->vertices, sizeof(bool));
    if (visited == NULL) return;
    
    Queue *queue = create_queue();
    if (queue == NULL) {
        free(visited);
        return;
    }
    
    visited[start_vertex] = true;
    enqueue(queue, start_vertex);
    
    printf("BFS Traversal starting from vertex %d: ", start_vertex);
    
    while (!is_queue_empty(queue)) {
        int current_vertex = dequeue(queue);
        printf("%d ", current_vertex);
        
        AdjListNode *current = graph->adj_list[current_vertex];
        while (current != NULL) {
            int adj_vertex = current->vertex;
            if (!visited[adj_vertex]) {
                visited[adj_vertex] = true;
                enqueue(queue, adj_vertex);
            }
            current = current->next;
        }
    }
    
    printf("\n");
    
    free(visited);
    free(queue);
}

int main() {
    BFSGraph *graph = create_bfs_graph(6);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add edges to create a sample graph
    add_bfs_edge(graph, 0, 1);
    add_bfs_edge(graph, 0, 2);
    add_bfs_edge(graph, 1, 3);
    add_bfs_edge(graph, 1, 4);
    add_bfs_edge(graph, 2, 4);
    add_bfs_edge(graph, 3, 5);
    add_bfs_edge(graph, 4, 5);
    
    bfs(graph, 0);
    bfs(graph, 2);
    
    free_bfs_graph(graph);
    return 0;
}
```

### Depth-First Search (DFS)

DFS explores as far as possible along each branch before backtracking.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define MAX_VERTICES 100

typedef struct DFSGraph {
    int vertices;
    struct AdjListNode **adj_list;
} DFSGraph;

typedef struct AdjListNode {
    int vertex;
    struct AdjListNode *next;
} AdjListNode;

// Create new adjacency list node
AdjListNode* create_dfs_node(int vertex) {
    AdjListNode *node = malloc(sizeof(AdjListNode));
    if (node == NULL) return NULL;
    
    node->vertex = vertex;
    node->next = NULL;
    return node;
}

// Create DFS graph
DFSGraph* create_dfs_graph(int vertices) {
    DFSGraph *graph = malloc(sizeof(DFSGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    graph->adj_list = malloc(vertices * sizeof(AdjListNode*));
    if (graph->adj_list == NULL) {
        free(graph);
        return NULL;
    }
    
    for (int i = 0; i < vertices; i++) {
        graph->adj_list[i] = NULL;
    }
    
    return graph;
}

// Free DFS graph
void free_dfs_graph(DFSGraph *graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        AdjListNode *current = graph->adj_list[i];
        while (current != NULL) {
            AdjListNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(graph->adj_list);
    free(graph);
}

// Add edge to DFS graph
void add_dfs_edge(DFSGraph *graph, int src, int dest) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Add edge from src to dest
    AdjListNode *new_node = create_dfs_node(dest);
    new_node->next = graph->adj_list[src];
    graph->adj_list[src] = new_node;
    
    // For undirected graph, also add reverse edge
    new_node = create_dfs_node(src);
    new_node->next = graph->adj_list[dest];
    graph->adj_list[dest] = new_node;
}

// Recursive DFS helper function
void dfs_recursive(DFSGraph *graph, int vertex, bool *visited) {
    visited[vertex] = true;
    printf("%d ", vertex);
    
    AdjListNode *current = graph->adj_list[vertex];
    while (current != NULL) {
        int adj_vertex = current->vertex;
        if (!visited[adj_vertex]) {
            dfs_recursive(graph, adj_vertex, visited);
        }
        current = current->next;
    }
}

// DFS traversal
void dfs(DFSGraph *graph, int start_vertex) {
    if (graph == NULL || start_vertex < 0 || start_vertex >= graph->vertices) {
        return;
    }
    
    bool *visited = calloc(graph->vertices, sizeof(bool));
    if (visited == NULL) return;
    
    printf("DFS Traversal starting from vertex %d: ", start_vertex);
    dfs_recursive(graph, start_vertex, visited);
    printf("\n");
    
    free(visited);
}

// Iterative DFS using stack
void dfs_iterative(DFSGraph *graph, int start_vertex) {
    if (graph == NULL || start_vertex < 0 || start_vertex >= graph->vertices) {
        return;
    }
    
    bool *visited = calloc(graph->vertices, sizeof(bool));
    if (visited == NULL) return;
    
    int stack[MAX_VERTICES];
    int top = -1;
    
    stack[++top] = start_vertex;
    
    printf("DFS Iterative Traversal starting from vertex %d: ", start_vertex);
    
    while (top >= 0) {
        int current_vertex = stack[top--];
        
        if (!visited[current_vertex]) {
            visited[current_vertex] = true;
            printf("%d ", current_vertex);
            
            // Push all adjacent vertices to stack
            AdjListNode *current = graph->adj_list[current_vertex];
            while (current != NULL) {
                int adj_vertex = current->vertex;
                if (!visited[adj_vertex]) {
                    stack[++top] = adj_vertex;
                }
                current = current->next;
            }
        }
    }
    
    printf("\n");
    
    free(visited);
}

int main() {
    DFSGraph *graph = create_dfs_graph(6);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add edges to create a sample graph
    add_dfs_edge(graph, 0, 1);
    add_dfs_edge(graph, 0, 2);
    add_dfs_edge(graph, 1, 3);
    add_dfs_edge(graph, 1, 4);
    add_dfs_edge(graph, 2, 4);
    add_dfs_edge(graph, 3, 5);
    add_dfs_edge(graph, 4, 5);
    
    dfs(graph, 0);
    dfs_iterative(graph, 0);
    
    free_dfs_graph(graph);
    return 0;
}
```

## Shortest Path Algorithms

### Dijkstra's Algorithm

Dijkstra's algorithm finds the shortest path from a source vertex to all other vertices in a weighted graph with non-negative edge weights.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

#define MAX_VERTICES 100

typedef struct DijkstraGraph {
    int vertices;
    struct DijkstraNode **adj_list;
} DijkstraGraph;

typedef struct DijkstraNode {
    int vertex;
    int weight;
    struct DijkstraNode *next;
} DijkstraNode;

// Create new adjacency list node
DijkstraNode* create_dijkstra_node(int vertex, int weight) {
    DijkstraNode *node = malloc(sizeof(DijkstraNode));
    if (node == NULL) return NULL;
    
    node->vertex = vertex;
    node->weight = weight;
    node->next = NULL;
    return node;
}

// Create Dijkstra graph
DijkstraGraph* create_dijkstra_graph(int vertices) {
    DijkstraGraph *graph = malloc(sizeof(DijkstraGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    graph->adj_list = malloc(vertices * sizeof(DijkstraNode*));
    if (graph->adj_list == NULL) {
        free(graph);
        return NULL;
    }
    
    for (int i = 0; i < vertices; i++) {
        graph->adj_list[i] = NULL;
    }
    
    return graph;
}

// Free Dijkstra graph
void free_dijkstra_graph(DijkstraGraph *graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        DijkstraNode *current = graph->adj_list[i];
        while (current != NULL) {
            DijkstraNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(graph->adj_list);
    free(graph);
}

// Add edge to Dijkstra graph
void add_dijkstra_edge(DijkstraGraph *graph, int src, int dest, int weight) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Add edge from src to dest
    DijkstraNode *new_node = create_dijkstra_node(dest, weight);
    new_node->next = graph->adj_list[src];
    graph->adj_list[src] = new_node;
    
    // For undirected graph, also add reverse edge
    new_node = create_dijkstra_node(src, weight);
    new_node->next = graph->adj_list[dest];
    graph->adj_list[dest] = new_node;
}

// Min heap implementation for Dijkstra's algorithm
typedef struct {
    int *vertices;
    int *distances;
    int size;
    int capacity;
    int *pos;  // Position of vertices in heap
} MinHeap;

// Create min heap
MinHeap* create_min_heap(int capacity) {
    MinHeap *heap = malloc(sizeof(MinHeap));
    if (heap == NULL) return NULL;
    
    heap->capacity = capacity;
    heap->size = 0;
    heap->vertices = malloc(capacity * sizeof(int));
    heap->distances = malloc(capacity * sizeof(int));
    heap->pos = malloc(capacity * sizeof(int));
    
    if (heap->vertices == NULL || heap->distances == NULL || heap->pos == NULL) {
        free(heap->vertices);
        free(heap->distances);
        free(heap->pos);
        free(heap);
        return NULL;
    }
    
    return heap;
}

// Free min heap
void free_min_heap(MinHeap *heap) {
    if (heap == NULL) return;
    
    free(heap->vertices);
    free(heap->distances);
    free(heap->pos);
    free(heap);
}

// Check if heap is empty
bool is_heap_empty(MinHeap *heap) {
    return heap->size == 0;
}

// Min heapify operation
void min_heapify(MinHeap *heap, int idx) {
    int smallest = idx;
    int left = 2 * idx + 1;
    int right = 2 * idx + 2;
    
    if (left < heap->size && heap->distances[left] < heap->distances[smallest]) {
        smallest = left;
    }
    
    if (right < heap->size && heap->distances[right] < heap->distances[smallest]) {
        smallest = right;
    }
    
    if (smallest != idx) {
        // Swap positions
        int temp_pos = heap->pos[heap->vertices[smallest]];
        heap->pos[heap->vertices[smallest]] = heap->pos[heap->vertices[idx]];
        heap->pos[heap->vertices[idx]] = temp_pos;
        
        // Swap vertices
        int temp_vertex = heap->vertices[smallest];
        heap->vertices[smallest] = heap->vertices[idx];
        heap->vertices[idx] = temp_vertex;
        
        // Swap distances
        int temp_dist = heap->distances[smallest];
        heap->distances[smallest] = heap->distances[idx];
        heap->distances[idx] = temp_dist;
        
        min_heapify(heap, smallest);
    }
}

// Extract minimum distance vertex
int extract_min(MinHeap *heap) {
    if (is_heap_empty(heap)) return -1;
    
    int root_vertex = heap->vertices[0];
    
    // Replace root with last element
    int last_vertex = heap->vertices[heap->size - 1];
    heap->vertices[0] = last_vertex;
    
    // Update position of last vertex
    heap->pos[root_vertex] = heap->size - 1;
    heap->pos[last_vertex] = 0;
    
    // Reduce heap size and heapify root
    heap->size--;
    min_heapify(heap, 0);
    
    return root_vertex;
}

// Decrease key operation
void decrease_key(MinHeap *heap, int vertex, int new_dist) {
    int idx = heap->pos[vertex];
    heap->distances[idx] = new_dist;
    
    // Travel up while heap property is violated
    while (idx && heap->distances[idx] < heap->distances[(idx - 1) / 2]) {
        // Swap positions
        int temp_pos = heap->pos[heap->vertices[(idx - 1) / 2]];
        heap->pos[heap->vertices[(idx - 1) / 2]] = heap->pos[heap->vertices[idx]];
        heap->pos[heap->vertices[idx]] = temp_pos;
        
        // Swap vertices
        int temp_vertex = heap->vertices[(idx - 1) / 2];
        heap->vertices[(idx - 1) / 2] = heap->vertices[idx];
        heap->vertices[idx] = temp_vertex;
        
        // Swap distances
        int temp_dist = heap->distances[(idx - 1) / 2];
        heap->distances[(idx - 1) / 2] = heap->distances[idx];
        heap->distances[idx] = temp_dist;
        
        idx = (idx - 1) / 2;
    }
}

// Check if vertex is in min heap
bool is_in_min_heap(MinHeap *heap, int vertex) {
    return (heap->pos[vertex] < heap->size);
}

// Dijkstra's algorithm
void dijkstra(DijkstraGraph *graph, int src) {
    if (graph == NULL || src < 0 || src >= graph->vertices) {
        return;
    }
    
    int *distances = malloc(graph->vertices * sizeof(int));
    int *parent = malloc(graph->vertices * sizeof(int));
    bool *visited = calloc(graph->vertices, sizeof(bool));
    
    if (distances == NULL || parent == NULL || visited == NULL) {
        free(distances);
        free(parent);
        free(visited);
        return;
    }
    
    // Initialize distances and parent array
    for (int i = 0; i < graph->vertices; i++) {
        distances[i] = INT_MAX;
        parent[i] = -1;
    }
    
    distances[src] = 0;
    
    // Create min heap
    MinHeap *min_heap = create_min_heap(graph->vertices);
    if (min_heap == NULL) {
        free(distances);
        free(parent);
        free(visited);
        return;
    }
    
    // Initialize min heap with all vertices
    for (int i = 0; i < graph->vertices; i++) {
        min_heap->vertices[i] = i;
        min_heap->distances[i] = distances[i];
        min_heap->pos[i] = i;
    }
    
    min_heap->size = graph->vertices;
    
    // Main loop of Dijkstra's algorithm
    while (!is_heap_empty(min_heap)) {
        // Extract minimum distance vertex
        int u = extract_min(min_heap);
        visited[u] = true;
        
        // Update distance values of adjacent vertices
        DijkstraNode *current = graph->adj_list[u];
        while (current != NULL) {
            int v = current->vertex;
            
            // If shortest distance to v is not finalized yet,
            // and distance to v through u is less than its current distance
            if (!visited[v] && distances[u] != INT_MAX && 
                distances[u] + current->weight < distances[v]) {
                distances[v] = distances[u] + current->weight;
                parent[v] = u;
                
                // Update distance value in min heap
                decrease_key(min_heap, v, distances[v]);
            }
            
            current = current->next;
        }
    }
    
    // Print shortest distances
    printf("Shortest distances from vertex %d:\n", src);
    for (int i = 0; i < graph->vertices; i++) {
        if (distances[i] == INT_MAX) {
            printf("Vertex %d: INF\n", i);
        } else {
            printf("Vertex %d: %d\n", i, distances[i]);
        }
    }
    
    free(distances);
    free(parent);
    free(visited);
    free_min_heap(min_heap);
}

int main() {
    DijkstraGraph *graph = create_dijkstra_graph(6);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add weighted edges
    add_dijkstra_edge(graph, 0, 1, 4);
    add_dijkstra_edge(graph, 0, 2, 3);
    add_dijkstra_edge(graph, 1, 2, 1);
    add_dijkstra_edge(graph, 1, 3, 2);
    add_dijkstra_edge(graph, 2, 3, 4);
    add_dijkstra_edge(graph, 3, 4, 2);
    add_dijkstra_edge(graph, 4, 5, 6);
    
    dijkstra(graph, 0);
    
    free_dijkstra_graph(graph);
    return 0;
}
```

## Minimum Spanning Tree Algorithms

### Prim's Algorithm

Prim's algorithm finds a minimum spanning tree for a weighted undirected graph.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <limits.h>

#define MAX_VERTICES 100

typedef struct PrimGraph {
    int vertices;
    struct PrimNode **adj_list;
} PrimGraph;

typedef struct PrimNode {
    int vertex;
    int weight;
    struct PrimNode *next;
} PrimNode;

// Create new adjacency list node
PrimNode* create_prim_node(int vertex, int weight) {
    PrimNode *node = malloc(sizeof(PrimNode));
    if (node == NULL) return NULL;
    
    node->vertex = vertex;
    node->weight = weight;
    node->next = NULL;
    return node;
}

// Create Prim graph
PrimGraph* create_prim_graph(int vertices) {
    PrimGraph *graph = malloc(sizeof(PrimGraph));
    if (graph == NULL) return NULL;
    
    graph->vertices = vertices;
    graph->adj_list = malloc(vertices * sizeof(PrimNode*));
    if (graph->adj_list == NULL) {
        free(graph);
        return NULL;
    }
    
    for (int i = 0; i < vertices; i++) {
        graph->adj_list[i] = NULL;
    }
    
    return graph;
}

// Free Prim graph
void free_prim_graph(PrimGraph *graph) {
    if (graph == NULL) return;
    
    for (int i = 0; i < graph->vertices; i++) {
        PrimNode *current = graph->adj_list[i];
        while (current != NULL) {
            PrimNode *next = current->next;
            free(current);
            current = next;
        }
    }
    
    free(graph->adj_list);
    free(graph);
}

// Add edge to Prim graph
void add_prim_edge(PrimGraph *graph, int src, int dest, int weight) {
    if (graph == NULL || src < 0 || src >= graph->vertices || 
        dest < 0 || dest >= graph->vertices) {
        return;
    }
    
    // Add edge from src to dest
    PrimNode *new_node = create_prim_node(dest, weight);
    new_node->next = graph->adj_list[src];
    graph->adj_list[src] = new_node;
    
    // For undirected graph, also add reverse edge
    new_node = create_prim_node(src, weight);
    new_node->next = graph->adj_list[dest];
    graph->adj_list[dest] = new_node;
}

// Min heap implementation for Prim's algorithm
typedef struct {
    int *vertices;
    int *keys;
    int *parent;
    int size;
    int capacity;
    int *pos;  // Position of vertices in heap
} PrimHeap;

// Create min heap for Prim's algorithm
PrimHeap* create_prim_heap(int capacity) {
    PrimHeap *heap = malloc(sizeof(PrimHeap));
    if (heap == NULL) return NULL;
    
    heap->capacity = capacity;
    heap->size = 0;
    heap->vertices = malloc(capacity * sizeof(int));
    heap->keys = malloc(capacity * sizeof(int));
    heap->parent = malloc(capacity * sizeof(int));
    heap->pos = malloc(capacity * sizeof(int));
    
    if (heap->vertices == NULL || heap->keys == NULL || 
        heap->parent == NULL || heap->pos == NULL) {
        free(heap->vertices);
        free(heap->keys);
        free(heap->parent);
        free(heap->pos);
        free(heap);
        return NULL;
    }
    
    return heap;
}

// Free Prim heap
void free_prim_heap(PrimHeap *heap) {
    if (heap == NULL) return;
    
    free(heap->vertices);
    free(heap->keys);
    free(heap->parent);
    free(heap->pos);
    free(heap);
}

// Check if heap is empty
bool is_prim_heap_empty(PrimHeap *heap) {
    return heap->size == 0;
}

// Min heapify operation
void prim_heapify(PrimHeap *heap, int idx) {
    int smallest = idx;
    int left = 2 * idx + 1;
    int right = 2 * idx + 2;
    
    if (left < heap->size && heap->keys[left] < heap->keys[smallest]) {
        smallest = left;
    }
    
    if (right < heap->size && heap->keys[right] < heap->keys[smallest]) {
        smallest = right;
    }
    
    if (smallest != idx) {
        // Swap positions
        int temp_pos = heap->pos[heap->vertices[smallest]];
        heap->pos[heap->vertices[smallest]] = heap->pos[heap->vertices[idx]];
        heap->pos[heap->vertices[idx]] = temp_pos;
        
        // Swap vertices
        int temp_vertex = heap->vertices[smallest];
        heap->vertices[smallest] = heap->vertices[idx];
        heap->vertices[idx] = temp_vertex;
        
        // Swap keys
        int temp_key = heap->keys[smallest];
        heap->keys[smallest] = heap->keys[idx];
        heap->keys[idx] = temp_key;
        
        prim_heapify(heap, smallest);
    }
}

// Extract minimum key vertex
int extract_min_prim(PrimHeap *heap) {
    if (is_prim_heap_empty(heap)) return -1;
    
    int root_vertex = heap->vertices[0];
    
    // Replace root with last element
    int last_vertex = heap->vertices[heap->size - 1];
    heap->vertices[0] = last_vertex;
    
    // Update position of last vertex
    heap->pos[root_vertex] = heap->size - 1;
    heap->pos[last_vertex] = 0;
    
    // Reduce heap size and heapify root
    heap->size--;
    prim_heapify(heap, 0);
    
    return root_vertex;
}

// Decrease key operation
void decrease_key_prim(PrimHeap *heap, int vertex, int new_key) {
    int idx = heap->pos[vertex];
    heap->keys[idx] = new_key;
    
    // Travel up while heap property is violated
    while (idx && heap->keys[idx] < heap->keys[(idx - 1) / 2]) {
        // Swap positions
        int temp_pos = heap->pos[heap->vertices[(idx - 1) / 2]];
        heap->pos[heap->vertices[(idx - 1) / 2]] = heap->pos[heap->vertices[idx]];
        heap->pos[heap->vertices[idx]] = temp_pos;
        
        // Swap vertices
        int temp_vertex = heap->vertices[(idx - 1) / 2];
        heap->vertices[(idx - 1) / 2] = heap->vertices[idx];
        heap->vertices[idx] = temp_vertex;
        
        // Swap keys
        int temp_key = heap->keys[(idx - 1) / 2];
        heap->keys[(idx - 1) / 2] = heap->keys[idx];
        heap->keys[idx] = temp_key;
        
        idx = (idx - 1) / 2;
    }
}

// Prim's algorithm for Minimum Spanning Tree
void prim_mst(PrimGraph *graph) {
    if (graph == NULL) return;
    
    int *parent = malloc(graph->vertices * sizeof(int));
    int *key = malloc(graph->vertices * sizeof(int));
    bool *in_mst = calloc(graph->vertices, sizeof(bool));
    
    if (parent == NULL || key == NULL || in_mst == NULL) {
        free(parent);
        free(key);
        free(in_mst);
        return;
    }
    
    // Create min heap
    PrimHeap *min_heap = create_prim_heap(graph->vertices);
    if (min_heap == NULL) {
        free(parent);
        free(key);
        free(in_mst);
        return;
    }
    
    // Initialize min heap with all vertices
    for (int i = 0; i < graph->vertices; i++) {
        parent[i] = -1;
        key[i] = INT_MAX;
        min_heap->vertices[i] = i;
        min_heap->keys[i] = key[i];
        min_heap->parent[i] = parent[i];
        min_heap->pos[i] = i;
    }
    
    // Make key value of 0th vertex as 0
    min_heap->keys[0] = 0;
    key[0] = 0;
    min_heap->parent[0] = -1;
    
    min_heap->size = graph->vertices;
    
    // Main loop of Prim's algorithm
    while (!is_prim_heap_empty(min_heap)) {
        // Extract minimum key vertex
        int u = extract_min_prim(min_heap);
        in_mst[u] = true;
        
        // Update key values and parent indices of adjacent vertices
        PrimNode *current = graph->adj_list[u];
        while (current != NULL) {
            int v = current->vertex;
            
            // If v is not in MST and weight of (u,v) is smaller than current key of v
            if (!in_mst[v] && current->weight < key[v]) {
                key[v] = current->weight;
                parent[v] = u;
                decrease_key_prim(min_heap, v, key[v]);
            }
            
            current = current->next;
        }
    }
    
    // Print MST edges
    printf("Minimum Spanning Tree Edges:\n");
    int total_weight = 0;
    for (int i = 1; i < graph->vertices; i++) {
        printf("%d - %d: %d\n", parent[i], i, key[i]);
        total_weight += key[i];
    }
    printf("Total weight: %d\n", total_weight);
    
    free(parent);
    free(key);
    free(in_mst);
    free_prim_heap(min_heap);
}

int main() {
    PrimGraph *graph = create_prim_graph(5);
    if (graph == NULL) {
        printf("Failed to create graph\n");
        return 1;
    }
    
    // Add weighted edges to create a sample graph
    add_prim_edge(graph, 0, 1, 2);
    add_prim_edge(graph, 0, 3, 6);
    add_prim_edge(graph, 1, 2, 3);
    add_prim_edge(graph, 1, 3, 8);
    add_prim_edge(graph, 1, 4, 5);
    add_prim_edge(graph, 2, 4, 7);
    add_prim_edge(graph, 3, 4, 9);
    
    prim_mst(graph);
    
    free_prim_graph(graph);
    return 0;
}
```

## Practical Examples

### Social Network Analysis

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_USERS 100
#define MAX_NAME_LENGTH 50

typedef struct User {
    int id;
    char name[MAX_NAME_LENGTH];
    struct User **friends;
    int friend_count;
    int max_friends;
} User;

typedef struct SocialNetwork {
    User *users[MAX_USERS];
    int user_count;
} SocialNetwork;

// Create new user
User* create_user(int id, const char *name) {
    User *user = malloc(sizeof(User));
    if (user == NULL) return NULL;
    
    user->id = id;
    strncpy(user->name, name, MAX_NAME_LENGTH - 1);
    user->name[MAX_NAME_LENGTH - 1] = '\0';
    user->friend_count = 0;
    user->max_friends = 10;
    user->friends = malloc(user->max_friends * sizeof(User*));
    if (user->friends == NULL) {
        free(user);
        return NULL;
    }
    
    return user;
}

// Free user
void free_user(User *user) {
    if (user == NULL) return;
    free(user->friends);
    free(user);
}

// Create social network
SocialNetwork* create_social_network(void) {
    SocialNetwork *network = malloc(sizeof(SocialNetwork));
    if (network == NULL) return NULL;
    
    for (int i = 0; i < MAX_USERS; i++) {
        network->users[i] = NULL;
    }
    
    network->user_count = 0;
    return network;
}

// Free social network
void free_social_network(SocialNetwork *network) {
    if (network == NULL) return;
    
    for (int i = 0; i < MAX_USERS; i++) {
        if (network->users[i] != NULL) {
            free_user(network->users[i]);
        }
    }
    
    free(network);
}

// Add user to network
bool add_user(SocialNetwork *network, int id, const char *name) {
    if (network == NULL || id < 0 || id >= MAX_USERS || name == NULL) {
        return false;
    }
    
    if (network->users[id] != NULL) {
        return false;  // User already exists
    }
    
    User *user = create_user(id, name);
    if (user == NULL) {
        return false;
    }
    
    network->users[id] = user;
    network->user_count++;
    return true;
}

// Add friendship between users
bool add_friendship(SocialNetwork *network, int user1_id, int user2_id) {
    if (network == NULL || user1_id < 0 || user1_id >= MAX_USERS || 
        user2_id < 0 || user2_id >= MAX_USERS) {
        return false;
    }
    
    User *user1 = network->users[user1_id];
    User *user2 = network->users[user2_id];
    
    if (user1 == NULL || user2 == NULL) {
        return false;
    }
    
    // Add user2 to user1's friend list
    if (user1->friend_count >= user1->max_friends) {
        user1->max_friends *= 2;
        User **temp = realloc(user1->friends, user1->max_friends * sizeof(User*));
        if (temp == NULL) {
            return false;
        }
        user1->friends = temp;
    }
    user1->friends[user1->friend_count++] = user2;
    
    // Add user1 to user2's friend list
    if (user2->friend_count >= user2->max_friends) {
        user2->max_friends *= 2;
        User **temp = realloc(user2->friends, user2->max_friends * sizeof(User*));
        if (temp == NULL) {
            return false;
        }
        user2->friends = temp;
    }
    user2->friends[user2->friend_count++] = user1;
    
    return true;
}

// Find mutual friends
void find_mutual_friends(SocialNetwork *network, int user1_id, int user2_id) {
    if (network == NULL || user1_id < 0 || user1_id >= MAX_USERS || 
        user2_id < 0 || user2_id >= MAX_USERS) {
        return;
    }
    
    User *user1 = network->users[user1_id];
    User *user2 = network->users[user2_id];
    
    if (user1 == NULL || user2 == NULL) {
        return;
    }
    
    printf("Mutual friends between %s and %s:\n", user1->name, user2->name);
    
    bool found = false;
    for (int i = 0; i < user1->friend_count; i++) {
        User *friend1 = user1->friends[i];
        for (int j = 0; j < user2->friend_count; j++) {
            if (user2->friends[j] == friend1) {
                printf("  %s\n", friend1->name);
                found = true;
                break;
            }
        }
    }
    
    if (!found) {
        printf("  No mutual friends found\n");
    }
}

// Calculate degree centrality (number of connections)
void calculate_degree_centrality(SocialNetwork *network) {
    if (network == NULL) return;
    
    printf("Degree Centrality (Number of Friends):\n");
    printf("=====================================\n");
    
    for (int i = 0; i < MAX_USERS; i++) {
        if (network->users[i] != NULL) {
            printf("%s: %d friends\n", 
                   network->users[i]->name, 
                   network->users[i]->friend_count);
        }
    }
}

// Print social network
void print_social_network(SocialNetwork *network) {
    if (network == NULL) return;
    
    printf("Social Network:\n");
    printf("===============\n");
    
    for (int i = 0; i < MAX_USERS; i++) {
        if (network->users[i] != NULL) {
            User *user = network->users[i];
            printf("%s (ID: %d): ", user->name, user->id);
            
            if (user->friend_count == 0) {
                printf("No friends\n");
            } else {
                printf("Friends: ");
                for (int j = 0; j < user->friend_count; j++) {
                    printf("%s", user->friends[j]->name);
                    if (j < user->friend_count - 1) {
                        printf(", ");
                    }
                }
                printf("\n");
            }
        }
    }
}

int main() {
    SocialNetwork *network = create_social_network();
    if (network == NULL) {
        printf("Failed to create social network\n");
        return 1;
    }
    
    // Add users
    add_user(network, 0, "Alice");
    add_user(network, 1, "Bob");
    add_user(network, 2, "Charlie");
    add_user(network, 3, "Diana");
    add_user(network, 4, "Eve");
    
    // Add friendships
    add_friendship(network, 0, 1);  // Alice - Bob
    add_friendship(network, 0, 2);  // Alice - Charlie
    add_friendship(network, 1, 2);  // Bob - Charlie
    add_friendship(network, 1, 3);  // Bob - Diana
    add_friendship(network, 2, 4);  // Charlie - Eve
    add_friendship(network, 3, 4);  // Diana - Eve
    
    print_social_network(network);
    
    printf("\n");
    find_mutual_friends(network, 0, 3);  // Alice and Diana
    find_mutual_friends(network, 1, 4);  // Bob and Eve
    
    printf("\n");
    calculate_degree_centrality(network);
    
    free_social_network(network);
    return 0;
}
```

## Summary

Graph algorithms are essential for solving complex problems in computer science and real-world applications:

1. **Graph Representations**:
   - Adjacency Matrix: Good for dense graphs, O(1) edge lookup
   - Adjacency List: Good for sparse graphs, space-efficient

2. **Graph Traversal**:
   - BFS: Level-by-level exploration, useful for shortest path in unweighted graphs
   - DFS: Deep exploration, useful for connectivity and cycle detection

3. **Shortest Path Algorithms**:
   - Dijkstra's Algorithm: Finds shortest paths in weighted graphs with non-negative edges
   - Time complexity: O((V + E) log V) with binary heap

4. **Minimum Spanning Tree**:
   - Prim's Algorithm: Greedy approach to find MST
   - Time complexity: O((V + E) log V) with binary heap

Key considerations when working with graph algorithms:
- **Graph Density**: Choose appropriate representation (matrix vs. list)
- **Edge Weights**: Consider whether negative weights are allowed
- **Directed vs. Undirected**: Algorithm implementation varies
- **Performance Requirements**: Balance time and space complexity

Graph algorithms have numerous applications:
- Social network analysis
- Network routing protocols
- Transportation and logistics
- Computer network design
- Circuit design
- Game development (pathfinding)
- Recommendation systems
- Dependency resolution

Understanding graph algorithms and their implementations is crucial for solving complex computational problems efficiently.