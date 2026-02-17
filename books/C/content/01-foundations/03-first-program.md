# Your First C Program

## Introduction

In this chapter, we'll write and run your first C program. This will introduce you to the basic structure of C programs, the compilation process, and how to execute your code.

## The Classic "Hello, World!" Program

Let's start with the traditional first program in any language - printing "Hello, World!" to the screen:

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

Let's break down each part of this program:

### Preprocessor Directive
```c
#include <stdio.h>
```
This line tells the preprocessor to include the standard input/output library. The `#include` directive is processed before compilation and essentially copies the contents of the specified file into your program.

### Main Function
```c
int main() {
    // function body
}
```
The `main()` function is the entry point of every C program. When you run your program, execution starts here. The `int` before `main` indicates that this function returns an integer value.

### Function Body
```c
{
    printf("Hello, World!\n");
    return 0;
}
```
The curly braces `{}` define the beginning and end of the function body. Everything between them is executed when the function is called.

### Output Statement
```c
printf("Hello, World!\n");
```
This line calls the `printf()` function from the stdio library to print text to the console. The `\n` is an escape sequence that adds a newline character.

### Return Statement
```c
return 0;
```
This statement returns the value 0 to the operating system, indicating that the program executed successfully.

## Creating and Saving Your Program

### Step 1: Create a New File
Create a new file named `hello.c` using your preferred text editor or IDE.

### Step 2: Type the Code
Enter the following code into your file:

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

### Step 3: Save the File
Save the file with the `.c` extension, which indicates it's a C source file.

## Compilation Process

Before you can run your C program, you need to compile it. Compilation is the process of translating human-readable source code into machine-readable binary code.

### Using GCC
```bash
gcc hello.c -o hello
```

This command:
- `gcc` invokes the GNU Compiler Collection
- `hello.c` specifies the source file to compile
- `-o hello` specifies the name of the output executable file

### Using Clang
```bash
clang hello.c -o hello
```

### Using Visual Studio (Windows)
If you're using Visual Studio on Windows:
1. Create a new C++ project
2. Add your `.c` file to the project
3. Build the project (Ctrl+Shift+B)

## Running Your Program

After successful compilation, you'll have an executable file. Run it using:

### Linux/macOS
```bash
./hello
```

### Windows
```cmd
hello.exe
```

You should see the output:
```
Hello, World!
```

## Understanding the Compilation Process

The compilation process involves several stages:

### 1. Preprocessing
The preprocessor handles directives like `#include` and `#define`. It essentially performs text replacement before compilation.

### 2. Compilation
The compiler translates the preprocessed C code into assembly language.

### 3. Assembly
The assembler converts the assembly code into object code (machine code in binary format).

### 4. Linking
The linker combines the object code with any necessary library functions to create the final executable.

## Exploring Compilation Steps Individually

You can see each step of the compilation process:

### Preprocessing Only
```bash
gcc -E hello.c -o hello.i
```

### Compilation to Assembly
```bash
gcc -S hello.c -o hello.s
```

### Assembly to Object Code
```bash
gcc -c hello.s -o hello.o
```

### Linking
```bash
gcc hello.o -o hello
```

## Common Compilation Flags

### Debug Information
```bash
gcc -g hello.c -o hello
```
The `-g` flag includes debugging information, allowing you to use debuggers like GDB.

### Warning Levels
```bash
gcc -Wall -Wextra hello.c -o hello
```
- `-Wall` enables most common warnings
- `-Wextra` enables additional warnings

### Optimization
```bash
gcc -O2 hello.c -o hello
```
The `-O2` flag enables level 2 optimizations.

### C Standard Selection
```bash
gcc -std=c99 hello.c -o hello
gcc -std=c11 hello.c -o hello
gcc -std=c17 hello.c -o hello
gcc -std=c23 hello.c -o hello
```

## Structure of a C Program

Every C program follows a general structure:

```c
/* Preprocessor Directives */
#include <header_files.h>
#define CONSTANTS

/* Global Declarations */
int global_variable;
void function_prototypes();

/* Main Function */
int main() {
    /* Local Declarations */
    int local_variable;
    
    /* Statements */
    printf("Hello, World!\n");
    
    return 0;
}

/* User-defined Functions */
void function_definitions() {
    // function code
}
```

### Key Components

1. **Preprocessor Directives**: Instructions processed before compilation
2. **Global Declarations**: Variables and functions accessible throughout the program
3. **Main Function**: Entry point of the program
4. **Local Declarations**: Variables declared within functions
5. **Statements**: Executable instructions
6. **User-defined Functions**: Custom functions created by the programmer

## Comments in C

Comments are used to document your code and are ignored by the compiler.

### Single-line Comments
```c
// This is a single-line comment
int x = 5; // This comment is at the end of a line
```

### Multi-line Comments
```c
/*
This is a multi-line comment
that spans several lines
*/
int y = 10;
```

## Common Beginner Mistakes

### Missing Semicolons
```c
// Incorrect
printf("Hello, World!\n")

// Correct
printf("Hello, World!\n");
```

### Missing Header Files
```c
// Incorrect - will cause compilation error
int main() {
    printf("Hello, World!\n");
    return 0;
}

// Correct
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    return 0;
}
```

### Case Sensitivity
```c
// Incorrect - C is case-sensitive
Printf("Hello, World!\n");

// Correct
printf("Hello, World!\n");
```

### Forgetting Return Statement
```c
// Incorrect - may cause warnings
int main() {
    printf("Hello, World!\n");
}

// Correct
int main() {
    printf("Hello, World!\n");
    return 0;
}
```

## Variations of the Hello World Program

### Without Return Statement (C99+)
In C99 and later standards, you can omit the return statement in main:

```c
#include <stdio.h>

int main() {
    printf("Hello, World!\n");
    // return 0; is implicit in C99+
}
```

### With Command Line Arguments
```c
#include <stdio.h>

int main(int argc, char *argv[]) {
    printf("Hello, World!\n");
    printf("Program name: %s\n", argv[0]);
    return 0;
}
```

### With Function Prototypes
```c
#include <stdio.h>

void print_greeting(void);

int main() {
    print_greeting();
    return 0;
}

void print_greeting(void) {
    printf("Hello, World!\n");
}
```

## Object Files and Executables

When you compile a C program, you can generate different types of output:

### Object File
```bash
gcc -c hello.c -o hello.o
```
An object file (.o or .obj) contains compiled code but is not yet executable.

### Executable File
```bash
gcc hello.c -o hello
```
An executable file can be run directly by the operating system.

## Summary

In this chapter, you've learned:

1. **Basic C Program Structure**: How to write a simple C program with `#include`, `main()`, and `printf()`
2. **Compilation Process**: The steps from source code to executable
3. **Running Programs**: How to execute your compiled programs
4. **Common Syntax**: Essential elements like semicolons, braces, and comments
5. **Compilation Flags**: Useful options for debugging, warnings, and optimization

This foundation will serve as the building block for all future C programming concepts. In the next chapter, we'll explore basic input and output operations in more detail.