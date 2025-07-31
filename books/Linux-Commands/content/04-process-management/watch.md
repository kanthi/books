# watch

## Overview
The `watch` command executes a program repeatedly and displays its output, allowing you to monitor changes over time. It's essential for real-time system monitoring and observing command output changes.

## Syntax
```bash
watch [options] command
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n seconds` | Update interval (default: 2) |
| `-d` | Highlight differences |
| `-t` | Turn off header |
| `-b` | Beep on command failure |
| `-e` | Exit on command failure |
| `-g` | Exit when output changes |
| `-c` | Interpret ANSI color sequences |
| `-x` | Pass command to exec instead of sh |
| `-p` | Precise timing |

## Key Use Cases
1. Monitor system resources
2. Watch file changes
3. Track process status
4. Monitor network connections
5. Observe command output changes

## Examples with Explanations
### Example 1: Monitor Disk Usage
```bash
watch df -h
```
Updates disk usage display every 2 seconds

### Example 2: Watch Process List
```bash
watch -n 1 'ps aux | head -10'
```
Updates process list every second

### Example 3: Monitor with Differences
```bash
watch -d free -h
```
Highlights changes in memory usage

### Example 4: Watch File Size
```bash
watch -n 0.5 'ls -lh largefile.txt'
```
Monitors file size changes every 0.5 seconds

## System Monitoring
1. CPU usage:
   ```bash
   watch -n 1 'cat /proc/loadavg'
   ```
2. Memory usage:
   ```bash
   watch -d 'free -h && echo && ps aux --sort=-%mem | head -5'
   ```
3. Network connections:
   ```bash
   watch -n 2 'netstat -tuln | grep LISTEN'
   ```

## File and Directory Monitoring
1. Directory contents:
   ```bash
   watch -d 'ls -la /tmp'
   ```
2. File modifications:
   ```bash
   watch -n 1 'stat file.txt | grep Modify'
   ```
3. Log file growth:
   ```bash
   watch -d 'wc -l /var/log/syslog'
   ```

## Process Monitoring
1. Specific process:
   ```bash
   watch -n 1 'ps aux | grep [p]rocess_name'
   ```
2. Process tree:
   ```bash
   watch -n 2 'pstree -p'
   ```
3. Process resource usage:
   ```bash
   watch -n 1 'top -bn1 | head -15'
   ```

## Advanced Usage
1. Exit on change:
   ```bash
   watch -g 'ls /tmp | wc -l'
   ```
2. Beep on failure:
   ```bash
   watch -b 'ping -c 1 google.com'
   ```
3. Precise timing:
   ```bash
   watch -p -n 0.1 'date +%S.%N'
   ```

## Performance Analysis
- Low CPU overhead
- Configurable update intervals
- Good for long-term monitoring
- Minimal memory usage
- Efficient for repetitive tasks

## Related Commands
- `tail -f` - Follow file changes
- `top` - Process monitor
- `htop` - Interactive process viewer
- `iostat` - I/O statistics
- `vmstat` - Virtual memory stats

## Best Practices
1. Use appropriate update intervals
2. Combine multiple commands with &&
3. Use quotes for complex commands
4. Consider system load impact
5. Use -d to highlight changes

## Network Monitoring
1. Active connections:
   ```bash
   watch -n 1 'ss -tuln'
   ```
2. Network traffic:
   ```bash
   watch -d 'cat /proc/net/dev'
   ```
3. Ping monitoring:
   ```bash
   watch -n 1 'ping -c 1 8.8.8.8 | tail -2'
   ```

## Service Monitoring
1. Service status:
   ```bash
   watch -n 5 'systemctl status apache2'
   ```
2. Port availability:
   ```bash
   watch -n 2 'nc -zv localhost 80'
   ```
3. Database connections:
   ```bash
   watch -n 3 'mysql -e "SHOW PROCESSLIST"'
   ```

## Scripting Applications
1. Automated monitoring:
   ```bash
   #!/bin/bash
   # Monitor until condition met
   watch -g 'test -f /tmp/done.flag' && echo "Process completed"
   ```
2. Resource threshold monitoring:
   ```bash
   watch -n 1 'free | awk "NR==2{printf \"%.2f%%\", \$3/\$2*100}"'
   ```

## Integration Examples
1. With logging:
   ```bash
   watch -n 10 'df -h | tee -a disk_usage.log'
   ```
2. Combined monitoring:
   ```bash
   watch -n 1 'echo "=== CPU ===" && uptime && echo "=== Memory ===" && free -h'
   ```
3. Alert integration:
   ```bash
   watch -n 30 'df -h | awk "$5 > 90 {print}" | mail -s "Disk Alert" admin'
   ```

## Color and Formatting
1. Preserve colors:
   ```bash
   watch -c 'ls --color=always'
   ```
2. Custom formatting:
   ```bash
   watch -n 1 'printf "\033[2J\033[H"; date; echo; ps aux | head -10'
   ```

## Error Handling
1. Exit on command failure:
   ```bash
   watch -e 'ping -c 1 unreachable_host'
   ```
2. Beep on errors:
   ```bash
   watch -b 'test -f important_file.txt'
   ```
3. Continue on errors:
   ```bash
   watch 'command_that_might_fail || echo "Command failed"'
   ```

## Troubleshooting
1. High CPU usage with short intervals
2. Terminal size limitations
3. Command quoting issues
4. Color display problems
5. Timing precision limitations

## Security Considerations
1. Avoid displaying sensitive information
2. Be careful with command injection
3. Monitor resource usage
4. Consider screen locking
5. Validate command inputs

## Alternative Approaches
1. Using while loop:
   ```bash
   while true; do
       clear
       command
       sleep 2
   done
   ```
2. Using inotify for file watching:
   ```bash
   inotifywait -m /path/to/file
   ```

## Real-world Examples
1. Development monitoring:
   ```bash
   watch -n 1 'make test 2>&1 | tail -10'
   ```
2. Deployment monitoring:
   ```bash
   watch -d 'kubectl get pods'
   ```
3. Performance testing:
   ```bash
   watch -n 0.5 'curl -w "%{time_total}\n" -o /dev/null -s http://localhost'
   ```

## Customization
1. Custom header:
   ```bash
   watch -t 'echo "Custom Monitor - $(date)"; echo; command'
   ```
2. Multiple commands:
   ```bash
   watch 'echo "=== Disk ===" && df -h && echo "=== Memory ===" && free -h'
   ```