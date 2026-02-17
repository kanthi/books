# Module 1: Foundations Exercises

## Exercise 1: Basic Program Structure
Write a C program that prints the following output:
```
**************************
*   My First C Program   *
**************************
```

**Requirements:**
- Use proper program structure with `#include` and `main()` function
- Include comments explaining each part of your code
- Compile and run your program successfully

## Exercise 2: Personal Information Display
Create a program that displays your personal information in a formatted way:
- Name
- Age
- City/Country
- Favorite programming language
- Years of programming experience

**Requirements:**
- Use at least 3 different printf format specifiers
- Use both single-line and multi-line comments
- Make the output visually appealing with proper formatting

## Exercise 3: Simple Calculator Input
Write a program that asks the user for two numbers and then displays:
- The sum
- The difference
- The product
- The quotient (handle division by zero)

**Requirements:**
- Use `scanf()` to get input from the user
- Check the return value of `scanf()` for error handling
- Use proper variable declarations
- Format the output clearly

## Exercise 4: Character Analysis
Create a program that asks the user to enter a character and then displays:
- The character itself
- Its ASCII value
- Whether it's a vowel (a, e, i, o, u)
- Whether it's uppercase or lowercase (if it's a letter)

**Requirements:**
- Use `getchar()` for character input
- Handle whitespace properly
- Use conditional statements (will be covered in detail in Module 3)
- Display results in a formatted manner

## Exercise 5: Temperature Converter
Write a program that converts temperatures between Celsius and Fahrenheit:
- Ask the user for a temperature value
- Ask the user to specify C for Celsius or F for Fahrenheit
- Convert and display the equivalent temperature in the other unit

**Formulas:**
- F = (C × 9/5) + 32
- C = (F - 32) × 5/9

**Requirements:**
- Use proper input validation
- Format output to 2 decimal places
- Handle both uppercase and lowercase input for unit specification
- Include clear prompts and instructions

## Exercise 6: String Formatting Practice
Create a program that demonstrates various printf formatting options:
- Display integers with different width specifications
- Display floating-point numbers with different precision
- Display strings with width and alignment options
- Use escape sequences for formatting

**Requirements:**
- Demonstrate at least 5 different printf format options
- Include examples of left and right alignment
- Use at least 3 different data types
- Comment your code explaining each formatting choice

## Exercise 7: Input Buffer Management
Write a program that demonstrates proper input buffer management:
- Read a string with spaces using `fgets()`
- Read an integer after the string
- Read a character after the integer
- Show how to properly handle the input buffer between different input types

**Requirements:**
- Avoid common scanf pitfalls with buffer management
- Use appropriate buffer sizes to prevent overflow
- Handle input errors gracefully
- Include comments explaining buffer management techniques

## Exercise 8: Comprehensive Demo Program
Create a comprehensive program that integrates all Module 1 concepts:
- Proper program structure with includes and main function
- Multiple function calls (at least 2 custom functions)
- Various printf formatting options
- Multiple scanf inputs with error checking
- Character I/O demonstrations
- Well-commented code with both comment types

**Requirements:**
- At least 50 lines of code
- Use all major concepts from Module 1
- Include a README section in comments explaining your program
- Compile without warnings (use -Wall -Wextra flags)

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>

int main() {
    // Print a decorative header
    printf("**************************\n");
    printf("*   My First C Program   *\n");
    printf("**************************\n");
    return 0;
}
```

### Exercise 3 Solution Example:
```c
#include <stdio.h>

int main() {
    float num1, num2;
    
    printf("Enter first number: ");
    if (scanf("%f", &num1) != 1) {
        printf("Invalid input!\n");
        return 1;
    }
    
    printf("Enter second number: ");
    if (scanf("%f", &num2) != 1) {
        printf("Invalid input!\n");
        return 1;
    }
    
    printf("\nResults:\n");
    printf("%.2f + %.2f = %.2f\n", num1, num2, num1 + num2);
    printf("%.2f - %.2f = %.2f\n", num1, num2, num1 - num2);
    printf("%.2f * %.2f = %.2f\n", num1, num2, num1 * num2);
    
    if (num2 != 0) {
        printf("%.2f / %.2f = %.2f\n", num1, num2, num1 / num2);
    } else {
        printf("Cannot divide by zero!\n");
    }
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Missing `&` in scanf**: Always use `&` for non-string variables
2. **Buffer overflow**: Limit string input lengths
3. **Whitespace issues**: Handle newlines properly with character input
4. **Missing return 0**: Always return 0 from main function
5. **Forgetting headers**: Include `<stdio.h>` for I/O functions

### Compilation Tips:
```bash
# Basic compilation
gcc program.c -o program

# With warnings enabled
gcc -Wall -Wextra program.c -o program

# With debugging information
gcc -g program.c -o program

# With C standard specification
gcc -std=c99 program.c -o program
```

Complete these exercises to solidify your understanding of Module 1 concepts. Each exercise builds upon the previous ones, gradually increasing in complexity.