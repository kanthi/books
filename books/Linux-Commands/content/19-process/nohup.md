# nohup

## Overview
The `nohup` command runs a command immune to hangups, with output to a non-tty. It allows processes to continue running after the terminal is closed or the user logs out.

## Syntax
```bash
nohup command [arguments]
```

## Common Options
| Option | Description |
|--------|-------------|
| `--help` | Show help |
| `--version` | Show version |
| `-p` | Print PID |
| `-u` | Unbuffered output |

## Output Handling
| File | Description |
|------|-------------|
| nohup.out | Default output |
| ~/nohup.out | Home directory |
| ./nohup.out | Current directory |
| /dev/null | Discard output |

## Key Use Cases
1. Background jobs
2. Long-running tasks
3. Remote execution
4. Batch processing
5. System maintenance

## Examples with Explanations
### Example 1: Basic Usage
```bash
nohup command &
```
Run in background

### Example 2: Custom Output
```bash
nohup command > output.log 2>&1 &
```
Redirect output

### Example 3: Discard Output
```bash
nohup command >/dev/null 2>&1 &
```
No output file

## Common Usage Patterns
1. Long process:
   ```bash
   nohup ./script.sh &
   ```
2. With logging:
   ```bash
   nohup command > log.txt &
   ```
3. Background job:
   ```bash
   nohup command & echo $!
   ```

## Process Management
1. Background running
2. Signal handling
3. Output redirection
4. Process isolation
5. Job control

## Related Commands
- `disown` - Job control
- `screen` - Terminal manager
- `tmux` - Terminal multiplexer
- `bg` - Background jobs
- `jobs` - Show jobs

## Additional Resources
- [Nohup Manual](https://man7.org/linux/man-pages/man1/nohup.1.html)
- [Usage Guide](https://www.cyberciti.biz/faq/linux-nohup-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-nohup-command-examples/)

## Best Practices
1. Redirect output
2. Check process
3. Use job control
4. Monitor resources
5. Clean up files

## Security Considerations
1. Process ownership
2. File permissions
3. Output handling
4. Resource limits
5. System access

## Troubleshooting
1. Process status
2. Output files
3. Permission issues
4. Signal handling
5. Resource usage

## Common Issues
1. Output location
2. Process termination
3. Signal handling
4. File permissions
5. Resource limits
