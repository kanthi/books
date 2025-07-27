# nice

## Overview
The `nice` command runs a program with modified scheduling priority. It allows you to start a process with a different niceness (priority) value.

## Syntax
```bash
nice [options] [command [arguments]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n adjustment` | Priority value |
| `--adjustment` | Priority value |
| `-h` | Show help |
| `-v` | Verbose mode |
| `--version` | Show version |

## Nice Values
| Value | Priority |
|-------|----------|
| -20 | Highest |
| -10 | High |
| 0 | Normal |
| 10 | Low |
| 19 | Lowest |

## Key Use Cases
1. Process priority
2. Resource control
3. Background tasks
4. System optimization
5. Performance tuning

## Examples with Explanations
### Example 1: Basic Usage
```bash
nice command
```
Run with default nice

### Example 2: Set Priority
```bash
nice -n 10 command
```
Run with lower priority

### Example 3: High Priority
```bash
nice -n -10 command
```
Run with higher priority

## Common Usage Patterns
1. Background task:
   ```bash
   nice -n 19 longprocess
   ```
2. CPU intensive:
   ```bash
   nice -n -10 compute
   ```
3. Check nice:
   ```bash
   nice -n 0 nice
   ```

## Priority Management
1. Default priority
2. Adjustment range
3. User limits
4. System impact
5. Process groups

## Related Commands
- `renice` - Change priority
- `top` - Process viewer
- `ps` - Process status
- `ionice` - I/O priority
- `chrt` - Real-time priority

## Additional Resources
- [Nice Manual](https://man7.org/linux/man-pages/man1/nice.1.html)
- [Priority Guide](https://www.cyberciti.biz/faq/linux-nice-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-nice-command-examples/)

## Best Practices
1. Check limits
2. Monitor impact
3. Document usage
4. Test settings
5. Regular review

## Security Considerations
1. User permissions
2. System resources
3. Priority limits
4. Process control
5. Resource abuse

## Troubleshooting
1. Permission denied
2. Priority limits
3. System load
4. Process behavior
5. Resource conflicts

## System Impact
1. CPU scheduling
2. Process priority
3. System load
4. User experience
5. Resource sharing
