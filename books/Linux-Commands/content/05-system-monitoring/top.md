# top

## Overview
The `top` command provides a dynamic real-time view of running system processes. It shows system summary information and a list of processes or threads currently managed by the Linux kernel.

## Syntax
```bash
top [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Batch mode operation |
| `-n num` | Number of iterations |
| `-d delay` | Screen update interval |
| `-p pid` | Monitor specific process IDs |
| `-u user` | Show only processes of a specific user |
| `-H` | Show threads |
| `-i` | Don't show idle processes |

## Key Use Cases
1. Monitor system resource usage
2. Identify resource-intensive processes
3. Track process status changes
4. System performance analysis
5. Memory usage monitoring

## Examples with Explanations
### Example 1: Basic Usage
```bash
top
```
Shows real-time process information

### Example 2: Monitor Specific Process
```bash
top -p 1234
```
Shows information only for process ID 1234

### Example 3: Update Faster
```bash
top -d 0.5
```
Updates display every 0.5 seconds

## Understanding Output
Header sections:
1. System uptime and load averages
2. Tasks summary (total, running, sleeping)
3. CPU states (user, system, idle)
4. Memory usage (total, used, free)
5. Swap usage

Process list columns:
- PID: Process ID
- USER: Process owner
- PR: Priority
- NI: Nice value
- VIRT: Virtual memory
- RES: Resident memory
- SHR: Shared memory
- S: Process status
- %CPU: CPU usage
- %MEM: Memory usage
- TIME+: CPU time
- COMMAND: Command name

## Common Usage Patterns
Interactive commands:
- 'k': Kill a process
- 'r': Renice a process
- 'f': Select fields to display
- 'o': Change sort field
- 'h': Show help
- 'q': Quit

## Performance Analysis
- Use batch mode (-b) for logging
- Filter idle processes (-i) for clearer view
- Sort by different columns for various analyses
- Monitor specific processes with -p

## Related Commands
- `htop` - Interactive process viewer
- `ps` - Process status
- `vmstat` - Virtual memory statistics
- `free` - Memory usage
- `atop` - Advanced system monitor

## Additional Resources
- [Linux Top Manual](https://man7.org/linux/man-pages/man1/top.1.html)
- [Top Command Guide](https://www.tecmint.com/12-top-command-examples-in-linux/)
