# Makefile for Module 4 Demonstration Program

# Compiler and flags
CC = gcc
CFLAGS = -Wall -Wextra -std=c99 -O2
LDFLAGS = -lm

# Source files
SRCS = module4-demo.c math_utils.c string_utils.c

# Object files
OBJS = $(SRCS:.c=.o)

# Target executable
TARGET = module4-demo

# Default target
all: $(TARGET)

# Link the object files to create the executable
$(TARGET): $(OBJS)
	$(CC) $(OBJS) -o $(TARGET) $(LDFLAGS)

# Compile source files to object files
%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

# Clean build artifacts
clean:
	rm -f $(OBJS) $(TARGET)

# Rebuild everything
rebuild: clean all

# Install (optional)
install: $(TARGET)
	cp $(TARGET) /usr/local/bin/

# Run the program
run: $(TARGET)
	./$(TARGET)

# Debug build
debug: CFLAGS += -g -DDEBUG
debug: rebuild

# Dependencies
module4-demo.o: module4-demo.c math_utils.h string_utils.h
math_utils.o: math_utils.c math_utils.h
string_utils.o: string_utils.c string_utils.h

.PHONY: all clean rebuild install run debug