# Basic Input and Output

## Introduction

Input and output (I/O) operations are fundamental to almost every program. In this chapter, we'll explore the basic I/O functions provided by the C standard library, focusing on console input and output using the `stdio.h` library.

## The stdio.h Library

The `stdio.h` (standard input/output) header file provides functions for performing input and output operations. It's one of the most commonly used libraries in C programming.

To use any stdio functions, you must include the header at the beginning of your program:
```c
#include <stdio.h>
```

## Output with printf()

The `printf()` function is used to display formatted output to the console.

### Basic Syntax
```c
int printf(const char *format, ...);
```

### Simple Output
```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

### Format Specifiers

Format specifiers allow you to insert variables into your output strings:

| Specifier | Data Type | Description |
|-----------|-----------|-------------|
| `%d` or `%i` | int | Signed decimal integer |
| `%u` | unsigned int | Unsigned decimal integer |
| `%f` | float/double | Floating-point number |
| `%c` | char | Single character |
| `%s` | char* | String |
| `%x` | int | Hexadecimal integer |
| `%o` | int | Octal integer |
| `%p` | void* | Pointer address |
| `%%` | - | Literal percent sign |

### Examples with Different Data Types
```c
#include <stdio.h>

int main() {
    int age = 25;
    float height = 5.9f;
    char initial = 'J';
    char name[] = "John";
    
    printf("Name: %s\n", name);
    printf("Age: %d years\n", age);
    printf("Height: %.1f feet\n", height);
    printf("Initial: %c\n", initial);
    
    return 0;
}
```

### Formatting Options

#### Width Specifiers
```c
printf("%10d\n", 42);     // Right-aligned in 10 characters
printf("%-10d\n", 42);    // Left-aligned in 10 characters
```

#### Precision Specifiers
```c
printf("%.2f\n", 3.14159);  // 2 decimal places
printf("%.5s\n", "Hello World");  // First 5 characters of string
```

#### Zero Padding
```c
printf("%05d\n", 42);     // Zero-padded to 5 digits: 00042
```

## Input with scanf()

The `scanf()` function reads formatted input from the standard input (keyboard).

### Basic Syntax
```c
int scanf(const char *format, ...);
```

### Reading Different Data Types
```c
#include <stdio.h>

int main() {
    int age;
    float height;
    char initial;
    char name[50];
    
    printf("Enter your age: ");
    scanf("%d", &age);
    
    printf("Enter your height: ");
    scanf("%f", &height);
    
    printf("Enter your initial: ");
    scanf(" %c", &initial);  // Note the space before %c
    
    printf("Enter your name: ");
    scanf("%49s", name);     // Limit to 49 characters to prevent buffer overflow
    
    printf("\n--- Your Information ---\n");
    printf("Name: %s\n", name);
    printf("Age: %d\n", age);
    printf("Height: %.1f\n", height);
    printf("Initial: %c\n", initial);
    
    return 0;
}
```

### Important scanf Considerations

#### Address Operator (&)
When reading variables with `scanf()`, you must use the address operator `&`:
```c
int number;
scanf("%d", &number);  // Correct
// scanf("%d", number);  // Incorrect!
```

#### Whitespace Handling
`scanf()` skips whitespace characters (spaces, tabs, newlines) when reading numbers, but not when reading characters:
```c
int a, b;
char c;

scanf("%d", &a);   // Reads integer, leaves newline in buffer
scanf("%c", &c);   // Reads the leftover newline!
scanf("%d", &b);   // Waits for next input
```

To fix this, add a space before the format specifier:
```c
scanf(" %c", &c);  // Space consumes any whitespace
```

#### Buffer Overflow Prevention
Always limit string input length:
```c
char name[20];
scanf("%19s", name);  // Prevents buffer overflow
```

## Character I/O Functions

For single character input and output, C provides specialized functions.

### putchar() and getchar()

#### putchar()
Outputs a single character:
```c
#include <stdio.h>

int main() {
    putchar('H');
    putchar('i');
    putchar('!');
    putchar('\n');
    return 0;
}
```

#### getchar()
Reads a single character:
```c
#include <stdio.h>

int main() {
    char ch;
    
    printf("Press any key: ");
    ch = getchar();
    
    printf("You pressed: ");
    putchar(ch);
    putchar('\n');
    
    return 0;
}
}
```

### Character I/O in Loops
```c
#include <stdio.h>

int main() {
    char ch;
    
    printf("Enter text (press Ctrl+D to end):\n");
    
    while ((ch = getchar()) != EOF) {
        putchar(ch);
    }
    
    printf("\nEnd of input.\n");
    return 0;
}
```

## Formatted I/O Functions

### sprintf() and sscanf()

#### sprintf()
Writes formatted output to a string:
```c
#include <stdio.h>

int main() {
    char buffer[100];
    int age = 30;
    float salary = 50000.50;
    
    sprintf(buffer, "Age: %d, Salary: $%.2f", age, salary);
    printf("%s\n", buffer);
    
    return 0;
}
```

#### sscanf()
Reads formatted input from a string:
```c
#include <stdio.h>

int main() {
    char input[] = "John 25 75.5";
    char name[20];
    int age;
    float weight;
    
    sscanf(input, "%s %d %f", name, &age, &weight);
    
    printf("Name: %s\n", name);
    printf("Age: %d\n", age);
    printf("Weight: %.1f\n", weight);
    
    return 0;
}
```

## Return Values

All I/O functions return values that indicate success or failure:

### printf() Return Value
Returns the number of characters printed, or a negative value if an error occurred:
```c
int chars_printed = printf("Hello, World!\n");
if (chars_printed < 0) {
    printf("Error occurred during printing\n");
}
```

### scanf() Return Value
Returns the number of items successfully read, or EOF if an error occurred:
```c
int number;
int items_read = scanf("%d", &number);

if (items_read == 1) {
    printf("Successfully read: %d\n", number);
} else if (items_read == EOF) {
    printf("End of input reached\n");
} else {
    printf("Failed to read input\n");
}
```

## Practical Examples

### Simple Calculator
```c
#include <stdio.h>

int main() {
    float num1, num2, result;
    char operator;
    
    printf("Enter first number: ");
    scanf("%f", &num1);
    
    printf("Enter operator (+, -, *, /): ");
    scanf(" %c", &operator);
    
    printf("Enter second number: ");
    scanf("%f", &num2);
    
    switch (operator) {
        case '+':
            result = num1 + num2;
            break;
        case '-':
            result = num1 - num2;
            break;
        case '*':
            result = num1 * num2;
            break;
        case '/':
            if (num2 != 0) {
                result = num1 / num2;
            } else {
                printf("Error: Division by zero!\n");
                return 1;
            }
            break;
        default:
            printf("Error: Invalid operator!\n");
            return 1;
    }
    
    printf("%.2f %c %.2f = %.2f\n", num1, operator, num2, result);
    return 0;
}
```

### Interactive User Information
```c
#include <stdio.h>

int main() {
    char name[50];
    int age;
    float height;
    
    printf("=== User Information Form ===\n\n");
    
    printf("Enter your full name: ");
    fgets(name, sizeof(name), stdin);  // Safer than scanf for strings
    
    printf("Enter your age: ");
    scanf("%d", &age);
    
    printf("Enter your height (in meters): ");
    scanf("%f", &height);
    
    printf("\n=== Your Information ===\n");
    printf("Name: %s", name);  // fgets includes newline
    printf("Age: %d years\n", age);
    printf("Height: %.2f meters\n", height);
    
    return 0;
}
```

## Best Practices

### 1. Always Check Return Values
```c
if (scanf("%d", &number) != 1) {
    printf("Invalid input!\n");
    return 1;
}
```

### 2. Prevent Buffer Overflows
```c
char name[20];
scanf("%19s", name);  // Limit input to prevent overflow
```

### 3. Handle Whitespace in Character Input
```c
char ch;
scanf(" %c", &ch);  // Space consumes any whitespace
```

### 4. Use fgets() for String Input
```c
char line[100];
fgets(line, sizeof(line), stdin);  // Safer than gets() or scanf()
```

### 5. Clear Input Buffer When Needed
```c
int c;
while ((c = getchar()) != '\n' && c != EOF);  // Clear input buffer
```

## Summary

In this chapter, you've learned:

1. **printf() Function**: How to display formatted output with various format specifiers
2. **scanf() Function**: How to read formatted input from the user
3. **Character I/O**: Using `getchar()` and `putchar()` for single character operations
4. **Formatted String I/O**: Using `sprintf()` and `sscanf()` for string operations
5. **Error Handling**: Checking return values to ensure I/O operations succeed
6. **Best Practices**: Safe input handling and buffer overflow prevention

These basic I/O operations form the foundation for user interaction in C programs. As you progress through this course, you'll build upon these concepts to create more sophisticated programs with advanced input and output capabilities.

In the next module, we'll explore data types and variables in detail, which will give you the knowledge needed to work with different kinds of data in your I/O operations.