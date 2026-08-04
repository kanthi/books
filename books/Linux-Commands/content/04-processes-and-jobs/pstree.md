# pstree

## Overview

`pstree` shows running processes as a **tree**, making parent/child relationships obvious — ideal for seeing what a supervisor spawned, which shell owns a pipeline, or how threads hang under a process.

## Syntax

```bash
pstree [options] [pid|user]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Show command-line args |
| `-p` | Show PIDs |
| `-c` | Don’t compact identical subtrees |
| `-h` / `-H pid` | Highlight current / specified |
| `-n` | Sort by PID |
| `-u` | Show uid transitions |
| `-g` | Show PGID |
| `-s` | Show parents of specified PID |
| `-l` | Long lines (no truncation) |
| `-T` | Hide threads |
| `-A` / `-U` | ASCII / UTF-8 lines |
| `-Z` | SELinux context |
| `-t` | Show full thread names when available |

## Examples with Explanations

### Basics

```bash
pstree
pstree -p
pstree -ap
```

### One user or PID

```bash
pstree alice
pstree -p 1
pstree -ap $(pidof -s nginx)
```

### Show ancestry of a process

```bash
pstree -s -p 12345
ps -o pid,ppid,cmd -p 12345
```

### Avoid compaction

```bash
pstree -c -p
```

Identical child names are otherwise merged with counts.

### Threads vs processes

```bash
pstree -p 12345
pstree -T -p 12345
```

### SELinux

```bash
pstree -Z
```

### Compare with ps

```bash
ps auxf
pstree -ap
systemd-cgls
```

`ps f` / `ps --forest` is another forest view; `systemd-cgls` shows cgroup trees.

## Notes / Pitfalls

- Large trees on busy hosts are noisy — filter by user/PID.
- Compact mode can hide multiplicity — use `-c` when counting workers.
- Permission: some args may be invisible for other users’ processes.
- PID namespaces in containers show a nested world (PID 1 is container init).
- Not a real-time monitor — re-run or use `watch -n1 pstree -p`.

## 2026-relevant notes

- systemd-heavy systems: also learn `systemctl status` and `systemd-cgtop`.
- For containers: `podman top` / `docker top` + host `pstree -p` with care.
- Kernel threads appear under `kthreadd` (PID 2) on the host.

## Related Commands

- `ps auxf` — forest view
- `pgrep` / `pidof` — find PIDs
- `systemd-cgls` — cgroup tree
- `top` / `htop` — live views with tree modes
- `pstree` package often from `psmisc`

## Additional Resources

- `man pstree`
