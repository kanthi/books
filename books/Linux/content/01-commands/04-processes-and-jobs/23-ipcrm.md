# ipcrm

## Overview

`ipcrm` removes **System V IPC** objects: shared memory segments, semaphore arrays, and message queues. Use after confirming with `ipcs` that objects are orphaned — never delete resources still owned by live production processes.

## Syntax

```bash
ipcrm [options]
ipcrm -m id | -M key
ipcrm -q id | -Q key
ipcrm -s id | -S key
```

## Common Options

| Option | Description |
|--------|-------------|
| `-m shmid` | Remove shared memory by **ID** |
| `-M key` | Remove shared memory by **key** |
| `-q msqid` | Remove message queue by ID |
| `-Q key` | Remove message queue by key |
| `-s semid` | Remove semaphore by ID |
| `-S key` | Remove semaphore by key |
| `-a` | Remove all (dangerous; some versions / with filters) |
| `-v` | Verbose |

Exact `-a` behavior varies — read `man ipcrm` before bulk deletes.

## Examples with Explanations

### Inspect then remove one segment

```bash
ipcs -m
sudo ipcrm -m 98305
ipcs -m
```

### Remove by key

```bash
ipcs -m
# note the key column (hex)
sudo ipcrm -M 0x00000000
```

### Message queues / semaphores

```bash
ipcs -q
sudo ipcrm -q 12
ipcs -s
sudo ipcrm -s 34
```

### Scripted cleanup of your own leftovers

```bash
# example: remove shared memory owned by current user carefully
id -u
ipcs -m -c
# manually select ids, then:
# ipcrm -m ID
```

Automating bulk `ipcrm` without filters is risky on multi-app hosts.

### After crash lab example

```bash
# app crashed without IPC_RMID
ipcs -m -p
# verify no live PID uses it
ps -p <cpid>,<lpid>
sudo ipcrm -m <shmid>
```

## Notes / Pitfalls

- Wrong ID → impact on another application (databases!).
- Need permission; root can remove almost anything.
- Race with process still attaching — prefer graceful app shutdown.
- Keys of `0x00000000` may mean `IPC_PRIVATE` — identify carefully.
- Does not remove POSIX shm files in `/dev/shm` — use `rm` there if appropriate.

## 2026-relevant notes

- Prefer designs that set `IPC_RMID` or use POSIX shm with clear lifecycle.
- In containers, IPC namespace teardown often cleans objects automatically on exit.
- Document any required SysV objects for legacy apps so ops doesn’t “clean” them.

## Related Commands

- `ipcs` — list IPC
- `sysctl` — kernel limits
- `ls /dev/shm` — POSIX shm
- `rm` — remove POSIX shm files
- `ipcmk` — create IPC (rarely needed manually)

## Additional Resources

- `man ipcrm`
