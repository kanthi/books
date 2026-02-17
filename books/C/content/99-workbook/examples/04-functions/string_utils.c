#include "string_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Function implementations
char *reverse_string(char *str) {
    if (str == NULL) return NULL;
    
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        char temp = str[i];
        str[i] = str[len - 1 - i];
        str[len - 1 - i] = temp;
    }
    return str;
}

char *to_uppercase(char *str) {
    if (str == NULL) return NULL;
    
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = toupper(str[i]);
    }
    return str;
}

char *to_lowercase(char *str) {
    if (str == NULL) return NULL;
    
    for (int i = 0; str[i] != '\0'; i++) {
        str[i] = tolower(str[i]);
    }
    return str;
}

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
    char *end = str + strlen(str) - 1;
    while (end > str && isspace(*end)) {
        end--;
    }
    
    // Null terminate after last non-whitespace character
    *(end + 1) = '\0';
    
    return str;
}

int is_palindrome(const char *str) {
    if (str == NULL) return 0;
    
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - 1 - i])) {
            return 0;
        }
    }
    return 1;
}