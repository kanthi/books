# kill

## Overview
The `kill` command sends signals to processes. It's primarily used to terminate processes, but can send any specified signal to a process.

## Syntax
```bash
kill [options] pid...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List signals |
| `-s signal` | Specify signal |
| `-n signum` | Signal number |
| `-v` | Verbose mode |
| `-w` | Wait for death |
| `-0` | Check existence |
| `-p` | Print PID |
| `-q` | Quiet mode |
| `-a` | All processes |
| `-u user` | User processes |

## Common Signals
| Signal | Number | Description |
|--------|---------|-------------|
| SIGHUP | 1 | Hangup |
| SIGINT | 2 | Interrupt |
| SIGQUIT | 3 | Quit |
| SIGKILL | 9 | Kill |
| SIGTERM | 15 | Terminate |
| SIGSTOP | 19 | Stop |
| SIGCONT | 18 | Continue |
| SIGUSR1 | 10 | User defined 1 |
| SIGUSR2 | 12 | User defined 2 |
| SIGTSTP | 20 | Terminal stop |

## Key Use Cases
1. Process termination
2. Process control
3. Application restart
4. Debugging
5. System management

## Examples with Explanations
### Example 1: Basic Kill
```bash
kill 1234
```
Send SIGTERM

### Example 2: Force Kill
```bash
kill -9 1234
```
Send SIGKILL

### Example 3: List Signals
```bash
kill -l
```
Show available signals

## Common Usage Patterns
1. Graceful stop:
   ```bash
   kill -15 PID
   ```
2. Force stop:
   ```bash
   kill -KILL PID
   ```
3. Check process:
   ```bash
   kill -0 PID
   ```

## Signal Handling
1. Default action
2. Ignore signal
3. Catch signal
4. Block signal
5. Process groups

## Related Commands
- `pkill` - Process kill
- `killall` - Kill by name
- `pgrep` - Process grep
- `ps` - Process status
- `top` - Process viewer

## Additional Resources
- [Kill Manual](https://man7.org/linux/man-pages/man1/kill.1.html)
- [Signal Guide](https://www.cyberciti.biz/faq/linux-kill-command-examples/)
- [System Administration](https://www.tecmint.com/linux-kill-command-examples/)

## Best Practices
1. Use SIGTERM first
2. Wait for exit
3. Check status
4. Document actions
5. Verify results

## Security Considerations
1. Process ownership
2. Signal permissions
3. System impact
4. Zombie processes
5. Resource cleanup

## Troubleshooting
1. Process won't die
2. Permission denied
3. Invalid PID
4. Zombie processes
5. Signal handling

## Process States
1. Running
2. Sleeping
3. Stopped
4. Zombie
5. Dead
