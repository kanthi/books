# fg

## Overview
The `fg` command resumes jobs in the foreground. It brings a background or stopped job into the foreground, making it the current job.

## Syntax
```bash
fg [jobspec]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Show help |
| `-v` | Show version |

## Job Specification
| Spec | Description |
|------|-------------|
| %n | Job number n |
| %str | Job starting with str |
| %?str | Job containing str |
| %+ | Current job |
| %- | Previous job |
| %% | Current job |

## Key Use Cases
1. Resume jobs
2. Job control
3. Process management
4. Interactive tasks
5. Shell control

## Examples with Explanations
### Example 1: Current Job
```bash
fg
```
Resume current job

### Example 2: Specific Job
```bash
fg %2
```
Resume job number 2

### Example 3: Named Job
```bash
fg %?name
```
Resume job containing 'name'

## Common Usage Patterns
1. Background to fore:
   ```bash
   fg %1
   ```
2. Check then resume:
   ```bash
   jobs; fg %2
   ```
3. Stop then resume:
   ```bash
   Ctrl-Z; fg
   ```

## Job Control
1. Background (bg)
2. Foreground (fg)
3. Stop (Ctrl-Z)
4. List (jobs)
5. Kill (kill)

## Related Commands
- `bg` - Background
- `jobs` - List jobs
- `kill` - Send signal
- `disown` - Job control
- `nohup` - No hangup

## Additional Resources
- [Fg Manual](https://man7.org/linux/man-pages/man1/fg.1p.html)
- [Shell Guide](https://www.cyberciti.biz/faq/linux-fg-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-fg-command-examples/)

## Best Practices
1. Check job status
2. Use job numbers
3. Monitor output
4. Clean up jobs
5. Document usage

## Security Considerations
1. Job ownership
2. Process control
3. Terminal access
4. User permissions
5. Resource usage

## Troubleshooting
1. Job status
2. Process state
3. Terminal issues
4. Shell problems
5. Signal handling

## Common Scenarios
1. Interactive tasks
2. Editing sessions
3. Program control
4. Debug sessions
5. Shell operations
