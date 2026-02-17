/*
 * Module 8 Demonstration Program
 * This program demonstrates all the key concepts from Module 8:
 * - File operations (opening, closing, error handling)
 * - File I/O functions (fgetc, fgets, fputc, fputs, fprintf, fscanf)
 * - Advanced file operations (binary files, random access)
 * - System programming concepts (file system operations)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Include our custom header files
#include "file_utils.h"

// Function prototypes for demonstration functions
void demonstrate_file_operations(void);
void demonstrate_text_file_io(void);
void demonstrate_binary_file_io(void);
void demonstrate_advanced_file_operations(void);

// Structure for binary file example
typedef struct {
    int id;
    char name[50];
    double salary;
} Employee;

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 8: File I/O Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_file_operations();
    demonstrate_text_file_io();
    demonstrate_binary_file_io();
    demonstrate_advanced_file_operations();
    
    printf("\n========================================\n");
    printf("  Module 8 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate basic file operations
 */
void demonstrate_file_operations() {
    print_separator("Basic File Operations");
    
    // Create a test file
    const char *filename = "test.txt";
    const char *content = "This is a test file.\nLine 2\nLine 3\n";
    
    printf("Creating file '%s' with content:\n%s", filename, content);
    
    if (write_text_to_file(filename, content)) {
        printf("File created successfully.\n");
    } else {
        printf("Failed to create file.\n");
        return;
    }
    
    // Check if file exists
    if (file_exists(filename)) {
        printf("File '%s' exists.\n", filename);
    } else {
        printf("File '%s' does not exist.\n", filename);
    }
    
    // Get file size
    long size = get_file_size(filename);
    if (size >= 0) {
        printf("File size: %ld bytes\n", size);
    }
    
    // Read file content
    char *file_content = read_text_from_file(filename);
    if (file_content != NULL) {
        printf("File content:\n%s", file_content);
        free(file_content);
    }
    
    // Append to file
    const char *append_content = "Appended line\n";
    printf("\nAppending to file: %s", append_content);
    
    if (append_text_to_file(filename, append_content)) {
        printf("Content appended successfully.\n");
        
        // Read updated content
        file_content = read_text_from_file(filename);
        if (file_content != NULL) {
            printf("Updated file content:\n%s", file_content);
            free(file_content);
        }
    }
    
    // Copy file
    const char *copy_filename = "test_copy.txt";
    printf("\nCopying '%s' to '%s'\n", filename, copy_filename);
    
    if (copy_file(filename, copy_filename)) {
        printf("File copied successfully.\n");
        
        // Verify copy
        file_content = read_text_from_file(copy_filename);
        if (file_content != NULL) {
            printf("Copy file content:\n%s", file_content);
            free(file_content);
        }
    }
    
    // Clean up test files
    remove(filename);
    remove(copy_filename);
}

/*
 * Demonstrate text file I/O functions
 */
void demonstrate_text_file_io() {
    print_separator("Text File I/O Functions");
    
    const char *filename = "text_demo.txt";
    
    // Using fprintf and fscanf
    FILE *file = open_file(filename, "w");
    if (file != NULL) {
        fprintf(file, "Name: %s\n", "John Doe");
        fprintf(file, "Age: %d\n", 30);
        fprintf(file, "Height: %.2f meters\n", 1.75);
        close_file(file);
        printf("Data written using fprintf.\n");
    }
    
    // Reading with fscanf
    file = open_file(filename, "r");
    if (file != NULL) {
        char name[50];
        int age;
        float height;
        
        // Skip "Name: " prefix
        fscanf(file, "%*s %s", name);
        // Read age (skip "Age: " prefix)
        fscanf(file, "%*s %d", &age);
        // Read height (skip "Height: " prefix)
        fscanf(file, "%*s %f", &height);
        
        printf("Data read using fscanf:\n");
        printf("  Name: %s\n", name);
        printf("  Age: %d\n", age);
        printf("  Height: %.2f meters\n", height);
        
        close_file(file);
    }
    
    // Using fputc and fgetc
    file = open_file(filename, "w");
    if (file != NULL) {
        const char *text = "Hello, File I/O!";
        for (int i = 0; text[i] != '\0'; i++) {
            fputc(text[i], file);
        }
        close_file(file);
        printf("\nText written using fputc.\n");
    }
    
    file = open_file(filename, "r");
    if (file != NULL) {
        printf("Text read using fgetc: ");
        int ch;
        while ((ch = fgetc(file)) != EOF) {
            putchar(ch);
        }
        printf("\n");
        close_file(file);
    }
    
    // Using fgets
    file = open_file(filename, "w");
    if (file != NULL) {
        fputs("Line 1\nLine 2\nLine 3\n", file);
        close_file(file);
        printf("\nLines written using fputs.\n");
    }
    
    file = open_file(filename, "r");
    if (file != NULL) {
        char buffer[100];
        printf("Lines read using fgets:\n");
        while (fgets(buffer, sizeof(buffer), file) != NULL) {
            printf("  %s", buffer);
        }
        close_file(file);
    }
    
    // Clean up
    remove(filename);
}

/*
 * Demonstrate binary file I/O
 */
void demonstrate_binary_file_io() {
    print_separator("Binary File I/O");
    
    const char *filename = "employees.dat";
    
    // Create employee data
    Employee employees[] = {
        {1, "John Doe", 50000.0},
        {2, "Jane Smith", 55000.0},
        {3, "Bob Johnson", 48000.0}
    };
    int num_employees = sizeof(employees) / sizeof(employees[0]);
    
    // Write binary data
    FILE *file = open_file(filename, "wb");
    if (file != NULL) {
        for (int i = 0; i < num_employees; i++) {
            fwrite(&employees[i], sizeof(Employee), 1, file);
        }
        close_file(file);
        printf("Written %d employees to binary file.\n", num_employees);
    }
    
    // Read binary data
    file = open_file(filename, "rb");
    if (file != NULL) {
        Employee emp;
        int count = 0;
        printf("Reading employees from binary file:\n");
        while (fread(&emp, sizeof(Employee), 1, file) == 1) {
            printf("  ID: %d, Name: %s, Salary: $%.2f\n", 
                   emp.id, emp.name, emp.salary);
            count++;
        }
        printf("Total employees read: %d\n", count);
        close_file(file);
    }
    
    // Clean up
    remove(filename);
}

/*
 * Demonstrate advanced file operations
 */
void demonstrate_advanced_file_operations() {
    print_separator("Advanced File Operations");
    
    const char *filename = "advanced_demo.txt";
    
    // Create a file with multiple lines
    FILE *file = open_file(filename, "w");
    if (file != NULL) {
        fprintf(file, "Line 1: Hello\n");
        fprintf(file, "Line 2: World\n");
        fprintf(file, "Line 3: C Programming\n");
        fprintf(file, "Line 4: File I/O\n");
        fprintf(file, "Line 5: Advanced Topics\n");
        close_file(file);
    }
    
    // Random access with fseek and ftell
    file = open_file(filename, "r");
    if (file != NULL) {
        printf("File size: %ld bytes\n", get_file_size(filename));
        
        // Move to beginning
        fseek(file, 0, SEEK_SET);
        printf("Position at beginning: %ld\n", ftell(file));
        
        // Move to end
        fseek(file, 0, SEEK_END);
        printf("Position at end: %ld\n", ftell(file));
        
        // Move to specific position
        fseek(file, 10, SEEK_SET);
        printf("Position after seeking to 10: %ld\n", ftell(file));
        
        // Read character at current position
        int ch = fgetc(file);
        printf("Character at position 10: '%c'\n", ch);
        
        // Read line from specific position
        fseek(file, 0, SEEK_SET);
        char buffer[100];
        fgets(buffer, sizeof(buffer), file); // Read first line
        printf("First line: %s", buffer);
        
        // Read third line
        fgets(buffer, sizeof(buffer), file); // Skip second line
        fgets(buffer, sizeof(buffer), file); // Read third line
        printf("Third line: %s", buffer);
        
        close_file(file);
    }
    
    // File positioning with rewind
    file = open_file(filename, "r");
    if (file != NULL) {
        char buffer[100];
        fgets(buffer, sizeof(buffer), file); // Read first line
        printf("First read: %s", buffer);
        
        rewind(file); // Reset to beginning
        fgets(buffer, sizeof(buffer), file); // Read first line again
        printf("After rewind: %s", buffer);
        
        close_file(file);
    }
    
    // Error handling
    print_separator("File Error Handling");
    file = open_file("nonexistent.txt", "r");
    if (file == NULL) {
        printf("Successfully handled error for opening nonexistent file.\n");
    }
    
    // File status functions
    printf("\nFile status information:\n");
    if (file_exists(filename)) {
        long size = get_file_size(filename);
        printf("  File '%s' exists, size: %ld bytes\n", filename, size);
    }
    
    // Clean up
    remove(filename);
}