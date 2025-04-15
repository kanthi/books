# jobs

## Overview
The `jobs` command displays the status of jobs in the current shell. It lists the jobs that are running in the background or stopped.

## Syntax
```bash
jobs [options] [jobspec...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List PIDs |
| `-p` | List PIDs only |
| `-n` | New jobs |
| `-r` | Running jobs |
| `-s` | Stopped jobs |
| `-x command` | Execute command |

## Job States
| State | Description |
|-------|-------------|
| Running | Currently executing |
| Stopped | Suspended |
| Done | Completed |
| Terminated | Killed |
| Suspended | Paused |

## Key Use Cases
1. Job monitoring
2. Process control
3. Background tasks
4. Shell management
5. Task scheduling

## Examples with Explanations
### Example 1: List Jobs
```bash
jobs
```
Show all jobs

### Example 2: Show PIDs
```bash
jobs -l
```
List with process IDs

### Example 3: Running Jobs
```bash
jobs -r
```
Show running jobs

## Common Usage Patterns
1. Check status:
   ```bash
   jobs -l
   ```
2. Background job:
   ```bash
   command & jobs
   ```
3. Stopped jobs:
   ```bash
   jobs -s
   ```

## Job Control
1. Background (&)
2. Foreground (fg)
3. Stop (Ctrl-Z)
4. Continue (bg)
5. Kill (kill)

## Related Commands
- `fg` - Foreground
- `bg` - Background
- `kill` - Send signal
- `ps` - Process status
- `disown` - Job control

## Additional Resources
- [Jobs Manual](https://man7.org/linux/man-pages/man1/jobs.1p.html)
- [Shell Guide](https://www.cyberciti.biz/faq/linux-jobs-command-examples-usage-syntax/)
- [System Administration](https://www.tecmint.com/linux-jobs-command-examples/)

## Best Practices
1. Monitor jobs
2. Use job numbers
3. Check status
4. Clean up jobs
5. Document tasks

## Security Considerations
1. Job ownership
2. Process control
3. Resource usage
4. Shell access
5. User permissions

## Troubleshooting
1. Hung jobs
2. Zombie processes
3. Status errors
4. Shell issues
5. Resource limits

## Job Notation
1. %n (job number)
2. %string (prefix)
3. %?string (contains)
4. %+ (current)
5. %- (previous)
