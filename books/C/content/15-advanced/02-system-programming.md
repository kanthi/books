# Module 15.2: System Programming in C

## Introduction

System programming involves writing software that interacts directly with the operating system and hardware. In C, system programming encompasses a wide range of topics including process management, file system operations, inter-process communication, and low-level system interfaces. This module explores the essential concepts and techniques for writing system-level code in C.

## Learning Objectives

By the end of this module, you will be able to:
- Understand system calls and their role in system programming
- Manage processes and implement process control
- Perform advanced file system operations
- Implement inter-process communication mechanisms
- Work with signals and signal handling
- Understand memory management at the system level
- Apply best practices for secure and robust system programming

## 1. System Calls and APIs

### 1.1 What are System Calls?

System calls are the interface between user-space programs and the kernel. They provide controlled access to system resources and services. In C, system calls are typically accessed through wrapper functions in the standard library.

### 1.2 Common System Call Categories

1. **Process Control**: fork(), exec(), wait(), exit()
2. **File Management**: open(), read(), write(), close(), stat()
3. **Device Management**: ioctl()
4. **Information Maintenance**: getpid(), getuid(), gettimeofday()
5. **Communication**: pipe(), socket(), send(), receive()

### 1.3 Error Handling in System Calls

System calls return -1 on error and set the global `errno` variable:

```c
#include <stdio.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>

int main() {
    if (close(-1) == -1) {
        fprintf(stderr, "Error: %s\n", strerror(errno));
        // Error: Bad file descriptor
    }
    return 0;
}
```

## 2. Process Management

### 2.1 Process Creation with fork()

The `fork()` system call creates a new process by duplicating the calling process:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <stdlib.h>

int main() {
    pid_t pid = fork();
    
    if (pid == -1) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    } else if (pid == 0) {
        // Child process
        printf("Child process (PID: %d)\n", getpid());
        exit(EXIT_SUCCESS);
    } else {
        // Parent process
        printf("Parent process (PID: %d), Child PID: %d\n", getpid(), pid);
        wait(NULL);  // Wait for child to complete
        printf("Child process completed\n");
    }
    
    return 0;
}
```

### 2.2 Process Execution with exec()

The `exec()` family of functions replaces the current process image:

```c
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>

int main() {
    pid_t pid = fork();
    
    if (pid == 0) {
        // Child process - execute ls command
        char *args[] = {"ls", "-l", "/home", NULL};
        execvp("ls", args);
        
        // If execvp returns, it failed
        perror("execvp failed");
        exit(EXIT_FAILURE);
    } else if (pid > 0) {
        // Parent process
        wait(NULL);
        printf("Child process completed\n");
    } else {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }
    
    return 0;
}
```

### 2.3 Process Groups and Sessions

Process groups and sessions help organize related processes:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <signal.h>

int main() {
    pid_t pid = fork();
    
    if (pid == 0) {
        // Create new session
        if (setsid() == -1) {
            perror("setsid failed");
            exit(EXIT_FAILURE);
        }
        
        printf("New session leader (PID: %d)\n", getpid());
        printf("Session ID: %d\n", getsid(0));
        
        // Simulate daemon work
        sleep(10);
        exit(EXIT_SUCCESS);
    } else if (pid > 0) {
        printf("Parent process (PID: %d)\n", getpid());
        wait(NULL);
    }
    
    return 0;
}
```

## 3. Advanced File System Operations

### 3.1 File Metadata with stat()

The `stat()` family of functions retrieves file metadata:

```c
#include <stdio.h>
#include <sys/stat.h>
#include <time.h>
#include <pwd.h>
#include <grp.h>

void print_file_info(const char *filename) {
    struct stat file_stat;
    
    if (stat(filename, &file_stat) == -1) {
        perror("stat failed");
        return;
    }
    
    printf("File: %s\n", filename);
    printf("Size: %ld bytes\n", file_stat.st_size);
    printf("Permissions: %o\n", file_stat.st_mode & 0777);
    printf("Inode: %ld\n", file_stat.st_ino);
    printf("Links: %d\n", file_stat.st_nlink);
    
    // Convert timestamps to readable format
    printf("Last access: %s", ctime(&file_stat.st_atime));
    printf("Last modification: %s", ctime(&file_stat.st_mtime));
    printf("Last status change: %s", ctime(&file_stat.st_ctime));
    
    // Get user and group names
    struct passwd *pwd = getpwuid(file_stat.st_uid);
    struct group *grp = getgrgid(file_stat.st_gid);
    
    if (pwd) printf("Owner: %s\n", pwd->pw_name);
    if (grp) printf("Group: %s\n", grp->gr_name);
}

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <filename>\n", argv[0]);
        return 1;
    }
    
    print_file_info(argv[1]);
    return 0;
}
```

### 3.2 Directory Operations

Working with directories using opendir(), readdir(), and closedir():

```c
#include <stdio.h>
#include <dirent.h>
#include <sys/stat.h>
#include <string.h>

void list_directory(const char *path) {
    DIR *dir = opendir(path);
    if (!dir) {
        perror("opendir failed");
        return;
    }
    
    struct dirent *entry;
    while ((entry = readdir(dir)) != NULL) {
        // Skip current and parent directory entries
        if (strcmp(entry->d_name, ".") == 0 || strcmp(entry->d_name, "..") == 0) {
            continue;
        }
        
        printf("%s\n", entry->d_name);
        
        // Get file type information
        switch (entry->d_type) {
            case DT_REG:
                printf("  (regular file)\n");
                break;
            case DT_DIR:
                printf("  (directory)\n");
                break;
            case DT_LNK:
                printf("  (symbolic link)\n");
                break;
            case DT_CHR:
                printf("  (character device)\n");
                break;
            case DT_BLK:
                printf("  (block device)\n");
                break;
            case DT_FIFO:
                printf("  (named pipe)\n");
                break;
            case DT_SOCK:
                printf("  (socket)\n");
                break;
            default:
                printf("  (unknown)\n");
                break;
        }
    }
    
    closedir(dir);
}

int main(int argc, char *argv[]) {
    const char *path = (argc > 1) ? argv[1] : ".";
    list_directory(path);
    return 0;
}
```

### 3.3 Hard Links and Symbolic Links

Creating and working with links:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/stat.h>

int main() {
    const char *original = "original.txt";
    const char *hard_link = "hard_link.txt";
    const char *sym_link = "sym_link.txt";
    
    // Create original file
    FILE *file = fopen(original, "w");
    if (file) {
        fprintf(file, "This is the original file.\n");
        fclose(file);
    }
    
    // Create hard link
    if (link(original, hard_link) == -1) {
        perror("link failed");
    } else {
        printf("Hard link created: %s\n", hard_link);
    }
    
    // Create symbolic link
    if (symlink(original, sym_link) == -1) {
        perror("symlink failed");
    } else {
        printf("Symbolic link created: %s\n", sym_link);
    }
    
    // Show link information
    struct stat stat_buf;
    if (stat(original, &stat_buf) == 0) {
        printf("Original file link count: %d\n", stat_buf.st_nlink);
    }
    
    return 0;
}
```

## 4. Inter-Process Communication (IPC)

### 4.1 Pipes

Creating anonymous pipes for communication between related processes:

```c
#include <stdio.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>
#include <stdlib.h>

int main() {
    int pipefd[2];
    pid_t pid;
    char buffer[100];
    
    // Create pipe
    if (pipe(pipefd) == -1) {
        perror("pipe failed");
        exit(EXIT_FAILURE);
    }
    
    pid = fork();
    if (pid == -1) {
        perror("fork failed");
        exit(EXIT_FAILURE);
    }
    
    if (pid == 0) {
        // Child process - write to pipe
        close(pipefd[0]);  // Close read end
        
        const char *message = "Hello from child process!";
        write(pipefd[1], message, strlen(message) + 1);
        
        close(pipefd[1]);  // Close write end
        exit(EXIT_SUCCESS);
    } else {
        // Parent process - read from pipe
        close(pipefd[1]);  // Close write end
        
        ssize_t bytes_read = read(pipefd[0], buffer, sizeof(buffer));
        if (bytes_read > 0) {
            printf("Parent received: %s\n", buffer);
        }
        
        close(pipefd[0]);  // Close read end
        wait(NULL);  // Wait for child to complete
    }
    
    return 0;
}
```

### 4.2 Named Pipes (FIFOs)

Creating named pipes for communication between unrelated processes:

```c
#include <stdio.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

#define FIFO_NAME "/tmp/my_fifo"

int main() {
    // Create named pipe
    if (mkfifo(FIFO_NAME, 0666) == -1) {
        perror("mkfifo failed");
        return 1;
    }
    
    pid_t pid = fork();
    if (pid == 0) {
        // Child process - write to FIFO
        int fd = open(FIFO_NAME, O_WRONLY);
        if (fd == -1) {
            perror("open failed");
            exit(EXIT_FAILURE);
        }
        
        const char *message = "Message through named pipe";
        write(fd, message, strlen(message) + 1);
        close(fd);
        exit(EXIT_SUCCESS);
    } else {
        // Parent process - read from FIFO
        int fd = open(FIFO_NAME, O_RDONLY);
        if (fd == -1) {
            perror("open failed");
            return 1;
        }
        
        char buffer[100];
        ssize_t bytes_read = read(fd, buffer, sizeof(buffer));
        if (bytes_read > 0) {
            printf("Received: %s\n", buffer);
        }
        
        close(fd);
        wait(NULL);
        unlink(FIFO_NAME);  // Remove FIFO
    }
    
    return 0;
}
```

### 4.3 Shared Memory

Using shared memory for efficient data sharing:

```c
#include <stdio.h>
#include <sys/shm.h>
#include <sys/stat.h>
#include <unistd.h>
#include <sys/wait.h>
#include <string.h>

int main() {
    const int SHM_SIZE = 1024;
    const key_t shm_key = 0x1234;
    
    // Create shared memory segment
    int shmid = shmget(shm_key, SHM_SIZE, IPC_CREAT | 0666);
    if (shmid == -1) {
        perror("shmget failed");
        return 1;
    }
    
    pid_t pid = fork();
    if (pid == 0) {
        // Child process - write to shared memory
        char *shm_ptr = (char*)shmat(shmid, NULL, 0);
        if (shm_ptr == (char*)-1) {
            perror("shmat failed");
            exit(EXIT_FAILURE);
        }
        
        strcpy(shm_ptr, "Hello from shared memory!");
        shmdt(shm_ptr);
        exit(EXIT_SUCCESS);
    } else {
        // Parent process - read from shared memory
        sleep(1);  // Wait for child to write
        
        char *shm_ptr = (char*)shmat(shmid, NULL, 0);
        if (shm_ptr == (char*)-1) {
            perror("shmat failed");
            return 1;
        }
        
        printf("Received: %s\n", shm_ptr);
        
        shmdt(shm_ptr);
        shmctl(shmid, IPC_RMID, NULL);  // Remove shared memory
        wait(NULL);
    }
    
    return 0;
}
```

## 5. Signal Handling

### 5.1 Basic Signal Handling

Handling signals with signal() or sigaction():

```c
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>

void signal_handler(int sig) {
    switch (sig) {
        case SIGINT:
            printf("\nReceived SIGINT (Ctrl+C)\n");
            break;
        case SIGTERM:
            printf("\nReceived SIGTERM\n");
            break;
        default:
            printf("\nReceived signal %d\n", sig);
            break;
    }
}

int main() {
    // Register signal handlers
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    printf("Process PID: %d\n", getpid());
    printf("Send signals to test handling\n");
    printf("Press Ctrl+C to send SIGINT\n");
    
    // Infinite loop - wait for signals
    while (1) {
        printf("Working...\n");
        sleep(2);
    }
    
    return 0;
}
```

### 5.2 Advanced Signal Handling with sigaction()

More robust signal handling using sigaction():

```c
#include <stdio.h>
#include <signal.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

volatile sig_atomic_t signal_received = 0;

void sigint_handler(int sig, siginfo_t *info, void *context) {
    printf("\nReceived SIGINT from PID %d\n", info->si_pid);
    signal_received = 1;
}

void sigusr1_handler(int sig, siginfo_t *info, void *context) {
    printf("\nReceived SIGUSR1\n");
    signal_received = 2;
}

int main() {
    struct sigaction sa_int, sa_usr1;
    
    // Setup SIGINT handler
    memset(&sa_int, 0, sizeof(sa_int));
    sa_int.sa_sigaction = sigint_handler;
    sa_int.sa_flags = SA_SIGINFO;
    sigaction(SIGINT, &sa_int, NULL);
    
    // Setup SIGUSR1 handler
    memset(&sa_usr1, 0, sizeof(sa_usr1));
    sa_usr1.sa_sigaction = sigusr1_handler;
    sa_usr1.sa_flags = SA_SIGINFO;
    sigaction(SIGUSR1, &sa_usr1, NULL);
    
    printf("Process PID: %d\n", getpid());
    printf("Send SIGINT (Ctrl+C) or SIGUSR1 to test\n");
    
    while (!signal_received) {
        printf("Working... (signal_received = %d)\n", signal_received);
        sleep(2);
    }
    
    printf("Exiting due to signal %d\n", signal_received);
    return 0;
}
```

## 6. Memory Management

### 6.1 Memory Mapping with mmap()

Using mmap() for file mapping and shared memory:

```c
#include <stdio.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <string.h>

int main() {
    const char *filename = "mapped_file.txt";
    const char *content = "This content is mapped to memory.\n";
    
    // Create and write to file
    int fd = open(filename, O_CREAT | O_RDWR, 0666);
    if (fd == -1) {
        perror("open failed");
        return 1;
    }
    
    write(fd, content, strlen(content));
    
    // Map file to memory
    struct stat sb;
    fstat(fd, &sb);
    
    char *mapped = mmap(NULL, sb.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (mapped == MAP_FAILED) {
        perror("mmap failed");
        close(fd);
        return 1;
    }
    
    printf("Original content: %s", mapped);
    
    // Modify mapped content
    strcpy(mapped, "Modified content through memory mapping!\n");
    
    // Unmap and cleanup
    munmap(mapped, sb.st_size);
    close(fd);
    
    // Verify changes
    fd = open(filename, O_RDONLY);
    char buffer[100];
    ssize_t bytes_read = read(fd, buffer, sizeof(buffer) - 1);
    if (bytes_read > 0) {
        buffer[bytes_read] = '\0';
        printf("File content after modification: %s", buffer);
    }
    
    close(fd);
    unlink(filename);
    return 0;
}
```

### 6.2 Memory Protection

Setting memory protection with mprotect():

```c
#include <stdio.h>
#include <sys/mman.h>
#include <stdlib.h>
#include <signal.h>
#include <setjmp.h>

static jmp_buf jmp_env;

void segv_handler(int sig) {
    printf("Segmentation fault caught!\n");
    longjmp(jmp_env, 1);
}

int main() {
    // Allocate memory with mmap
    size_t page_size = getpagesize();
    char *memory = mmap(NULL, page_size, PROT_READ | PROT_WRITE, 
                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
    
    if (memory == MAP_FAILED) {
        perror("mmap failed");
        return 1;
    }
    
    // Set up signal handler
    signal(SIGSEGV, segv_handler);
    
    // Write to memory (should work)
    strcpy(memory, "Hello, protected memory!");
    printf("Before protection: %s\n", memory);
    
    // Set memory to read-only
    if (mprotect(memory, page_size, PROT_READ) == -1) {
        perror("mprotect failed");
        munmap(memory, page_size);
        return 1;
    }
    
    // Try to write to protected memory
    if (setjmp(jmp_env) == 0) {
        strcpy(memory, "This should fail!");
        printf("Write succeeded (unexpected)\n");
    } else {
        printf("Write to protected memory failed as expected\n");
    }
    
    printf("After protection: %s\n", memory);
    
    // Cleanup
    munmap(memory, page_size);
    return 0;
}
```

## 7. Security Considerations

### 7.1 Secure Programming Practices

1. **Input Validation**: Always validate and sanitize input
2. **Buffer Overflow Prevention**: Use safe string functions
3. **Privilege Management**: Drop privileges when not needed
4. **Secure File Operations**: Set appropriate permissions
5. **Environment Sanitization**: Clear sensitive environment variables

### 7.2 Example of Secure File Handling

```c
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <sys/stat.h>
#include <errno.h>
#include <string.h>

int create_secure_file(const char *filename) {
    // Create file with restrictive permissions
    int fd = open(filename, O_CREAT | O_WRONLY | O_TRUNC, 0600);
    if (fd == -1) {
        return -1;
    }
    
    // Verify file was created with correct permissions
    struct stat st;
    if (fstat(fd, &st) == -1) {
        close(fd);
        unlink(filename);
        return -1;
    }
    
    if ((st.st_mode & 0777) != 0600) {
        close(fd);
        unlink(filename);
        errno = EACCES;
        return -1;
    }
    
    return fd;
}

int main() {
    const char *filename = "secure_file.txt";
    int fd = create_secure_file(filename);
    
    if (fd == -1) {
        perror("Failed to create secure file");
        return 1;
    }
    
    const char *data = "Sensitive data";
    write(fd, data, strlen(data));
    close(fd);
    
    printf("Secure file created successfully\n");
    
    // Verify permissions
    struct stat st;
    if (stat(filename, &st) == 0) {
        printf("File permissions: %o\n", st.st_mode & 0777);
    }
    
    unlink(filename);
    return 0;
}
```

## 8. Best Practices

### 8.1 Error Handling

1. **Check all system call return values**
2. **Use errno for detailed error information**
3. **Implement proper cleanup on error**
4. **Log errors appropriately**

### 8.2 Resource Management

1. **Always close file descriptors**
2. **Free allocated memory**
3. **Remove temporary files**
4. **Detach shared memory segments**

### 8.3 Portability

1. **Use feature test macros**
2. **Handle platform differences**
3. **Avoid non-standard extensions**
4. **Test on multiple platforms**

## Summary

System programming in C requires a deep understanding of operating system concepts and careful attention to detail. Key areas covered in this module include:

- Process management with fork(), exec(), and wait()
- Advanced file system operations with stat() and directory functions
- Inter-process communication through pipes, FIFOs, and shared memory
- Signal handling for process control
- Memory management with mmap() and mprotect()
- Security considerations for robust system code

Mastering system programming enables developers to create efficient, low-level applications that interact directly with the operating system. Always prioritize security, robustness, and proper error handling when writing system-level code.