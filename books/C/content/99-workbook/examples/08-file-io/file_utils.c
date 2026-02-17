#include "file_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Open a file with error checking
FILE* open_file(const char *filename, const char *mode) {
    if (filename == NULL || mode == NULL) {
        printf("Error: Invalid filename or mode\n");
        return NULL;
    }
    
    FILE *file = fopen(filename, mode);
    if (file == NULL) {
        printf("Error: Could not open file '%s' in mode '%s'\n", filename, mode);
    }
    
    return file;
}

// Close a file
void close_file(FILE *file) {
    if (file != NULL) {
        fclose(file);
    }
}

// Write text to a file (overwrites existing content)
int write_text_to_file(const char *filename, const char *text) {
    if (filename == NULL || text == NULL) {
        return 0; // Failure
    }
    
    FILE *file = open_file(filename, "w");
    if (file == NULL) {
        return 0; // Failure
    }
    
    int result = fputs(text, file);
    close_file(file);
    
    return (result >= 0) ? 1 : 0; // Success if fputs returns non-negative
}

// Append text to a file
int append_text_to_file(const char *filename, const char *text) {
    if (filename == NULL || text == NULL) {
        return 0; // Failure
    }
    
    FILE *file = open_file(filename, "a");
    if (file == NULL) {
        return 0; // Failure
    }
    
    int result = fputs(text, file);
    close_file(file);
    
    return (result >= 0) ? 1 : 0; // Success if fputs returns non-negative
}

// Read entire text from a file
char* read_text_from_file(const char *filename) {
    if (filename == NULL) {
        return NULL;
    }
    
    FILE *file = open_file(filename, "r");
    if (file == NULL) {
        return NULL;
    }
    
    // Get file size
    if (fseek(file, 0, SEEK_END) != 0) {
        close_file(file);
        return NULL;
    }
    
    long file_size = ftell(file);
    if (file_size < 0) {
        close_file(file);
        return NULL;
    }
    
    if (fseek(file, 0, SEEK_SET) != 0) {
        close_file(file);
        return NULL;
    }
    
    // Allocate memory for file content
    char *content = (char*)malloc(file_size + 1);
    if (content == NULL) {
        printf("Error: Memory allocation failed\n");
        close_file(file);
        return NULL;
    }
    
    // Read file content
    size_t bytes_read = fread(content, 1, file_size, file);
    content[bytes_read] = '\0'; // Null terminate
    
    close_file(file);
    return content;
}

// Copy a file
int copy_file(const char *source, const char *destination) {
    if (source == NULL || destination == NULL) {
        return 0; // Failure
    }
    
    FILE *src_file = open_file(source, "rb");
    if (src_file == NULL) {
        return 0; // Failure
    }
    
    FILE *dest_file = open_file(destination, "wb");
    if (dest_file == NULL) {
        close_file(src_file);
        return 0; // Failure
    }
    
    // Copy file content
    char buffer[1024];
    size_t bytes_read;
    
    while ((bytes_read = fread(buffer, 1, sizeof(buffer), src_file)) > 0) {
        if (fwrite(buffer, 1, bytes_read, dest_file) != bytes_read) {
            printf("Error: Failed to write to destination file\n");
            close_file(src_file);
            close_file(dest_file);
            return 0; // Failure
        }
    }
    
    close_file(src_file);
    close_file(dest_file);
    return 1; // Success
}

// Get file size
long get_file_size(const char *filename) {
    if (filename == NULL) {
        return -1;
    }
    
    FILE *file = open_file(filename, "r");
    if (file == NULL) {
        return -1;
    }
    
    if (fseek(file, 0, SEEK_END) != 0) {
        close_file(file);
        return -1;
    }
    
    long file_size = ftell(file);
    close_file(file);
    
    return file_size;
}

// Check if file exists
int file_exists(const char *filename) {
    if (filename == NULL) {
        return 0;
    }
    
    FILE *file = fopen(filename, "r");
    if (file != NULL) {
        fclose(file);
        return 1; // File exists
    }
    
    return 0; // File does not exist
}

// Print file contents to stdout
void print_file_contents(const char *filename) {
    if (filename == NULL) {
        return;
    }
    
    FILE *file = open_file(filename, "r");
    if (file == NULL) {
        return;
    }
    
    char buffer[1024];
    while (fgets(buffer, sizeof(buffer), file) != NULL) {
        printf("%s", buffer);
    }
    
    close_file(file);
}