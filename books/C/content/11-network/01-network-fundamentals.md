# Network Fundamentals

Network programming lets C programs exchange data across hosts. This chapter covers the models and addressing you need, then focuses on **real POSIX C**: endianness, `htons`/`htonl`, `inet_pton`/`inet_ntop`, filling `sockaddr_in`, and a complete **UDP echo client and server**.

**Environment:** Linux, `gcc -std=c17 -Wall -Wextra`. Link nothing extra for these examples (just libc).

```bash
gcc -std=c17 -Wall -Wextra -o prog prog.c
```

## Computer Network Basics

A network is a set of interconnected devices that share a common communication path. Scope ranges from a USB gadget link to the global Internet.

### Topologies (conceptual)

1. **Bus** — shared medium  
2. **Star** — central switch/hub  
3. **Ring** — circular path  
4. **Mesh** — multiple redundant paths  
5. **Tree** — hierarchical aggregation  

### Network types by scope

| Type | Scope | Example |
|------|-------|---------|
| PAN | Person / desk | Bluetooth |
| LAN | Building / campus | Office Ethernet |
| MAN | City | Metro fiber |
| WAN | Large region | ISP backbone |
| Internet | Global | Public IP routing |

## OSI and TCP/IP Models

### OSI (7 layers)

1. Physical — bits on wire/radio  
2. Data Link — frames, MAC  
3. Network — routing (IP)  
4. Transport — end-to-end (TCP/UDP)  
5. Session — dialogs  
6. Presentation — encoding/encryption  
7. Application — HTTP, DNS, …  

### TCP/IP (practical 4 layers)

| TCP/IP layer | Rough OSI | Examples |
|--------------|-----------|----------|
| Link | 1–2 | Ethernet, Wi-Fi |
| Internet | 3 | IPv4, IPv6, ICMP |
| Transport | 4 | TCP, UDP |
| Application | 5–7 | HTTP, DNS, SSH |

In socket programming you mostly touch **transport + addressing (IP + port)**.

## IP Addressing and Ports

### IPv4

32-bit addresses written dotted-decimal: `192.168.1.10`.

Special addresses:

- `127.0.0.1` — loopback (this host)  
- `0.0.0.0` — “any” address when binding a server  
- `255.255.255.255` — limited broadcast (local link)  

Historical classful ranges (A/B/C) matter less than **CIDR** (`192.168.0.0/24`), but you still see class language in older docs.

### IPv6 (awareness)

128-bit addresses: `2001:db8::1`. Use `AF_INET6`, `struct sockaddr_in6`, and `inet_pton(AF_INET6, ...)`. This chapter’s full programs use IPv4 for clarity; the conversion APIs are dual-stack ready.

### Ports

16-bit service numbers (0–65535):

| Range | Name | Examples |
|-------|------|----------|
| 0–1023 | Well-known | 22 SSH, 80 HTTP, 443 HTTPS |
| 1024–49151 | Registered | Many app servers |
| 49152–65535 | Ephemeral | Client source ports |

Binding ports below 1024 usually requires root/capabilities on Linux.

## TCP vs UDP (what sockets expose)

| | TCP (`SOCK_STREAM`) | UDP (`SOCK_DGRAM`) |
|--|---------------------|--------------------|
| Connection | Handshake (3-way) | None |
| Reliability | Retransmit, ordered | Best-effort |
| Message bounds | Byte stream | Datagram boundaries kept |
| Use cases | HTTP, SSH, databases | DNS, games, discovery, echo labs |

This chapter ends with **UDP echo** because it is the smallest complete network program (no listen/accept).

## Sockets and Address Structures

A **socket** is an endpoint (a file descriptor on Unix). You create one with `socket()`, then `bind`/`connect`/`sendto`/`recvfrom` as needed.

### Headers

```c
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <unistd.h>
#include <netdb.h>
#include <errno.h>
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
```

### Structures

```c
/* IPv4 socket address */
struct sockaddr_in {
    sa_family_t    sin_family; /* AF_INET */
    in_port_t      sin_port;   /* port in network byte order */
    struct in_addr sin_addr;   /* IPv4 address, network byte order */
    /* padding (sin_zero) often present */
};

struct in_addr {
    uint32_t s_addr;           /* address in network byte order */
};

/* Generic shape used by bind/connect (cast to/from) */
struct sockaddr {
    sa_family_t sa_family;
    char        sa_data[14];
};
```

Always set unused fields to zero (`memset` the whole `sockaddr_in`) before filling fields.

---

## Endianness: Why Byte Order Matters

Multi-byte integers can be stored **little-endian** (least significant byte first — common on x86/x86-64) or **big-endian** (most significant byte first). **Network byte order is big-endian.**

If you put a host `uint16_t` port into a packet without conversion, peers on different architectures (or even the same machine’s stack) will disagree about the value.

### Program: inspect endianness and multi-byte layout

```c
/* file: endian_demo.c */
#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

static void print_bytes(const char *label, const void *p, size_t n) {
    const unsigned char *b = p;
    size_t i;
    printf("%s:", label);
    for (i = 0; i < n; i++) {
        printf(" %02x", b[i]);
    }
    printf("\n");
}

int main(void) {
    uint32_t host_u32 = 0x12345678u;
    uint16_t host_u16 = 0xABCDu;
    uint32_t net_u32;
    uint16_t net_u16;

    {
        uint16_t probe = 0x0102;
        const unsigned char *p = (const unsigned char *)&probe;
        if (p[0] == 0x01 && p[1] == 0x02) {
            printf("This host appears big-endian\n");
        } else if (p[0] == 0x02 && p[1] == 0x01) {
            printf("This host appears little-endian\n");
        } else {
            printf("Unexpected byte order probe\n");
        }
    }

    print_bytes("host uint32 0x12345678", &host_u32, sizeof host_u32);
    print_bytes("host uint16 0xABCD", &host_u16, sizeof host_u16);

    net_u32 = htonl(host_u32);
    net_u16 = htons(host_u16);

    print_bytes("htonl(0x12345678)", &net_u32, sizeof net_u32);
    print_bytes("htons(0xABCD)", &net_u16, sizeof net_u16);

    printf("ntohl(htonl(x)) == x ? %s\n",
           ntohl(net_u32) == host_u32 ? "yes" : "no");
    printf("ntohs(htons(x)) == x ? %s\n",
           ntohs(net_u16) == host_u16 ? "yes" : "no");

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o endian_demo endian_demo.c
./endian_demo
```

On a little-endian host you typically see:

```text
This host appears little-endian
host uint32 0x12345678: 78 56 34 12
htonl(0x12345678): 12 34 56 78
```

Network order always shows the “natural” human hex order in memory for that value’s big-endian encoding.

---

## `htons` / `htonl` / `ntohs` / `ntohl`

```c
#include <arpa/inet.h>

uint32_t htonl(uint32_t hostlong);
uint16_t htons(uint16_t hostshort);
uint32_t ntohl(uint32_t netlong);
uint16_t ntohs(uint16_t netshort);
```

| Function | Direction | Width |
|----------|-----------|-------|
| `htons` | host → network | 16-bit (ports) |
| `htonl` | host → network | 32-bit (IPv4 `s_addr` pieces, some protocol fields) |
| `ntohs` | network → host | 16-bit |
| `ntohl` | network → host | 32-bit |

### Demo program

```c
/* file: hton_demo.c */
#include <stdio.h>
#include <stdint.h>
#include <arpa/inet.h>

int main(void) {
    uint16_t port_host = 8080;
    uint16_t port_net = htons(port_host);
    uint32_t word_host = 0x12345678u;

    printf("port host:  %u (0x%04x)\n", port_host, port_host);
    printf("port net:   %u (0x%04x)  /* value after htons */\n",
           port_net, port_net);
    printf("port back:  %u\n", ntohs(port_net));

    printf("word host:  0x%08x\n", word_host);
    printf("word net:   0x%08x\n", htonl(word_host));
    printf("word back:  0x%08x\n", ntohl(htonl(word_host)));

    /* Rule: store htons(port) into sin_port; print with ntohs(sin.sin_port) */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o hton_demo hton_demo.c
./hton_demo
```

**Rule of thumb:** every multi-byte field that crosses the wire (or sits in `sockaddr_in`) is converted **to network order on write** and **to host order on read**.

---

## `inet_pton` and `inet_ntop`

Prefer these over older `inet_addr` / `inet_ntoa` (which are IPv4-only, weaker error reporting, and `inet_ntoa` is not thread-safe).

```c
#include <arpa/inet.h>

int inet_pton(int af, const char *src, void *dst);
const char *inet_ntop(int af, const void *src, char *dst, socklen_t size);
```

- `inet_pton`: text → binary. Returns `1` success, `0` invalid text, `-1` bad `af` / error.  
- `inet_ntop`: binary → text. Returns `dst` on success, `NULL` on error.  
- Buffer size: `INET_ADDRSTRLEN` (IPv4) or `INET6_ADDRSTRLEN` (IPv6).  

### Full conversion + `sockaddr_in` setup demo

```c
/* file: addr_demo.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <arpa/inet.h>
#include <netinet/in.h>

int main(void) {
    const char *ip_text = "192.168.1.100";
    const uint16_t port = 9000;
    struct sockaddr_in addr;
    char ip_out[INET_ADDRSTRLEN];

    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_port = htons(port);

    if (inet_pton(AF_INET, ip_text, &addr.sin_addr) != 1) {
        fprintf(stderr, "inet_pton failed for %s\n", ip_text);
        return EXIT_FAILURE;
    }

    if (inet_ntop(AF_INET, &addr.sin_addr, ip_out, sizeof ip_out) == NULL) {
        perror("inet_ntop");
        return EXIT_FAILURE;
    }

    printf("text in:  %s\n", ip_text);
    printf("text out: %s\n", ip_out);
    printf("port:     %u (wire field raw after htons: 0x%04x)\n",
           ntohs(addr.sin_port), addr.sin_port);
    printf("s_addr:   0x%08x (network order bits)\n",
           addr.sin_addr.s_addr);

    /* Bind-all pattern for servers */
    memset(&addr, 0, sizeof addr);
    addr.sin_family = AF_INET;
    addr.sin_addr.s_addr = htonl(INADDR_ANY); /* 0.0.0.0 */
    addr.sin_port = htons(9000);
    printf("server bind: 0.0.0.0:%u\n", ntohs(addr.sin_port));

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o addr_demo addr_demo.c
./addr_demo
```

### Filling `sockaddr_in` checklist

```c
struct sockaddr_in sa;
memset(&sa, 0, sizeof sa);
sa.sin_family = AF_INET;
sa.sin_port   = htons(port);
inet_pton(AF_INET, "127.0.0.1", &sa.sin_addr);
/* or: sa.sin_addr.s_addr = htonl(INADDR_ANY); */
```

When calling `bind` / `sendto` / `recvfrom`, cast:

```c
bind(fd, (struct sockaddr *)&sa, sizeof sa);
```

---

## Minimal UDP Echo: Server and Client

UDP echo: client sends a datagram; server replies with the same payload to the source address.

### Server (`udp_echo_server.c`)

```c
/* file: udp_echo_server.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>

#define BUF_SIZE 2048

int main(int argc, char *argv[]) {
    int fd;
    uint16_t port;
    struct sockaddr_in srv;
    struct sockaddr_in cli;
    socklen_t cli_len;
    char buf[BUF_SIZE];
    char addrbuf[INET_ADDRSTRLEN];
    ssize_t n;

    if (argc != 2) {
        fprintf(stderr, "Usage: %s <port>\n", argv[0]);
        return EXIT_FAILURE;
    }
    port = (uint16_t)atoi(argv[1]);
    if (port == 0) {
        fprintf(stderr, "invalid port\n");
        return EXIT_FAILURE;
    }

    fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        perror("socket");
        return EXIT_FAILURE;
    }

    memset(&srv, 0, sizeof srv);
    srv.sin_family = AF_INET;
    srv.sin_addr.s_addr = htonl(INADDR_ANY);
    srv.sin_port = htons(port);

    if (bind(fd, (struct sockaddr *)&srv, sizeof srv) < 0) {
        perror("bind");
        close(fd);
        return EXIT_FAILURE;
    }

    printf("UDP echo server listening on port %u\n", port);

    for (;;) {
        cli_len = sizeof cli;
        n = recvfrom(fd, buf, sizeof buf, 0,
                     (struct sockaddr *)&cli, &cli_len);
        if (n < 0) {
            perror("recvfrom");
            continue;
        }

        if (inet_ntop(AF_INET, &cli.sin_addr, addrbuf, sizeof addrbuf) == NULL) {
            strncpy(addrbuf, "?", sizeof addrbuf);
            addrbuf[sizeof addrbuf - 1] = '\0';
        }
        printf("from %s:%u (%zd bytes)\n",
               addrbuf, ntohs(cli.sin_port), n);

        if (sendto(fd, buf, (size_t)n, 0,
                   (struct sockaddr *)&cli, cli_len) < 0) {
            perror("sendto");
        }
    }

    /* unreachable in this simple loop */
    /* close(fd); */
    /* return 0; */
}
```

### Client (`udp_echo_client.c`)

```c
/* file: udp_echo_client.c */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <netinet/in.h>
#include <sys/socket.h>

#define BUF_SIZE 2048

int main(int argc, char *argv[]) {
    int fd;
    struct sockaddr_in srv;
    char buf[BUF_SIZE];
    ssize_t n;
    size_t len;

    if (argc != 4) {
        fprintf(stderr, "Usage: %s <server_ip> <port> <message>\n", argv[0]);
        return EXIT_FAILURE;
    }

    fd = socket(AF_INET, SOCK_DGRAM, 0);
    if (fd < 0) {
        perror("socket");
        return EXIT_FAILURE;
    }

    memset(&srv, 0, sizeof srv);
    srv.sin_family = AF_INET;
    srv.sin_port = htons((uint16_t)atoi(argv[2]));
    if (inet_pton(AF_INET, argv[1], &srv.sin_addr) != 1) {
        fprintf(stderr, "invalid server IP: %s\n", argv[1]);
        close(fd);
        return EXIT_FAILURE;
    }

    len = strlen(argv[3]);
    if (len == 0 || len >= BUF_SIZE) {
        fprintf(stderr, "message empty or too long\n");
        close(fd);
        return EXIT_FAILURE;
    }

    if (sendto(fd, argv[3], len, 0,
               (struct sockaddr *)&srv, sizeof srv) < 0) {
        perror("sendto");
        close(fd);
        return EXIT_FAILURE;
    }

    n = recvfrom(fd, buf, sizeof buf - 1, 0, NULL, NULL);
    if (n < 0) {
        perror("recvfrom");
        close(fd);
        return EXIT_FAILURE;
    }
    buf[n] = '\0';
    printf("echo: %s\n", buf);

    close(fd);
    return 0;
}
```

### Build and run (two terminals)

```bash
gcc -std=c17 -Wall -Wextra -o udp_echo_server udp_echo_server.c
gcc -std=c17 -Wall -Wextra -o udp_echo_client udp_echo_client.c

# terminal 1
./udp_echo_server 9000

# terminal 2
./udp_echo_client 127.0.0.1 9000 "hello UDP"
# echo: hello UDP
```

**What just happened**

1. Server `socket` + `bind` to `0.0.0.0:9000`  
2. Client `sendto` a datagram to `127.0.0.1:9000`  
3. Kernel delivers payload; `recvfrom` also fills **client address**  
4. Server `sendto` same bytes back to that address  
5. Client `recvfrom` prints the reply  

No `listen`, no `accept` — that is TCP territory (next chapter).

### Optional: see the packets

```bash
# while the exchange runs
sudo tcpdump -i lo -n udp port 9000
```

---

## Network Errors (practical)

Always check return values:

```c
if (fd < 0) {
    fprintf(stderr, "socket: %s\n", strerror(errno));
    exit(EXIT_FAILURE);
}
if (bind(fd, (struct sockaddr *)&srv, sizeof srv) < 0) {
    fprintf(stderr, "bind: %s\n", strerror(errno));
    close(fd);
    exit(EXIT_FAILURE);
}
```

| Symptom | Typical cause |
|---------|----------------|
| `EADDRINUSE` | Port already bound |
| `EACCES` | Port &lt; 1024 without privilege |
| `ECONNREFUSED` | More common with TCP; UDP may get ICMP unreachable later |
| `EINVAL` | Wrong address length / family |
| `ENETUNREACH` / `EHOSTUNREACH` | Routing problem |

UDP clients often hang in `recvfrom` if the server is down (no automatic error). Use `setsockopt` timeouts (`SO_RCVTIMEO`) for production clients.

```c
struct timeval tv = {.tv_sec = 3, .tv_usec = 0};
setsockopt(fd, SOL_SOCKET, SO_RCVTIMEO, &tv, sizeof tv);
```

---

## Hostname Lookup (brief, modern)

Prefer `getaddrinfo` over deprecated `gethostbyname`:

```c
/* sketch — full dual-stack client belongs with TCP chapter */
struct addrinfo hints, *res;
memset(&hints, 0, sizeof hints);
hints.ai_family = AF_INET;
hints.ai_socktype = SOCK_DGRAM;
if (getaddrinfo("localhost", "9000", &hints, &res) != 0) {
    /* handle error */
}
/* use res->ai_addr with sendto; freeaddrinfo(res) later */
```

## Protocol Quick Reference

- **TCP** — reliable stream; next chapter builds connect/accept.  
- **UDP** — datagrams; this chapter’s echo lab.  
- **ICMP** — diagnostics (`ping`); raw sockets need privileges.  

---

## Exercises

### Exercise 1 — Endianness report

Run `endian_demo` on your machine. Paste the byte listings for `0x12345678` before and after `htonl`. Explain which listing matches network order.

### Exercise 2 — Port round-trip

Write a program that takes a port number as `argv[1]`, stores `htons` into a `sockaddr_in`, then prints `ntohs(sin_port)`. Confirm the printed port equals the argument for values `80`, `8080`, and `65535`.

### Exercise 3 — `inet_pton` validation

Feed `inet_pton` the strings `127.0.0.1`, `256.0.0.1`, `::1` (with `AF_INET`), and `not-an-ip`. Print the return code for each. Then convert `::1` with `AF_INET6` successfully.

### Exercise 4 — Bind failure

Start `udp_echo_server 9000` twice. Capture the error from the second bind. Kill the first and confirm the second starts.

### Exercise 5 — Echo timeout

Add `SO_RCVTIMEO` of 2 seconds to the client. Run the client without a server and show that it fails cleanly instead of hanging forever.

### Exercise 6 — Multi-message server log

Modify the server to prefix each log line with a packet counter. Send five client messages and verify counters 1…5.

### Exercise 7 — Binary payload

Send 8 raw bytes (not a C string) from a small client using an `unsigned char` array. Have the server reply with the same bytes. Confirm length stays 8 (no reliance on `\0`).

---

## Summary

| Concept | C takeaway |
|---------|------------|
| TCP/IP model | Sockets sit at transport + app |
| Endianness | Network = big-endian; use `hton*` / `ntoh*` |
| Text ↔ binary IP | `inet_pton` / `inet_ntop` |
| Address struct | Zero, set `AF_INET`, `htons` port, `inet_pton` or `INADDR_ANY` |
| UDP echo | `socket` → `bind`/`sendto`/`recvfrom` |
| Errors | Check every call; `strerror(errno)` |

You now have the addressing and byte-order tools every C network program needs, plus a complete UDP exchange you can extend into real services. The next chapter builds **TCP** socket programming on the same foundations.
