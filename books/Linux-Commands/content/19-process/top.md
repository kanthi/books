# top

## Overview
The `top` command provides a dynamic real-time view of running processes. It shows system summary information and a list of processes currently being managed by the Linux kernel.

## Syntax
```bash
top [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Batch mode |
| `-n num` | Number of iterations |
| `-p pid` | Monitor PID |
| `-u user` | User processes |
| `-H` | Show threads |
| `-i` | Idle processes |
| `-c` | Command line |
| `-w` | Output width |
| `-d delay` | Update delay |
| `-o field` | Sort field |
| `-U user` | User filter |
| `-E scale` | Memory scale |

## Interactive Commands
| Key | Action |
|-----|--------|
| `h` | Help |
| `q` | Quit |
| `k` | Kill process |
| `r` | Renice process |
| `f` | Fields management |
| `o` | Sort field |
| `u` | User filter |
| `M` | Sort by memory |
| `P` | Sort by CPU |
| `T` | Sort by time |
| `W` | Write config |

## Key Use Cases
1. System monitoring
2. Resource tracking
3. Process management
4. Performance analysis
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
top
```
Show system status

### Example 2: Specific User
```bash
top -u username
```
Show user processes

### Example 3: Batch Mode
```bash
top -b -n 1
```
Single iteration output

## Common Usage Patterns
1. Monitor PID:
   ```bash
   top -p 1234
   ```
2. Sort by memory:
   ```bash
   top -o %MEM
   ```
3. Update faster:
   ```bash
   top -d 0.5
   ```

## Header Information
1. System uptime
2. Load averages
3. CPU states
4. Memory usage
5. Swap usage

## Related Commands
- `ps` - Process status
- `htop` - Interactive top
- `atop` - Advanced top
- `free` - Memory info
- `vmstat` - Virtual memory

## Additional Resources
- [Top Manual](https://man7.org/linux/man-pages/man1/top.1.html)
- [Process Guide](https://www.cyberciti.biz/faq/linux-top-command/)
- [System Administration](https://www.tecmint.com/linux-top-command-examples/)

## Best Practices
1. Regular monitoring
2. Set refresh rate
3. Use filters
4. Check trends
5. Document issues

## Security Considerations
1. Process visibility
2. User permissions
3. Resource impact
4. Signal handling
5. Configuration

## Troubleshooting
1. High CPU use
2. Memory leaks
3. Process states
4. System load
5. Performance issues

## Output Fields
1. PID
2. USER
3. PR/NI
4. VIRT/RES/SHR
5. S (Status)
