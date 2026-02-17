#ifndef POINTER_UTILS_H
#define POINTER_UTILS_H

// Function prototypes for pointer utilities
void swap_int(int *a, int *b);
void print_array_ptr(int *arr, int size);
int *find_max_ptr(int *arr, int size);
void increment_ptr(int *ptr);
int *allocate_array(int size);
void free_array(int *arr);
void pointer_arithmetic_demo(void);

#endif // POINTER_UTILS_H