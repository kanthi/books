# Tree Structures

## Introduction

Tree structures are hierarchical data structures that organize data in a parent-child relationship, where each node can have zero or more child nodes. Trees are fundamental in computer science and are used in various applications such as file systems, databases, expression parsing, and decision-making algorithms.

In this chapter, we'll explore different types of tree structures, from basic binary trees to more complex balanced trees like AVL and red-black trees. We'll implement these structures in C and examine their properties, operations, and performance characteristics.

## Binary Trees

A binary tree is a tree data structure where each node has at most two children, referred to as the left child and the right child.

### Basic Binary Tree Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct TreeNode {
    int data;
    struct TreeNode *left;
    struct TreeNode *right;
} TreeNode;

// Create new tree node
TreeNode* create_node(int data) {
    TreeNode *node = malloc(sizeof(TreeNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

// Free entire tree
void free_tree(TreeNode *root) {
    if (root == NULL) return;
    
    free_tree(root->left);
    free_tree(root->right);
    free(root);
}

// Insert node in binary tree (level-order insertion)
TreeNode* insert_level_order(TreeNode *root, int data) {
    TreeNode *new_node = create_node(data);
    if (new_node == NULL) return root;
    
    if (root == NULL) {
        return new_node;
    }
    
    // Use queue for level-order insertion
    TreeNode *queue[100];
    int front = 0, rear = 0;
    queue[rear++] = root;
    
    while (front < rear) {
        TreeNode *current = queue[front++];
        
        if (current->left == NULL) {
            current->left = new_node;
            return root;
        } else {
            queue[rear++] = current->left;
        }
        
        if (current->right == NULL) {
            current->right = new_node;
            return root;
        } else {
            queue[rear++] = current->right;
        }
    }
    
    return root;
}

// Tree traversals
void inorder_traversal(TreeNode *root) {
    if (root == NULL) return;
    
    inorder_traversal(root->left);
    printf("%d ", root->data);
    inorder_traversal(root->right);
}

void preorder_traversal(TreeNode *root) {
    if (root == NULL) return;
    
    printf("%d ", root->data);
    preorder_traversal(root->left);
    preorder_traversal(root->right);
}

void postorder_traversal(TreeNode *root) {
    if (root == NULL) return;
    
    postorder_traversal(root->left);
    postorder_traversal(root->right);
    printf("%d ", root->data);
}

// Level-order traversal (breadth-first)
void level_order_traversal(TreeNode *root) {
    if (root == NULL) return;
    
    TreeNode *queue[100];
    int front = 0, rear = 0;
    queue[rear++] = root;
    
    while (front < rear) {
        TreeNode *current = queue[front++];
        printf("%d ", current->data);
        
        if (current->left != NULL) {
            queue[rear++] = current->left;
        }
        
        if (current->right != NULL) {
            queue[rear++] = current->right;
        }
    }
}

// Tree height
int tree_height(TreeNode *root) {
    if (root == NULL) return 0;
    
    int left_height = tree_height(root->left);
    int right_height = tree_height(root->right);
    
    return 1 + (left_height > right_height ? left_height : right_height);
}

// Node count
int node_count(TreeNode *root) {
    if (root == NULL) return 0;
    
    return 1 + node_count(root->left) + node_count(root->right);
}

// Leaf count
int leaf_count(TreeNode *root) {
    if (root == NULL) return 0;
    
    if (root->left == NULL && root->right == NULL) {
        return 1;
    }
    
    return leaf_count(root->left) + leaf_count(root->right);
}

int main() {
    TreeNode *root = NULL;
    
    // Build tree: 1, 2, 3, 4, 5, 6, 7
    for (int i = 1; i <= 7; i++) {
        root = insert_level_order(root, i);
    }
    
    printf("Inorder traversal: ");
    inorder_traversal(root);
    printf("\n");
    
    printf("Preorder traversal: ");
    preorder_traversal(root);
    printf("\n");
    
    printf("Postorder traversal: ");
    postorder_traversal(root);
    printf("\n");
    
    printf("Level-order traversal: ");
    level_order_traversal(root);
    printf("\n");
    
    printf("Tree height: %d\n", tree_height(root));
    printf("Node count: %d\n", node_count(root));
    printf("Leaf count: %d\n", leaf_count(root));
    
    free_tree(root);
    return 0;
}
```

## Binary Search Trees (BST)

A binary search tree is a binary tree where each node follows the property that all values in the left subtree are less than the node's value, and all values in the right subtree are greater than the node's value.

### BST Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct BSTNode {
    int data;
    struct BSTNode *left;
    struct BSTNode *right;
} BSTNode;

// Create new BST node
BSTNode* create_bst_node(int data) {
    BSTNode *node = malloc(sizeof(BSTNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    return node;
}

// Free BST
void free_bst(BSTNode *root) {
    if (root == NULL) return;
    
    free_bst(root->left);
    free_bst(root->right);
    free(root);
}

// Insert node in BST
BSTNode* insert_bst(BSTNode *root, int data) {
    if (root == NULL) {
        return create_bst_node(data);
    }
    
    if (data < root->data) {
        root->left = insert_bst(root->left, data);
    } else if (data > root->data) {
        root->right = insert_bst(root->right, data);
    }
    // If data == root->data, we don't insert duplicates
    
    return root;
}

// Search in BST
BSTNode* search_bst(BSTNode *root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search_bst(root->left, data);
    } else {
        return search_bst(root->right, data);
    }
}

// Find minimum value node
BSTNode* find_min(BSTNode *root) {
    if (root == NULL) return NULL;
    
    while (root->left != NULL) {
        root = root->left;
    }
    
    return root;
}

// Find maximum value node
BSTNode* find_max(BSTNode *root) {
    if (root == NULL) return NULL;
    
    while (root->right != NULL) {
        root = root->right;
    }
    
    return root;
}

// Delete node from BST
BSTNode* delete_bst(BSTNode *root, int data) {
    if (root == NULL) return root;
    
    if (data < root->data) {
        root->left = delete_bst(root->left, data);
    } else if (data > root->data) {
        root->right = delete_bst(root->right, data);
    } else {
        // Node to be deleted found
        
        // Case 1: Node has no children
        if (root->left == NULL && root->right == NULL) {
            free(root);
            return NULL;
        }
        
        // Case 2: Node has one child
        if (root->left == NULL) {
            BSTNode *temp = root->right;
            free(root);
            return temp;
        }
        
        if (root->right == NULL) {
            BSTNode *temp = root->left;
            free(root);
            return temp;
        }
        
        // Case 3: Node has two children
        BSTNode *temp = find_min(root->right);
        root->data = temp->data;
        root->right = delete_bst(root->right, temp->data);
    }
    
    return root;
}

// Inorder traversal (gives sorted order for BST)
void inorder_bst(BSTNode *root) {
    if (root == NULL) return;
    
    inorder_bst(root->left);
    printf("%d ", root->data);
    inorder_bst(root->right);
}

// Check if tree is valid BST
bool is_valid_bst(BSTNode *root, long min_val, long max_val) {
    if (root == NULL) return true;
    
    if (root->data <= min_val || root->data >= max_val) {
        return false;
    }
    
    return is_valid_bst(root->left, min_val, root->data) &&
           is_valid_bst(root->right, root->data, max_val);
}

bool validate_bst(BSTNode *root) {
    return is_valid_bst(root, LONG_MIN, LONG_MAX);
}

int main() {
    BSTNode *root = NULL;
    
    // Insert nodes
    int values[] = {50, 30, 70, 20, 40, 60, 80, 10, 25, 35, 45};
    int n = sizeof(values) / sizeof(values[0]);
    
    for (int i = 0; i < n; i++) {
        root = insert_bst(root, values[i]);
    }
    
    printf("BST inorder traversal (sorted): ");
    inorder_bst(root);
    printf("\n");
    
    printf("Is valid BST: %s\n", validate_bst(root) ? "Yes" : "No");
    
    // Search operations
    int search_values[] = {25, 35, 90};
    for (int i = 0; i < 3; i++) {
        BSTNode *found = search_bst(root, search_values[i]);
        printf("Search %d: %s\n", search_values[i], 
               found ? "Found" : "Not found");
    }
    
    // Find min and max
    BSTNode *min_node = find_min(root);
    BSTNode *max_node = find_max(root);
    printf("Minimum value: %d\n", min_node ? min_node->data : -1);
    printf("Maximum value: %d\n", max_node ? max_node->data : -1);
    
    // Delete operations
    printf("Deleting 20...\n");
    root = delete_bst(root, 20);
    printf("BST after deletion: ");
    inorder_bst(root);
    printf("\n");
    
    printf("Deleting 30...\n");
    root = delete_bst(root, 30);
    printf("BST after deletion: ");
    inorder_bst(root);
    printf("\n");
    
    printf("Deleting 50...\n");
    root = delete_bst(root, 50);
    printf("BST after deletion: ");
    inorder_bst(root);
    printf("\n");
    
    free_bst(root);
    return 0;
}
```

## AVL Trees

AVL trees are self-balancing binary search trees where the heights of the two child subtrees of any node differ by at most one. This ensures O(log n) time complexity for search, insert, and delete operations.

### AVL Tree Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <math.h>

typedef struct AVLNode {
    int data;
    struct AVLNode *left;
    struct AVLNode *right;
    int height;
} AVLNode;

// Get height of node
int get_height(AVLNode *node) {
    return node ? node->height : 0;
}

// Get balance factor
int get_balance(AVLNode *node) {
    return node ? get_height(node->left) - get_height(node->right) : 0;
}

// Create new AVL node
AVLNode* create_avl_node(int data) {
    AVLNode *node = malloc(sizeof(AVLNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->left = NULL;
    node->right = NULL;
    node->height = 1;  // New node is initially at leaf level
    return node;
}

// Free AVL tree
void free_avl(AVLNode *root) {
    if (root == NULL) return;
    
    free_avl(root->left);
    free_avl(root->right);
    free(root);
}

// Update height of node
void update_height(AVLNode *node) {
    if (node != NULL) {
        node->height = 1 + fmax(get_height(node->left), get_height(node->right));
    }
}

// Right rotate
AVLNode* right_rotate(AVLNode *y) {
    AVLNode *x = y->left;
    AVLNode *T2 = x->right;
    
    // Perform rotation
    x->right = y;
    y->left = T2;
    
    // Update heights
    update_height(y);
    update_height(x);
    
    // Return new root
    return x;
}

// Left rotate
AVLNode* left_rotate(AVLNode *x) {
    AVLNode *y = x->right;
    AVLNode *T2 = y->left;
    
    // Perform rotation
    y->left = x;
    x->right = T2;
    
    // Update heights
    update_height(x);
    update_height(y);
    
    // Return new root
    return y;
}

// Insert node in AVL tree
AVLNode* insert_avl(AVLNode *root, int data) {
    // 1. Perform normal BST insertion
    if (root == NULL) {
        return create_avl_node(data);
    }
    
    if (data < root->data) {
        root->left = insert_avl(root->left, data);
    } else if (data > root->data) {
        root->right = insert_avl(root->right, data);
    } else {
        // Equal keys not allowed
        return root;
    }
    
    // 2. Update height of this ancestor node
    update_height(root);
    
    // 3. Get balance factor
    int balance = get_balance(root);
    
    // 4. If unbalanced, perform rotations
    
    // Left Left Case
    if (balance > 1 && data < root->left->data) {
        return right_rotate(root);
    }
    
    // Right Right Case
    if (balance < -1 && data > root->right->data) {
        return left_rotate(root);
    }
    
    // Left Right Case
    if (balance > 1 && data > root->left->data) {
        root->left = left_rotate(root->left);
        return right_rotate(root);
    }
    
    // Right Left Case
    if (balance < -1 && data < root->right->data) {
        root->right = right_rotate(root->right);
        return left_rotate(root);
    }
    
    // Return unchanged node pointer
    return root;
}

// Find node with minimum value
AVLNode* find_min_avl(AVLNode *root) {
    if (root == NULL) return NULL;
    
    while (root->left != NULL) {
        root = root->left;
    }
    
    return root;
}

// Delete node from AVL tree
AVLNode* delete_avl(AVLNode *root, int data) {
    // 1. Perform standard BST deletion
    if (root == NULL) return root;
    
    if (data < root->data) {
        root->left = delete_avl(root->left, data);
    } else if (data > root->data) {
        root->right = delete_avl(root->right, data);
    } else {
        // Node to be deleted found
        if (root->left == NULL || root->right == NULL) {
            AVLNode *temp = root->left ? root->left : root->right;
            
            if (temp == NULL) {
                temp = root;
                root = NULL;
            } else {
                *root = *temp;
            }
            
            free(temp);
        } else {
            AVLNode *temp = find_min_avl(root->right);
            root->data = temp->data;
            root->right = delete_avl(root->right, temp->data);
        }
    }
    
    if (root == NULL) return root;
    
    // 2. Update height of current node
    update_height(root);
    
    // 3. Get balance factor
    int balance = get_balance(root);
    
    // 4. If unbalanced, perform rotations
    
    // Left Left Case
    if (balance > 1 && get_balance(root->left) >= 0) {
        return right_rotate(root);
    }
    
    // Left Right Case
    if (balance > 1 && get_balance(root->left) < 0) {
        root->left = left_rotate(root->left);
        return right_rotate(root);
    }
    
    // Right Right Case
    if (balance < -1 && get_balance(root->right) <= 0) {
        return left_rotate(root);
    }
    
    // Right Left Case
    if (balance < -1 && get_balance(root->right) > 0) {
        root->right = right_rotate(root->right);
        return left_rotate(root);
    }
    
    return root;
}

// Search in AVL tree
AVLNode* search_avl(AVLNode *root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search_avl(root->left, data);
    } else {
        return search_avl(root->right, data);
    }
}

// Inorder traversal
void inorder_avl(AVLNode *root) {
    if (root == NULL) return;
    
    inorder_avl(root->left);
    printf("%d ", root->data);
    inorder_avl(root->right);
}

// Check if tree is balanced
bool is_balanced(AVLNode *root) {
    if (root == NULL) return true;
    
    int balance = get_balance(root);
    if (abs(balance) > 1) return false;
    
    return is_balanced(root->left) && is_balanced(root->right);
}

int main() {
    AVLNode *root = NULL;
    
    // Insert nodes
    int values[] = {10, 20, 30, 40, 50, 25};
    int n = sizeof(values) / sizeof(values[0]);
    
    printf("Inserting values: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", values[i]);
        root = insert_avl(root, values[i]);
    }
    printf("\n");
    
    printf("AVL tree inorder traversal: ");
    inorder_avl(root);
    printf("\n");
    
    printf("Is tree balanced: %s\n", is_balanced(root) ? "Yes" : "No");
    printf("Root height: %d\n", get_height(root));
    
    // Search operations
    int search_values[] = {25, 35, 60};
    for (int i = 0; i < 3; i++) {
        AVLNode *found = search_avl(root, search_values[i]);
        printf("Search %d: %s\n", search_values[i], 
               found ? "Found" : "Not found");
    }
    
    // Delete operations
    printf("Deleting 30...\n");
    root = delete_avl(root, 30);
    printf("AVL tree after deletion: ");
    inorder_avl(root);
    printf("\n");
    
    printf("Is tree balanced: %s\n", is_balanced(root) ? "Yes" : "No");
    printf("Root height: %d\n", get_height(root));
    
    free_avl(root);
    return 0;
}
```

## Red-Black Trees

Red-black trees are another type of self-balancing binary search tree with additional properties that ensure the tree remains approximately balanced during insertions and deletions.

### Red-Black Tree Properties

1. Every node is either red or black
2. The root is black
3. All leaves (NIL nodes) are black
4. If a node is red, both its children are black
5. Every path from a node to its descendant leaves contains the same number of black nodes

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef enum { RED, BLACK } Color;

typedef struct RBNode {
    int data;
    Color color;
    struct RBNode *left;
    struct RBNode *right;
    struct RBNode *parent;
} RBNode;

// Global NIL node (sentinel)
RBNode *NIL;

// Initialize NIL node
void init_nil(void) {
    NIL = malloc(sizeof(RBNode));
    NIL->color = BLACK;
    NIL->left = NIL->right = NIL->parent = NULL;
}

// Create new red-black node
RBNode* create_rb_node(int data) {
    RBNode *node = malloc(sizeof(RBNode));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->color = RED;  // New nodes are red by default
    node->left = node->right = node->parent = NIL;
    return node;
}

// Free red-black tree
void free_rb_tree(RBNode *root) {
    if (root == NULL || root == NIL) return;
    
    free_rb_tree(root->left);
    free_rb_tree(root->right);
    free(root);
}

// Left rotate
void left_rotate(RBNode **root, RBNode *x) {
    RBNode *y = x->right;
    
    // Turn y's left subtree into x's right subtree
    x->right = y->left;
    if (y->left != NIL) {
        y->left->parent = x;
    }
    
    // Link x's parent to y
    y->parent = x->parent;
    if (x->parent == NIL) {
        *root = y;
    } else if (x == x->parent->left) {
        x->parent->left = y;
    } else {
        x->parent->right = y;
    }
    
    // Put x on y's left
    y->left = x;
    x->parent = y;
}

// Right rotate
void right_rotate(RBNode **root, RBNode *y) {
    RBNode *x = y->left;
    
    // Turn x's right subtree into y's left subtree
    y->left = x->right;
    if (x->right != NIL) {
        x->right->parent = y;
    }
    
    // Link y's parent to x
    x->parent = y->parent;
    if (y->parent == NIL) {
        *root = x;
    } else if (y == y->parent->right) {
        y->parent->right = x;
    } else {
        y->parent->left = x;
    }
    
    // Put y on x's right
    x->right = y;
    y->parent = x;
}

// Fixup after insertion
void insert_fixup(RBNode **root, RBNode *z) {
    while (z->parent->color == RED) {
        if (z->parent == z->parent->parent->left) {
            RBNode *y = z->parent->parent->right;
            
            if (y->color == RED) {
                // Case 1: Uncle is red
                z->parent->color = BLACK;
                y->color = BLACK;
                z->parent->parent->color = RED;
                z = z->parent->parent;
            } else {
                if (z == z->parent->right) {
                    // Case 2: Uncle is black and z is right child
                    z = z->parent;
                    left_rotate(root, z);
                }
                // Case 3: Uncle is black and z is left child
                z->parent->color = BLACK;
                z->parent->parent->color = RED;
                right_rotate(root, z->parent->parent);
            }
        } else {
            RBNode *y = z->parent->parent->left;
            
            if (y->color == RED) {
                // Case 1: Uncle is red
                z->parent->color = BLACK;
                y->color = BLACK;
                z->parent->parent->color = RED;
                z = z->parent->parent;
            } else {
                if (z == z->parent->left) {
                    // Case 2: Uncle is black and z is left child
                    z = z->parent;
                    right_rotate(root, z);
                }
                // Case 3: Uncle is black and z is right child
                z->parent->color = BLACK;
                z->parent->parent->color = RED;
                left_rotate(root, z->parent->parent);
            }
        }
    }
    (*root)->color = BLACK;
}

// Insert node in red-black tree
RBNode* insert_rb(RBNode **root, int data) {
    RBNode *z = create_rb_node(data);
    if (z == NULL) return NULL;
    
    RBNode *y = NIL;
    RBNode *x = *root;
    
    // Find insertion point
    while (x != NIL) {
        y = x;
        if (z->data < x->data) {
            x = x->left;
        } else {
            x = x->right;
        }
    }
    
    z->parent = y;
    if (y == NIL) {
        *root = z;
    } else if (z->data < y->data) {
        y->left = z;
    } else {
        y->right = z;
    }
    
    // Fix red-black properties
    insert_fixup(root, z);
    
    return z;
}

// Inorder traversal
void inorder_rb(RBNode *root) {
    if (root == NULL || root == NIL) return;
    
    inorder_rb(root->left);
    printf("%d(%s) ", root->data, root->color == RED ? "R" : "B");
    inorder_rb(root->right);
}

int main() {
    init_nil();
    
    RBNode *root = NIL;
    
    // Insert nodes
    int values[] = {7, 3, 18, 10, 22, 8, 11, 26};
    int n = sizeof(values) / sizeof(values[0]);
    
    printf("Inserting values into red-black tree: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", values[i]);
        insert_rb(&root, values[i]);
    }
    printf("\n");
    
    printf("Red-black tree inorder traversal: ");
    inorder_rb(root);
    printf("\n");
    
    free_rb_tree(root);
    free(NIL);
    return 0;
}
```

## B-Trees

B-trees are balanced tree data structures that maintain sorted data and allow for efficient insertion, deletion, and search operations. They are commonly used in databases and file systems.

### B-Tree Implementation (Simplified)

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

#define T 3  // Minimum degree

typedef struct BTreeNode {
    int n;                    // Number of keys
    int keys[2 * T - 1];      // Array of keys
    struct BTreeNode *children[2 * T];  // Array of child pointers
    bool leaf;                // True if node is leaf
} BTreeNode;

// Create new B-tree node
BTreeNode* create_btree_node(bool leaf) {
    BTreeNode *node = malloc(sizeof(BTreeNode));
    if (node == NULL) return NULL;
    
    node->n = 0;
    node->leaf = leaf;
    
    for (int i = 0; i < 2 * T; i++) {
        node->children[i] = NULL;
    }
    
    return node;
}

// Search for key in B-tree
BTreeNode* search_btree(BTreeNode *root, int key) {
    int i = 0;
    while (i < root->n && key > root->keys[i]) {
        i++;
    }
    
    if (i < root->n && key == root->keys[i]) {
        return root;
    }
    
    if (root->leaf) {
        return NULL;
    }
    
    return search_btree(root->children[i], key);
}

// Split child node
void split_child(BTreeNode *parent, int i, BTreeNode *child) {
    BTreeNode *z = create_btree_node(child->leaf);
    z->n = T - 1;
    
    // Copy the last T-1 keys of child to z
    for (int j = 0; j < T - 1; j++) {
        z->keys[j] = child->keys[j + T];
    }
    
    // Copy the last T children of child to z
    if (!child->leaf) {
        for (int j = 0; j < T; j++) {
            z->children[j] = child->children[j + T];
        }
    }
    
    child->n = T - 1;
    
    // Shift parent's children to make space for z
    for (int j = parent->n; j >= i + 1; j--) {
        parent->children[j + 1] = parent->children[j];
    }
    
    parent->children[i + 1] = z;
    
    // Shift parent's keys to make space
    for (int j = parent->n - 1; j >= i; j--) {
        parent->keys[j + 1] = parent->keys[j];
    }
    
    parent->keys[i] = child->keys[T - 1];
    parent->n++;
}

// Insert non-full node
void insert_non_full(BTreeNode *node, int key) {
    int i = node->n - 1;
    
    if (node->leaf) {
        // Find location to insert key and shift keys
        while (i >= 0 && node->keys[i] > key) {
            node->keys[i + 1] = node->keys[i];
            i--;
        }
        
        node->keys[i + 1] = key;
        node->n++;
    } else {
        // Find child to recurse on
        while (i >= 0 && node->keys[i] > key) {
            i--;
        }
        i++;
        
        // Split child if it's full
        if (node->children[i]->n == 2 * T - 1) {
            split_child(node, i, node->children[i]);
            
            if (node->keys[i] < key) {
                i++;
            }
        }
        
        insert_non_full(node->children[i], key);
    }
}

// Insert key in B-tree
BTreeNode* insert_btree(BTreeNode *root, int key) {
    if (root == NULL) {
        root = create_btree_node(true);
        root->keys[0] = key;
        root->n = 1;
        return root;
    }
    
    // If root is full, split it
    if (root->n == 2 * T - 1) {
        BTreeNode *new_root = create_btree_node(false);
        new_root->children[0] = root;
        split_child(new_root, 0, root);
        
        int i = 0;
        if (new_root->keys[0] < key) {
            i++;
        }
        
        insert_non_full(new_root->children[i], key);
        return new_root;
    } else {
        insert_non_full(root, key);
        return root;
    }
}

// Print B-tree
void print_btree(BTreeNode *root, int level) {
    if (root == NULL) return;
    
    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    
    printf("Level %d: [", level);
    for (int i = 0; i < root->n; i++) {
        printf("%d ", root->keys[i]);
    }
    printf("]\n");
    
    if (!root->leaf) {
        for (int i = 0; i <= root->n; i++) {
            print_btree(root->children[i], level + 1);
        }
    }
}

int main() {
    BTreeNode *root = NULL;
    
    // Insert nodes
    int values[] = {10, 20, 5, 6, 12, 30, 7, 17};
    int n = sizeof(values) / sizeof(values[0]);
    
    printf("Inserting values into B-tree: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", values[i]);
        root = insert_btree(root, values[i]);
    }
    printf("\n\n");
    
    printf("B-tree structure:\n");
    print_btree(root, 0);
    
    // Search operations
    int search_values[] = {6, 15, 17};
    for (int i = 0; i < 3; i++) {
        BTreeNode *found = search_btree(root, search_values[i]);
        printf("Search %d: %s\n", search_values[i], 
               found ? "Found" : "Not found");
    }
    
    return 0;
}
```

## Practical Examples

### File System Directory Tree

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct DirectoryNode {
    char name[100];
    bool is_directory;
    long size;  // For files
    struct DirectoryNode *first_child;
    struct DirectoryNode *next_sibling;
} DirectoryNode;

// Create new directory node
DirectoryNode* create_directory_node(const char *name, bool is_dir, long size) {
    DirectoryNode *node = malloc(sizeof(DirectoryNode));
    if (node == NULL) return NULL;
    
    strncpy(node->name, name, sizeof(node->name) - 1);
    node->name[sizeof(node->name) - 1] = '\0';
    node->is_directory = is_dir;
    node->size = size;
    node->first_child = NULL;
    node->next_sibling = NULL;
    
    return node;
}

// Add child to directory
void add_child(DirectoryNode *parent, DirectoryNode *child) {
    if (parent->first_child == NULL) {
        parent->first_child = child;
    } else {
        DirectoryNode *current = parent->first_child;
        while (current->next_sibling != NULL) {
            current = current->next_sibling;
        }
        current->next_sibling = child;
    }
}

// Print directory tree
void print_directory_tree(DirectoryNode *root, int level) {
    if (root == NULL) return;
    
    for (int i = 0; i < level; i++) {
        printf("  ");
    }
    
    if (root->is_directory) {
        printf("[%s]\n", root->name);
    } else {
        printf("%s (%ld bytes)\n", root->name, root->size);
    }
    
    // Print children
    DirectoryNode *child = root->first_child;
    while (child != NULL) {
        print_directory_tree(child, level + 1);
        child = child->next_sibling;
    }
}

// Calculate directory size
long calculate_directory_size(DirectoryNode *root) {
    if (root == NULL) return 0;
    
    if (!root->is_directory) {
        return root->size;
    }
    
    long total_size = 0;
    DirectoryNode *child = root->first_child;
    while (child != NULL) {
        total_size += calculate_directory_size(child);
        child = child->next_sibling;
    }
    
    return total_size;
}

// Find file by name
DirectoryNode* find_file(DirectoryNode *root, const char *name) {
    if (root == NULL) return NULL;
    
    if (strcmp(root->name, name) == 0) {
        return root;
    }
    
    // Search in children
    DirectoryNode *child = root->first_child;
    while (child != NULL) {
        DirectoryNode *found = find_file(child, name);
        if (found != NULL) {
            return found;
        }
        child = child->next_sibling;
    }
    
    return NULL;
}

int main() {
    // Create file system structure
    DirectoryNode *root = create_directory_node("root", true, 0);
    
    // Create directories
    DirectoryNode *home = create_directory_node("home", true, 0);
    DirectoryNode *usr = create_directory_node("usr", true, 0);
    DirectoryNode *john = create_directory_node("john", true, 0);
    DirectoryNode *documents = create_directory_node("documents", true, 0);
    DirectoryNode *pictures = create_directory_node("pictures", true, 0);
    
    // Create files
    DirectoryNode *file1 = create_directory_node("readme.txt", false, 1024);
    DirectoryNode *file2 = create_directory_node("report.pdf", false, 204800);
    DirectoryNode *file3 = create_directory_node("photo.jpg", false, 512000);
    DirectoryNode *file4 = create_directory_node("vacation.png", false, 1024000);
    
    // Build tree structure
    add_child(root, home);
    add_child(root, usr);
    add_child(home, john);
    add_child(john, documents);
    add_child(john, pictures);
    add_child(documents, file1);
    add_child(documents, file2);
    add_child(pictures, file3);
    add_child(pictures, file4);
    
    // Print directory tree
    printf("File System Directory Tree:\n");
    print_directory_tree(root, 0);
    
    // Calculate sizes
    printf("\nDirectory Sizes:\n");
    printf("Root directory size: %ld bytes\n", calculate_directory_size(root));
    printf("John's directory size: %ld bytes\n", calculate_directory_size(john));
    printf("Documents directory size: %ld bytes\n", calculate_directory_size(documents));
    
    // Find files
    printf("\nFile Search:\n");
    DirectoryNode *found = find_file(root, "photo.jpg");
    if (found) {
        printf("Found file: %s (%ld bytes)\n", found->name, found->size);
    } else {
        printf("File not found\n");
    }
    
    return 0;
}
```

## Summary

Tree structures are essential data structures in computer science with various applications:

1. **Binary Trees**: Basic hierarchical structure with at most two children per node
2. **Binary Search Trees**: Ordered binary trees with efficient search, insert, and delete operations
3. **AVL Trees**: Self-balancing BSTs that maintain O(log n) operations
4. **Red-Black Trees**: Another self-balancing BST with relaxed balancing requirements
5. **B-Trees**: Multi-way trees optimized for disk storage and databases

Key properties and considerations:

- **Time Complexity**: 
  - BST (unbalanced): O(n) worst case, O(log n) average
  - Balanced trees (AVL, Red-Black): O(log n) guaranteed
  - B-Trees: O(log n) with better cache performance

- **Space Complexity**: O(n) for n nodes

- **Use Cases**:
  - BST: Expression trees, decision trees
  - AVL/Red-Black: In-memory databases, symbol tables
  - B-Trees: File systems, database indexes

Understanding tree structures and their variations is crucial for efficient data organization and retrieval in complex applications.