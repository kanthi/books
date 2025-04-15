# shutdown

## Overview
The `shutdown` command brings the system down in a secure way. It notifies users, stops processes gracefully, and either halts, powers off, or reboots the system.

## Syntax
```bash
shutdown [options] [time] [message]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Halt or power off |
| `-r` | Reboot |
| `-c` | Cancel pending shutdown |
| `-k` | Only send warning |
| `-P` | Power off |
| `-H` | Halt |
| `-f` | Force fsck on reboot |
| `-F` | Skip fsck on reboot |
| `now` | Immediate shutdown |
| `+m` | Minutes to wait |
| `HH:MM` | Specific time |

## Key Use Cases
1. System maintenance
2. Emergency shutdown
3. Scheduled reboots
4. Power management
5. User notification

## Examples with Explanations
### Example 1: Immediate Shutdown
```bash
shutdown -h now
```
Halt system immediately

### Example 2: Scheduled Reboot
```bash
shutdown -r +15 "System maintenance in 15 minutes"
```
Reboot in 15 minutes with message

### Example 3: Cancel Shutdown
```bash
shutdown -c
```
Cancel pending shutdown

## Understanding Output
System messages:
- Broadcast warning
- Process termination
- Service shutdown
- Final system state

## Common Usage Patterns
1. Power off:
   ```bash
   shutdown -P now
   ```
2. Delayed shutdown:
   ```bash
   shutdown -h +30
   ```
3. Specific time:
   ```bash
   shutdown -r 23:00
   ```

## Security Considerations
1. User permissions
2. Process termination
3. Data integrity
4. Service shutdown
5. Network connections

## Related Commands
- `reboot` - System reboot
- `poweroff` - Power off
- `halt` - Stop system
- `init` - Change runlevel
- `systemctl` - System control

## Additional Resources
- [Shutdown Manual](https://man7.org/linux/man-pages/man8/shutdown.8.html)
- [System Administration Guide](https://www.cyberciti.biz/faq/linux-system-shutdown-command/)
- [Process Management](https://www.tecmint.com/linux-process-management/)

## Best Practices
1. Notify users
2. Schedule maintenance
3. Check active processes
4. Verify file systems
5. Document actions

## Process Handling
1. SIGTERM signals
2. Service shutdown
3. Process cleanup
4. File system sync
5. Hardware shutdown

## Safety Checks
1. Active users
2. Running processes
3. Open files
4. Network connections
5. System services
