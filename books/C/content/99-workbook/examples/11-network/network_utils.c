#include "network_utils.h"

// Initialize sockets (Windows specific)
int initialize_sockets(void) {
#ifdef _WIN32
    WSADATA wsaData;
    int result = WSAStartup(MAKEWORD(2, 2), &wsaData);
    if (result != 0) {
        printf("WSAStartup failed: %d\n", result);
        return 0; // Failure
    }
#endif
    return 1; // Success
}

// Cleanup sockets (Windows specific)
void cleanup_sockets(void) {
#ifdef _WIN32
    WSACleanup();
#endif
}

// Create a TCP socket
socket_t create_tcp_socket(void) {
    socket_t sock = socket(AF_INET, SOCK_STREAM, 0);
    if (sock == SOCK_ERR) {
        perror("Socket creation failed");
    }
    return sock;
}

// Bind socket to a port
int bind_socket(socket_t sock, int port) {
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    
    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(port);
    
    int result = bind(sock, (struct sockaddr*)&server_addr, sizeof(server_addr));
    if (result == SOCK_ERR) {
        perror("Bind failed");
        return 0; // Failure
    }
    
    return 1; // Success
}

// Listen on socket
int listen_socket(socket_t sock, int backlog) {
    int result = listen(sock, backlog);
    if (result == SOCK_ERR) {
        perror("Listen failed");
        return 0; // Failure
    }
    
    return 1; // Success
}

// Accept a connection
socket_t accept_connection(socket_t server_sock, struct sockaddr_in* client_addr) {
    socklen_t client_len = sizeof(*client_addr);
    socket_t client_sock = accept(server_sock, (struct sockaddr*)client_addr, &client_len);
    
    if (client_sock == SOCK_ERR) {
        perror("Accept failed");
    }
    
    return client_sock;
}

// Connect to a server
int connect_to_server(socket_t sock, const char* ip, int port) {
    struct sockaddr_in server_addr;
    memset(&server_addr, 0, sizeof(server_addr));
    
    server_addr.sin_family = AF_INET;
    server_addr.sin_port = htons(port);
    
    if (inet_pton(AF_INET, ip, &server_addr.sin_addr) <= 0) {
        printf("Invalid address/Address not supported\n");
        return 0; // Failure
    }
    
    int result = connect(sock, (struct sockaddr*)&server_addr, sizeof(server_addr));
    if (result == SOCK_ERR) {
        perror("Connection failed");
        return 0; // Failure
    }
    
    return 1; // Success
}

// Send data
int send_data(socket_t sock, const char* data, size_t length) {
    ssize_t bytes_sent = send(sock, data, length, 0);
    if (bytes_sent == SOCK_ERR) {
        perror("Send failed");
        return 0; // Failure
    }
    
    return (int)bytes_sent; // Success, return bytes sent
}

// Receive data
int receive_data(socket_t sock, char* buffer, size_t buffer_size) {
    ssize_t bytes_received = recv(sock, buffer, buffer_size - 1, 0);
    if (bytes_received == SOCK_ERR) {
        perror("Receive failed");
        return 0; // Failure
    }
    
    buffer[bytes_received] = '\0'; // Null terminate
    return (int)bytes_received; // Success, return bytes received
}

// Close connection
void close_connection(socket_t sock) {
    CLOSE_SOCKET(sock);
}

// Get IP address from hostname
char* get_ip_address(const char* hostname) {
    static char ip_str[INET_ADDRSTRLEN];
    struct hostent* host_entry = gethostbyname(hostname);
    
    if (host_entry == NULL) {
        perror("gethostbyname failed");
        return NULL;
    }
    
    struct in_addr** addr_list = (struct in_addr**)host_entry->h_addr_list;
    if (addr_list[0] == NULL) {
        printf("No IP addresses found\n");
        return NULL;
    }
    
    inet_ntop(AF_INET, addr_list[0], ip_str, INET_ADDRSTRLEN);
    return ip_str;
}