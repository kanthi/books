# Module 3: Control Flow Exercises

## Exercise 1: Grade Calculator with Multiple Conditions
Write a program that calculates letter grades based on numerical scores using nested if-else statements. Include:
- Input validation for scores (0-100)
- Different grading scales for different courses
- Bonus points for perfect attendance
- Extra credit opportunities

**Requirements:**
- Use nested conditionals for complex grading logic
- Implement multiple grading scales (e.g., strict, lenient, standard)
- Include bonus point calculations
- Provide detailed feedback for each grade range

## Exercise 2: Pattern Generator
Create a program that generates various number and character patterns using nested loops:
- Right-angled triangles
- Pyramids
- Diamond patterns
- Floyd's triangle
- Pascal's triangle (advanced)

**Requirements:**
- Use nested loops for pattern generation
- Allow user to select pattern type
- Implement input validation for pattern size
- Include both number and character patterns

## Exercise 3: Menu-Driven Calculator
Develop a comprehensive calculator using do-while loops and switch statements:
- Basic arithmetic operations
- Scientific functions (sin, cos, tan, log, sqrt)
- Memory functions (store, recall, clear)
- History of calculations
- Unit conversions

**Requirements:**
- Use do-while for main menu loop
- Implement switch for operation selection
- Include error handling for invalid inputs
- Provide clear exit mechanism

## Exercise 4: Prime Number Analyzer
Write a program that finds and analyzes prime numbers using various loop constructs:
- Prime number detection
- Prime factorization
- Twin prime identification
- Prime number distribution analysis
- Sieve of Eratosthenes implementation

**Requirements:**
- Use efficient algorithms for prime detection
- Implement multiple loop types (for, while)
- Include performance timing
- Provide statistical analysis of results

## Exercise 5: Resource Manager with goto
Create a resource management system that demonstrates proper use of goto for error handling:
- File operations
- Memory allocation
- Network connections (simulated)
- Database connections (simulated)
- Cleanup procedures

**Requirements:**
- Use goto for structured error handling
- Implement proper resource cleanup
- Include error simulation
- Demonstrate resource leak prevention

## Exercise 6: Function Pointer Calculator
Develop a calculator that uses function pointers for operation selection:
- Basic arithmetic operations
- Advanced mathematical functions
- Custom function registration
- Dynamic operation selection
- Plugin architecture simulation

**Requirements:**
- Use function pointers for operation dispatch
- Implement callback mechanisms
- Include function registration system
- Provide extensibility examples

## Exercise 7: State Machine Implementation
Create a state machine for a real-world system:
- Vending machine controller
- Traffic light system
- Bank account management
- Game character states
- Network protocol handler

**Requirements:**
- Use enum for state definitions
- Implement state transition logic
- Include event handling
- Provide state visualization

## Exercise 8: Error Handling Framework
Design an error handling system that demonstrates various error management techniques:
- Return code patterns
- errno simulation
- Exception-like behavior with setjmp/longjmp
- Logging mechanisms
- Recovery procedures

**Requirements:**
- Implement multiple error handling approaches
- Include error code definitions
- Provide error message system
- Demonstrate error recovery

## Exercise 9: Complex Loop Optimization
Write programs that demonstrate loop optimization techniques:
- Loop unrolling
- Loop fusion
- Loop invariant code motion
- Strength reduction
- Cache-friendly iterations

**Requirements:**
- Compare performance of optimized vs. unoptimized loops
- Include timing measurements
- Provide analysis of optimization effects
- Demonstrate when optimizations are beneficial

## Exercise 10: Comprehensive Control Flow Application
Design and implement a complete application that integrates all control flow concepts:
- A simple game (tic-tac-toe, snake, etc.)
- A data processing system
- A simulation program
- A configuration tool
- A monitoring application

**Requirements:**
- Use all control flow constructs appropriately
- Include complex decision-making logic
- Implement proper error handling
- Provide user-friendly interface
- Include comprehensive documentation

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>

int main() {
    float score;
    int attendance;
    int extra_credit;
    
    printf("Enter score (0-100): ");
    scanf("%f", &score);
    
    printf("Enter attendance (0-100%%): ");
    scanf("%d", &attendance);
    
    printf("Enter extra credit points (0-10): ");
    scanf("%d", &extra_credit);
    
    // Input validation
    if (score < 0 || score > 100) {
        printf("Invalid score!\n");
        return 1;
    }
    
    if (attendance < 0 || attendance > 100) {
        printf("Invalid attendance!\n");
        return 1;
    }
    
    if (extra_credit < 0 || extra_credit > 10) {
        printf("Invalid extra credit!\n");
        return 1;
    }
    
    // Apply bonus for perfect attendance
    if (attendance == 100) {
        score += 2.0f;
        if (score > 100) score = 100;
    }
    
    // Add extra credit
    score += extra_credit;
    if (score > 100) score = 100;
    
    // Determine grade
    if (score >= 97) {
        printf("Grade: A+ (Excellent)\n");
    } else if (score >= 93) {
        printf("Grade: A (Outstanding)\n");
    } else if (score >= 90) {
        printf("Grade: A- (Very Good)\n");
    } else if (score >= 87) {
        printf("Grade: B+ (Good)\n");
    } else if (score >= 83) {
        printf("Grade: B (Satisfactory)\n");
    } else if (score >= 80) {
        printf("Grade: B- (Above Average)\n");
    } else if (score >= 77) {
        printf("Grade: C+ (Average)\n");
    } else if (score >= 73) {
        printf("Grade: C (Below Average)\n");
    } else if (score >= 70) {
        printf("Grade: C- (Poor)\n");
    } else if (score >= 60) {
        printf("Grade: D (Very Poor)\n");
    } else {
        printf("Grade: F (Fail)\n");
    }
    
    printf("Final score: %.1f\n", score);
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>

void print_pyramid(int rows) {
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
}

void print_floyds_triangle(int rows) {
    int num = 1;
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= i; j++) {
            printf("%d ", num++);
        }
        printf("\n");
    }
}

int main() {
    int choice, rows;
    
    printf("Pattern Generator\n");
    printf("1. Pyramid\n");
    printf("2. Floyd's Triangle\n");
    printf("Enter choice: ");
    scanf("%d", &choice);
    
    printf("Enter number of rows: ");
    scanf("%d", &rows);
    
    if (rows <= 0 || rows > 20) {
        printf("Invalid number of rows!\n");
        return 1;
    }
    
    switch (choice) {
        case 1:
            print_pyramid(rows);
            break;
        case 2:
            print_floyds_triangle(rows);
            break;
        default:
            printf("Invalid choice!\n");
    }
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <math.h>

double memory = 0.0;
double history[100];
int history_count = 0;

void add_to_history(double result) {
    if (history_count < 100) {
        history[history_count++] = result;
    }
}

void show_history() {
    printf("\nCalculation History:\n");
    for (int i = 0; i < history_count && i < 10; i++) {
        printf("%d. %.2f\n", i + 1, history[i]);
    }
}

int main() {
    int choice;
    double num1, num2, result;
    
    do {
        printf("\n=== Scientific Calculator ===\n");
        printf("1. Addition\n");
        printf("2. Subtraction\n");
        printf("3. Multiplication\n");
        printf("4. Division\n");
        printf("5. Sine\n");
        printf("6. Cosine\n");
        printf("7. Square Root\n");
        printf("8. Memory Store\n");
        printf("9. Memory Recall\n");
        printf("10. Show History\n");
        printf("0. Exit\n");
        printf("Enter your choice: ");
        
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter two numbers: ");
                scanf("%lf %lf", &num1, &num2);
                result = num1 + num2;
                printf("Result: %.2f\n", result);
                add_to_history(result);
                break;
            case 2:
                printf("Enter two numbers: ");
                scanf("%lf %lf", &num1, &num2);
                result = num1 - num2;
                printf("Result: %.2f\n", result);
                add_to_history(result);
                break;
            case 3:
                printf("Enter two numbers: ");
                scanf("%lf %lf", &num1, &num2);
                result = num1 * num2;
                printf("Result: %.2f\n", result);
                add_to_history(result);
                break;
            case 4:
                printf("Enter two numbers: ");
                scanf("%lf %lf", &num1, &num2);
                if (num2 != 0) {
                    result = num1 / num2;
                    printf("Result: %.2f\n", result);
                    add_to_history(result);
                } else {
                    printf("Error: Division by zero!\n");
                }
                break;
            case 5:
                printf("Enter angle in radians: ");
                scanf("%lf", &num1);
                result = sin(num1);
                printf("Result: %.2f\n", result);
                add_to_history(result);
                break;
            case 6:
                printf("Enter angle in radians: ");
                scanf("%lf", &num1);
                result = cos(num1);
                printf("Result: %.2f\n", result);
                add_to_history(result);
                break;
            case 7:
                printf("Enter number: ");
                scanf("%lf", &num1);
                if (num1 >= 0) {
                    result = sqrt(num1);
                    printf("Result: %.2f\n", result);
                    add_to_history(result);
                } else {
                    printf("Error: Cannot calculate square root of negative number!\n");
                }
                break;
            case 8:
                printf("Enter number to store: ");
                scanf("%lf", &memory);
                printf("Stored %.2f in memory\n", memory);
                break;
            case 9:
                printf("Memory: %.2f\n", memory);
                break;
            case 10:
                show_history();
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

### Exercise 5 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *filename;
    FILE *file;
    char *buffer;
    int *data;
} ResourceManager;

int initialize_resources(ResourceManager *rm) {
    // Allocate filename
    rm->filename = malloc(100);
    if (!rm->filename) {
        goto cleanup;
    }
    strcpy(rm->filename, "data.txt");
    
    // Open file
    rm->file = fopen(rm->filename, "w");
    if (!rm->file) {
        printf("Error opening file\n");
        goto cleanup;
    }
    
    // Allocate buffer
    rm->buffer = malloc(1024);
    if (!rm->buffer) {
        printf("Error allocating buffer\n");
        goto cleanup;
    }
    
    // Allocate data
    rm->data = malloc(100 * sizeof(int));
    if (!rm->data) {
        printf("Error allocating data\n");
        goto cleanup;
    }
    
    printf("All resources initialized successfully\n");
    return 0;  // Success
    
cleanup:
    // Cleanup in reverse order
    if (rm->data) {
        free(rm->data);
        rm->data = NULL;
    }
    if (rm->buffer) {
        free(rm->buffer);
        rm->buffer = NULL;
    }
    if (rm->file) {
        fclose(rm->file);
        rm->file = NULL;
    }
    if (rm->filename) {
        free(rm->filename);
        rm->filename = NULL;
    }
    return -1;  // Error
}

void cleanup_resources(ResourceManager *rm) {
    if (rm->data) {
        free(rm->data);
        rm->data = NULL;
    }
    if (rm->buffer) {
        free(rm->buffer);
        rm->buffer = NULL;
    }
    if (rm->file) {
        fclose(rm->file);
        rm->file = NULL;
    }
    if (rm->filename) {
        free(rm->filename);
        rm->filename = NULL;
    }
    printf("All resources cleaned up\n");
}

int main() {
    ResourceManager rm = {0};
    
    if (initialize_resources(&rm) == 0) {
        printf("Resource management successful\n");
        // Use resources here
        cleanup_resources(&rm);
    } else {
        printf("Resource management failed\n");
        return 1;
    }
    
    return 0;
}
```

## Common Pitfalls to Avoid

1. **Infinite Loops**: Always ensure loop termination conditions
2. **Off-by-One Errors**: Carefully check loop bounds
3. **goto Overuse**: Use goto only for structured error handling
4. **Deep Nesting**: Use early returns to reduce nesting levels
5. **Missing Break Statements**: Always include break in switch cases
6. **Floating-Point Loop Variables**: Avoid using floats as loop counters
7. **Resource Leaks**: Always clean up allocated resources
8. **Uninitialized Variables**: Initialize all variables before use

## Compilation Tips
```bash
# Basic compilation
gcc program.c -o program

# With math library for scientific functions
gcc program.c -lm -o program

# With warnings enabled
gcc -Wall -Wextra program.c -o program

# With debugging information
gcc -g -Wall program.c -o program

# With optimization
gcc -O2 program.c -o program
```

Complete these exercises to solidify your understanding of Module 3 concepts. Each exercise builds upon the previous ones, gradually increasing in complexity.