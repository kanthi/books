# w

## Overview
The `w` command displays information about currently logged-in users and their activities. It shows more detailed information than `who`, including system load and what each user is doing.

## Syntax
```bash
w [options] [user]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Don't print header |
| `-u` | Ignore username in process |
| `-s` | Short format |
| `-f` | Toggle printing from field |
| `-o` | Old style output |
| `-i` | Display IP instead of hostname |

## Key Use Cases
1. Monitor user activity
2. System load analysis
3. Security auditing
4. Performance monitoring
5. Session management

## Examples with Explanations
### Example 1: Basic Usage
```bash
w
```
Shows system load and all logged-in users with their activities

### Example 2: Specific User
```bash
w username
```
Shows information for specific user only

### Example 3: Short Format
```bash
w -s
```
Displays condensed output without JCPU and PCPU

## Understanding Output
Header information:
- Current time
- System uptime
- Number of logged-in users
- Load averages (1, 5, 15 minutes)

User columns:
- **USER**: Username
- **TTY**: Terminal
- **FROM**: Remote hostname/IP
- **LOGIN@**: Login time
- **IDLE**: Idle time
- **JCPU**: CPU time used by all processes
- **PCPU**: CPU time used by current process
- **WHAT**: Current command

## Load Average Interpretation
Load averages represent:
- **1 min**: Recent system load
- **5 min**: Medium-term load
- **15 min**: Long-term load

Values relative to CPU cores:
- 1.0 = 100% utilization on single-core system
- 2.0 = 100% utilization on dual-core system

## Common Usage Patterns
1. Quick system overview:
   ```bash
   w | head -1
   ```
2. Find idle users:
   ```bash
   w | awk '$5 ~ /[0-9]+days/ {print $1, $5}'
   ```
3. Monitor specific activity:
   ```bash
   w | grep -v idle
   ```

## Advanced Usage
1. No header output:
   ```bash
   w -h
   ```
2. Show IP addresses:
   ```bash
   w -i
   ```
3. Old-style format:
   ```bash
   w -o
   ```

## Performance Analysis
Information useful for:
- System load monitoring
- User activity tracking
- Resource utilization
- Performance bottleneck identification
- Capacity planning

## Related Commands
- `who` - Basic user information
- `uptime` - System load and uptime
- `top` - Process activity
- `users` - Simple user list
- `last` - Login history

## Best Practices
1. Regular system monitoring
2. Identify resource-heavy users
3. Monitor for unusual activity
4. Track system performance trends
5. Use for capacity planning

## System Monitoring
1. Load average alerts:
   ```bash
   LOAD=$(w | head -1 | awk '{print $10}' | cut -d, -f1)
   if (( $(echo "$LOAD > 2.0" | bc -l) )); then
       echo "High system load: $LOAD"
   fi
   ```
2. Idle user detection:
   ```bash
   w | awk '$5 ~ /days/ {print "Idle user:", $1, "for", $5}'
   ```

## Security Applications
1. Monitor unauthorized access:
   ```bash
   w | grep -v "$(whoami)" | tail -n +2
   ```
2. Track remote connections:
   ```bash
   w | awk '$3 !~ /^-/ {print $1, $3}'
   ```

## Scripting Examples
1. System status report:
   ```bash
   #!/bin/bash
   echo "=== System Status ==="
   w | head -1
   echo "=== Active Users ==="
   w -h | wc -l
   ```
2. Performance monitoring:
   ```bash
   while true; do
       LOAD=$(w | head -1 | awk '{print $12}' | cut -d, -f1)
       echo "$(date): Load average: $LOAD"
       sleep 60
   done
   ```

## Integration Examples
1. Alert system:
   ```bash
   HIGH_LOAD=$(w | head -1 | awk '{print $12}' | cut -d, -f1)
   if (( $(echo "$HIGH_LOAD > 5.0" | bc -l) )); then
       mail -s "High Load Alert" admin@domain.com < /dev/null
   fi
   ```
2. User activity log:
   ```bash
   echo "$(date): $(w -h | wc -l) active users" >> activity.log
   w -h >> activity.log
   ```

## Output Parsing
1. Extract load average:
   ```bash
   w | head -1 | awk '{print $(NF-2)}' | cut -d, -f1
   ```
2. Get active user count:
   ```bash
   w -h | wc -l
   ```
3. Find users by activity:
   ```bash
   w | awk '$NF !~ /^-/ {print $1, $NF}'
   ```

## Troubleshooting
1. High load investigation
2. Idle session cleanup
3. Resource usage analysis
4. Network connectivity issues
5. User activity verification

## Automation Examples
1. Scheduled monitoring:
   ```bash
   # Crontab entry
   */5 * * * * w | head -1 >> /var/log/system-load.log
   ```
2. Threshold alerting:
   ```bash
   LOAD_THRESHOLD=3.0
   CURRENT_LOAD=$(w | head -1 | awk '{print $12}' | cut -d, -f1)
   (( $(echo "$CURRENT_LOAD > $LOAD_THRESHOLD" | bc -l) )) && alert_admin
   ```