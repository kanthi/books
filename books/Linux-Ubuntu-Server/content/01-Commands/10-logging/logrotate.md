# logrotate

## Overview
The `logrotate` command manages log files by rotating, compressing, and mailing them. It helps prevent log files from consuming too much disk space.

## Syntax
```bash
logrotate [options] config_file
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Debug mode |
| `-f` | Force rotation |
| `-m command` | Mail command |
| `-s statefile` | Use alternate state file |
| `-v` | Verbose mode |
| `--usage` | Display brief usage |
| `-g group` | Override group |
| `-u user` | Override user |

## Configuration Directives
| Directive | Description |
|-----------|-------------|
| `rotate N` | Keep N old logs |
| `size size` | Rotate if bigger |
| `create mode owner group` | File creation attributes |
| `compress` | Compress old versions |
| `delaycompress` | Postpone compression |
| `notifempty` | Don't rotate empty files |
| `missingok` | Skip missing files |
| `copytruncate` | Copy and truncate |
| `dateext` | Date extension |
| `mail address` | Mail old versions |

## Key Use Cases
1. Log management
2. Disk space control
3. Archive maintenance
4. Compliance requirements
5. System maintenance

## Examples with Explanations
### Example 1: Basic Configuration
```
/var/log/messages {
    rotate 7
    daily
    compress
    delaycompress
    missingok
    notifempty
}
```

### Example 2: Size-based Rotation
```
/var/log/large.log {
    size 100M
    rotate 5
    compress
    create 0644 root root
}
```

### Example 3: Weekly Rotation
```
/var/log/weekly.log {
    weekly
    rotate 4
    create 0640 www-data www-data
    compress
}
```

## Common Usage Patterns
1. Force rotation:
   ```bash
   logrotate -f /etc/logrotate.conf
   ```
2. Debug config:
   ```bash
   logrotate -d /etc/logrotate.conf
   ```
3. Verbose mode:
   ```bash
   logrotate -v /etc/logrotate.conf
   ```

## Security Considerations
1. File permissions
2. Compression safety
3. Mail configuration
4. Access control
5. Script execution

## Related Commands
- `logger` - Make log entries
- `syslog` - System logger
- `journalctl` - Query logs
- `gzip` - Compression
- `mail` - Send mail

## Additional Resources
- [Logrotate Manual](https://linux.die.net/man/8/logrotate)
- [Log Management Guide](https://www.digitalocean.com/community/tutorials/how-to-manage-logfiles-with-logrotate-on-ubuntu-16-04)
- [System Administration](https://www.tecmint.com/install-logrotate-to-manage-log-rotation-in-linux/)

## Best Practices
1. Regular testing
2. Size monitoring
3. Compression planning
4. Retention policy
5. Error handling

## Configuration Examples
1. Daily rotation
2. Size-based rotation
3. Custom scripts
4. Mail notification
5. Compression options

## Troubleshooting
1. Rotation timing
2. Permission issues
3. Space problems
4. Script errors
5. Mail delivery
