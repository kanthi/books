/*
 * Module 3 Demonstration Program
 * This program demonstrates all the key concepts from Module 3:
 * - Conditional statements (if, if-else, switch)
 * - Loop constructs (while, do-while, for)
 * - Advanced control flow (goto, function pointers, error handling)
 * - State machines and complex control patterns
 */

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>
#include <setjmp.h>

// Function prototypes
void demonstrate_conditionals(void);
void demonstrate_loops(void);
void demonstrate_advanced_control_flow(void);
void demonstrate_state_machine(void);
void demonstrate_error_handling(void);

// Helper functions for demonstrations
int factorial(int n);
void print_pattern(int rows);
bool is_prime(int num);
int calculate(int a, int b, char op);

/*
 * Main function - entry point of the program
 */
int main() {
    printf("=====================================\n");
    printf("  Module 3: Control Flow Demonstration \n");
    printf("         Comprehensive Demo           \n");
    printf("=====================================\n\n");
    
    demonstrate_conditionals();
    demonstrate_loops();
    demonstrate_advanced_control_flow();
    demonstrate_state_machine();
    demonstrate_error_handling();
    
    printf("\n=====================================\n");
    printf("  Module 3 Demo Completed Successfully \n");
    printf("=====================================\n");
    
    return 0;
}

/*
 * Demonstrate conditional statements
 */
void demonstrate_conditionals() {
    printf("--- Conditional Statements ---\n");
    
    // if-else statements
    int age = 25;
    printf("Age: %d\n", age);
    
    if (age >= 18 && age < 65) {
        printf("You are an adult.\n");
    } else if (age >= 65) {
        printf("You are a senior citizen.\n");
    } else {
        printf("You are a minor.\n");
    }
    
    // switch statement
    int day = 3;
    printf("\nDay of week (1-7): %d\n", day);
    
    switch (day) {
        case 1:
            printf("Monday\n");
            break;
        case 2:
            printf("Tuesday\n");
            break;
        case 3:
            printf("Wednesday\n");
            break;
        case 4:
            printf("Thursday\n");
            break;
        case 5:
            printf("Friday\n");
            break;
        case 6:
            printf("Saturday\n");
            break;
        case 7:
            printf("Sunday\n");
            break;
        default:
            printf("Invalid day\n");
    }
    
    // Conditional operator
    int a = 10, b = 20;
    int max = (a > b) ? a : b;
    printf("\nMaximum of %d and %d is %d\n", a, b, max);
    
    printf("\n");
}

/*
 * Demonstrate loop constructs
 */
void demonstrate_loops() {
    printf("--- Loop Constructs ---\n");
    
    // while loop
    printf("While loop (count 1-5):\n");
    int count = 1;
    while (count <= 5) {
        printf("%d ", count);
        count++;
    }
    printf("\n");
    
    // do-while loop
    printf("\nDo-while loop (countdown 5-1):\n");
    int countdown = 5;
    do {
        printf("%d ", countdown);
        countdown--;
    } while (countdown > 0);
    printf("\n");
    
    // for loop
    printf("\nFor loop (multiplication table 5x):\n");
    for (int i = 1; i <= 5; i++) {
        printf("5 x %d = %d\n", i, 5 * i);
    }
    
    // Nested loops
    printf("\nNested loops (pattern):\n");
    print_pattern(5);
    
    // Loop with break and continue
    printf("\nLoop with break and continue (prime numbers 1-20):\n");
    for (int i = 1; i <= 20; i++) {
        if (i < 2) {
            continue;  // Skip numbers less than 2
        }
        
        if (i > 15) {
            break;  // Stop after 15
        }
        
        if (is_prime(i)) {
            printf("%d ", i);
        }
    }
    printf("\n");
    
    printf("\n");
}

/*
 * Helper function to print pattern
 */
void print_pattern(int rows) {
    for (int i = 1; i <= rows; i++) {
        for (int j = 1; j <= i; j++) {
            printf("* ");
        }
        printf("\n");
    }
}

/*
 * Helper function to check if number is prime
 */
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

/*
 * Demonstrate advanced control flow mechanisms
 */
void demonstrate_advanced_control_flow() {
    printf("--- Advanced Control Flow ---\n");
    
    // goto for error handling
    printf("Goto for error handling:\n");
    
    FILE *file = NULL;
    int *array = NULL;
    int result = -1;
    
    file = fopen("test.txt", "r");
    if (!file) {
        printf("  Error: Could not open file\n");
        goto cleanup;
    }
    
    array = (int*)malloc(10 * sizeof(int));
    if (!array) {
        printf("  Error: Could not allocate memory\n");
        goto cleanup;
    }
    
    printf("  Resources allocated successfully\n");
    result = 0;  // Success
    
cleanup:
    if (array) {
        free(array);
        printf("  Memory freed\n");
    }
    if (file) {
        fclose(file);
        printf("  File closed\n");
    }
    
    if (result == 0) {
        printf("  Operation completed successfully\n");
    } else {
        printf("  Operation failed\n");
    }
    
    // Function pointers
    printf("\nFunction pointers:\n");
    int x = 10, y = 5;
    
    printf("  %d + %d = %d\n", x, y, calculate(x, y, '+'));
    printf("  %d - %d = %d\n", x, y, calculate(x, y, '-'));
    printf("  %d * %d = %d\n", x, y, calculate(x, y, '*'));
    printf("  %d / %d = %d\n", x, y, calculate(x, y, '/'));
    
    // Recursion
    printf("\nRecursion (factorial):\n");
    for (int i = 0; i <= 6; i++) {
        printf("  %d! = %d\n", i, factorial(i));
    }
    
    printf("\n");
}

/*
 * Helper function for factorial calculation
 */
int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}

/*
 * Helper function for calculator using function pointers
 */
int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }
int divide(int a, int b) { return b != 0 ? a / b : 0; }

int calculate(int a, int b, char op) {
    int (*operation)(int, int);
    
    switch (op) {
        case '+': operation = add; break;
        case '-': operation = subtract; break;
        case '*': operation = multiply; break;
        case '/': operation = divide; break;
        default: return 0;
    }
    
    return operation(a, b);
}

/*
 * Demonstrate state machine
 */
void demonstrate_state_machine() {
    printf("--- State Machine ---\n");
    
    typedef enum {
        STATE_IDLE,
        STATE_PROCESSING,
        STATE_COMPLETE,
        STATE_ERROR
    } State;
    
    State current_state = STATE_IDLE;
    int input;
    
    printf("State machine simulation (simplified):\n");
    printf("  1: Start processing\n");
    printf("  2: Complete processing\n");
    printf("  3: Error condition\n");
    printf("  0: Exit simulation\n");
    
    // Simulate state transitions
    for (int i = 0; i < 4; i++) {
        switch (current_state) {
            case STATE_IDLE:
                printf("  State: IDLE\n");
                current_state = STATE_PROCESSING;
                break;
                
            case STATE_PROCESSING:
                printf("  State: PROCESSING\n");
                if (i == 2) {
                    current_state = STATE_ERROR;
                } else {
                    current_state = STATE_COMPLETE;
                }
                break;
                
            case STATE_COMPLETE:
                printf("  State: COMPLETE\n");
                current_state = STATE_IDLE;
                break;
                
            case STATE_ERROR:
                printf("  State: ERROR\n");
                current_state = STATE_IDLE;
                break;
        }
    }
    
    printf("\n");
}

/*
 * Demonstrate error handling patterns
 */
void demonstrate_error_handling() {
    printf("--- Error Handling ---\n");
    
    // Return code pattern
    typedef enum {
        SUCCESS = 0,
        ERROR_INVALID_INPUT = 1,
        ERROR_MEMORY_ALLOCATION = 2,
        ERROR_FILE_OPERATION = 3
    } ErrorCode;
    
    printf("Return code pattern:\n");
    ErrorCode result = SUCCESS;
    
    int value = -5;
    if (value < 0) {
        result = ERROR_INVALID_INPUT;
        printf("  Error: Invalid input value %d\n", value);
    } else {
        printf("  Success: Valid input value %d\n", value);
    }
    
    // Error message mapping
    const char* error_messages[] = {
        "Success",
        "Invalid input",
        "Memory allocation failed",
        "File operation failed"
    };
    
    printf("  Error code %d: %s\n", result, error_messages[result]);
    
    // errno simulation
    printf("\nErrno simulation:\n");
    int errno_sim = 2;  // Simulate ENOENT (No such file or directory)
    const char* errno_messages[] = {
        "No error",
        "Operation not permitted",
        "No such file or directory",
        "No such process"
    };
    
    if (errno_sim != 0) {
        printf("  System error %d: %s\n", errno_sim, errno_messages[errno_sim]);
    }
    
    printf("\n");
}