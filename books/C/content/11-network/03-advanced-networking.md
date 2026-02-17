# Advanced Networking

## Introduction

Advanced networking concepts build upon the fundamentals of socket programming to create more sophisticated and efficient network applications. This chapter covers non-blocking I/O, multiplexing with select/poll, concurrent server architectures, and other advanced techniques that are essential for building scalable network applications.

## Non-blocking I/O

Non-blocking I/O allows a program to continue execution while waiting for network operations to complete, rather than blocking until the operation finishes.

### Setting Non-blocking Mode

There are two main ways to set a socket to non-blocking mode:

1. **Using fcntl()**:
```c
#include <fcntl.h>

int flags = fcntl(sockfd, F_GETFL, 0);
fcntl(sockfd, F_SETFL, flags | O_NONBLOCK);
```

2. **Using ioctl()**:
```c
#include <sys/ioctl.h>

int nonblocking = 1;
ioctl(sockfd, FIONBIO, &nonblocking);
```

### Non-blocking Socket Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <errno.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int sockfd;
    struct sockaddr_in server_addr;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket to non-blocking mode
    int flags = fcntl(sockfd, F_GETFL, 0);
    if (fcntl(sockfd, F_SETFL, flags | O_NONBLOCK) < 0) {
        perror("fcntl failed");
        exit(EXIT_FAILURE);
    }
    
    // Configure server address
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(80);
    server_addr.sin_addr.s_addr = inet_addr("93.184.216.34"); // example.com
    
    // Attempt to connect (will likely return immediately with EINPROGRESS)
    int result = connect(sockfd, (struct sockaddr*)&server_addr, sizeof(server_addr));
    
    if (result < 0) {
        if (errno == EINPROGRESS) {
            printf("Connection in progress...\n");
            // Use select() or poll() to wait for connection completion
        } else {
            perror("connect failed");
            close(sockfd);
            exit(EXIT_FAILURE);
        }
    }
    
    close(sockfd);
    return 0;
}
```

## I/O Multiplexing

I/O multiplexing allows a single process to monitor multiple file descriptors, waiting until one or more of them become "ready" for I/O operations.

### select()

The `select()` function monitors multiple file descriptors to see if any of them are ready for I/O:

```c
#include <sys/select.h>

int select(int nfds, fd_set *readfds, fd_set *writefds,
           fd_set *exceptfds, struct timeval *timeout);
```

### Example: Using select() for Multiple Clients

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define MAX_CLIENTS 30
#define BUFFER_SIZE 1024

int main() {
    int server_fd, new_socket, client_socket[MAX_CLIENTS], max_clients = MAX_CLIENTS;
    int activity, i, valread, sd;
    int max_sd;
    struct sockaddr_in address;
    
    char buffer[BUFFER_SIZE];
    
    fd_set readfds;
    
    // Initialize all client_socket[] to 0 (not valid)
    for (i = 0; i < max_clients; i++) {
        client_socket[i] = 0;
    }
    
    // Create socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set master socket to allow multiple connections
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, sizeof(opt)) < 0) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Listener on port %d\n", PORT);
    
    // Listen for connections
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    // Accept connections
    int addrlen = sizeof(address);
    puts("Waiting for connections...");
    
    while (1) {
        // Clear the socket set
        FD_ZERO(&readfds);
        
        // Add master socket to set
        FD_SET(server_fd, &readfds);
        max_sd = server_fd;
        
        // Add child sockets to set
        for (i = 0; i < max_clients; i++) {
            // Socket descriptor
            sd = client_socket[i];
            
            // If valid socket descriptor then add to read list
            if (sd > 0)
                FD_SET(sd, &readfds);
            
            // Highest file descriptor number, needed for select()
            if (sd > max_sd)
                max_sd = sd;
        }
        
        // Wait for an activity on one of the sockets
        activity = select(max_sd + 1, &readfds, NULL, NULL, NULL);
        
        if ((activity < 0) && (errno != EINTR)) {
            printf("select error");
        }
        
        // If something happened on the master socket, then it's an incoming connection
        if (FD_ISSET(server_fd, &readfds)) {
            if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
                perror("accept");
                exit(EXIT_FAILURE);
            }
            
            // Inform user of socket number
            printf("New connection, socket fd is %d, ip is : %s, port : %d\n",
                   new_socket, inet_ntoa(address.sin_addr), ntohs(address.sin_port));
            
            // Add new socket to array of sockets
            for (i = 0; i < max_clients; i++) {
                // If position is empty
                if (client_socket[i] == 0) {
                    client_socket[i] = new_socket;
                    printf("Adding to list of sockets as %d\n", i);
                    break;
                }
            }
        }
        
        // Else it's some IO operation on some other socket
        for (i = 0; i < max_clients; i++) {
            sd = client_socket[i];
            
            if (FD_ISSET(sd, &readfds)) {
                // Check if it was for closing, and also read the incoming message
                if ((valread = read(sd, buffer, BUFFER_SIZE)) == 0) {
                    // Somebody disconnected, get his details and print
                    getpeername(sd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
                    printf("Host disconnected, ip %s, port %d\n",
                           inet_ntoa(address.sin_addr), ntohs(address.sin_port));
                    
                    // Close the socket and mark as 0 in list for reuse
                    close(sd);
                    client_socket[i] = 0;
                } else {
                    // Set the string terminating NULL byte on the end of the data read
                    buffer[valread] = '\0';
                    send(sd, buffer, strlen(buffer), 0);
                }
            }
        }
    }
    
    return 0;
}
```

### poll()

The `poll()` function provides similar functionality to `select()` but with some advantages:

```c
#include <poll.h>

int poll(struct pollfd *fds, nfds_t nfds, int timeout);
```

### Example: Using poll()

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <poll.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define MAX_CLIENTS 30
#define BUFFER_SIZE 1024

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int addrlen = sizeof(address);
    
    struct pollfd fds[MAX_CLIENTS + 1];
    int nfds = 1; // Only server socket initially
    
    // Initialize pollfd structure
    for (int i = 0; i < MAX_CLIENTS + 1; i++) {
        fds[i].fd = -1;
        fds[i].events = POLLIN;
    }
    
    // Create server socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, sizeof(opt)) < 0) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind and listen
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    // Add server socket to poll
    fds[0].fd = server_fd;
    fds[0].events = POLLIN;
    
    printf("Server listening on port %d\n", PORT);
    
    while (1) {
        int poll_count = poll(fds, nfds, -1);
        
        if (poll_count == -1) {
            perror("poll");
            exit(EXIT_FAILURE);
        }
        
        // Check server socket for new connections
        if (fds[0].revents & POLLIN) {
            if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
                perror("accept");
                exit(EXIT_FAILURE);
            }
            
            printf("New connection, socket fd is %d\n", new_socket);
            
            // Add new socket to poll array
            int i;
            for (i = 1; i < MAX_CLIENTS + 1; i++) {
                if (fds[i].fd == -1) {
                    fds[i].fd = new_socket;
                    nfds = (i + 1 > nfds) ? i + 1 : nfds;
                    break;
                }
            }
            
            if (i == MAX_CLIENTS + 1) {
                printf("Too many clients\n");
                close(new_socket);
            }
        }
        
        // Check client sockets for data
        for (int i = 1; i < nfds; i++) {
            if (fds[i].fd != -1 && (fds[i].revents & POLLIN)) {
                char buffer[BUFFER_SIZE];
                int valread = read(fds[i].fd, buffer, BUFFER_SIZE);
                
                if (valread == 0) {
                    // Client disconnected
                    printf("Client disconnected, socket fd %d\n", fds[i].fd);
                    close(fds[i].fd);
                    fds[i].fd = -1;
                } else {
                    // Echo data back
                    buffer[valread] = '\0';
                    printf("Received: %s", buffer);
                    send(fds[i].fd, buffer, valread, 0);
                }
            }
        }
    }
    
    return 0;
}
```

## Concurrent Server Architectures

### Threading Approach

Using threads to handle multiple clients concurrently:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <pthread.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

void *handle_client(void *arg) {
    int client_fd = *(int*)arg;
    char buffer[BUFFER_SIZE];
    int valread;
    
    // Detach thread to automatically clean up when finished
    pthread_detach(pthread_self());
    
    // Free the argument (allocated in main)
    free(arg);
    
    // Handle client communication
    while ((valread = read(client_fd, buffer, BUFFER_SIZE)) > 0) {
        buffer[valread] = '\0';
        printf("Received from client: %s", buffer);
        
        // Echo back to client
        send(client_fd, buffer, valread, 0);
        
        // Exit if client sends "quit"
        if (strncmp(buffer, "quit", 4) == 0) {
            break;
        }
    }
    
    printf("Client disconnected\n");
    close(client_fd);
    return NULL;
}

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    
    // Create server socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                   &opt, sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for connections
    if (listen(server_fd, 10) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d\n", PORT);
    
    while (1) {
        // Accept connection
        if ((client_fd = accept(server_fd, (struct sockaddr *)&address,
                               (socklen_t*)&addrlen)) < 0) {
            perror("accept");
            continue;
        }
        
        printf("New client connected\n");
        
        // Create thread to handle client
        pthread_t thread_id;
        int *new_sock = malloc(sizeof(int));
        *new_sock = client_fd;
        
        if (pthread_create(&thread_id, NULL, handle_client, (void*)new_sock) < 0) {
            perror("could not create thread");
            free(new_sock);
            close(client_fd);
        }
    }
    
    close(server_fd);
    return 0;
}
```

### Forking Approach

Using processes to handle multiple clients:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/wait.h>

#define PORT 8080
#define BUFFER_SIZE 1024

void handle_client(int client_fd) {
    char buffer[BUFFER_SIZE];
    int valread;
    
    while ((valread = read(client_fd, buffer, BUFFER_SIZE)) > 0) {
        buffer[valread] = '\0';
        printf("Received from client: %s", buffer);
        
        // Echo back to client
        send(client_fd, buffer, valread, 0);
        
        // Exit if client sends "quit"
        if (strncmp(buffer, "quit", 4) == 0) {
            break;
        }
    }
    
    printf("Client disconnected\n");
    close(client_fd);
    exit(0);
}

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    
    // Create server socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                   &opt, sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind socket
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for connections
    if (listen(server_fd, 10) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d\n", PORT);
    
    while (1) {
        // Accept connection
        if ((client_fd = accept(server_fd, (struct sockaddr *)&address,
                               (socklen_t*)&addrlen)) < 0) {
            perror("accept");
            continue;
        }
        
        printf("New client connected\n");
        
        // Fork child process to handle client
        pid_t pid = fork();
        
        if (pid < 0) {
            perror("fork failed");
            close(client_fd);
        } else if (pid == 0) {
            // Child process
            close(server_fd); // Close listening socket in child
            handle_client(client_fd);
        } else {
            // Parent process
            close(client_fd); // Close client socket in parent
            // Clean up zombie processes
            while (waitpid(-1, NULL, WNOHANG) > 0);
        }
    }
    
    close(server_fd);
    return 0;
}
```

## Advanced Socket Options

### Socket Buffer Sizes

Adjusting socket buffer sizes can improve performance:

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>

int main() {
    int sockfd;
    int buffer_size;
    socklen_t len = sizeof(buffer_size);
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Get current receive buffer size
    if (getsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &buffer_size, &len) < 0) {
        perror("getsockopt failed");
        exit(EXIT_FAILURE);
    }
    printf("Default receive buffer size: %d bytes\n", buffer_size);
    
    // Get current send buffer size
    if (getsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &buffer_size, &len) < 0) {
        perror("getsockopt failed");
        exit(EXIT_FAILURE);
    }
    printf("Default send buffer size: %d bytes\n", buffer_size);
    
    // Set new buffer sizes
    buffer_size = 64 * 1024; // 64KB
    if (setsockopt(sockfd, SOL_SOCKET, SO_RCVBUF, &buffer_size, sizeof(buffer_size)) < 0) {
        perror("setsockopt SO_RCVBUF failed");
        exit(EXIT_FAILURE);
    }
    
    if (setsockopt(sockfd, SOL_SOCKET, SO_SNDBUF, &buffer_size, sizeof(buffer_size)) < 0) {
        perror("setsockopt SO_SNDBUF failed");
        exit(EXIT_FAILURE);
    }
    
    printf("New buffer sizes set to %d bytes\n", buffer_size);
    
    close(sockfd);
    return 0;
}
```

### Timeout Options

Setting timeouts for socket operations:

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <time.h>

int main() {
    int sockfd;
    struct timeval timeout;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Set receive timeout
    timeout.tv_sec = 5;  // 5 seconds
    timeout.tv_usec = 0;
    
    if (setsockopt(sockfd, SOL_SOCKET, SO_RCVTIMEO, &timeout, sizeof(timeout)) < 0) {
        perror("setsockopt SO_RCVTIMEO failed");
        exit(EXIT_FAILURE);
    }
    
    // Set send timeout
    timeout.tv_sec = 3;  // 3 seconds
    
    if (setsockopt(sockfd, SOL_SOCKET, SO_SNDTIMEO, &timeout, sizeof(timeout)) < 0) {
        perror("setsockopt SO_SNDTIMEO failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Socket timeouts set successfully\n");
    
    close(sockfd);
    return 0;
}
```

## Signal-Driven I/O

Signal-driven I/O allows a process to be notified when a socket is ready for I/O operations:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <fcntl.h>

int sockfd;

void signal_handler(int sig) {
    if (sig == SIGIO) {
        printf("Socket is ready for I/O\n");
        // Handle I/O operations here
    }
}

int main() {
    struct sockaddr_in address;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket to non-blocking
    int flags = fcntl(sockfd, F_GETFL, 0);
    fcntl(sockfd, F_SETFL, flags | O_NONBLOCK);
    
    // Set up signal handler
    signal(SIGIO, signal_handler);
    
    // Enable asynchronous I/O on socket
    if (fcntl(sockfd, F_SETOWN, getpid()) < 0) {
        perror("fcntl F_SETOWN failed");
        exit(EXIT_FAILURE);
    }
    
    if (fcntl(sockfd, F_SETFL, flags | O_ASYNC) < 0) {
        perror("fcntl F_SETFL O_ASYNC failed");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    memset(&address, 0, sizeof(address));
    address.sin_family = AF_INET;
    address.sin_port = htons(80);
    address.sin_addr.s_addr = inet_addr("93.184.216.34"); // example.com
    
    // Attempt to connect
    connect(sockfd, (struct sockaddr*)&address, sizeof(address));
    
    // Main loop
    while (1) {
        pause(); // Wait for signals
    }
    
    close(sockfd);
    return 0;
}
```

## Practical Examples

### High-Performance Echo Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/select.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

#define PORT 8080
#define MAX_CLIENTS 100
#define BUFFER_SIZE 4096

typedef struct {
    int fd;
    char buffer[BUFFER_SIZE];
    int buffer_pos;
    int buffer_len;
} client_t;

int main() {
    int server_fd;
    struct sockaddr_in address;
    client_t clients[MAX_CLIENTS];
    int max_clients = MAX_CLIENTS;
    fd_set read_fds, write_fds;
    int max_fd;
    
    // Initialize client structures
    for (int i = 0; i < max_clients; i++) {
        clients[i].fd = -1;
        clients[i].buffer_pos = 0;
        clients[i].buffer_len = 0;
    }
    
    // Create server socket
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Set socket options
    int opt = 1;
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, (char *)&opt, sizeof(opt)) < 0) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind and listen
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    if (listen(server_fd, 10) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("High-performance echo server listening on port %d\n", PORT);
    
    while (1) {
        // Clear file descriptor sets
        FD_ZERO(&read_fds);
        FD_ZERO(&write_fds);
        
        // Add server socket to read set
        FD_SET(server_fd, &read_fds);
        max_fd = server_fd;
        
        // Add client sockets to appropriate sets
        for (int i = 0; i < max_clients; i++) {
            if (clients[i].fd > 0) {
                FD_SET(clients[i].fd, &read_fds);
                
                // If we have data to send, add to write set
                if (clients[i].buffer_len > 0) {
                    FD_SET(clients[i].fd, &write_fds);
                }
                
                if (clients[i].fd > max_fd) {
                    max_fd = clients[i].fd;
                }
            }
        }
        
        // Wait for activity
        int activity = select(max_fd + 1, &read_fds, &write_fds, NULL, NULL);
        
        if (activity < 0 && errno != EINTR) {
            perror("select error");
            exit(EXIT_FAILURE);
        }
        
        // Check for new connections
        if (FD_ISSET(server_fd, &read_fds)) {
            int new_socket;
            int addrlen = sizeof(address);
            
            if ((new_socket = accept(server_fd, (struct sockaddr *)&address, (socklen_t*)&addrlen)) < 0) {
                perror("accept");
                continue;
            }
            
            // Add new socket to clients array
            int i;
            for (i = 0; i < max_clients; i++) {
                if (clients[i].fd == -1) {
                    clients[i].fd = new_socket;
                    clients[i].buffer_pos = 0;
                    clients[i].buffer_len = 0;
                    printf("New connection: socket %d\n", new_socket);
                    break;
                }
            }
            
            if (i == max_clients) {
                printf("Too many clients, closing new connection\n");
                close(new_socket);
            }
        }
        
        // Check for data from clients
        for (int i = 0; i < max_clients; i++) {
            int sd = clients[i].fd;
            
            if (sd < 0) continue;
            
            // Check for data to read
            if (FD_ISSET(sd, &read_fds)) {
                int valread = read(sd, clients[i].buffer + clients[i].buffer_len, 
                                  BUFFER_SIZE - clients[i].buffer_len);
                
                if (valread <= 0) {
                    // Client disconnected
                    getpeername(sd, (struct sockaddr*)&address, (socklen_t*)&addrlen);
                    printf("Client disconnected: %s:%d\n", 
                           inet_ntoa(address.sin_addr), ntohs(address.sin_port));
                    close(sd);
                    clients[i].fd = -1;
                    clients[i].buffer_pos = 0;
                    clients[i].buffer_len = 0;
                } else {
                    // Add data to buffer
                    clients[i].buffer_len += valread;
                    printf("Received %d bytes from client\n", valread);
                }
            }
            
            // Check for ability to write
            if (sd > 0 && FD_ISSET(sd, &write_fds) && clients[i].buffer_len > 0) {
                int to_send = clients[i].buffer_len - clients[i].buffer_pos;
                int sent = write(sd, clients[i].buffer + clients[i].buffer_pos, to_send);
                
                if (sent < 0) {
                    if (errno != EAGAIN && errno != EWOULDBLOCK) {
                        printf("Write error, closing connection\n");
                        close(sd);
                        clients[i].fd = -1;
                        clients[i].buffer_pos = 0;
                        clients[i].buffer_len = 0;
                    }
                } else {
                    clients[i].buffer_pos += sent;
                    
                    // If we've sent all data, reset buffer
                    if (clients[i].buffer_pos >= clients[i].buffer_len) {
                        clients[i].buffer_pos = 0;
                        clients[i].buffer_len = 0;
                    }
                }
            }
        }
    }
    
    return 0;
}
```

## Summary

Advanced networking concepts in C include:

1. **Non-blocking I/O** - Preventing programs from blocking on network operations
2. **I/O Multiplexing** - Using `select()` and `poll()` to handle multiple connections
3. **Concurrent Servers** - Implementing threading and forking approaches for handling multiple clients
4. **Advanced Socket Options** - Configuring buffer sizes, timeouts, and other socket parameters
5. **Signal-Driven I/O** - Using signals to notify when sockets are ready for I/O

These techniques are essential for building high-performance, scalable network applications. The next chapter will cover specific network protocols and their implementation in C.