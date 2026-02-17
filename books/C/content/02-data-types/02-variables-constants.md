# Variables and Constants

## Introduction

Variables and constants are fundamental building blocks in C programming. Variables are named storage locations in memory that can hold values which may change during program execution, while constants are fixed values that cannot be altered after they are defined.

Understanding how to properly declare, initialize, and use variables and constants is crucial for writing effective C programs. This chapter will cover all aspects of variables and constants, including their declaration, scope, lifetime, and best practices.

## Variables

### What is a Variable?

A variable is a named memory location that stores data which can be modified during program execution. Every variable in C has:
- A name (identifier)
- A type (determines what kind of data it can store)
- A value (the actual data stored)
- A memory address (location in memory)

### Variable Declaration

Before using a variable, you must declare it by specifying its type and name:

```c
int age;           // Declares an integer variable named 'age'
float height;      // Declares a float variable named 'height'
char initial;      // Declares a character variable named 'initial'
double salary;     // Declares a double variable named 'salary'
```

### Variable Initialization

Variables can be initialized (given an initial value) at the time of declaration:

```c
int age = 25;                    // Initialize with value 25
float height = 5.9f;             // Initialize with value 5.9
char initial = 'J';              // Initialize with character 'J'
double salary = 75000.50;        // Initialize with value 75000.50
```

You can also declare multiple variables of the same type in a single statement:

```c
int x = 10, y = 20, z = 30;      // Multiple integers with initial values
float a, b, c;                   // Multiple floats without initialization
```

### Variable Assignment

After declaration, you can assign new values to variables using the assignment operator (=):

```c
#include <stdio.h>

int main() {
    int number;        // Declaration
    number = 42;       // Assignment
    
    printf("Number: %d\n", number);
    
    number = 100;      // New assignment
    printf("Number: %d\n", number);
    
    return 0;
}
```

### Variable Naming Rules

C has specific rules for naming variables:

1. **Must begin with a letter (a-z, A-Z) or underscore (_)**
2. **Can contain letters, digits (0-9), and underscores**
3. **Cannot be C keywords (int, float, if, etc.)**
4. **Case-sensitive (age and Age are different variables)**
5. **No spaces or special characters allowed**

#### Valid Variable Names
```c
int age;           // Valid
int _temp;         // Valid (starts with underscore)
int student1;      // Valid (contains digit)
int myVariable;    // Valid (camelCase)
int MAX_SIZE;      // Valid (uppercase convention for constants)
```

#### Invalid Variable Names
```c
int 1age;          // Invalid (starts with digit)
int my-age;        // Invalid (contains hyphen)
int int;           // Invalid (keyword)
int my age;        // Invalid (contains space)
int $amount;       // Invalid (contains special character)
```

### Variable Naming Conventions

While C allows various naming styles, following consistent conventions improves code readability:

```c
// Snake case (recommended for C)
int student_age;
float account_balance;
char first_name[50];

// Camel case (also acceptable)
int studentAge;
float accountBalance;
char firstName[50];

// Upper case for constants (convention)
const int MAX_STUDENTS = 100;
const float PI = 3.14159f;
```

## Constants

Constants are fixed values that cannot be changed during program execution. C provides several ways to define constants.

### Literal Constants

Literal constants are values written directly in the code:

```c
int main() {
    int age = 25;           // 25 is an integer literal
    float price = 19.99f;   // 19.99 is a floating-point literal
    char grade = 'A';       // 'A' is a character literal
    char name[] = "John";   // "John" is a string literal
    
    return 0;
}
```

### #define Preprocessor Directive

The `#define` directive creates symbolic constants:

```c
#include <stdio.h>

#define MAX_SIZE 100
#define PI 3.14159
#define COMPANY_NAME "TechCorp"
#define IS_ACTIVE 1

int main() {
    int array[MAX_SIZE];
    float area = PI * 10 * 10;
    
    printf("Company: %s\n", COMPANY_NAME);
    printf("Area of circle: %.2f\n", area);
    
    if (IS_ACTIVE) {
        printf("System is active\n");
    }
    
    return 0;
}
```

### const Qualifier

The `const` keyword creates typed constants:

```c
#include <stdio.h>

int main() {
    const int max_size = 100;
    const float pi = 3.14159f;
    const char company_name[] = "TechCorp";
    
    printf("Max size: %d\n", max_size);
    printf("PI: %.5f\n", pi);
    printf("Company: %s\n", company_name);
    
    // max_size = 200;  // Error: cannot modify const variable
    
    return 0;
}
```

### enum (Enumeration)

Enumerations create named integer constants:

```c
#include <stdio.h>

enum Weekday {
    MONDAY = 1,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY,
    SUNDAY
};

enum Status {
    INACTIVE = 0,
    ACTIVE = 1,
    PENDING = 2
};

int main() {
    enum Weekday today = WEDNESDAY;
    enum Status user_status = ACTIVE;
    
    printf("Today is day %d of the week\n", today);
    printf("User status: %d\n", user_status);
    
    if (user_status == ACTIVE) {
        printf("User is active\n");
    }
    
    return 0;
}
```

## Storage Classes

Storage classes define the scope, visibility, and lifetime of variables and functions.

### auto

The `auto` storage class is the default for local variables:

```c
#include <stdio.h>

int main() {
    auto int count = 0;  // auto is optional
    int number = 10;     // implicitly auto
    
    printf("Count: %d\n", count);
    printf("Number: %d\n", number);
    
    return 0;
}
```

### register

The `register` storage class suggests that the variable be stored in a CPU register for faster access:

```c
#include <stdio.h>

int main() {
    register int counter = 0;
    register int i;
    
    for (i = 0; i < 1000000; i++) {
        counter += i;
    }
    
    printf("Counter: %d\n", counter);
    
    return 0;
}
```

### static

The `static` storage class has different meanings depending on context:

#### Static Local Variables
```c
#include <stdio.h>

void counter() {
    static int count = 0;  // Retains value between function calls
    count++;
    printf("Count: %d\n", count);
}

int main() {
    counter();  // Output: Count: 1
    counter();  // Output: Count: 2
    counter();  // Output: Count: 3
    
    return 0;
}
```

#### Static Global Variables
```c
#include <stdio.h>

static int internal_count = 0;  // Only accessible within this file

void increment_count() {
    internal_count++;
}

int get_count() {
    return internal_count;
}

int main() {
    increment_count();
    increment_count();
    printf("Internal count: %d\n", get_count());
    
    return 0;
}
```

### extern

The `extern` storage class declares a variable that is defined in another file:

```c
// file1.c
int global_counter = 0;  // Definition

// file2.c
#include <stdio.h>

extern int global_counter;  // Declaration (defined elsewhere)

void print_counter() {
    printf("Global counter: %d\n", global_counter);
}
```

## Scope and Lifetime

### Scope

Scope determines where a variable can be accessed in the code:

#### Local Scope
```c
#include <stdio.h>

int main() {
    int local_var = 10;  // Local to main function
    
    if (local_var > 5) {
        int block_var = 20;  // Local to this block
        printf("Local var: %d, Block var: %d\n", local_var, block_var);
    }
    
    // printf("Block var: %d\n", block_var);  // Error: out of scope
    
    return 0;
}
```

#### Global Scope
```c
#include <stdio.h>

int global_var = 100;  // Global scope

void function1() {
    printf("Global var in function1: %d\n", global_var);
}

int main() {
    printf("Global var in main: %d\n", global_var);
    function1();
    
    return 0;
}
```

### Lifetime

Lifetime determines how long a variable exists in memory:

```c
#include <stdio.h>

int global_var = 100;  // Exists for entire program duration

void function() {
    static int static_var = 0;  // Initialized only once, exists for program duration
    int local_var = 10;         // Created and destroyed each function call
    
    static_var++;
    printf("Static var: %d, Local var: %d\n", static_var, local_var);
}

int main() {
    function();  // Static var: 1, Local var: 10
    function();  // Static var: 2, Local var: 10
    function();  // Static var: 3, Local var: 10
    
    return 0;
}
```

## Type Qualifiers

### const

The `const` qualifier makes a variable read-only:

```c
#include <stdio.h>

int main() {
    const int max_items = 50;
    const float tax_rate = 0.08f;
    
    // max_items = 100;  // Error: cannot modify const variable
    
    printf("Max items: %d\n", max_items);
    printf("Tax rate: %.2f\n", tax_rate);
    
    return 0;
}
```

### volatile

The `volatile` qualifier tells the compiler that a variable's value may change unexpectedly:

```c
#include <stdio.h>

int main() {
    volatile int sensor_value = 0;  // May be changed by hardware
    
    // Compiler won't optimize away reads/writes to volatile variables
    while (sensor_value < 100) {
        // Read sensor value (might be updated by hardware)
        printf("Sensor value: %d\n", sensor_value);
    }
    
    return 0;
}
```

### restrict (C99+)

The `restrict` qualifier is used with pointers to indicate that no other pointer will access the same memory location:

```c
#include <stdio.h>

void add_arrays(int n, int *restrict a, int *restrict b, int *restrict c) {
    // Compiler can optimize knowing a, b, c don't overlap
    for (int i = 0; i < n; i++) {
        c[i] = a[i] + b[i];
    }
}

int main() {
    int array1[5] = {1, 2, 3, 4, 5};
    int array2[5] = {10, 20, 30, 40, 50};
    int result[5];
    
    add_arrays(5, array1, array2, result);
    
    for (int i = 0; i < 5; i++) {
        printf("%d ", result[i]);
    }
    printf("\n");
    
    return 0;
}
```

## Practical Examples

### Variable Declaration and Usage
```c
#include <stdio.h>

int main() {
    // Different ways to declare and initialize variables
    int age = 25;
    float height = 5.9f;
    double weight = 150.5;
    char grade = 'A';
    char name[] = "John Doe";
    
    // Display initial values
    printf("=== Initial Values ===\n");
    printf("Age: %d\n", age);
    printf("Height: %.1f feet\n", height);
    printf("Weight: %.1f pounds\n", weight);
    printf("Grade: %c\n", grade);
    printf("Name: %s\n", name);
    
    // Modify variables
    age = 26;
    height = 6.0f;
    weight = 155.0;
    grade = 'B';
    
    // Display modified values
    printf("\n=== Modified Values ===\n");
    printf("Age: %d\n", age);
    printf("Height: %.1f feet\n", height);
    printf("Weight: %.1f pounds\n", weight);
    printf("Grade: %c\n", grade);
    
    return 0;
}
```

### Constants Comparison
```c
#include <stdio.h>

#define PI_DEFINE 3.14159
const float PI_CONST = 3.14159f;

enum Colors {
    RED = 1,
    GREEN = 2,
    BLUE = 4
};

int main() {
    // Using #define constant
    float area1 = PI_DEFINE * 10 * 10;
    
    // Using const variable
    float area2 = PI_CONST * 15 * 15;
    
    // Using enum constants
    int selected_colors = RED | BLUE;
    
    printf("Area using #define: %.2f\n", area1);
    printf("Area using const: %.2f\n", area2);
    printf("Selected colors: %d\n", selected_colors);
    
    return 0;
}
```

### Storage Class Demonstration
```c
#include <stdio.h>

int global_counter = 0;  // Global variable

void demonstrate_storage_classes() {
    auto int auto_var = 10;        // Automatic storage (default)
    register int reg_var = 20;     // Register storage
    static int static_var = 0;     // Static storage
    
    global_counter++;
    static_var++;
    
    printf("Auto var: %d\n", auto_var);
    printf("Register var: %d\n", reg_var);
    printf("Static var: %d\n", static_var);
    printf("Global counter: %d\n", global_counter);
    printf("---\n");
}

int main() {
    printf("First call:\n");
    demonstrate_storage_classes();
    
    printf("Second call:\n");
    demonstrate_storage_classes();
    
    printf("Third call:\n");
    demonstrate_storage_classes();
    
    return 0;
}
```

## Best Practices

### 1. Initialize Variables
```c
// Good practice
int count = 0;
float price = 0.0f;

// Avoid (uninitialized variables)
int count;  // Contains garbage value
```

### 2. Use Meaningful Names
```c
// Good
int student_age;
float account_balance;
char first_name[50];

// Avoid
int x;
float y;
char z[50];
```

### 3. Use const for Fixed Values
```c
// Good
const int MAX_STUDENTS = 100;
const float TAX_RATE = 0.08f;

// Avoid
#define MAX_STUDENTS 100
#define TAX_RATE 0.08
```

### 4. Limit Global Variables
```c
// Prefer local variables when possible
void calculate_area(float radius) {
    const float PI = 3.14159f;  // Local constant
    float area = PI * radius * radius;
    printf("Area: %.2f\n", area);
}
```

### 5. Use Appropriate Storage Classes
```c
// Use static for persistent local state
void counter() {
    static int count = 0;
    count++;
    printf("Call #%d\n", count);
}
```

## Summary

In this chapter, you've learned about:

1. **Variables**: Declaration, initialization, naming rules, and assignment
2. **Constants**: #define, const, and enum for creating fixed values
3. **Storage Classes**: auto, register, static, and extern
4. **Scope and Lifetime**: Local vs global scope, variable lifetime
5. **Type Qualifiers**: const, volatile, and restrict
6. **Best Practices**: Proper variable naming, initialization, and usage

Understanding variables and constants is essential for effective C programming. In the next chapter, we'll explore type conversions and how C handles different data types in expressions.