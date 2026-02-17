# Structures

## Introduction

Structures (structs) are user-defined data types in C that allow you to group related variables of different types under a single name. They are fundamental for creating complex data representations and implementing abstract data types. Structures enable programmers to model real-world entities and organize data in a logical, maintainable way.

## Structure Declaration and Definition

### Basic Structure Declaration
A structure is declared using the `struct` keyword followed by the structure name and a list of members enclosed in braces:

```c
struct Person {
    char name[50];
    int age;
    float height;
    char gender;
};
```

### Structure Variable Declaration
Structure variables can be declared in several ways:

```c
// Method 1: Declare structure and variables separately
struct Person {
    char name[50];
    int age;
    float height;
    char gender;
};

struct Person person1, person2;

// Method 2: Declare structure and variables together
struct {
    char name[50];
    int age;
    float height;
    char gender;
} person1, person2;

// Method 3: Use typedef for cleaner syntax
typedef struct {
    char name[50];
    int age;
    float height;
    char gender;
} Person;

Person person1, person2;
```

## Structure Initialization

### Designated Initializers (C99)
```c
typedef struct {
    char name[50];
    int age;
    float height;
    char gender;
} Person;

// Initialize all members
Person person1 = {"John Doe", 25, 5.9, 'M'};

// Designated initializers (C99)
Person person2 = {
    .name = "Jane Smith",
    .age = 30,
    .height = 5.5,
    .gender = 'F'
};

// Partial initialization
Person person3 = {
    .name = "Bob Johnson",
    .age = 35
    // height and gender will be zero-initialized
};
```

### Nested Structure Initialization
```c
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char name[50];
    Date birth_date;
    float salary;
} Employee;

// Nested structure initialization
Employee emp = {
    .name = "Alice Brown",
    .birth_date = {15, 6, 1990},
    .salary = 75000.0
};

// Designated initialization with nested structures
Employee emp2 = {
    .name = "Charlie Wilson",
    .birth_date.day = 20,
    .birth_date.month = 3,
    .birth_date.year = 1985,
    .salary = 80000.0
};
```

## Accessing Structure Members

### Dot Operator (.)
The dot operator is used to access members of a structure variable:

```c
typedef struct {
    char name[50];
    int age;
    float height;
    char gender;
} Person;

int main() {
    Person person = {"John Doe", 25, 5.9, 'M'};
    
    // Access members using dot operator
    printf("Name: %s\n", person.name);
    printf("Age: %d\n", person.age);
    printf("Height: %.1f\n", person.height);
    printf("Gender: %c\n", person.gender);
    
    // Modify members
    person.age = 26;
    person.height = 6.0;
    strcpy(person.name, "John Smith");
    
    return 0;
}
```

### Arrow Operator (->)
The arrow operator is used to access members through a pointer to a structure:

```c
typedef struct {
    char name[50];
    int age;
    float height;
    char gender;
} Person;

int main() {
    Person person = {"John Doe", 25, 5.9, 'M'};
    Person *ptr = &person;
    
    // Access members using arrow operator
    printf("Name: %s\n", ptr->name);
    printf("Age: %d\n", ptr->age);
    printf("Height: %.1f\n", ptr->height);
    printf("Gender: %c\n", ptr->gender);
    
    // Modify members through pointer
    ptr->age = 26;
    ptr->height = 6.0;
    strcpy(ptr->name, "John Smith");
    
    return 0;
}
```

## Arrays of Structures

### Declaration and Initialization
```c
typedef struct {
    char name[50];
    int id;
    float gpa;
} Student;

int main() {
    // Array of structures
    Student students[3] = {
        {"Alice", 101, 3.8},
        {"Bob", 102, 3.5},
        {"Charlie", 103, 3.9}
    };
    
    // Access array elements
    for (int i = 0; i < 3; i++) {
        printf("Student %d: %s, ID: %d, GPA: %.1f\n",
               i + 1, students[i].name, students[i].id, students[i].gpa);
    }
    
    return 0;
}
```

### Dynamic Array of Structures
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char name[50];
    int id;
    float gpa;
} Student;

int main() {
    int count = 3;
    
    // Dynamic array of structures
    Student *students = malloc(count * sizeof(Student));
    if (students == NULL) {
        printf("Memory allocation failed\n");
        return 1;
    }
    
    // Initialize array elements
    strcpy(students[0].name, "Alice");
    students[0].id = 101;
    students[0].gpa = 3.8;
    
    strcpy(students[1].name, "Bob");
    students[1].id = 102;
    students[1].gpa = 3.5;
    
    strcpy(students[2].name, "Charlie");
    students[2].id = 103;
    students[2].gpa = 3.9;
    
    // Access array elements
    for (int i = 0; i < count; i++) {
        printf("Student %d: %s, ID: %d, GPA: %.1f\n",
               i + 1, students[i].name, students[i].id, students[i].gpa);
    }
    
    // Free memory
    free(students);
    
    return 0;
}
```

## Nested Structures

### Basic Nested Structures
```c
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char street[100];
    char city[50];
    char state[30];
    int zip_code;
} Address;

typedef struct {
    char name[50];
    Date birth_date;
    Address home_address;
    float salary;
} Employee;

int main() {
    Employee emp = {
        .name = "John Doe",
        .birth_date = {15, 6, 1990},
        .home_address = {
            .street = "123 Main St",
            .city = "Anytown",
            .state = "CA",
            .zip_code = 12345
        },
        .salary = 75000.0
    };
    
    // Access nested structure members
    printf("Name: %s\n", emp.name);
    printf("Birth Date: %d/%d/%d\n", 
           emp.birth_date.month, emp.birth_date.day, emp.birth_date.year);
    printf("Address: %s, %s, %s %d\n",
           emp.home_address.street, emp.home_address.city,
           emp.home_address.state, emp.home_address.zip_code);
    printf("Salary: $%.2f\n", emp.salary);
    
    return 0;
}
```

### Self-Referential Structures
Structures can contain pointers to their own type, enabling linked data structures:

```c
typedef struct Node {
    int data;
    struct Node *next;  // Pointer to same structure type
} Node;

int main() {
    // Create nodes
    Node node1 = {10, NULL};
    Node node2 = {20, NULL};
    Node node3 = {30, NULL};
    
    // Link nodes
    node1.next = &node2;
    node2.next = &node3;
    
    // Traverse linked list
    Node *current = &node1;
    while (current != NULL) {
        printf("Data: %d\n", current->data);
        current = current->next;
    }
    
    return 0;
}
```

## Structure Assignment and Comparison

### Structure Assignment
Structures can be assigned to each other if they are of the same type:

```c
typedef struct {
    char name[50];
    int age;
    float height;
} Person;

int main() {
    Person person1 = {"John Doe", 25, 5.9};
    Person person2;
    
    // Structure assignment
    person2 = person1;
    
    printf("Person 1: %s, %d, %.1f\n", person1.name, person1.age, person1.height);
    printf("Person 2: %s, %d, %.1f\n", person2.name, person2.age, person2.height);
    
    return 0;
}
```

### Structure Comparison
Structures cannot be directly compared using comparison operators. You need to compare members individually:

```c
typedef struct {
    char name[50];
    int age;
    float height;
} Person;

int compare_persons(const Person *p1, const Person *p2) {
    // Compare names
    int name_cmp = strcmp(p1->name, p2->name);
    if (name_cmp != 0) return name_cmp;
    
    // Compare ages
    if (p1->age != p2->age) return p1->age - p2->age;
    
    // Compare heights
    if (p1->height < p2->height) return -1;
    if (p1->height > p2->height) return 1;
    
    return 0;  // Structures are equal
}

int main() {
    Person person1 = {"John Doe", 25, 5.9};
    Person person2 = {"John Doe", 25, 5.9};
    
    if (compare_persons(&person1, &person2) == 0) {
        printf("Persons are equal\n");
    } else {
        printf("Persons are different\n");
    }
    
    return 0;
}
```

## Passing Structures to Functions

### Pass by Value
When passing structures by value, a copy of the entire structure is made:

```c
typedef struct {
    char name[50];
    int age;
    float height;
} Person;

void print_person(Person p) {
    printf("Name: %s\n", p.name);
    printf("Age: %d\n", p.age);
    printf("Height: %.1f\n", p.height);
}

void modify_person(Person p) {
    // Modifications affect only the copy
    p.age = 30;
    strcpy(p.name, "Modified Name");
}

int main() {
    Person person = {"John Doe", 25, 5.9};
    
    printf("Before modification:\n");
    print_person(person);
    
    modify_person(person);
    
    printf("After modification:\n");
    print_person(person);  // Original unchanged
    
    return 0;
}
```

### Pass by Reference (Pointer)
Passing pointers to structures is more efficient and allows modification:

```c
typedef struct {
    char name[50];
    int age;
    float height;
} Person;

void print_person(const Person *p) {
    printf("Name: %s\n", p->name);
    printf("Age: %d\n", p->age);
    printf("Height: %.1f\n", p->height);
}

void modify_person(Person *p) {
    // Modifications affect the original structure
    p->age = 30;
    strcpy(p->name, "Modified Name");
}

int main() {
    Person person = {"John Doe", 25, 5.9};
    
    printf("Before modification:\n");
    print_person(&person);
    
    modify_person(&person);
    
    printf("After modification:\n");
    print_person(&person);  // Original changed
    
    return 0;
}
```

## Structure Size and Memory Layout

### Calculating Structure Size
```c
#include <stdio.h>

typedef struct {
    char a;      // 1 byte
    int b;       // 4 bytes
    char c;      // 1 byte
} Example;

int main() {
    printf("Size of char: %zu bytes\n", sizeof(char));
    printf("Size of int: %zu bytes\n", sizeof(int));
    printf("Size of Example: %zu bytes\n", sizeof(Example));
    // Note: Size may be larger than sum due to padding
    
    return 0;
}
```

### Memory Alignment
Compilers may add padding to ensure proper alignment:

```c
#include <stdio.h>

// Without pragma pack
typedef struct {
    char a;      // 1 byte
    int b;       // 4 bytes (may have 3 bytes padding before)
    char c;      // 1 byte (may have 3 bytes padding after)
} Unpacked;

// With pragma pack (1) - no padding
#pragma pack(1)
typedef struct {
    char a;      // 1 byte
    int b;       // 4 bytes (no padding)
    char c;      // 1 byte (no padding)
} Packed;
#pragma pack()

int main() {
    printf("Size of Unpacked: %zu bytes\n", sizeof(Unpacked));
    printf("Size of Packed: %zu bytes\n", sizeof(Packed));
    
    return 0;
}
```

## Practical Examples

### Student Management System
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    int id;
    char name[50];
    float grades[5];
    float average;
} Student;

void calculate_average(Student *student) {
    float sum = 0;
    for (int i = 0; i < 5; i++) {
        sum += student->grades[i];
    }
    student->average = sum / 5;
}

void print_student(const Student *student) {
    printf("ID: %d\n", student->id);
    printf("Name: %s\n", student->name);
    printf("Grades: ");
    for (int i = 0; i < 5; i++) {
        printf("%.1f ", student->grades[i]);
    }
    printf("\nAverage: %.2f\n", student->average);
    printf("------------------------\n");
}

int main() {
    Student students[3] = {
        {1, "Alice", {85.5, 90.0, 78.5, 92.0, 88.5}, 0},
        {2, "Bob", {76.0, 82.5, 79.0, 85.5, 81.0}, 0},
        {3, "Charlie", {95.0, 92.5, 98.0, 90.5, 94.0}, 0}
    };
    
    // Calculate averages
    for (int i = 0; i < 3; i++) {
        calculate_average(&students[i]);
    }
    
    // Print student information
    for (int i = 0; i < 3; i++) {
        print_student(&students[i]);
    }
    
    // Find student with highest average
    int top_student = 0;
    for (int i = 1; i < 3; i++) {
        if (students[i].average > students[top_student].average) {
            top_student = i;
        }
    }
    
    printf("Top student:\n");
    print_student(&students[top_student]);
    
    return 0;
}
```

### Point Structure with Operations
```c
#include <stdio.h>
#include <math.h>

typedef struct {
    double x;
    double y;
} Point;

// Function to create a point
Point create_point(double x, double y) {
    Point p = {x, y};
    return p;
}

// Function to calculate distance between two points
double distance(const Point *p1, const Point *p2) {
    double dx = p1->x - p2->x;
    double dy = p1->y - p2->y;
    return sqrt(dx * dx + dy * dy);
}

// Function to move a point
void move_point(Point *p, double dx, double dy) {
    p->x += dx;
    p->y += dy;
}

// Function to print a point
void print_point(const Point *p) {
    printf("(%.2f, %.2f)", p->x, p->y);
}

int main() {
    Point p1 = create_point(0, 0);
    Point p2 = create_point(3, 4);
    
    printf("Point 1: ");
    print_point(&p1);
    printf("\n");
    
    printf("Point 2: ");
    print_point(&p2);
    printf("\n");
    
    printf("Distance: %.2f\n", distance(&p1, &p2));
    
    move_point(&p1, 1, 1);
    printf("After moving Point 1: ");
    print_point(&p1);
    printf("\n");
    
    printf("New distance: %.2f\n", distance(&p1, &p2));
    
    return 0;
}
```

## Summary

Structures are fundamental to C programming, providing a way to group related data and create complex data types. Key points to remember:

1. **Declaration and Initialization**: Structures can be declared and initialized in various ways
2. **Member Access**: Use dot operator for structure variables, arrow operator for pointers
3. **Arrays of Structures**: Enable management of multiple related data items
4. **Nested Structures**: Allow creation of complex hierarchical data representations
5. **Function Parameters**: Pass by value creates copies, pass by pointer is more efficient
6. **Memory Layout**: Structures may have padding for alignment
7. **Self-Referential Structures**: Enable linked data structures like lists and trees

Understanding structures is essential for implementing complex data structures, managing related data efficiently, and creating well-organized C programs.