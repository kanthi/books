# timeout

## Overview
The `timeout` command runs another command with a time limit. If the command doesn't complete within the specified time, timeout terminates it, preventing hung processes and runaway commands.

## Syntax
```bash
timeout [options] duration command [args...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-k duration` | Kill after duration if still running |
| `-s signal` | Signal to send (default: TERM) |
| `--preserve-status` | Exit with command's exit status |
| `--foreground` | Don't create new process group |
| `-v` | Verbose output |

## Duration Formats
| Format | Description |
|--------|-------------|
| `10` | 10 seconds |
| `5m` | 5 minutes |
| `2h` | 2 hours |
| `1d` | 1 day |
| `30.5` | 30.5 seconds |

## Key Use Cases
1. Prevent hung processes
2. Limit command execution time
3. Testing and debugging
4. Network operation timeouts
5. Script reliability

## Examples with Explanations
### Example 1: Basic Timeout
```bash
timeout 10 ping google.com
```
Stops ping after 10 seconds

### Example 2: Different Time Units
```bash
timeout 5m long_running_script.sh
```
Kills script after 5 minutes

### Example 3: Force Kill
```bash
timeout -k 5 30 problematic_command
```
Sends TERM after 30s, KILL after 35s

### Example 4: Custom Signal
```bash
timeout -s INT 10 command
```
Sends SIGINT instead of SIGTERM

## Common Usage Patterns
1. Network operations:
   ```bash
   timeout 30 wget https://example.com/largefile.zip
   ```
2. Database operations:
   ```bash
   timeout 60 mysql -e "SELECT * FROM large_table"
   ```
3. Testing commands:
   ```bash
   timeout 5 ./test_script.sh || echo "Test timed out"
   ```

## Signal Handling
1. Default behavior:
   - Sends SIGTERM after timeout
   - Waits for graceful exit
   - Sends SIGKILL if still running

2. Custom signals:
   ```bash
   timeout -s KILL 10 command  # Immediate kill
   timeout -s USR1 10 command  # Custom signal
   ```

## Exit Status
- **0**: Command completed successfully
- **124**: Command timed out
- **125**: Timeout command failed
- **126**: Command found but not executable
- **127**: Command not found
- **Other**: Command's exit status

## Performance Analysis
- Minimal overhead
- Efficient process monitoring
- Good for preventing resource waste
- Helps maintain system stability
- Useful for automation

## Related Commands
- `kill` - Terminate processes
- `killall` - Kill by name
- `sleep` - Delay execution
- `wait` - Wait for processes
- `nohup` - Run immune to hangups

## Best Practices
1. Use appropriate timeout values
2. Handle timeout exit codes
3. Consider graceful shutdown time
4. Use -k for stubborn processes
5. Test timeout values in development

## Scripting Applications
1. Robust network operations:
   ```bash
   #!/bin/bash
   if timeout 30 ping -c 1 google.com; then
       echo "Network is available"
   else
       echo "Network timeout or unavailable"
   fi
   ```
2. Service health checks:
   ```bash
   check_service() {
       if timeout 10 curl -f http://localhost:8080/health; then
           echo "Service is healthy"
       else
           echo "Service check failed or timed out"
       fi
   }
   ```

## Error Handling
1. Check for timeout:
   ```bash
   timeout 30 command
   if [ $? -eq 124 ]; then
       echo "Command timed out"
   fi
   ```
2. Retry with timeout:
   ```bash
   for i in {1..3}; do
       if timeout 10 command; then
           break
       fi
       echo "Attempt $i failed, retrying..."
   done
   ```

## Integration Examples
1. Backup operations:
   ```bash
   timeout 1h rsync -av /data/ /backup/ || {
       echo "Backup timed out after 1 hour"
       exit 1
   }
   ```
2. Testing framework:
   ```bash
   run_test() {
       local test_name="$1"
       local time_limit="$2"

       if timeout "$time_limit" "./$test_name"; then
           echo "PASS: $test_name"
       else
           echo "FAIL: $test_name (timeout or error)"
       fi
   }
   ```

## Advanced Usage
1. Preserve exit status:
   ```bash
   timeout --preserve-status 30 command
   ```
2. Foreground execution:
   ```bash
   timeout --foreground 10 interactive_command
   ```
3. Multiple timeouts:
   ```bash
   timeout 60 timeout 30 command  # Nested timeouts
   ```

## Troubleshooting
1. Command not terminating properly
2. Signal handling issues
3. Process group problems
4. Exit status confusion
5. Time format errors

## Security Considerations
1. Prevent resource exhaustion
2. Limit exposure time for risky operations
3. Use appropriate signals
4. Monitor timeout effectiveness
5. Consider process privileges

## Real-world Examples
1. Web scraping:
   ```bash
   timeout 2m python scraper.py || echo "Scraping timed out"
   ```
2. System maintenance:
   ```bash
   timeout 30m fsck /dev/sdb1 || {
       echo "Filesystem check timed out"
       exit 1
   }
   ```
3. Monitoring scripts:
   ```bash
   while true; do
       timeout 5 check_system_health
       sleep 60
   done
   ```