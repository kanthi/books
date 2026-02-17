#ifndef NETWORK_UTILS_H
#define NETWORK_UTILS_H

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
#endif

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <errno.h>

// Cross-platform socket type
#ifdef _WIN32
    typedef SOCKET socket_t;
    #define CLOSE_SOCKET closesocket
    #define SOCK_ERR SOCKET_ERROR
#else
    typedef int socket_t;
    #define CLOSE_SOCKET close
    #define SOCK_ERR -1
#endif

// Function prototypes for network utilities
int initialize_sockets(void);
void cleanup_sockets(void);
socket_t create_tcp_socket(void);
int bind_socket(socket_t sock, int port);
int listen_socket(socket_t sock, int backlog);
socket_t accept_connection(socket_t server_sock, struct sockaddr_in* client_addr);
int connect_to_server(socket_t sock, const char* ip, int port);
int send_data(socket_t sock, const char* data, size_t length);
int receive_data(socket_t sock, char* buffer, size_t buffer_size);
void close_connection(socket_t sock);
char* get_ip_address(const char* hostname);

#endif // NETWORK_UTILS_H