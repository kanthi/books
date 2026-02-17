# Arrays

## Introduction

Arrays are fundamental data structures in C that allow you to store multiple values of the same type in a contiguous block of memory. They provide an efficient way to organize and access collections of data, making them essential for many programming tasks. Understanding arrays is crucial for C programmers as they form the basis for more complex data structures and algorithms.

## Array Declaration and Initialization

### Basic Array Declaration
Arrays are declared by specifying the data type, followed by the array name and the size in square brackets:

```c
int numbers[10];        // Array of 10 integers
float temperatures[7];   // Array of 7 floats
char letters[26];       // Array of 26 characters
```

### Array Initialization
Arrays can be initialized at the time of declaration:

```c
// Initialize all elements
int numbers[5] = {1, 2, 3, 4, 5};

// Partial initialization (remaining elements set to 0)
int values[10] = {1, 2, 3};

// Initialize all elements to 0
int zeros[5] = {0};

// Designated initializers (C99)
int array[10] = {[0] = 1, [5] = 10, [9] = 5};

// Omit size for automatic sizing
int primes[] = {2, 3, 5, 7, 11, 13};
```

### Constant Arrays
Arrays can be declared as constant to prevent modification:

```c
const int DAYS_IN_MONTH[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
```

## Array Access and Indexing

### Array Indexing
Array elements are accessed using zero-based indexing:

```c
int numbers[5] = {10, 20, 30, 40, 50};

// Access individual elements
printf("First element: %d\n", numbers[0]);   // 10
printf("Third element: %d\n", numbers[2]);   // 30
printf("Last element: %d\n", numbers[4]);    // 50

// Modify elements
numbers[1] = 25;
numbers[3] = numbers[0] + numbers[2];
```

### Bounds Checking
C does not perform automatic bounds checking, so accessing elements outside the array bounds leads to undefined behavior:

```c
int array[5] = {1, 2, 3, 4, 5};

// Valid access
array[0] = 10;  // OK
array[4] = 50;  // OK

// Invalid access - undefined behavior
array[-1] = 5;   // Dangerous!
array[10] = 100; // Dangerous!
```

## Array Traversal

### Using For Loops
Arrays are commonly traversed using for loops:

```c
int numbers[5] = {1, 2, 3, 4, 5};
int size = 5;

// Forward traversal
for (int i = 0; i < size; i++) {
    printf("Element %d: %d\n", i, numbers[i]);
}

// Backward traversal
for (int i = size - 1; i >= 0; i--) {
    printf("Element %d: %d\n", i, numbers[i]);
}
```

### Using While Loops
While loops can also be used for array traversal:

```c
int numbers[5] = {1, 2, 3, 4, 5};
int i = 0;

while (i < 5) {
    printf("Element %d: %d\n", i, numbers[i]);
    i++;
}
```

### Enhanced For Loop (C99)
C99 allows variable declarations in for loop initializers:

```c
int numbers[5] = {1, 2, 3, 4, 5};

for (int i = 0; i < 5; i++) {
    printf("Element %d: %d\n", i, numbers[i]);
}
```

## Array Size and sizeof Operator

### Determining Array Size
The sizeof operator can be used to determine the size of an array:

```c
int numbers[10];
int size = sizeof(numbers) / sizeof(numbers[0]);
printf("Array size: %d elements\n", size);

// For arrays passed to functions, sizeof returns pointer size
void function(int arr[]) {
    // This will NOT give the array size!
    int size = sizeof(arr) / sizeof(arr[0]);  // Size of pointer, not array!
}
```

### Array Size Macro
A common pattern is to define a macro for array size:

```c
#define ARRAY_SIZE(arr) (sizeof(arr) / sizeof((arr)[0]))

int numbers[10];
printf("Array size: %d\n", ARRAY_SIZE(numbers));
```

## Common Array Operations

### Finding Maximum and Minimum
```c
int find_max(int arr[], int size) {
    if (size <= 0) return 0;
    
    int max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

int find_min(int arr[], int size) {
    if (size <= 0) return 0;
    
    int min = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}
```

### Array Sum and Average
```c
int array_sum(int arr[], int size) {
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return sum;
}

double array_average(int arr[], int size) {
    if (size <= 0) return 0.0;
    
    int sum = array_sum(arr, size);
    return (double)sum / size;
}
```

### Array Copying
```c
void array_copy(int source[], int destination[], int size) {
    for (int i = 0; i < size; i++) {
        destination[i] = source[i];
    }
}
```

### Array Reversal
```c
void array_reverse(int arr[], int size) {
    for (int i = 0; i < size / 2; i++) {
        int temp = arr[i];
        arr[i] = arr[size - 1 - i];
        arr[size - 1 - i] = temp;
    }
}
```

## Array Algorithms

### Linear Search
```c
int linear_search(int arr[], int size, int target) {
    for (int i = 0; i < size; i++) {
        if (arr[i] == target) {
            return i;  // Return index if found
        }
    }
    return -1;  // Return -1 if not found
}
```

### Bubble Sort
```c
void bubble_sort(int arr[], int size) {
    for (int i = 0; i < size - 1; i++) {
        for (int j = 0; j < size - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                // Swap elements
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}
```

### Selection Sort
```c
void selection_sort(int arr[], int size) {
    for (int i = 0; i < size - 1; i++) {
        int min_index = i;
        
        // Find the minimum element in remaining array
        for (int j = i + 1; j < size; j++) {
            if (arr[j] < arr[min_index]) {
                min_index = j;
            }
        }
        
        // Swap the found minimum element with the first element
        if (min_index != i) {
            int temp = arr[i];
            arr[i] = arr[min_index];
            arr[min_index] = temp;
        }
    }
}
```

## Array Pitfalls and Best Practices

### Buffer Overflow Prevention
Always ensure array accesses are within bounds:

```c
int numbers[10];

// Safe access
for (int i = 0; i < 10; i++) {
    numbers[i] = i;
}

// Unsafe access - potential buffer overflow
for (int i = 0; i < 15; i++) {  // Dangerous!
    numbers[i] = i;
}
```

### Array Decay to Pointers
When passed to functions, arrays decay to pointers:

```c
void print_array(int arr[], int size) {  // arr is actually a pointer
    // sizeof(arr) returns pointer size, not array size
    for (int i = 0; i < size; i++) {     // Must pass size separately
        printf("%d ", arr[i]);
    }
    printf("\n");
}
```

### Initialization Best Practices
```c
// Good: Initialize all elements
int numbers[10] = {0};

// Good: Use designated initializers for sparse arrays
int sparse[100] = {[0] = 1, [50] = 2, [99] = 3};

// Good: Use const for read-only arrays
const int DAYS[] = {31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31};
```

## Practical Examples

### Temperature Data Analysis
```c
#include <stdio.h>

#define DAYS 7

int main() {
    float temperatures[DAYS];
    
    // Input temperatures
    printf("Enter temperatures for %d days:\n", DAYS);
    for (int i = 0; i < DAYS; i++) {
        printf("Day %d: ", i + 1);
        scanf("%f", &temperatures[i]);
    }
    
    // Calculate statistics
    float sum = 0;
    float max = temperatures[0];
    float min = temperatures[0];
    
    for (int i = 0; i < DAYS; i++) {
        sum += temperatures[i];
        if (temperatures[i] > max) max = temperatures[i];
        if (temperatures[i] < min) min = temperatures[i];
    }
    
    float average = sum / DAYS;
    
    // Output results
    printf("\nTemperature Analysis:\n");
    printf("Average: %.2f°C\n", average);
    printf("Maximum: %.2f°C\n", max);
    printf("Minimum: %.2f°C\n", min);
    
    return 0;
}
```

### Student Grade Management
```c
#include <stdio.h>
#include <string.h>

#define STUDENTS 5
#define NAME_LENGTH 50

int main() {
    char names[STUDENTS][NAME_LENGTH];
    float grades[STUDENTS];
    
    // Input student data
    printf("Enter student data:\n");
    for (int i = 0; i < STUDENTS; i++) {
        printf("Student %d name: ", i + 1);
        scanf("%s", names[i]);
        printf("Student %d grade: ", i + 1);
        scanf("%f", &grades[i]);
    }
    
    // Find top student
    int top_student = 0;
    for (int i = 1; i < STUDENTS; i++) {
        if (grades[i] > grades[top_student]) {
            top_student = i;
        }
    }
    
    // Output results
    printf("\nTop Student: %s with grade %.2f\n", 
           names[top_student], grades[top_student]);
    
    // Calculate class average
    float sum = 0;
    for (int i = 0; i < STUDENTS; i++) {
        sum += grades[i];
    }
    float average = sum / STUDENTS;
    printf("Class Average: %.2f\n", average);
    
    return 0;
}
```

## Summary

Arrays are fundamental data structures in C that provide efficient storage and access to collections of data. Key points to remember:

1. **Declaration and Initialization**: Arrays must be declared with a fixed size and can be initialized at declaration
2. **Zero-based Indexing**: Array elements are accessed using indices starting from 0
3. **Bounds Checking**: C does not perform automatic bounds checking, so programmer must ensure safe access
4. **Array Traversal**: Commonly done using for loops with proper bounds
5. **Size Determination**: Use sizeof operator carefully, especially when passing arrays to functions
6. **Common Operations**: Searching, sorting, copying, and mathematical operations
7. **Best Practices**: Initialize arrays, check bounds, and use const for read-only data

Understanding arrays is crucial for C programming as they form the foundation for more complex data structures and algorithms.