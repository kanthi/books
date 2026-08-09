# strace

## Overview

`strace` traces **system calls** and signals for a process. When a program fails with a vague error (“permission denied”, “connection refused”, silent hang), strace often shows the failing `openat`, `connect`, `execve`, or `access`. It is a diagnostic scalpel — powerful, noisy, and can slow production processes. Prefer filtering (`-e`) and short attaches.

## Syntax

```bash
strace [options] command [args...]
strace [options] -p PID
```

## Common Options

| Option | Description |
|--------|-------------|
| `-e trace=file\|network\|process\|desc\|…` | Syscall sets |
| `-e openat,connect,execve` | Specific calls |
| `-e errno=ENOENT` | Only failures of a type (version-dependent usage) |
| `-o file` | Write trace to file (keep stderr clean) |
| `-f` | Follow forks/threads (usually want this) |
| `-p PID` | Attach to running process |
| `-c` | Summary counts and time per syscall |
| `-C` | Summary plus regular trace |
| `-s N` | Max string length printed (default often 32) |
| `-y` | Resolve FD paths |
| `-yy` | Extra protocol details for sockets (newer) |
| `-tt` / `-ttt` | Timestamps (wall / epoch) |
| `-T` | Time spent in each syscall |
| `-q` | Quieter attach/detach messages |

## Safety

- Attaching to live production processes **adds overhead** — can stall latency-sensitive apps.
- Needs privileges for other users’ PIDs (`CAP_SYS_PTRACE` / root); Yama `ptrace_scope` may block attaches.
- Do not casually attach to security-sensitive processes (agents, secret managers) on shared notes/screens.
- Detach with Ctrl-C carefully; prefer `-o` logs over flooding terminals in incidents.

## Key Use Cases

1. Why did a command fail to open a file or config?
2. Where is a hang — blocking `read`/`poll`/`futex`/`connect`?
3. Which addresses/ports does a binary hit?
4. Rough syscall cost profile (`-c`) before deeper `perf`

## Examples with Explanations

### Why did it fail? (file open)

```bash
strace -f -e openat,access ls /no/such 2>&1 | tail
strace -f -e openat,stat,access cat /etc/shadow
```

Look for `= -1 ENOENT` or `EACCES` on the path you expected.

### Network path of a client

```bash
strace -f -e connect,sendto,recvfrom,poll,select \
  curl -sS https://example.com/ -o /dev/null
```

See DNS vs connect failures (pair with `curl -v` / `dig`).

### Summary profile

```bash
strace -c ls -R /etc >/dev/null
strace -c -f make -j"$(nproc)" >/dev/null
```

Counts and rough time per syscall — good for “too many small reads” stories.

### Attach to a running PID

```bash
pidof myapp
sudo strace -p "$(pidof -s myapp)" -f -e file -s 200
# or:
sudo strace -p PID -f -e trace=network -tt
```

`-f` follows worker threads. Scope with `-e` or the terminal becomes unreadable.

### Write a full log

```bash
strace -f -tt -T -o /tmp/trace.txt ./app --flag
less /tmp/trace.txt
grep -E 'ENOENT|EACCES|ECONNREFUSED' /tmp/trace.txt | tail
```

Always useful: keep app stdout free; search the log for errnos.

### Longer strings and FD paths

```bash
strace -f -s 200 -y -e openat,read,write ./app
```

`-s` avoids truncated paths; `-y` shows what FD 7 actually is.

### Child processes / build systems

```bash
strace -f -e execve,openat make package 2>&1 | grep execve
```

See which helpers are actually invoked.

### Hang diagnosis sketch

```bash
sudo strace -p PID -f -tt -T
# stuck in futex → locking; poll/select → waiting I/O; read on socket → peer silent
```

## Understanding Output

Typical lines:

```text
openat(AT_FDCWD, "/etc/passwd", O_RDONLY|O_CLOEXEC) = 3
connect(4, {sa_family=AF_INET, sin_port=htons(443), ...}, 16) = -1 EINPROGRESS (Operation now in progress)
openat(AT_FDCWD, "/etc/foo.conf", O_RDONLY) = -1 ENOENT (No such file or directory)
```

| Piece | Meaning |
|-------|---------|
| Name | Syscall |
| Args | Paths, FDs, flags, addresses |
| `= N` | Success return (FD number, byte count, …) |
| `= -1 ERRNO (text)` | Failure — usually the smoking gun |
| Duration (`-T`) | Time inside the call (blocking shows up here) |

**Common errnos:** `ENOENT` missing path, `EACCES`/`EPERM` rights, `ECONNREFUSED` nothing listening, `ETIMEDOUT` network path, `EAGAIN` nonblocking empty.

## Notes & Pitfalls

- Without `-e`, output volume explodes — always filter first when possible.
- Multi-threaded apps need `-f` or you miss workers.
- Go/Java/Node runtimes are syscall-noisy; start with `-e network` or `-e file`.
- `seccomp`/sandboxes may alter available calls; container seccomp profiles matter.
- Kernel `yama/ptrace_scope` (`/proc/sys/kernel/yama/ptrace_scope`) can deny non-root attaches.
- For performance at scale prefer `perf`, eBPF (`bpftrace`), or app metrics — strace is not a profiler for production load tests.

## Related Commands

- `ltrace` — library calls (not syscalls)
- `perf` — CPU performance counters / flame graphs
- `gdb` — breakpoints and state inspection
- `lsof` — open files/sockets snapshot without tracing
- `journalctl` / app logs — higher-level errors first
- `ss` / `tcpdump` — network without process tracing

## Additional Resources

- `man strace`
- `man ptrace`
