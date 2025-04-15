# ps

## Overview
The `ps` command displays information about active processes. It provides a snapshot of current processes and their status.

## Syntax
```bash
ps [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-e` | All processes |
| `-f` | Full format |
| `-l` | Long format |
| `-u user` | User processes |
| `-p pid` | Process ID |
| `-C cmd` | Command name |
| `-o format` | Output format |
| `--sort key` | Sort output |
| `-H` | Process hierarchy |
| `-L` | Thread info |
| `-m` | Memory info |
| `aux` | BSD style |

## Output Fields
| Field | Description |
|-------|-------------|
| PID | Process ID |
| PPID | Parent PID |
| %CPU | CPU usage |
| %MEM | Memory usage |
| VSZ | Virtual size |
| RSS | Resident size |
| TTY | Terminal |
| STAT | Process state |
| START | Start time |
| TIME | CPU time |
| COMMAND | Command line |

## Key Use Cases
1. Process monitoring
2. Resource usage
3. System analysis
4. Troubleshooting
5. Performance tuning

## Examples with Explanations
### Example 1: All Processes
```bash
ps -ef
```
Full process list

### Example 2: Process Tree
```bash
ps -ejH
```
Show process hierarchy

### Example 3: Custom Format
```bash
ps -eo pid,ppid,cmd
```
Select output fields

## Common Usage Patterns
1. User processes:
   ```bash
   ps -u username
   ```
2. Sort by memory:
   ```bash
   ps aux --sort=-%mem
   ```
3. Process search:
   ```bash
   ps -C processname
   ```

## Process States
| State | Description |
|-------|-------------|
| R | Running |
| S | Sleeping |
| D | Uninterruptible |
| Z | Zombie |
| T | Stopped |
| W | Paging |
| X | Dead |
| < | High priority |
| N | Low priority |

## Related Commands
- `top` - Process viewer
- `htop` - Interactive top
- `pgrep` - Process grep
- `kill` - Send signal
- `nice` - Priority control

## Additional Resources
- [PS Manual](https://man7.org/linux/man-pages/man1/ps.1.html)
- [Process Guide](https://www.cyberciti.biz/faq/linux-ps-command/)
- [System Administration](https://www.tecmint.com/linux-ps-command-examples/)

## Best Practices
1. Use filters
2. Check resources
3. Monitor states
4. Regular checks
5. Document findings

## Security Considerations
1. Process visibility
2. User permissions
3. System impact
4. Information leak
5. Resource usage

## Troubleshooting
1. Missing processes
2. High resource use
3. Zombie processes
4. State issues
5. Performance problems

## Common Formats
1. Default
2. BSD style
3. System V
4. Custom
5. Thread view
