# logger

## Overview
The `logger` command makes entries in the system log. It provides a shell command interface to the syslog system log module, allowing you to create log entries from the command line or scripts.

## Syntax
```bash
logger [options] [message]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f file` | Log contents of file |
| `-i` | Log process ID |
| `-p priority` | Specify message priority |
| `-t tag` | Mark every line with specified tag |
| `-n server` | Write to remote syslog server |
| `-s` | Output to standard error as well |
| `-u socket` | Write to specified socket |
| `--id=[id]` | Enter log entry with specified ID |

## Key Use Cases
1. Script logging
2. System monitoring
3. Application debugging
4. Security auditing
5. Event tracking

## Examples with Explanations
### Example 1: Basic Logging
```bash
logger "System backup completed successfully"
```
Logs a simple message to syslog

### Example 2: Tagged Message
```bash
logger -t BACKUP -p local0.info "Backup process started"
```
Logs a tagged message with priority

### Example 3: Log File Contents
```bash
logger -f /var/log/myapp.log
```
Sends file contents to syslog

## Understanding Output
Priority Levels:
- emerg (0): System is unusable
- alert (1): Action must be taken immediately
- crit (2): Critical conditions
- err (3): Error conditions
- warning (4): Warning conditions
- notice (5): Normal but significant
- info (6): Informational
- debug (7): Debug-level messages

## Common Usage Patterns
1. Script logging:
   ```bash
   logger -t myscript -p local0.info "Script started"
   ```
2. Error logging:
   ```bash
   logger -i -t myapp -p local0.err "Error: Database connection failed"
   ```
3. Remote logging:
   ```bash
   logger -n logserver.example.com -P 514 "Remote log entry"
   ```

## Performance Analysis
- Minimal system impact
- Asynchronous operation
- Consider log rotation
- Monitor disk usage
- Check syslog configuration

## Related Commands
- `syslogd` - System log daemon
- `klogd` - Kernel log daemon
- `dmesg` - Print kernel messages
- `tail` - Monitor log files
- `journalctl` - Query systemd journal

## Additional Resources
- [Linux logger manual](https://man7.org/linux/man-pages/man1/logger.1.html)
- [Syslog Protocol RFC](https://tools.ietf.org/html/rfc5424)
- [System Logging Guide](https://www.rsyslog.com/doc/master/)