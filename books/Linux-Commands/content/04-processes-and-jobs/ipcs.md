# ipcs

## Overview
`ipcs` provides information on System V Inter-Process Communication (IPC) facilities: shared memory segments, message queues, and semaphore arrays.

## Syntax
```bash
ipcs [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a`, `--all` | Show all IPC facilities (default) |
| `-m`, `--shmems` | Display shared memory segments |
| `-q`, `--queues` | Display message queues |
| `-s`, `--semaphores` | Display semaphore arrays |
| `-p`, `--pid` | Display process IDs of IPC creators and last operators |
| `-t`, `--time` | Display access/change timestamps |

## Key Use Cases
1. Auditing active System V shared memory segments and semaphores.
2. Identifying orphaned shared memory allocations.
3. Troubleshooting database or multi-process IPC resource leaks.

## Examples with Explanations
### Example 1: View Shared Memory Segments
```bash
ipcs -m
```
Lists active shared memory segment IDs, keys, owners, permissions, and byte sizes.

## Related Commands
- `ipcrm` - Remove System V IPC resources
- `ls` - List files
