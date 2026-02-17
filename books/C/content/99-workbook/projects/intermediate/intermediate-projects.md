# Intermediate Projects

These projects are designed for programmers with basic C knowledge who want to advance their skills. They involve more complex data structures, file handling, and problem-solving techniques.

## Project 1: Student Grade Management System

### Description
Create a comprehensive system to manage student grades, calculate statistics, and generate reports.

### Learning Objectives
- Working with dynamic data structures
- File I/O operations with structured data
- Data analysis and statistics
- Memory management
- Modular programming

### Requirements
1. Store student information (ID, name, grades for multiple subjects)
2. Add, edit, and delete student records
3. Calculate average grades for students and subjects
4. Generate class statistics (highest, lowest, median grades)
5. Save and load data from files
6. Search and sort student records
7. Generate detailed reports
8. Handle multiple classes/sections

### Implementation Steps
1. Design data structures for students and grades
2. Implement dynamic memory allocation for records
3. Create functions for CRUD operations
4. Implement statistical analysis functions
5. Add file I/O for data persistence
6. Create sorting and searching algorithms
7. Develop report generation features
8. Build a menu-driven interface

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define MAX_NAME_LENGTH 50
#define MAX_SUBJECTS 10
#define FILENAME "students.dat"

typedef struct {
    int id;
    char name[MAX_NAME_LENGTH];
    int num_subjects;
    char subjects[MAX_SUBJECTS][MAX_NAME_LENGTH];
    double grades[MAX_SUBJECTS];
} Student;

typedef struct {
    Student *students;
    int count;
    int capacity;
} StudentManager;

// Function prototypes
StudentManager* create_student_manager(int initial_capacity);
void destroy_student_manager(StudentManager *manager);
int add_student(StudentManager *manager, Student student);
int edit_student(StudentManager *manager, int id, Student new_student);
int delete_student(StudentManager *manager, int id);
Student* find_student(StudentManager *manager, int id);
void sort_students_by_name(StudentManager *manager);
void sort_students_by_average(StudentManager *manager);
double calculate_student_average(Student *student);
double calculate_subject_average(StudentManager *manager, const char *subject);
void generate_class_report(StudentManager *manager);
void save_to_file(StudentManager *manager, const char *filename);
int load_from_file(StudentManager *manager, const char *filename);
void display_menu();

int main() {
    StudentManager *manager = create_student_manager(10);
    if (!manager) {
        fprintf(stderr, "Failed to create student manager\n");
        return 1;
    }
    
    // Load existing data
    load_from_file(manager, FILENAME);
    
    int choice;
    do {
        display_menu();
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1: {
                Student student;
                printf("Enter student ID: ");
                scanf("%d", &student.id);
                printf("Enter student name: ");
                scanf(" %[^\n]", student.name);
                // Add more input handling
                add_student(manager, student);
                break;
            }
            // Implement other cases
            case 8:
                save_to_file(manager, FILENAME);
                printf("Data saved successfully!\n");
                break;
            case 9:
                printf("Goodbye!\n");
                break;
            default:
                printf("Invalid choice. Please try again.\n");
        }
    } while (choice != 9);
    
    destroy_student_manager(manager);
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Memory leaks from dynamic allocation
2. Buffer overflows with string inputs
3. Not checking return values of file operations
4. Incorrect implementation of sorting algorithms
5. Not handling edge cases in statistical calculations

### Best Practices
1. Always free dynamically allocated memory
2. Check for NULL pointers before dereferencing
3. Validate all user inputs
4. Use appropriate data structures for efficiency
5. Implement proper error handling
6. Comment complex algorithms
7. Use constants for array sizes and limits

## Project 2: Simple Text Editor

### Description
Create a basic text editor that can create, edit, and save text files with basic editing features.

### Learning Objectives
- Working with dynamic strings
- File I/O operations
- Text processing algorithms
- Memory management
- User interface design

### Requirements
1. Create new text files
2. Open and edit existing text files
3. Save files to disk
4. Basic editing operations (insert, delete, replace)
5. Search and replace functionality
6. Undo/redo functionality
7. Line numbering
8. Status bar with file information

### Implementation Steps
1. Design data structures for text storage
2. Implement file I/O operations
3. Create basic editing functions
4. Add search and replace features
5. Implement undo/redo functionality
6. Add line numbering
7. Create user interface
8. Add status bar and file information

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_LINE_LENGTH 1000
#define INITIAL_LINES 100

typedef struct {
    char **lines;
    int line_count;
    int capacity;
    char filename[256];
    int modified;
} TextEditor;

// Function prototypes
TextEditor* create_editor();
void destroy_editor(TextEditor *editor);
int load_file(TextEditor *editor, const char *filename);
int save_file(TextEditor *editor, const char *filename);
void insert_line(TextEditor *editor, int line_num, const char *text);
void delete_line(TextEditor *editor, int line_num);
void replace_line(TextEditor *editor, int line_num, const char *text);
int search_text(TextEditor *editor, const char *text);
void replace_all(TextEditor *editor, const char *old_text, const char *new_text);
void display_content(TextEditor *editor);
void display_status(TextEditor *editor);
void expand_lines(TextEditor *editor);

int main() {
    TextEditor *editor = create_editor();
    if (!editor) {
        fprintf(stderr, "Failed to create text editor\n");
        return 1;
    }
    
    char filename[256];
    printf("Enter filename to open (or new filename): ");
    scanf(" %[^\n]", filename);
    
    if (load_file(editor, filename)) {
        printf("File loaded successfully\n");
    } else {
        printf("Creating new file: %s\n", filename);
        strcpy(editor->filename, filename);
    }
    
    int choice;
    do {
        display_content(editor);
        display_status(editor);
        // Add menu options
        printf("1. Insert line\n");
        printf("2. Delete line\n");
        printf("3. Replace line\n");
        printf("4. Search text\n");
        printf("5. Save file\n");
        printf("6. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        // Implement menu options
    } while (choice != 6);
    
    destroy_editor(editor);
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Memory leaks from dynamic string allocation
2. Buffer overflows when reading input
3. Not handling file operation errors
4. Incorrect implementation of undo/redo functionality
5. Performance issues with large files

### Best Practices
1. Use dynamic memory allocation carefully
2. Validate all file operations
3. Implement proper error handling
4. Use efficient data structures for text storage
5. Provide clear user feedback
6. Handle edge cases in editing operations

## Project 3: Library Management System

### Description
Create a system to manage a library's collection of books, borrowers, and transactions.

### Learning Objectives
- Working with complex data relationships
- File I/O with structured data
- Data validation and integrity
- Search and sorting algorithms
- Transaction management

### Requirements
1. Manage book inventory (title, author, ISBN, quantity)
2. Manage borrower information (ID, name, contact info)
3. Handle book borrowing and returning
4. Track overdue books
5. Generate reports (borrowed books, overdue books, popular books)
6. Save and load data from files
7. Search books by various criteria
8. Handle multiple copies of the same book

### Implementation Steps
1. Design data structures for books, borrowers, and transactions
2. Implement CRUD operations for books and borrowers
3. Create borrowing and returning functionality
4. Add overdue tracking
5. Implement file I/O for data persistence
6. Create search and reporting features
7. Build a menu-driven interface
8. Add data validation

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_TITLE_LENGTH 100
#define MAX_AUTHOR_LENGTH 50
#define MAX_BORROWERS 1000
#define MAX_BOOKS 1000

typedef struct {
    int isbn;
    char title[MAX_TITLE_LENGTH];
    char author[MAX_AUTHOR_LENGTH];
    int total_copies;
    int available_copies;
} Book;

typedef struct {
    int id;
    char name[50];
    char contact[50];
    int borrowed_count;
} Borrower;

typedef struct {
    int book_isbn;
    int borrower_id;
    time_t borrow_date;
    time_t due_date;
    time_t return_date;  // 0 if not returned
} Transaction;

typedef struct {
    Book books[MAX_BOOKS];
    int book_count;
    
    Borrower borrowers[MAX_BORROWERS];
    int borrower_count;
    
    Transaction transactions[10000];
    int transaction_count;
} Library;

// Function prototypes
Library* create_library();
void destroy_library(Library *library);
int add_book(Library *library, Book book);
int remove_book(Library *library, int isbn);
int add_borrower(Library *library, Borrower borrower);
int remove_borrower(Library *library, int id);
int borrow_book(Library *library, int isbn, int borrower_id);
int return_book(Library *library, int isbn, int borrower_id);
Book* find_book(Library *library, int isbn);
Borrower* find_borrower(Library *library, int id);
void search_books(Library *library, const char *query);
void generate_overdue_report(Library *library);
void save_library(Library *library, const char *filename);
int load_library(Library *library, const char *filename);
void display_menu();

int main() {
    Library *library = create_library();
    if (!library) {
        fprintf(stderr, "Failed to create library\n");
        return 1;
    }
    
    // Load existing data
    load_library(library, "library.dat");
    
    int choice;
    do {
        display_menu();
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1: {
                Book book;
                printf("Enter ISBN: ");
                scanf("%d", &book.isbn);
                printf("Enter title: ");
                scanf(" %[^\n]", book.title);
                printf("Enter author: ");
                scanf(" %[^\n]", book.author);
                printf("Enter total copies: ");
                scanf("%d", &book.total_copies);
                book.available_copies = book.total_copies;
                add_book(library, book);
                break;
            }
            // Implement other cases
            case 9:
                save_library(library, "library.dat");
                printf("Library data saved successfully!\n");
                break;
            case 10:
                printf("Goodbye!\n");
                break;
            default:
                printf("Invalid choice. Please try again.\n");
        }
    } while (choice != 10);
    
    destroy_library(library);
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Data inconsistency between related entities
2. Not handling date/time calculations correctly
3. Memory leaks in dynamic structures
4. Not validating transaction integrity
5. Performance issues with large datasets

### Best Practices
1. Maintain data integrity between related entities
2. Use proper date/time functions
3. Implement efficient search algorithms
4. Validate all transactions
5. Handle edge cases in borrowing logic
6. Provide clear error messages
7. Use appropriate data structures for performance

## Project 4: Simple Database Engine

### Description
Create a basic database engine that can store, retrieve, and manipulate tabular data.

### Learning Objectives
- Working with tabular data structures
- File I/O with binary data
- Query processing
- Indexing and search optimization
- Memory management

### Requirements
1. Create and manage database tables
2. Define table schemas (column names and types)
3. Insert, update, and delete records
4. Query data with simple WHERE clauses
5. Save and load databases from files
6. Support basic data types (int, float, string)
7. Implement indexing for faster searches
8. Export data to CSV format

### Implementation Steps
1. Design data structures for tables and records
2. Implement table creation and schema management
3. Create CRUD operations for records
4. Add query processing functionality
5. Implement file I/O for persistence
6. Add indexing for performance
7. Create CSV export functionality
8. Build a command-line interface

### Sample Code Structure
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_TABLES 100
#define MAX_COLUMNS 50
#define MAX_RECORDS 10000
#define MAX_STRING_LENGTH 256

typedef enum {
    TYPE_INT,
    TYPE_FLOAT,
    TYPE_STRING
} DataType;

typedef struct {
    char name[50];
    DataType type;
    int size;
} Column;

typedef struct {
    int id;
    void *data;  // Pointer to actual data
} Record;

typedef struct {
    char name[50];
    Column columns[MAX_COLUMNS];
    int column_count;
    Record records[MAX_RECORDS];
    int record_count;
    int *index;  // Simple index array
    int index_count;
} Table;

typedef struct {
    Table tables[MAX_TABLES];
    int table_count;
} Database;

// Function prototypes
Database* create_database();
void destroy_database(Database *db);
Table* create_table(Database *db, const char *name);
int add_column(Table *table, const char *name, DataType type, int size);
int insert_record(Table *table, void *data[]);
Record* find_record(Table *table, int record_id);
int update_record(Table *table, int record_id, void *data[]);
int delete_record(Table *table, int record_id);
Record** query_table(Table *table, const char *where_clause, int *result_count);
void save_database(Database *db, const char *filename);
int load_database(Database *db, const char *filename);
void export_to_csv(Table *table, const char *filename);
void display_menu();

int main() {
    Database *db = create_database();
    if (!db) {
        fprintf(stderr, "Failed to create database\n");
        return 1;
    }
    
    // Load existing database
    load_database(db, "database.dat");
    
    int choice;
    do {
        display_menu();
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1: {
                char table_name[50];
                printf("Enter table name: ");
                scanf(" %[^\n]", table_name);
                create_table(db, table_name);
                break;
            }
            // Implement other cases
            case 7:
                save_database(db, "database.dat");
                printf("Database saved successfully!\n");
                break;
            case 8:
                printf("Goodbye!\n");
                break;
            default:
                printf("Invalid choice. Please try again.\n");
        }
    } while (choice != 8);
    
    destroy_database(db);
    return 0;
}

// Implement all functions here
```

### Common Pitfalls to Avoid
1. Memory leaks from dynamic data allocation
2. Data type mismatches
3. Not handling file format compatibility
4. Performance issues with large datasets
5. Not implementing proper indexing strategies

### Best Practices
1. Use appropriate data structures for different data types
2. Validate data types during operations
3. Implement efficient indexing strategies
4. Handle file format versioning
5. Provide clear error messages for query syntax
6. Use constants for size limits
7. Implement proper memory management

## Tips for Success

1. **Plan Before Coding**: Design your data structures and algorithms before implementation
2. **Modular Approach**: Break complex problems into smaller, manageable functions
3. **Error Handling**: Always consider what could go wrong and handle it gracefully
4. **Memory Management**: Be careful with dynamic allocation and always free memory
5. **Testing**: Test each function individually before integrating
6. **Performance**: Consider the efficiency of your algorithms, especially for large datasets
7. **Documentation**: Comment your code, especially complex algorithms
8. **Version Control**: Use version control to track changes and experiment safely

These intermediate projects will help you develop more advanced C programming skills while working on realistic applications. Focus on writing efficient, maintainable code with proper error handling.