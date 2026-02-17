#include "string_utils.h"
#include <stdio.h>
#include <ctype.h>

// Calculate string length
int string_length(const char *str) {
    if (str == NULL) return 0;
    
    int length = 0;
    while (str[length] != '\0') {
        length++;
    }
    return length;
}

// Copy string from src to dest
void string_copy(char *dest, const char *src) {
    if (dest == NULL || src == NULL) return;
    
    int i = 0;
    while (src[i] != '\0') {
        dest[i] = src[i];
        i++;
    }
    dest[i] = '\0'; // Null terminate
}

// Concatenate src to dest
void string_concat(char *dest, const char *src) {
    if (dest == NULL || src == NULL) return;
    
    int dest_len = string_length(dest);
    int i = 0;
    
    while (src[i] != '\0') {
        dest[dest_len + i] = src[i];
        i++;
    }
    dest[dest_len + i] = '\0'; // Null terminate
}

// Compare two strings
int string_compare(const char *str1, const char *str2) {
    if (str1 == NULL && str2 == NULL) return 0;
    if (str1 == NULL) return -1;
    if (str2 == NULL) return 1;
    
    int i = 0;
    while (str1[i] != '\0' && str2[i] != '\0') {
        if (str1[i] < str2[i]) return -1;
        if (str1[i] > str2[i]) return 1;
        i++;
    }
    
    // Check if one string is longer than the other
    if (str1[i] == '\0' && str2[i] == '\0') return 0;
    if (str1[i] == '\0') return -1;
    return 1;
}

// Reverse a string in place
char *string_reverse(char *str) {
    if (str == NULL) return NULL;
    
    int len = string_length(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
    return str;
}

// Check if string is a palindrome
int is_palindrome(const char *str) {
    if (str == NULL) return 0;
    
    int len = string_length(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - 1 - i])) {
            return 0;
        }
    }
    return 1;
}

// Count words in a string
int count_words(const char *str) {
    if (str == NULL) return 0;
    
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

// Count vowels in a string
int count_vowels(const char *str) {
    if (str == NULL) return 0;
    
    int count = 0;
    for (int i = 0; str[i] != '\0'; i++) {
        char c = tolower(str[i]);
        if (c == 'a' || c == 'e' || c == 'i' || c == 'o' || c == 'u') {
            count++;
        }
    }
    return count;
}

// Convert string to uppercase
char *to_uppercase(char *str) {
    if (str == NULL) return NULL;
    
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = toupper(str[i]);
    }
    return str;
}

// Convert string to lowercase
char *to_lowercase(char *str) {
    if (str == NULL) return NULL;
    
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = tolower(str[i]);
    }
    return str;
}

// Trim whitespace from both ends of string
char *trim_whitespace(char *str) {
    if (str == NULL) return NULL;
    
    // Trim leading whitespace
    while (isspace(*str)) {
        str++;
    }
    
    // If string is empty after trimming
    if (*str == '\0') {
        return str;
    }
    
    // Trim trailing whitespace
    char *end = str + string_length(str) - 1;
    while (end > str && isspace(*end)) {
        end--;
    }
    
    // Null terminate after last non-whitespace character
    *(end + 1) = '\0';
    
    return str;
}