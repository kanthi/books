# System-Level Programming

## Introduction

System-level programming in C involves interacting directly with the operating system to perform tasks such as processing command-line arguments, accessing environment variables, managing process execution, and handling system signals. These capabilities allow C programs to integrate seamlessly with the operating system environment and provide more sophisticated functionality than basic file I/O operations.

Understanding system-level programming concepts is essential for developing robust applications that can adapt to different environments, handle errors gracefully, and interact with system resources effectively.

**Environment:** Linux/POSIX (macOS mostly fine). Compile with:

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
```

Some examples use POSIX APIs (`sigaction`, `fork`, `unistd.h`).

## Command-Line Arguments

Command-line arguments allow programs to receive input directly from the command line when they are executed. This is a fundamental way for programs to be configurable and flexible.

### argc and argv

The `main()` function can accept two parameters for processing command-line arguments:

```c
int main(int argc, char *argv[]);
```

**Parameters:**
- `argc`: Argument count (number of command-line arguments)
- `argv`: Argument vector (array of string pointers to the arguments)

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
    printf("Program name: %s\n", argv[0]);
    printf("Number of arguments: %d\n", argc - 1);
    
    // Print all arguments
    for (int i = 1; i < argc; i++) {
        printf("Argument %d: %s\n", i, argv[i]);
    }
    
    return 0;
}
```

### Practical Command-Line Processor

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_usage(const char *program_name) {
    printf("Usage: %s [options] <input_file> <output_file>\n", program_name);
    printf("Options:\n");
    printf("  -v, --verbose    Verbose output\n");
    printf("  -h, --help       Show this help message\n");
    printf("  -c, --copy       Copy mode (default)\n");
    printf("  -m, --move       Move mode\n");
}

int main(int argc, char *argv[]) {
    int verbose = 0;
    int move_mode = 0;
    const char *input_file = NULL;
    const char *output_file = NULL;
    
    // Process command-line arguments
    for (int i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0 || strcmp(argv[i], "--verbose") == 0) {
            verbose = 1;
        } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            print_usage(argv[0]);
            exit(EXIT_SUCCESS);
        } else if (strcmp(argv[i], "-m") == 0 || strcmp(argv[i], "--move") == 0) {
            move_mode = 1;
        } else if (strcmp(argv[i], "-c") == 0 || strcmp(argv[i], "--copy") == 0) {
            move_mode = 0;
        } else if (input_file == NULL) {
            input_file = argv[i];
        } else if (output_file == NULL) {
            output_file = argv[i];
        } else {
            fprintf(stderr, "Error: Too many arguments\n");
            print_usage(argv[0]);
            exit(EXIT_FAILURE);
        }
    }
    
    // Validate required arguments
    if (input_file == NULL || output_file == NULL) {
        fprintf(stderr, "Error: Input and output files required\n");
        print_usage(argv[0]);
        exit(EXIT_FAILURE);
    }
    
    if (verbose) {
        printf("Mode: %s\n", move_mode ? "Move" : "Copy");
        printf("Input file: %s\n", input_file);
        printf("Output file: %s\n", output_file);
    }
    
    // Perform the operation (simplified)
    if (move_mode) {
        if (verbose) printf("Moving file...\n");
        // In a real implementation, you would use rename()
    } else {
        if (verbose) printf("Copying file...\n");
        // In a real implementation, you would copy the file contents
    }
    
    printf("Operation completed successfully\n");
    return 0;
}
```

## Environment Variables

Environment variables provide a way for programs to access system configuration information and user preferences. They are key-value pairs that are inherited from the parent process and can be accessed by C programs.

### getenv()

Retrieves the value of an environment variable:

```c
char *getenv(const char *name);
```

**Return Value:**
- Pointer to the value string on success
- `NULL` if the variable is not found

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    char *home_dir, *path, *user, *shell;
    
    // Get common environment variables
    home_dir = getenv("HOME");
    path = getenv("PATH");
    user = getenv("USER");
    shell = getenv("SHELL");
    
    printf("Home directory: %s\n", home_dir ? home_dir : "Not set");
    printf("User: %s\n", user ? user : "Not set");
    printf("Shell: %s\n", shell ? shell : "Not set");
    printf("Path: %s\n", path ? path : "Not set");
    
    // Check for custom environment variable
    char *debug = getenv("DEBUG");
    if (debug != NULL && strcmp(debug, "1") == 0) {
        printf("Debug mode enabled\n");
    }
    
    return 0;
}
```

### Setting Environment Variables

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    // Set an environment variable
    if (setenv("MY_VARIABLE", "Hello, World!", 1) != 0) {
        perror("Error setting environment variable");
        exit(EXIT_FAILURE);
    }
    
    // Retrieve and display the variable
    char *value = getenv("MY_VARIABLE");
    printf("MY_VARIABLE = %s\n", value ? value : "Not set");
    
    // Unset the environment variable
    unsetenv("MY_VARIABLE");
    
    // Try to retrieve it again
    value = getenv("MY_VARIABLE");
    printf("MY_VARIABLE after unset = %s\n", value ? value : "Not set");
    
    return 0;
}
```

## Process Management

Process management functions allow programs to control their execution flow, terminate gracefully, and manage exit status codes.

### exit()

Terminates the program with a specified exit status:

```c
void exit(int status);
```

### atexit()

Registers functions to be called when the program exits:

```c
int atexit(void (*func)(void));
```

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

void cleanup_handler1(void) {
    printf("Cleanup handler 1 called\n");
}

void cleanup_handler2(void) {
    printf("Cleanup handler 2 called\n");
}

void cleanup_handler3(void) {
    printf("Cleanup handler 3 called\n");
}

int main() {
    // Register cleanup handlers
    if (atexit(cleanup_handler1) != 0) {
        fprintf(stderr, "Failed to register cleanup handler 1\n");
        exit(EXIT_FAILURE);
    }
    
    if (atexit(cleanup_handler2) != 0) {
        fprintf(stderr, "Failed to register cleanup handler 2\n");
        exit(EXIT_FAILURE);
    }
    
    if (atexit(cleanup_handler3) != 0) {
        fprintf(stderr, "Failed to register cleanup handler 3\n");
        exit(EXIT_FAILURE);
    }
    
    printf("Main function executing\n");
    
    // Exit with success status
    exit(EXIT_SUCCESS);
    
    // This code will never be reached
    printf("This won't be printed\n");
}
```

### Process Exit Status

```c
#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <number>\n", argv[0]);
        exit(EXIT_FAILURE);  // Exit with failure status
    }
    
    int number = atoi(argv[1]);
    
    if (number < 0) {
        fprintf(stderr, "Error: Negative numbers not allowed\n");
        exit(EXIT_FAILURE);  // Exit with failure status
    }
    
    if (number == 0) {
        printf("Zero is neither positive nor negative\n");
        exit(EXIT_SUCCESS);  // Exit with success status
    }
    
    printf("Number %d is positive\n", number);
    
    // Normal exit (equivalent to exit(EXIT_SUCCESS))
    return 0;
}
```

## Signal Handling

Signals are software interrupts that allow the operating system to notify a process of various events. Signal handling enables programs to respond gracefully to events like user interrupts, termination requests, and other system events.

### signal()

Sets up a signal handler:

```c
#include <signal.h>
void (*signal(int sig, void (*handler)(int)))(int);
```

### Common Signals

| Signal | Description | Default Action |
|--------|-------------|----------------|
| `SIGINT` | Interrupt (Ctrl+C) | Terminate process |
| `SIGTERM` | Termination request | Terminate process |
| `SIGKILL` | Kill signal | Terminate process (cannot be caught) |
| `SIGSEGV` | Segmentation fault | Terminate process |
| `SIGUSR1` | User-defined signal 1 | Terminate process |
| `SIGUSR2` | User-defined signal 2 | Terminate process |

### Examples

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>

volatile sig_atomic_t signal_received = 0;

void signal_handler(int sig) {
    printf("\nReceived signal %d\n", sig);
    signal_received = 1;
}

int main() {
    // Set up signal handlers
    if (signal(SIGINT, signal_handler) == SIG_ERR) {
        perror("Error setting SIGINT handler");
        exit(EXIT_FAILURE);
    }
    
    if (signal(SIGTERM, signal_handler) == SIG_ERR) {
        perror("Error setting SIGTERM handler");
        exit(EXIT_FAILURE);
    }
    
    printf("Program running. Press Ctrl+C to interrupt.\n");
    
    // Main loop
    while (!signal_received) {
        printf("Working...\n");
        sleep(2);
    }
    
    printf("Cleaning up and exiting gracefully...\n");
    
    // Perform cleanup operations here
    // Close files, free memory, etc.
    
    exit(EXIT_SUCCESS);
}
```

### Advanced Signal Handling

```c
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>

volatile sig_atomic_t sigint_count = 0;
volatile sig_atomic_t sigterm_received = 0;

void sigint_handler(int sig) {
    sigint_count++;
    printf("\nSIGINT received (%d times)\n", sigint_count);
    
    if (sigint_count >= 3) {
        printf("Three interrupts received. Exiting...\n");
        exit(EXIT_SUCCESS);
    }
}

void sigterm_handler(int sig) {
    printf("\nSIGTERM received. Cleaning up...\n");
    sigterm_received = 1;
}

void sigsegv_handler(int sig) {
    printf("\nSegmentation fault detected! Saving emergency data...\n");
    // Save critical data before terminating
    exit(EXIT_FAILURE);
}

int main() {
    // Set up signal handlers
    struct sigaction sa_int, sa_term, sa_segv;
    
    // SIGINT handler
    memset(&sa_int, 0, sizeof(sa_int));
    sa_int.sa_handler = sigint_handler;
    sigemptyset(&sa_int.sa_mask);
    sa_int.sa_flags = 0;
    sigaction(SIGINT, &sa_int, NULL);
    
    // SIGTERM handler
    memset(&sa_term, 0, sizeof(sa_term));
    sa_term.sa_handler = sigterm_handler;
    sigemptyset(&sa_term.sa_mask);
    sa_term.sa_flags = 0;
    sigaction(SIGTERM, &sa_term, NULL);
    
    // SIGSEGV handler
    memset(&sa_segv, 0, sizeof(sa_segv));
    sa_segv.sa_handler = sigsegv_handler;
    sigemptyset(&sa_segv.sa_mask);
    sa_segv.sa_flags = SA_RESETHAND;  // Only handle once
    sigaction(SIGSEGV, &sa_segv, NULL);
    
    printf("Advanced signal handling demo\n");
    printf("Press Ctrl+C up to 3 times, or send SIGTERM to terminate\n");
    
    // Main loop
    while (!sigterm_received) {
        printf("Working... (PID: %d)\n", getpid());
        sleep(3);
    }
    
    printf("Program terminating normally\n");
    return 0;
}
```

## System Calls and Process Creation

System calls provide direct access to operating system services. While C's standard library provides higher-level interfaces, system calls offer more control and are sometimes necessary for specific tasks.

### system()

Executes a command through the shell:

```c
int system(const char *command);
```

### Examples

```c
#include <stdio.h>
#include <stdlib.h>

int main() {
    int result;
    
    // Execute system commands
    printf("Listing current directory:\n");
    result = system("ls -la");
    if (result == -1) {
        perror("Error executing command");
    }
    
    printf("\nCurrent date and time:\n");
    result = system("date");
    if (result == -1) {
        perror("Error executing command");
    }
    
    // Conditional execution based on system command result
    printf("\nChecking if 'git' is available:\n");
    result = system("which git > /dev/null 2>&1");
    if (result == 0) {
        printf("Git is available\n");
        system("git --version");
    } else {
        printf("Git is not available\n");
    }
    
    return 0;
}
```

## Practical Examples

### Configuration File Processor
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct {
    char database_host[100];
    int database_port;
    char log_level[20];
    int max_connections;
} Config;

int load_config(const char *filename, Config *config) {
    FILE *fp;
    char line[256];
    char key[100], value[100];
    
    // Set default values
    strcpy(config->database_host, "localhost");
    config->database_port = 5432;
    strcpy(config->log_level, "INFO");
    config->max_connections = 100;
    
    fp = fopen(filename, "r");
    if (fp == NULL) {
        // Try to load from environment variables
        char *env_host = getenv("DB_HOST");
        char *env_port = getenv("DB_PORT");
        char *env_log = getenv("LOG_LEVEL");
        char *env_max = getenv("MAX_CONN");
        
        if (env_host) strcpy(config->database_host, env_host);
        if (env_port) config->database_port = atoi(env_port);
        if (env_log) strcpy(config->log_level, env_log);
        if (env_max) config->max_connections = atoi(env_max);
        
        return 0;  // Success with environment variables
    }
    
    // Parse configuration file
    while (fgets(line, sizeof(line), fp) != NULL) {
        // Skip comments and empty lines
        if (line[0] == '#' || line[0] == '\n') continue;
        
        // Parse key=value pairs
        if (sscanf(line, "%[^=]=%s", key, value) == 2) {
            if (strcmp(key, "database_host") == 0) {
                strcpy(config->database_host, value);
            } else if (strcmp(key, "database_port") == 0) {
                config->database_port = atoi(value);
            } else if (strcmp(key, "log_level") == 0) {
                strcpy(config->log_level, value);
            } else if (strcmp(key, "max_connections") == 0) {
                config->max_connections = atoi(value);
            }
        }
    }
    
    fclose(fp);
    return 0;
}

void print_config(const Config *config) {
    printf("Configuration:\n");
    printf("  Database Host: %s\n", config->database_host);
    printf("  Database Port: %d\n", config->database_port);
    printf("  Log Level: %s\n", config->log_level);
    printf("  Max Connections: %d\n", config->max_connections);
}

int main(int argc, char *argv[]) {
    Config config;
    const char *config_file = "app.conf";
    
    // Check for command-line configuration file
    if (argc > 1) {
        config_file = argv[1];
    }
    
    // Load configuration
    if (load_config(config_file, &config) != 0) {
        fprintf(stderr, "Error loading configuration\n");
        exit(EXIT_FAILURE);
    }
    
    // Print configuration
    print_config(&config);
    
    // Use configuration in application
    printf("\nApplication starting with above configuration...\n");
    
    return 0;
}
```

### Process Monitor
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <sys/wait.h>

volatile sig_atomic_t terminate = 0;

void signal_handler(int sig) {
    printf("\nTermination signal received\n");
    terminate = 1;
}

int main(int argc, char *argv[]) {
    pid_t pid;
    int status;
    
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <command>\n", argv[0]);
        exit(EXIT_FAILURE);
    }
    
    // Set up signal handlers
    signal(SIGINT, signal_handler);
    signal(SIGTERM, signal_handler);
    
    printf("Process monitor started\n");
    printf("Monitoring command: %s\n", argv[1]);
    
    while (!terminate) {
        // Fork a child process
        pid = fork();
        
        if (pid == -1) {
            perror("Error forking process");
            exit(EXIT_FAILURE);
        }
        
        if (pid == 0) {
            // Child process - execute the command
            execl("/bin/sh", "sh", "-c", argv[1], (char *)NULL);
            perror("Error executing command");
            exit(EXIT_FAILURE);
        } else {
            // Parent process - wait for child
            printf("Started process with PID %d\n", pid);
            
            // Wait for child to complete
            waitpid(pid, &status, 0);
            
            if (WIFEXITED(status)) {
                printf("Process exited with status %d\n", WEXITSTATUS(status));
            } else if (WIFSIGNALED(status)) {
                printf("Process terminated by signal %d\n", WTERMSIG(status));
            }
            
            // Wait before restarting (unless terminating)
            if (!terminate) {
                printf("Restarting in 5 seconds...\n");
                sleep(5);
            }
        }
    }
    
    printf("Process monitor terminated\n");
    return 0;
}
```

## Full Programs: CLI, Env, Signals, Processes

### Program 1 — Robust argument parser (`opts.c`)

```c
/* file: opts.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Options {
    const char *input;
    const char *output;
    int verbose;
    int count;
};

static void usage(const char *prog) {
    fprintf(stderr,
            "Usage: %s [-v] [-n N] -i input -o output\n"
            "  -v        verbose\n"
            "  -n N      count (default 1)\n"
            "  -i path   input file\n"
            "  -o path   output file\n",
            prog);
}

int main(int argc, char *argv[]) {
    struct Options opt = {NULL, NULL, 0, 1};
    int i;

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-v") == 0) {
            opt.verbose = 1;
        } else if (strcmp(argv[i], "-n") == 0) {
            if (i + 1 >= argc) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            opt.count = atoi(argv[++i]);
            if (opt.count <= 0) {
                fprintf(stderr, "-n must be positive\n");
                return EXIT_FAILURE;
            }
        } else if (strcmp(argv[i], "-i") == 0) {
            if (i + 1 >= argc) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            opt.input = argv[++i];
        } else if (strcmp(argv[i], "-o") == 0) {
            if (i + 1 >= argc) {
                usage(argv[0]);
                return EXIT_FAILURE;
            }
            opt.output = argv[++i];
        } else if (strcmp(argv[i], "-h") == 0 || strcmp(argv[i], "--help") == 0) {
            usage(argv[0]);
            return EXIT_SUCCESS;
        } else {
            fprintf(stderr, "unknown option: %s\n", argv[i]);
            usage(argv[0]);
            return EXIT_FAILURE;
        }
    }

    if (opt.input == NULL || opt.output == NULL) {
        usage(argv[0]);
        return EXIT_FAILURE;
    }

    if (opt.verbose) {
        fprintf(stderr, "in=%s out=%s count=%d\n",
                opt.input, opt.output, opt.count);
    }
    printf("would process %s -> %s (%d times)\n",
           opt.input, opt.output, opt.count);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o opts opts.c
./opts -v -n 3 -i a.txt -o b.txt
./opts -h
./opts -i a.txt          # should fail with usage
```

### Program 2 — Environment-driven config (`envcfg.c`)

```c
/* file: envcfg.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Config {
    const char *home;
    const char *log_level;
    int max_items;
};

static int parse_positive_int(const char *s, int *out) {
    char *end;
    long v;

    if (s == NULL || out == NULL) {
        return -1;
    }
    v = strtol(s, &end, 10);
    if (end == s || *end != '\0' || v <= 0 || v > 1000000L) {
        return -1;
    }
    *out = (int)v;
    return 0;
}

int main(void) {
    struct Config cfg;
    const char *max_s;

    cfg.home = getenv("HOME");
    if (cfg.home == NULL) {
        cfg.home = ".";
    }

    cfg.log_level = getenv("APP_LOG_LEVEL");
    if (cfg.log_level == NULL) {
        cfg.log_level = "INFO";
    }

    max_s = getenv("APP_MAX_ITEMS");
    if (max_s == NULL) {
        cfg.max_items = 100;
    } else if (parse_positive_int(max_s, &cfg.max_items) != 0) {
        fprintf(stderr, "invalid APP_MAX_ITEMS=%s\n", max_s);
        return EXIT_FAILURE;
    }

    printf("home=%s\n", cfg.home);
    printf("log_level=%s\n", cfg.log_level);
    printf("max_items=%d\n", cfg.max_items);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o envcfg envcfg.c
./envcfg
APP_LOG_LEVEL=DEBUG APP_MAX_ITEMS=50 ./envcfg
APP_MAX_ITEMS=nope ./envcfg   # should fail
```

### Program 3 — `atexit` cleanup and `exit` status (`cleanup_demo.c`)

```c
/* file: cleanup_demo.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

static FILE *g_log;

static void close_log(void) {
    if (g_log != NULL) {
        fprintf(g_log, "shutdown\n");
        fclose(g_log);
        g_log = NULL;
        fprintf(stderr, "atexit: log closed\n");
    }
}

int main(int argc, char *argv[]) {
    int fail = (argc > 1 && strcmp(argv[1], "fail") == 0);

    g_log = fopen("app_runtime.log", "w");
    if (g_log == NULL) {
        perror("fopen");
        return EXIT_FAILURE;
    }
    if (atexit(close_log) != 0) {
        fprintf(stderr, "atexit registration failed\n");
        fclose(g_log);
        return EXIT_FAILURE;
    }

    fprintf(g_log, "started\n");
    printf("working...\n");

    if (fail) {
        fprintf(stderr, "failing with exit code 2\n");
        exit(2);  /* still runs atexit handlers */
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o cleanup_demo cleanup_demo.c
./cleanup_demo
cat app_runtime.log
./cleanup_demo fail; echo exit=$?
```

Note: `#include <string.h>` is required for `strcmp` — add it if your compiler rejects the program under pedantic modes.

### Program 4 — Graceful SIGINT shutdown (`sigint_loop.c`)

```c
/* file: sigint_loop.c */
#include <stdio.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <string.h>

static volatile sig_atomic_t g_stop = 0;

static void on_sigint(int signo) {
    (void)signo;
    g_stop = 1;
}

int main(void) {
    struct sigaction sa;
    unsigned long ticks = 0;

    memset(&sa, 0, sizeof sa);
    sa.sa_handler = on_sigint;
    sigemptyset(&sa.sa_mask);
    sa.sa_flags = 0;  /* no SA_RESTART: sleep may return early */

    if (sigaction(SIGINT, &sa, NULL) != 0) {
        perror("sigaction");
        return EXIT_FAILURE;
    }

    printf("pid=%d — press Ctrl+C to stop\n", (int)getpid());
    while (!g_stop) {
        printf("tick %lu\n", ticks++);
        sleep(1);
    }
    printf("clean shutdown after %lu ticks\n", ticks);
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o sigint_loop sigint_loop.c
./sigint_loop
# Ctrl+C → clean message
```

### Program 5 — `fork` + `exec` + `wait` mini runner (`run_cmd.c`)

```c
/* file: run_cmd.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <errno.h>

int main(int argc, char *argv[]) {
    pid_t pid;
    int status;

    if (argc < 2) {
        fprintf(stderr, "Usage: %s <command> [args...]\n", argv[0]);
        return EXIT_FAILURE;
    }

    pid = fork();
    if (pid < 0) {
        perror("fork");
        return EXIT_FAILURE;
    }

    if (pid == 0) {
        /* child */
        execvp(argv[1], &argv[1]);
        fprintf(stderr, "execvp %s: %s\n", argv[1], strerror(errno));
        _exit(127);
    }

    /* parent */
    if (waitpid(pid, &status, 0) < 0) {
        perror("waitpid");
        return EXIT_FAILURE;
    }

    if (WIFEXITED(status)) {
        printf("child exited %d\n", WEXITSTATUS(status));
        return WEXITSTATUS(status);
    }
    if (WIFSIGNALED(status)) {
        printf("child killed by signal %d\n", WTERMSIG(status));
        return 128 + WTERMSIG(status);
    }
    return EXIT_FAILURE;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o run_cmd run_cmd.c
./run_cmd echo hello from child
./run_cmd false; echo status=$?
./run_cmd /no/such/cmd; echo status=$?
```

### Program 6 — Echo lines with PID and env prefix (`line_echo.c`)

```c
/* file: line_echo.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

int main(void) {
    char line[256];
    const char *prefix = getenv("LINE_PREFIX");
    pid_t pid = getpid();

    if (prefix == NULL) {
        prefix = "";
    }

    while (fgets(line, sizeof line, stdin) != NULL) {
        /* strip newline for formatting */
        line[strcspn(line, "\n")] = '\0';
        printf("%s[pid=%d] %s\n", prefix, (int)pid, line);
        fflush(stdout);
    }
    if (ferror(stdin)) {
        perror("stdin");
        return EXIT_FAILURE;
    }
    return EXIT_SUCCESS;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o line_echo line_echo.c
printf 'a\nb\n' | LINE_PREFIX='>>' ./line_echo
```

---

## Exercises

```bash
gcc -std=c17 -Wall -Wextra -o exN exN.c
```

1. **`opts` long form** — Accept `--input=path` and `--verbose` in addition to short flags.

2. **Required env** — Fail startup if `APP_TOKEN` is unset or empty; print a clear error to stderr.

3. **Double atexit** — Register two `atexit` handlers; show they run in reverse order of registration.

4. **SIGTERM too** — Extend `sigint_loop` to stop on `SIGTERM` as well as `SIGINT` (one handler, two `sigaction` calls).

5. **Pipeline** — Use `run_cmd` to run `ls` and then `true`/`false`; document exit codes in a comment.

6. **Avoid `system()`** — Replace a `system("ls -l")` sketch with `fork`/`execvp`/`waitpid` for fixed argv `{"ls","-l",NULL}`.

7. **Argv0 banner** — Print only the basename of `argv[0]` (after last `/`) as the program name in usage errors.

8. **Timeout sketch** — After `fork`, parent uses `alarm(2)` or a timed wait strategy (research `sigtimedwait` or poll loop) to kill a hanging child — advanced stretch.

---

## Summary

System-level programming in C provides powerful capabilities for interacting with the operating system:

1. **Command-Line Arguments**: Processing `argc` and `argv` for flexible program configuration
2. **Environment Variables**: Accessing system configuration through `getenv()`, `setenv()`, and `unsetenv()`
3. **Process Management**: Controlling program termination with `exit()` and cleanup with `atexit()`
4. **Signal Handling**: Responding to system events and interrupts gracefully (`sig_atomic_t`, `sigaction`)
5. **Process control**: `fork`, `exec*`, `waitpid` for running and supervising programs
6. **System Calls**: Executing shell commands carefully (`system` is convenient but shells inject risk)

These system-level programming concepts are essential for developing robust, production-ready C applications that can adapt to different environments and handle various runtime conditions effectively.