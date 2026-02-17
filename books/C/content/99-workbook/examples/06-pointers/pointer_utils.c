#include "pointer_utils.h"
#include <stdio.h>
#include <stdlib.h>

// Swap two integers using pointers
void swap_int(int *a, int *b) {
    if (a == NULL || b == NULL) return;
    
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Print array using pointer notation
void print_array_ptr(int *arr, int size) {
    if (arr == NULL) return;
    
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", *(arr + i));
        if (i < size - 1) {
            printf(", ");
        }
    }
    printf("]\n");
}

// Find maximum element and return pointer to it
int *find_max_ptr(int *arr, int size) {
    if (arr == NULL || size <= 0) return NULL;
    
    int *max_ptr = arr;
    for (int i = 1; i < size; i++) {
        if (*(arr + i) > *max_ptr) {
            max_ptr = arr + i;
        }
    }
    return max_ptr;
}

// Increment value pointed to by pointer
void increment_ptr(int *ptr) {
    if (ptr != NULL) {
        (*ptr)++;
    }
}

// Allocate memory for integer array
int *allocate_array(int size) {
    if (size <= 0) return NULL;
    
    int *arr = (int*)malloc(size * sizeof(int));
    if (arr == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    // Initialize array elements to zero
    for (int i = 0; i < size; i++) {
        arr[i] = 0;
    }
    
    return arr;
}

// Free allocated array memory
void free_array(int *arr) {
    if (arr != NULL) {
        free(arr);
    }
}

// Demonstrate pointer arithmetic
void pointer_arithmetic_demo(void) {
    int arr[] = {10, 20, 30, 40, 50};
    int size = sizeof(arr) / sizeof(arr[0]);
    int *ptr = arr; // Points to first element
    
    printf("Pointer arithmetic demonstration:\n");
    for (int i = 0; i < size; i++) {
        printf("Element %d: value=%d, address=%p\n", i, *ptr, (void*)ptr);
        ptr++; // Move to next element
    }
}