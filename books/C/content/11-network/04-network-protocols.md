# Network Protocols

## Introduction

Network protocols define the rules and conventions for communication between network devices. Understanding and implementing common network protocols is essential for developing robust network applications. This chapter covers the implementation of widely-used protocols such as HTTP, FTP, DNS, and others in C.

## HTTP Protocol Implementation

HTTP (HyperText Transfer Protocol) is the foundation of data communication on the World Wide Web. Understanding HTTP is crucial for developing web applications and services.

### HTTP Request Structure

An HTTP request consists of:
1. **Request Line** - Method, URI, and HTTP version
2. **Headers** - Key-value pairs providing metadata
3. **Body** - Optional data (for POST, PUT requests)

Example HTTP GET request:
```
GET /index.html HTTP/1.1
Host: www.example.com
User-Agent: Mozilla/5.0
Accept: text/html
Connection: close

```

### HTTP Response Structure

An HTTP response consists of:
1. **Status Line** - HTTP version, status code, and reason phrase
2. **Headers** - Key-value pairs providing metadata
3. **Body** - Response content

Example HTTP response:
```
HTTP/1.1 200 OK
Content-Type: text/html
Content-Length: 1234
Connection: close

<HTML>...</HTML>
```

### Simple HTTP Client

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define BUFFER_SIZE 4096

int create_socket(const char *hostname, int port) {
    int sockfd;
    struct hostent *server;
    struct sockaddr_in serv_addr;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("ERROR opening socket");
        return -1;
    }
    
    // Get server IP address
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr, "ERROR, no such host\n");
        return -1;
    }
    
    // Configure server address
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    memcpy(server->h_addr, &serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(port);
    
    // Connect to server
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("ERROR connecting");
        return -1;
    }
    
    return sockfd;
}

int http_get(const char *hostname, const char *path) {
    int sockfd;
    char request[BUFFER_SIZE];
    char response[BUFFER_SIZE];
    int bytes_sent, bytes_received;
    
    // Create socket and connect
    sockfd = create_socket(hostname, 80);
    if (sockfd < 0) {
        return -1;
    }
    
    // Create HTTP GET request
    snprintf(request, BUFFER_SIZE,
             "GET %s HTTP/1.1\r\n"
             "Host: %s\r\n"
             "Connection: close\r\n"
             "\r\n",
             path, hostname);
    
    // Send request
    bytes_sent = send(sockfd, request, strlen(request), 0);
    if (bytes_sent < 0) {
        perror("ERROR sending request");
        close(sockfd);
        return -1;
    }
    
    printf("HTTP Request sent:\n%s", request);
    
    // Receive response
    while ((bytes_received = recv(sockfd, response, BUFFER_SIZE - 1, 0)) > 0) {
        response[bytes_received] = '\0';
        printf("%s", response);
    }
    
    if (bytes_received < 0) {
        perror("ERROR receiving response");
        close(sockfd);
        return -1;
    }
    
    close(sockfd);
    return 0;
}

int main() {
    const char *hostname = "httpbin.org";
    const char *path = "/get";
    
    printf("Sending HTTP GET request to %s%s\n", hostname, path);
    http_get(hostname, path);
    
    return 0;
}
```

### Simple HTTP Server

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
#define BUFFER_SIZE 4096

void send_http_response(int client_fd, const char *status, const char *content_type, const char *body) {
    char response[BUFFER_SIZE];
    time_t now;
    char time_str[100];
    
    // Get current time
    time(&now);
    strftime(time_str, sizeof(time_str), "%a, %d %b %Y %H:%M:%S GMT", gmtime(&now));
    
    // Create HTTP response
    int content_length = strlen(body);
    snprintf(response, BUFFER_SIZE,
             "HTTP/1.1 %s\r\n"
             "Date: %s\r\n"
             "Server: SimpleHTTPServer/1.0\r\n"
             "Content-Type: %s\r\n"
             "Content-Length: %d\r\n"
             "Connection: close\r\n"
             "\r\n"
             "%s",
             status, time_str, content_type, content_length, body);
    
    // Send response
    send(client_fd, response, strlen(response), 0);
}

void handle_request(int client_fd, const char *request) {
    printf("Received request:\n%s\n", request);
    
    // Parse request line (first line)
    char method[16], path[256], version[16];
    if (sscanf(request, "%15s %255s %15s", method, path, version) != 3) {
        send_http_response(client_fd, "400 Bad Request", "text/plain", "Bad Request");
        return;
    }
    
    // Handle different HTTP methods and paths
    if (strcmp(method, "GET") == 0) {
        if (strcmp(path, "/") == 0 || strcmp(path, "/index.html") == 0) {
            const char *html = 
                "<!DOCTYPE html>\n"
                "<html>\n"
                "<head><title>Simple HTTP Server</title></head>\n"
                "<body><h1>Welcome to Simple HTTP Server</h1>\n"
                "<p>This is a simple HTTP server implemented in C.</p>\n"
                "</body>\n"
                "</html>";
            send_http_response(client_fd, "200 OK", "text/html", html);
        } else if (strcmp(path, "/api/time") == 0) {
            time_t now = time(NULL);
            char time_str[100];
            snprintf(time_str, sizeof(time_str), "{\"time\": \"%s\"}", ctime(&now));
            send_http_response(client_fd, "200 OK", "application/json", time_str);
        } else {
            const char *not_found = 
                "<!DOCTYPE html>\n"
                "<html>\n"
                "<head><title>404 Not Found</title></head>\n"
                "<body><h1>404 Not Found</h1>\n"
                "<p>The requested resource was not found.</p>\n"
                "</body>\n"
                "</html>";
            send_http_response(client_fd, "404 Not Found", "text/html", not_found);
        }
    } else {
        send_http_response(client_fd, "405 Method Not Allowed", "text/plain", "Method Not Allowed");
    }
}

int main() {
    int server_fd, client_fd;
    struct sockaddr_in address;
    int opt = 1;
    int addrlen = sizeof(address);
    char buffer[BUFFER_SIZE];
    
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
    if (listen(server_fd, 10) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("HTTP Server listening on port %d\n", PORT);
    
    while (1) {
        // Accept connection
        if ((client_fd = accept(server_fd, (struct sockaddr *)&address,
                               (socklen_t*)&addrlen)) < 0) {
            perror("accept");
            continue;
        }
        
        // Read request
        int bytes_read = read(client_fd, buffer, BUFFER_SIZE - 1);
        if (bytes_read > 0) {
            buffer[bytes_read] = '\0';
            handle_request(client_fd, buffer);
        }
        
        // Close client connection
        close(client_fd);
    }
    
    close(server_fd);
    return 0;
}
```

## FTP Protocol Implementation

FTP (File Transfer Protocol) is a standard network protocol used for transferring files between a client and server on a computer network.

### FTP Client Implementation

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define BUFFER_SIZE 1024
#define FTP_PORT 21

int ftp_connect(const char *hostname, int port) {
    int sockfd;
    struct hostent *server;
    struct sockaddr_in serv_addr;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("ERROR opening socket");
        return -1;
    }
    
    // Get server IP address
    server = gethostbyname(hostname);
    if (server == NULL) {
        fprintf(stderr, "ERROR, no such host\n");
        return -1;
    }
    
    // Configure server address
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    memcpy(server->h_addr, &serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(port);
    
    // Connect to server
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("ERROR connecting");
        return -1;
    }
    
    return sockfd;
}

int ftp_login(int sockfd, const char *username, const char *password) {
    char buffer[BUFFER_SIZE];
    int bytes_received;
    
    // Read welcome message
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }
    
    // Send USER command
    snprintf(buffer, BUFFER_SIZE, "USER %s\r\n", username);
    send(sockfd, buffer, strlen(buffer), 0);
    
    // Read response
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
    }
    
    // Send PASS command
    snprintf(buffer, BUFFER_SIZE, "PASS %s\r\n", password);
    send(sockfd, buffer, strlen(buffer), 0);
    
    // Read response
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
        
        // Check if login was successful
        if (strncmp(buffer, "230", 3) == 0) {
            return 0; // Success
        }
    }
    
    return -1; // Failure
}

int ftp_list(int sockfd) {
    char buffer[BUFFER_SIZE];
    
    // Send LIST command
    snprintf(buffer, BUFFER_SIZE, "LIST\r\n");
    send(sockfd, buffer, strlen(buffer), 0);
    
    // Read response
    int bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("%s", buffer);
        return 0;
    }
    
    return -1;
}

int main() {
    int sockfd;
    const char *hostname = "ftp.example.com"; // Replace with actual FTP server
    const char *username = "anonymous";
    const char *password = "user@example.com";
    
    printf("Connecting to FTP server: %s\n", hostname);
    
    // Connect to FTP server
    sockfd = ftp_connect(hostname, FTP_PORT);
    if (sockfd < 0) {
        exit(EXIT_FAILURE);
    }
    
    // Login to FTP server
    if (ftp_login(sockfd, username, password) < 0) {
        printf("FTP login failed\n");
        close(sockfd);
        exit(EXIT_FAILURE);
    }
    
    printf("FTP login successful\n");
    
    // List directory contents
    printf("Directory listing:\n");
    ftp_list(sockfd);
    
    // Close connection
    close(sockfd);
    return 0;
}
```

## DNS Protocol Implementation

DNS (Domain Name System) translates domain names to IP addresses. Understanding DNS is important for network programming.

### Simple DNS Resolver

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

// DNS header structure
struct dns_header {
    unsigned short id;       // identification number
    unsigned short flags;    // flags
    unsigned short qdcount;  // number of question entries
    unsigned short ancount;  // number of answer entries
    unsigned short nscount;  // number of authority entries
    unsigned short arcount;  // number of resource entries
};

// DNS question structure
struct dns_question {
    unsigned short qtype;
    unsigned short qclass;
};

// Function to convert domain name to DNS format
void dns_format(unsigned char* dns, unsigned char* host) {
    int lock = 0, i;
    strcat((char*)host, ".");
    
    for(i = 0; i < strlen((char*)host); i++) {
        if(host[i] == '.') {
            *dns++ = i - lock;
            for(; lock < i; lock++) {
                *dns++ = host[lock];
            }
            lock++;
        }
    }
    *dns++ = '\0';
}

int dns_query(const char *hostname) {
    int sockfd;
    struct sockaddr_in dest;
    unsigned char buf[65536];
    struct dns_header *dns = NULL;
    struct dns_question *qinfo = NULL;
    
    // Create UDP socket
    sockfd = socket(AF_INET, SOCK_DGRAM, IPPROTO_UDP);
    if (sockfd < 0) {
        perror("socket creation failed");
        return -1;
    }
    
    // Configure destination address (Google DNS)
    dest.sin_family = AF_INET;
    dest.sin_port = htons(53);
    dest.sin_addr.s_addr = inet_addr("8.8.8.8");
    
    // Set up DNS header
    dns = (struct dns_header *)&buf;
    dns->id = (unsigned short)htons(getpid());
    dns->flags = htons(0x0100); // Standard query
    dns->qdcount = htons(1);    // One question
    dns->ancount = 0;
    dns->nscount = 0;
    dns->arcount = 0;
    
    // Set up question section
    unsigned char *qname = (unsigned char*)&buf[sizeof(struct dns_header)];
    dns_format(qname, (unsigned char*)hostname);
    
    qinfo = (struct dns_question*)&buf[sizeof(struct dns_header) + strlen((char*)qname) + 1];
    qinfo->qtype = htons(1);  // Type A (IPv4 address)
    qinfo->qclass = htons(1); // Class IN (Internet)
    
    // Send DNS query
    int packet_size = sizeof(struct dns_header) + strlen((char*)qname) + 1 + sizeof(struct dns_question);
    if (sendto(sockfd, (char*)buf, packet_size, 0, (struct sockaddr*)&dest, sizeof(dest)) < 0) {
        perror("sendto failed");
        close(sockfd);
        return -1;
    }
    
    // Receive DNS response
    socklen_t dest_len = sizeof(dest);
    int received_bytes = recvfrom(sockfd, (char*)buf, 65536, 0, (struct sockaddr*)&dest, &dest_len);
    if (received_bytes < 0) {
        perror("recvfrom failed");
        close(sockfd);
        return -1;
    }
    
    // Parse DNS response
    dns = (struct dns_header*)buf;
    printf("DNS Response:\n");
    printf("  ID: %d\n", ntohs(dns->id));
    printf("  Questions: %d\n", ntohs(dns->qdcount));
    printf("  Answers: %d\n", ntohs(dns->ancount));
    
    // Extract IP addresses from answer section
    unsigned char *reader = &buf[sizeof(struct dns_header) + strlen((char*)qname) + 1 + sizeof(struct dns_question)];
    
    for(int i = 0; i < ntohs(dns->ancount); i++) {
        // Skip name (for simplicity, assuming it's a pointer)
        reader += 2; // Skip name pointer
        
        unsigned short type = ntohs(*(unsigned short*)reader);
        reader += 2;
        
        unsigned short class = ntohs(*(unsigned short*)reader);
        reader += 2;
        
        unsigned int ttl = ntohl(*(unsigned int*)reader);
        reader += 4;
        
        unsigned short data_len = ntohs(*(unsigned short*)reader);
        reader += 2;
        
        if (type == 1 && class == 1) { // Type A, Class IN
            unsigned char ip[4];
            for(int j = 0; j < 4; j++) {
                ip[j] = *reader++;
            }
            printf("  IP Address: %d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
        } else {
            reader += data_len;
        }
    }
    
    close(sockfd);
    return 0;
}

int main() {
    const char *hostname = "google.com";
    
    printf("Resolving hostname: %s\n", hostname);
    dns_query(hostname);
    
    return 0;
}
```

## SMTP Protocol Implementation

SMTP (Simple Mail Transfer Protocol) is used for sending emails. Here's a simple SMTP client implementation:

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

#define BUFFER_SIZE 1024
#define SMTP_PORT 25

int smtp_connect(const char *smtp_server) {
    int sockfd;
    struct hostent *server;
    struct sockaddr_in serv_addr;
    
    // Create socket
    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) {
        perror("ERROR opening socket");
        return -1;
    }
    
    // Get server IP address
    server = gethostbyname(smtp_server);
    if (server == NULL) {
        fprintf(stderr, "ERROR, no such host\n");
        return -1;
    }
    
    // Configure server address
    memset(&serv_addr, 0, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    memcpy(server->h_addr, &serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(SMTP_PORT);
    
    // Connect to server
    if (connect(sockfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0) {
        perror("ERROR connecting");
        return -1;
    }
    
    return sockfd;
}

int smtp_send_command(int sockfd, const char *command) {
    char buffer[BUFFER_SIZE];
    int bytes_sent, bytes_received;
    
    // Send command
    bytes_sent = send(sockfd, command, strlen(command), 0);
    if (bytes_sent < 0) {
        perror("ERROR sending command");
        return -1;
    }
    
    // Receive response
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Server: %s", buffer);
        return 0;
    }
    
    return -1;
}

int smtp_send_email(const char *smtp_server, const char *from, const char *to, 
                   const char *subject, const char *body) {
    int sockfd;
    char command[BUFFER_SIZE];
    
    // Connect to SMTP server
    sockfd = smtp_connect(smtp_server);
    if (sockfd < 0) {
        return -1;
    }
    
    // Read server greeting
    char buffer[BUFFER_SIZE];
    int bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Server: %s", buffer);
    }
    
    // Send HELO command
    snprintf(command, BUFFER_SIZE, "HELO localhost\r\n");
    smtp_send_command(sockfd, command);
    
    // Send MAIL FROM command
    snprintf(command, BUFFER_SIZE, "MAIL FROM:<%s>\r\n", from);
    smtp_send_command(sockfd, command);
    
    // Send RCPT TO command
    snprintf(command, BUFFER_SIZE, "RCPT TO:<%s>\r\n", to);
    smtp_send_command(sockfd, command);
    
    // Send DATA command
    snprintf(command, BUFFER_SIZE, "DATA\r\n");
    smtp_send_command(sockfd, command);
    
    // Send email content
    snprintf(command, BUFFER_SIZE, 
             "From: %s\r\n"
             "To: %s\r\n"
             "Subject: %s\r\n"
             "\r\n"
             "%s\r\n"
             ".\r\n",
             from, to, subject, body);
    send(sockfd, command, strlen(command), 0);
    
    // Read response
    bytes_received = recv(sockfd, buffer, BUFFER_SIZE - 1, 0);
    if (bytes_received > 0) {
        buffer[bytes_received] = '\0';
        printf("Server: %s", buffer);
    }
    
    // Send QUIT command
    snprintf(command, BUFFER_SIZE, "QUIT\r\n");
    smtp_send_command(sockfd, command);
    
    close(sockfd);
    return 0;
}

int main() {
    const char *smtp_server = "smtp.example.com"; // Replace with actual SMTP server
    const char *from = "sender@example.com";
    const char *to = "recipient@example.com";
    const char *subject = "Test Email";
    const char *body = "This is a test email sent from a C program.";
    
    printf("Sending email via SMTP...\n");
    smtp_send_email(smtp_server, from, to, subject, body);
    
    return 0;
}
```

## Practical Examples

### Protocol Analyzer

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netinet/ip.h>
#include <netinet/tcp.h>
#include <netinet/udp.h>
#include <netinet/ip_icmp.h>

void analyze_ip_packet(const unsigned char *buffer, int size) {
    struct iphdr *iph = (struct iphdr*)buffer;
    
    printf("IP Header\n");
    printf("   |-Version           : %d\n", (unsigned int)iph->version);
    printf("   |-Internet Header Length : %d DWORDS or %d Bytes\n", 
           (unsigned int)iph->ihl, ((unsigned int)(iph->ihl))*4);
    printf("   |-Type Of Service   : %d\n", (unsigned int)iph->tos);
    printf("   |-Total Length      : %d Bytes\n", ntohs(iph->tot_len));
    printf("   |-Identification    : %d\n", ntohs(iph->id));
    printf("   |-Time To Live      : %d\n", (unsigned int)iph->ttl);
    printf("   |-Protocol          : %d\n", (unsigned int)iph->protocol);
    printf("   |-Header Checksum   : %d\n", ntohs(iph->check));
    printf("   |-Source IP         : %s\n", inet_ntoa(*(struct in_addr*)&iph->saddr));
    printf("   |-Destination IP    : %s\n", inet_ntoa(*(struct in_addr*)&iph->daddr));
    
    // Analyze protocol-specific headers
    switch (iph->protocol) {
        case 6: // TCP
            printf("TCP Protocol\n");
            break;
        case 17: // UDP
            printf("UDP Protocol\n");
            break;
        case 1: // ICMP
            printf("ICMP Protocol\n");
            break;
        default:
            printf("Other Protocol\n");
            break;
    }
}

int main() {
    int sockfd;
    unsigned char buffer[65536];
    struct sockaddr_in dest;
    socklen_t dest_len = sizeof(dest);
    
    // Create raw socket (requires root privileges)
    sockfd = socket(AF_INET, SOCK_RAW, IPPROTO_TCP);
    if (sockfd < 0) {
        perror("socket creation failed (try running as root)");
        exit(EXIT_FAILURE);
    }
    
    printf("Protocol Analyzer started...\n");
    
    // Capture packets
    while (1) {
        int packet_size = recvfrom(sockfd, buffer, 65536, 0, (struct sockaddr*)&dest, &dest_len);
        if (packet_size < 0) {
            perror("recvfrom failed");
            continue;
        }
        
        printf("\n----------------------------------------\n");
        analyze_ip_packet(buffer, packet_size);
        printf("----------------------------------------\n");
    }
    
    close(sockfd);
    return 0;
}
```

## Summary

Network protocol implementation in C involves understanding and working with various standard protocols:

1. **HTTP** - The foundation of web communication with request/response patterns
2. **FTP** - File transfer protocol for uploading and downloading files
3. **DNS** - Domain name resolution system
4. **SMTP** - Email transmission protocol
5. **Protocol Analysis** - Examining network packets at the protocol level

Key concepts for protocol implementation:
- Understanding protocol message formats and structures
- Properly formatting requests and parsing responses
- Handling different protocol states and error conditions
- Managing connections and data flow
- Implementing security considerations

These implementations form the basis for more complex network applications and services. The next chapter will cover network security considerations and best practices.