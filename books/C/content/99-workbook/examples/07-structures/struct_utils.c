#include "struct_utils.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Create a date structure
Date create_date(int day, int month, int year) {
    Date d = {day, month, year};
    return d;
}

// Print a date structure
void print_date(const Date *d) {
    if (d == NULL) return;
    printf("%02d/%02d/%04d", d->day, d->month, d->year);
}

// Create a person structure
Person create_person(const char *firstName, const char *lastName, int age, Date birthDate) {
    Person p;
    strncpy(p.firstName, firstName, sizeof(p.firstName) - 1);
    p.firstName[sizeof(p.firstName) - 1] = '\0'; // Ensure null termination
    
    strncpy(p.lastName, lastName, sizeof(p.lastName) - 1);
    p.lastName[sizeof(p.lastName) - 1] = '\0'; // Ensure null termination
    
    p.age = age;
    p.birthDate = birthDate;
    
    return p;
}

// Print a person structure
void print_person(const Person *p) {
    if (p == NULL) return;
    printf("Name: %s %s\n", p->firstName, p->lastName);
    printf("Age: %d\n", p->age);
    printf("Birth Date: ");
    print_date(&p->birthDate);
    printf("\n");
}

// Create a book structure
Book create_book(int id, const char *title, const char *author, int year, double price) {
    Book b;
    b.id = id;
    
    strncpy(b.title, title, sizeof(b.title) - 1);
    b.title[sizeof(b.title) - 1] = '\0'; // Ensure null termination
    
    strncpy(b.author, author, sizeof(b.author) - 1);
    b.author[sizeof(b.author) - 1] = '\0'; // Ensure null termination
    
    b.year = year;
    b.price = price;
    
    return b;
}

// Print a book structure
void print_book(const Book *b) {
    if (b == NULL) return;
    printf("ID: %d\n", b->id);
    printf("Title: %s\n", b->title);
    printf("Author: %s\n", b->author);
    printf("Year: %d\n", b->year);
    printf("Price: $%.2f\n", b->price);
}

// Create a new linked list node
Node* create_node(int data) {
    Node *new_node = (Node*)malloc(sizeof(Node));
    if (new_node == NULL) {
        printf("Error: Memory allocation failed\n");
        return NULL;
    }
    
    new_node->data = data;
    new_node->next = NULL;
    return new_node;
}

// Insert a node at the beginning of the list
void insert_at_beginning(Node **head, int data) {
    if (head == NULL) return;
    
    Node *new_node = create_node(data);
    if (new_node == NULL) return;
    
    new_node->next = *head;
    *head = new_node;
}

// Print the entire linked list
void print_list(Node *head) {
    Node *current = head;
    printf("List: ");
    
    while (current != NULL) {
        printf("%d ", current->data);
        current = current->next;
    }
    printf("\n");
}

// Free all nodes in the linked list
void free_list(Node *head) {
    Node *current = head;
    Node *next;
    
    while (current != NULL) {
        next = current->next;
        free(current);
        current = next;
    }
}