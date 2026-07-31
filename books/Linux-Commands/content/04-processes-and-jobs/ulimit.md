# ulimit

## Overview
`ulimit` is a shell builtin used to get and set resource limits for the current shell and processes started by it (e.g. max open files, stack size, max user processes).

## Syntax
```bash
ulimit [options] [limit]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Display all current resource limits |
| `-n` | Maximum number of open file descriptors |
| `-u` | Maximum number of processes available to single user |
| `-v` | Maximum amount of virtual memory available |
| `-H` | Set/show hard limit (cannot be raised by non-root) |
| `-S` | Set/show soft limit (can be raised up to hard limit) |

## Key Use Cases
1. Increasing max open file limits (`ulimit -n`) for high-concurrency servers.
2. Checking process allocation boundaries for application user accounts.

## Examples with Explanations
### Example 1: Show All Current Limits
```bash
ulimit -a
```
Outputs soft and hard resource boundaries for the active shell environment.

### Example 2: Increase Open File Descriptor Limit
```bash
ulimit -n 65536
```
Sets the soft limit for open files to 65,536.

## Related Commands
- `sysctl` - Configure kernel parameters at runtime
- `systemctl` - Systemd service resource control
