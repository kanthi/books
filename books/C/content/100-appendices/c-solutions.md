# Appendix C: Exercise Solutions

This appendix provides solutions to selected exercises from each module of the course. These solutions are meant to serve as examples of good programming practices and to help you understand the concepts covered in each module.

## Module 1: Foundations

### Exercise 1.1: Hello World Variations
```c
#include <stdio.h>

int main() {
    // Basic Hello World
    printf("Hello, World!\n");
    
    // Personalized greeting
    printf("Hello, C Programmer!\n");
    
    // Multi-line message
    printf("Welcome to C programming.\n");
    printf("This is the beginning of your journey.\n");
    
    return 0;
}
```

### Exercise 1.2: Basic Calculator
```c
#include <stdio.h>

int main() {
    double num1, num2;
    char operator;
    
    printf("Enter first number: ");
    scanf("%lf", &num1);
    
    printf("Enter an operator (+, -, *, /): ");
    scanf(" %c", &operator);
    
    printf("Enter second number: ");
    scanf("%lf", &num2);
    
    switch (operator) {
        case '+':
            printf("%.2lf + %.2lf = %.2lf\n", num1, num2, num1 + num2);
            break;
        case '-':
            printf("%.2lf - %.2lf = %.2lf\n", num1, num2, num1 - num2);
            break;
        case '*':
            printf("%.2lf * %.2lf = %.2lf\n", num1, num2, num1 * num2);
            break;
        case '/':
            if (num2 != 0) {
                printf("%.2lf / %.2lf = %.2lf\n", num1, num2, num1 / num2);
            } else {
                printf("Error: Division by zero\n");
            }
            break;
        default:
            printf("Error: Invalid operator\n");
    }
    
    return 0;
}
```

## Module 2: Data Types

### Exercise 2.1: Size and Range Calculator
```c
#include <stdio.h>
#include <limits.h>
#include <float.h>

int main() {
    printf("Data Type Sizes and Ranges:\n");
    printf("==========================\n");
    
    printf("char: %zu bytes\n", sizeof(char));
    printf("  Range: %d to %d\n", CHAR_MIN, CHAR_MAX);
    
    printf("unsigned char: %zu bytes\n", sizeof(unsigned char));
    printf("  Range: 0 to %u\n", UCHAR_MAX);
    
    printf("short: %zu bytes\n", sizeof(short));
    printf("  Range: %d to %d\n", SHRT_MIN, SHRT_MAX);
    
    printf("unsigned short: %zu bytes\n", sizeof(unsigned short));
    printf("  Range: 0 to %u\n", USHRT_MAX);
    
    printf("int: %zu bytes\n", sizeof(int));
    printf("  Range: %d to %d\n", INT_MIN, INT_MAX);
    
    printf("unsigned int: %zu bytes\n", sizeof(unsigned int));
    printf("  Range: 0 to %u\n", UINT_MAX);
    
    printf("long: %zu bytes\n", sizeof(long));
    printf("  Range: %ld to %ld\n", LONG_MIN, LONG_MAX);
    
    printf("unsigned long: %zu bytes\n", sizeof(unsigned long));
    printf("  Range: 0 to %lu\n", ULONG_MAX);
    
    printf("float: %zu bytes\n", sizeof(float));
    printf("  Range: %e to %e\n", FLT_MIN, FLT_MAX);
    printf("  Precision: %d digits\n", FLT_DIG);
    
    printf("double: %zu bytes\n", sizeof(double));
    printf("  Range: %e to %e\n", DBL_MIN, DBL_MAX);
    printf("  Precision: %d digits\n", DBL_DIG);
    
    return 0;
}
```

### Exercise 2.2: Temperature Converter
```c
#include <stdio.h>

double celsius_to_fahrenheit(double celsius) {
    return (celsius * 9.0 / 5.0) + 32.0;
}

double fahrenheit_to_celsius(double fahrenheit) {
    return (fahrenheit - 32.0) * 5.0 / 9.0;
}

int main() {
    double temperature;
    int choice;
    
    printf("Temperature Converter\n");
    printf("1. Celsius to Fahrenheit\n");
    printf("2. Fahrenheit to Celsius\n");
    printf("Enter your choice (1 or 2): ");
    scanf("%d", &choice);
    
    if (choice == 1) {
        printf("Enter temperature in Celsius: ");
        scanf("%lf", &temperature);
        printf("%.2lf°C = %.2lf°F\n", temperature, celsius_to_fahrenheit(temperature));
    } else if (choice == 2) {
        printf("Enter temperature in Fahrenheit: ");
        scanf("%lf", &temperature);
        printf("%.2lf°F = %.2lf°C\n", temperature, fahrenheit_to_celsius(temperature));
    } else {
        printf("Invalid choice\n");
    }
    
    return 0;
}
```

## Module 3: Control Flow

### Exercise 3.1: Prime Number Checker
```c
#include <stdio.h>
#include <stdbool.h>

bool is_prime(int n) {
    if (n <= 1) return false;
    if (n <= 3) return true;
    if (n % 2 == 0 || n % 3 == 0) return false;
    
    for (int i = 5; i * i <= n; i += 6) {
        if (n % i == 0 || n % (i + 2) == 0) {
            return false;
        }
    }
    return true;
}

int main() {
    int number;
    
    printf("Enter a number: ");
    scanf("%d", &number);
    
    if (is_prime(number)) {
        printf("%d is a prime number\n", number);
    } else {
        printf("%d is not a prime number\n", number);
    }
    
    return 0;
}
```

### Exercise 3.2: Pattern Printer
```c
#include <stdio.h>

void print_triangle(int n) {
    for (int i = 1; i <= n; i++) {
        // Print spaces
        for (int j = 1; j <= n - i; j++) {
            printf(" ");
        }
        // Print stars
        for (int j = 1; j <= 2 * i - 1; j++) {
            printf("*");
        }
        printf("\n");
    }
}

void print_diamond(int n) {
    // Upper half (including middle)
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= n - i; j++) {
            printf(" ");
        }
        for (int j = 1; j <= 2 * i - 1; j++) {
            printf("*");
        }
        printf("\n");
    }
    
    // Lower half
    for (int i = n - 1; i >= 1; i--) {
        for (int j = 1; j <= n - i; j++) {
            printf(" ");
        }
        for (int j = 1; j <= 2 * i - 1; j++) {
            printf("*");
        }
        printf("\n");
    }
}

int main() {
    int n;
    int choice;
    
    printf("Pattern Printer\n");
    printf("1. Triangle\n");
    printf("2. Diamond\n");
    printf("Enter your choice (1 or 2): ");
    scanf("%d", &choice);
    
    printf("Enter the size: ");
    scanf("%d", &n);
    
    if (choice == 1) {
        print_triangle(n);
    } else if (choice == 2) {
        print_diamond(n);
    } else {
        printf("Invalid choice\n");
    }
    
    return 0;
}
```

## Module 4: Functions

### Exercise 4.1: Mathematical Functions Library
```c
#include <stdio.h>
#include <math.h>

// Function to calculate factorial
long long factorial(int n) {
    if (n < 0) return -1;  // Error case
    if (n == 0 || n == 1) return 1;
    
    long long result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

// Function to calculate power
double power(double base, int exponent) {
    if (exponent == 0) return 1.0;
    
    double result = 1.0;
    int abs_exp = (exponent < 0) ? -exponent : exponent;
    
    for (int i = 0; i < abs_exp; i++) {
        result *= base;
    }
    
    return (exponent < 0) ? 1.0 / result : result;
}

// Function to calculate GCD using Euclidean algorithm
int gcd(int a, int b) {
    while (b != 0) {
        int temp = b;
        b = a % b;
        a = temp;
    }
    return a;
}

// Function to calculate LCM
int lcm(int a, int b) {
    return (a * b) / gcd(a, b);
}

int main() {
    int choice, a, b;
    double x;
    int n;
    
    printf("Mathematical Functions Library\n");
    printf("1. Factorial\n");
    printf("2. Power\n");
    printf("3. GCD\n");
    printf("4. LCM\n");
    printf("Enter your choice (1-4): ");
    scanf("%d", &choice);
    
    switch (choice) {
        case 1:
            printf("Enter a number: ");
            scanf("%d", &n);
            if (n >= 0) {
                printf("Factorial of %d = %lld\n", n, factorial(n));
            } else {
                printf("Factorial is not defined for negative numbers\n");
            }
            break;
            
        case 2:
            printf("Enter base: ");
            scanf("%lf", &x);
            printf("Enter exponent: ");
            scanf("%d", &n);
            printf("%.2lf^%d = %.2lf\n", x, n, power(x, n));
            break;
            
        case 3:
            printf("Enter first number: ");
            scanf("%d", &a);
            printf("Enter second number: ");
            scanf("%d", &b);
            printf("GCD of %d and %d = %d\n", a, b, gcd(a, b));
            break;
            
        case 4:
            printf("Enter first number: ");
            scanf("%d", &a);
            printf("Enter second number: ");
            scanf("%d", &b);
            printf("LCM of %d and %d = %d\n", a, b, lcm(a, b));
            break;
            
        default:
            printf("Invalid choice\n");
    }
    
    return 0;
}
```

### Exercise 4.2: Recursive Functions
```c
#include <stdio.h>

// Recursive factorial
long long recursive_factorial(int n) {
    if (n < 0) return -1;
    if (n == 0 || n == 1) return 1;
    return n * recursive_factorial(n - 1);
}

// Recursive Fibonacci
int recursive_fibonacci(int n) {
    if (n <= 0) return 0;
    if (n == 1) return 1;
    return recursive_fibonacci(n - 1) + recursive_fibonacci(n - 2);
}

// Recursive power
double recursive_power(double base, int exponent) {
    if (exponent == 0) return 1.0;
    if (exponent > 0) {
        return base * recursive_power(base, exponent - 1);
    } else {
        return 1.0 / base * recursive_power(base, exponent + 1);
    }
}

int main() {
    int choice, n;
    double x;
    int exp;
    
    printf("Recursive Functions\n");
    printf("1. Factorial\n");
    printf("2. Fibonacci\n");
    printf("3. Power\n");
    printf("Enter your choice (1-3): ");
    scanf("%d", &choice);
    
    switch (choice) {
        case 1:
            printf("Enter a number: ");
            scanf("%d", &n);
            if (n >= 0) {
                printf("Factorial of %d = %lld\n", n, recursive_factorial(n));
            } else {
                printf("Factorial is not defined for negative numbers\n");
            }
            break;
            
        case 2:
            printf("Enter position: ");
            scanf("%d", &n);
            if (n >= 0) {
                printf("Fibonacci number at position %d = %d\n", n, recursive_fibonacci(n));
            } else {
                printf("Invalid position\n");
            }
            break;
            
        case 3:
            printf("Enter base: ");
            scanf("%lf", &x);
            printf("Enter exponent: ");
            scanf("%d", &exp);
            printf("%.2lf^%d = %.2lf\n", x, exp, recursive_power(x, exp));
            break;
            
        default:
            printf("Invalid choice\n");
    }
    
    return 0;
}
```

## Module 5: Arrays and Strings

### Exercise 5.1: Array Operations
```c
#include <stdio.h>
#include <limits.h>

// Function to find maximum element in array
int find_max(int arr[], int size) {
    int max = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] > max) {
            max = arr[i];
        }
    }
    return max;
}

// Function to find minimum element in array
int find_min(int arr[], int size) {
    int min = arr[0];
    for (int i = 1; i < size; i++) {
        if (arr[i] < min) {
            min = arr[i];
        }
    }
    return min;
}

// Function to calculate average
double calculate_average(int arr[], int size) {
    long long sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }
    return (double)sum / size;
}

// Function to reverse array
void reverse_array(int arr[], int size) {
    for (int i = 0; i < size / 2; i++) {
        int temp = arr[i];
        arr[i] = arr[size - 1 - i];
        arr[size - 1 - i] = temp;
    }
}

// Function to print array
void print_array(int arr[], int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) printf(", ");
    }
    printf("]\n");
}

int main() {
    int arr[] = {64, 34, 25, 12, 22, 11, 90};
    int size = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array(arr, size);
    
    printf("Maximum element: %d\n", find_max(arr, size));
    printf("Minimum element: %d\n", find_min(arr, size));
    printf("Average: %.2f\n", calculate_average(arr, size));
    
    reverse_array(arr, size);
    printf("Reversed array: ");
    print_array(arr, size);
    
    return 0;
}
```

### Exercise 5.2: String Manipulation
```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

// Function to count vowels
int count_vowels(const char *str) {
    int count = 0;
    for (int i = 0; str[i] != '\0'; i++) {
        char ch = tolower(str[i]);
        if (ch == 'a' || ch == 'e' || ch == 'i' || ch == 'o' || ch == 'u') {
            count++;
        }
    }
    return count;
}

// Function to reverse string
void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
}

// Function to check palindrome
int is_palindrome(const char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - 1 - i])) {
            return 0;
        }
    }
    return 1;
}

// Function to remove spaces
void remove_spaces(char *str) {
    int i, j = 0;
    for (i = 0; str[i] != '\0'; i++) {
        if (str[i] != ' ') {
            str[j++] = str[i];
        }
    }
    str[j] = '\0';
}

int main() {
    char str[100];
    
    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin);
    
    // Remove newline character if present
    str[strcspn(str, "\n")] = 0;
    
    printf("Original string: %s\n", str);
    printf("Number of vowels: %d\n", count_vowels(str));
    
    char str_copy[100];
    strcpy(str_copy, str);
    reverse_string(str_copy);
    printf("Reversed string: %s\n", str_copy);
    
    if (is_palindrome(str)) {
        printf("The string is a palindrome\n");
    } else {
        printf("The string is not a palindrome\n");
    }
    
    strcpy(str_copy, str);
    remove_spaces(str_copy);
    printf("String without spaces: %s\n", str_copy);
    
    return 0;
}
```

## Module 6: Pointers

### Exercise 6.1: Pointer Arithmetic
```c
#include <stdio.h>

// Function to swap two integers using pointers
void swap(int *a, int *b) {
    int temp = *a;
    *a = *b;
    *b = temp;
}

// Function to find maximum in array using pointers
int* find_max_ptr(int *arr, int size) {
    int *max = arr;
    for (int i = 1; i < size; i++) {
        if (*(arr + i) > *max) {
            max = arr + i;
        }
    }
    return max;
}

// Function to reverse array using pointers
void reverse_array_ptr(int *arr, int size) {
    int *start = arr;
    int *end = arr + size - 1;
    
    while (start < end) {
        int temp = *start;
        *start = *end;
        *end = temp;
        start++;
        end--;
    }
}

// Function to print array using pointers
void print_array_ptr(int *arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", *(arr + i));
        if (i < size - 1) printf(", ");
    }
    printf("]\n");
}

int main() {
    int arr[] = {64, 34, 25, 12, 22, 11, 90};
    int size = sizeof(arr) / sizeof(arr[0]);
    
    printf("Original array: ");
    print_array_ptr(arr, size);
    
    int a = 10, b = 20;
    printf("Before swap: a = %d, b = %d\n", a, b);
    swap(&a, &b);
    printf("After swap: a = %d, b = %d\n", a, b);
    
    int *max_ptr = find_max_ptr(arr, size);
    printf("Maximum element: %d at address %p\n", *max_ptr, (void*)max_ptr);
    
    reverse_array_ptr(arr, size);
    printf("Reversed array: ");
    print_array_ptr(arr, size);
    
    return 0;
}
```

### Exercise 6.2: Dynamic Memory Allocation
```c
#include <stdio.h>
#include <stdlib.h>

// Function to create dynamic array
int* create_array(int size) {
    int *arr = (int*)malloc(size * sizeof(int));
    if (arr == NULL) {
        printf("Memory allocation failed\n");
        return NULL;
    }
    return arr;
}

// Function to initialize array with random values
void initialize_array(int *arr, int size) {
    for (int i = 0; i < size; i++) {
        arr[i] = rand() % 100;  // Random numbers 0-99
    }
}

// Function to resize array
int* resize_array(int *arr, int old_size, int new_size) {
    int *new_arr = (int*)realloc(arr, new_size * sizeof(int));
    if (new_arr == NULL) {
        printf("Memory reallocation failed\n");
        return arr;  // Return original array
    }
    
    // Initialize new elements to 0
    if (new_size > old_size) {
        for (int i = old_size; i < new_size; i++) {
            new_arr[i] = 0;
        }
    }
    
    return new_arr;
}

// Function to free array
void free_array(int *arr) {
    free(arr);
}

// Function to print array
void print_array(int *arr, int size) {
    printf("[");
    for (int i = 0; i < size; i++) {
        printf("%d", arr[i]);
        if (i < size - 1) printf(", ");
    }
    printf("]\n");
}

int main() {
    int size = 5;
    int *arr = create_array(size);
    
    if (arr != NULL) {
        initialize_array(arr, size);
        printf("Original array: ");
        print_array(arr, size);
        
        // Resize array
        int new_size = 8;
        arr = resize_array(arr, size, new_size);
        if (arr != NULL) {
            printf("Resized array: ");
            print_array(arr, new_size);
        }
        
        free_array(arr);
        printf("Memory freed successfully\n");
    }
    
    return 0;
}
```

## Module 7: Structures

### Exercise 7.1: Student Database
```c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#define MAX_STUDENTS 100

typedef struct {
    int id;
    char name[50];
    int age;
    float gpa;
} Student;

// Function to add student
void add_student(Student students[], int *count) {
    if (*count >= MAX_STUDENTS) {
        printf("Database is full\n");
        return;
    }
    
    Student *s = &students[*count];
    
    printf("Enter student ID: ");
    scanf("%d", &s->id);
    
    printf("Enter student name: ");
    scanf(" %[^\n]", s->name);
    
    printf("Enter student age: ");
    scanf("%d", &s->age);
    
    printf("Enter student GPA: ");
    scanf("%f", &s->gpa);
    
    (*count)++;
    printf("Student added successfully\n");
}

// Function to display all students
void display_students(Student students[], int count) {
    if (count == 0) {
        printf("No students in database\n");
        return;
    }
    
    printf("\nStudent Database:\n");
    printf("ID\tName\t\t\tAge\tGPA\n");
    printf("----------------------------------------\n");
    
    for (int i = 0; i < count; i++) {
        Student *s = &students[i];
        printf("%d\t%-20s\t%d\t%.2f\n", s->id, s->name, s->age, s->gpa);
    }
}

// Function to find student by ID
Student* find_student(Student students[], int count, int id) {
    for (int i = 0; i < count; i++) {
        if (students[i].id == id) {
            return &students[i];
        }
    }
    return NULL;
}

// Function to calculate average GPA
float calculate_average_gpa(Student students[], int count) {
    if (count == 0) return 0.0;
    
    float sum = 0.0;
    for (int i = 0; i < count; i++) {
        sum += students[i].gpa;
    }
    return sum / count;
}

int main() {
    Student students[MAX_STUDENTS];
    int count = 0;
    int choice, id;
    
    while (1) {
        printf("\nStudent Database Menu:\n");
        printf("1. Add Student\n");
        printf("2. Display All Students\n");
        printf("3. Find Student by ID\n");
        printf("4. Calculate Average GPA\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                add_student(students, &count);
                break;
                
            case 2:
                display_students(students, count);
                break;
                
            case 3:
                printf("Enter student ID: ");
                scanf("%d", &id);
                Student *s = find_student(students, count, id);
                if (s != NULL) {
                    printf("Student found:\n");
                    printf("ID: %d\n", s->id);
                    printf("Name: %s\n", s->name);
                    printf("Age: %d\n", s->age);
                    printf("GPA: %.2f\n", s->gpa);
                } else {
                    printf("Student not found\n");
                }
                break;
                
            case 4:
                printf("Average GPA: %.2f\n", calculate_average_gpa(students, count));
                break;
                
            case 5:
                printf("Exiting program\n");
                exit(0);
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

### Exercise 7.2: Complex Number Operations
```c
#include <stdio.h>
#include <math.h>

typedef struct {
    double real;
    double imag;
} Complex;

// Function to create complex number
Complex create_complex(double real, double imag) {
    Complex c = {real, imag};
    return c;
}

// Function to add two complex numbers
Complex add_complex(Complex a, Complex b) {
    Complex result;
    result.real = a.real + b.real;
    result.imag = a.imag + b.imag;
    return result;
}

// Function to subtract two complex numbers
Complex subtract_complex(Complex a, Complex b) {
    Complex result;
    result.real = a.real - b.real;
    result.imag = a.imag - b.imag;
    return result;
}

// Function to multiply two complex numbers
Complex multiply_complex(Complex a, Complex b) {
    Complex result;
    result.real = a.real * b.real - a.imag * b.imag;
    result.imag = a.real * b.imag + a.imag * b.real;
    return result;
}

// Function to calculate magnitude of complex number
double magnitude_complex(Complex c) {
    return sqrt(c.real * c.real + c.imag * c.imag);
}

// Function to print complex number
void print_complex(Complex c) {
    if (c.imag >= 0) {
        printf("%.2f + %.2fi", c.real, c.imag);
    } else {
        printf("%.2f - %.2fi", c.real, -c.imag);
    }
}

int main() {
    Complex a, b, result;
    int choice;
    
    printf("Enter first complex number:\n");
    printf("Real part: ");
    scanf("%lf", &a.real);
    printf("Imaginary part: ");
    scanf("%lf", &a.imag);
    
    printf("Enter second complex number:\n");
    printf("Real part: ");
    scanf("%lf", &b.real);
    printf("Imaginary part: ");
    scanf("%lf", &b.imag);
    
    while (1) {
        printf("\nComplex Number Operations:\n");
        printf("1. Add\n");
        printf("2. Subtract\n");
        printf("3. Multiply\n");
        printf("4. Magnitude of first number\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                result = add_complex(a, b);
                printf("Result: ");
                print_complex(a);
                printf(" + ");
                print_complex(b);
                printf(" = ");
                print_complex(result);
                printf("\n");
                break;
                
            case 2:
                result = subtract_complex(a, b);
                printf("Result: ");
                print_complex(a);
                printf(" - ");
                print_complex(b);
                printf(" = ");
                print_complex(result);
                printf("\n");
                break;
                
            case 3:
                result = multiply_complex(a, b);
                printf("Result: ");
                print_complex(a);
                printf(" * ");
                print_complex(b);
                printf(" = ");
                print_complex(result);
                printf("\n");
                break;
                
            case 4:
                printf("Magnitude of ");
                print_complex(a);
                printf(" = %.2f\n", magnitude_complex(a));
                break;
                
            case 5:
                printf("Exiting program\n");
                return 0;
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

## Module 8: File I/O

### Exercise 8.1: Text File Processor
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Function to count lines, words, and characters
void analyze_file(const char *filename) {
    FILE *file = fopen(filename, "r");
    if (file == NULL) {
        perror("Error opening file");
        return;
    }
    
    int lines = 0, words = 0, characters = 0;
    int ch, in_word = 0;
    
    while ((ch = fgetc(file)) != EOF) {
        characters++;
        
        if (ch == '\n') {
            lines++;
        }
        
        if (isspace(ch)) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            words++;
        }
    }
    
    // Handle case where file doesn't end with newline
    if (characters > 0 && fseek(file, -1, SEEK_END) == 0) {
        if (fgetc(file) != '\n') {
            lines++;
        }
    }
    
    fclose(file);
    
    printf("File Analysis for '%s':\n", filename);
    printf("Lines: %d\n", lines);
    printf("Words: %d\n", words);
    printf("Characters: %d\n", characters);
}

// Function to copy file
void copy_file(const char *source, const char *destination) {
    FILE *src = fopen(source, "r");
    if (src == NULL) {
        perror("Error opening source file");
        return;
    }
    
    FILE *dest = fopen(destination, "w");
    if (dest == NULL) {
        perror("Error opening destination file");
        fclose(src);
        return;
    }
    
    int ch;
    while ((ch = fgetc(src)) != EOF) {
        fputc(ch, dest);
    }
    
    fclose(src);
    fclose(dest);
    
    printf("File copied successfully from '%s' to '%s'\n", source, destination);
}

// Function to convert text to uppercase
void convert_to_uppercase(const char *input, const char *output) {
    FILE *in = fopen(input, "r");
    if (in == NULL) {
        perror("Error opening input file");
        return;
    }
    
    FILE *out = fopen(output, "w");
    if (out == NULL) {
        perror("Error opening output file");
        fclose(in);
        return;
    }
    
    int ch;
    while ((ch = fgetc(in)) != EOF) {
        fputc(toupper(ch), out);
    }
    
    fclose(in);
    fclose(out);
    
    printf("Text converted to uppercase and saved to '%s'\n", output);
}

int main() {
    int choice;
    char filename1[100], filename2[100];
    
    while (1) {
        printf("\nText File Processor:\n");
        printf("1. Analyze file\n");
        printf("2. Copy file\n");
        printf("3. Convert to uppercase\n");
        printf("4. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter filename: ");
                scanf("%s", filename1);
                analyze_file(filename1);
                break;
                
            case 2:
                printf("Enter source filename: ");
                scanf("%s", filename1);
                printf("Enter destination filename: ");
                scanf("%s", filename2);
                copy_file(filename1, filename2);
                break;
                
            case 3:
                printf("Enter input filename: ");
                scanf("%s", filename1);
                printf("Enter output filename: ");
                scanf("%s", filename2);
                convert_to_uppercase(filename1, filename2);
                break;
                
            case 4:
                printf("Exiting program\n");
                return 0;
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

### Exercise 8.2: Binary File Operations
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_RECORDS 100

typedef struct {
    int id;
    char name[50];
    float salary;
} Employee;

// Function to write employee data to binary file
void write_employees(const char *filename, Employee employees[], int count) {
    FILE *file = fopen(filename, "wb");
    if (file == NULL) {
        perror("Error opening file for writing");
        return;
    }
    
    fwrite(&count, sizeof(int), 1, file);
    fwrite(employees, sizeof(Employee), count, file);
    
    fclose(file);
    printf("Employee data written to '%s'\n", filename);
}

// Function to read employee data from binary file
int read_employees(const char *filename, Employee employees[]) {
    FILE *file = fopen(filename, "rb");
    if (file == NULL) {
        perror("Error opening file for reading");
        return 0;
    }
    
    int count;
    fread(&count, sizeof(int), 1, file);
    
    if (count > MAX_RECORDS) {
        printf("Too many records in file\n");
        fclose(file);
        return 0;
    }
    
    fread(employees, sizeof(Employee), count, file);
    fclose(file);
    
    printf("Employee data read from '%s'\n", filename);
    return count;
}

// Function to add employee
void add_employee(Employee employees[], int *count) {
    if (*count >= MAX_RECORDS) {
        printf("Maximum number of employees reached\n");
        return;
    }
    
    Employee *emp = &employees[*count];
    
    printf("Enter employee ID: ");
    scanf("%d", &emp->id);
    
    printf("Enter employee name: ");
    scanf(" %[^\n]", emp->name);
    
    printf("Enter employee salary: ");
    scanf("%f", &emp->salary);
    
    (*count)++;
    printf("Employee added successfully\n");
}

// Function to display all employees
void display_employees(Employee employees[], int count) {
    if (count == 0) {
        printf("No employees in database\n");
        return;
    }
    
    printf("\nEmployee Database:\n");
    printf("ID\tName\t\t\tSalary\n");
    printf("----------------------------------------\n");
    
    for (int i = 0; i < count; i++) {
        Employee *emp = &employees[i];
        printf("%d\t%-20s\t$%.2f\n", emp->id, emp->name, emp->salary);
    }
}

int main() {
    Employee employees[MAX_RECORDS];
    int count = 0;
    int choice;
    char filename[100];
    
    while (1) {
        printf("\nBinary File Employee Database:\n");
        printf("1. Add Employee\n");
        printf("2. Display Employees\n");
        printf("3. Save to File\n");
        printf("4. Load from File\n");
        printf("5. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                add_employee(employees, &count);
                break;
                
            case 2:
                display_employees(employees, count);
                break;
                
            case 3:
                printf("Enter filename: ");
                scanf("%s", filename);
                write_employees(filename, employees, count);
                break;
                
            case 4:
                printf("Enter filename: ");
                scanf("%s", filename);
                count = read_employees(filename, employees);
                break;
                
            case 5:
                printf("Exiting program\n");
                return 0;
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

## Module 9: Modern C Features

### Exercise 9.1: C99 Features Demonstration
```c
#include <stdio.h>
#include <stdbool.h>
#include <stdint.h>
#include <inttypes.h>

// Variable-length array example
void vla_example(int size) {
    int arr[size];  // VLA - size determined at runtime
    
    printf("VLA of size %d:\n", size);
    for (int i = 0; i < size; i++) {
        arr[i] = i * i;
        printf("arr[%d] = %d\n", i, arr[i]);
    }
}

// Inline function example
inline int max(int a, int b) {
    return (a > b) ? a : b;
}

// _Bool example
void bool_example(void) {
    bool flag1 = true;
    bool flag2 = false;
    
    printf("Boolean values: flag1 = %s, flag2 = %s\n",
           flag1 ? "true" : "false",
           flag2 ? "true" : "false");
    
    bool result = flag1 && !flag2;
    printf("flag1 AND NOT flag2 = %s\n", result ? "true" : "false");
}

int main() {
    printf("C99 Features Demonstration\n");
    printf("==========================\n");
    
    // Variable-length array
    int size;
    printf("Enter size for VLA: ");
    scanf("%d", &size);
    vla_example(size);
    
    // Inline function
    int a = 15, b = 25;
    printf("Max of %d and %d = %d\n", a, b, max(a, b));
    
    // Boolean example
    bool_example();
    
    // Fixed-width integers
    int32_t fixed_int = 123456789;
    uint64_t big_uint = 123456789012345ULL;
    
    printf("Fixed-width integers:\n");
    printf("int32_t: %" PRId32 "\n", fixed_int);
    printf("uint64_t: %" PRIu64 "\n", big_uint);
    
    return 0;
}
```

### Exercise 9.2: C11 Features Demonstration
```c
#include <stdio.h>
#include <stdlib.h>
#include <stdalign.h>
#include <stdnoreturn.h>
#include <threads.h>
#include <stdatomic.h>

// Static assertion example
#define ARRAY_SIZE 10
_Static_assert(ARRAY_SIZE > 0, "Array size must be positive");

// Generic selection example
#define PRINT_GENERIC(x) _Generic((x), \
    int: printf("Integer: %d\n"), \
    float: printf("Float: %f\n"), \
    double: printf("Double: %f\n"), \
    char*: printf("String: %s\n"), \
    default: printf("Unknown type\n") \
)(x)

// Noreturn function example
noreturn void fatal_error(const char *msg) {
    printf("Fatal error: %s\n", msg);
    exit(EXIT_FAILURE);
}

// Alignment example
struct aligned_struct {
    alignas(16) double x;
    int y;
};

// Atomic operations example
atomic_int global_counter = ATOMIC_VAR_INIT(0);

int increment_counter(void *arg) {
    for (int i = 0; i < 1000; i++) {
        atomic_fetch_add(&global_counter, 1);
    }
    return 0;
}

int main() {
    printf("C11 Features Demonstration\n");
    printf("==========================\n");
    
    // Generic selection
    int i = 42;
    float f = 3.14f;
    double d = 2.718;
    char *s = "Hello, C11!";
    
    PRINT_GENERIC(i);
    PRINT_GENERIC(f);
    PRINT_GENERIC(d);
    PRINT_GENERIC(s);
    
    // Alignment
    printf("Alignment of aligned_struct: %zu\n", alignof(struct aligned_struct));
    printf("Size of aligned_struct: %zu\n", sizeof(struct aligned_struct));
    
    // Atomic operations with threads
    thrd_t thread1, thread2;
    
    thrd_create(&thread1, increment_counter, NULL);
    thrd_create(&thread2, increment_counter, NULL);
    
    thrd_join(thread1, NULL);
    thrd_join(thread2, NULL);
    
    printf("Final counter value: %d\n", atomic_load(&global_counter));
    
    // Static assertion (compile-time check)
    int arr[ARRAY_SIZE];
    printf("Array of size %d created successfully\n", ARRAY_SIZE);
    
    return 0;
}
```

## Module 10: Data Structures

### Exercise 10.1: Linked List Implementation
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* next;
} Node;

// Function to create new node
Node* create_node(int data) {
    Node* new_node = (Node*)malloc(sizeof(Node));
    if (new_node == NULL) {
        printf("Memory allocation failed\n");
        return NULL;
    }
    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}

// Function to insert at beginning
void insert_at_beginning(Node** head, int data) {
    Node* new_node = create_node(data);
    if (new_node == NULL) return;
    
    new_node->next = *head;
    *head = new_node;
}

// Function to insert at end
void insert_at_end(Node** head, int data) {
    Node* new_node = create_node(data);
    if (new_node == NULL) return;
    
    if (*head == NULL) {
        *head = new_node;
        return;
    }
    
    Node* current = *head;
    while (current->next != NULL) {
        current = current->next;
    }
    current->next = new_node;
}

// Function to delete node
void delete_node(Node** head, int key) {
    if (*head == NULL) return;
    
    // If head node holds the key
    if ((*head)->data == key) {
        Node* temp = *head;
        *head = (*head)->next;
        free(temp);
        return;
    }
    
    // Search for the key to be deleted
    Node* current = *head;
    while (current->next != NULL && current->next->data != key) {
        current = current->next;
    }
    
    // If key was not present
    if (current->next == NULL) return;
    
    // Remove the node
    Node* temp = current->next;
    current->next = current->next->next;
    free(temp);
}

// Function to search for a node
Node* search_node(Node* head, int key) {
    Node* current = head;
    while (current != NULL) {
        if (current->data == key) {
            return current;
        }
        current = current->next;
    }
    return NULL;
}

// Function to display the list
void display_list(Node* head) {
    if (head == NULL) {
        printf("List is empty\n");
        return;
    }
    
    printf("List: ");
    Node* current = head;
    while (current != NULL) {
        printf("%d", current->data);
        if (current->next != NULL) printf(" -> ");
        current = current->next;
    }
    printf(" -> NULL\n");
}

// Function to free the entire list
void free_list(Node* head) {
    Node* current = head;
    while (current != NULL) {
        Node* next = current->next;
        free(current);
        current = next;
    }
}

int main() {
    Node* head = NULL;
    int choice, data;
    
    while (1) {
        printf("\nLinked List Operations:\n");
        printf("1. Insert at beginning\n");
        printf("2. Insert at end\n");
        printf("3. Delete node\n");
        printf("4. Search node\n");
        printf("5. Display list\n");
        printf("6. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter data: ");
                scanf("%d", &data);
                insert_at_beginning(&head, data);
                break;
                
            case 2:
                printf("Enter data: ");
                scanf("%d", &data);
                insert_at_end(&head, data);
                break;
                
            case 3:
                printf("Enter data to delete: ");
                scanf("%d", &data);
                delete_node(&head, data);
                break;
                
            case 4:
                printf("Enter data to search: ");
                scanf("%d", &data);
                Node* found = search_node(head, data);
                if (found != NULL) {
                    printf("Node found with data: %d\n", found->data);
                } else {
                    printf("Node not found\n");
                }
                break;
                
            case 5:
                display_list(head);
                break;
                
            case 6:
                free_list(head);
                printf("Exiting program\n");
                return 0;
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

### Exercise 10.2: Binary Search Tree Implementation
```c
#include <stdio.h>
#include <stdlib.h>

typedef struct TreeNode {
    int data;
    struct TreeNode* left;
    struct TreeNode* right;
} TreeNode;

// Function to create new node
TreeNode* create_node(int data) {
    TreeNode* new_node = (TreeNode*)malloc(sizeof(TreeNode));
    if (new_node == NULL) {
        printf("Memory allocation failed\n");
        return NULL;
    }
    new_node->data = data;
    new_node->left = NULL;
    new_node->right = NULL;
    return new_node;
}

// Function to insert node
TreeNode* insert_node(TreeNode* root, int data) {
    if (root == NULL) {
        return create_node(data);
    }
    
    if (data < root->data) {
        root->left = insert_node(root->left, data);
    } else if (data > root->data) {
        root->right = insert_node(root->right, data);
    }
    // If data is equal, we don't insert (no duplicates)
    
    return root;
}

// Function for inorder traversal
void inorder_traversal(TreeNode* root) {
    if (root != NULL) {
        inorder_traversal(root->left);
        printf("%d ", root->data);
        inorder_traversal(root->right);
    }
}

// Function for preorder traversal
void preorder_traversal(TreeNode* root) {
    if (root != NULL) {
        printf("%d ", root->data);
        preorder_traversal(root->left);
        preorder_traversal(root->right);
    }
}

// Function for postorder traversal
void postorder_traversal(TreeNode* root) {
    if (root != NULL) {
        postorder_traversal(root->left);
        postorder_traversal(root->right);
        printf("%d ", root->data);
    }
}

// Function to search for a node
TreeNode* search_node(TreeNode* root, int data) {
    if (root == NULL || root->data == data) {
        return root;
    }
    
    if (data < root->data) {
        return search_node(root->left, data);
    } else {
        return search_node(root->right, data);
    }
}

// Function to find minimum value node
TreeNode* find_min(TreeNode* root) {
    while (root && root->left != NULL) {
        root = root->left;
    }
    return root;
}

// Function to delete node
TreeNode* delete_node(TreeNode* root, int data) {
    if (root == NULL) return root;
    
    if (data < root->data) {
        root->left = delete_node(root->left, data);
    } else if (data > root->data) {
        root->right = delete_node(root->right, data);
    } else {
        // Node to be deleted found
        if (root->left == NULL) {
            TreeNode* temp = root->right;
            free(root);
            return temp;
        } else if (root->right == NULL) {
            TreeNode* temp = root->left;
            free(root);
            return temp;
        }
        
        // Node with two children
        TreeNode* temp = find_min(root->right);
        root->data = temp->data;
        root->right = delete_node(root->right, temp->data);
    }
    return root;
}

// Function to free the entire tree
void free_tree(TreeNode* root) {
    if (root != NULL) {
        free_tree(root->left);
        free_tree(root->right);
        free(root);
    }
}

int main() {
    TreeNode* root = NULL;
    int choice, data;
    
    while (1) {
        printf("\nBinary Search Tree Operations:\n");
        printf("1. Insert node\n");
        printf("2. Delete node\n");
        printf("3. Search node\n");
        printf("4. Inorder traversal\n");
        printf("5. Preorder traversal\n");
        printf("6. Postorder traversal\n");
        printf("7. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        switch (choice) {
            case 1:
                printf("Enter data: ");
                scanf("%d", &data);
                root = insert_node(root, data);
                break;
                
            case 2:
                printf("Enter data to delete: ");
                scanf("%d", &data);
                root = delete_node(root, data);
                break;
                
            case 3:
                printf("Enter data to search: ");
                scanf("%d", &data);
                TreeNode* found = search_node(root, data);
                if (found != NULL) {
                    printf("Node found with data: %d\n", found->data);
                } else {
                    printf("Node not found\n");
                }
                break;
                
            case 4:
                printf("Inorder traversal: ");
                inorder_traversal(root);
                printf("\n");
                break;
                
            case 5:
                printf("Preorder traversal: ");
                preorder_traversal(root);
                printf("\n");
                break;
                
            case 6:
                printf("Postorder traversal: ");
                postorder_traversal(root);
                printf("\n");
                break;
                
            case 7:
                free_tree(root);
                printf("Exiting program\n");
                return 0;
                
            default:
                printf("Invalid choice\n");
        }
    }
    
    return 0;
}
```

## Module 11: Network Programming

### Exercise 11.1: Simple TCP Client-Server
```c
// Server code (server.c)
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main_server() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};
    
    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                   &opt, sizeof(opt))) {
        perror("setsockopt failed");
        exit(EXIT_FAILURE);
    }
    
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for connections
    if (listen(server_fd, 3) < 0) {
        perror("listen failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d\n", PORT);
    
    // Accept connection
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                           (socklen_t*)&addrlen)) < 0) {
        perror("accept failed");
        exit(EXIT_FAILURE);
    }
    
    // Receive message
    int valread = read(new_socket, buffer, BUFFER_SIZE);
    printf("Client: %s\n", buffer);
    
    // Send response
    const char *response = "Hello from server";
    send(new_socket, response, strlen(response), 0);
    printf("Response sent\n");
    
    close(new_socket);
    close(server_fd);
    return 0;
}

// Client code (client.c)
int main_client() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char *hello = "Hello from client";
    char buffer[1024] = {0};
    
    // Create socket
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("Socket creation error\n");
        return -1;
    }
    
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    
    // Convert IPv4 address from text to binary
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("Invalid address/ Address not supported\n");
        return -1;
    }
    
    // Connect to server
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("Connection Failed\n");
        return -1;
    }
    
    // Send message
    send(sock, hello, strlen(hello), 0);
    printf("Hello message sent\n");
    
    // Receive response
    int valread = read(sock, buffer, 1024);
    printf("Server: %s\n", buffer);
    
    close(sock);
    return 0;
}

int main() {
    int choice;
    printf("1. Run as server\n");
    printf("2. Run as client\n");
    printf("Enter choice: ");
    scanf("%d", &choice);
    
    if (choice == 1) {
        return main_server();
    } else if (choice == 2) {
        return main_client();
    } else {
        printf("Invalid choice\n");
        return 1;
    }
}
```

### Exercise 11.2: HTTP Client
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

int http_get_request(const char *hostname, const char *path) {
    int sock;
    struct hostent *server;
    struct sockaddr_in serv_addr;
    char request[1024];
    char response[4096];
    
    // Create socket
    sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock < 0) {
        perror("socket creation failed");
        return 1;
    }
    
    // Get server IP address
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr, "Error, no such host\n");
        close(sock);
        return 1;
    }
    
    // Set up server address
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    memcpy(server->h_addr, &serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(80);
    
    // Connect to server
    if (connect(sock, (struct sockaddr*)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("connection failed");
        close(sock);
        return 1;
    }
    
    // Create HTTP GET request
    snprintf(request, sizeof(request),
             "GET %s HTTP/1.1\r\n"
             "Host: %s\r\n"
             "Connection: close\r\n\r\n",
             path, hostname);
    
    // Send request
    if (send(sock, request, strlen(request), 0) < 0) {
        perror("send failed");
        close(sock);
        return 1;
    }
    
    // Receive response
    int bytes_received;
    while ((bytes_received = recv(sock, response, sizeof(response) - 1, 0)) > 0) {
        response[bytes_received] = '\0';
        printf("%s", response);
    }
    
    close(sock);
    return 0;
}

int main() {
    char hostname[256];
    char path[256];
    
    printf("Enter hostname (e.g., httpbin.org): ");
    scanf("%s", hostname);
    
    printf("Enter path (e.g., /get): ");
    scanf("%s", path);
    
    return http_get_request(hostname, path);
}
```

## Module 12: Embedded Systems Programming

### Exercise 12.1: Bit Manipulation Library
```c
#include <stdio.h>
#include <stdint.h>

// Bit manipulation macros
#define SET_BIT(reg, bit)       ((reg) |= (1U << (bit)))
#define CLEAR_BIT(reg, bit)     ((reg) &= ~(1U << (bit)))
#define TOGGLE_BIT(reg, bit)    ((reg) ^= (1U << (bit)))
#define CHECK_BIT(reg, bit)     (((reg) >> (bit)) & 1U)

// Bit field structure for hardware register
typedef struct {
    uint32_t enable    : 1;  // Bit 0
    uint32_t direction : 1;  // Bit 1
    uint32_t reserved  : 2;  // Bits 2-3
    uint32_t mode      : 4;  // Bits 4-7
    uint32_t config    : 24; // Bits 8-31
} gpio_register_t;

// Function implementations
void set_bit(uint32_t *reg, int bit) {
    *reg |= (1U << bit);
}

void clear_bit(uint32_t *reg, int bit) {
    *reg &= ~(1U << bit);
}

void toggle_bit(uint32_t *reg, int bit) {
    *reg ^= (1U << bit);
}

int check_bit(uint32_t reg, int bit) {
    return (reg >> bit) & 1U;
}

int main() {
    uint32_t test_reg = 0;
    
    printf("Initial register value: 0x%08X\n", test_reg);
    
    // Test bit manipulation functions
    set_bit(&test_reg, 5);
    printf("After setting bit 5: 0x%08X\n", test_reg);
    
    toggle_bit(&test_reg, 5);
    printf("After toggling bit 5: 0x%08X\n", test_reg);
    
    clear_bit(&test_reg, 5);
    printf("After clearing bit 5: 0x%08X\n", test_reg);
    
    // Test bit manipulation macros
    SET_BIT(test_reg, 3);
    printf("After setting bit 3 with macro: 0x%08X\n", test_reg);
    
    if (CHECK_BIT(test_reg, 3)) {
        printf("Bit 3 is set\n");
    }
    
    // Test bit field structure
    gpio_register_t gpio_reg = {0};
    gpio_reg.enable = 1;
    gpio_reg.direction = 1;
    gpio_reg.mode = 0xF;
    
    printf("GPIO Register - Enable: %d, Direction: %d, Mode: 0x%X\n",
           gpio_reg.enable, gpio_reg.direction, gpio_reg.mode);
    
    return 0;
}
```

### Exercise 12.2: Memory-Mapped I/O Simulation
```c
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>
#include <string.h>

// Memory-mapped I/O simulation
#define GPIO_BASE_ADDR 0x40020000
#define GPIO_DIR_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x00))
#define GPIO_DATA_REG  (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x04))
#define GPIO_SET_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x08))
#define GPIO_CLR_REG   (*(volatile uint32_t *)(GPIO_BASE_ADDR + 0x0C))

// GPIO pin definitions
#define GPIO_PIN_0  (1U << 0)
#define GPIO_PIN_1  (1U << 1)
#define GPIO_PIN_2  (1U << 2)
#define GPIO_PIN_3  (1U << 3)

// Simple GPIO simulation structure
typedef struct {
    uint32_t direction;  // 0 = input, 1 = output
    uint32_t data;       // Current pin states
} gpio_sim_t;

// Global GPIO simulation instance
static gpio_sim_t gpio_sim = {0};

// Function to initialize GPIO
void gpio_init(void) {
    gpio_sim.direction = 0;
    gpio_sim.data = 0;
    printf("GPIO initialized\n");
}

// Function to set GPIO direction
void gpio_set_direction(uint32_t pins, int direction) {
    if (direction) {
        gpio_sim.direction |= pins;  // Set as output
    } else {
        gpio_sim.direction &= ~pins; // Set as input
    }
    
    // Update hardware register
    GPIO_DIR_REG = gpio_sim.direction;
    printf("GPIO direction set: 0x%08X (pins: 0x%08X, direction: %s)\n",
           gpio_sim.direction, pins, direction ? "output" : "input");
}

// Function to write to GPIO pins
void gpio_write(uint32_t pins, int value) {
    if (value) {
        gpio_sim.data |= pins;
        GPIO_SET_REG = pins;  // Hardware register for setting pins
    } else {
        gpio_sim.data &= ~pins;
        GPIO_CLR_REG = pins;  // Hardware register for clearing pins
    }
    
    GPIO_DATA_REG = gpio_sim.data;  // Update data register
    printf("GPIO write: pins 0x%08X set to %d\n", pins, value);
}

// Function to read from GPIO pins
uint32_t gpio_read(uint32_t pins) {
    uint32_t value = GPIO_DATA_REG & pins;  // Read from hardware register
    printf("GPIO read: pins 0x%08X = 0x%08X\n", pins, value);
    return value;
}

// Function to simulate external input change
void gpio_simulate_input(uint32_t pins, int value) {
    if (value) {
        gpio_sim.data |= pins;
    } else {
        gpio_sim.data &= ~pins;
    }
    printf("Simulated input change: pins 0x%08X set to %d\n", pins, value);
}

int main() {
    // Initialize GPIO
    gpio_init();
    
    // Configure pins 0-1 as outputs, pins 2-3 as inputs
    gpio_set_direction(GPIO_PIN_0 | GPIO_PIN_1, 1);  // Output
    gpio_set_direction(GPIO_PIN_2 | GPIO_PIN_3, 0);  // Input
    
    // Write to output pins
    gpio_write(GPIO_PIN_0, 1);
    gpio_write(GPIO_PIN_1, 0);
    
    // Simulate input changes
    gpio_simulate_input(GPIO_PIN_2, 1);
    gpio_simulate_input(GPIO_PIN_3, 0);
    
    // Read input pins
    uint32_t input_value = gpio_read(GPIO_PIN_2 | GPIO_PIN_3);
    printf("Input pins value: 0x%08X\n", input_value);
    
    return 0;
}
```

## Module 13: Performance Optimization

### Exercise 13.1: Algorithm Complexity Analysis
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

// Timing function
double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

// O(n²) bubble sort
void bubble_sort(int arr[], int n) {
    for (int i = 0; i < n - 1; i++) {
        for (int j = 0; j < n - i - 1; j++) {
            if (arr[j] > arr[j + 1]) {
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }
}

// O(n log n) quick sort
void quick_sort(int arr[], int low, int high) {
    if (low < high) {
        int pi = partition(arr, low, high);
        quick_sort(arr, low, pi - 1);
        quick_sort(arr, pi + 1, high);
    }
}

int partition(int arr[], int low, int high) {
    int pivot = arr[high];
    int i = (low - 1);
    
    for (int j = low; j <= high - 1; j++) {
        if (arr[j] < pivot) {
            i++;
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
        }
    }
    int temp = arr[i + 1];
    arr[i + 1] = arr[high];
    arr[high] = temp;
    return (i + 1);
}

// O(n) linear search
int linear_search(int arr[], int n, int key) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == key) {
            return i;
        }
    }
    return -1;
}

// O(log n) binary search
int binary_search(int arr[], int low, int high, int key) {
    if (high >= low) {
        int mid = low + (high - low) / 2;
        if (arr[mid] == key) {
            return mid;
        }
        if (arr[mid] > key) {
            return binary_search(arr, low, mid - 1, key);
        }
        return binary_search(arr, mid + 1, high, key);
    }
    return -1;
}

// Performance testing function
void test_algorithms() {
    const int sizes[] = {1000, 5000, 10000, 20000};
    const int num_sizes = sizeof(sizes) / sizeof(sizes[0]);
    
    for (int s = 0; s < num_sizes; s++) {
        int n = sizes[s];
        int *arr1 = malloc(n * sizeof(int));
        int *arr2 = malloc(n * sizeof(int));
        
        // Fill arrays with random data
        for (int i = 0; i < n; i++) {
            arr1[i] = rand() % 10000;
            arr2[i] = arr1[i];
        }
        
        struct timespec start, end;
        
        // Test bubble sort
        clock_gettime(CLOCK_MONOTONIC, &start);
        bubble_sort(arr1, n);
        clock_gettime(CLOCK_MONOTONIC, &end);
        double bubble_time = get_time_diff(start, end);
        
        // Test quick sort
        clock_gettime(CLOCK_MONOTONIC, &start);
        quick_sort(arr2, 0, n - 1);
        clock_gettime(CLOCK_MONOTONIC, &end);
        double quick_time = get_time_diff(start, end);
        
        printf("Array size: %d\n", n);
        printf("Bubble sort time: %.6f seconds\n", bubble_time);
        printf("Quick sort time: %.6f seconds\n", quick_time);
        printf("Speedup: %.2fx\n\n", bubble_time / quick_time);
        
        free(arr1);
        free(arr2);
    }
}

int main() {
    srand(time(NULL));
    test_algorithms();
    return 0;
}
```

### Exercise 13.2: Memory Access Patterns
```c
#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>

#define MATRIX_SIZE 1000
#define CACHE_LINE_SIZE 64

// Matrix structure with proper alignment
typedef struct {
    int rows;
    int cols;
    int *data;
} matrix_t;

// Create matrix with specified alignment
matrix_t* create_matrix(int rows, int cols) {
    matrix_t *mat = malloc(sizeof(matrix_t));
    mat->rows = rows;
    mat->cols = cols;
    // Allocate aligned memory for better cache performance
    posix_memalign((void**)&mat->data, CACHE_LINE_SIZE, rows * cols * sizeof(int));
    return mat;
}

void free_matrix(matrix_t *mat) {
    free(mat->data);
    free(mat);
}

// Initialize matrix with random values
void init_matrix(matrix_t *mat) {
    for (int i = 0; i < mat->rows * mat->cols; i++) {
        mat->data[i] = rand() % 100;
    }
}

// Matrix multiplication - ijk order (poor cache performance)
void matrix_multiply_ijk(matrix_t *a, matrix_t *b, matrix_t *c) {
    for (int i = 0; i < a->rows; i++) {
        for (int j = 0; j < b->cols; j++) {
            c->data[i * c->cols + j] = 0;
            for (int k = 0; k < a->cols; k++) {
                c->data[i * c->cols + j] += 
                    a->data[i * a->cols + k] * b->data[k * b->cols + j];
            }
        }
    }
}

// Matrix multiplication - ikj order (better cache performance)
void matrix_multiply_ikj(matrix_t *a, matrix_t *b, matrix_t *c) {
    // Initialize result matrix
    memset(c->data, 0, c->rows * c->cols * sizeof(int));
    
    for (int i = 0; i < a->rows; i++) {
        for (int k = 0; k < a->cols; k++) {
            int temp = a->data[i * a->cols + k];
            for (int j = 0; j < b->cols; j++) {
                c->data[i * c->cols + j] += temp * b->data[k * b->cols + j];
            }
        }
    }
}

// Performance comparison
void compare_matrix_multiplication() {
    matrix_t *a = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *b = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *c1 = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    matrix_t *c2 = create_matrix(MATRIX_SIZE, MATRIX_SIZE);
    
    init_matrix(a);
    init_matrix(b);
    
    struct timespec start, end;
    
    // Test ijk order
    clock_gettime(CLOCK_MONOTONIC, &start);
    matrix_multiply_ijk(a, b, c1);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time_ijk = get_time_diff(start, end);
    
    // Test ikj order
    clock_gettime(CLOCK_MONOTONIC, &start);
    matrix_multiply_ikj(a, b, c2);
    clock_gettime(CLOCK_MONOTONIC, &end);
    double time_ikj = get_time_diff(start, end);
    
    printf("Matrix multiplication performance comparison:\n");
    printf("Matrix size: %dx%d\n", MATRIX_SIZE, MATRIX_SIZE);
    printf("ijk order time: %.6f seconds\n", time_ijk);
    printf("ikj order time: %.6f seconds\n", time_ikj);
    printf("Performance improvement: %.2fx\n", time_ijk / time_ikj);
    
    // Verify results are the same
    int diff_count = 0;
    for (int i = 0; i < c1->rows * c1->cols; i++) {
        if (c1->data[i] != c2->data[i]) {
            diff_count++;
        }
    }
    printf("Results match: %s\n", diff_count == 0 ? "Yes" : "No");
    
    free_matrix(a);
    free_matrix(b);
    free_matrix(c1);
    free_matrix(c2);
}

double get_time_diff(struct timespec start, struct timespec end) {
    return (end.tv_sec - start.tv_sec) + (end.tv_nsec - start.tv_nsec) / 1e9;
}

int main() {
    srand(time(NULL));
    compare_matrix_multiplication();
    return 0;
}
```

## Module 14: Testing and Quality Assurance

### Exercise 14.1: Unit Testing Framework
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

// Simple unit testing framework

// Test result structure
typedef struct {
    int passed;
    int failed;
    int skipped;
    double total_time;
} test_result_t;

// Global test result tracker
static test_result_t g_test_result = {0};

// Assertion functions
#define ASSERT_TRUE(condition) \
    do { \
        if (!(condition)) { \
            printf("ASSERT_TRUE failed at %s:%d\n", __FILE__, __LINE__); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_FALSE(condition) \
    do { \
        if (condition) { \
            printf("ASSERT_FALSE failed at %s:%d\n", __FILE__, __LINE__); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_EQUAL(expected, actual) \
    do { \
        if ((expected) != (actual)) { \
            printf("ASSERT_EQUAL failed at %s:%d: expected %d, got %d\n", \
                   __FILE__, __LINE__, (expected), (actual)); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

#define ASSERT_STRING_EQUAL(expected, actual) \
    do { \
        if (strcmp((expected), (actual)) != 0) { \
            printf("ASSERT_STRING_EQUAL failed at %s:%d: expected '%s', got '%s'\n", \
                   __FILE__, __LINE__, (expected), (actual)); \
            g_test_result.failed++; \
            return; \
        } \
        g_test_result.passed++; \
    } while(0)

// Test function type
typedef void (*test_func_t)(void);

// Test case structure
typedef struct {
    const char *name;
    test_func_t function;
} test_case_t;

// Example functions to test
int add(int a, int b) {
    return a + b;
}

int subtract(int a, int b) {
    return a - b;
}

const char* get_hello_message(void) {
    return "Hello, World!";
}

// Test cases
void test_add_positive(void) {
    ASSERT_EQUAL(5, add(2, 3));
}

void test_add_negative(void) {
    ASSERT_EQUAL(-1, add(2, -3));
}

void test_subtract(void) {
    ASSERT_EQUAL(2, subtract(5, 3));
}

void test_string_message(void) {
    ASSERT_STRING_EQUAL("Hello, World!", get_hello_message());
}

// Test suite
test_case_t test_suite[] = {
    {"test_add_positive", test_add_positive},
    {"test_add_negative", test_add_negative},
    {"test_subtract", test_subtract},
    {"test_string_message", test_string_message},
    {NULL, NULL}  // Sentinel
};

// Test runner
void run_tests(void) {
    printf("Running tests...\n");
    
    struct timespec start, end;
    clock_gettime(CLOCK_MONOTONIC, &start);
    
    for (int i = 0; test_suite[i].name != NULL; i++) {
        printf("Running %s... ", test_suite[i].name);
        
        // Reset test counters for each test
        int initial_passed = g_test_result.passed;
        int initial_failed = g_test_result.failed;
        
        test_suite[i].function();
        
        if (g_test_result.failed > initial_failed) {
            printf("FAILED\n");
        } else {
            printf("PASSED\n");
        }
    }
    
    clock_gettime(CLOCK_MONOTONIC, &end);
    g_test_result.total_time = (end.tv_sec - start.tv_sec) + 
                              (end.tv_nsec - start.tv_nsec) / 1e9;
    
    // Print summary
    printf("\nTest Results:\n");
    printf("Passed: %d\n", g_test_result.passed);
    printf("Failed: %d\n", g_test_result.failed);
    printf("Skipped: %d\n", g_test_result.skipped);
    printf("Total time: %.6f seconds\n", g_test_result.total_time);
    
    if (g_test_result.failed == 0) {
        printf("All tests passed!\n");
    } else {
        printf("Some tests failed!\n");
    }
}

int main() {
    run_tests();
    return g_test_result.failed > 0 ? 1 : 0;
}
```

### Exercise 14.2: Mocking Framework
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Mocking framework example

// Real database interface
typedef struct {
    int (*connect)(const char *host, int port);
    int (*query)(const char *sql, char **result);
    void (*disconnect)(void);
} database_interface_t;

// Real database implementation
static int real_db_connect(const char *host, int port) {
    printf("Connecting to database at %s:%d\n", host, port);
    return 1; // Success
}

static int real_db_query(const char *sql, char **result) {
    printf("Executing query: %s\n", sql);
    *result = strdup("Mock query result");
    return 1; // Success
}

static void real_db_disconnect(void) {
    printf("Disconnecting from database\n");
}

database_interface_t real_database = {
    .connect = real_db_connect,
    .query = real_db_query,
    .disconnect = real_db_disconnect
};

// Mock database implementation
static int mock_connect_calls = 0;
static int mock_query_calls = 0;
static int mock_disconnect_calls = 0;
static int mock_connect_result = 1;
static int mock_query_result = 1;

static int mock_db_connect(const char *host, int port) {
    mock_connect_calls++;
    printf("Mock connect called (%d times)\n", mock_connect_calls);
    return mock_connect_result;
}

static int mock_db_query(const char *sql, char **result) {
    mock_query_calls++;
    printf("Mock query called (%d times): %s\n", mock_query_calls, sql);
    *result = strdup("Mock result");
    return mock_query_result;
}

static void mock_db_disconnect(void) {
    mock_disconnect_calls++;
    printf("Mock disconnect called (%d times)\n", mock_disconnect_calls);
}

database_interface_t mock_database = {
    .connect = mock_db_connect,
    .query = mock_db_query,
    .disconnect = mock_db_disconnect
};

// Function under test
int fetch_user_data(database_interface_t *db, const char *user_id, char **data) {
    if (!db->connect("localhost", 5432)) {
        return 0;
    }
    
    char sql[256];
    snprintf(sql, sizeof(sql), "SELECT * FROM users WHERE id = '%s'", user_id);
    
    int result = db->query(sql, data);
    db->disconnect();
    
    return result;
}

// Test with mock
void test_fetch_user_data_success(void) {
    // Reset mock counters
    mock_connect_calls = 0;
    mock_query_calls = 0;
    mock_disconnect_calls = 0;
    mock_connect_result = 1;
    mock_query_result = 1;
    
    char *data = NULL;
    int result = fetch_user_data(&mock_database, "123", &data);
    
    // Verify results
    if (result != 1) {
        printf("Test failed: Expected success, got failure\n");
        return;
    }
    
    if (mock_connect_calls != 1) {
        printf("Test failed: Expected 1 connect call, got %d\n", mock_connect_calls);
        return;
    }
    
    if (mock_query_calls != 1) {
        printf("Test failed: Expected 1 query call, got %d\n", mock_query_calls);
        return;
    }
    
    if (mock_disconnect_calls != 1) {
        printf("Test failed: Expected 1 disconnect call, got %d\n", mock_disconnect_calls);
        return;
    }
    
    printf("Test passed: All mock interactions verified\n");
    free(data);
}

void test_fetch_user_data_connection_failure(void) {
    // Reset mock counters
    mock_connect_calls = 0;
    mock_query_calls = 0;
    mock_disconnect_calls = 0;
    mock_connect_result = 0; // Simulate connection failure
    
    char *data = NULL;
    int result = fetch_user_data(&mock_database, "123", &data);
    
    // Verify results
    if (result != 0) {
        printf("Test failed: Expected failure, got success\n");
        return;
    }
    
    if (mock_connect_calls != 1) {
        printf("Test failed: Expected 1 connect call, got %d\n", mock_connect_calls);
        return;
    }
    
    // Should not call query or disconnect on connection failure
    if (mock_query_calls != 0) {
        printf("Test failed: Expected 0 query calls, got %d\n", mock_query_calls);
        return;
    }
    
    if (mock_disconnect_calls != 0) {
        printf("Test failed: Expected 0 disconnect calls, got %d\n", mock_disconnect_calls);
        return;
    }
    
    printf("Test passed: Connection failure handled correctly\n");
}

int main() {
    printf("Testing with mock database...\n");
    test_fetch_user_data_success();
    test_fetch_user_data_connection_failure();
    
    printf("\nFor comparison, running with real database:\n");
    char *data = NULL;
    fetch_user_data(&real_database, "123", &data);
    free(data);
    
    return 0;
}
```

## Module 15: Advanced Topics

### Exercise 15.1: Multithreading Example
```c
#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <unistd.h>

// Thread function
void* thread_function(void* arg) {
    int thread_id = *(int*)arg;
    printf("Hello from thread %d\n", thread_id);
    
    // Simulate some work
    sleep(1);
    
    printf("Thread %d finishing\n", thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // Create threads
    if (pthread_create(&thread1, NULL, thread_function, &id1) != 0) {
        perror("pthread_create failed");
        exit(EXIT_FAILURE);
    }
    
    if (pthread_create(&thread2, NULL, thread_function, &id2) != 0) {
        perror("pthread_create failed");
        exit(EXIT_FAILURE);
    }
    
    // Wait for threads to complete
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("All threads completed\n");
    return 0;
}
```

### Exercise 15.2: System Programming Example
```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main() {
    pid_t pid = fork();
    
    if (pid == -1) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    } else if (pid == 0) {
        // Child process
        printf("Child process (PID: %d)\n", getpid());
        exit(EXIT_SUCCESS);
    } else {
        // Parent process
        printf("Parent process (PID: %d), Child PID: %d\n", getpid(), pid);
        wait(NULL);  // Wait for child to complete
        printf("Child process completed\n");
    }
    
    return 0;
}
```

This appendix provides solutions to selected exercises from each module of the course. These solutions demonstrate good programming practices and illustrate the concepts covered in each module. Remember that there are often multiple ways to solve a problem, and these solutions are meant to serve as examples rather than the only correct approach.