# killall

## Overview
The `killall` command kills processes by name. It sends a signal to all processes running any of the specified commands.

## Syntax
```bash
killall [options] name...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-e` | Require exact match |
| `-I` | Case insensitive |
| `-i` | Interactive |
| `-l` | List signals |
| `-q` | Quiet mode |
| `-r` | Use regex |
| `-s signal` | Send signal |
| `-u user` | Kill user's processes |
| `-v` | Verbose mode |
| `-w` | Wait for processes to die |
| `-y` | Younger than time |
| `-o` | Older than time |

## Key Use Cases
1. Process cleanup
2. Application restart
3. User process termination
4. System maintenance
5. Batch process control

## Examples with Explanations
### Example 1: Basic Usage
```bash
killall firefox
```
Kill all Firefox processes

### Example 2: Specific Signal
```bash
killall -9 httpd
```
Force kill all Apache processes

### Example 3: Interactive Mode
```bash
killall -i process_name
```
Prompt before killing each process

## Understanding Output
- No output on success
- With -v:
  - Killed process information
- Error messages for:
  - No process found
  - Permission denied
  - Invalid signal
  - Pattern errors

## Common Usage Patterns
1. Kill by age:
   ```bash
   killall -o 15m process_name
   ```
2. Kill user processes:
   ```bash
   killall -u username process_name
   ```
3. Wait for completion:
   ```bash
   killall -w process_name
   ```

## Performance Analysis
- Process name lookup
- Pattern matching overhead
- Signal delivery time
- Multiple process handling
- System resource impact

## Related Commands
- `kill` - Kill by PID
- `pkill` - Kill by pattern
- `pgrep` - List processes
- `pidof` - Find process ID
- `ps` - Process status

## Additional Resources
- [Killall Manual](https://man7.org/linux/man-pages/man1/killall.1.html)
- [Process Management Guide](https://www.tecmint.com/how-to-kill-processes-in-linux/)
- [Signal Handling](https://www.gnu.org/software/libc/manual/html_node/Signal-Handling.html)

## Best Practices
1. Use exact matching
2. Verify process names
3. Interactive mode for safety
4. Check user permissions
5. Document actions

## Safety Considerations
1. Avoid system processes
2. Use interactive mode
3. Verify process names
4. Check dependencies
5. Backup important data
