#ifndef STRUCT_UTILS_H
#define STRUCT_UTILS_H

// Structure definitions
typedef struct {
    int day;
    int month;
    int year;
} Date;

typedef struct {
    char firstName[50];
    char lastName[50];
    int age;
    Date birthDate;
} Person;

typedef struct {
    int id;
    char title[100];
    char author[100];
    int year;
    double price;
} Book;

// Linked list node structure
typedef struct Node {
    int data;
    struct Node *next;
} Node;

// Function prototypes for structure utilities
void print_person(const Person *p);
void print_book(const Book *b);
Person create_person(const char *firstName, const char *lastName, int age, Date birthDate);
Book create_book(int id, const char *title, const char *author, int year, double price);
Date create_date(int day, int month, int year);
void print_date(const Date *d);

// Linked list functions
Node* create_node(int data);
void insert_at_beginning(Node **head, int data);
void print_list(Node *head);
void free_list(Node *head);

#endif // STRUCT_UTILS_H