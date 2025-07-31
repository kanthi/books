# nohup

## Overview
The `nohup` command runs commands immune to hangups, allowing processes to continue running even after the user logs out or the terminal is closed.

## Syntax
```bash
nohup command [arguments] &
nohup command [arguments] > output.log 2>&1 &
```

## Key Features
| Feature | Description |
|---------|-------------|
| Hangup immunity | Process survives terminal closure |
| Background execution | Runs in background with & |
| Output redirection | Saves output to nohup.out |
| Signal handling | Ignores SIGHUP signal |
| Session independence | Detaches from controlling terminal |

## Default Behavior
- Redirects stdout to `nohup.out`
- Redirects stderr to stdout
- Ignores SIGHUP signal
- Process continues after logout

## Key Use Cases
1. Long-running scripts
2. Background services
3. Remote command execution
4. Batch processing
5. Server maintenance tasks

## Examples with Explanations
### Example 1: Basic Usage
```bash
nohup ./long_script.sh &
```
Runs script in background, immune to hangups

### Example 2: Custom Output File
```bash
nohup python script.py > script.log 2>&1 &
```
Redirects all output to custom log file

### Example 3: Multiple Commands
```bash
nohup bash -c 'command1 && command2 && command3' &
```
Runs sequence of commands with nohup

## Output Redirection
| Redirection | Description |
|-------------|-------------|
| `> file` | Redirect stdout to file |
| `2>&1` | Redirect stderr to stdout |
| `> /dev/null 2>&1` | Discard all output |
| `>> file` | Append to file |
| `2> error.log` | Redirect stderr to file |

## Common Usage Patterns
1. Silent background execution:
   ```bash
   nohup command > /dev/null 2>&1 &
   ```
2. With custom log:
   ```bash
   nohup ./script.sh > script.log 2>&1 &
   ```
3. Get process ID:
   ```bash
   nohup command & echo $! > pid.txt
   ```

## Process Management
1. Check running processes:
   ```bash
   ps aux | grep script_name
   ```
2. Kill nohup process:
   ```bash
   kill $(cat pid.txt)
   ```
3. Monitor output:
   ```bash
   tail -f nohup.out
   ```

## Signal Handling
Signals and nohup:
- **SIGHUP**: Ignored by nohup
- **SIGTERM**: Can still terminate process
- **SIGKILL**: Force kills process
- **SIGINT**: Usually ignored in background

## Performance Analysis
- Minimal overhead
- No performance impact on command
- Efficient for long-running tasks
- Good for resource-intensive operations
- Suitable for batch processing

## Related Commands
- `screen` - Terminal multiplexer
- `tmux` - Terminal multiplexer
- `disown` - Remove job from shell
- `bg` - Put job in background
- `jobs` - List active jobs

## Additional Resources
- [Nohup Manual](https://www.gnu.org/software/coreutils/manual/html_node/nohup-invocation.html)
- [Background Process Guide](https://www.tecmint.com/nohup-command-examples/)

## Best Practices
1. Always use & for background execution
2. Redirect output to avoid nohup.out clutter
3. Save process IDs for management
4. Monitor long-running processes
5. Use appropriate log rotation

## Advanced Usage
1. With environment variables:
   ```bash
   nohup env VAR=value command &
   ```
2. Conditional execution:
   ```bash
   nohup bash -c 'if condition; then command; fi' &
   ```
3. With timeout:
   ```bash
   nohup timeout 3600 command &
   ```

## Scripting Examples
1. Backup script:
   ```bash
   #!/bin/bash
   nohup rsync -av /data/ /backup/ > backup.log 2>&1 &
   echo $! > backup.pid
   ```
2. Service starter:
   ```bash
   start_service() {
       nohup ./service > service.log 2>&1 &
       echo $! > service.pid
   }
   ```
3. Batch processor:
   ```bash
   nohup find /data -name "*.txt" -exec process_file {} \; &
   ```

## Monitoring and Control
1. Check if process is running:
   ```bash
   if ps -p $(cat pid.txt) > /dev/null; then
       echo "Process running"
   fi
   ```
2. Monitor resource usage:
   ```bash
   top -p $(cat pid.txt)
   ```
3. Follow log output:
   ```bash
   tail -f nohup.out
   ```

## Common Pitfalls
1. Forgetting the & symbol
2. Not redirecting output properly
3. Losing track of process IDs
4. Not monitoring disk space for logs
5. Assuming process will always run

## Integration Examples
1. With cron for scheduled tasks:
   ```bash
   0 2 * * * nohup /path/to/script.sh > /var/log/script.log 2>&1 &
   ```
2. SSH remote execution:
   ```bash
   ssh user@server 'nohup ./remote_script.sh > script.log 2>&1 &'
   ```
3. Service management:
   ```bash
   nohup java -jar application.jar > app.log 2>&1 &
   ```

## Alternatives Comparison
| Tool | Use Case |
|------|----------|
| `nohup` | Simple background execution |
| `screen` | Interactive session management |
| `tmux` | Advanced terminal multiplexing |
| `systemd` | System service management |
| `supervisor` | Process supervision |

## Troubleshooting
1. Process not starting
2. Output not being captured
3. Process dying unexpectedly
4. Permission issues
5. Resource limitations

## Security Considerations
1. Log file permissions
2. Process ownership
3. Resource consumption
4. Output sensitive data
5. Process monitoring