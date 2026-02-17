# Loops

## Introduction

Loops are control structures that allow programs to repeat a block of code multiple times. They are essential for processing collections of data, implementing algorithms, and automating repetitive tasks. C provides three main types of loops: `while`, `do-while`, and `for`, each with specific use cases and characteristics.

Understanding loops is crucial for efficient programming, as they enable you to write concise code that can handle large amounts of data or perform complex calculations. This chapter will explore all loop types in detail, their syntax, best practices, and common applications.

## The while Loop

The `while` loop repeatedly executes a block of code as long as a specified condition remains true. It's a pre-test loop, meaning the condition is evaluated before each iteration.

### Basic Syntax

```c
while (condition) {
    // Code to execute repeatedly
}
```

### Simple while Loop Example

```c
#include <stdio.h>

int main() {
    int count = 1;
    
    while (count <= 5) {
        printf("Count: %d\n", count);
        count++;  // Important: update the loop variable
    }
    
    return 0;
}
```

### while Loop with User Input

```c
#include <stdio.h>

int main() {
    int number;
    
    printf("Enter positive numbers (0 to stop):\n");
    
    scanf("%d", &number);
    while (number > 0) {
        printf("You entered: %d\n", number);
        scanf("%d", &number);
    }
    
    printf("Loop ended.\n");
    return 0;
}
```

## The do-while Loop

The `do-while` loop is a post-test loop, meaning the code block is executed at least once before the condition is evaluated. This guarantees that the loop body executes at least once.

### Basic Syntax

```c
do {
    // Code to execute
} while (condition);
```

### Simple do-while Example

```c
#include <stdio.h>

int main() {
    int count = 1;
    
    do {
        printf("Count: %d\n", count);
        count++;
    } while (count <= 5);
    
    return 0;
}
```

### Menu-Driven Program with do-while

```c
#include <stdio.h>

int main() {
    int choice;
    
    do {
        printf("\n=== Menu ===\n");
        printf("1. Option 1\n");
        printf("2. Option 2\n");
        printf("3. Option 3\n");
        printf("0. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("You selected Option 1\n");
                break;
            case 2:
                printf("You selected Option 2\n");
                break;
            case 3:
                printf("You selected Option 3\n");
                break;
            case 0:
                printf("Exiting...\n");
                break;
            default:
                printf("Invalid choice! Try again.\n");
        }
    } while (choice != 0);
    
    return 0;
}
```

## The for Loop

The `for` loop is ideal when you know the exact number of iterations or have a clear initialization, condition, and update pattern. It combines all loop control elements in one line.

### Basic Syntax

```c
for (initialization; condition; update) {
    // Code to execute repeatedly
}
```

### Simple for Loop Example

```c
#include <stdio.h>

int main() {
    for (int i = 1; i <= 5; i++) {
        printf("Count: %d\n", i);
    }
    
    return 0;
}
```

### for Loop with Arrays

```c
#include <stdio.h>

int main() {
    int numbers[] = {10, 20, 30, 40, 50};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    printf("Array elements:\n");
    for (int i = 0; i < size; i++) {
        printf("numbers[%d] = %d\n", i, numbers[i]);
    }
    
    return 0;
}
```

## Loop Control Statements

C provides two statements to control loop execution: `break` and `continue`.

### break Statement

The `break` statement immediately terminates the loop, transferring control to the statement following the loop.

```c
#include <stdio.h>

int main() {
    for (int i = 1; i <= 10; i++) {
        if (i == 5) {
            break;  // Exit the loop when i equals 5
        }
        printf("Count: %d\n", i);
    }
    
    printf("Loop ended.\n");
    return 0;
}
```

### continue Statement

The `continue` statement skips the remaining code in the current iteration and proceeds to the next iteration.

```c
#include <stdio.h>

int main() {
    for (int i = 1; i <= 10; i++) {
        if (i % 2 == 0) {
            continue;  // Skip even numbers
        }
        printf("Odd number: %d\n", i);
    }
    
    return 0;
}
```

## Nested Loops

Loops can be nested within other loops to handle multi-dimensional data structures or complex iterations.

### Nested for Loops

```c
#include <stdio.h>

int main() {
    // Print multiplication table
    for (int i = 1; i <= 5; i++) {
        for (int j = 1; j <= 5; j++) {
            printf("%d ", i * j);
        }
        printf("\n");
    }
    
    return 0;
}
```

### Nested Loops with break and continue

```c
#include <stdio.h>

int main() {
    for (int i = 1; i <= 3; i++) {
        printf("Outer loop: %d\n", i);
        
        for (int j = 1; j <= 5; j++) {
            if (j == 3) {
                continue;  // Skip j = 3 in inner loop
            }
            
            if (i == 2 && j == 4) {
                break;  // Break inner loop when i=2 and j=4
            }
            
            printf("  Inner loop: %d\n", j);
        }
    }
    
    return 0;
}
```

## Infinite Loops

Infinite loops run indefinitely unless interrupted by a `break` statement or external intervention.

### Creating Infinite Loops

```c
#include <stdio.h>

int main() {
    // Method 1: while with true condition
    int count = 0;
    while (1) {  // Always true
        printf("Count: %d\n", count);
        count++;
        
        if (count >= 5) {
            break;  // Exit condition
        }
    }
    
    // Method 2: for loop with no conditions
    for (;;) {
        printf("Infinite loop iteration\n");
        break;  // Prevent actual infinite execution
    }
    
    return 0;
}
```

## Loop Performance Considerations

### Efficient Loop Writing

```c
#include <stdio.h>

int main() {
    int array[1000];
    int size = 1000;
    
    // Inefficient: calculating size in each iteration
    for (int i = 0; i < sizeof(array) / sizeof(array[0]); i++) {
        array[i] = i;
    }
    
    // Efficient: calculate size once
    int array_size = sizeof(array) / sizeof(array[0]);
    for (int i = 0; i < array_size; i++) {
        array[i] = i;
    }
    
    return 0;
}
```

### Loop Unrolling (Manual Optimization)

```c
#include <stdio.h>

int main() {
    int array[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int sum = 0;
    
    // Standard loop
    for (int i = 0; i < 10; i++) {
        sum += array[i];
    }
    printf("Sum (standard): %d\n", sum);
    
    // Loop unrolling (manual optimization)
    sum = 0;
    sum += array[0] + array[1] + array[2] + array[3] + array[4];
    sum += array[5] + array[6] + array[7] + array[8] + array[9];
    printf("Sum (unrolled): %d\n", sum);
    
    return 0;
}
```

## Best Practices for Loops

### 1. Initialize Loop Variables Properly

```c
// Good: Clear initialization
for (int i = 0; i < 10; i++) {
    // Loop body
}

// Avoid: Unclear initialization
int i;
for (i = 0; i < 10; i++) {
    // Loop body
}
```

### 2. Use Meaningful Loop Variable Names

```c
// Good: Descriptive names
for (int student_index = 0; student_index < num_students; student_index++) {
    process_student(student_index);
}

// Avoid: Generic names for complex loops
for (int i = 0; i < num_students; i++) {
    process_student(i);
}
```

### 3. Avoid Modifying Loop Variables Inside Loop

```c
// Good: Clear loop control
for (int i = 0; i < 10; i++) {
    if (some_condition) {
        break;  // Use break to exit
    }
    // Process data
}

// Avoid: Modifying loop variable inside loop
for (int i = 0; i < 10; i++) {
    if (some_condition) {
        i += 5;  // Confusing control flow
    }
    // Process data
}
```

### 4. Choose the Right Loop Type

```c
// Use while when condition is complex or unknown
int input;
printf("Enter positive numbers (0 to stop): ");
scanf("%d", &input);
while (input > 0) {
    process_number(input);
    scanf("%d", &input);
}

// Use for when iterations are known
for (int i = 0; i < 10; i++) {
    process_item(i);
}

// Use do-while when at least one execution is needed
char choice;
do {
    display_menu();
    scanf(" %c", &choice);
} while (choice != 'q' && choice != 'Q');
```

## Common Pitfalls and How to Avoid Them

### 1. Infinite Loops

```c
#include <stdio.h>

int main() {
    // Wrong: Loop variable not updated
    int i = 0;
    while (i < 10) {
        printf("Count: %d\n", i);
        // Missing i++; causes infinite loop
    }
    
    // Correct: Loop variable updated
    i = 0;
    while (i < 10) {
        printf("Count: %d\n", i);
        i++;  // Loop variable updated
    }
    
    return 0;
}
```

### 2. Off-by-One Errors

```c
#include <stdio.h>

int main() {
    int array[5] = {1, 2, 3, 4, 5};
    
    // Wrong: Accesses array[5] which is out of bounds
    for (int i = 0; i <= 5; i++) {
        printf("array[%d] = %d\n", i, array[i]);  // Error on last iteration
    }
    
    // Correct: Proper bounds checking
    for (int i = 0; i < 5; i++) {
        printf("array[%d] = %d\n", i, array[i]);
    }
    
    return 0;
}
```

### 3. Floating-Point Loop Variables

```c
#include <stdio.h>

int main() {
    // Wrong: Floating-point loop variables can cause precision issues
    for (float x = 0.1f; x != 1.0f; x += 0.1f) {
        printf("x = %.20f\n", x);
    }
    
    // Correct: Use integer loop variables for counting
    for (int i = 1; i <= 10; i++) {
        float x = i * 0.1f;
        printf("x = %.20f\n", x);
    }
    
    return 0;
}
```

## Practical Examples

### Number Pattern Generator

```c
#include <stdio.h>

int main() {
    int rows = 5;
    
    // Right-angled triangle pattern
    printf("Right-angled triangle:\n");
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }
    
    // Pyramid pattern
    printf("\nPyramid:\n");
    for (int i = 1; i <= rows; i++) {
        // Print spaces
        for (int j = 1; j <= rows - i; j++) {
            printf(" ");
        }
        // Print stars
        for (int k = 1; k <= 2 * i - 1; k++) {
            printf("*");
        }
        printf("\n");
    }
    
    return 0;
}
```

### Prime Number Finder

```c
#include <stdio.h>
#include <stdbool.h>

bool is_prime(int num) {
    if (num <= 1) return false;
    if (num <= 3) return true;
    if (num % 2 == 0 || num % 3 == 0) return false;
    
    for (int i = 5; i * i <= num; i += 6) {
        if (num % i == 0 || num % (i + 2) == 0) {
            return false;
        }
    }
    return true;
}

int main() {
    int limit = 50;
    
    printf("Prime numbers up to %d:\n", limit);
    
    // Using while loop
    int num = 2;
    while (num <= limit) {
        if (is_prime(num)) {
            printf("%d ", num);
        }
        num++;
    }
    printf("\n");
    
    // Using for loop
    printf("Prime numbers (for loop):\n");
    for (int i = 2; i <= limit; i++) {
        if (is_prime(i)) {
            printf("%d ", i);
        }
    }
    printf("\n");
    
    return 0;
}
```

### Array Processing with Loops

```c
#include <stdio.h>

int main() {
    int numbers[] = {12, 7, 23, 8, 15, 3, 19, 11, 5, 17};
    int size = sizeof(numbers) / sizeof(numbers[0]);
    
    // Find maximum value
    int max = numbers[0];
    for (int i = 1; i < size; i++) {
        if (numbers[i] > max) {
            max = numbers[i];
        }
    }
    printf("Maximum value: %d\n", max);
    
    // Calculate average
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += numbers[i];
    }
    double average = (double)sum / size;
    printf("Average: %.2f\n", average);
    
    // Count even numbers
    int even_count = 0;
    for (int i = 0; i < size; i++) {
        if (numbers[i] % 2 == 0) {
            even_count++;
        }
    }
    printf("Even numbers count: %d\n", even_count);
    
    // Reverse array
    printf("Original array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    // Reverse using two pointers
    for (int i = 0, j = size - 1; i < j; i++, j--) {
        int temp = numbers[i];
        numbers[i] = numbers[j];
        numbers[j] = temp;
    }
    
    printf("Reversed array: ");
    for (int i = 0; i < size; i++) {
        printf("%d ", numbers[i]);
    }
    printf("\n");
    
    return 0;
}
```

### Menu-Driven Calculator with Loop Control

```c
#include <stdio.h>
#include <math.h>

int main() {
    int choice;
    double num1, num2, result;
    
    do {
        printf("\n=== Advanced Calculator ===\n");
        printf("1. Addition\n");
        printf("2. Subtraction\n");
        printf("3. Multiplication\n");
        printf("4. Division\n");
        printf("5. Power\n");
        printf("6. Square Root\n");
        printf("0. Exit\n");
        printf("Enter your choice: ");
        
        if (scanf("%d", &choice) != 1) {
            printf("Invalid input! Please enter a number.\n");
            // Clear input buffer
            while (getchar() != '\n');
            continue;
        }
        
        if (choice >= 1 && choice <= 5) {
            printf("Enter first number: ");
            if (scanf("%lf", &num1) != 1) {
                printf("Invalid input!\n");
                while (getchar() != '\n');
                continue;
            }
            
            if (choice != 6) {  // Square root only needs one number
                printf("Enter second number: ");
                if (scanf("%lf", &num2) != 1) {
                    printf("Invalid input!\n");
                    while (getchar() != '\n');
                    continue;
                }
            }
        } else if (choice == 6) {
            printf("Enter number: ");
            if (scanf("%lf", &num1) != 1) {
                printf("Invalid input!\n");
                while (getchar() != '\n');
                continue;
            }
        }
        
        switch (choice) {
            case 1:
                result = num1 + num2;
                printf("Result: %.2f + %.2f = %.2f\n", num1, num2, result);
                break;
            case 2:
                result = num1 - num2;
                printf("Result: %.2f - %.2f = %.2f\n", num1, num2, result);
                break;
            case 3:
                result = num1 * num2;
                printf("Result: %.2f * %.2f = %.2f\n", num1, num2, result);
                break;
            case 4:
                if (num2 != 0) {
                    result = num1 / num2;
                    printf("Result: %.2f / %.2f = %.2f\n", num1, num2, result);
                } else {
                    printf("Error: Division by zero!\n");
                }
                break;
            case 5:
                result = pow(num1, num2);
                printf("Result: %.2f ^ %.2f = %.2f\n", num1, num2, result);
                break;
            case 6:
                if (num1 >= 0) {
                    result = sqrt(num1);
                    printf("Result: sqrt(%.2f) = %.2f\n", num1, result);
                } else {
                    printf("Error: Cannot calculate square root of negative number!\n");
                }
                break;
            case 0:
                printf("Thank you for using the calculator!\n");
                break;
            default:
                printf("Invalid choice! Please try again.\n");
        }
    } while (choice != 0);
    
    return 0;
}
```

## Summary

In this chapter, you've learned about:

1. **while Loops**: Pre-test loops for unknown iteration counts
2. **do-while Loops**: Post-test loops that execute at least once
3. **for Loops**: Count-controlled loops with initialization, condition, and update
4. **Loop Control**: break and continue statements for flow control
5. **Nested Loops**: Loops within loops for multi-dimensional processing
6. **Infinite Loops**: Loops that run indefinitely
7. **Performance Considerations**: Efficient loop writing practices
8. **Best Practices**: Writing clean, maintainable loop code
9. **Common Pitfalls**: Avoiding typical loop errors

Loops are fundamental to programming and enable efficient processing of data collections, implementation of algorithms, and automation of repetitive tasks. With this knowledge, you're now ready to tackle more complex programming challenges in the next chapter on advanced control flow.