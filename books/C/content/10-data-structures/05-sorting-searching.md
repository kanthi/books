# Sorting and Searching

## Introduction

Sorting and searching are fundamental operations in computer science that are used extensively in software development. Sorting arranges data in a specific order, making it easier to search, analyze, and process. Searching finds specific elements within a dataset, which is essential for data retrieval and manipulation.

In this chapter, we'll explore various sorting algorithms including comparison-based and non-comparison-based approaches, as well as different searching techniques. We'll implement these algorithms in C and analyze their time and space complexity.

## Comparison-Based Sorting Algorithms

### Bubble Sort

Bubble sort repeatedly steps through the list, compares adjacent elements, and swaps them if they're in the wrong order.

```c
#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <time.h>

// Bubble sort implementation
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        bool swapped = false;
        
        // Last i elements are already in place
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap elements
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = true;
            }
        }
        
        // If no swapping occurred, array is sorted
        if (!swapped) {
            break;
        }
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {64, 34, 25, 12, 22, 11, 90};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    bubble_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Selection Sort

Selection sort finds the minimum element from the unsorted part and places it at the beginning.

```c
#include <stdio.h>

// Selection sort implementation
void selection_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        // Find the minimum element in the remaining unsorted array
        int min_idx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[min_idx]) {
                min_idx = j;
            }
        }
        
        // Swap the found minimum element with the first element
        if (min_idx != i) {
            int temp = arr[min_idx];
            arr[min_idx] = arr[i];
            arr[i] = temp;
        }
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {64, 25, 12, 22, 11, 90};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    selection_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Insertion Sort

Insertion sort builds the final sorted array one item at a time by inserting each element into its correct position.

```c
#include <stdio.h>

// Insertion sort implementation
void insertion_sort(int arr[], int n) {
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        
        // Move elements greater than key one position ahead
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        
        arr[j + 1] = key;
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {12, 11, 13, 5, 6};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    insertion_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Merge Sort

Merge sort is a divide-and-conquer algorithm that divides the array into halves, sorts them, and then merges them.

```c
#include <stdio.h>
#include <stdlib.h>

// Merge two sorted subarrays
void merge(int arr[], int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    // Create temporary arrays
    int *left_arr = malloc(n1 * sizeof(int));
    int *right_arr = malloc(n2 * sizeof(int));
    
    if (left_arr == NULL || right_arr == NULL) {
        free(left_arr);
        free(right_arr);
        return;
    }
    
    // Copy data to temporary arrays
    for (int i = 0; i < n1; i++) {
        left_arr[i] = arr[left + i];
    }
    for (int i = 0; i < n2; i++) {
        right_arr[i] = arr[mid + 1 + i];
    }
    
    // Merge the temporary arrays back into arr[left..right]
    int i = 0, j = 0, k = left;
    
    while (i < n1 && j < n2) {
        if (left_arr[i] <= right_arr[j]) {
            arr[k] = left_arr[i];
            i++;
        } else {
            arr[k] = right_arr[j];
            j++;
        }
        k++;
    }
    
    // Copy remaining elements of left_arr[], if any
    while (i < n1) {
        arr[k] = left_arr[i];
        i++;
        k++;
    }
    
    // Copy remaining elements of right_arr[], if any
    while (j < n2) {
        arr[k] = right_arr[j];
        j++;
        k++;
    }
    
    free(left_arr);
    free(right_arr);
}

// Merge sort implementation
void merge_sort(int arr[], int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        
        // Sort first and second halves
        merge_sort(arr, left, mid);
        merge_sort(arr, mid + 1, right);
        
        // Merge the sorted halves
        merge(arr, left, mid, right);
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {12, 11, 13, 5, 6, 7};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    merge_sort(arr, 0, n - 1);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Quick Sort

Quick sort is a divide-and-conquer algorithm that picks an element as a pivot and partitions the array around it.

```c
#include <stdio.h>

// Partition function for quick sort
int partition(int arr[], int low, int high) {
    int pivot = arr[high];  // Choose the rightmost element as pivot
    int i = low - 1;        // Index of smaller element
    
    for (int j = low; j < high; j++) {
        // If current element is smaller than or equal to pivot
        if (arr[j] <= pivot) {
            i++;  // Increment index of smaller element
            // Swap arr[i] and arr[j]
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    
    // Swap arr[i+1] and arr[high] (pivot)
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    
    return i + 1;
}

// Quick sort implementation
void quick_sort(int arr[], int low, int high) {
    if (low < high) {
        // Partition the array and get pivot index
        int pi = partition(arr, low, high);
        
        // Recursively sort elements before and after partition
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {10, 7, 8, 9, 1, 5};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    quick_sort(arr, 0, n - 1);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Heap Sort

Heap sort uses a binary heap data structure to sort elements efficiently.

```c
#include <stdio.h>

// Heapify a subtree rooted at index i
void heapify(int arr[], int n, int i) {
    int largest = i;    // Initialize largest as root
    int left = 2 * i + 1;   // Left child
    int right = 2 * i + 2;  // Right child
    
    // If left child is larger than root
    if (left < n && arr[left] > arr[largest]) {
        largest = left;
    }
    
    // If right child is larger than largest so far
    if (right < n && arr[right] > arr[largest]) {
        largest = right;
    }
    
    // If largest is not root
    if (largest != i) {
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;
        
        // Recursively heapify the affected sub-tree
        heapify(arr, n, largest);
    }
}

// Heap sort implementation
void heap_sort(int arr[], int n) {
    // Build heap (rearrange array)
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }
    
    // Extract elements from heap one by one
    for (int i = n - 1; i > 0; i--) {
        // Move current root to end
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;
        
        // Call heapify on the reduced heap
        heapify(arr, i, 0);
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {12, 11, 13, 5, 6, 7};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    heap_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

## Non-Comparison Sorting Algorithms

### Counting Sort

Counting sort counts the occurrences of each element and uses this information to place elements in the correct position.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Counting sort implementation
void counting_sort(int arr[], int n, int max_val) {
    // Create count array to store count of each element
    int *count = calloc(max_val + 1, sizeof(int));
    int *output = malloc(n * sizeof(int));
    
    if (count == NULL || output == NULL) {
        free(count);
        free(output);
        return;
    }
    
    // Store count of each element
    for (int i = 0; i < n; i++) {
        count[arr[i]]++;
    }
    
    // Change count[i] so that count[i] now contains actual
    // position of this element in output array
    for (int i = 1; i <= max_val; i++) {
        count[i] += count[i - 1];
    }
    
    // Build the output array
    for (int i = n - 1; i >= 0; i--) {
        output[count[arr[i]] - 1] = arr[i];
        count[arr[i]]--;
    }
    
    // Copy the output array to arr[], so that arr[] now
    // contains sorted elements
    for (int i = 0; i < n; i++) {
        arr[i] = output[i];
    }
    
    free(count);
    free(output);
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {4, 2, 2, 8, 3, 3, 1};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    // Find maximum value in array
    int max_val = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max_val) {
            max_val = arr[i];
        }
    }
    
    counting_sort(arr, n, max_val);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Radix Sort

Radix sort sorts numbers by processing individual digits, starting from the least significant digit to the most significant.

```c
#include <stdio.h>
#include <stdlib.h>

// Get maximum value in array
int get_max(int arr[], int n) {
    int max = arr[0];
    for (int i = 1; i < n; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

// Counting sort for a particular digit (exp)
void counting_sort_for_radix(int arr[], int n, int exp) {
    int *output = malloc(n * sizeof(int));
    int count[10] = {0};
    
    if (output == NULL) return;
    
    // Store count of occurrences in count[]
    for (int i = 0; i < n; i++) {
        count[(arr[i] / exp) % 10]++;
    }
    
    // Change count[i] so that count[i] now contains actual
    // position of this digit in output[]
    for (int i = 1; i < 10; i++) {
        count[i] += count[i - 1];
    }
    
    // Build the output array
    for (int i = n - 1; i >= 0; i--) {
        output[count[(arr[i] / exp) % 10] - 1] = arr[i];
        count[(arr[i] / exp) % 10]--;
    }
    
    // Copy the output array to arr[], so that arr[] now
    // contains sorted numbers according to current digit
    for (int i = 0; i < n; i++) {
        arr[i] = output[i];
    }
    
    free(output);
}

// Radix sort implementation
void radix_sort(int arr[], int n) {
    // Find the maximum number to know number of digits
    int max = get_max(arr, n);
    
    // Do counting sort for every digit
    for (int exp = 1; max / exp > 0; exp *= 10) {
        counting_sort_for_radix(arr, n, exp);
    }
}

// Print array
void print_array(int arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
}

int main() {
    int arr[] = {170, 45, 75, 90, 2, 802, 24, 66};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    radix_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

### Bucket Sort

Bucket sort distributes elements into buckets and then sorts each bucket individually.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define NUM_BUCKETS 10

typedef struct Node {
    float data;
    struct Node *next;
} Node;

// Create new node
Node* create_node(float data) {
    Node *node = malloc(sizeof(Node));
    if (node == NULL) return NULL;
    
    node->data = data;
    node->next = NULL;
    return node;
}

// Insert node in sorted order
void insert_sorted(Node **head, float data) {
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    // If list is empty or new node should be first
    if (*head == NULL || (*head)->data >= data) {
        new_node->next = *head;
        *head = new_node;
        return;
    }
    
    // Find the node before the point of insertion
    Node *current = *head;
    while (current->next != NULL && current->next->data < data) {
        current = current->next;
    }
    
    new_node->next = current->next;
    current->next = new_node;
}

// Bucket sort implementation
void bucket_sort(float arr[], int n) {
    // Create buckets
    Node *buckets[NUM_BUCKETS];
    for (int i = 0; i < NUM_BUCKETS; i++) {
        buckets[i] = NULL;
    }
    
    // Put array elements in different buckets
    for (int i = 0; i < n; i++) {
        int bucket_index = (int)(arr[i] * NUM_BUCKETS);
        // Handle edge case where arr[i] is 1.0
        if (bucket_index >= NUM_BUCKETS) {
            bucket_index = NUM_BUCKETS - 1;
        }
        insert_sorted(&buckets[bucket_index], arr[i]);
    }
    
    // Concatenate all buckets into arr[]
    int index = 0;
    for (int i = 0; i < NUM_BUCKETS; i++) {
        Node *current = buckets[i];
        while (current != NULL) {
            arr[index++] = current->data;
            Node *temp = current;
            current = current->next;
            free(temp);
        }
    }
}

// Print array
void print_array(float arr[], int n) {
    for (int i = 0; i < n; i++) {
        printf("%.2f ", arr[i]);
    }
    printf("\n");
}

int main() {
    float arr[] = {0.897, 0.565, 0.656, 0.1234, 0.665, 0.3434};
    int n = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, n);
    
    bucket_sort(arr, n);
    
    printf("Sorted array: ");
    print_array(arr, n);
    
    return 0;
}
```

## Searching Algorithms

### Linear Search

Linear search sequentially checks each element until the target is found or the end of the array is reached.

```c
#include <stdio.h>

// Linear search implementation
int linear_search(int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target) {
            return i;  // Return index of found element
        }
    }
    return -1;  // Element not found
}

int main() {
    int arr[] = {10, 20, 80, 30, 60, 50, 110, 100, 130, 170};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 110;
    
    int result = linear_search(arr, n, target);
    
    if (result != -1) {
        printf("Element %d found at index %d\n", target, result);
    } else {
        printf("Element %d not found in array\n", target);
    }
    
    return 0;
}
```

### Binary Search

Binary search works on sorted arrays by repeatedly dividing the search interval in half.

```c
#include <stdio.h>

// Iterative binary search
int binary_search_iterative(int arr[], int n, int target) {
    int left = 0;
    int right = n - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid;  // Element found
        } else if (arr[mid] < target) {
            left = mid + 1;  // Search right half
        } else {
            right = mid - 1;  // Search left half
        }
    }
    
    return -1;  // Element not found
}

// Recursive binary search
int binary_search_recursive(int arr[], int left, int right, int target) {
    if (left > right) {
        return -1;  // Element not found
    }
    
    int mid = left + (right - left) / 2;
    
    if (arr[mid] == target) {
        return mid;  // Element found
    } else if (arr[mid] < target) {
        return binary_search_recursive(arr, mid + 1, right, target);
    } else {
        return binary_search_recursive(arr, left, mid - 1, target);
    }
}

int main() {
    int arr[] = {2, 3, 4, 10, 40, 50, 80};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 10;
    
    printf("Array: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    // Iterative binary search
    int result1 = binary_search_iterative(arr, n, target);
    if (result1 != -1) {
        printf("Element %d found at index %d (iterative)\n", target, result1);
    } else {
        printf("Element %d not found (iterative)\n", target);
    }
    
    // Recursive binary search
    int result2 = binary_search_recursive(arr, 0, n - 1, target);
    if (result2 != -1) {
        printf("Element %d found at index %d (recursive)\n", target, result2);
    } else {
        printf("Element %d not found (recursive)\n", target);
    }
    
    return 0;
}
```

### Interpolation Search

Interpolation search is an improvement over binary search for uniformly distributed sorted arrays.

```c
#include <stdio.h>

// Interpolation search implementation
int interpolation_search(int arr[], int n, int target) {
    int low = 0;
    int high = n - 1;
    
    while (low <= high && target >= arr[low] && target <= arr[high]) {
        // If array has only one element
        if (low == high) {
            if (arr[low] == target) return low;
            return -1;
        }
        
        // Probing the position with keeping uniform distribution in mind
        int pos = low + (((double)(high - low) / (arr[high] - arr[low])) * (target - arr[low]));
        
        // Condition of target found
        if (arr[pos] == target) {
            return pos;
        }
        
        // If target is larger, target is in upper part
        if (arr[pos] < target) {
            low = pos + 1;
        }
        // If target is smaller, target is in lower part
        else {
            high = pos - 1;
        }
    }
    
    return -1;  // Element not found
}

int main() {
    int arr[] = {10, 12, 13, 16, 18, 19, 20, 21, 22, 23, 24, 33, 35, 42, 47};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 18;
    
    printf("Array: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    int result = interpolation_search(arr, n, target);
    
    if (result != -1) {
        printf("Element %d found at index %d\n", target, result);
    } else {
        printf("Element %d not found\n", target);
    }
    
    return 0;
}
```

## Advanced Searching Techniques

### Exponential Search

Exponential search finds the range where the element might be present and then performs binary search in that range.

```c
#include <stdio.h>

// Binary search helper function
int binary_search(int arr[], int left, int right, int target) {
    while (left <= right) {
        int mid = left + (right - left) / 2;
        
        if (arr[mid] == target) {
            return mid;
        } else if (arr[mid] < target) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    return -1;
}

// Exponential search implementation
int exponential_search(int arr[], int n, int target) {
    // If first element is target
    if (arr[0] == target) {
        return 0;
    }
    
    // Find range for binary search by repeated doubling
    int i = 1;
    while (i < n && arr[i] <= target) {
        i *= 2;
    }
    
    // Call binary search for the found range
    return binary_search(arr, i / 2, (i < n) ? i : n - 1, target);
}

int main() {
    int arr[] = {2, 3, 4, 10, 40, 50, 80, 100, 120, 150, 200};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 100;
    
    printf("Array: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    int result = exponential_search(arr, n, target);
    
    if (result != -1) {
        printf("Element %d found at index %d\n", target, result);
    } else {
        printf("Element %d not found\n", target);
    }
    
    return 0;
}
```

### Jump Search

Jump search creates blocks and jumps through them to find the target block, then performs linear search within that block.

```c
#include <stdio.h>
#include <math.h>

// Jump search implementation
int jump_search(int arr[], int n, int target) {
    int step = sqrt(n);
    int prev = 0;
    
    // Finding the block where element is present (if it is present)
    while (arr[(int)fmin(step, n) - 1] < target) {
        prev = step;
        step += sqrt(n);
        if (prev >= n) {
            return -1;
        }
    }
    
    // Doing a linear search for target in block beginning with prev
    while (arr[prev] < target) {
        prev++;
        
        // If we reached next block or end of array, element is not present
        if (prev == fmin(step, n)) {
            return -1;
        }
    }
    
    // If element is found
    if (arr[prev] == target) {
        return prev;
    }
    
    return -1;
}

int main() {
    int arr[] = {0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610};
    int n = sizeof(arr) / sizeof(arr[0]);
    int target = 55;
    
    printf("Array: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    int result = jump_search(arr, n, target);
    
    if (result != -1) {
        printf("Element %d found at index %d\n", target, result);
    } else {
        printf("Element %d not found\n", target);
    }
    
    return 0;
}
```

## Selection Algorithms

### Quickselect (Finding kth Smallest Element)

Quickselect finds the kth smallest element in an unordered list using a partitioning approach similar to quicksort.

```c
#include <stdio.h>
#include <stdlib.h>

// Partition function (same as in quicksort)
int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    
    return i + 1;
}

// Quickselect algorithm to find kth smallest element
int quickselect(int arr[], int low, int high, int k) {
    if (low <= high) {
        // Partition the array and get pivot index
        int pi = partition(arr, low, high);
        
        // If pivot is the kth element
        if (pi == k) {
            return arr[pi];
        }
        // If kth element is in left subarray
        else if (pi > k) {
            return quickselect(arr, low, pi - 1, k);
        }
        // If kth element is in right subarray
        else {
            return quickselect(arr, pi + 1, high, k);
        }
    }
    
    return -1;  // Error case
}

// Find kth smallest element
int find_kth_smallest(int arr[], int n, int k) {
    if (k < 0 || k >= n) {
        return -1;  // Invalid k
    }
    
    // Create a copy of array to avoid modifying original
    int *temp = malloc(n * sizeof(int));
    if (temp == NULL) return -1;
    
    for (int i = 0; i < n; i++) {
        temp[i] = arr[i];
    }
    
    int result = quickselect(temp, 0, n - 1, k);
    free(temp);
    
    return result;
}

int main() {
    int arr[] = {12, 3, 5, 7, 4, 19, 26};
    int n = sizeof(arr) / sizeof(arr[0]);
    int k = 3;  // Find 4th smallest element (0-indexed)
    
    printf("Array: ");
    for (int i = 0; i < n; i++) {
        printf("%d ", arr[i]);
    }
    printf("\n");
    
    int kth_smallest = find_kth_smallest(arr, n, k);
    
    if (kth_smallest != -1) {
        printf("The %dth smallest element is: %d\n", k + 1, kth_smallest);
    } else {
        printf("Invalid k value\n");
    }
    
    return 0;
}
```

## Performance Comparison and Analysis

### Sorting Algorithm Performance Test

```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define ARRAY_SIZE 10000

// Function prototypes
void bubble_sort(int arr[], int n);
void selection_sort(int arr[], int n);
void insertion_sort(int arr[], int n);
void merge_sort(int arr[], int left, int right);
void quick_sort(int arr[], int low, int high);
void heap_sort(int arr[], int n);

// Generate random array
void generate_random_array(int arr[], int n) {
    srand(time(NULL));
    for (int i = 0; i < n; i++) {
        arr[i] = rand() % 1000;
    }
}

// Copy array
void copy_array(int src[], int dest[], int n) {
    for (int i = 0; i < n; i++) {
        dest[i] = src[i];
    }
}

// Test sorting algorithm performance
double test_sorting_algorithm(void (*sort_func)(int[], int), int arr[], int n, const char *name) {
    int *test_arr = malloc(n * sizeof(int));
    if (test_arr == NULL) return -1;
    
    copy_array(arr, test_arr, n);
    
    clock_t start = clock();
    sort_func(test_arr, n);
    clock_t end = clock();
    
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("%-20s: %.6f seconds\n", name, time_taken);
    
    free(test_arr);
    return time_taken;
}

// Test sorting algorithm with range parameters
double test_sorting_algorithm_range(void (*sort_func)(int[], int, int), int arr[], int n, const char *name) {
    int *test_arr = malloc(n * sizeof(int));
    if (test_arr == NULL) return -1;
    
    copy_array(arr, test_arr, n);
    
    clock_t start = clock();
    sort_func(test_arr, 0, n - 1);
    clock_t end = clock();
    
    double time_taken = ((double)(end - start)) / CLOCKS_PER_SEC;
    
    printf("%-20s: %.6f seconds\n", name, time_taken);
    
    free(test_arr);
    return time_taken;
}

// Bubble sort implementation
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        int swapped = 0;
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
                swapped = 1;
            }
        }
        if (!swapped) break;
    }
}

// Selection sort implementation
void selection_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        int min_idx = i;
        for (int j = i + 1; j < n; j++) {
            if (arr[j] < arr[min_idx]) {
                min_idx = j;
            }
        }
        if (min_idx != i) {
            int temp = arr[min_idx];
            arr[min_idx] = arr[i];
            arr[i] = temp;
        }
    }
}

// Insertion sort implementation
void insertion_sort(int arr[], int n) {
    for (int i = 1; i < n; i++) {
        int key = arr[i];
        int j = i - 1;
        while (j >= 0 && arr[j] > key) {
            arr[j + 1] = arr[j];
            j--;
        }
        arr[j + 1] = key;
    }
}

// Merge function for merge sort
void merge(int arr[], int left, int mid, int right) {
    int n1 = mid - left + 1;
    int n2 = right - mid;
    
    int *left_arr = malloc(n1 * sizeof(int));
    int *right_arr = malloc(n2 * sizeof(int));
    
    for (int i = 0; i < n1; i++) {
        left_arr[i] = arr[left + i];
    }
    for (int i = 0; i < n2; i++) {
        right_arr[i] = arr[mid + 1 + i];
    }
    
    int i = 0, j = 0, k = left;
    while (i < n1 && j < n2) {
        if (left_arr[i] <= right_arr[j]) {
            arr[k] = left_arr[i];
            i++;
        } else {
            arr[k] = right_arr[j];
            j++;
        }
        k++;
    }
    
    while (i < n1) {
        arr[k] = left_arr[i];
        i++;
        k++;
    }
    
    while (j < n2) {
        arr[k] = right_arr[j];
        j++;
        k++;
    }
    
    free(left_arr);
    free(right_arr);
}

// Merge sort implementation
void merge_sort(int arr[], int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;
        merge_sort(arr, left, mid);
        merge_sort(arr, mid + 1, right);
        merge(arr, left, mid, right);
    }
}

// Partition function for quick sort
int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = low - 1;
    
    for (int j = low; j < high; j++) {
        if (arr[j] <= pivot) {
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    
    return i + 1;
}

// Quick sort implementation
void quick_sort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

// Heapify function for heap sort
void heapify(int arr[], int n, int i) {
    int largest = i;
    int left = 2 * i + 1;
    int right = 2 * i + 2;
    
    if (left < n && arr[left] > arr[largest]) {
        largest = left;
    }
    
    if (right < n && arr[right] > arr[largest]) {
        largest = right;
    }
    
    if (largest != i) {
        int temp = arr[i];
        arr[i] = arr[largest];
        arr[largest] = temp;
        heapify(arr, n, largest);
    }
}

// Heap sort implementation
void heap_sort(int arr[], int n) {
    for (int i = n / 2 - 1; i >= 0; i--) {
        heapify(arr, n, i);
    }
    
    for (int i = n - 1; i > 0; i--) {
        int temp = arr[0];
        arr[0] = arr[i];
        arr[i] = temp;
        heapify(arr, i, 0);
    }
}

int main() {
    int *original_arr = malloc(ARRAY_SIZE * sizeof(int));
    if (original_arr == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    printf("Generating random array of size %d...\n", ARRAY_SIZE);
    generate_random_array(original_arr, ARRAY_SIZE);
    
    printf("\nSorting Algorithm Performance Comparison:\n");
    printf("========================================\n");
    
    // Test various sorting algorithms
    test_sorting_algorithm(bubble_sort, original_arr, ARRAY_SIZE, "Bubble Sort");
    test_sorting_algorithm(selection_sort, original_arr, ARRAY_SIZE, "Selection Sort");
    test_sorting_algorithm(insertion_sort, original_arr, ARRAY_SIZE, "Insertion Sort");
    test_sorting_algorithm_range(merge_sort, original_arr, ARRAY_SIZE, "Merge Sort");
    test_sorting_algorithm_range(quick_sort, original_arr, ARRAY_SIZE, "Quick Sort");
    test_sorting_algorithm(heap_sort, original_arr, ARRAY_SIZE, "Heap Sort");
    
    free(original_arr);
    return 0;
}
```

## Practical Examples

### Phone Book Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

#define MAX_CONTACTS 1000
#define MAX_NAME_LENGTH 50
#define MAX_PHONE_LENGTH 20

typedef struct {
    char name[MAX_NAME_LENGTH];
    char phone[MAX_PHONE_LENGTH];
} Contact;

typedef struct {
    Contact contacts[MAX_CONTACTS];
    int count;
} PhoneBook;

// Create phone book
PhoneBook* create_phone_book(void) {
    PhoneBook *book = malloc(sizeof(PhoneBook));
    if (book == NULL) return NULL;
    
    book->count = 0;
    return book;
}

// Free phone book
void free_phone_book(PhoneBook *book) {
    free(book);
}

// Add contact to phone book
bool add_contact(PhoneBook *book, const char *name, const char *phone) {
    if (book == NULL || name == NULL || phone == NULL || book->count >= MAX_CONTACTS) {
        return false;
    }
    
    strncpy(book->contacts[book->count].name, name, MAX_NAME_LENGTH - 1);
    book->contacts[book->count].name[MAX_NAME_LENGTH - 1] = '\0';
    
    strncpy(book->contacts[book->count].phone, phone, MAX_PHONE_LENGTH - 1);
    book->contacts[book->count].phone[MAX_PHONE_LENGTH - 1] = '\0';
    
    book->count++;
    return true;
}

// Linear search for contact by name
int search_contact_linear(PhoneBook *book, const char *name) {
    if (book == NULL || name == NULL) return -1;
    
    for (int i = 0; i < book->count; i++) {
        if (strcmp(book->contacts[i].name, name) == 0) {
            return i;
        }
    }
    
    return -1;
}

// Comparison function for sorting contacts by name
int compare_contacts(const void *a, const void *b) {
    const Contact *contact_a = (const Contact *)a;
    const Contact *contact_b = (const Contact *)b;
    return strcmp(contact_a->name, contact_b->name);
}

// Sort phone book by name
void sort_phone_book(PhoneBook *book) {
    if (book == NULL) return;
    
    qsort(book->contacts, book->count, sizeof(Contact), compare_contacts);
}

// Binary search for contact by name (requires sorted phone book)
int search_contact_binary(PhoneBook *book, const char *name) {
    if (book == NULL || name == NULL) return -1;
    
    int left = 0;
    int right = book->count - 1;
    
    while (left <= right) {
        int mid = left + (right - left) / 2;
        int cmp = strcmp(book->contacts[mid].name, name);
        
        if (cmp == 0) {
            return mid;
        } else if (cmp < 0) {
            left = mid + 1;
        } else {
            right = mid - 1;
        }
    }
    
    return -1;
}

// Print all contacts
void print_phone_book(PhoneBook *book) {
    if (book == NULL) return;
    
    printf("Phone Book (%d contacts):\n", book->count);
    printf("========================\n");
    
    for (int i = 0; i < book->count; i++) {
        printf("%-20s: %s\n", book->contacts[i].name, book->contacts[i].phone);
    }
    printf("\n");
}

// Print specific contact
void print_contact(PhoneBook *book, int index) {
    if (book == NULL || index < 0 || index >= book->count) return;
    
    printf("Name: %s\n", book->contacts[index].name);
    printf("Phone: %s\n", book->contacts[index].phone);
}

int main() {
    PhoneBook *book = create_phone_book();
    if (book == NULL) {
        printf("Failed to create phone book\n");
        return 1;
    }
    
    // Add contacts
    add_contact(book, "Alice Johnson", "555-1234");
    add_contact(book, "Bob Smith", "555-5678");
    add_contact(book, "Charlie Brown", "555-9012");
    add_contact(book, "Diana Prince", "555-3456");
    add_contact(book, "Eve Wilson", "555-7890");
    add_contact(book, "Frank Miller", "555-2345");
    add_contact(book, "Grace Lee", "555-6789");
    
    printf("Unsorted phone book:\n");
    print_phone_book(book);
    
    // Linear search
    printf("Linear search for 'Charlie Brown':\n");
    int index = search_contact_linear(book, "Charlie Brown");
    if (index != -1) {
        print_contact(book, index);
    } else {
        printf("Contact not found\n");
    }
    
    // Sort phone book
    printf("\nSorting phone book...\n");
    sort_phone_book(book);
    
    printf("\nSorted phone book:\n");
    print_phone_book(book);
    
    // Binary search
    printf("Binary search for 'Eve Wilson':\n");
    index = search_contact_binary(book, "Eve Wilson");
    if (index != -1) {
        print_contact(book, index);
    } else {
        printf("Contact not found\n");
    }
    
    free_phone_book(book);
    return 0;
}
```

## Summary

Sorting and searching algorithms are fundamental to computer science and software development:

1. **Comparison-Based Sorting**:
   - Bubble Sort: O(n²) time, simple but inefficient
   - Selection Sort: O(n²) time, minimal memory writes
   - Insertion Sort: O(n²) time, efficient for small datasets
   - Merge Sort: O(n log n) time, stable and consistent
   - Quick Sort: O(n log n) average time, in-place sorting
   - Heap Sort: O(n log n) time, in-place and consistent

2. **Non-Comparison Sorting**:
   - Counting Sort: O(n + k) time, for small range integers
   - Radix Sort: O(d × (n + k)) time, for fixed-width integers
   - Bucket Sort: O(n + k) average time, for uniformly distributed data

3. **Searching Algorithms**:
   - Linear Search: O(n) time, works on unsorted data
   - Binary Search: O(log n) time, requires sorted data
   - Interpolation Search: O(log log n) average time, for uniformly distributed data
   - Exponential Search: O(log n) time, for unbounded searches
   - Jump Search: O(√n) time, alternative to binary search

4. **Selection Algorithms**:
   - Quickselect: O(n) average time, finds kth smallest element

Key considerations when choosing algorithms:
- **Data Size**: Small datasets may benefit from simple algorithms
- **Data Distribution**: Uniform distribution enables faster algorithms
- **Memory Constraints**: In-place algorithms save memory
- **Stability Requirements**: Stable sorts preserve relative order
- **Performance Requirements**: Balance time and space complexity

Understanding these algorithms and their trade-offs is essential for:
- Optimizing application performance
- Choosing appropriate data structures
- Implementing efficient algorithms
- Solving complex computational problems
- Passing technical interviews

Mastering sorting and searching techniques provides a strong foundation for advanced algorithmic thinking and problem-solving skills.