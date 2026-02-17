# Module 11: Network Programming Exercises

## Exercise 1: Basic Socket Programming
Write a program that demonstrates fundamental socket operations:
- Create and configure TCP and UDP sockets
- Implement basic client-server communication
- Handle socket binding, listening, and connection acceptance
- Send and receive data through sockets
- Properly close and cleanup socket resources

**Requirements:**
- Implement both TCP and UDP examples
- Include proper error handling for all socket operations
- Handle cross-platform differences (Windows vs Unix)
- Implement timeout handling for socket operations
- Provide clear examples of client-server interaction

## Exercise 2: HTTP Client Implementation
Create a program that implements a simple HTTP client:
- Parse URLs and extract host, port, and path components
- Establish HTTP connections to web servers
- Send HTTP GET and POST requests
- Parse HTTP response headers and status codes
- Handle chunked transfer encoding and content length

**Requirements:**
- Implement proper HTTP/1.1 protocol compliance
- Include support for common HTTP headers
- Handle redirects and authentication (basic)
- Implement connection reuse for multiple requests
- Include proper error handling for network issues

## Exercise 3: Multi-client Server
Develop a program that implements a server handling multiple clients:
- Use fork() or threading to handle concurrent clients
- Implement connection pooling for efficient resource usage
- Handle client disconnections gracefully
- Include client session management
- Implement basic rate limiting and security measures

**Requirements:**
- Handle race conditions with proper synchronization
- Include timeout mechanisms for inactive clients
- Implement proper resource cleanup for terminated clients
- Provide logging and monitoring capabilities
- Include comprehensive error handling

## Exercise 4: Network Protocol Implementation
Write a program that implements custom network protocols:
- Design and implement a simple chat protocol
- Create a file transfer protocol with checksum verification
- Implement a simple remote command execution protocol
- Include protocol versioning and compatibility
- Handle protocol state management

**Requirements:**
- Define clear protocol specifications
- Include proper message framing and parsing
- Implement error recovery mechanisms
- Handle network byte order conversion
- Provide protocol documentation and examples

## Exercise 5: Advanced Networking Concepts
Create a program that demonstrates advanced networking features:
- Implement non-blocking I/O with select() or poll()
- Use epoll() or kqueue() for high-performance I/O (Linux/BSD)
- Implement socket timeouts and keep-alive mechanisms
- Handle network address resolution and DNS lookups
- Include IPv6 support alongside IPv4

**Requirements:**
- Include performance comparisons between different I/O models
- Handle partial reads and writes correctly
- Implement proper signal handling for network applications
- Include network interface enumeration and monitoring
- Provide cross-platform compatibility

## Exercise 6: Network Security Implementation
Write a program that implements basic network security:
- Implement simple encryption/decryption functions
- Create secure communication channels with basic cryptography
- Handle certificate validation and SSL/TLS (bonus)
- Implement basic authentication mechanisms
- Include secure key exchange protocols

**Requirements:**
- Use established cryptographic libraries (OpenSSL, etc.)
- Include proper random number generation
- Handle key management and storage securely
- Implement secure session establishment
- Provide security best practices documentation

## Exercise 7: Network Debugging and Monitoring
Create a program that provides network debugging capabilities:
- Implement packet capture and analysis (bonus)
- Create network performance monitoring tools
- Develop connection state tracking and logging
- Include bandwidth measurement and reporting
- Implement network error diagnosis tools

**Requirements:**
- Include comprehensive logging and tracing
- Provide real-time monitoring capabilities
- Handle large volumes of network data efficiently
- Include visualization of network statistics
- Document debugging techniques and tools

## Exercise 8: Comprehensive Network Application
Design a complete network application that integrates all concepts:
- Implement a distributed system with multiple network components
- Create a peer-to-peer file sharing network
- Develop a simple web server with dynamic content
- Include network service discovery and registration
- Provide comprehensive testing and validation

**Requirements:**
- Use modular design with clear separation of concerns
- Include proper documentation for all components
- Handle all network resource management properly
- Implement robust error handling throughout
- Provide clear examples and test cases

## Solutions and Tips

### Exercise 1 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    #pragma comment(lib, "ws2_32.lib")
#else
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netinet/in.h>
    #include <netdb.h>
#endif

// Cross-platform socket definitions
#ifdef _WIN32
    typedef SOCKET socket_t;
    #define CLOSE_SOCKET closesocket
    #define SOCK_ERR SOCKET_ERROR
#else
    typedef int socket_t;
    #define CLOSE_SOCKET close
    #define SOCK_ERR -1
#endif

// Function to initialize sockets (Windows specific)
int initialize_sockets(void) {
#ifdef _WIN32
    WSADATA wsaData;
    int result = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (result != 0) {
        printf("WSAStartup failed: %d\n", result);
        return 0;
    }
#endif
    return 1;
}

// Function to cleanup sockets (Windows specific)
void cleanup_sockets(void) {
#ifdef _WIN32
    WSACleanup();
#endif
}

// Function to create TCP socket
socket_t create_tcp_socket(void) {
    socket_t sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == SOCK_ERR) {
        perror("Socket creation failed");
    }
    return sock;
}

// Function to create UDP socket
socket_t create_udp_socket(void) {
    socket_t sock = socket(AF_INET, SOCK_DGRAM, 0);
    if (sock == SOCK_ERR) {
        perror("UDP Socket creation failed");
    }
    return sock;
}

// Simple TCP server example
int tcp_server_example(int port) {
    if (!initialize_sockets()) return -1;
    
    socket_t server_sock = create_tcp_socket();
    if (server_sock == SOCK_ERR) {
        cleanup_sockets();
        return -1;
    }
    
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(port);
    
    if (bind(server_sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == SOCK_ERR) {
        perror("Bind failed");
        CLOSE_SOCKET(server_sock);
        cleanup_sockets();
        return -1;
    }
    
    if (listen(server_sock, 5) == SOCK_ERR) {
        perror("Listen failed");
        CLOSE_SOCKET(server_sock);
        cleanup_sockets();
        return -1;
    }
    
    printf("TCP Server listening on port %d\n", port);
    
    struct sockaddr_in client_addr;
    socklen_t client_len = sizeof(client_addr);
    socket_t client_sock = accept(server_sock, (struct sockaddr*)&client_addr, &client_len);
    
    if (client_sock != SOCK_ERR) {
        char buffer[1024];
        int bytes_received = recv(client_sock, buffer, sizeof(buffer) - 1, 0);
        if (bytes_received > 0) {
            buffer[bytes_received] = '\0';
            printf("Received: %s\n", buffer);
            
            const char *response = "Hello from TCP server!";
            send(client_sock, response, strlen(response), 0);
        }
        CLOSE_SOCKET(client_sock);
    }
    
    CLOSE_SOCKET(server_sock);
    cleanup_sockets();
    return 0;
}

// Simple TCP client example
int tcp_client_example(const char *server_ip, int port) {
    if (!initialize_sockets()) return -1;
    
    socket_t client_sock = create_tcp_socket();
    if (client_sock == SOCK_ERR) {
        cleanup_sockets();
        return -1;
    }
    
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    
    if (inet_pton(AF_INET, server_ip, &server_addr.sin_addr) <= 0) {
        printf("Invalid address\n");
        CLOSE_SOCKET(client_sock);
        cleanup_sockets();
        return -1;
    }
    
    if (connect(client_sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == SOCK_ERR) {
        perror("Connection failed");
        CLOSE_SOCKET(client_sock);
        cleanup_sockets();
        return -1;
    }
    
    const char *message = "Hello from TCP client!";
    send(client_sock, message, strlen(message), 0);
    
    char buffer[1024];
    int bytes_received = recv(client_sock, buffer, sizeof(buffer) - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Received: %s\n", buffer);
    }
    
    CLOSE_SOCKET(client_sock);
    cleanup_sockets();
    return 0;
}

int main() {
    // Note: For testing, you would run the server and client separately
    // This is just an example of how to structure the code
    
    printf("Network Programming Examples\n");
    printf("Run tcp_server_example() in one terminal\n");
    printf("Run tcp_client_example() in another terminal\n");
    
    return 0;
}
```

### Exercise 2 Solution Example:
```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    #pragma comment(lib, "ws2_32.lib")
#else
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netinet/in.h>
    #include <netdb.h>
#endif

#ifdef _WIN32
    typedef SOCKET socket_t;
    #define CLOSE_SOCKET closesocket
    #define SOCK_ERR SOCKET_ERROR
#else
    typedef int socket_t;
    #define CLOSE_SOCKET close
    #define SOCK_ERR -1
#endif

// URL parsing structure
typedef struct {
    char protocol[16];
    char host[256];
    int port;
    char path[512];
} URL;

// Function to parse URL
int parse_url(const char *url_str, URL *url) {
    // Simple URL parsing (supports http://host:port/path)
    if (sscanf(url_str, "%15[^:]://%255[^:/]:%d%511s", 
               url->protocol, url->host, &url->port, url->path) == 4) {
        return 0;
    }
    
    // Try without port
    if (sscanf(url_str, "%15[^:]://%255[^/]%511s", 
               url->protocol, url->host, url->path) == 3) {
        url->port = (strcmp(url->protocol, "https") == 0) ? 443 : 80;
        return 0;
    }
    
    return -1;
}

// Simple HTTP GET request
int http_get_request(const char *url_str) {
#ifdef _WIN32
    WSADATA wsaData;
    if (WSAStartup(MAKEWORD(2, 2), &wsaData) != 0) {
        return -1;
    }
#endif
    
    URL url;
    if (parse_url(url_str, &url) != 0) {
        printf("Failed to parse URL: %s\n", url_str);
#ifdef _WIN32
        WSACleanup();
#endif
        return -1;
    }
    
    // Create socket
    socket_t sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == SOCK_ERR) {
        perror("Socket creation failed");
#ifdef _WIN32
        WSACleanup();
#endif
        return -1;
    }
    
    // Resolve hostname
    struct hostent *host = gethostbyname(url.host);
    if (host == NULL) {
        printf("Failed to resolve hostname: %s\n", url.host);
        CLOSE_SOCKET(sock);
#ifdef _WIN32
        WSACleanup();
#endif
        return -1;
    }
    
    // Connect to server
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(url.port);
    memcpy(&server_addr.sin_addr, host->h_addr_list[0], host->h_length);
    
    if (connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr)) == SOCK_ERR) {
        perror("Connection failed");
        CLOSE_SOCKET(sock);
#ifdef _WIN32
        WSACleanup();
#endif
        return -1;
    }
    
    // Send HTTP GET request
    char request[1024];
    snprintf(request, sizeof(request),
             "GET %s HTTP/1.1\r\n"
             "Host: %s:%d\r\n"
             "Connection: close\r\n"
             "\r\n",
             url.path, url.host, url.port);
    
    if (send(sock, request, strlen(request), 0) == SOCK_ERR) {
        perror("Send failed");
        CLOSE_SOCKET(sock);
#ifdef _WIN32
        WSACleanup();
#endif
        return -1;
    }
    
    // Receive response
    char buffer[4096];
    int bytes_received;
    while ((bytes_received = recv(sock, buffer, sizeof(buffer) - 1, 0)) > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }
    
    CLOSE_SOCKET(sock);
#ifdef _WIN32
    WSACleanup();
#endif
    return 0;
}

int main() {
    const char *url = "http://httpbin.org/get";
    printf("Making HTTP GET request to: %s\n\n", url);
    
    if (http_get_request(url) != 0) {
        printf("HTTP request failed\n");
        return 1;
    }
    
    return 0;
}
```

### Common Pitfalls to Avoid:
1. **Platform differences**: Handle Windows and Unix socket API differences
2. **Resource leaks**: Always close sockets and cleanup network libraries
3. **Buffer overflows**: Check buffer sizes when receiving network data
4. **Blocking operations**: Handle timeouts to prevent hanging applications
5. **Error handling**: Check return values from all network functions

### Best Practices:
1. **Cross-platform compatibility**: Use conditional compilation for platform differences
2. **Resource management**: Implement proper cleanup in error paths
3. **Security considerations**: Validate all network input and use secure protocols
4. **Performance optimization**: Use appropriate I/O models for scalability
5. **Error recovery**: Implement robust error handling and recovery mechanisms

Complete these exercises to solidify your understanding of network programming in C. Each exercise builds upon the previous ones, gradually increasing in complexity.