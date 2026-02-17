/*
 * Module 1 Demonstration Program
 * This program demonstrates all the key concepts from Module 1:
 * - Basic program structure
 * - Preprocessor directives
 * - Main function
 * - Basic I/O operations
 * - Comments
 */

#include <stdio.h>

// Function prototype
void print_welcome_message(void);

/*
 * Main function - entry point of the program
 * Returns 0 to indicate successful execution
 */
int main() {
    // Call our custom function
    print_welcome_message();
    
    // Demonstrate different printf format specifiers
    int age = 25;
    float height = 5.9f;
    char initial = 'C';
    char name[] = "Programmer";
    
    printf("=== Personal Information ===\n");
    printf("Name: %s\n", name);
    printf("Age: %d years\n", age);
    printf("Height: %.1f feet\n", height);
    printf("Initial: %c\n", initial);
    printf("Hexadecimal age: %x\n", age);
    printf("Octal age: %o\n", age);
    
    // Demonstrate scanf with proper input handling
    int number;
    char character;
    
    printf("\nEnter a number: ");
    if (scanf("%d", &number) == 1) {
        printf("You entered: %d\n", number);
    } else {
        printf("Invalid input for number!\n");
        // Clear input buffer
        int c;
        while ((c = getchar()) != '\n' && c != EOF);
    }
    
    // Consume the newline left in buffer
    while (getchar() != '\n');
    
    printf("Enter a character: ");
    character = getchar();
    printf("You entered: %c (ASCII: %d)\n", character, character);
    
    // Demonstrate character I/O
    printf("\nCharacter I/O demonstration:\n");
    putchar('H');
    putchar('e');
    putchar('l');
    putchar('l');
    putchar('o');
    putchar('!');
    putchar('\n');
    
    // Demonstrate sprintf
    char buffer[100];
    sprintf(buffer, "Formatted string: %s is %d years old", name, age);
    printf("\n%s\n", buffer);
    
    printf("\nProgram completed successfully!\n");
    return 0;
}

/*
 * Custom function to print a welcome message
 * Demonstrates function definition and void return type
 */
void print_welcome_message(void) {
    printf("=====================================\n");
    printf("  Welcome to C Programming Module 1  \n");
    printf("    Basic Foundations Demo Program   \n");
    printf("=====================================\n\n");
}