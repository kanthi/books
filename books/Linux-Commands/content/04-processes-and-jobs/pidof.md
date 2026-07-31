# pidof

## Overview
The `pidof` command finds process IDs (PIDs) of running programs. It displays the process IDs of named programs.

## Syntax
```bash
pidof [options] program [program...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-s` | Single shot - return one PID |
| `-x` | Scripts too - return script PIDs |
| `-o omitpid` | Omit given PID |
| `-c` | Only return PIDs in chroot |
| `-n` | Newest process only |
| `-o` | Oldest process only |
| `-z` | Skip zombies |
| `-w` | Show PIDs with same name |

## Key Use Cases
1. Process identification
2. Script automation
3. Process monitoring
4. Service management
5. System administration

## Examples with Explanations
### Example 1: Basic Usage
```bash
pidof nginx
```
Find all nginx process IDs

### Example 2: Single Process
```bash
pidof -s firefox
```
Find one firefox process ID

### Example 3: Omit PID
```bash
pidof -o 1234 process_name
```
Find PIDs except 1234

## Understanding Output
- Space-separated list of PIDs
- No output if process not found
- Error messages for:
  - Invalid options
  - Permission issues
  - Process not found

## Common Usage Patterns
1. Kill process:
   ```bash
   kill $(pidof program)
   ```
2. Check if running:
   ```bash
   if pidof program >/dev/null; then echo "Running"; fi
   ```
3. Monitor newest:
   ```bash
   pidof -n program
   ```

## Performance Analysis
- Fast execution
- Minimal system impact
- Process table lookup
- Name matching
- Multiple process handling

## Related Commands
- `pgrep` - Find processes
- `ps` - Process status
- `kill` - Send signals
- `killall` - Kill by name
- `pkill` - Kill by pattern

## Additional Resources
- [Pidof Manual](https://man7.org/linux/man-pages/man1/pidof.1.html)
- [Process Management Guide](https://www.tecmint.com/linux-process-management/)
- [System Administration](https://tldp.org/LDP/sag/html/index.html)

## Best Practices
1. Verify process names
2. Handle multiple PIDs
3. Error checking
4. Script safety
5. Regular monitoring

## Use Cases
1. Service scripts
2. Process control
3. System monitoring
4. Automation tasks
5. Dependency checking
