# File I/O Functions

## Introduction

C provides a rich set of functions for performing input and output operations on files. These functions can be categorized into character I/O, line I/O, formatted I/O, and binary I/O functions. Each category serves different purposes and offers varying levels of control and convenience for file processing tasks.

Understanding these functions is crucial for effectively reading from and writing to files, whether you're processing text data, binary data, or structured information.

## Character I/O Functions

Character I/O functions allow reading and writing files one character at a time. These functions are useful for simple text processing and when fine-grained control over file operations is needed.

### fgetc() and getc()

Both functions read a single character from a file:

```c
int fgetc(FILE *stream);
int getc(FILE *stream);
```

**Key Points:**
- Returns the character read as an `unsigned char` cast to `int`
- Returns `EOF` on end of file or error
- `fgetc()` is a function, `getc()` may be a macro

### fputc() and putc()

Both functions write a single character to a file:

```c
int fputc(int char, FILE *stream);
int putc(int char, FILE *stream);
```

**Key Points:**
- Writes the character (cast to `unsigned char`) to the file
- Returns the written character on success
- Returns `EOF` on error
- `fputc()` is a function, `putc()` may be a macro

### ungetc()

Pushes a character back onto the input stream:

```c
int ungetc(int char, FILE *stream);
```

**Key Points:**
- Allows "unread" operations for parsing
- Only one character can be pushed back
- Returns the character on success, `EOF` on failure

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

int main() {
    FILE *input, *output;
    int ch;
    
    input = fopen("input.txt", "r");
    output = fopen("output.txt", "w");
    
    if (input == NULL || output == NULL) {
        printf("Error opening files\n");
        exit(EXIT_FAILURE);
    }
    
    // Convert lowercase to uppercase
    while ((ch = fgetc(input)) != EOF) {
        if (islower(ch)) {
            ch = toupper(ch);
        }
        fputc(ch, output);
    }
    
    // Demonstrate ungetc
    ch = fgetc(input);
    if (ch != EOF) {
        ungetc(ch, input);  // Push character back
        ch = fgetc(input);  // Read it again
        printf("Character read twice: %c\n", ch);
    }
    
    fclose(input);
    fclose(output);
    
    return 0;
}
```

## Line I/O Functions

Line I/O functions are designed for reading and writing entire lines of text, making them ideal for processing text files where data is organized in lines.

### fgets()

Reads a line from a file:

```c
char *fgets(char *str, int count, FILE *stream);
```

**Key Points:**
- Reads at most `count-1` characters
- Stops at newline or end of file
- Always null-terminates the string
- Stores newline in the buffer (if space available)
- Returns `str` on success, `NULL` on error or EOF

### fputs()

Writes a string to a file:

```c
int fputs(const char *str, FILE *stream);
```

**Key Points:**
- Writes string without null terminator
- Does not append newline automatically
- Returns non-negative value on success
- Returns `EOF` on error

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *fp;
    char line[256];
    
    fp = fopen("lines.txt", "w");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    // Write lines to file
    fputs("First line\n", fp);
    fputs("Second line\n", fp);
    fputs("Third line\n", fp);
    
    fclose(fp);
    
    // Read lines from file
    fp = fopen("lines.txt", "r");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    while (fgets(line, sizeof(line), fp) != NULL) {
        // Remove newline if present
        line[strcspn(line, "\n")] = '\0';
        printf("Read line: '%s'\n", line);
    }
    
    fclose(fp);
    return 0;
}
```

## Formatted I/O Functions

Formatted I/O functions provide high-level input and output operations similar to `printf()` and `scanf()`, but operate on files instead of standard streams.

### fprintf()

Writes formatted output to a file:

```c
int fprintf(FILE *stream, const char *format, ...);
```

**Key Points:**
- Works like `printf()` but writes to a file
- Returns number of characters written
- Returns negative value on error

### fscanf()

Reads formatted input from a file:

```c
int fscanf(FILE *stream, const char *format, ...);
```

**Key Points:**
- Works like `scanf()` but reads from a file
- Returns number of items successfully read
- Returns `EOF` on error or end of file

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    char name[50];
    double salary;
} Employee;

int main() {
    FILE *fp;
    Employee emp;
    
    // Write structured data to file
    fp = fopen("employees.txt", "w");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    fprintf(fp, "%d %s %.2f\n", 1, "John Doe", 50000.0);
    fprintf(fp, "%d %s %.2f\n", 2, "Jane Smith", 60000.0);
    fprintf(fp, "%d %s %.2f\n", 3, "Bob Johnson", 55000.0);
    
    fclose(fp);
    
    // Read structured data from file
    fp = fopen("employees.txt", "r");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    printf("Employee Records:\n");
    while (fscanf(fp, "%d %s %lf", &emp.id, emp.name, &emp.salary) == 3) {
        printf("ID: %d, Name: %s, Salary: %.2f\n", 
               emp.id, emp.name, emp.salary);
    }
    
    fclose(fp);
    return 0;
}
```

## Binary I/O Functions

Binary I/O functions allow reading and writing raw data in binary format, preserving the exact bit patterns of the data. These functions are essential for working with binary files like images, executables, or structured data.

### fwrite()

Writes binary data to a file:

```c
size_t fwrite(const void *ptr, size_t size, size_t count, FILE *stream);
```

**Key Points:**
- Writes `count` items of `size` bytes each
- Returns number of items successfully written
- Returns value less than `count` on error

### fread()

Reads binary data from a file:

```c
size_t fread(void *ptr, size_t size, size_t count, FILE *stream);
```

**Key Points:**
- Reads `count` items of `size` bytes each
- Returns number of items successfully read
- Returns value less than `count` on error or EOF

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int id;
    char name[20];
    double value;
} Record;

int main() {
    FILE *fp;
    Record records[] = {
        {1, "Record1", 100.5},
        {2, "Record2", 200.75},
        {3, "Record3", 300.25}
    };
    Record read_records[3];
    size_t written, read;
    
    // Write binary data
    fp = fopen("records.bin", "wb");
    if (fp == NULL) {
        printf("Error opening file for writing\n");
        exit(EXIT_FAILURE);
    }
    
    written = fwrite(records, sizeof(Record), 3, fp);
    if (written != 3) {
        printf("Error writing records\n");
    }
    
    fclose(fp);
    
    // Read binary data
    fp = fopen("records.bin", "rb");
    if (fp == NULL) {
        printf("Error opening file for reading\n");
        exit(EXIT_FAILURE);
    }
    
    read = fread(read_records, sizeof(Record), 3, fp);
    if (read != 3) {
        printf("Error reading records\n");
    }
    
    fclose(fp);
    
    // Display read data
    printf("Read Records:\n");
    for (int i = 0; i < 3; i++) {
        printf("ID: %d, Name: %s, Value: %.2f\n",
               read_records[i].id, read_records[i].name, read_records[i].value);
    }
    
    return 0;
}
```

## Practical Examples

### CSV File Processor
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int id;
    char name[50];
    int age;
    double salary;
} Employee;

int main() {
    FILE *input, *output;
    char line[256];
    Employee emp;
    double total_salary = 0;
    int count = 0;
    
    input = fopen("employees.csv", "r");
    output = fopen("report.txt", "w");
    
    if (input == NULL || output == NULL) {
        printf("Error opening files\n");
        exit(EXIT_FAILURE);
    }
    
    // Skip header line
    fgets(line, sizeof(line), input);
    
    fprintf(output, "Employee Report\n");
    fprintf(output, "===============\n");
    
    // Process each line
    while (fgets(line, sizeof(line), input) != NULL) {
        // Remove newline
        line[strcspn(line, "\n")] = '\0';
        
        // Parse CSV line
        if (sscanf(line, "%d,%[^,],%d,%lf", 
                   &emp.id, emp.name, &emp.age, &emp.salary) == 4) {
            fprintf(output, "ID: %d, Name: %s, Age: %d, Salary: %.2f\n",
                    emp.id, emp.name, emp.age, emp.salary);
            total_salary += emp.salary;
            count++;
        }
    }
    
    if (count > 0) {
        fprintf(output, "\nAverage Salary: %.2f\n", total_salary / count);
    }
    
    fclose(input);
    fclose(output);
    
    printf("Report generated successfully\n");
    return 0;
}
```

### Binary File Analyzer
```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    FILE *fp;
    unsigned char buffer[16];
    long offset = 0;
    size_t bytes_read;
    
    if (argc != 2) {
        printf("Usage: %s <filename>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    fp = fopen(argv[1], "rb");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    printf("Offset  Hex Dump                  ASCII\n");
    printf("------  --------                  -----\n");
    
    while ((bytes_read = fread(buffer, 1, sizeof(buffer), fp)) > 0) {
        // Print offset
        printf("%06lx  ", offset);
        
        // Print hex values
        for (size_t i = 0; i < sizeof(buffer); i++) {
            if (i < bytes_read) {
                printf("%02x ", buffer[i]);
            } else {
                printf("   ");
            }
            
            // Add extra space after 8 bytes
            if (i == 7) printf(" ");
        }
        
        printf(" ");
        
        // Print ASCII representation
        for (size_t i = 0; i < bytes_read; i++) {
            if (buffer[i] >= 32 && buffer[i] <= 126) {
                printf("%c", buffer[i]);
            } else {
                printf(".");
            }
        }
        
        printf("\n");
        offset += bytes_read;
    }
    
    fclose(fp);
    return 0;
}
```

## Error Handling and Best Practices

### Comprehensive Error Checking
```c
#include <stdio.h>
#include <stdlib.h>

int safe_file_copy(const char *source, const char *destination) {
    FILE *src, *dst;
    int ch;
    
    // Open source file
    src = fopen(source, "rb");
    if (src == NULL) {
        perror("Error opening source file");
        return -1;
    }
    
    // Open destination file
    dst = fopen(destination, "wb");
    if (dst == NULL) {
        perror("Error opening destination file");
        fclose(src);
        return -1;
    }
    
    // Copy data
    while ((ch = fgetc(src)) != EOF) {
        if (fputc(ch, dst) == EOF) {
            perror("Error writing to destination file");
            fclose(src);
            fclose(dst);
            return -1;
        }
    }
    
    // Check for read errors
    if (ferror(src)) {
        perror("Error reading source file");
        fclose(src);
        fclose(dst);
        return -1;
    }
    
    // Close files
    if (fclose(src) != 0) {
        perror("Error closing source file");
        fclose(dst);
        return -1;
    }
    
    if (fclose(dst) != 0) {
        perror("Error closing destination file");
        return -1;
    }
    
    return 0;  // Success
}

int main() {
    if (safe_file_copy("source.txt", "destination.txt") == 0) {
        printf("File copied successfully\n");
    } else {
        printf("File copy failed\n");
    }
    
    return 0;
}
```

## Summary

C's file I/O functions provide comprehensive capabilities for working with files:

1. **Character I/O**: `fgetc()`, `fputc()`, `ungetc()` for single character operations
2. **Line I/O**: `fgets()`, `fputs()` for line-based text processing
3. **Formatted I/O**: `fprintf()`, `fscanf()` for structured data input/output
4. **Binary I/O**: `fwrite()`, `fread()` for raw binary data operations

Each category of functions serves specific purposes and offers different levels of control and convenience. Proper error handling and understanding of text vs. binary modes are essential for robust file processing applications.