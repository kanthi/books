/*
 * Module 5 Demonstration Program
 * This program demonstrates all the key concepts from Module 5:
 * - Arrays (single-dimensional, multi-dimensional)
 * - Strings (character arrays, string manipulation)
 * - Advanced array operations
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include our custom header files
#include "array_utils.h"
#include "string_utils.h"

// Function prototypes for demonstration functions
void demonstrate_arrays(void);
void demonstrate_strings(void);
void demonstrate_advanced_arrays(void);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 5: Arrays and Strings Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_arrays();
    demonstrate_strings();
    demonstrate_advanced_arrays();
    
    printf("\n========================================\n");
    printf("  Module 5 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate array concepts
 */
void demonstrate_arrays() {
    print_separator("Array Fundamentals");
    
    // Single-dimensional arrays
    int numbers[] = {5, 2, 8, 1, 9, 3};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("Original array: ");
    print_int_array(numbers, size);
    
    // Array operations
    printf("Maximum value: %d\n", find_max(numbers, size));
    printf("Minimum value: %d\n", find_min(numbers, size));
    printf("Sum of elements: %d\n", sum_array(numbers, size));
    
    // Sorting
    bubble_sort(numbers, size);
    printf("Sorted array: ");
    print_int_array(numbers, size);
    
    // Searching
    int target = 8;
    int index = linear_search(numbers, size, target);
    printf("Linear search for %d: index %d\n", target, index);
    
    index = binary_search(numbers, size, target);
    printf("Binary search for %d: index %d\n", target, index);
    
    // Reversing
    reverse_array(numbers, size);
    printf("Reversed array: ");
    print_int_array(numbers, size);
    
    // Multi-dimensional arrays
    print_separator("Multi-dimensional Arrays");
    int matrix[3][3] = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9}
    };
    
    printf("3x3 Matrix:\n");
    for (int i = 0; i < 3; i++) {
        for (int j = 0; j < 3; j++) {
            printf("%d ", matrix[i][j]);
        }
        printf("\n");
    }
    
    // Sum of rows and columns
    printf("Row sums: ");
    for (int i = 0; i < 3; i++) {
        int row_sum = 0;
        for (int j = 0; j < 3; j++) {
            row_sum += matrix[i][j];
        }
        printf("%d ", row_sum);
    }
    printf("\n");
}

/*
 * Demonstrate string concepts
 */
void demonstrate_strings() {
    print_separator("String Fundamentals");
    
    // String operations
    char str1[100] = "Hello, World!";
    char str2[100] = "Hello, C Programming!";
    
    printf("String 1: %s\n", str1);
    printf("String 2: %s\n", str2);
    printf("Length of str1: %d\n", string_length(str1));
    printf("Length of str2: %d\n", string_length(str2));
    
    // String comparison
    int cmp_result = string_compare(str1, str2);
    printf("Comparison result: %d\n", cmp_result);
    
    // String copying
    char str3[100];
    string_copy(str3, str1);
    printf("Copied string: %s\n", str3);
    
    // String concatenation
    string_concat(str3, " Welcome!");
    printf("Concatenated string: %s\n", str3);
    
    // String manipulation
    printf("Original string: %s\n", str1);
    string_reverse(str1);
    printf("Reversed string: %s\n", str1);
    
    // Palindrome check
    char palindrome[] = "racecar";
    printf("Is '%s' a palindrome? %s\n", palindrome, 
           is_palindrome(palindrome) ? "Yes" : "No");
    
    // Word and vowel counting
    char sentence[] = "The quick brown fox jumps over the lazy dog";
    printf("Sentence: %s\n", sentence);
    printf("Word count: %d\n", count_words(sentence));
    printf("Vowel count: %d\n", count_vowels(sentence));
    
    // Case conversion
    char text[] = "Hello, World!";
    printf("Original text: %s\n", text);
    to_uppercase(text);
    printf("Uppercase: %s\n", text);
    
    char text2[] = "HELLO, WORLD!";
    printf("Original text: %s\n", text2);
    to_lowercase(text2);
    printf("Lowercase: %s\n", text2);
    
    // Whitespace trimming
    char spaced_text[] = "   Hello, World!   ";
    printf("Original text: '%s'\n", spaced_text);
    trim_whitespace(spaced_text);
    printf("Trimmed text: '%s'\n", spaced_text);
}

/*
 * Demonstrate advanced array concepts
 */
void demonstrate_advanced_arrays() {
    print_separator("Advanced Array Concepts");
    
    // Dynamic memory allocation for arrays
    int size = 10;
    int *dynamic_array = (int*)malloc(size * sizeof(int));
    
    if (dynamic_array != NULL) {
        // Initialize array
        for (int i = 0; i < size; i++) {
            dynamic_array[i] = i * 2;
        }
        
        printf("Dynamic array: ");
        print_int_array(dynamic_array, size);
        
        // Resize array
        size = 15;
        int *resized_array = (int*)realloc(dynamic_array, size * sizeof(int));
        
        if (resized_array != NULL) {
            dynamic_array = resized_array;
            // Initialize new elements
            for (int i = 10; i < size; i++) {
                dynamic_array[i] = i * 3;
            }
            
            printf("Resized array: ");
            print_int_array(dynamic_array, size);
        }
        
        free(dynamic_array);
    }
    
    // Array of pointers
    print_separator("Array of Pointers");
    int a = 10, b = 20, c = 30;
    int *ptr_array[] = {&a, &b, &c};
    
    printf("Values through pointer array: ");
    for (int i = 0; i < 3; i++) {
        printf("%d ", *ptr_array[i]);
    }
    printf("\n");
    
    // Command line arguments (simulated)
    print_separator("Command Line Arguments");
    char *argv[] = {"program", "arg1", "arg2", "arg3"};
    int argc = 4;
    
    printf("Program name: %s\n", argv[0]);
    printf("Arguments: ");
    for (int i = 1; i < argc; i++) {
        printf("%s ", argv[i]);
    }
    printf("\n");
}