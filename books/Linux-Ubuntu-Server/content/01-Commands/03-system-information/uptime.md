# uptime

## Overview
The `uptime` command shows how long the system has been running, along with the current time, number of users, and system load averages.

## Syntax
```bash
uptime [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p, --pretty` | Show uptime in pretty format |
| `-s, --since` | System up since |
| `-V, --version` | Display version |
| `-h, --help` | Display help |

## Key Use Cases
1. System monitoring
2. Performance analysis
3. Load tracking
4. User activity monitoring
5. System availability checks

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
Show uptime in readable format

### Example 3: Boot Time
```bash
uptime -s
```
Show system start time

## Understanding Output
Example output:
```
14:28:00 up 1 day, 2:03, 5 users, load average: 0.52, 0.58, 0.59
```
Components:
- Current time
- System uptime
- Number of users
- Load averages (1, 5, 15 minutes)

## Common Usage Patterns
1. Quick system check:
   ```bash
   uptime
   ```
2. Monitor load:
   ```bash
   watch uptime
   ```
3. Uptime logging:
   ```bash
   uptime >> uptime.log
   ```

## Performance Analysis
- Instant execution
- Minimal resource usage
- Real-time information
- Load average calculation
- User session counting

## Related Commands
- `w` - Show who is logged in
- `top` - System monitoring
- `who` - Show logged in users
- `last` - Login history
- `procinfo` - System statistics

## Additional Resources
- [GNU Coreutils - uptime](https://www.gnu.org/software/coreutils/manual/html_node/uptime-invocation.html)
- [System Monitoring Guide](https://www.tecmint.com/linux-system-monitoring-tools/)
- [Load Average Explained](http://www.brendangregg.com/blog/2017-08-08/linux-load-averages.html)

## Load Average
Understanding load averages:
1. 1-minute average
2. 5-minute average
3. 15-minute average
4. Interpretation
5. Thresholds

## Best Practices
1. Regular monitoring
2. Load tracking
3. Trend analysis
4. Alert thresholds
5. Performance correlation
