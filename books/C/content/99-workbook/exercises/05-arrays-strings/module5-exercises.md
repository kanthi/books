# Module 5: Arrays and Strings Exercises

## Exercise 1: Array Manipulation Functions
Write a program that implements various array manipulation functions:
- A function to find the maximum and minimum values in an array
- A function to calculate the average of array elements
- A function to reverse an array in place
- A function to check if an array is sorted (ascending or descending)
- A function to remove duplicates from an array

**Requirements:**
- Use proper function declarations with array parameters
- Handle edge cases (empty arrays, single element arrays)
- Include appropriate header files
- Provide clear function documentation
- Test with different array sizes and data types

## Exercise 2: Matrix Operations
Create a program that performs various matrix operations:
- Matrix addition and subtraction
- Matrix multiplication
- Transpose of a matrix
- Determinant calculation for 2x2 and 3x3 matrices
- Check if a matrix is symmetric

**Requirements:**
- Use 2D arrays for matrix representation
- Implement proper bounds checking
- Handle memory allocation for dynamic matrices (bonus)
- Include error handling for incompatible matrix operations
- Provide clear output formatting for matrices

## Exercise 3: String Processing Library
Develop a comprehensive string processing library:
- Function to count words in a string
- Function to count vowels and consonants
- Function to reverse words in a string (maintain word order)
- Function to remove extra whitespace
- Function to check if a string is a palindrome

**Requirements:**
- Use proper string handling functions from string.h
- Implement your own versions of common string functions
- Handle edge cases (empty strings, NULL pointers)
- Include memory safety considerations
- Provide examples with various string inputs

## Exercise 4: Dynamic Array Implementation
Create a dynamic array (vector-like) implementation:
- Function to initialize a dynamic array
- Function to add elements (with automatic resizing)
- Function to remove elements by index
- Function to search for elements
- Function to free the dynamic array

**Requirements:**
- Use malloc, realloc, and free for memory management
- Implement proper error handling for memory allocation
- Include capacity and size tracking
- Handle memory leaks properly
- Provide a complete API with clear documentation

## Exercise 5: Multi-dimensional Array Challenges
Solve complex problems using multi-dimensional arrays:
- Implement a simple image processing function (2D array of pixels)
- Create a tic-tac-toe game board with win detection
- Implement a simple maze solver using backtracking
- Create a program to process student grades in a 2D array
- Implement Conway's Game of Life

**Requirements:**
- Use appropriate data structures for each problem
- Include proper initialization and cleanup
- Handle boundary conditions correctly
- Provide clear visualization of results where applicable
- Include performance considerations for large arrays

## Exercise 6: String Search and Replace
Write a program that implements advanced string operations:
- Function to find all occurrences of a substring
- Function to replace all occurrences of a substring
- Function to tokenize a string based on multiple delimiters
- Function to implement a simple pattern matching algorithm
- Function to perform case-insensitive string operations

**Requirements:**
- Handle overlapping matches correctly
- Manage memory allocation for result strings
- Include error checking for invalid inputs
- Optimize for performance where possible
- Provide comprehensive test cases

## Exercise 7: Command Line Argument Processing
Create a program that processes command line arguments effectively:
- Parse command line options and flags
- Handle positional arguments
- Implement a help system with usage information
- Validate argument types and ranges
- Provide meaningful error messages for invalid input

**Requirements:**
- Use argc and argv properly
- Implement both short (-h) and long (--help) options
- Handle combined flags (-abc equivalent to -a -b -c)
- Include default values for optional arguments
- Provide examples of usage

## Exercise 8: Advanced Array and String Integration
Design a complete application that integrates arrays and strings:
- Implement a simple database system using arrays of structures
- Create a text analysis tool that processes multiple files
- Develop a word frequency counter with sorting capabilities
- Implement a simple encryption/decryption system
- Create a program that generates reports from structured data

**Requirements:**
- Use modular design with separate functions for each major task
- Include proper error handling and recovery
- Handle file I/O for data persistence
- Implement sorting and searching algorithms
- Provide clear user interface and output formatting

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <limits.h>

// Function to find maximum value in array
int find_max(int arr[], int size) {
    if (size <= 0) return INT_MIN;
    
    int max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

// Function to find minimum value in array
int find_min(int arr[], int size) {
    if (size <= 0) return INT_MAX;
    
    int min = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}

// Function to calculate average
double calculate_average(int arr[], int size) {
    if (size <= 0) return 0.0;
    
    long long sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return (double)sum / size;
}

int main() {
    int numbers[] = {5, 2, 8, 1, 9, 3};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("Array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    printf("Maximum: %d\n", find_max(numbers, size));
    printf("Minimum: %d\n", find_min(numbers, size));
    printf("Average: %.2f\n", calculate_average(numbers, size));
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Function to count words in a string
int count_words(const char *str) {
    if (str == NULL) return 0;
    
    int count = 0;
    int in_word = 0;
    
    for (int i = 0; str[i] != '\0'; i++) {
        if (isspace(str[i])) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            count++;
        }
    }
    return count;
}

// Function to check if string is palindrome
int is_palindrome(const char *str) {
    if (str == NULL) return 0;
    
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - 1 - i])) {
            return 0;
        }
    }
    return 1;
}

int main() {
    char text1[] = "Hello world, this is a test string";
    char text2[] = "A man a plan a canal Panama";
    
    printf("Text 1: \"%s\"\n", text1);
    printf("Word count: %d\n", count_words(text1));
    
    printf("\nText 2: \"%s\"\n", text2);
    printf("Is palindrome: %s\n", is_palindrome(text2) ? "Yes" : "No");
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Array bounds**: Always check array indices before accessing elements
2. **String termination**: Ensure strings are properly null-terminated
3. **Memory allocation**: Check return values from malloc/realloc
4. **Pointer validation**: Always check for NULL pointers
5. **Buffer overflow**: Limit string input sizes to prevent overflow

### Performance Tips:
1. **Pass by reference**: Use pointers for large arrays to avoid copying
2. **Avoid repeated strlen**: Store string length in a variable when used multiple times
3. **Use const**: Mark string parameters as const when not modifying them
4. **Pre-allocate**: When size is known, pre-allocate arrays to avoid repeated resizing
5. **Cache results**: For expensive operations, cache results when possible

Complete these exercises to solidify your understanding of arrays and strings in C. Each exercise builds upon the previous ones, gradually increasing in complexity.