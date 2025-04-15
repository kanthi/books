# nice

## Overview
The `nice` command runs a program with modified scheduling priority. It allows you to start a process with a different niceness (priority) value.

## Syntax
```bash
nice [-n adjustment] command [args]...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n N` | Add N to niceness (default 10) |
| `--adjustment=N` | Same as -n N |
| `-h` | Display help |
| `-v` | Verbose mode |
| `--version` | Show version |

## Nice Values
- Range: -20 to 19
- Lower values = higher priority
- Higher values = lower priority
- Default: 0
- Only root can set negative values

## Key Use Cases
1. Process prioritization
2. Resource management
3. Background tasks
4. CPU scheduling
5. Performance optimization

## Examples with Explanations
### Example 1: Basic Usage
```bash
nice command
```
Run command with increased niceness (+10)

### Example 2: Specific Priority
```bash
nice -n 15 command
```
Run command with niceness 15

### Example 3: Maximum Priority
```bash
sudo nice -n -20 command
```
Run command with highest priority

## Understanding Output
- Command output as normal
- Error messages for:
  - Permission denied
  - Invalid adjustment
  - Command not found
  - Priority range errors

## Common Usage Patterns
1. Lower priority task:
   ```bash
   nice -n 19 backup.sh
   ```
2. Higher priority task:
   ```bash
   sudo nice -n -10 critical_task
   ```
3. Check current nice value:
   ```bash
   nice
   ```

## Performance Analysis
- Priority impact
- CPU scheduling
- System load effect
- Resource allocation
- Process behavior

## Related Commands
- `renice` - Change priority
- `top` - Process monitoring
- `ps` - Process status
- `ionice` - I/O scheduling
- `chrt` - Real-time scheduling

## Additional Resources
- [Nice Manual](https://www.gnu.org/software/coreutils/manual/html_node/nice-invocation.html)
- [Process Priority Guide](https://www.tecmint.com/set-linux-process-priority-using-nice-and-renice-commands/)
- [CPU Scheduling](https://www.kernel.org/doc/html/latest/scheduler/sched-nice-design.html)

## Best Practices
1. Use appropriate values
2. Monitor system impact
3. Document priorities
4. Consider dependencies
5. Regular review

## Use Cases
1. Batch processing
2. System maintenance
3. Background services
4. CPU-intensive tasks
5. Non-critical operations
