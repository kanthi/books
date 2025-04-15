# logger

## Overview
The `logger` command makes entries in the system log. It provides a shell command interface to the syslog system log module.

## Syntax
```bash
logger [options] [message]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Log process ID |
| `-f file` | Log file contents |
| `-p priority` | Specify priority |
| `-t tag` | Mark with tag |
| `-n server` | Write to remote server |
| `-P port` | Use port number |
| `-s` | Output to stderr |
| `-u socket` | Write to socket |
| `--id=[id]` | Log with id |
| `--rfc3164` | Use RFC 3164 format |
| `--rfc5424` | Use RFC 5424 format |

## Priority Levels
| Level | Description |
|-------|-------------|
| emerg | System unusable |
| alert | Immediate action needed |
| crit | Critical conditions |
| err | Error conditions |
| warning | Warning conditions |
| notice | Normal but significant |
| info | Informational |
| debug | Debug messages |

## Key Use Cases
1. System logging
2. Script logging
3. Debugging
4. Monitoring
5. Auditing

## Examples with Explanations
### Example 1: Basic Usage
```bash
logger "System backup completed"
```
Log simple message

### Example 2: With Priority
```bash
logger -p local0.info "Service started"
```
Log with facility and priority

### Example 3: With Tag
```bash
logger -t backup -p user.notice "Backup process complete"
```
Log with tag and priority

## Common Usage Patterns
1. Script logging:
   ```bash
   logger -t myscript "Process started"
   ```
2. File content:
   ```bash
   logger -f /var/log/errors
   ```
3. Remote logging:
   ```bash
   logger -n logserver.example.com -P 514 "Remote log"
   ```

## Security Considerations
1. Log permissions
2. Remote logging
3. Message content
4. Facility usage
5. Priority levels

## Related Commands
- `syslog` - System logger
- `rsyslog` - Enhanced syslog
- `journalctl` - Query logs
- `tail` - View log files
- `grep` - Search logs

## Additional Resources
- [Logger Manual](https://man7.org/linux/man-pages/man1/logger.1.html)
- [Syslog Guide](https://www.rsyslog.com/doc/master/index.html)
- [Logging Best Practices](https://www.cyberciti.biz/tips/howto-linux-unix-log-management.html)

## Best Practices
1. Use appropriate priorities
2. Include context
3. Structured messages
4. Regular monitoring
5. Log rotation

## Message Format
1. Timestamp
2. Hostname
3. Process name
4. Process ID
5. Message text

## Troubleshooting
1. Log delivery
2. Priority levels
3. Remote logging
4. Permission issues
5. Storage space
