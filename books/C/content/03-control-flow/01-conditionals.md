# Conditional Statements

## Introduction

Conditional statements are fundamental control structures that allow programs to make decisions and execute different code paths based on specific conditions. They enable programs to respond dynamically to varying inputs, user interactions, and runtime conditions.

In C, conditional statements provide the foundation for implementing logic, validation, error handling, and complex decision-making processes. This chapter will explore the various conditional constructs available in C, their syntax, best practices, and common use cases.

## The if Statement

The `if` statement is the most basic conditional construct in C. It executes a block of code only if a specified condition evaluates to true (non-zero).

### Basic Syntax

```c
if (condition) {
    // Code to execute if condition is true
}
```

### Simple if Statement

```c
#include <stdio.h>

int main() {
    int age = 20;
    
    if (age >= 18) {
        printf("You are eligible to vote.\n");
    }
    
    return 0;
}
```

### if-else Statement

The `if-else` construct allows you to specify alternative code paths for when the condition is true or false:

```c
#include <stdio.h>

int main() {
    int number = 15;
    
    if (number % 2 == 0) {
        printf("%d is even.\n", number);
    } else {
        printf("%d is odd.\n", number);
    }
    
    return 0;
}
```

### if-else if-else Chain

For multiple conditions, you can chain `if-else if-else` statements:

```c
#include <stdio.h>

int main() {
    int score = 85;
    
    if (score >= 90) {
        printf("Grade: A\n");
    } else if (score >= 80) {
        printf("Grade: B\n");
    } else if (score >= 70) {
        printf("Grade: C\n");
    } else if (score >= 60) {
        printf("Grade: D\n");
    } else {
        printf("Grade: F\n");
    }
    
    return 0;
}
```

## The switch Statement

The `switch` statement provides an alternative to long `if-else if` chains when comparing a single variable against multiple constant values.

### Basic Syntax

```c
switch (expression) {
    case constant1:
        // Code for constant1
        break;
    case constant2:
        // Code for constant2
        break;
    // ... more cases
    default:
        // Code for no match
}
```

### Simple switch Example

```c
#include <stdio.h>

int main() {
    int day = 3;
    
    switch (day) {
        case 1:
            printf("Monday\n");
            break;
        case 2:
            printf("Tuesday\n");
            break;
        case 3:
            printf("Wednesday\n");
            break;
        case 4:
            printf("Thursday\n");
            break;
        case 5:
            printf("Friday\n");
            break;
        case 6:
            printf("Saturday\n");
            break;
        case 7:
            printf("Sunday\n");
            break;
        default:
            printf("Invalid day\n");
    }
    
    return 0;
}
```

### switch Without break Statements

```c
#include <stdio.h>

int main() {
    int choice = 2;
    
    printf("Menu:\n");
    printf("1. Pizza\n");
    printf("2. Burger\n");
    printf("3. Salad\n");
    
    switch (choice) {
        case 1:
            printf("You ordered Pizza - $10\n");
            // Fall through to case 2
        case 2:
            printf("You ordered Burger - $8\n");
            // Fall through to case 3
        case 3:
            printf("You ordered Salad - $5\n");
            break;
        default:
            printf("Invalid choice\n");
    }
    
    return 0;
}
```

## Nested Conditionals

Conditionals can be nested within other conditionals to handle complex decision-making scenarios:

```c
#include <stdio.h>

int main() {
    int age = 25;
    int has_license = 1;  // 1 for true, 0 for false
    
    if (age >= 18) {
        if (has_license) {
            printf("You can drive legally.\n");
        } else {
            printf("You need to get a license.\n");
        }
    } else {
        printf("You are not old enough to drive.\n");
    }
    
    return 0;
}
```

## Conditional Expressions

C also supports the conditional (ternary) operator as a shorthand for simple if-else statements:

```c
#include <stdio.h>

int main() {
    int a = 10, b = 20;
    
    // Traditional if-else
    int max1;
    if (a > b) {
        max1 = a;
    } else {
        max1 = b;
    }
    
    // Conditional operator equivalent
    int max2 = (a > b) ? a : b;
    
    printf("Max (if-else): %d\n", max1);
    printf("Max (conditional): %d\n", max2);
    
    // More complex conditional expressions
    char *status = (age >= 18) ? "adult" : "minor";
    printf("Status: %s\n", status);
    
    return 0;
}
```

## Best Practices for Conditionals

### 1. Use Braces Consistently

```c
// Good: Always use braces
if (condition) {
    do_something();
}

// Avoid: Inconsistent brace usage
if (condition)
    do_something();
else
    do_something_else();
```

### 2. Handle All Cases in switch

```c
// Good: Include default case
switch (value) {
    case 1:
        handle_case_1();
        break;
    case 2:
        handle_case_2();
        break;
    default:
        handle_default();
        break;
}

// Avoid: Missing default case
switch (value) {
    case 1:
        handle_case_1();
        break;
    case 2:
        handle_case_2();
        break;
}
```

### 3. Avoid Deep Nesting

```c
// Good: Early returns to reduce nesting
int process_data(int data) {
    if (data < 0) {
        return -1;  // Error
    }
    
    if (data > 100) {
        return -2;  // Error
    }
    
    // Process valid data
    return data * 2;
}

// Avoid: Deep nesting
int process_data(int data) {
    if (data >= 0) {
        if (data <= 100) {
            return data * 2;
        } else {
            return -2;  // Error
        }
    } else {
        return -1;  // Error
    }
}
```

### 4. Use Descriptive Conditions

```c
// Good: Descriptive variable names
int is_adult = (age >= 18);
int has_permission = (permission_level > 0);

if (is_adult && has_permission) {
    grant_access();
}

// Avoid: Complex conditions in if statement
if (age >= 18 && permission_level > 0 && user_active && !account_locked) {
    grant_access();
}
```

## Common Pitfalls and How to Avoid Them

### 1. Assignment vs. Comparison

```c
#include <stdio.h>

int main() {
    int x = 5;
    
    // Wrong: Assignment instead of comparison
    if (x = 10) {  // This assigns 10 to x and always evaluates to true
        printf("This will always execute!\n");
    }
    
    // Correct: Comparison
    if (x == 10) {
        printf("This checks if x equals 10\n");
    }
    
    // Better: Prevent assignment in condition
    if ((x = 10)) {  // Extra parentheses make assignment intentional
        printf("Assigned x = 10\n");
    }
    
    return 0;
}
```

### 2. Floating-Point Comparisons

```c
#include <stdio.h>
#include <math.h>

int main() {
    double a = 0.1 + 0.2;
    double b = 0.3;
    
    // Wrong: Direct floating-point comparison
    if (a == b) {
        printf("Equal\n");
    } else {
        printf("Not equal (a = %.20f, b = %.20f)\n", a, b);
    }
    
    // Correct: Use epsilon for floating-point comparison
    double epsilon = 1e-9;
    if (fabs(a - b) < epsilon) {
        printf("Approximately equal\n");
    }
    
    return 0;
}
```

### 3. Missing break in switch

```c
#include <stdio.h>

int main() {
    int choice = 1;
    
    // Wrong: Missing break causes fall-through
    switch (choice) {
        case 1:
            printf("Option 1\n");
            // Missing break - falls through to case 2
        case 2:
            printf("Option 2\n");
            break;
        default:
            printf("Default option\n");
    }
    
    // Correct: Include break statements
    switch (choice) {
        case 1:
            printf("Option 1\n");
            break;
        case 2:
            printf("Option 2\n");
            break;
        default:
            printf("Default option\n");
    }
    
    return 0;
}
```

## Practical Examples

### Grade Calculator with Conditionals

```c
#include <stdio.h>

int main() {
    float score;
    
    printf("Enter student score (0-100): ");
    scanf("%f", &score);
    
    // Validate input
    if (score < 0 || score > 100) {
        printf("Invalid score! Please enter a value between 0 and 100.\n");
        return 1;
    }
    
    // Determine letter grade
    if (score >= 90) {
        printf("Grade: A (Excellent)\n");
    } else if (score >= 80) {
        printf("Grade: B (Good)\n");
    } else if (score >= 70) {
        printf("Grade: C (Average)\n");
    } else if (score >= 60) {
        printf("Grade: D (Below Average)\n");
    } else {
        printf("Grade: F (Fail)\n");
    }
    
    // Provide additional feedback
    if (score >= 70) {
        printf("Congratulations! You passed.\n");
    } else {
        printf("You need to improve your performance.\n");
    }
    
    return 0;
}
```

### Menu-Driven Program

```c
#include <stdio.h>

int main() {
    int choice;
    
    do {
        printf("\n=== Calculator Menu ===\n");
        printf("1. Addition\n");
        printf("2. Subtraction\n");
        printf("3. Multiplication\n");
        printf("4. Division\n");
        printf("0. Exit\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        
        if (choice >= 1 && choice <= 4) {
            float num1, num2, result;
            
            printf("Enter two numbers: ");
            scanf("%f %f", &num1, &num2);
            
            switch (choice) {
                case 1:
                    result = num1 + num2;
                    printf("Result: %.2f + %.2f = %.2f\n", num1, num2, result);
                    break;
                case 2:
                    result = num1 - num2;
                    printf("Result: %.2f - %.2f = %.2f\n", num1, num2, result);
                    break;
                case 3:
                    result = num1 * num2;
                    printf("Result: %.2f * %.2f = %.2f\n", num1, num2, result);
                    break;
                case 4:
                    if (num2 != 0) {
                        result = num1 / num2;
                        printf("Result: %.2f / %.2f = %.2f\n", num1, num2, result);
                    } else {
                        printf("Error: Division by zero!\n");
                    }
                    break;
            }
        } else if (choice != 0) {
            printf("Invalid choice! Please try again.\n");
        }
        
    } while (choice != 0);
    
    printf("Thank you for using the calculator!\n");
    return 0;
}
```

### Leap Year Checker

```c
#include <stdio.h>

int main() {
    int year;
    
    printf("Enter a year: ");
    scanf("%d", &year);
    
    // Leap year logic
    if ((year % 4 == 0 && year % 100 != 0) || (year % 400 == 0)) {
        printf("%d is a leap year.\n", year);
    } else {
        printf("%d is not a leap year.\n", year);
    }
    
    // Alternative implementation with nested conditionals
    printf("\nAlternative implementation:\n");
    if (year % 4 == 0) {
        if (year % 100 == 0) {
            if (year % 400 == 0) {
                printf("%d is a leap year.\n", year);
            } else {
                printf("%d is not a leap year.\n", year);
            }
        } else {
            printf("%d is a leap year.\n", year);
        }
    } else {
        printf("%d is not a leap year.\n", year);
    }
    
    return 0;
}
```

## Advanced Conditional Techniques

### Short-Circuit Evaluation

```c
#include <stdio.h>

int main() {
    int a = 5, b = 0;
    
    // Short-circuit prevents division by zero
    if (b != 0 && a / b > 1) {
        printf("Division is safe and result > 1\n");
    } else {
        printf("Either b is zero or division result <= 1\n");
    }
    
    // Short-circuit can be used for efficiency
    int expensive_function_calls = 0;
    
    // Function won't be called if first condition is false
    if (a > 10 && (++expensive_function_calls > 0)) {
        printf("This won't execute\n");
    }
    
    printf("Expensive function calls: %d\n", expensive_function_calls);
    
    return 0;
}
```

### Complex Conditional Logic

```c
#include <stdio.h>
#include <stdbool.h>

int main() {
    bool is_weekend = true;
    bool is_holiday = false;
    int temperature = 75;
    bool has_umbrella = true;
    bool is_raining = false;
    
    // Complex decision making
    bool should_go_outside = 
        (is_weekend || is_holiday) && 
        (temperature >= 60 && temperature <= 85) && 
        (!is_raining || has_umbrella);
    
    if (should_go_outside) {
        printf("Great weather to go outside!\n");
    } else {
        printf("Better stay inside today.\n");
    }
    
    return 0;
}
```

## Summary

In this chapter, you've learned about:

1. **if Statements**: Basic conditional execution
2. **if-else Statements**: Binary decision making
3. **if-else if-else Chains**: Multiple condition handling
4. **switch Statements**: Efficient constant value comparison
5. **Nested Conditionals**: Complex decision trees
6. **Conditional Operators**: Ternary expressions
7. **Best Practices**: Writing clean, maintainable conditional code
8. **Common Pitfalls**: Avoiding typical mistakes
9. **Advanced Techniques**: Short-circuit evaluation and complex logic

Conditional statements are essential for implementing program logic and decision-making capabilities. In the next chapter, we'll explore loops, which allow programs to repeat actions efficiently.