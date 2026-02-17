# File Operations

## Introduction

File operations are fundamental to most real-world C programs, allowing them to persist data beyond program execution, process large datasets, and interact with the file system. Understanding how to properly open, read, write, and close files is essential for any C programmer working on applications that need to store or retrieve data.

In C, file operations are performed using the standard library functions defined in `<stdio.h>`. These functions provide a high-level interface for working with files, abstracting away the underlying operating system details while still offering fine-grained control when needed.

## File Pointers and the FILE Structure

In C, all file operations are performed through file pointers, which are pointers to a special structure called `FILE`. This structure contains all the information needed to manage a file, including buffering information, current position, error status, and more.

```c
#include <stdio.h>

FILE *fp;  // Declaration of a file pointer
```

The `FILE` structure is implementation-defined, meaning its exact contents vary between different C implementations, but it typically contains:
- Buffer for efficient I/O operations
- Current file position
- Error and end-of-file indicators
- File mode information
- System file descriptor

## Opening Files

Before performing any operations on a file, it must be opened using the `fopen()` function. This function takes two parameters: the file name and the mode in which to open the file.

### Syntax
```c
FILE *fopen(const char *filename, const char *mode);
```

### File Opening Modes

| Mode | Description | File Position | File Creation |
|------|-------------|---------------|---------------|
| `"r"` | Read only | Beginning | No |
| `"w"` | Write only | Beginning | Yes (truncates if exists) |
| `"a"` | Append only | End | Yes |
| `"r+"` | Read and write | Beginning | No |
| `"w+"` | Read and write | Beginning | Yes (truncates if exists) |
| `"a+"` | Read and append | End | Yes |

For binary files, append `b` to any of the above modes (e.g., `"rb"`, `"wb"`, `"ab"`).

### Examples
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    
    // Open file for reading
    fp = fopen("data.txt", "r");
    if (fp == NULL) {
        printf("Error: Could not open file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    // Open file for writing (creates new or truncates existing)
    fp = fopen("output.txt", "w");
    if (fp == NULL) {
        printf("Error: Could not open file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    // Open file for appending
    fp = fopen("log.txt", "a");
    if (fp == NULL) {
        printf("Error: Could not open file for appending\n");
        exit(EXIT_FAILURE);
    }
    
    // Open binary file for reading
    fp = fopen("image.bin", "rb");
    if (fp == NULL) {
        printf("Error: Could not open binary file\n");
        exit(EXIT_FAILURE);
    }
    
    // Don't forget to close files when done
    fclose(fp);
    
    return 0;
}
```

## Text vs. Binary Files

### Text Files
Text files contain human-readable characters organized into lines. When working with text files:
- Data is processed as characters
- Line endings may be translated (e.g., `\n` to `\r\n` on Windows)
- Whitespace and formatting are preserved
- Suitable for configuration files, logs, source code, etc.

### Binary Files
Binary files contain raw data in the same format used internally by the computer. When working with binary files:
- Data is processed as bytes without translation
- No line ending translation occurs
- Exact bit patterns are preserved
- Suitable for images, executables, databases, etc.

```c
#include <stdio.h>

int main() {
    FILE *text_file, *binary_file;
    
    // Text file operations
    text_file = fopen("document.txt", "w");
    fprintf(text_file, "Hello, World!\n");
    fclose(text_file);
    
    // Binary file operations
    binary_file = fopen("data.bin", "wb");
    int numbers[] = {1, 2, 3, 4, 5};
    fwrite(numbers, sizeof(int), 5, binary_file);
    fclose(binary_file);
    
    return 0;
}
```

## Closing Files

After completing file operations, files should be closed using the `fclose()` function. This ensures that any buffered data is written to the file and system resources are released.

### Syntax
```c
int fclose(FILE *stream);
```

### Return Value
- `0` on success
- `EOF` on failure

### Example
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    
    fp = fopen("example.txt", "w");
    if (fp == NULL) {
        printf("Error opening file\n");
        exit(EXIT_FAILURE);
    }
    
    fprintf(fp, "This is a test file.\n");
    
    // Close the file
    if (fclose(fp) != 0) {
        printf("Error closing file\n");
        exit(EXIT_FAILURE);
    }
    
    printf("File closed successfully\n");
    
    return 0;
}
```

## Error Handling in File Operations

Proper error handling is crucial when working with files, as many things can go wrong (file not found, permission denied, disk full, etc.).

### Checking fopen() Results
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    
    fp = fopen("nonexistent.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");  // Prints system error message
        exit(EXIT_FAILURE);
    }
    
    // File operations here...
    
    fclose(fp);
    return 0;
}
```

### Using errno for Detailed Error Information
```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

int main() {
    FILE *fp;
    
    fp = fopen("test.txt", "r");
    if (fp == NULL) {
        fprintf(stderr, "Error opening file: %s\n", strerror(errno));
        exit(EXIT_FAILURE);
    }
    
    fclose(fp);
    return 0;
}
```

## File Status Functions

C provides several functions to check the status of file operations:

### feof()
Checks if end-of-file has been reached:
```c
int feof(FILE *stream);
```

### ferror()
Checks if an error has occurred:
```c
int ferror(FILE *stream);
```

### clearerr()
Clears error and end-of-file indicators:
```c
void clearerr(FILE *stream);
```

### Example
```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    int ch;
    
    fp = fopen("example.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    // Read characters until end of file or error
    while ((ch = fgetc(fp)) != EOF) {
        putchar(ch);
    }
    
    // Check why loop terminated
    if (feof(fp)) {
        printf("\nEnd of file reached\n");
    } else if (ferror(fp)) {
        printf("\nError occurred while reading\n");
        clearerr(fp);  // Clear error indicator
    }
    
    fclose(fp);
    return 0;
}
```

## File Buffering

C uses buffering to improve I/O performance. There are three types of buffering:

1. **Fully Buffered**: Data is written to/from buffer when it's full/empty
2. **Line Buffered**: Data is written when a newline character is encountered
3. **Unbuffered**: Data is written immediately

### Buffer Control Functions
```c
// Force writing of buffered data
int fflush(FILE *stream);

// Change buffering mode
int setvbuf(FILE *stream, char *buffer, int mode, size_t size);
```

### Example
```c
#include <stdio.h>

int main() {
    FILE *fp;
    
    fp = fopen("buffered.txt", "w");
    
    // Force immediate output
    printf("This might be buffered\n");
    fflush(stdout);  // Force output to terminal
    
    fprintf(fp, "This is buffered file output\n");
    fflush(fp);  // Force output to file
    
    fclose(fp);
    return 0;
}
```

## Practical Examples

### Simple File Copy Program
```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *source, *destination;
    int ch;
    
    if (argc != 3) {
        printf("Usage: %s <source> <destination>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    // Open source file for reading
    source = fopen(argv[1], "rb");
    if (source == NULL) {
        perror("Error opening source file");
        exit(EXIT_FAILURE);
    }
    
    // Open destination file for writing
    destination = fopen(argv[2], "wb");
    if (destination == NULL) {
        perror("Error opening destination file");
        fclose(source);
        exit(EXIT_FAILURE);
    }
    
    // Copy data
    while ((ch = fgetc(source)) != EOF) {
        fputc(ch, destination);
    }
    
    // Check for read errors
    if (ferror(source)) {
        printf("Error reading source file\n");
    }
    
    // Close files
    fclose(source);
    fclose(destination);
    
    printf("File copied successfully\n");
    return 0;
}
```

### File Information Program
```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *fp;
    long size;
    
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    // Get file size
    fseek(fp, 0, SEEK_END);  // Go to end of file
    size = ftell(fp);         // Get current position (file size)
    fseek(fp, 0, SEEK_SET);   // Go back to beginning
    
    printf("File: %s\n", argv[1]);
    printf("Size: %ld bytes\n", size);
    
    fclose(fp);
    return 0;
}
```

## Best Practices

1. **Always check return values** from file operations
2. **Close files explicitly** when done with them
3. **Use appropriate file modes** for your intended operations
4. **Handle binary files correctly** with binary modes
5. **Check for errors** using `perror()` or `strerror()`
6. **Use `fflush()`** when immediate output is required
7. **Be aware of buffering** effects on program behavior
8. **Free allocated buffers** when using custom buffering

## Summary

File operations in C provide a powerful interface for working with persistent data storage. Key concepts include:
- File pointers and the `FILE` structure
- Opening files with appropriate modes
- Understanding text vs. binary file differences
- Proper error handling and status checking
- File buffering and performance considerations
- Closing files to release resources

Mastering these concepts is essential for building robust C applications that interact with the file system.