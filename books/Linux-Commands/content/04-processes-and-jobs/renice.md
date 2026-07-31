# renice

## Overview
The `renice` command alters the scheduling priority of running processes. It allows you to change the nice value of processes that are already running.

## Syntax
```bash
renice [-n] priority [-g|-p|-u] identifier...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n` | Specify nice increment |
| `-g` | Interpret as process groups |
| `-p` | Interpret as process IDs |
| `-u` | Interpret as usernames |
| `--help` | Display help |
| `--version` | Show version |

## Nice Values
- Range: -20 to 19
- Lower values = higher priority
- Higher values = lower priority
- Only root can set negative values
- Default: current nice value

## Key Use Cases
1. Adjust process priority
2. Resource management
3. Performance tuning
4. System optimization
5. Process control

## Examples with Explanations
### Example 1: Basic Usage
```bash
renice +5 -p 1234
```
Change priority of PID 1234

### Example 2: User Processes
```bash
renice 10 -u username
```
Change priority of user's processes

### Example 3: Process Group
```bash
renice -5 -g 100
```
Change priority of process group

## Understanding Output
Format:
```
1234: old priority 0, new priority 5
```
Error messages for:
- Permission denied
- Invalid priority
- Process not found
- User not found

## Common Usage Patterns
1. Lower process priority:
   ```bash
   renice +10 -p $(pgrep firefox)
   ```
2. Increase user priority:
   ```bash
   sudo renice -5 -u apache
   ```
3. Multiple processes:
   ```bash
   renice 5 -p 1234 5678
   ```

## Performance Analysis
- Priority impact
- System load effect
- Resource allocation
- Process behavior
- Scheduling changes

## Related Commands
- `nice` - Start with priority
- `top` - Process monitoring
- `ps` - Process status
- `ionice` - I/O scheduling
- `chrt` - Real-time scheduling

## Additional Resources
- [Renice Manual](https://man7.org/linux/man-pages/man1/renice.1.html)
- [Process Priority Guide](https://www.tecmint.com/set-linux-process-priority-using-nice-and-renice-commands/)
- [CPU Scheduling](https://www.kernel.org/doc/html/latest/scheduler/sched-design-CFS.html)

## Best Practices
1. Monitor system impact
2. Document changes
3. Consider dependencies
4. Regular review
5. Use appropriate values

## Use Cases
1. Performance tuning
2. Resource allocation
3. System maintenance
4. Service optimization
5. Troubleshooting
