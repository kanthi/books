# Module 8: File I/O Exercises

## Exercise 1: Basic File Operations
Write a program that performs fundamental file operations:
- Create and write text to a file
- Read and display the contents of a file
- Append new content to an existing file
- Copy one file to another
- Check if a file exists and get its properties

**Requirements:**
- Use proper file handling functions (fopen, fclose, etc.)
- Include error checking for all file operations
- Handle different file modes appropriately
- Implement proper resource cleanup
- Provide clear feedback for operation results

## Exercise 2: Text File Processing
Create a program that processes text files in various ways:
- Count lines, words, and characters in a text file
- Search for specific patterns or words in a file
- Replace occurrences of a word with another word
- Extract specific lines or sections from a file
- Format and restructure text data

**Requirements:**
- Use appropriate text file I/O functions
- Handle large files efficiently
- Include proper buffer management
- Implement case-sensitive and case-insensitive searches
- Provide statistics and progress feedback

## Exercise 3: Binary File Operations
Develop a program that works with binary files:
- Create and read binary data files
- Implement a simple database using binary files
- Serialize and deserialize structures to/from binary files
- Handle endianness when working with binary data
- Include data validation and integrity checking

**Requirements:**
- Use binary file modes appropriately
- Handle structure padding and alignment issues
- Implement proper error checking for binary operations
- Include byte order conversion functions if needed
- Provide examples of practical binary file applications

## Exercise 4: File System Operations
Write a program that performs file system level operations:
- List files and directories in a given path
- Create, rename, and delete files and directories
- Check file permissions and attributes
- Implement a simple file browser
- Handle file system errors gracefully

**Requirements:**
- Use platform-appropriate file system functions
- Include proper error handling for system calls
- Handle cross-platform compatibility issues
- Implement recursive directory operations
- Provide clear user interface for file system operations

## Exercise 5: Random Access Files
Create a program that demonstrates random access file operations:
- Implement direct record access in a data file
- Create an index for fast data retrieval
- Update specific records without reading entire file
- Handle file positioning with fseek and ftell
- Implement a simple database with random access

**Requirements:**
- Use fseek, ftell, and rewind appropriately
- Handle fixed and variable record lengths
- Include proper data serialization for records
- Implement error checking for positioning operations
- Provide efficient access patterns for large datasets

## Exercise 6: Advanced File I/O Techniques
Write a program that implements advanced file handling concepts:
- Use file buffering and flushing strategies
- Implement non-blocking I/O operations
- Create temporary files and handle automatic cleanup
- Work with file locking for concurrent access
- Implement file compression and decompression (bonus)

**Requirements:**
- Include proper buffer management and flushing
- Handle concurrent access scenarios safely
- Implement proper cleanup for temporary files
- Include error recovery mechanisms
- Document performance considerations for different approaches

## Exercise 7: Error Handling and Recovery
Create a program that demonstrates robust file error handling:
- Implement comprehensive error checking for all file operations
- Create recovery mechanisms for interrupted operations
- Handle disk full and other system-level errors
- Implement logging for file operations
- Include graceful degradation for non-critical failures

**Requirements:**
- Check return values from all file functions
- Provide meaningful error messages for different failure scenarios
- Implement retry mechanisms for transient errors
- Include proper cleanup in error paths
- Document error handling strategies clearly

## Exercise 8: Comprehensive File Management System
Design a complete application that integrates all file I/O concepts:
- Implement a full-featured file manager with GUI or CLI interface
- Create backup and restore functionality
- Implement file synchronization between directories
- Include search and filtering capabilities
- Provide comprehensive error handling and logging

**Requirements:**
- Use modular design with clear separation of concerns
- Include proper documentation for all components
- Handle all file operations safely and efficiently
- Implement robust error handling throughout
- Provide clear examples and test cases

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Function to write text to a file
int write_text_file(const char *filename, const char *text) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Could not open file %s for writing\n", filename);
        return -1;
    }
    
    if (fputs(text, file) == EOF) {
        printf("Error: Failed to write to file %s\n", filename);
        fclose(file);
        return -1;
    }
    
    fclose(file);
    return 0;
}

// Function to read and display file contents
int read_text_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        printf("Error: Could not open file %s for reading\n", filename);
        return -1;
    }
    
    char buffer[1024];
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }
    
    if (ferror(file)) {
        printf("Error: Failed to read from file %s\n", filename);
        fclose(file);
        return -1;
    }
    
    fclose(file);
    return 0;
}

// Function to append text to a file
int append_text_file(const char *filename, const char *text) {
    FILE *file = fopen(filename, "a");
    if (file == NULL) {
        printf("Error: Could not open file %s for appending\n", filename);
        return -1;
    }
    
    if (fputs(text, file) == EOF) {
        printf("Error: Failed to append to file %s\n", filename);
        fclose(file);
        return -1;
    }
    
    fclose(file);
    return 0;
}

int main() {
    const char *filename = "test.txt";
    const char *initial_text = "This is the initial content.\nLine 2\nLine 3\n";
    const char *append_text = "This line was appended.\n";
    
    // Write initial content
    if (write_text_file(filename, initial_text) != 0) {
        return 1;
    }
    printf("Wrote initial content to %s\n", filename);
    
    // Read and display content
    printf("\nFile contents:\n");
    if (read_text_file(filename) != 0) {
        return 1;
    }
    
    // Append additional content
    if (append_text_file(filename, append_text) != 0) {
        return 1;
    }
    printf("\nAppended content to %s\n", filename);
    
    // Read and display updated content
    printf("\nUpdated file contents:\n");
    if (read_text_file(filename) != 0) {
        return 1;
    }
    
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure for binary data
typedef struct {
    int id;
    char name[32];
    double value;
} Record;

// Function to write records to binary file
int write_records(const char *filename, const Record *records, int count) {
    FILE *file = fopen(filename, "wb");
    if (file == NULL) {
        printf("Error: Could not open file %s for writing\n", filename);
        return -1;
    }
    
    if (fwrite(records, sizeof(Record), count, file) != (size_t)count) {
        printf("Error: Failed to write all records to file %s\n", filename);
        fclose(file);
        return -1;
    }
    
    fclose(file);
    return 0;
}

// Function to read records from binary file
int read_records(const char *filename, Record *records, int max_count) {
    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
        printf("Error: Could not open file %s for reading\n", filename);
        return -1;
    }
    
    size_t records_read = fread(records, sizeof(Record), max_count, file);
    if (ferror(file)) {
        printf("Error: Failed to read records from file %s\n", filename);
        fclose(file);
        return -1;
    }
    
    fclose(file);
    return (int)records_read;
}

int main() {
    // Create sample records
    Record records[] = {
        {1, "Record One", 100.50},
        {2, "Record Two", 200.75},
        {3, "Record Three", 300.25}
    };
    int record_count = sizeof(records) / sizeof(records[0]);
    
    const char *filename = "records.dat";
    
    // Write records to binary file
    if (write_records(filename, records, record_count) != 0) {
        return 1;
    }
    printf("Wrote %d records to %s\n", record_count, filename);
    
    // Read records from binary file
    Record read_records[10];
    int read_count = read_records(filename, read_records, 10);
    if (read_count < 0) {
        return 1;
    }
    
    printf("\nRead %d records from %s:\n", read_count, filename);
    for (int i = 0; i < read_count; i++) {
        printf("ID: %d, Name: %s, Value: %.2f\n", 
               read_records[i].id, read_records[i].name, read_records[i].value);
    }
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **File handle leaks**: Always close files with fclose
2. **Buffer overflows**: Check buffer sizes when reading text
3. **Binary mode issues**: Use "rb"/"wb" for binary files on all platforms
4. **Error checking**: Always check return values from file functions
5. **Path separators**: Handle cross-platform path differences properly

### Best Practices:
1. **Resource management**: Use RAII-like patterns for file handles
2. **Error handling**: Implement comprehensive error checking
3. **Buffer management**: Use appropriate buffer sizes for efficiency
4. **File modes**: Choose correct file modes for intended operations
5. **Data integrity**: Include validation and checksums for critical data

Complete these exercises to solidify your understanding of file I/O in C. Each exercise builds upon the previous ones, gradually increasing in complexity.