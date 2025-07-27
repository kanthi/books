# top

## Overview
The `top` command provides a dynamic real-time view of running processes. It shows system summary information and a list of processes or threads currently managed by the Linux kernel.

## Syntax
```bash
top [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Batch mode output |
| `-n num` | Number of iterations |
| `-d delay` | Screen update interval |
| `-p pid` | Monitor specific PIDs |
| `-u user` | Show specific user's processes |
| `-H` | Show threads |
| `-i` | Ignore idle processes |
| `-c` | Show command line |
| `-w` | Wide output |

## Key Use Cases
1. System monitoring
2. Process tracking
3. Resource usage analysis
4. Performance troubleshooting
5. Memory management

## Examples with Explanations
### Example 1: Basic Usage
```bash
top
```
Show dynamic process view

### Example 2: Specific User
```bash
top -u username
```
Show user's processes

### Example 3: Specific Process
```bash
top -p 1234
```
Monitor specific PID

## Interactive Commands
| Key | Action |
|-----|--------|
| h | Help |
| q | Quit |
| k | Kill process |
| r | Renice process |
| f | Fields management |
| o | Sort field |
| M | Sort by memory |
| P | Sort by CPU |
| T | Sort by time |
| W | Save settings |

## Understanding Output
Header sections:
1. System uptime and load
2. Tasks summary
3. CPU states
4. Memory usage
5. Swap usage
6. Process list

## Common Usage Patterns
1. Monitor system load:
   ```bash
   top -d 5
   ```
2. Save output:
   ```bash
   top -b -n 1 > top_output.txt
   ```
3. Track specific processes:
   ```bash
   top -p $(pgrep firefox)
   ```

## Performance Analysis
- Real-time monitoring
- Resource overhead
- Update frequency impact
- Process count effect
- Memory usage

## Related Commands
- `htop` - Enhanced top
- `ps` - Process status
- `vmstat` - Virtual memory stats
- `free` - Memory usage
- `kill` - Terminate processes

## Additional Resources
- [Procps Documentation](https://gitlab.com/procps-ng/procps)
- [Linux Process Management](https://www.tecmint.com/linux-process-management/)
- [Top Command Guide](https://www.booleanworld.com/guide-linux-top-command/)

## Best Practices
1. Regular monitoring
2. Custom configurations
3. Alert thresholds
4. Resource tracking
5. Performance baselines
