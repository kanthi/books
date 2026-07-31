# tail

## Overview
The `tail` command displays the last lines of files or input streams. It's essential for monitoring log files and examining file endings.

## Syntax
```bash
tail [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n num` | Show last num lines |
| `-c num` | Show last num bytes |
| `-f` | Follow file changes |
| `-F` | Follow with retry |
| `-q` | Suppress headers |
| `-v` | Always show headers |
| `-s num` | Sleep seconds between checks |
| `--pid=pid` | Terminate after process dies |
| `--retry` | Keep trying to open file |

## Key Use Cases
1. Monitor log files
2. View file endings
3. Real-time file watching
4. Debug running processes
5. System monitoring

## Examples with Explanations
### Example 1: Default Usage
```bash
tail file.txt
```
Shows last 10 lines of file

### Example 2: Follow Log File
```bash
tail -f /var/log/syslog
```
Continuously monitors log file for new entries

### Example 3: Specific Line Count
```bash
tail -n 20 error.log
```
Shows last 20 lines

### Example 4: Multiple Files
```bash
tail -f /var/log/*.log
```
Follows multiple log files simultaneously

## Follow Mode Options
| Option | Behavior |
|--------|----------|
| `-f` | Follow by file descriptor |
| `-F` | Follow by name (handles rotation) |
| `--retry` | Keep trying if file doesn't exist |
| `--pid=pid` | Stop when process dies |

## Common Usage Patterns
1. Monitor application logs:
   ```bash
   tail -f /var/log/apache2/error.log
   ```
2. Watch system logs:
   ```bash
   tail -f /var/log/messages
   ```
3. Debug scripts:
   ```bash
   tail -f script.log &
   ./script.sh
   ```

## Advanced Usage
1. Follow with retry:
   ```bash
   tail -F /var/log/app.log
   ```
2. Stop after process ends:
   ```bash
   tail -f --pid=$PID logfile.log
   ```
3. Custom sleep interval:
   ```bash
   tail -f -s 0.1 fast_changing.log
   ```

## Performance Analysis
- Efficient for file monitoring
- Low CPU usage in follow mode
- Handles log rotation well with -F
- Good for real-time monitoring
- Minimal memory footprint

## Related Commands
- `head` - Show first lines
- `less` - Advanced pager
- `watch` - Execute commands periodically
- `journalctl` - Systemd log viewer
- `multitail` - Monitor multiple files

## Best Practices
1. Use -F for log files that rotate
2. Combine with grep for filtering
3. Use --pid for temporary monitoring
4. Consider multitail for multiple files
5. Be aware of file descriptor limits

## Integration Examples
1. Filtered monitoring:
   ```bash
   tail -f /var/log/syslog | grep ERROR
   ```
2. Multiple log analysis:
   ```bash
   tail -f /var/log/{messages,secure,maillog}
   ```
3. Application debugging:
   ```bash
   tail -f app.log | while read line; do
       echo "$(date): $line"
   done
   ```

## Log Rotation Handling
1. Follow by name (handles rotation):
   ```bash
   tail -F /var/log/app.log
   ```
2. Retry if file disappears:
   ```bash
   tail -f --retry /var/log/app.log
   ```

## Scripting Applications
1. Wait for log entry:
   ```bash
   tail -f app.log | grep -q "Server started" && echo "Ready"
   ```
2. Monitor until condition:
   ```bash
   timeout 60 tail -f deploy.log | grep -q "Deployment complete"
   ```

## System Monitoring
1. Watch system load:
   ```bash
   tail -f /proc/loadavg
   ```
2. Monitor memory:
   ```bash
   watch -n 1 'tail -5 /proc/meminfo'
   ```
## Additional Examples
```bash
tail file.txt
tail -n 100 file.txt
tail -f /var/log/syslog      # follow
tail -F app.log              # follow with rename reopen
journalctl -u nginx -f       # often better for units
```
