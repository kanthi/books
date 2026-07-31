# ipcrm

## Overview
`ipcrm` removes System V Inter-Process Communication (IPC) objects (shared memory segments, message queues, or semaphore arrays) from the Linux kernel.

## Syntax
```bash
ipcrm [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-m`, `--shm-id ID` | Remove shared memory segment identified by ID |
| `-M`, `--shm-key KEY` | Remove shared memory segment identified by KEY |
| `-s`, `--sem-id ID` | Remove semaphore array identified by ID |
| `-S`, `--sem-key KEY` | Remove semaphore array identified by KEY |
| `-q`, `--queue-id ID` | Remove message queue identified by ID |
| `-Q`, `--queue-key KEY` | Remove message queue identified by KEY |

## Key Use Cases
1. Reclaiming leaked shared memory segments after process crashes.
2. Clearing orphaned semaphore locks in multi-threaded application environments.

## Examples with Explanations
### Example 1: Remove Shared Memory Segment by ID
```bash
ipcrm -m 32768
```
Deallocates and removes the shared memory segment associated with ID `32768`.

## Related Commands
- `ipcs` - View active System V IPC resources
