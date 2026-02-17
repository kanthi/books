# Advanced Control Flow

## Introduction

Advanced control flow mechanisms in C go beyond basic conditionals and loops to provide more sophisticated ways to manage program execution. This chapter explores the `goto` statement, function calls as control flow mechanisms, error handling patterns, and advanced techniques for structuring complex programs.

While some of these mechanisms are powerful, they must be used judiciously to maintain code readability and maintainability. Understanding when and how to use these advanced features is crucial for writing professional C code.

## The goto Statement

The `goto` statement allows unconditional jumps to labeled statements within the same function. While generally discouraged in modern programming, there are specific scenarios where `goto` can improve code clarity and efficiency.

### Basic Syntax

```c
goto label;
...
label: statement;
```

### Simple goto Example

```c
#include <stdio.h>

int main() {
    int choice;
    
    printf("Enter 1 to continue, 0 to exit: ");
    scanf("%d", &choice);
    
    if (choice == 0) {
        goto end;  // Jump to the 'end' label
    }
    
    printf("Continuing with the program...\n");
    // More program logic here
    
end:
    printf("Program ended.\n");
    return 0;
}
```

### goto for Error Handling

One of the most legitimate uses of `goto` is in error handling, particularly when cleaning up resources:

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *file1 = NULL;
    FILE *file2 = NULL;
    int *array = NULL;
    
    // Allocate resources
    file1 = fopen("file1.txt", "r");
    if (file1 == NULL) {
        printf("Error opening file1.txt\n");
        goto cleanup;
    }
    
    file2 = fopen("file2.txt", "w");
    if (file2 == NULL) {
        printf("Error opening file2.txt\n");
        goto cleanup;
    }
    
    array = (int*)malloc(100 * sizeof(int));
    if (array == NULL) {
        printf("Error allocating memory\n");
        goto cleanup;
    }
    
    // Main program logic here
    printf("All resources allocated successfully!\n");
    
    // Normal cleanup (reverse order of allocation)
    free(array);
    fclose(file2);
    fclose(file1);
    return 0;
    
cleanup:
    // Error cleanup (free allocated resources)
    if (array != NULL) {
        free(array);
    }
    if (file2 != NULL) {
        fclose(file2);
    }
    if (file1 != NULL) {
        fclose(file1);
    }
    return 1;  // Error exit code
}
```

### goto in Switch Statements

`goto` can be used to jump between cases in switch statements:

```c
#include <stdio.h>

int main() {
    int state = 1;
    
    switch (state) {
        case 1:
            printf("State 1\n");
            goto state_3;  // Jump to case 3
        case 2:
            printf("State 2\n");
            break;
        case 3:
        state_3:
            printf("State 3\n");
            break;
        default:
            printf("Unknown state\n");
    }
    
    return 0;
}
```

## Function Calls as Control Flow

Function calls are a fundamental control flow mechanism that transfer execution to another part of the program. They enable code reuse, modularity, and structured programming.

### Basic Function Calls

```c
#include <stdio.h>

void print_hello() {
    printf("Hello from function!\n");
}

int add(int a, int b) {
    return a + b;
}

int main() {
    print_hello();  // Function call transfers control
    
    int result = add(5, 3);  // Function call with return value
    printf("5 + 3 = %d\n", result);
    
    return 0;
}
```

### Recursive Function Calls

Recursive functions call themselves to solve problems that can be broken down into smaller, similar subproblems:

```c
#include <stdio.h>

// Factorial calculation using recursion
int factorial(int n) {
    if (n <= 1) {
        return 1;  // Base case
    }
    return n * factorial(n - 1);  // Recursive call
}

// Fibonacci sequence using recursion
int fibonacci(int n) {
    if (n <= 1) {
        return n;  // Base cases
    }
    return fibonacci(n - 1) + fibonacci(n - 2);  // Recursive calls
}

int main() {
    int num = 5;
    
    printf("Factorial of %d: %d\n", num, factorial(num));
    printf("Fibonacci of %d: %d\n", num, fibonacci(num));
    
    return 0;
}
```

### Function Pointers for Dynamic Control Flow

Function pointers allow dynamic selection of which function to call at runtime:

```c
#include <stdio.h>

int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

int multiply(int a, int b) {
    return a * b;
}

int divide(int a, int b) {
    if (b != 0) {
        return a / b;
    }
    return 0;
}

int main() {
    int x = 10, y = 5;
    int (*operation)(int, int);  // Function pointer
    
    // Dynamic function selection
    char op;
    printf("Enter operation (+, -, *, /): ");
    scanf(" %c", &op);
    
    switch (op) {
        case '+':
            operation = add;
            break;
        case '-':
            operation = subtract;
            break;
        case '*':
            operation = multiply;
            break;
        case '/':
            operation = divide;
            break;
        default:
            printf("Invalid operation\n");
            return 1;
    }
    
    int result = operation(x, y);  // Call selected function
    printf("Result: %d\n", result);
    
    return 0;
}
```

## Error Handling Patterns

C doesn't have built-in exception handling, so error handling is typically done through return codes and careful checking.

### Return Code Pattern

```c
#include <stdio.h>
#include <stdlib.h>

#define SUCCESS 0
#define ERROR_INVALID_INPUT 1
#define ERROR_MEMORY_ALLOCATION 2
#define ERROR_FILE_OPERATION 3

int process_data(int *data, int size) {
    if (data == NULL || size <= 0) {
        return ERROR_INVALID_INPUT;
    }
    
    // Process data
    for (int i = 0; i < size; i++) {
        data[i] *= 2;
    }
    
    return SUCCESS;
}

int main() {
    int data[] = {1, 2, 3, 4, 5};
    int size = sizeof(data) / sizeof(data[0]);
    
    int result = process_data(data, size);
    
    switch (result) {
        case SUCCESS:
            printf("Data processed successfully!\n");
            for (int i = 0; i < size; i++) {
                printf("%d ", data[i]);
            }
            printf("\n");
            break;
        case ERROR_INVALID_INPUT:
            printf("Error: Invalid input data\n");
            break;
        case ERROR_MEMORY_ALLOCATION:
            printf("Error: Memory allocation failed\n");
            break;
        case ERROR_FILE_OPERATION:
            printf("Error: File operation failed\n");
            break;
        default:
            printf("Unknown error occurred\n");
    }
    
    return result;
}
```

### errno and perror for System Errors

```c
#include <stdio.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *file = fopen("nonexistent_file.txt", "r");
    
    if (file == NULL) {
        printf("Error opening file: %s\n", strerror(errno));
        perror("fopen");  // Alternative way to print error
        return errno;
    }
    
    fclose(file);
    return 0;
}
```

### Setjmp and Longjmp for Non-Local Jumps

The `setjmp` and `longjmp` functions provide a way to perform non-local jumps, similar to exceptions in other languages:

```c
#include <stdio.h>
#include <setjmp.h>
#include <stdlib.h>

jmp_buf jump_buffer;

void risky_function() {
    printf("Entering risky function\n");
    
    // Simulate an error condition
    int error_condition = 1;
    if (error_condition) {
        printf("Error occurred, jumping back!\n");
        longjmp(jump_buffer, 1);  // Jump back to setjmp
    }
    
    printf("This won't be printed\n");
}

int main() {
    int result = setjmp(jump_buffer);
    
    if (result == 0) {
        printf("First time through setjmp\n");
        risky_function();
    } else {
        printf("Returned from longjmp with value: %d\n", result);
    }
    
    return 0;
}
```

## Advanced Loop Control Techniques

### Loop Labels and Break to Outer Loops

While C doesn't support loop labels like some languages, you can achieve similar functionality using flags or goto:

```c
#include <stdio.h>

int main() {
    int found = 0;
    
    // Search for a value in a 2D array
    int matrix[3][3] = {{1, 2, 3}, {4, 5, 6}, {7, 8, 9}};
    int target = 5;
    
    for (int i = 0; i < 3 && !found; i++) {
        for (int j = 0; j < 3; j++) {
            if (matrix[i][j] == target) {
                printf("Found %d at position (%d, %d)\n", target, i, j);
                found = 1;
                break;  // Breaks inner loop
            }
        }
        // Outer loop will exit due to !found condition
    }
    
    return 0;
}
```

### State Machines

State machines are a powerful pattern for managing complex control flow:

```c
#include <stdio.h>

typedef enum {
    STATE_IDLE,
    STATE_PROCESSING,
    STATE_COMPLETE,
    STATE_ERROR
} State;

int main() {
    State current_state = STATE_IDLE;
    int input;
    
    while (current_state != STATE_COMPLETE && current_state != STATE_ERROR) {
        switch (current_state) {
            case STATE_IDLE:
                printf("Enter command (1=start, 2=quit): ");
                scanf("%d", &input);
                if (input == 1) {
                    current_state = STATE_PROCESSING;
                    printf("Processing started...\n");
                } else if (input == 2) {
                    current_state = STATE_COMPLETE;
                }
                break;
                
            case STATE_PROCESSING:
                printf("Enter data (0=complete, -1=error): ");
                scanf("%d", &input);
                if (input == 0) {
                    current_state = STATE_COMPLETE;
                    printf("Processing completed!\n");
                } else if (input == -1) {
                    current_state = STATE_ERROR;
                    printf("Processing error!\n");
                }
                break;
                
            case STATE_COMPLETE:
                printf("Process complete.\n");
                break;
                
            case STATE_ERROR:
                printf("Process error.\n");
                break;
        }
    }
    
    return 0;
}
```

## Best Practices for Advanced Control Flow

### 1. Use goto Sparingly and Structured

```c
// Good: Structured error handling with goto
int process_files() {
    FILE *file1 = NULL;
    FILE *file2 = NULL;
    int *buffer = NULL;
    int result = -1;  // Default error
    
    file1 = fopen("input.txt", "r");
    if (!file1) goto cleanup;
    
    file2 = fopen("output.txt", "w");
    if (!file2) goto cleanup;
    
    buffer = malloc(1024);
    if (!buffer) goto cleanup;
    
    // Main processing logic
    result = 0;  // Success
    
cleanup:
    if (buffer) free(buffer);
    if (file2) fclose(file2);
    if (file1) fclose(file1);
    return result;
}
```

### 2. Avoid Deep Nesting

```c
// Good: Early returns to reduce nesting
int validate_input(int value) {
    if (value < 0) {
        return -1;  // Invalid
    }
    
    if (value > 100) {
        return -1;  // Invalid
    }
    
    if (value % 2 != 0) {
        return -1;  // Invalid
    }
    
    return 0;  // Valid
}

// Avoid: Deep nesting
int validate_input_nested(int value) {
    if (value >= 0) {
        if (value <= 100) {
            if (value % 2 == 0) {
                return 0;  // Valid
            } else {
                return -1;  // Invalid
            }
        } else {
            return -1;  // Invalid
        }
    } else {
        return -1;  // Invalid
    }
}
```

### 3. Use Function Pointers for Strategy Pattern

```c
#include <stdio.h>

typedef int (*operation_func)(int, int);

int add(int a, int b) { return a + b; }
int subtract(int a, int b) { return a - b; }
int multiply(int a, int b) { return a * b; }

int calculate(int a, int b, operation_func op) {
    return op(a, b);
}

int main() {
    int x = 10, y = 5;
    
    printf("Add: %d\n", calculate(x, y, add));
    printf("Subtract: %d\n", calculate(x, y, subtract));
    printf("Multiply: %d\n", calculate(x, y, multiply));
    
    return 0;
}
```

## Common Pitfalls and How to Avoid Them

### 1. goto Leading to Spaghetti Code

```c
#include <stdio.h>

int main() {
    // Wrong: Complex goto usage leading to unreadable code
    int i = 0;
    goto start;
    
loop:
    printf("In loop: %d\n", i);
    i++;
    if (i < 5) goto loop;
    goto end;
    
start:
    printf("Starting...\n");
    goto loop;
    
end:
    printf("Ending...\n");
    
    // Correct: Use proper loop constructs
    printf("Starting...\n");
    for (int j = 0; j < 5; j++) {
        printf("In loop: %d\n", j);
    }
    printf("Ending...\n");
    
    return 0;
}
```

### 2. Infinite Recursion

```c
#include <stdio.h>

// Wrong: No base case
int factorial_wrong(int n) {
    return n * factorial_wrong(n - 1);  // Infinite recursion
}

// Correct: With proper base case
int factorial_correct(int n) {
    if (n <= 1) return 1;  // Base case
    return n * factorial_correct(n - 1);
}

int main() {
    printf("Factorial of 5: %d\n", factorial_correct(5));
    return 0;
}
```

### 3. Longjmp Across Function Boundaries

```c
#include <stdio.h>
#include <setjmp.h>

jmp_buf env;

void function_a() {
    printf("In function A\n");
    longjmp(env, 1);  // This is safe within the same function context
}

void function_b() {
    function_a();  // This is also safe
}

int main() {
    if (setjmp(env) == 0) {
        printf("Setting jump point\n");
        function_b();
    } else {
        printf("Jumped back!\n");
    }
    
    return 0;
}
```

## Practical Examples

### Resource Management with goto

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *name;
    int *data;
    FILE *file;
} ResourceContainer;

int initialize_resources(ResourceContainer *container) {
    // Allocate name
    container->name = malloc(50);
    if (!container->name) {
        goto cleanup;
    }
    strcpy(container->name, "Resource");
    
    // Allocate data
    container->data = malloc(100 * sizeof(int));
    if (!container->data) {
        goto cleanup;
    }
    
    // Open file
    container->file = fopen("data.txt", "w");
    if (!container->file) {
        goto cleanup;
    }
    
    return 0;  // Success
    
cleanup:
    // Clean up in reverse order
    if (container->file) {
        fclose(container->file);
    }
    if (container->data) {
        free(container->data);
    }
    if (container->name) {
        free(container->name);
    }
    return -1;  // Error
}

void cleanup_resources(ResourceContainer *container) {
    if (container->file) {
        fclose(container->file);
    }
    if (container->data) {
        free(container->data);
    }
    if (container->name) {
        free(container->name);
    }
    memset(container, 0, sizeof(ResourceContainer));
}

int main() {
    ResourceContainer container = {0};
    
    if (initialize_resources(&container) == 0) {
        printf("Resources initialized successfully\n");
        printf("Name: %s\n", container.name);
        // Use resources...
        cleanup_resources(&container);
    } else {
        printf("Failed to initialize resources\n");
        return 1;
    }
    
    return 0;
}
```

### Command-Line Parser with State Machine

```c
#include <stdio.h>
#include <string.h>

typedef enum {
    STATE_START,
    STATE_OPTION,
    STATE_ARGUMENT,
    STATE_DONE,
    STATE_ERROR
} ParseState;

typedef struct {
    int verbose;
    char *output_file;
    int count;
} Options;

int parse_arguments(int argc, char *argv[], Options *options) {
    ParseState state = STATE_START;
    
    for (int i = 1; i < argc && state != STATE_ERROR; i++) {
        switch (state) {
            case STATE_START:
                if (argv[i][0] == '-') {
                    state = STATE_OPTION;
                    i--;  // Re-process this argument
                } else {
                    state = STATE_DONE;
                }
                break;
                
            case STATE_OPTION:
                if (strcmp(argv[i], "-v") == 0) {
                    options->verbose = 1;
                } else if (strcmp(argv[i], "-o") == 0) {
                    state = STATE_ARGUMENT;
                } else if (strcmp(argv[i], "-c") == 0) {
                    state = STATE_ARGUMENT;
                } else {
                    printf("Unknown option: %s\n", argv[i]);
                    state = STATE_ERROR;
                }
                break;
                
            case STATE_ARGUMENT:
                if (strcmp(argv[i-1], "-o") == 0) {
                    options->output_file = argv[i];
                } else if (strcmp(argv[i-1], "-c") == 0) {
                    options->count = atoi(argv[i]);
                }
                state = STATE_START;
                break;
                
            case STATE_DONE:
            case STATE_ERROR:
                break;
        }
    }
    
    return (state == STATE_DONE || state == STATE_START) ? 0 : -1;
}

int main(int argc, char *argv[]) {
    Options options = {0};
    
    if (parse_arguments(argc, argv, &options) == 0) {
        printf("Parsing successful:\n");
        printf("  Verbose: %s\n", options.verbose ? "yes" : "no");
        printf("  Output file: %s\n", options.output_file ? options.output_file : "not specified");
        printf("  Count: %d\n", options.count);
    } else {
        printf("Parsing failed\n");
        return 1;
    }
    
    return 0;
}
```

### Complex Error Handling System

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

typedef enum {
    ERR_SUCCESS = 0,
    ERR_MEMORY,
    ERR_FILE_OPEN,
    ERR_FILE_READ,
    ERR_INVALID_INPUT,
    ERR_UNKNOWN
} ErrorCode;

const char* error_string(ErrorCode code) {
    switch (code) {
        case ERR_SUCCESS: return "Success";
        case ERR_MEMORY: return "Memory allocation failed";
        case ERR_FILE_OPEN: return "File open failed";
        case ERR_FILE_READ: return "File read failed";
        case ERR_INVALID_INPUT: return "Invalid input";
        case ERR_UNKNOWN: return "Unknown error";
        default: return "Unrecognized error";
    }
}

ErrorCode process_file(const char *filename) {
    FILE *file = NULL;
    char *buffer = NULL;
    ErrorCode result = ERR_SUCCESS;
    
    // Open file
    file = fopen(filename, "r");
    if (!file) {
        result = ERR_FILE_OPEN;
        goto cleanup;
    }
    
    // Allocate buffer
    buffer = malloc(1024);
    if (!buffer) {
        result = ERR_MEMORY;
        goto cleanup;
    }
    
    // Read file
    if (fread(buffer, 1, 1024, file) == 0) {
        if (feof(file)) {
            printf("File is empty\n");
        } else {
            result = ERR_FILE_READ;
            goto cleanup;
        }
    }
    
    printf("File processed successfully\n");
    
cleanup:
    if (buffer) free(buffer);
    if (file) fclose(file);
    return result;
}

int main() {
    const char *filename = "test.txt";
    ErrorCode result = process_file(filename);
    
    if (result == ERR_SUCCESS) {
        printf("Operation completed successfully\n");
    } else {
        printf("Error: %s\n", error_string(result));
        if (result == ERR_FILE_OPEN) {
            printf("System error: %s\n", strerror(errno));
        }
    }
    
    return result;
}
```

## Summary

In this chapter, you've learned about:

1. **goto Statement**: When and how to use unconditional jumps
2. **Function Calls**: Basic and recursive function calls as control flow
3. **Function Pointers**: Dynamic function selection and callback mechanisms
4. **Error Handling**: Return codes, errno, and advanced error management
5. **setjmp/longjmp**: Non-local jumps for exceptional control flow
6. **Advanced Loop Control**: Techniques for managing complex iterations
7. **State Machines**: Pattern for managing complex program states
8. **Best Practices**: Writing clean, maintainable advanced control flow
9. **Common Pitfalls**: Avoiding typical mistakes with advanced control structures

Advanced control flow mechanisms provide powerful tools for managing complex program execution, but they must be used carefully to maintain code quality. With these techniques, you can implement sophisticated control logic while maintaining readability and reliability.