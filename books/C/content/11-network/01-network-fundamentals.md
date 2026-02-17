# Network Fundamentals

## Introduction

Network programming is a crucial aspect of modern software development, enabling applications to communicate across local networks and the internet. Understanding the fundamentals of networking is essential for building robust, scalable network applications in C.

This chapter covers the basic concepts of computer networks, network models, protocols, and addressing schemes that form the foundation of network programming.

## Computer Network Basics

A computer network is a collection of interconnected devices that can communicate and share resources. Networks can range from simple point-to-point connections to complex global internetworks like the Internet.

### Network Topologies

Network topology refers to the arrangement of nodes and connections in a network:

1. **Bus Topology** - All devices connected to a single communication line
2. **Star Topology** - All devices connected to a central hub
3. **Ring Topology** - Devices connected in a circular fashion
4. **Mesh Topology** - Devices interconnected with multiple paths
5. **Tree Topology** - Hierarchical structure with root and branches

### Network Types

Networks are classified based on their geographical scope:

1. **PAN (Personal Area Network)** - Small networks for personal devices (Bluetooth, etc.)
2. **LAN (Local Area Network)** - Networks within a building or campus
3. **MAN (Metropolitan Area Network)** - Networks spanning a city
4. **WAN (Wide Area Network)** - Networks spanning large geographical areas
5. **Internet** - Global network of interconnected networks

## OSI and TCP/IP Models

### OSI Model

The Open Systems Interconnection (OSI) model is a conceptual framework that standardizes the functions of a communication system into seven layers:

1. **Physical Layer** - Transmission and reception of raw bit streams
2. **Data Link Layer** - Reliable transmission of data frames between nodes
3. **Network Layer** - Routing and forwarding of data packets
4. **Transport Layer** - Reliable transmission of data between processes
5. **Session Layer** - Managing sessions between applications
6. **Presentation Layer** - Translation, encryption, and compression
7. **Application Layer** - Network services to applications

### TCP/IP Model

The TCP/IP model is a simplified four-layer model that forms the basis of the Internet:

1. **Link Layer** - Corresponds to Physical and Data Link layers of OSI
2. **Internet Layer** - Corresponds to Network layer of OSI (IP protocol)
3. **Transport Layer** - Corresponds to Transport layer of OSI (TCP/UDP protocols)
4. **Application Layer** - Combines Session, Presentation, and Application layers of OSI

## IP Addressing

IP (Internet Protocol) addresses uniquely identify devices on a network. There are two main versions:

### IPv4 Addresses

IPv4 addresses are 32-bit numbers typically expressed in dotted decimal notation (e.g., 192.168.1.1).

#### IPv4 Address Classes

1. **Class A** - First octet: 1-126, Default subnet mask: 255.0.0.0
2. **Class B** - First octet: 128-191, Default subnet mask: 255.255.0.0
3. **Class C** - First octet: 192-223, Default subnet mask: 255.255.255.0
4. **Class D** - First octet: 224-239, Used for multicast
5. **Class E** - First octet: 240-255, Reserved for experimental use

#### Special IPv4 Addresses

- **127.0.0.1** - Loopback address (localhost)
- **0.0.0.0** - Default route or unspecified address
- **255.255.255.255** - Limited broadcast address

### IPv6 Addresses

IPv6 addresses are 128-bit numbers expressed in hexadecimal notation with colons (e.g., 2001:0db8:85a3:0000:0000:8a2e:0370:7334).

#### IPv6 Address Types

1. **Unicast** - Point-to-point communication
2. **Multicast** - One-to-many communication
3. **Anycast** - One-to-nearest communication

## Network Protocols

Protocols define the rules and conventions for communication between network devices.

### TCP (Transmission Control Protocol)

TCP is a connection-oriented, reliable transport protocol that ensures:
- Data delivery in the correct order
- Error detection and correction
- Flow control and congestion control
- Connection establishment and termination

### UDP (User Datagram Protocol)

UDP is a connectionless, unreliable transport protocol that provides:
- Fast, low-overhead communication
- No guarantee of delivery or order
- No flow control or error recovery
- Suitable for real-time applications

### ICMP (Internet Control Message Protocol)

ICMP is used for error reporting and network diagnostics:
- Error messages for unreachable destinations
- Echo request/reply (ping)
- Time exceeded messages

## Port Numbers

Ports identify specific processes or services on a network device. Port numbers are 16-bit values ranging from 0 to 65535.

### Port Categories

1. **Well-known Ports (0-1023)** - Assigned to system processes
   - HTTP: 80
   - HTTPS: 443
   - FTP: 21
   - SSH: 22
   - Telnet: 23

2. **Registered Ports (1024-49151)** - Assigned by IANA for specific services

3. **Dynamic/Private Ports (49152-65535)** - Used for private or temporary purposes

## Socket Fundamentals

A socket is an endpoint for communication between two machines over a network. In C, sockets are represented by file descriptors and provide an interface for network communication.

### Socket Types

1. **Stream Sockets (SOCK_STREAM)** - Connection-oriented, reliable communication (TCP)
2. **Datagram Sockets (SOCK_DGRAM)** - Connectionless, unreliable communication (UDP)
3. **Raw Sockets (SOCK_RAW)** - Direct access to lower-level protocols

### Socket Address Structures

In C, network addresses are represented using structures:

```c
// IPv4 address structure
struct sockaddr_in {
    sa_family_t    sin_family; // Address family (AF_INET)
    in_port_t      sin_port;   // Port number (network byte order)
    struct in_addr sin_addr;   // IP address (network byte order)
};

// Generic socket address structure
struct sockaddr {
    sa_family_t sa_family;
    char        sa_data[14];
};
```

## Byte Order and Conversion Functions

Network protocols use big-endian byte order (network byte order), while most computers use little-endian byte order (host byte order). Conversion functions are needed to ensure compatibility:

### Host to Network Byte Order

```c
#include <arpa/inet.h>

uint32_t htonl(uint32_t hostlong);  // Host to network long
uint16_t htons(uint16_t hostshort); // Host to network short
```

### Network to Host Byte Order

```c
uint32_t ntohl(uint32_t netlong);   // Network to host long
uint16_t ntohs(uint16_t netshort);  // Network to host short
```

## IP Address Conversion Functions

### IPv4 Address Conversion

```c
#include <arpa/inet.h>

// Convert IPv4 address from text to binary form
int inet_pton(int af, const char *src, void *dst);

// Convert IPv4 address from binary to text form
const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);

// Older functions (deprecated but still common)
in_addr_t inet_addr(const char *cp);        // ASCII to network address
char *inet_ntoa(struct in_addr in);         // Network address to ASCII
```

## Network Programming Headers

Network programming in C requires several standard headers:

```c
#include <sys/socket.h>    // Socket functions
#include <netinet/in.h>    // Internet address structures
#include <arpa/inet.h>     // IP address conversion functions
#include <netdb.h>         // Network database operations
#include <sys/types.h>     // System data types
```

## Practical Examples

### IP Address Conversion Example

```c
#include <stdio.h>
#include <stdlib.h>
#include <arpa/inet.h>

int main() {
    char ip_str[] = "192.168.1.100";
    struct in_addr ip_addr;
    
    // Convert string to binary IP address
    if (inet_aton(ip_str, &ip_addr) == 0) {
        printf("Invalid IP address\n");
        exit(EXIT_FAILURE);
    }
    
    printf("IP address: %s\n", ip_str);
    printf("Binary representation: 0x%08x\n", ip_addr.s_addr);
    printf("Network byte order: 0x%08x\n", htonl(ip_addr.s_addr));
    
    // Convert back to string
    char converted_str[INET_ADDRSTRLEN];
    if (inet_ntop(AF_INET, &ip_addr, converted_str, INET_ADDRSTRLEN) == NULL) {
        perror("inet_ntop");
        exit(EXIT_FAILURE);
    }
    
    printf("Converted back: %s\n", converted_str);
    
    return 0;
}
```

### Byte Order Conversion Example

```c
#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

int main() {
    uint32_t host_value = 0x12345678;
    uint16_t port = 8080;
    
    printf("Host byte order:\n");
    printf("  32-bit value: 0x%08x\n", host_value);
    printf("  16-bit port: %u\n", port);
    
    printf("\nNetwork byte order:\n");
    printf("  32-bit value: 0x%08x\n", htonl(host_value));
    printf("  16-bit port: %u\n", htons(port));
    
    printf("\nConverted back to host byte order:\n");
    printf("  32-bit value: 0x%08x\n", ntohl(htonl(host_value)));
    printf("  16-bit port: %u\n", ntohs(htons(port)));
    
    return 0;
}
```

### Simple Network Information Program

```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>

int main() {
    char hostname[256];
    struct hostent *host_entry;
    
    // Get hostname
    if (gethostname(hostname, sizeof(hostname)) == -1) {
        perror("gethostname");
        exit(EXIT_FAILURE);
    }
    
    printf("Hostname: %s\n", hostname);
    
    // Get host information
    host_entry = gethostbyname(hostname);
    if (host_entry == NULL) {
        perror("gethostbyname");
        exit(EXIT_FAILURE);
    }
    
    printf("Official name: %s\n", host_entry->h_name);
    
    // Print aliases
    printf("Aliases: ");
    for (int i = 0; host_entry->h_aliases[i] != NULL; i++) {
        printf("%s ", host_entry->h_aliases[i]);
    }
    printf("\n");
    
    // Print IP addresses
    printf("IP addresses: ");
    for (int i = 0; host_entry->h_addr_list[i] != NULL; i++) {
        struct in_addr *addr = (struct in_addr *)host_entry->h_addr_list[i];
        printf("%s ", inet_ntoa(*addr));
    }
    printf("\n");
    
    return 0;
}
```

## Network Error Handling

Network programming requires careful error handling due to the unreliable nature of networks:

### Common Network Errors

1. **Connection refused** - Server not accepting connections
2. **Host unreachable** - Network path to host is unavailable
3. **Timeout** - Operation took too long to complete
4. **Network unreachable** - No route to destination network
5. **Connection reset** - Connection was forcibly closed

### Error Checking in Network Code

```c
#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <string.h>

// Check for socket errors
if (socket_fd == -1) {
    fprintf(stderr, "Socket creation failed: %s\n", strerror(errno));
    exit(EXIT_FAILURE);
}

// Check for bind errors
if (bind(socket_fd, (struct sockaddr*)&server_addr, sizeof(server_addr)) == -1) {
    fprintf(stderr, "Bind failed: %s\n", strerror(errno));
    close(socket_fd);
    exit(EXIT_FAILURE);
}
```

## Summary

Network fundamentals form the foundation of network programming in C. Key concepts include:

1. **Network Models** - Understanding OSI and TCP/IP models
2. **IP Addressing** - IPv4 and IPv6 addressing schemes
3. **Protocols** - TCP for reliable communication, UDP for fast communication
4. **Sockets** - Endpoints for network communication
5. **Byte Order** - Converting between host and network byte order
6. **Address Conversion** - Converting between text and binary IP addresses

These concepts are essential for developing network applications in C. The next chapter will build upon these fundamentals to implement actual socket programming.