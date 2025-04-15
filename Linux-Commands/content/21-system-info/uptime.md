# uptime

## Overview
The `uptime` command shows how long the system has been running. It displays the current time, system uptime, number of users, and load averages.

## Syntax
```bash
uptime [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p` | Pretty format |
| `-s` | Since date |
| `-h` | Show help |
| `-V` | Show version |
| `--pretty` | Pretty output |
| `--since` | Boot time |
| `--help` | Show help |
| `--version` | Show version |

## Output Fields
| Field | Description |
|-------|-------------|
| Time | Current time |
| Uptime | Running time |
| Users | Connected users |
| Load1 | 1 minute load |
| Load5 | 5 minute load |
| Load15 | 15 minute load |

## Key Use Cases
1. System monitoring
2. Load analysis
3. Uptime tracking
4. User activity
5. Performance checking

## Examples with Explanations
### Example 1: Basic Usage
```bash
uptime
```
Show all information

### Example 2: Pretty Format
```bash
uptime -p
```
Human readable time

### Example 3: Boot Time
```bash
uptime -s
```
System start time

## Common Usage Patterns
1. Quick check:
   ```bash
   uptime
   ```
2. Simple format:
   ```bash
   uptime -p
   ```
3. Boot time:
   ```bash
   uptime -s
   ```

## System Information
1. Running time
2. System load
3. User count
4. Current time
5. Load trends

## Related Commands
- `w` - Who is logged in
- `top` - System monitor
- `who` - Show users
- `last` - Login history
- `procinfo` - System stats

## Additional Resources
- [Uptime Manual](https://man7.org/linux/man-pages/man1/uptime.1.html)
- [System Guide](https://www.cyberciti.biz/faq/linux-uptime-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-uptime-command-examples/)

## Best Practices
1. Regular checking
2. Load monitoring
3. User tracking
4. Documentation
5. Trend analysis

## Performance Analysis
1. Load averages
2. User activity
3. System stability
4. Uptime goals
5. Resource usage

## Troubleshooting
1. High load
2. User issues
3. System stability
4. Resource problems
5. Performance degradation

## Common Uses
1. System monitoring
2. Performance checks
3. Availability tracking
4. Load analysis
5. User activity
