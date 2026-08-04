# ipcs

## Overview

`ipcs` lists **System V IPC** objects: message queues, shared memory segments, and semaphore arrays. Useful when debugging legacy applications, databases, or middleware that use SysV IPC, and when cleaning up leftover segments after crashes.

POSIX shared memory and mutexes use different interfaces (`/dev/shm`, pthreads) — not shown by `ipcs`.

## Syntax

```bash
ipcs [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | All resources (default summary style) |
| `-q` | Message queues |
| `-m` | Shared memory |
| `-s` | Semaphores |
| `-t` | Time info |
| `-p` | PIDs (creator/last operator) |
| `-c` | Creator user/group |
| `-l` | Resource limits |
| `-u` | Summary usage |
| `-i id` | Details for specific ID |
| `-b` | Brief bytes columns where applicable |

## Examples with Explanations

### Overview

```bash
ipcs
ipcs -a
ipcs -m
ipcs -q
ipcs -s
```

### Limits and usage

```bash
ipcs -l
ipcs -u
```

### Creator and PIDs

```bash
ipcs -m -p
ipcs -m -c
ipcs -i 123456 -m
```

### Find leftovers by user

```bash
ipcs -m | awk 'NR>3 && $3=="alice" {print}'
```

### Cleanup companion

```bash
ipcs -m
sudo ipcrm -m <shmid>
# or by key:
sudo ipcrm -M 0x00001234
```

See `ipcrm` page for deletion safety.

### Kernel params (context)

```bash
sysctl kernel.shmmax kernel.shmall kernel.shmmni
sysctl kernel.msgmax kernel.msgmni
sysctl kernel.sem
```

## Notes / Pitfalls

- Deleting live shared memory of a running DB will wreck it — identify owners first.
- IDs vs keys: `ipcrm` flags differ (`-m` id vs `-M` key).
- Docker/IPC namespaces hide or isolate objects — empty `ipcs` may be namespace-related.
- Modern apps often prefer POSIX shm (`/dev/shm`) and won’t appear here.
- Permissions: you may only see objects you can access.

## 2026-relevant notes

- Still relevant for Oracle, older SAP, and legacy C apps; less so for greenfield Go/Node services.
- Prefer container IPC isolation over host-global SysV segments when designing new systems.
- Monitor with app-native tools first; use `ipcs` for orphan cleanup after hard crashes.

## Related Commands

- `ipcrm` — remove IPC objects
- `ls -l /dev/shm` — POSIX shared memory files
- `sysctl` — kernel IPC limits
- `fuser` / `lsof` — who uses files (not always SysV)
- `pmap` — process memory maps

## Additional Resources

- `man ipcs`, `man ipc`
