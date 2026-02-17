# Strings

## Introduction

In C, strings are represented as arrays of characters terminated by a null character ('\0'). Unlike many other programming languages that have a dedicated string data type, C treats strings as a convention built on top of character arrays. This approach provides flexibility but also requires careful handling to avoid common pitfalls like buffer overflows and memory management issues.

## String Representation

### Character Arrays
Strings in C are stored as character arrays with a null terminator:

```c
char str1[6] = {'H', 'e', 'l', 'l', 'o', '\0'};
char str2[6] = "Hello";  // Equivalent to above
char str3[] = "Hello";   // Size automatically determined
```

### String Literals
String literals are stored in read-only memory and should be treated as constant:

```c
char *str = "Hello";     // Pointer to string literal (read-only)
char str2[] = "Hello";   // Modifiable character array
```

### Null Terminator
The null character ('\0') marks the end of a string:

```c
char str[] = "Hello";
// Memory layout: 'H' 'e' 'l' 'l' 'o' '\0'
// Indices:        0   1   2   3   4   5
```

## String Declaration and Initialization

### Different Ways to Declare Strings
```c
// Character array - modifiable
char str1[20] = "Hello";

// Character array - partial initialization
char str2[20] = {'H', 'e', 'l', 'l', 'o', '\0'};

// Pointer to string literal - read-only
char *str3 = "Hello";

// Uninitialized character array
char str4[20];
```

### Initialization Examples
```c
// Initialize with string literal
char greeting[] = "Hello, World!";

// Initialize with character array
char name[50] = {'J', 'o', 'h', 'n', '\0'};

// Initialize empty string
char empty[10] = "";

// Initialize with memset
char buffer[100];
memset(buffer, 0, sizeof(buffer));
```

## Standard Library String Functions

### String Length
```c
#include <string.h>

size_t strlen(const char *str);
size_t strnlen(const char *str, size_t maxlen);  // C23
```

Example:
```c
char str[] = "Hello";
size_t length = strlen(str);  // Returns 5
```

### String Copying
```c
#include <string.h>

char *strcpy(char *dest, const char *src);
char *strncpy(char *dest, const char *src, size_t n);
char *strdup(const char *s);        // C23
char *strndup(const char *s, size_t n);  // C23
```

Example:
```c
char source[] = "Hello";
char destination[20];

strcpy(destination, source);  // Copy entire string
strncpy(destination, source, 3);  // Copy first 3 characters
```

### String Concatenation
```c
#include <string.h>

char *strcat(char *dest, const char *src);
char *strncat(char *dest, const char *src, size_t n);
```

Example:
```c
char str[50] = "Hello";
char append[] = " World";

strcat(str, append);  // str becomes "Hello World"
```

### String Comparison
```c
#include <string.h>

int strcmp(const char *s1, const char *s2);
int strncmp(const char *s1, const char *s2, size_t n);
int strcoll(const char *s1, const char *s2);  // Locale-specific
```

Example:
```c
char str1[] = "Hello";
char str2[] = "World";

int result = strcmp(str1, str2);
// result < 0 if str1 < str2
// result == 0 if str1 == str2
// result > 0 if str1 > str2
```

### String Searching
```c
#include <string.h>

char *strchr(const char *s, int c);     // Find first occurrence
char *strrchr(const char *s, int c);    // Find last occurrence
char *strstr(const char *haystack, const char *needle);  // Find substring
size_t strcspn(const char *s, const char *reject);       // Span of non-matching chars
size_t strspn(const char *s, const char *accept);        // Span of matching chars
char *strpbrk(const char *s, const char *accept);        // Find any of a set of chars
```

Example:
```c
char str[] = "Hello, World!";
char *pos = strchr(str, 'o');  // Points to first 'o'
char *last_pos = strrchr(str, 'o');  // Points to last 'o'
char *substr = strstr(str, "World");  // Points to "World!"
```

## Manual String Operations

### String Length (Manual Implementation)
```c
int string_length(const char *str) {
    int length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length;
}
```

### String Copying (Manual Implementation)
```c
void string_copy(char *dest, const char *src) {
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0';  // Don't forget null terminator
}
```

### String Comparison (Manual Implementation)
```c
int string_compare(const char *str1, const char *str2) {
    int i = 0;
    while (str1[i] != '\0' && str2[i] != '\0') {
        if (str1[i] < str2[i]) return -1;
        if (str1[i] > str2[i]) return 1;
        i++;
    }
    
    // Check if one string is longer
    if (str1[i] == '\0' && str2[i] == '\0') return 0;
    if (str1[i] == '\0') return -1;
    return 1;
}
```

## String Input and Output

### Reading Strings
```c
#include <stdio.h>

// Using scanf (dangerous - no bounds checking)
char str1[20];
scanf("%s", str1);  // Risk of buffer overflow

// Using scanf with width specifier (safer)
char str2[20];
scanf("%19s", str2);  // Reads at most 19 characters

// Using fgets (safer for multi-word strings)
char str3[100];
fgets(str3, sizeof(str3), stdin);  // Includes newline character

// Using gets (deprecated and dangerous - never use)
char str4[100];
gets(str4);  // Deprecated - do not use
```

### Writing Strings
```c
#include <stdio.h>

char str[] = "Hello, World!";

// Using printf
printf("%s\n", str);

// Using puts (adds newline automatically)
puts(str);

// Using putchar for character-by-character output
for (int i = 0; str[i] != '\0'; i++) {
    putchar(str[i]);
}
```

## String Manipulation Techniques

### Removing Newline from fgets
```c
void remove_newline(char *str) {
    int len = strlen(str);
    if (len > 0 && str[len-1] == '\n') {
        str[len-1] = '\0';
    }
}
```

### String Trimming
```c
void trim_whitespace(char *str) {
    // Trim leading whitespace
    while (isspace(*str)) {
        str++;
    }
    
    // If string is empty after trimming
    if (*str == '\0') {
        return;
    }
    
    // Trim trailing whitespace
    char *end = str + strlen(str) - 1;
    while (end > str && isspace(*end)) {
        end--;
    }
    
    // Null terminate after last non-whitespace character
    *(end + 1) = '\0';
}
```

### String Reversal
```c
void reverse_string(char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
}
```

### Case Conversion
```c
#include <ctype.h>

void to_uppercase(char *str) {
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = toupper(str[i]);
    }
}

void to_lowercase(char *str) {
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = tolower(str[i]);
    }
}
```

## String Tokenization

### Using strtok
```c
#include <string.h>

char str[] = "apple,banana,orange,grape";
char *token;

// Get first token
token = strtok(str, ",");
while (token != NULL) {
    printf("Token: %s\n", token);
    // Get next token
    token = strtok(NULL, ",");
}
```

### Manual Tokenization
```c
void tokenize_string(const char *str, char delimiter, char tokens[][50], int *token_count) {
    int start = 0, end = 0, count = 0;
    
    while (str[end] != '\0') {
        if (str[end] == delimiter) {
            // Copy token
            int len = end - start;
            strncpy(tokens[count], &str[start], len);
            tokens[count][len] = '\0';
            count++;
            
            // Move to next token
            start = end + 1;
        }
        end++;
    }
    
    // Copy last token
    int len = end - start;
    strncpy(tokens[count], &str[start], len);
    tokens[count][len] = '\0';
    count++;
    
    *token_count = count;
}
```

## String Pitfalls and Best Practices

### Buffer Overflow Prevention
```c
// Dangerous - no bounds checking
char buffer[10];
scanf("%s", buffer);  // Potential buffer overflow

// Safe - with bounds checking
char buffer[10];
scanf("%9s", buffer);  // Reads at most 9 characters

// Safe - using fgets
char buffer[10];
fgets(buffer, sizeof(buffer), stdin);
```

### Memory Management
```c
// Dynamically allocated string
char *str = malloc(20 * sizeof(char));
if (str != NULL) {
    strcpy(str, "Hello");
    // Use str...
    free(str);  // Don't forget to free
    str = NULL; // Prevent dangling pointer
}
```

### String Literal Modification
```c
// Dangerous - modifying string literal
char *str = "Hello";
str[0] = 'h';  // Undefined behavior

// Safe - modifying character array
char str[] = "Hello";
str[0] = 'h';  // OK
```

## Practical Examples

### Palindrome Checker
```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int is_palindrome(const char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - 1 - i])) {
            return 0;
        }
    }
    return 1;
}

int main() {
    char str[100];
    
    printf("Enter a string: ");
    fgets(str, sizeof(str), stdin);
    
    // Remove newline if present
    int len = strlen(str);
    if (len > 0 && str[len-1] == '\n') {
        str[len-1] = '\0';
    }
    
    if (is_palindrome(str)) {
        printf("'%s' is a palindrome.\n", str);
    } else {
        printf("'%s' is not a palindrome.\n", str);
    }
    
    return 0;
}
```

### Word Count Program
```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

int count_words(const char *str) {
    int count = 0;
    int in_word = 0;
    
    for (int i = 0; str[i] != '\0'; i++) {
        if (isspace(str[i])) {
            in_word = 0;
        } else if (!in_word) {
            in_word = 1;
            count++;
        }
    }
    return count;
}

int main() {
    char text[1000];
    
    printf("Enter text: ");
    fgets(text, sizeof(text), stdin);
    
    int words = count_words(text);
    printf("Word count: %d\n", words);
    
    return 0;
}
```

### String Statistics
```c
#include <stdio.h>
#include <string.h>
#include <ctype.h>

void analyze_string(const char *str) {
    int letters = 0, digits = 0, spaces = 0, others = 0;
    
    for (int i = 0; str[i] != '\0'; i++) {
        if (isalpha(str[i])) {
            letters++;
        } else if (isdigit(str[i])) {
            digits++;
        } else if (isspace(str[i])) {
            spaces++;
        } else {
            others++;
        }
    }
    
    printf("String analysis:\n");
    printf("Letters: %d\n", letters);
    printf("Digits: %d\n", digits);
    printf("Spaces: %d\n", spaces);
    printf("Other characters: %d\n", others);
    printf("Total characters: %lu\n", strlen(str));
}

int main() {
    char text[1000];
    
    printf("Enter text for analysis: ");
    fgets(text, sizeof(text), stdin);
    
    // Remove newline if present
    int len = strlen(text);
    if (len > 0 && text[len-1] == '\n') {
        text[len-1] = '\0';
    }
    
    analyze_string(text);
    
    return 0;
}
```

## Summary

Strings in C are character arrays terminated by a null character, providing a flexible but manual approach to text processing. Key points to remember:

1. **Representation**: Strings are character arrays with null terminators
2. **String Literals**: Stored in read-only memory and should be treated as constant
3. **Standard Library Functions**: Use functions from string.h for common operations
4. **Input/Output**: Use fgets instead of gets for safe string input
5. **Memory Management**: Be careful with dynamic allocation and string literals
6. **Buffer Safety**: Always ensure adequate buffer sizes to prevent overflows
7. **Best Practices**: Initialize strings, check bounds, and use standard library functions

Understanding strings is crucial for C programming as text processing is a common requirement in most applications.