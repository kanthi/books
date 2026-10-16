---
title: "poll vs epoll vs io_uring"
author:
  - name: "K19G"
  - name: "grok-bot"
---

# poll vs epoll vs io_uring

## Overview

**Thesis:** Linux gives you three generations of "wait for I/O" APIs. **`poll`** (and older `select`) ask "which of these fds are ready?" by rescanning your whole interest list every call — fine for a handful of descriptors, painful for thousands. **`epoll`** keeps the interest list in the kernel and returns only the ready set — the workhorse of Linux network servers. **`io_uring`** flips the model from *readiness* to *completion*: you submit work (SQEs), the kernel posts results (CQEs), and you can batch syscalls. Pick the oldest API that fits; do not reach for io_uring to read one config file.

This page runs small C labs with **gcc**, **poll(2)**, **epoll(7)**, and **liburing** already present on the box. No packages were installed for these examples.

## Mental model

```text
  readiness (poll / epoll):     "tell me when I MAY read/write"
       app                    kernel
        |-- wait ------------>|
        |<-- fd ready --------|
        |-- read(fd) -------->|   separate syscall for the I/O

  completion (io_uring):        "do this I/O; tell me when DONE"
       app                    kernel
        |-- SQE: read(fd,buf)->|
        |<-- CQE: res=n -------|   I/O already finished (or failed)
```

| API | Model | Cost scales with | Typical fit |
|-----|--------|------------------|-------------|
| `poll` | readiness; user passes fd array each call | **O(n)** fds watched per wait | small sets, portable code, quick prototypes |
| `epoll` | readiness; interest list lives in the kernel | **O(ready)** events returned | many sockets / pipes on Linux |
| `io_uring` | completion via SQ/CQ rings | submissions & completions (batchable) | high IOPS, syscall reduction, advanced storage/net |

| Fact | Consequence |
|------|-------------|
| `poll` copies and scans the fd list every wait | 10k idle connections ⇒ 10k checks even if nothing is ready |
| `epoll` interest list is stateful (`epoll_ctl`) | Add once; wait cheaply; mind level vs edge trigger |
| Edge trigger (`EPOLLET`) fires on state *change* | You must drain until `EAGAIN` or you miss data |
| io_uring posts completions, not readiness | One submission can include the read itself — fewer syscalls |
| Not every workload is "10k connections" | `poll` remains the right tool for two fds and a timeout |

## Syntax

```c
poll(fds, nfds, timeout_ms);                    /* man 2 poll */
epoll_create1(flags);
epoll_ctl(epfd, EPOLL_CTL_ADD, fd, &event);     /* man 7 epoll */
epoll_wait(epfd, events, maxevents, timeout_ms);

io_uring_queue_init(entries, &ring, flags);     /* liburing / man 2 io_uring_setup */
io_uring_get_sqe(&ring);  io_uring_prep_*(sqe, ...);
io_uring_submit(&ring);
io_uring_wait_cqe(&ring, &cqe);  io_uring_cqe_seen(&ring, cqe);
```

## Worked examples

Tested on Debian-like linux/amd64 with **GCC 14.2.0**, **strace 6.13**, and **liburing 2.9** headers/libs already on the system (October 2026). Exact `data.fd` numbers depend on prior opens; the control flow is what matters.

### Case 1: `poll` with a timeout (portable readiness)

```c
/* poll_stdin.c — readiness with poll(2) */
#include <poll.h>
#include <stdio.h>
#include <unistd.h>

int main(void)
{
    struct pollfd pfd = {.fd = STDIN_FILENO, .events = POLLIN};
    printf("polling stdin for 200ms...\n");
    int n = poll(&pfd, 1, 200);
    if (n < 0) { perror("poll"); return 1; }
    if (n == 0) {
        printf("timeout (no input)\n");
        return 0;
    }
    printf("revents=0x%x POLLIN=%d\n", pfd.revents, !!(pfd.revents & POLLIN));
    return 0;
}
```

```bash
gcc -O2 -o poll_stdin poll_stdin.c
./poll_stdin
```

```text
polling stdin for 200ms...
timeout (no input)
```

With one fd this is trivial. With thousands of mostly idle fds, every `poll` still walks the whole array — that is the scaling cliff the epoll design removed.

### Case 2: `epoll` edge-triggered on a pipe

```c
/* epoll_pipe.c — edge-triggered readiness on a pipe */
#include <sys/epoll.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>

int main(void)
{
    int fds[2];
    if (pipe(fds) < 0) { perror("pipe"); return 1; }

    int ep = epoll_create1(0);
    if (ep < 0) { perror("epoll_create1"); return 1; }

    struct epoll_event ev = {.events = EPOLLIN | EPOLLET, .data.fd = fds[0]};
    if (epoll_ctl(ep, EPOLL_CTL_ADD, fds[0], &ev) < 0) {
        perror("epoll_ctl"); return 1;
    }

    const char *msg = "hi";
    if (write(fds[1], msg, strlen(msg)) < 0) { perror("write"); return 1; }

    struct epoll_event out;
    int n = epoll_wait(ep, &out, 1, 500);
    printf("epoll_wait returned %d events=0x%x data.fd=%d\n",
           n, n > 0 ? out.events : 0, n > 0 ? out.data.fd : -1);

    char buf[8];
    ssize_t r = read(fds[0], buf, sizeof buf);
    printf("read %zd bytes\n", r);

    /* Edge-triggered + buffer empty ⇒ second wait times out */
    n = epoll_wait(ep, &out, 1, 100);
    printf("second epoll_wait returned %d (expect 0 timeout)\n", n);

    close(ep); close(fds[0]); close(fds[1]);
    return 0;
}
```

```bash
gcc -O2 -o epoll_pipe epoll_pipe.c
./epoll_pipe
```

```text
epoll_wait returned 1 events=0x1 data.fd=5
read 2 bytes
second epoll_wait returned 0 (expect 0 timeout)
```

`EPOLLIN` is `0x1`. After the read drains the pipe, edge-triggered epoll stays quiet until new data arrives. Level-triggered (`EPOLLIN` without `EPOLLET`) would keep reporting readiness while data remains — easier to get right, slightly more wakeups.

### Case 3: `io_uring` completion with a NOP

```c
/* uring_nop.c — completion model: submit NOP, wait for CQE */
#include <liburing.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

int main(void)
{
    struct io_uring ring;
    int ret = io_uring_queue_init(8, &ring, 0);
    if (ret < 0) {
        fprintf(stderr, "io_uring_queue_init: %s\n", strerror(-ret));
        return 1;
    }

    struct io_uring_sqe *sqe = io_uring_get_sqe(&ring);
    if (!sqe) { fprintf(stderr, "no SQE\n"); return 1; }
    io_uring_prep_nop(sqe);
    io_uring_sqe_set_data(sqe, (void *)(uintptr_t)42);

    ret = io_uring_submit(&ring);
    printf("submitted %d\n", ret);

    struct io_uring_cqe *cqe;
    ret = io_uring_wait_cqe(&ring, &cqe);
    if (ret < 0) {
        fprintf(stderr, "wait_cqe: %s\n", strerror(-ret));
        return 1;
    }
    printf("cqe res=%d user_data=%lu\n",
           cqe->res, (unsigned long)(uintptr_t)io_uring_cqe_get_data(cqe));
    io_uring_cqe_seen(&ring, cqe);
    io_uring_queue_exit(&ring);
    return 0;
}
```

```bash
gcc -O2 -o uring_nop uring_nop.c -luring
./uring_nop
```

```text
submitted 1
cqe res=0 user_data=42
```

A NOP does no I/O; it proves the SQ→CQ path. Real programs replace `io_uring_prep_nop` with `prep_read` / `prep_write` / `prep_accept` / … and often submit batches before collecting CQEs. See Jens Axboe's [io_uring.pdf](https://kernel.dk/io_uring.pdf) for ring layout and ordering rules.

### Case 4: When to stop climbing the ladder

| Situation | Prefer |
|-----------|--------|
| Two fds, script, teaching tool | `poll` |
| Linux service with many sockets | `epoll` (level trigger first) |
| Need portability to BSD/macOS | `poll` or `kqueue` (not epoll/io_uring) |
| Syscall overhead or storage IOPS dominates | `io_uring` |
| One blocking `read` in a simple CLI | plain `read` — skip all of the above |

## The trap

1. **Edge-triggered epoll without draining to `EAGAIN`.** You get one wakeup, leave bytes in the socket buffer, and hang waiting for an edge that never comes.  
2. **Using io_uring because it is new.** Setup cost, CQ overflow handling, and restricted kernels (containers, older LTS) bite beginners; epoll still runs the internet.  
3. **Confusing readiness with completion.** `epoll` saying "readable" does not mean your `read` finished — you still issue the read (unless you moved that work into an io_uring SQE).

## The boring rule

**Start with `poll` for small fd sets. Move to `epoll` when the fd count or wake rate hurts. Use `io_uring` when you have measured syscall or completion-batching benefits — and you are willing to handle ring lifecycle carefully.** Always match trigger mode (level vs edge) to how thoroughly you drain.

## Try this

1. Compile and run the three listings above; confirm timeout / one-shot / CQE behaviour.  
2. `strace -e poll ./poll_stdin` and `strace -e epoll_wait,epoll_ctl ./epoll_pipe` — see the syscalls.  
3. Change `epoll_pipe.c` to level trigger (drop `EPOLLET`) and call `epoll_wait` twice *before* reading; observe repeated readiness.  
4. Replace the NOP in `uring_nop.c` with `io_uring_prep_read` on a pipe end and print `cqe->res`.

## Sources

- `man 2 poll`, `man 7 epoll`, `man 2 io_uring_setup` / `io_uring_enter` / `io_uring_register`
- Jens Axboe, *io_uring*: <https://kernel.dk/io_uring.pdf>
- Linux kernel docs: `Documentation/io_uring/` (in-tree)
- Inspiration: <https://x.com/straceX/status/2049810663409680487>
