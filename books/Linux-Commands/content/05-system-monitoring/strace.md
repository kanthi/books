# strace

## Overview
`strace` traces **system calls** and signals of a process. When a program fails with a vague error, strace often shows the failing `open`, `connect`, or `permission` call.

## Syntax
```bash
strace [options] command [args...]
strace [options] -p PID
```

## Common Options
| Option | Description |
|--------|-------------|
| `-e trace=file\|network\|process\|…` | Subset of syscalls |
| `-e openat,connect` | Specific calls |
| `-o file` | Write trace to file |
| `-f` | Follow children/threads |
| `-p PID` | Attach to running process |
| `-c` | Summary counts/time |
| `-s N` | String truncate length |
| `-y` | Print paths for FDs |
| `-tt` / `-T` | Timestamps / syscall duration |

## Safety
Attaching to production processes can slow them. Needs privileges for other users’ PIDs (`CAP_SYS_PTRACE`/root). Do not attach casually to security-sensitive processes.

## Examples with Explanations
### Why did it fail?
```bash
strace -f -e openat,access ls /no/such 2>&1 | tail
strace -e connect,sendto,recvfrom curl -sS https://example.com/ -o /dev/null
```

### Summary profile
```bash
strace -c ls -R /etc >/dev/null
```

### Attach to PID
```bash
sudo strace -p $(pgrep -n myapp) -f -e file
```

### Write log
```bash
strace -f -o /tmp/trace.txt ./app
less /tmp/trace.txt
```

### Network-focused
```bash
strace -f -e network -s 200 ssh user@host true
```

## Reading output
Lines look like `openat(AT_FDCWD, "/etc/passwd", O_RDONLY) = 3` or `= -1 ENOENT (No such file or directory)`. The errno at the end is the usual smoking gun.

## Related Commands
- `ltrace` — library calls  
- `perf` — performance counters  
- `gdb` — debugger  
- `journalctl` / app logs — higher level  
- `lsof` — open files snapshot
