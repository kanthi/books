# ltrace

## Overview

`ltrace` intercepts and prints **dynamic library calls** of a process (similar to how `strace` prints syscalls). Useful when you need to see `malloc`, `strcmp`, `fopen`, or library-level behavior without a full debugger.

```bash
sudo apt install ltrace
```

## Syntax

```bash
ltrace [options] command [args...]
ltrace -p PID
```

## Common Options

| Option | Description |
|--------|-------------|
| `-e filter` | Include/exclude symbols |
| `-p PID` | Attach to process |
| `-c` | Counts / summary |
| `-T` | Show time in calls |
| `-f` | Follow forks |
| `-o file` | Output file |
| `-s strsize` | String capture length |

## Safety

- Attaching can slow or perturb production processes.  
- Needs appropriate `ptrace` permissions (`kernel.yama.ptrace_scope`).  
- Do not leave high-volume tracing on busy services.

## Examples with Explanations

### Trace a command

```bash
ltrace -e fopen+fclose+read ls /tmp 2>&1 | head
```

### Summary counts

```bash
ltrace -c true
ltrace -c ./myapp --flag 2>&1 | tail
```

### Attach

```bash
ltrace -p "$(pidof myapp)" -e 'malloc+free' -c
```

## Notes & Pitfalls

- Statically linked binaries show little.  
- Prefer `strace` for syscall/ENOENT path issues; `ltrace` for library logic.  
- Go/Rust binaries may be less informative depending on linkage.

## Related Commands

- `strace` — syscalls  
- `gdb` — full debugger  
- `perf` — profiling  
- `nm` / `ldd` — symbols and libraries  

## Additional Resources

- `man ltrace`
