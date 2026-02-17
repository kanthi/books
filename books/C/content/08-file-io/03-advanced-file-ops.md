# Advanced File Operations

## Introduction

Advanced file operations in C go beyond basic reading and writing to include sophisticated techniques such as file positioning, random access, temporary file management, and concurrent access control. These operations are essential for building efficient file processing applications, database systems, and other programs that require fine-grained control over file access.

Understanding these advanced concepts enables programmers to create more robust and performant file-handling code, particularly when dealing with large files or complex data structures.

## File Positioning

File positioning functions allow you to move the file pointer to specific locations within a file, enabling random access to data. This is particularly useful for databases, configuration files, and other structured data formats.

### fseek()

Moves the file pointer to a specified position:

```c
int fseek(FILE *stream, long offset, int origin);
```

**Parameters:**
- `stream`: File pointer
- `offset`: Number of bytes to move (can be negative)
- `origin`: Reference point for the offset

**Origin Values:**
- `SEEK_SET`: Beginning of file
- `SEEK_CUR`: Current position
- `SEEK_END`: End of file

**Return Value:**
- `0` on success
- Non-zero on error

### ftell()

Returns the current position of the file pointer:

```c
long ftell(FILE *stream);
```

**Return Value:**
- Current file position (in bytes from beginning)
- `-1L` on error

### rewind()

Moves the file pointer to the beginning of the file:

```c
void rewind(FILE *stream);
```

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    char buffer[100];
    
    // Create a test file
    fp = fopen("test.txt", "w");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    fprintf(fp, "Line 1: This is the first line.\n");
    fprintf(fp, "Line 2: This is the second line.\n");
    fprintf(fp, "Line 3: This is the third line.\n");
    fclose(fp);
    
    // Open for reading and demonstrate positioning
    fp = fopen("test.txt", "r");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    // Read first line
    fgets(buffer, sizeof(buffer), fp);
    printf("First line: %s", buffer);
    
    // Move to beginning of file
    rewind(fp);
    fgets(buffer, sizeof(buffer), fp);
    printf("First line again: %s", buffer);
    
    // Move to position 20 from beginning
    fseek(fp, 20, SEEK_SET);
    fgets(buffer, sizeof(buffer), fp);
    printf("From position 20: %s", buffer);
    
    // Get current position
    long pos = ftell(fp);
    printf("Current position: %ld\n", pos);
    
    // Move 10 bytes forward from current position
    fseek(fp, 10, SEEK_CUR);
    pos = ftell(fp);
    printf("Position after moving 10 bytes forward: %ld\n", pos);
    
    fclose(fp);
    return 0;
}
```

## Random Access Files

Random access files allow direct access to any part of the file without reading through preceding data. This is particularly useful for databases and other applications where quick access to specific records is required.

### Structured Data Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define RECORD_SIZE 64

typedef struct {
    int id;
    char name[20];
    double value;
} Record;

// Write records to file
void write_records(const char *filename) {
    FILE *fp;
    Record records[] = {
        {1, "Record1", 100.5},
        {2, "Record2", 200.75},
        {3, "Record3", 300.25},
        {4, "Record4", 400.0},
        {5, "Record5", 500.75}
    };
    
    fp = fopen(filename, "wb");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    for (int i = 0; i < 5; i++) {
        fwrite(&records[i], sizeof(Record), 1, fp);
    }
    
    fclose(fp);
}

// Read specific record by ID
int read_record(const char *filename, int record_id, Record *record) {
    FILE *fp;
    long position = (record_id - 1) * sizeof(Record);
    
    fp = fopen(filename, "rb");
    if (fp == NULL) {
        perror("Error opening file");
        return -1;
    }
    
    // Position to the specific record
    if (fseek(fp, position, SEEK_SET) != 0) {
        perror("Error seeking to record");
        fclose(fp);
        return -1;
    }
    
    // Read the record
    if (fread(record, sizeof(Record), 1, fp) != 1) {
        if (feof(fp)) {
            printf("Record not found\n");
        } else {
            perror("Error reading record");
        }
        fclose(fp);
        return -1;
    }
    
    fclose(fp);
    return 0;
}

// Update specific record by ID
int update_record(const char *filename, int record_id, const Record *new_record) {
    FILE *fp;
    long position = (record_id - 1) * sizeof(Record);
    
    fp = fopen(filename, "r+b");
    if (fp == NULL) {
        perror("Error opening file");
        return -1;
    }
    
    // Position to the specific record
    if (fseek(fp, position, SEEK_SET) != 0) {
        perror("Error seeking to record");
        fclose(fp);
        return -1;
    }
    
    // Write the updated record
    if (fwrite(new_record, sizeof(Record), 1, fp) != 1) {
        perror("Error writing record");
        fclose(fp);
        return -1;
    }
    
    fclose(fp);
    return 0;
}

int main() {
    Record record;
    
    // Create test file with records
    write_records("records.dat");
    
    // Read specific record
    if (read_record("records.dat", 3, &record) == 0) {
        printf("Record 3: ID=%d, Name=%s, Value=%.2f\n", 
               record.id, record.name, record.value);
    }
    
    // Update record
    Record updated = {3, "Updated3", 999.99};
    if (update_record("records.dat", 3, &updated) == 0) {
        printf("Record 3 updated successfully\n");
    }
    
    // Read updated record
    if (read_record("records.dat", 3, &record) == 0) {
        printf("Updated Record 3: ID=%d, Name=%s, Value=%.2f\n", 
               record.id, record.name, record.value);
    }
    
    return 0;
}
```

## Temporary Files

Temporary files are useful for storing data temporarily during program execution. C provides functions to create temporary files that are automatically managed by the system.

### tmpfile()

Creates a temporary binary file that is automatically deleted when closed:

```c
FILE *tmpfile(void);
```

**Return Value:**
- File pointer on success
- `NULL` on error

### tmpnam()

Generates a unique temporary filename:

```c
char *tmpnam(char *str);
```

**Parameters:**
- `str`: Buffer to store filename (if `NULL`, uses internal static buffer)

**Return Value:**
- Pointer to temporary filename
- `NULL` on error

### mkstemp() (POSIX)

Creates and opens a unique temporary file (more secure):

```c
int mkstemp(char *template);
```

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main() {
    FILE *tmp_fp;
    char tmp_name[L_tmpnam];
    int fd;
    
    // Method 1: Using tmpfile()
    tmp_fp = tmpfile();
    if (tmp_fp == NULL) {
        perror("Error creating temporary file");
        exit(EXIT_FAILURE);
    }
    
    fprintf(tmp_fp, "This is temporary data\n");
    fprintf(tmp_fp, "It will be deleted automatically\n");
    
    // Rewind and read back
    rewind(tmp_fp);
    int ch;
    while ((ch = fgetc(tmp_fp)) != EOF) {
        putchar(ch);
    }
    
    // File is automatically deleted when closed
    fclose(tmp_fp);
    
    // Method 2: Using tmpnam()
    if (tmpnam(tmp_name) == NULL) {
        printf("Error generating temporary filename\n");
        exit(EXIT_FAILURE);
    }
    
    printf("Temporary filename: %s\n", tmp_name);
    
    tmp_fp = fopen(tmp_name, "w+");
    if (tmp_fp == NULL) {
        perror("Error opening temporary file");
        exit(EXIT_FAILURE);
    }
    
    fprintf(tmp_fp, "Data in named temporary file\n");
    fclose(tmp_fp);
    
    // Note: tmpnam() doesn't delete the file automatically
    // You need to remove it manually
    if (remove(tmp_name) != 0) {
        perror("Error deleting temporary file");
    } else {
        printf("Temporary file deleted successfully\n");
    }
    
    return 0;
}
```

## File Locking and Concurrent Access

When multiple processes or threads access the same file simultaneously, file locking mechanisms are necessary to prevent data corruption and ensure consistency.

### flockfile() and funlockfile()

Provide explicit locking for FILE objects:

```c
void flockfile(FILE *file);
void funlockfile(FILE *file);
```

### ftrylockfile()

Attempts to lock a file without blocking:

```c
int ftrylockfile(FILE *file);
```

### Example with File Locking

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

void* writer_thread(void* arg) {
    FILE *fp = (FILE*)arg;
    int thread_id = *(int*)pthread_getspecific(pthread_self());
    
    for (int i = 0; i < 5; i++) {
        // Lock the file
        flockfile(fp);
        
        fprintf(fp, "Writer %d: Line %d\n", thread_id, i);
        fflush(fp);
        
        // Unlock the file
        funlockfile(fp);
        
        sleep(1);  // Simulate work
    }
    
    return NULL;
}

int main() {
    FILE *fp;
    pthread_t threads[3];
    int thread_ids[3] = {1, 2, 3};
    
    fp = fopen("shared.log", "w");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    // Create writer threads
    for (int i = 0; i < 3; i++) {
        pthread_create(&threads[i], NULL, writer_thread, fp);
    }
    
    // Wait for threads to complete
    for (int i = 0; i < 3; i++) {
        pthread_join(threads[i], NULL);
    }
    
    fclose(fp);
    printf("All threads completed\n");
    
    return 0;
}
```

## File Status and Information

C provides functions to query file status and obtain information about files without opening them.

### fileno()

Returns the file descriptor associated with a FILE pointer:

```c
int fileno(FILE *stream);
```

### fstat() (POSIX)

Gets file status information:

```c
#include <sys/stat.h>
int fstat(int fd, struct stat *buf);
```

### Example with File Information

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/stat.h>
#include <time.h>
#include <unistd.h>

void print_file_info(const char *filename) {
    struct stat file_info;
    
    if (stat(filename, &file_info) != 0) {
        perror("Error getting file information");
        return;
    }
    
    printf("File: %s\n", filename);
    printf("Size: %ld bytes\n", file_info.st_size);
    printf("Permissions: %o\n", file_info.st_mode & 0777);
    printf("Last modified: %s", ctime(&file_info.st_mtime));
    printf("Number of links: %ld\n", file_info.st_nlink);
    
    // Check file type
    if (S_ISREG(file_info.st_mode)) {
        printf("Type: Regular file\n");
    } else if (S_ISDIR(file_info.st_mode)) {
        printf("Type: Directory\n");
    } else if (S_ISLNK(file_info.st_mode)) {
        printf("Type: Symbolic link\n");
    }
}

int main() {
    FILE *fp;
    
    // Create a test file
    fp = fopen("info_test.txt", "w");
    if (fp == NULL) {
        perror("Error creating test file");
        exit(EXIT_FAILURE);
    }
    
    fprintf(fp, "This is a test file for information retrieval.\n");
    fprintf(fp, "It contains multiple lines of text.\n");
    fclose(fp);
    
    // Print file information
    print_file_info("info_test.txt");
    
    return 0;
}
```

## Buffering Strategies

Understanding and controlling buffering can significantly impact file I/O performance.

### setvbuf()

Controls buffering behavior:

```c
int setvbuf(FILE *stream, char *buffer, int mode, size_t size);
```

**Mode Values:**
- `_IOFBF`: Full buffering
- `_IOLBF`: Line buffering
- `_IONBF`: No buffering

### Example with Custom Buffering

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    FILE *fp;
    char buffer[1024];
    
    fp = fopen("buffer_test.txt", "w");
    if (fp == NULL) {
        perror("Error opening file");
        exit(EXIT_FAILURE);
    }
    
    // Set custom buffer
    if (setvbuf(fp, buffer, _IOFBF, sizeof(buffer)) != 0) {
        printf("Error setting buffer\n");
        fclose(fp);
        exit(EXIT_FAILURE);
    }
    
    // Write data (will be buffered)
    for (int i = 0; i < 100; i++) {
        fprintf(fp, "Line %d: This is test data.\n", i);
    }
    
    // Force buffer flush
    fflush(fp);
    
    fclose(fp);
    printf("Data written with custom buffering\n");
    
    return 0;
}
```

## Practical Examples

### File Merger Utility
```c
#include <stdio.h>
#include <stdlib.h>

int merge_files(const char *output, const char **inputs, int count) {
    FILE *out_fp, *in_fp;
    
    // Open output file
    out_fp = fopen(output, "wb");
    if (out_fp == NULL) {
        perror("Error opening output file");
        return -1;
    }
    
    // Process each input file
    for (int i = 0; i < count; i++) {
        in_fp = fopen(inputs[i], "rb");
        if (in_fp == NULL) {
            perror("Error opening input file");
            fclose(out_fp);
            return -1;
        }
        
        // Copy data
        int ch;
        while ((ch = fgetc(in_fp)) != EOF) {
            fputc(ch, out_fp);
        }
        
        fclose(in_fp);
    }
    
    fclose(out_fp);
    return 0;
}

int main() {
    const char *input_files[] = {"file1.txt", "file2.txt", "file3.txt"};
    
    // Create test files
    FILE *fp;
    fp = fopen("file1.txt", "w");
    fprintf(fp, "Content of file 1\n");
    fclose(fp);
    
    fp = fopen("file2.txt", "w");
    fprintf(fp, "Content of file 2\n");
    fclose(fp);
    
    fp = fopen("file3.txt", "w");
    fprintf(fp, "Content of file 3\n");
    fclose(fp);
    
    // Merge files
    if (merge_files("merged.txt", input_files, 3) == 0) {
        printf("Files merged successfully\n");
    } else {
        printf("Error merging files\n");
    }
    
    return 0;
}
```

### File Splitter Utility
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int split_file(const char *input, long chunk_size) {
    FILE *in_fp, *out_fp;
    char out_name[256];
    int ch, chunk_num = 0;
    long bytes_written = 0;
    
    in_fp = fopen(input, "rb");
    if (in_fp == NULL) {
        perror("Error opening input file");
        return -1;
    }
    
    while ((ch = fgetc(in_fp)) != EOF) {
        // Open new output file if needed
        if (bytes_written == 0) {
            snprintf(out_name, sizeof(out_name), "%s.part%d", input, chunk_num);
            out_fp = fopen(out_name, "wb");
            if (out_fp == NULL) {
                perror("Error opening output file");
                fclose(in_fp);
                return -1;
            }
            chunk_num++;
        }
        
        // Write byte to current output file
        fputc(ch, out_fp);
        bytes_written++;
        
        // Close current output file if chunk is complete
        if (bytes_written >= chunk_size) {
            fclose(out_fp);
            bytes_written = 0;
        }
    }
    
    // Close last output file if open
    if (bytes_written > 0) {
        fclose(out_fp);
    }
    
    fclose(in_fp);
    printf("File split into %d parts\n", chunk_num);
    return 0;
}

int main() {
    // Create test file
    FILE *fp = fopen("large_file.txt", "w");
    for (int i = 0; i < 1000; i++) {
        fprintf(fp, "This is line %d of the large test file.\n", i);
    }
    fclose(fp);
    
    // Split file into 1KB chunks
    if (split_file("large_file.txt", 1024) == 0) {
        printf("File split successfully\n");
    } else {
        printf("Error splitting file\n");
    }
    
    return 0;
}
```

## Summary

Advanced file operations in C provide powerful capabilities for sophisticated file handling:

1. **File Positioning**: `fseek()`, `ftell()`, `rewind()` for random access
2. **Random Access Files**: Direct access to specific file locations
3. **Temporary Files**: `tmpfile()`, `tmpnam()` for temporary data storage
4. **File Locking**: Synchronization for concurrent file access
5. **File Information**: Status and metadata retrieval
6. **Buffering Control**: Performance optimization through custom buffering

These advanced techniques are essential for building robust file processing applications, database systems, and other programs requiring fine-grained control over file operations.