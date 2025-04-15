# ps

## Overview
The `ps` command displays information about active processes running on the system. It provides a snapshot of the current processes.

## Syntax
```bash
ps [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-e` | Show all processes |
| `-f` | Full format listing |
| `-l` | Long format |
| `-u username` | Show processes for specified username |
| `aux` | Show all processes in BSD format |
| `-C cmdname` | Select by command name |
| `--sort` | Sort by specified criteria |

## Key Use Cases
1. Monitor system processes
2. Troubleshoot performance issues
3. Find resource-intensive processes
4. Check process status and details

## Examples with Explanations
### Example 1: Show all processes
```bash
ps -ef
```
Shows all processes in full format

### Example 2: Show process tree
```bash
ps -ejH
```
Displays process hierarchy in a tree format

### Example 3: Show processes by user
```bash
ps -u username
```
Shows processes owned by specified user

## Understanding Output
Standard columns in ps output:
- PID: Process ID
- TTY: Terminal type
- TIME: CPU time used
- CMD: Command name
- %CPU: CPU usage
- %MEM: Memory usage
- VSZ: Virtual memory size
- RSS: Resident set size

## Common Usage Patterns
1. Find all processes using a lot of CPU:
   ```bash
   ps aux --sort=-%cpu
   ```
2. Find process by name:
   ```bash
   ps -C processname
   ```
3. Show process hierarchy:
   ```bash
   ps -ejH
   ```

## Performance Analysis
- Use `ps` with `top` or `htop` for real-time monitoring
- Combine with `grep` to filter specific processes
- Use sorting options to identify resource-intensive processes

## Related Commands
- `top` - Dynamic process monitoring
- `htop` - Interactive process viewer
- `kill` - Terminate processes
- `pgrep` - Look up processes by name
- `pkill` - Kill processes by name

## Additional Resources
- [Linux ps command manual](https://man7.org/linux/man-pages/man1/ps.1.html)
- [PS command guide](https://www.tecmint.com/ps-command-examples-in-linux/)
