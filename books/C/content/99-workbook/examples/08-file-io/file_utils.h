#ifndef FILE_UTILS_H
#define FILE_UTILS_H

#include <stdio.h>

// Function prototypes for file utilities
FILE* open_file(const char *filename, const char *mode);
void close_file(FILE *file);
int write_text_to_file(const char *filename, const char *text);
int append_text_to_file(const char *filename, const char *text);
char* read_text_from_file(const char *filename);
int copy_file(const char *source, const char *destination);
long get_file_size(const char *filename);
int file_exists(const char *filename);
void print_file_contents(const char *filename);

#endif // FILE_UTILS_H