/*
 * Module 11 Demonstration Program
 * This program demonstrates all the key concepts from Module 11:
 * - Network fundamentals (OSI model, protocols, addressing)
 * - Socket programming (TCP/UDP sockets, client-server model)
 * - Advanced networking (non-blocking I/O, select, poll)
 * - Network protocols (HTTP, DNS, FTP)
 * - Network security (encryption, authentication)
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#ifdef _WIN32
    #include <winsock2.h>
    #include <ws2tcpip.h>
    #pragma comment(lib, "ws2_32.lib")
#else
    #include <sys/socket.h>
    #include <arpa/inet.h>
    #include <netinet/in.h>
    #include <unistd.h>
    #include <netdb.h>
    #include <pthread.h>
#endif

// Include our custom header files
#include "network_utils.h"

// Function prototypes for demonstration functions
void demonstrate_network_fundamentals(void);
void demonstrate_socket_programming(void);
void demonstrate_advanced_networking(void);
void demonstrate_network_protocols(void);
void demonstrate_network_security(void);

// Helper function to print section separators
static void print_separator(const char *title) {
    printf("\n--- %s ---\n", title);
}

// Simple HTTP server function (for demonstration)
void* simple_http_server(void* arg) {
    int port = *(int*)arg;
    
    if (!initialize_sockets()) {
        return NULL;
    }
    
    socket_t server_sock = create_tcp_socket();
    if (server_sock == SOCK_ERR) {
        cleanup_sockets();
        return NULL;
    }
    
    if (!bind_socket(server_sock, port)) {
        CLOSE_SOCKET(server_sock);
        cleanup_sockets();
        return NULL;
    }
    
    if (!listen_socket(server_sock, 5)) {
        CLOSE_SOCKET(server_sock);
        cleanup_sockets();
        return NULL;
    }
    
    printf("HTTP Server listening on port %d\n", port);
    
    // Accept one connection for demonstration
    struct sockaddr_in client_addr;
    socket_t client_sock = accept_connection(server_sock, &client_addr);
    
    if (client_sock != SOCK_ERR) {
        char buffer[1024];
        int bytes_received = receive_data(client_sock, buffer, sizeof(buffer));
        
        if (bytes_received > 0) {
            printf("Received HTTP request:\n%s\n", buffer);
            
            // Send simple HTTP response
            const char* response = 
                "HTTP/1.1 200 OK\r\n"
                "Content-Type: text/html\r\n"
                "Connection: close\r\n"
                "\r\n"
                "<html><body><h1>Module 11 Network Demo</h1>"
                "<p>This is a simple HTTP server response.</p></body></html>";
            
            send_data(client_sock, response, strlen(response));
        }
        
        close_connection(client_sock);
    }
    
    CLOSE_SOCKET(server_sock);
    cleanup_sockets();
    
    return NULL;
}

/*
 * Main function - entry point of the program
 */
int main() {
    printf("========================================\n");
    printf("  Module 11: Network Programming Demonstration\n");
    printf("           Comprehensive Demo\n");
    printf("========================================\n\n");
    
    demonstrate_network_fundamentals();
    demonstrate_socket_programming();
    demonstrate_advanced_networking();
    demonstrate_network_protocols();
    demonstrate_network_security();
    
    printf("\n========================================\n");
    printf("  Module 11 Demo Completed Successfully\n");
    printf("========================================\n");
    
    return 0;
}

/*
 * Demonstrate network fundamentals
 */
void demonstrate_network_fundamentals() {
    print_separator("Network Fundamentals");
    
    printf("1. OSI Model Layers:\n");
    printf("  Layer 7 - Application: HTTP, FTP, SMTP, DNS\n");
    printf("  Layer 6 - Presentation: SSL/TLS, JPEG, MPEG\n");
    printf("  Layer 5 - Session: RPC, SQL sessions\n");
    printf("  Layer 4 - Transport: TCP, UDP\n");
    printf("  Layer 3 - Network: IP, ICMP, routers\n");
    printf("  Layer 2 - Data Link: Ethernet, WiFi, switches\n");
    printf("  Layer 1 - Physical: Cables, radio waves\n");
    
    printf("\n2. TCP vs UDP:\n");
    printf("  TCP (Transmission Control Protocol):\n");
    printf("    - Connection-oriented\n");
    printf("    - Reliable, guaranteed delivery\n");
    printf("    - Error checking and correction\n");
    printf("    - Flow control and congestion control\n");
    printf("    - Examples: HTTP, FTP, SMTP\n");
    printf("  UDP (User Datagram Protocol):\n");
    printf("    - Connectionless\n");
    printf("    - Unreliable, no guarantee of delivery\n");
    printf("    - Lower overhead\n");
    printf("    - Examples: DNS, VoIP, streaming\n");
    
    printf("\n3. IP Addressing:\n");
    printf("  IPv4: 32-bit address (e.g., 192.168.1.1)\n");
    printf("  IPv6: 128-bit address (e.g., 2001:0db8:85a3:0000:0000:8a2e:0370:7334)\n");
    printf("  Subnetting: Dividing networks into smaller segments\n");
    printf("  CIDR Notation: 192.168.1.0/24\n");
    
    printf("\n4. Ports and Services:\n");
    printf("  Well-known ports: 0-1023\n");
    printf("    - HTTP: 80, HTTPS: 443\n");
    printf("    - FTP: 21, SSH: 22\n");
    printf("    - SMTP: 25, DNS: 53\n");
    printf("  Registered ports: 1024-49151\n");
    printf("  Dynamic/private ports: 49152-65535\n");
}

/*
 * Demonstrate socket programming
 */
void demonstrate_socket_programming() {
    print_separator("Socket Programming");
    
    printf("1. Socket Types:\n");
    printf("  Stream Sockets (SOCK_STREAM): TCP\n");
    printf("  Datagram Sockets (SOCK_DGRAM): UDP\n");
    printf("  Raw Sockets (SOCK_RAW): Direct IP access\n");
    
    printf("\n2. Client-Server Model:\n");
    printf("  Server:\n");
    printf("    1. Create socket\n");
    printf("    2. Bind to address/port\n");
    printf("    3. Listen for connections\n");
    printf("    4. Accept connections\n");
    printf("    5. Communicate with client\n");
    printf("    6. Close connection\n");
    printf("  Client:\n");
    printf("    1. Create socket\n");
    printf("    2. Connect to server\n");
    printf("    3. Communicate with server\n");
    printf("    4. Close connection\n");
    
    printf("\n3. Socket Functions:\n");
    printf("  socket(): Create a socket\n");
    printf("  bind(): Bind socket to address/port\n");
    printf("  listen(): Listen for incoming connections\n");
    printf("  accept(): Accept a connection\n");
    printf("  connect(): Connect to a server\n");
    printf("  send()/recv(): Send/receive data\n");
    printf("  close()/closesocket(): Close socket\n");
    
    // Simple example of socket creation
    printf("\n4. Simple Socket Creation Example:\n");
    if (initialize_sockets()) {
        socket_t sock = create_tcp_socket();
        if (sock != SOCK_ERR) {
            printf("  TCP socket created successfully\n");
            CLOSE_SOCKET(sock);
        } else {
            printf("  Failed to create TCP socket\n");
        }
        cleanup_sockets();
    } else {
        printf("  Failed to initialize sockets\n");
    }
}

/*
 * Demonstrate advanced networking
 */
void demonstrate_advanced_networking() {
    print_separator("Advanced Networking");
    
    printf("1. Non-blocking I/O:\n");
    printf("  - Allows performing other tasks while waiting for network operations\n");
    printf("  - Use fcntl() on Unix or ioctlsocket() on Windows to set non-blocking mode\n");
    printf("  - Check return values for EWOULDBLOCK/EAGAIN\n");
    
    printf("\n2. Select and Poll:\n");
    printf("  select():\n");
    printf("    - Monitors multiple file descriptors\n");
    printf("    - Waits until one or more descriptors are ready\n");
    printf("    - Portable but has limitations (FD_SETSIZE)\n");
    printf("  poll():\n");
    printf("    - Similar to select but more scalable\n");
    printf("    - No hardcoded limit on number of file descriptors\n");
    
    printf("\n3. Multiplexing Techniques:\n");
    printf("  I/O Multiplexing: Handle multiple connections in a single thread\n");
    printf("  Threading: Create a thread per connection\n");
    printf("  Forking: Create a process per connection (Unix)\n");
    printf("  Asynchronous I/O: Initiate operations and get notified when complete\n");
    
    printf("\n4. Buffering Strategies:\n");
    printf("  Line buffering: Flush on newline\n");
    printf("  Block buffering: Flush when buffer is full\n");
    printf("  No buffering: Flush immediately\n");
    
    printf("\n5. Timeout Handling:\n");
    printf("  Use setsockopt() with SO_RCVTIMEO and SO_SNDTIMEO\n");
    printf("  Or use select() with timeout parameter\n");
}

/*
 * Demonstrate network protocols
 */
void demonstrate_network_protocols() {
    print_separator("Network Protocols");
    
    printf("1. HTTP (HyperText Transfer Protocol):\n");
    printf("  Request Methods:\n");
    printf("    - GET: Retrieve resource\n");
    printf("    - POST: Submit data\n");
    printf("    - PUT: Update resource\n");
    printf("    - DELETE: Remove resource\n");
    printf("  Status Codes:\n");
    printf("    - 200 OK\n");
    printf("    - 404 Not Found\n");
    printf("    - 500 Internal Server Error\n");
    
    printf("\n2. DNS (Domain Name System):\n");
    printf("  - Translates domain names to IP addresses\n");
    printf("  - Hierarchical distributed database\n");
    printf("  - Uses UDP port 53\n");
    printf("  - Caching to improve performance\n");
    
    printf("\n3. FTP (File Transfer Protocol):\n");
    printf("  - Two connections: control (port 21) and data\n");
    printf("  - Active mode: server connects to client\n");
    printf("  - Passive mode: client connects to server\n");
    
    printf("\n4. SMTP (Simple Mail Transfer Protocol):\n");
    printf("  - Used for sending emails\n");
    printf("  - Uses TCP port 25\n");
    printf("  - Commands: HELO, MAIL FROM, RCPT TO, DATA\n");
    
    printf("\n5. SSH (Secure Shell):\n");
    printf("  - Secure remote login and command execution\n");
    printf("  - Uses encryption for security\n");
    printf("  - Port 22 by default\n");
    
    printf("\n6. SSL/TLS (Secure Sockets Layer/Transport Layer Security):\n");
    printf("  - Provides encryption and authentication\n");
    printf("  - Used by HTTPS, FTPS, etc.\n");
    printf("  - Certificate-based authentication\n");
}

/*
 * Demonstrate network security
 */
void demonstrate_network_security() {
    print_separator("Network Security");
    
    printf("1. Encryption:\n");
    printf("  Symmetric Encryption:\n");
    printf("    - Same key for encryption and decryption\n");
    printf("    - Examples: AES, DES\n");
    printf("    - Fast but key distribution challenge\n");
    printf("  Asymmetric Encryption:\n");
    printf("    - Public/private key pair\n");
    printf("    - Examples: RSA, ECC\n");
    printf("    - Slower but solves key distribution\n");
    
    printf("\n2. Authentication:\n");
    printf("  Password-based:\n");
    printf("    - Simple but vulnerable to attacks\n");
    printf("  Certificate-based:\n");
    printf("    - Uses digital certificates\n");
    printf("    - More secure but complex\n");
    printf("  Multi-factor:\n");
    printf("    - Combines multiple authentication methods\n");
    
    printf("\n3. Common Attacks:\n");
    printf("  Man-in-the-Middle (MITM):\n");
    printf("    - Attacker intercepts communication\n");
    printf("    - Prevention: Use encryption (SSL/TLS)\n");
    printf("  Denial of Service (DoS/DDoS):\n");
    printf("    - Overwhelm system with requests\n");
    printf("    - Prevention: Rate limiting, firewalls\n");
    printf("  SQL Injection:\n");
    printf("    - Malicious SQL in input data\n");
    printf("    - Prevention: Input validation, parameterized queries\n");
    
    printf("\n4. Security Best Practices:\n");
    printf("  - Validate all input data\n");
    printf("  - Use encryption for sensitive data\n");
    printf("  - Keep software up to date\n");
    printf("  - Use firewalls and intrusion detection\n");
    printf("  - Implement proper error handling\n");
    printf("  - Log security events\n");
    printf("  - Regular security audits\n");
    
    printf("\n5. Secure Coding Practices:\n");
    printf("  - Avoid buffer overflows\n");
    printf("  - Use secure functions (strncpy vs strcpy)\n");
    printf("  - Sanitize user input\n");
    printf("  - Implement proper access controls\n");
    printf("  - Use secure communication protocols\n");
}