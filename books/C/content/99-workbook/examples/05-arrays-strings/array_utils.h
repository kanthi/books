#ifndef ARRAY_UTILS_H
#define ARRAY_UTILS_H

// Function prototypes for array utilities
void print_int_array(int arr[], int size);
void print_double_array(double arr[], int size);
int find_max(int arr[], int size);
int find_min(int arr[], int size);
double calculate_average(double arr[], int size);
void bubble_sort(int arr[], int size);
int linear_search(int arr[], int size, int target);
int binary_search(int arr[], int size, int target);
void reverse_array(int arr[], int size);
int sum_array(int arr[], int size);

#endif // ARRAY_UTILS_H