#ifndef STRING_UTILS_H
#define STRING_UTILS_H

// Function prototypes for string utilities
int string_length(const char *str);
void string_copy(char *dest, const char *src);
void string_concat(char *dest, const char *src);
int string_compare(const char *str1, const char *str2);
char *string_reverse(char *str);
int is_palindrome(const char *str);
int count_words(const char *str);
int count_vowels(const char *str);
char *to_uppercase(char *str);
char *to_lowercase(char *str);
char *trim_whitespace(char *str);

#endif // STRING_UTILS_H