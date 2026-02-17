# Network Security

## Introduction

Network security is a critical aspect of modern network programming. As networks become more complex and interconnected, ensuring the confidentiality, integrity, and availability of data becomes increasingly important. This chapter covers essential network security concepts, encryption techniques, secure communication protocols, and best practices for developing secure network applications in C.

## Security Fundamentals

### CIA Triad

The foundation of information security is based on three core principles:

1. **Confidentiality** - Ensuring that information is accessible only to those authorized to have access
2. **Integrity** - Safeguarding the accuracy and completeness of information and processing methods
3. **Availability** - Ensuring that authorized users have access to information and associated assets when required

### Common Security Threats

1. **Eavesdropping** - Unauthorized interception of network communications
2. **Man-in-the-Middle (MITM)** - Intercepting and potentially altering communication between two parties
3. **Denial of Service (DoS)** - Overwhelming a system to make it unavailable
4. **Injection Attacks** - Inserting malicious code into applications
5. **Buffer Overflows** - Exploiting memory management vulnerabilities

## Cryptography Basics

Cryptography is the practice of securing communication from adversaries. Understanding basic cryptographic concepts is essential for implementing secure network applications.

### Symmetric Encryption

Symmetric encryption uses the same key for both encryption and decryption.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple XOR cipher (for demonstration only - not secure)
void xor_encrypt_decrypt(char *data, size_t data_len, const char *key, size_t key_len) {
    for (size_t i = 0; i < data_len; i++) {
        data[i] ^= key[i % key_len];
    }
}

int main() {
    char message[] = "This is a secret message";
    char key[] = "mykey";
    size_t message_len = strlen(message);
    
    printf("Original message: %s\n", message);
    
    // Encrypt
    xor_encrypt_decrypt(message, message_len, key, strlen(key));
    printf("Encrypted message: ");
    for (size_t i = 0; i < message_len; i++) {
        printf("%02x ", (unsigned char)message[i]);
    }
    printf("\n");
    
    // Decrypt (XOR is symmetric)
    xor_encrypt_decrypt(message, message_len, key, strlen(key));
    printf("Decrypted message: %s\n", message);
    
    return 0;
}
```

### Hash Functions

Hash functions create fixed-size digests of variable-length input data.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple hash function (for demonstration only - not cryptographically secure)
unsigned int simple_hash(const char *str) {
    unsigned int hash = 5381;
    int c;
    
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    }
    
    return hash;
}

int main() {
    const char *message1 = "Hello, World!";
    const char *message2 = "Hello, World!";
    const char *message3 = "Hello, world!";
    
    printf("Hash of '%s': 0x%08x\n", message1, simple_hash(message1));
    printf("Hash of '%s': 0x%08x\n", message2, simple_hash(message2));
    printf("Hash of '%s': 0x%08x\n", message3, simple_hash(message3));
    
    return 0;
}
```

## Secure Socket Layer (SSL/TLS)

SSL/TLS provides secure communication over computer networks. OpenSSL is a widely-used library for implementing SSL/TLS in C applications.

### Installing OpenSSL

```bash
# Ubuntu/Debian
sudo apt-get install libssl-dev

# macOS (with Homebrew)
brew install openssl

# CentOS/RHEL
sudo yum install openssl-devel
```

### Simple HTTPS Client with OpenSSL

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <netdb.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

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

SSL_CTX* init_ssl_ctx() {
    const SSL_METHOD *method;
    SSL_CTX *ctx;
    
    // Initialize OpenSSL
    SSL_library_init();
    SSL_load_error_strings();
    OpenSSL_add_all_algorithms();
    
    // Create SSL method
    method = TLS_client_method();
    
    // Create SSL context
    ctx = SSL_CTX_new(method);
    if (!ctx) {
        ERR_print_errors_fp(stderr);
        exit(EXIT_FAILURE);
    }
    
    return ctx;
}

int https_get(const char *hostname, const char *path) {
    int sockfd;
    SSL_CTX *ctx;
    SSL *ssl;
    char request[BUFFER_SIZE];
    char response[BUFFER_SIZE];
    int bytes_sent, bytes_received;
    
    // Initialize SSL context
    ctx = init_ssl_ctx();
    
    // Create socket and connect
    sockfd = create_socket(hostname, 443);
    if (sockfd < 0) {
        SSL_CTX_free(ctx);
        return -1;
    }
    
    // Create SSL structure
    ssl = SSL_new(ctx);
    SSL_set_fd(ssl, sockfd);
    
    // Perform SSL handshake
    if (SSL_connect(ssl) <= 0) {
        ERR_print_errors_fp(stderr);
        SSL_free(ssl);
        close(sockfd);
        SSL_CTX_free(ctx);
        return -1;
    }
    
    printf("SSL connection established\n");
    printf("SSL version: %s\n", SSL_get_version(ssl));
    printf("Cipher: %s\n", SSL_get_cipher(ssl));
    
    // Create HTTPS GET request
    snprintf(request, BUFFER_SIZE,
             "GET %s HTTP/1.1\r\n"
             "Host: %s\r\n"
             "Connection: close\r\n"
             "\r\n",
             path, hostname);
    
    // Send request over SSL
    bytes_sent = SSL_write(ssl, request, strlen(request));
    if (bytes_sent <= 0) {
        ERR_print_errors_fp(stderr);
        SSL_free(ssl);
        close(sockfd);
        SSL_CTX_free(ctx);
        return -1;
    }
    
    printf("HTTPS Request sent:\n%s", request);
    
    // Receive response over SSL
    while ((bytes_received = SSL_read(ssl, response, BUFFER_SIZE - 1)) > 0) {
        response[bytes_received] = '\0';
        printf("%s", response);
    }
    
    if (bytes_received < 0) {
        ERR_print_errors_fp(stderr);
        SSL_free(ssl);
        close(sockfd);
        SSL_CTX_free(ctx);
        return -1;
    }
    
    // Cleanup
    SSL_free(ssl);
    close(sockfd);
    SSL_CTX_free(ctx);
    
    return 0;
}

int main() {
    const char *hostname = "httpbin.org";
    const char *path = "/get";
    
    printf("Sending HTTPS GET request to %s%s\n", hostname, path);
    https_get(hostname, path);
    
    return 0;
}
```

## Authentication and Authorization

Authentication verifies the identity of users, while authorization determines what resources they can access.

### Simple Authentication System

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <crypt.h>

#define MAX_USERS 100
#define USERNAME_MAX 32
#define PASSWORD_MAX 128

typedef struct {
    char username[USERNAME_MAX];
    char password_hash[PASSWORD_MAX];
} User;

User users[MAX_USERS];
int user_count = 0;

// Add a new user
int add_user(const char *username, const char *password) {
    if (user_count >= MAX_USERS) {
        return -1;
    }
    
    // Hash the password (using crypt - not recommended for production)
    char *salt = "$6$salt$"; // SHA-512 with salt "salt"
    char *hash = crypt(password, salt);
    
    if (hash == NULL) {
        return -1;
    }
    
    strncpy(users[user_count].username, username, USERNAME_MAX - 1);
    strncpy(users[user_count].password_hash, hash, PASSWORD_MAX - 1);
    user_count++;
    
    return 0;
}

// Authenticate a user
int authenticate(const char *username, const char *password) {
    for (int i = 0; i < user_count; i++) {
        if (strcmp(users[i].username, username) == 0) {
            char *salt = users[i].password_hash;
            char *hash = crypt(password, salt);
            
            if (hash != NULL && strcmp(hash, users[i].password_hash) == 0) {
                return 1; // Authentication successful
            }
            return 0; // Wrong password
        }
    }
    return -1; // User not found
}

int main() {
    // Add some users
    add_user("admin", "admin123");
    add_user("user1", "password1");
    add_user("user2", "password2");
    
    // Test authentication
    const char *test_users[] = {"admin", "user1", "unknown"};
    const char *test_passwords[] = {"admin123", "wrongpass", "password1"};
    
    for (int i = 0; i < 3; i++) {
        printf("Authenticating user '%s' with password '%s': ", 
               test_users[i], test_passwords[i]);
        
        int result = authenticate(test_users[i], test_passwords[i]);
        switch (result) {
            case 1:
                printf("SUCCESS\n");
                break;
            case 0:
                printf("FAILED (wrong password)\n");
                break;
            case -1:
                printf("FAILED (user not found)\n");
                break;
        }
    }
    
    return 0;
}
```

## Secure Coding Practices

### Input Validation

Proper input validation is crucial for preventing injection attacks and buffer overflows.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// Validate email address format
int validate_email(const char *email) {
    if (email == NULL) return 0;
    
    int len = strlen(email);
    if (len == 0 || len > 254) return 0;
    
    // Check for @ symbol
    char *at = strchr(email, '@');
    if (at == NULL || at == email || at == email + len - 1) return 0;
    
    // Check for domain part
    char *domain = at + 1;
    if (strlen(domain) == 0) return 0;
    
    // Check for valid characters
    for (int i = 0; i < len; i++) {
        if (!isalnum(email[i]) && email[i] != '@' && email[i] != '.' && 
            email[i] != '-' && email[i] != '_') {
            return 0;
        }
    }
    
    return 1;
}

// Safe string copy with bounds checking
char* safe_strncpy(char *dest, const char *src, size_t dest_size) {
    if (dest == NULL || src == NULL || dest_size == 0) {
        return NULL;
    }
    
    size_t src_len = strlen(src);
    size_t copy_len = (src_len < dest_size - 1) ? src_len : dest_size - 1;
    
    strncpy(dest, src, copy_len);
    dest[copy_len] = '\0';
    
    return dest;
}

int main() {
    // Test email validation
    const char *emails[] = {
        "user@example.com",
        "invalid.email",
        "@example.com",
        "user@",
        "user@.com",
        "valid.email@domain.co.uk"
    };
    
    for (int i = 0; i < 6; i++) {
        printf("Email '%s' is %s\n", 
               emails[i], 
               validate_email(emails[i]) ? "VALID" : "INVALID");
    }
    
    // Test safe string copy
    char dest[10];
    const char *src = "This is a very long string";
    
    printf("\nOriginal source: %s\n", src);
    if (safe_strncpy(dest, src, sizeof(dest)) != NULL) {
        printf("Safe copy result: %s\n", dest);
    } else {
        printf("Safe copy failed\n");
    }
    
    return 0;
}
```

### Buffer Overflow Prevention

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Vulnerable function (DO NOT USE)
void vulnerable_function(char *input) {
    char buffer[10];
    strcpy(buffer, input); // Buffer overflow risk
    printf("Buffer content: %s\n", buffer);
}

// Secure function
void secure_function(const char *input) {
    char buffer[10];
    // Use strncpy with proper bounds checking
    strncpy(buffer, input, sizeof(buffer) - 1);
    buffer[sizeof(buffer) - 1] = '\0'; // Ensure null termination
    printf("Buffer content: %s\n", buffer);
}

// Even more secure using snprintf
void very_secure_function(const char *input) {
    char buffer[10];
    // Use snprintf for guaranteed bounds checking
    snprintf(buffer, sizeof(buffer), "%s", input);
    printf("Buffer content: %s\n", buffer);
}

int main() {
    const char *safe_input = "Hello";
    const char *unsafe_input = "This is a very long string that will cause buffer overflow";
    
    printf("Testing secure function with safe input:\n");
    secure_function(safe_input);
    
    printf("\nTesting secure function with unsafe input:\n");
    secure_function(unsafe_input);
    
    printf("\nTesting very secure function with unsafe input:\n");
    very_secure_function(unsafe_input);
    
    return 0;
}
```

## Firewall and Access Control

### Simple Packet Filter

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define MAX_RULES 100

typedef enum {
    ACTION_ALLOW,
    ACTION_DENY
} action_t;

typedef enum {
    PROTO_TCP,
    PROTO_UDP,
    PROTO_ANY
} protocol_t;

typedef struct {
    action_t action;
    protocol_t protocol;
    unsigned int src_ip;
    unsigned int dst_ip;
    unsigned short src_port;
    unsigned short dst_port;
} rule_t;

rule_t rules[MAX_RULES];
int rule_count = 0;

// Add a firewall rule
int add_rule(action_t action, protocol_t protocol, 
             const char *src_ip, const char *dst_ip,
             unsigned short src_port, unsigned short dst_port) {
    if (rule_count >= MAX_RULES) {
        return -1;
    }
    
    rules[rule_count].action = action;
    rules[rule_count].protocol = protocol;
    // In a real implementation, convert IP strings to network byte order integers
    rules[rule_count].src_ip = 0; // Simplified
    rules[rule_count].dst_ip = 0; // Simplified
    rules[rule_count].src_port = src_port;
    rules[rule_count].dst_port = dst_port;
    
    rule_count++;
    return 0;
}

// Check if a packet should be allowed
int check_packet(protocol_t protocol, unsigned short src_port, unsigned short dst_port) {
    // Check rules in order (first match wins)
    for (int i = 0; i < rule_count; i++) {
        // Simplified matching - in reality, would check IP addresses too
        if ((rules[i].protocol == PROTO_ANY || rules[i].protocol == protocol) &&
            (rules[i].src_port == 0 || rules[i].src_port == src_port) &&
            (rules[i].dst_port == 0 || rules[i].dst_port == dst_port)) {
            
            return (rules[i].action == ACTION_ALLOW) ? 1 : 0;
        }
    }
    
    // Default deny
    return 0;
}

int main() {
    // Add some firewall rules
    add_rule(ACTION_DENY, PROTO_TCP, NULL, NULL, 0, 23);  // Deny Telnet
    add_rule(ACTION_ALLOW, PROTO_TCP, NULL, NULL, 0, 80); // Allow HTTP
    add_rule(ACTION_ALLOW, PROTO_TCP, NULL, NULL, 0, 443); // Allow HTTPS
    add_rule(ACTION_DENY, PROTO_ANY, NULL, NULL, 0, 0);   // Deny everything else
    
    // Test packets
    struct {
        protocol_t protocol;
        unsigned short src_port;
        unsigned short dst_port;
        const char *description;
    } test_packets[] = {
        {PROTO_TCP, 12345, 80, "HTTP request"},
        {PROTO_TCP, 12345, 443, "HTTPS request"},
        {PROTO_TCP, 12345, 23, "Telnet connection"},
        {PROTO_UDP, 12345, 53, "DNS query"}
    };
    
    for (int i = 0; i < 4; i++) {
        int allowed = check_packet(test_packets[i].protocol,
                                  test_packets[i].src_port,
                                  test_packets[i].dst_port);
        
        printf("Packet: %s -> %s\n", 
               test_packets[i].description,
               allowed ? "ALLOWED" : "DENIED");
    }
    
    return 0;
}
```

## Secure Communication Patterns

### Mutual Authentication

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Simple mutual authentication protocol
typedef struct {
    char client_id[32];
    char server_id[32];
    unsigned char nonce[16]; // Random number
    unsigned char session_key[32];
} auth_context_t;

// Generate random nonce (simplified)
void generate_nonce(unsigned char *nonce, size_t len) {
    // In a real implementation, use a cryptographically secure random number generator
    for (size_t i = 0; i < len; i++) {
        nonce[i] = rand() % 256;
    }
}

// Simple HMAC-like function (for demonstration only)
void simple_hmac(const char *key, const char *message, unsigned char *digest) {
    // In a real implementation, use a proper HMAC function
    unsigned int hash = 5381;
    const char *ptr = key;
    
    while (*ptr) {
        hash = ((hash << 5) + hash) + *ptr++;
    }
    
    ptr = message;
    while (*ptr) {
        hash = ((hash << 5) + hash) + *ptr++;
    }
    
    // Convert to byte array
    for (int i = 0; i < 4; i++) {
        digest[i] = (hash >> (i * 8)) & 0xFF;
    }
}

int mutual_authenticate_client(const char *client_id, const char *server_id,
                              const char *client_secret, const char *server_secret) {
    auth_context_t ctx;
    unsigned char client_hmac[16];
    unsigned char server_hmac[16];
    
    // Initialize context
    strncpy(ctx.client_id, client_id, sizeof(ctx.client_id) - 1);
    strncpy(ctx.server_id, server_id, sizeof(ctx.server_id) - 1);
    generate_nonce(ctx.nonce, sizeof(ctx.nonce));
    
    printf("Client: Starting mutual authentication with server %s\n", server_id);
    
    // Client sends client_id and nonce to server
    printf("Client: Sending client_id='%s' and nonce\n", client_id);
    
    // Server responds with its own nonce and HMAC
    generate_nonce(ctx.nonce, sizeof(ctx.nonce)); // Server's nonce
    simple_hmac(server_secret, ctx.client_id, server_hmac);
    
    printf("Server: Sending nonce and HMAC\n");
    
    // Client verifies server's HMAC and sends its own HMAC
    simple_hmac(client_secret, ctx.server_id, client_hmac);
    
    // Server verifies client's HMAC
    printf("Server: Verifying client HMAC\n");
    printf("Client: Verifying server HMAC\n");
    
    // If both verifications pass, establish session key
    generate_nonce(ctx.session_key, sizeof(ctx.session_key));
    printf("Mutual authentication successful. Session key established.\n");
    
    return 0;
}

int main() {
    srand(time(NULL));
    
    const char *client_id = "client123";
    const char *server_id = "server456";
    const char *client_secret = "client_secret_key";
    const char *server_secret = "server_secret_key";
    
    printf("Starting mutual authentication...\n");
    mutual_authenticate_client(client_id, server_id, client_secret, server_secret);
    
    return 0;
}
```

## Practical Examples

### Secure File Transfer

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <openssl/ssl.h>
#include <openssl/err.h>

#define BUFFER_SIZE 4096
#define PORT 8443

// Simple file encryption function
int encrypt_file(const char *input_file, const char *output_file, const char *key) {
    FILE *in_fp, *out_fp;
    char buffer[BUFFER_SIZE];
    size_t bytes_read;
    size_t key_len = strlen(key);
    size_t key_index = 0;
    
    in_fp = fopen(input_file, "rb");
    if (!in_fp) {
        perror("Error opening input file");
        return -1;
    }
    
    out_fp = fopen(output_file, "wb");
    if (!out_fp) {
        perror("Error opening output file");
        fclose(in_fp);
        return -1;
    }
    
    // XOR encryption (for demonstration only)
    while ((bytes_read = fread(buffer, 1, BUFFER_SIZE, in_fp)) > 0) {
        for (size_t i = 0; i < bytes_read; i++) {
            buffer[i] ^= key[key_index++ % key_len];
        }
        fwrite(buffer, 1, bytes_read, out_fp);
    }
    
    fclose(in_fp);
    fclose(out_fp);
    
    return 0;
}

// Secure file transfer server
int secure_file_server() {
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
    if (listen(server_fd, 3) < 0) {
        perror("listen");
        exit(EXIT_FAILURE);
    }
    
    printf("Secure file server listening on port %d\n", PORT);
    
    while (1) {
        // Accept connection
        if ((client_fd = accept(server_fd, (struct sockaddr *)&address,
                               (socklen_t*)&addrlen)) < 0) {
            perror("accept");
            continue;
        }
        
        printf("Client connected\n");
        
        // In a real implementation, would establish SSL connection here
        // and transfer encrypted files
        
        close(client_fd);
    }
    
    close(server_fd);
    return 0;
}

int main() {
    printf("Network Security Examples\n");
    printf("========================\n\n");
    
    // Example: File encryption
    const char *test_file = "test.txt";
    const char *encrypted_file = "test.encrypted";
    const char *key = "my_secret_key";
    
    // Create a test file
    FILE *fp = fopen(test_file, "w");
    if (fp) {
        fprintf(fp, "This is a secret file that needs to be encrypted.\n");
        fprintf(fp, "It contains sensitive information.\n");
        fclose(fp);
        
        printf("Created test file: %s\n", test_file);
        
        // Encrypt the file
        if (encrypt_file(test_file, encrypted_file, key) == 0) {
            printf("File encrypted successfully: %s\n", encrypted_file);
        } else {
            printf("File encryption failed\n");
        }
    }
    
    return 0;
}
```

## Summary

Network security in C programming involves several critical aspects:

1. **Cryptography Fundamentals** - Understanding encryption, hashing, and secure key management
2. **SSL/TLS Implementation** - Using OpenSSL for secure communication
3. **Authentication and Authorization** - Implementing secure user verification systems
4. **Secure Coding Practices** - Preventing common vulnerabilities like buffer overflows
5. **Firewall and Access Control** - Implementing network-level security controls
6. **Secure Communication Patterns** - Establishing trusted communication channels

Key principles for secure network programming:
- Always validate and sanitize input
- Use established cryptographic libraries rather than implementing your own
- Implement proper error handling without revealing sensitive information
- Follow the principle of least privilege
- Keep software and libraries up to date
- Use secure communication protocols (HTTPS, SSL/TLS)
- Implement proper logging and monitoring

These security practices are essential for developing robust and trustworthy network applications that can withstand modern security threats.