# Error Handling

Error handling is a critical aspect of robust software development. In C programming, where memory management and low-level operations are common, proper error handling becomes even more important. This chapter explores various error handling strategies and techniques in C.

## Introduction to Error Handling

Error handling refers to the process of anticipating, detecting, and resolving programming, application, or communication errors. In C, error handling is primarily manual since the language does not have built-in exception handling mechanisms like some other languages.

### Why Error Handling is Important

- **Program Stability**: Prevents crashes and unexpected termination
- **Data Integrity**: Ensures data consistency and prevents corruption
- **User Experience**: Provides meaningful feedback to users
- **Debugging**: Helps identify and resolve issues quickly
- **Security**: Prevents vulnerabilities that could be exploited

## Error Handling Strategies in C

### Return Codes

Return codes are the most common error handling mechanism in C. Functions return specific values to indicate success or failure.

#### Basic Return Code Pattern

```c
#include <stdio.h>
#include <stdlib.h>

// Function that returns 0 on success, non-zero on error
int divide(int a, int b, int *result) {
    if (b == 0) {
        return -1; // Error: division by zero
    }
    *result = a / b;
    return 0; // Success
}

int main() {
    int result;
    int error = divide(10, 2, &result);
    
    if (error != 0) {
        printf("Error occurred during division\n");
        return 1;
    }
    
    printf("Result: %d\n", result);
    return 0;
}
```

#### Enumerated Return Codes

Using enums for return codes makes the code more readable and maintainable.

```c
#include <stdio.h>

typedef enum {
    SUCCESS = 0,
    ERROR_INVALID_INPUT,
    ERROR_DIVISION_BY_ZERO,
    ERROR_MEMORY_ALLOCATION,
    ERROR_FILE_NOT_FOUND
} ErrorCode;

ErrorCode safe_divide(int a, int b, int *result) {
    if (a < 0 || b < 0) {
        return ERROR_INVALID_INPUT;
    }
    
    if (b == 0) {
        return ERROR_DIVISION_BY_ZERO;
    }
    
    *result = a / b;
    return SUCCESS;
}

int main() {
    int result;
    ErrorCode error = safe_divide(10, 2, &result);
    
    switch (error) {
        case SUCCESS:
            printf("Result: %d\n", result);
            break;
        case ERROR_INVALID_INPUT:
            printf("Error: Invalid input values\n");
            break;
        case ERROR_DIVISION_BY_ZERO:
            printf("Error: Division by zero\n");
            break;
        default:
            printf("Unknown error occurred\n");
            break;
    }
    
    return error;
}
```

### Global Error Variables

C provides global variables like `errno` for system-level error reporting.

#### Using errno

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *file = fopen("nonexistent.txt", "r");
    
    if (file == NULL) {
        printf("Error opening file: %s\n", strerror(errno));
        return 1;
    }
    
    fclose(file);
    return 0;
}
```

#### Custom Error Variables

For application-specific errors, you can create your own global error variables.

```c
#include <stdio.h>
#include <string.h>

// Global error variable
static int app_errno = 0;

// Error codes
#define APP_SUCCESS 0
#define APP_ERROR_INVALID_DATA 1
#define APP_ERROR_BUFFER_OVERFLOW 2
#define APP_ERROR_NETWORK_FAILURE 3

// Function to get error description
const char* app_strerror(int error_code) {
    switch (error_code) {
        case APP_SUCCESS:
            return "Success";
        case APP_ERROR_INVALID_DATA:
            return "Invalid data";
        case APP_ERROR_BUFFER_OVERFLOW:
            return "Buffer overflow";
        case APP_ERROR_NETWORK_FAILURE:
            return "Network failure";
        default:
            return "Unknown error";
    }
}

// Function that sets app_errno
int process_data(const char *data) {
    if (data == NULL) {
        app_errno = APP_ERROR_INVALID_DATA;
        return -1;
    }
    
    if (strlen(data) > 100) {
        app_errno = APP_ERROR_BUFFER_OVERFLOW;
        return -1;
    }
    
    // Process data...
    app_errno = APP_SUCCESS;
    return 0;
}

int main() {
    int result = process_data(NULL);
    
    if (result != 0) {
        printf("Error: %s\n", app_strerror(app_errno));
        return 1;
    }
    
    printf("Data processed successfully\n");
    return 0;
}
```

## Advanced Error Handling Techniques

### Setjmp and Longjmp

C provides `setjmp` and `longjmp` for non-local jumps, which can be used for exception-like behavior.

```c
#include <stdio.h>
#include <stdlib.h>
#include <setjmp.h>
#include <string.h>

// Jump buffer for error handling
static jmp_buf error_buffer;

// Custom exception-like function
void throw_error(const char *message) {
    printf("Error: %s\n", message);
    longjmp(error_buffer, 1);
}

// Function that might fail
void risky_function(const char *data) {
    if (data == NULL) {
        throw_error("Null pointer passed to risky_function");
    }
    
    if (strlen(data) == 0) {
        throw_error("Empty string passed to risky_function");
    }
    
    printf("Processing data: %s\n", data);
}

int main() {
    // Set jump point
    if (setjmp(error_buffer) == 0) {
        // Normal execution path
        printf("Calling risky_function...\n");
        risky_function("Hello, World!");
        risky_function(NULL); // This will cause an error
    } else {
        // Error handling path
        printf("Error handled, continuing execution...\n");
    }
    
    printf("Program continues...\n");
    return 0;
}
```

### Resource Acquisition Is Initialization (RAII)

While not native to C, RAII principles can be implemented using goto statements for cleanup.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *name;
    int *data;
    FILE *file;
} ResourceContainer;

int process_resources() {
    ResourceContainer container = {0};
    int result = -1; // Assume failure
    
    // Allocate resources
    container.name = malloc(100);
    if (container.name == NULL) {
        fprintf(stderr, "Failed to allocate name buffer\n");
        goto cleanup;
    }
    
    container.data = malloc(1000 * sizeof(int));
    if (container.data == NULL) {
        fprintf(stderr, "Failed to allocate data array\n");
        goto cleanup;
    }
    
    container.file = fopen("data.txt", "w");
    if (container.file == NULL) {
        fprintf(stderr, "Failed to open file\n");
        goto cleanup;
    }
    
    // Use resources
    strcpy(container.name, "Test Data");
    for (int i = 0; i < 1000; i++) {
        container.data[i] = i * i;
        fprintf(container.file, "%d\n", container.data[i]);
    }
    
    result = 0; // Success
    
cleanup:
    // Clean up resources in reverse order
    if (container.file != NULL) {
        fclose(container.file);
    }
    
    if (container.data != NULL) {
        free(container.data);
    }
    
    if (container.name != NULL) {
        free(container.name);
    }
    
    return result;
}

int main() {
    if (process_resources() != 0) {
        printf("Error occurred during resource processing\n");
        return 1;
    }
    
    printf("Resources processed successfully\n");
    return 0;
}
```

## Error Handling Best Practices

### Check All Return Values

Always check return values from functions, especially system calls and library functions.

```c
#include <stdio.h>
#include <stdlib.h>

int safe_file_operations() {
    FILE *file = fopen("example.txt", "w");
    if (file == NULL) {
        perror("Failed to open file");
        return -1;
    }
    
    if (fprintf(file, "Hello, World!\n") < 0) {
        perror("Failed to write to file");
        fclose(file);
        return -1;
    }
    
    if (fclose(file) != 0) {
        perror("Failed to close file");
        return -1;
    }
    
    return 0;
}
```

### Use Assertions for Debugging

Assertions help catch programming errors during development.

```c
#include <stdio.h>
#include <assert.h>

int calculate_average(int *array, int size) {
    // Precondition checks
    assert(array != NULL);
    assert(size > 0);
    
    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += array[i];
    }
    
    return sum / size;
}

int main() {
    int numbers[] = {1, 2, 3, 4, 5};
    int average = calculate_average(numbers, 5);
    printf("Average: %d\n", average);
    
    // These would trigger assertions:
    // calculate_average(NULL, 5);  // Assertion failed
    // calculate_average(numbers, 0);  // Assertion failed
    
    return 0;
}
```

### Provide Meaningful Error Messages

Error messages should be clear and informative to help with debugging.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef enum {
    ERR_SUCCESS = 0,
    ERR_NULL_POINTER,
    ERR_INVALID_SIZE,
    ERR_MEMORY_ALLOCATION,
    ERR_FILE_OPERATION
} ErrorType;

const char* get_error_message(ErrorType error, const char *context) {
    static char message[256];
    
    switch (error) {
        case ERR_SUCCESS:
            snprintf(message, sizeof(message), "Success in %s", context);
            break;
        case ERR_NULL_POINTER:
            snprintf(message, sizeof(message), "Null pointer error in %s", context);
            break;
        case ERR_INVALID_SIZE:
            snprintf(message, sizeof(message), "Invalid size parameter in %s", context);
            break;
        case ERR_MEMORY_ALLOCATION:
            snprintf(message, sizeof(message), "Memory allocation failed in %s", context);
            break;
        case ERR_FILE_OPERATION:
            snprintf(message, sizeof(message), "File operation failed in %s", context);
            break;
        default:
            snprintf(message, sizeof(message), "Unknown error in %s", context);
            break;
    }
    
    return message;
}

int safe_memory_copy(char *dest, const char *src, size_t size) {
    if (dest == NULL) {
        fprintf(stderr, "%s\n", get_error_message(ERR_NULL_POINTER, "safe_memory_copy"));
        return -1;
    }
    
    if (src == NULL) {
        fprintf(stderr, "%s\n", get_error_message(ERR_NULL_POINTER, "safe_memory_copy"));
        return -1;
    }
    
    if (size == 0) {
        fprintf(stderr, "%s\n", get_error_message(ERR_INVALID_SIZE, "safe_memory_copy"));
        return -1;
    }
    
    strncpy(dest, src, size - 1);
    dest[size - 1] = '\0';
    
    return 0;
}
```

### Implement Error Logging

Logging errors helps with debugging and monitoring in production environments.

```c
#include <stdio.h>
#include <time.h>
#include <stdarg.h>

typedef enum {
    LOG_DEBUG,
    LOG_INFO,
    LOG_WARNING,
    LOG_ERROR,
    LOG_CRITICAL
} LogLevel;

void log_message(LogLevel level, const char *format, ...) {
    const char *level_strings[] = {
        "DEBUG", "INFO", "WARNING", "ERROR", "CRITICAL"
    };
    
    // Get current time
    time_t now = time(NULL);
    struct tm *tm_info = localtime(&now);
    char timestamp[20];
    strftime(timestamp, sizeof(timestamp), "%Y-%m-%d %H:%M:%S", tm_info);
    
    // Print log level and timestamp
    printf("[%s] [%s] ", timestamp, level_strings[level]);
    
    // Print formatted message
    va_list args;
    va_start(args, format);
    vprintf(format, args);
    va_end(args);
    
    printf("\n");
}

int divide_with_logging(int a, int b, int *result) {
    log_message(LOG_DEBUG, "divide_with_logging called with a=%d, b=%d", a, b);
    
    if (b == 0) {
        log_message(LOG_ERROR, "Division by zero attempted");
        return -1;
    }
    
    *result = a / b;
    log_message(LOG_INFO, "Division successful: %d / %d = %d", a, b, *result);
    return 0;
}
```

## Error Handling in Different Contexts

### File I/O Error Handling

File operations require careful error handling due to various failure points.

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

typedef struct {
    int id;
    char name[50];
    double value;
} Record;

int read_records(const char *filename, Record *records, int max_records, int *record_count) {
    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
        fprintf(stderr, "Error opening file %s: %s\n", filename, strerror(errno));
        return -1;
    }
    
    *record_count = 0;
    Record temp;
    
    while (*record_count < max_records) {
        size_t elements_read = fread(&temp, sizeof(Record), 1, file);
        if (elements_read == 1) {
            records[*record_count] = temp;
            (*record_count)++;
        } else {
            if (feof(file)) {
                // End of file reached normally
                break;
            } else if (ferror(file)) {
                // Error occurred
                fprintf(stderr, "Error reading from file: %s\n", strerror(errno));
                fclose(file);
                return -1;
            }
        }
    }
    
    if (fclose(file) != 0) {
        fprintf(stderr, "Error closing file: %s\n", strerror(errno));
        return -1;
    }
    
    return 0;
}
```

### Memory Management Error Handling

Proper memory management is crucial in C to prevent leaks and corruption.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char *data;
    size_t size;
    size_t capacity;
} DynamicBuffer;

DynamicBuffer* create_buffer(size_t initial_capacity) {
    DynamicBuffer *buffer = malloc(sizeof(DynamicBuffer));
    if (buffer == NULL) {
        fprintf(stderr, "Failed to allocate buffer structure\n");
        return NULL;
    }
    
    buffer->data = malloc(initial_capacity);
    if (buffer->data == NULL) {
        fprintf(stderr, "Failed to allocate buffer data\n");
        free(buffer);
        return NULL;
    }
    
    buffer->size = 0;
    buffer->capacity = initial_capacity;
    return buffer;
}

int append_to_buffer(DynamicBuffer *buffer, const char *data, size_t data_size) {
    if (buffer == NULL || data == NULL) {
        return -1;
    }
    
    // Check if we need to resize
    if (buffer->size + data_size > buffer->capacity) {
        size_t new_capacity = buffer->capacity * 2;
        while (new_capacity < buffer->size + data_size) {
            new_capacity *= 2;
        }
        
        char *new_data = realloc(buffer->data, new_capacity);
        if (new_data == NULL) {
            fprintf(stderr, "Failed to resize buffer\n");
            return -1;
        }
        
        buffer->data = new_data;
        buffer->capacity = new_capacity;
    }
    
    // Copy data
    memcpy(buffer->data + buffer->size, data, data_size);
    buffer->size += data_size;
    
    return 0;
}

void destroy_buffer(DynamicBuffer *buffer) {
    if (buffer != NULL) {
        free(buffer->data);
        free(buffer);
    }
}
```

## Conclusion

Error handling is a fundamental aspect of writing robust C programs. By using appropriate error handling strategies, checking return values, providing meaningful error messages, and implementing proper cleanup procedures, developers can create more reliable and maintainable software. The key is to anticipate potential failure points and handle them gracefully, ensuring that programs can recover from errors or fail safely when recovery is not possible.