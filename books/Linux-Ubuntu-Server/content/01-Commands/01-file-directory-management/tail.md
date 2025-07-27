# tail

## Overview
The `tail` command outputs the last part of files. It's particularly useful for monitoring log files and viewing recent changes.

## Syntax
```bash
tail [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n num` | Output last num lines |
| `-f` | Follow file growth |
| `-F` | Follow and retry if file inaccessible |
| `-c num` | Output last num bytes |
| `-q` | Never output headers |
| `-v` | Always output headers |
| `--pid=PID` | With -f, terminate after PID dies |
| `--retry` | Keep trying to open file |
| `--max-unchanged-stats=N` | Reopen file after N iterations |

## Key Use Cases
1. Monitor log files
2. View recent changes
3. Follow file updates
4. Debug applications
5. System monitoring

## Examples with Explanations
### Example 1: View End
```bash
tail file.log
```
Show last 10 lines

### Example 2: Follow Updates
```bash
tail -f log.txt
```
Monitor file for new content

### Example 3: Multiple Files
```bash
tail -n 5 file1 file2
```
Show last 5 lines of each file

## Understanding Output
- Default: 10 lines
- With -f:
  - Real-time updates
- With multiple files:
  - ==> filename <== headers
- Error messages for:
  - File not found
  - Permission denied
  - File rotation

## Common Usage Patterns
1. Monitor logs:
   ```bash
   tail -f /var/log/syslog
   ```
2. View recent changes:
   ```bash
   tail -n 50 file
   ```
3. Follow multiple files:
   ```bash
   tail -f file1 file2
   ```

## Performance Analysis
- Efficient file following
- Memory usage control
- Inode monitoring
- File rotation handling
- Multiple file impact

## Related Commands
- `head` - Show file beginning
- `less` - File pager
- `watch` - Execute periodically
- `grep` - Pattern matching
- `logrotate` - Log management

## Additional Resources
- [GNU Coreutils - tail](https://www.gnu.org/software/coreutils/manual/html_node/tail-invocation.html)
- [Linux Log Management](https://www.tecmint.com/view-contents-of-file-in-linux/)
- [System Monitoring Guide](https://tldp.org/LDP/abs/html/system.html)

## Best Practices
1. Use -F for log monitoring
2. Consider log rotation
3. Set appropriate buffer size
4. Use with grep for filtering
5. Monitor resource usage
