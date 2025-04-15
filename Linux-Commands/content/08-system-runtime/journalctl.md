# journalctl

## Overview
The `journalctl` command queries the systemd journal. It's used to view and analyze system logs collected by the systemd journal.

## Syntax
```bash
journalctl [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f` | Follow new entries |
| `-n N` | Show last N entries |
| `-r` | Show in reverse order |
| `-u UNIT` | Show unit logs |
| `-b` | Show current boot |
| `-k` | Show kernel messages |
| `-p PRIORITY` | Filter by priority |
| `--since` | Show since time |
| `--until` | Show until time |
| `--no-pager` | No pager output |
| `-x` | Add explanations |
| `-o FORMAT` | Output format |

## Key Use Cases
1. System troubleshooting
2. Service monitoring
3. Security auditing
4. Boot analysis
5. Error investigation

## Examples with Explanations
### Example 1: Recent Logs
```bash
journalctl -n 50
```
Show last 50 entries

### Example 2: Service Logs
```bash
journalctl -u nginx
```
Show nginx service logs

### Example 3: Boot Logs
```bash
journalctl -b
```
Show current boot logs

## Understanding Output
Priority levels:
0. Emergency
1. Alert
2. Critical
3. Error
4. Warning
5. Notice
6. Info
7. Debug

## Common Usage Patterns
1. Follow logs:
   ```bash
   journalctl -f
   ```
2. Time range:
   ```bash
   journalctl --since "1 hour ago"
   ```
3. Error messages:
   ```bash
   journalctl -p err
   ```

## Performance Analysis
- Log size
- Storage usage
- Query performance
- Rotation policy
- Compression ratio

## Related Commands
- `systemctl` - System control
- `logger` - Add log entries
- `dmesg` - Kernel messages
- `tail` - View file end
- `grep` - Search text

## Additional Resources
- [Journalctl Manual](https://man7.org/linux/man-pages/man1/journalctl.1.html)
- [Systemd Journal](https://www.freedesktop.org/software/systemd/man/journald.conf.html)
- [Log Management](https://www.digitalocean.com/community/tutorials/how-to-use-journalctl-to-view-and-manipulate-systemd-logs)

## Best Practices
1. Regular monitoring
2. Storage management
3. Priority filtering
4. Backup important logs
5. Security review

## Troubleshooting
1. Error analysis
2. Boot problems
3. Service failures
4. System crashes
5. Security incidents

## Output Formats
1. short
2. short-iso
3. short-precise
4. short-monotonic
5. verbose
