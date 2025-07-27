# shutdown

## Overview
The `shutdown` command brings the system down in a secure way. It notifies all users and processes of the pending shutdown, blocks new logins, and then either halts, powers off, or reboots the system.

## Syntax
```bash
shutdown [options] [time] [message]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Halt or power off after shutdown |
| `-r` | Reboot after shutdown |
| `-c` | Cancel a pending shutdown |
| `-k` | Only send warning messages, don't shutdown |
| `-P` | Power off the machine |
| `now` | Execute shutdown immediately |
| `+m` | Execute shutdown in 'm' minutes |

## Key Use Cases
1. System maintenance
2. Emergency shutdowns
3. Scheduled reboots
4. Power management
5. System updates

## Examples with Explanations
### Example 1: Immediate Shutdown
```bash
shutdown -h now
```
Halts the system immediately

### Example 2: Scheduled Reboot
```bash
shutdown -r +15 "System reboot for maintenance"
```
Schedules a reboot in 15 minutes with a message

### Example 3: Cancel Shutdown
```bash
shutdown -c
```
Cancels a pending shutdown

## Understanding Output
- Warning messages to all users
- Time remaining until shutdown
- System messages during shutdown process
- Final shutdown status

## Common Usage Patterns
1. Immediate power off:
   ```bash
   shutdown -P now
   ```
2. Delayed shutdown with message:
   ```bash
   shutdown -h +30 "System maintenance in 30 minutes"
   ```
3. Schedule reboot at specific time:
   ```bash
   shutdown -r 23:00
   ```

## Performance Analysis
- Minimal system impact
- Ensures clean process termination
- Syncs filesystem before shutdown
- Monitors service shutdown status

## Related Commands
- `reboot` - Restart system
- `poweroff` - Power off system
- `halt` - Stop all processes
- `init` - Change system runlevel
- `systemctl` - Control systemd system

## Additional Resources
- [Linux shutdown manual](https://man7.org/linux/man-pages/man8/shutdown.8.html)
- [System Administration Guide](https://www.redhat.com/sysadmin/linux-shutdown-reboot)
