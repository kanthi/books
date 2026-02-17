# Socket Programming

## Introduction

Socket programming is the foundation of network communication in C. Sockets provide an interface for applications to communicate over a network using various protocols such as TCP and UDP. This chapter covers the essential concepts and functions needed to create network applications using sockets.

## Socket Basics

A socket is an endpoint for communication between two machines over a network. In Unix-like systems, sockets are treated as file descriptors, allowing the use of standard I/O functions for network communication.

### Socket Creation

The first step in socket programming is creating a socket using the `socket()` function:

```c
#include <sys/socket.h>

int socket(int domain, int type, int protocol);
```

**Parameters:**
- `domain`: Communication domain (e.g., AF_INET for IPv4, AF_INET6 for IPv6)
- `type`: Communication type (e.g., SOCK_STREAM for TCP, SOCK_DGRAM for UDP)
- `protocol`: Specific protocol (usually 0 for default)

**Return Value:**
- Socket file descriptor on success
- -1 on error

### Example Socket Creation

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

int main() {
    int server_fd;
    
    // Create TCP socket
    server_fd = socket(AF_INET, SOCK_STREAM, 0);
    if (server_fd == -1) {
        perror("Socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Socket created successfully with file descriptor: %d\n", server_fd);
    
    // Close socket
    close(server_fd);
    return 0;
}
```

## Socket Address Structures

Different address structures are used for different address families:

### IPv4 Address Structure

```c
struct sockaddr_in {
    sa_family_t    sin_family; // Address family (AF_INET)
    in_port_t      sin_port;   // Port number (network byte order)
    struct in_addr sin_addr;   // IP address (network byte order)
    char           sin_zero[8]; // Padding to match sockaddr size
};
```

### Generic Socket Address Structure

```c
struct sockaddr {
    sa_family_t sa_family;     // Address family
    char        sa_data[14];   // Address data
};
```

## Server-Side Socket Programming

Creating a server involves several steps: socket creation, binding, listening, and accepting connections.

### Binding a Socket

The `bind()` function associates a socket with a specific address and port:

```c
#include <sys/socket.h>

int bind(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

### Listening for Connections

The `listen()` function makes a socket listen for incoming connections:

```c
int listen(int sockfd, int backlog);
```

### Accepting Connections

The `accept()` function accepts an incoming connection:

```c
int accept(int sockfd, struct sockaddr *addr, socklen_t *addrlen);
```

### Complete TCP Server Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int server_fd, new_socket;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE] = {0};
    char *hello = "Hello from server";
    
    // Create socket file descriptor
    if ((server_fd = socket(AF_INET, SOCK_STREAM, 0)) == 0) {
        perror("socket failed");
        exit(EXIT_FAILURE);
    }
    
    // Forcefully attaching socket to the port
    if (setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR | SO_REUSEPORT,
                   &opt, sizeof(opt))) {
        perror("setsockopt");
        exit(EXIT_FAILURE);
    }
    
    // Configure address structure
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = INADDR_ANY;
    address.sin_port = htons(PORT);
    
    // Bind the socket to the network address and port
    if (bind(server_fd, (struct sockaddr *)&address, sizeof(address)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    // Listen for incoming connections
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Server listening on port %d\n", PORT);
    
    // Accept incoming connection
    if ((new_socket = accept(server_fd, (struct sockaddr *)&address,
                           (socklen_t*)&addrlen)) < 0) {
        perror("accept");
        exit(EXIT_FAILURE);
    }
    
    // Read message from client
    int valread = read(new_socket, buffer, BUFFER_SIZE);
    printf("Client: %s\n", buffer);
    
    // Send message to client
    send(new_socket, hello, strlen(hello), 0);
    printf("Hello message sent\n");
    
    // Close sockets
    close(new_socket);
    close(server_fd);
    
    return 0;
}
```

## Client-Side Socket Programming

Creating a client involves socket creation and connecting to a server.

### Connecting to a Server

The `connect()` function establishes a connection to a server:

```c
#include <sys/socket.h>

int connect(int sockfd, const struct sockaddr *addr, socklen_t addrlen);
```

### Complete TCP Client Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char *hello = "Hello from client";
    char buffer[BUFFER_SIZE] = {0};
    
    // Create socket file descriptor
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("\n Socket creation error \n");
        return -1;
    }
    
    // Configure server address
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    
    // Convert IPv4 and IPv6 addresses from text to binary form
    if(inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("\nInvalid address/ Address not supported \n");
        return -1;
    }
    
    // Connect to server
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("\nConnection Failed \n");
        return -1;
    }
    
    // Send message to server
    send(sock, hello, strlen(hello), 0);
    printf("Hello message sent\n");
    
    // Read message from server
    int valread = read(sock, buffer, BUFFER_SIZE);
    printf("Server: %s\n", buffer);
    
    // Close socket
    close(sock);
    
    return 0;
}
```

## UDP Socket Programming

UDP (User Datagram Protocol) provides connectionless communication. Unlike TCP, there's no need for connection establishment.

### UDP Server Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUFFER_SIZE];
    struct sockaddr_in servaddr, cliaddr;
    
    // Create socket file descriptor
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0 ) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Clear address structures
    memset(&servaddr, 0, sizeof(servaddr));
    memset(&cliaddr, 0, sizeof(cliaddr));
    
    // Configure server address
    servaddr.sin_family = AF_INET;
    servaddr.sin_addr.s_addr = INADDR_ANY;
    servaddr.sin_port = htons(PORT);
    
    // Bind the socket with the server address
    if (bind(sockfd, (const struct sockaddr *)&servaddr, sizeof(servaddr)) < 0) {
        perror("bind failed");
        exit(EXIT_FAILURE);
    }
    
    int len, n;
    n = recvfrom(sockfd, (char *)buffer, BUFFER_SIZE, MSG_WAITALL,
                 (struct sockaddr *) &cliaddr, &len);
    buffer[n] = '\0';
    printf("Client : %s\n", buffer);
    
    char *hello = "Hello from server";
    sendto(sockfd, (const char *)hello, strlen(hello), MSG_CONFIRM,
           (const struct sockaddr *) &cliaddr, len);
    printf("Hello message sent.\n");
    
    close(sockfd);
    return 0;
}
```

### UDP Client Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sockfd;
    char buffer[BUFFER_SIZE];
    struct sockaddr_in servaddr;
    
    // Create socket file descriptor
    if ((sockfd = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Clear server address structure
    memset(&servaddr, 0, sizeof(servaddr));
    
    // Configure server address
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(PORT);
    servaddr.sin_addr.s_addr = INADDR_ANY;
    
    int n;
    char *hello = "Hello from client";
    sendto(sockfd, (const char *)hello, strlen(hello), MSG_CONFIRM,
           (const struct sockaddr *) &servaddr, sizeof(servaddr));
    printf("Hello message sent.\n");
    
    socklen_t len;
    n = recvfrom(sockfd, (char *)buffer, BUFFER_SIZE, MSG_WAITALL,
                 (struct sockaddr *) &servaddr, &len);
    buffer[n] = '\0';
    printf("Server : %s\n", buffer);
    
    close(sockfd);
    return 0;
}
```

## Advanced Socket Options

### Socket Options

The `setsockopt()` and `getsockopt()` functions allow configuration of socket behavior:

```c
#include <sys/socket.h>

int setsockopt(int sockfd, int level, int optname,
               const void *optval, socklen_t optlen);

int getsockopt(int sockfd, int level, int optname,
               void *optval, socklen_t *optlen);
```

### Common Socket Options

1. **SO_REUSEADDR** - Allow reuse of local addresses
2. **SO_KEEPALIVE** - Enable keep-alive messages
3. **SO_LINGER** - Control behavior on close
4. **TCP_NODELAY** - Disable Nagle's algorithm

### Example: Setting Socket Options

```c
#include <stdio.h>
#include <stdlib.h>
#include <sys/socket.h>

int main() {
    int sockfd;
    int opt = 1;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        perror("socket creation failed");
        exit(EXIT_FAILURE);
    }
    
    // Enable socket reuse
    if (setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &opt, sizeof(opt)) == -1) {
        perror("setsockopt SO_REUSEADDR failed");
        exit(EXIT_FAILURE);
    }
    
    // Enable keep-alive
    if (setsockopt(sockfd, SOL_SOCKET, SO_KEEPALIVE, &opt, sizeof(opt)) == -1) {
        perror("setsockopt SO_KEEPALIVE failed");
        exit(EXIT_FAILURE);
    }
    
    printf("Socket options set successfully\n");
    
    close(sockfd);
    return 0;
}
```

## Error Handling in Socket Programming

Proper error handling is crucial in socket programming due to the unreliable nature of networks.

### Common Socket Errors

1. **EACCES** - Permission denied
2. **EADDRINUSE** - Address already in use
3. **ECONNREFUSED** - Connection refused
4. **ETIMEDOUT** - Connection timed out
5. **EHOSTUNREACH** - No route to host

### Robust Error Handling Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <errno.h>

int create_tcp_socket() {
    int sockfd;
    
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd == -1) {
        switch (errno) {
            case EACCES:
                fprintf(stderr, "Permission denied to create socket\n");
                break;
            case EMFILE:
                fprintf(stderr, "Process file descriptor limit reached\n");
                break;
            case ENFILE:
                fprintf(stderr, "System file descriptor limit reached\n");
                break;
            case ENOBUFS:
                fprintf(stderr, "Insufficient buffer space\n");
                break;
            default:
                perror("socket creation failed");
        }
        return -1;
    }
    
    return sockfd;
}

int main() {
    int sockfd = create_tcp_socket();
    if (sockfd == -1) {
        exit(EXIT_FAILURE);
    }
    
    printf("Socket created successfully: %d\n", sockfd);
    close(sockfd);
    return 0;
}
```

## Practical Examples

### Simple Echo Server

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <time.h>

#define PORT 8080
#define BUFFER_SIZE 1024

void handle_client(int client_fd) {
    char buffer[BUFFER_SIZE];
    int bytes_read;
    
    while ((bytes_read = read(client_fd, buffer, BUFFER_SIZE - 1)) > 0) {
        buffer[bytes_read] = '\0';
        printf("Received: %s", buffer);
        
        // Echo back to client
        write(client_fd, buffer, bytes_read);
        
        // Exit if client sends "quit"
        if (strncmp(buffer, "quit", 4) == 0) {
            break;
        }
    }
    
    close(client_fd);
}

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    
    // Create socket
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
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Echo server listening on port %d\n", PORT);
    
    // Accept and handle clients
    while (1) {
        if ((client_fd = accept(server_fd, (struct sockaddr *)&address,
                               (socklen_t*)&addrlen)) < 0) {
            perror("accept");
            continue;
        }
        
        printf("Client connected\n");
        handle_client(client_fd);
        printf("Client disconnected\n");
    }
    
    close(server_fd);
    return 0;
}
```

### Simple Echo Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>

#define PORT 8080
#define BUFFER_SIZE 1024

int main() {
    int sock = 0;
    struct sockaddr_in serv_addr;
    char buffer[BUFFER_SIZE] = {0};
    
    // Create socket
    if ((sock = socket(AF_INET, SOCK_STREAM, 0)) < 0) {
        printf("Socket creation error\n");
        return -1;
    }
    
    // Configure server address
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_port = htons(PORT);
    
    // Convert IPv4 address
    if (inet_pton(AF_INET, "127.0.0.1", &serv_addr.sin_addr) <= 0) {
        printf("Invalid address\n");
        return -1;
    }
    
    // Connect to server
    if (connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        printf("Connection failed\n");
        return -1;
    }
    
    printf("Connected to echo server. Type 'quit' to exit.\n");
    
    // Main loop
    while (1) {
        printf("Enter message: ");
        fgets(buffer, BUFFER_SIZE, stdin);
        
        // Remove newline
        buffer[strcspn(buffer, "\n")] = 0;
        
        // Send message
        send(sock, buffer, strlen(buffer), 0);
        
        // Exit if user types "quit"
        if (strcmp(buffer, "quit") == 0) {
            break;
        }
        
        // Receive echo
        int valread = read(sock, buffer, BUFFER_SIZE);
        buffer[valread] = '\0';
        printf("Echo: %s\n", buffer);
    }
    
    close(sock);
    return 0;
}
```

## Summary

Socket programming in C involves several key concepts:

1. **Socket Creation** - Using `socket()` to create endpoints for communication
2. **Server Programming** - Binding, listening, and accepting connections
3. **Client Programming** - Connecting to servers
4. **TCP vs UDP** - Connection-oriented vs connectionless communication
5. **Socket Options** - Configuring socket behavior with `setsockopt()`
6. **Error Handling** - Properly handling network errors and exceptions

These fundamentals form the basis for building more complex network applications. The next chapter will cover advanced networking concepts such as non-blocking I/O, select/poll, and multiplexing.