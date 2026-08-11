# ulimit

## Overview

`ulimit` is a **shell builtin** (bash/zsh/etc.) that shows or sets **resource limits** for the current shell and its child processes: open files, processes, stack size, core dumps, and more. It does not permanently reconfigure the whole system—use `/etc/security/limits.conf`, systemd unit directives, or cgroups for persistence and service-wide policy.

## Syntax

```bash
ulimit [-SHacdefilmnpqrstuvx] [limit]
```

## Common Options

| Option | Resource |
|--------|----------|
| `-a` | Show all limits |
| `-n` | Max open file descriptors |
| `-u` | Max user processes |
| `-v` | Address space (KB) where supported |
| `-f` | Max file size (blocks) |
| `-c` | Core file size |
| `-s` | Stack size |
| `-l` | Locked memory |
| `-m` | Resident set (often ignored on Linux) |
| `-t` | CPU seconds |
| `-H` | Hard limit |
| `-S` | Soft limit |

Soft limits can be raised up to the hard limit by the user; hard limits need root (or were set that way at login).

## Key Use Cases

1. Raise `nofile` for databases, proxies, load generators
2. Allow core dumps (`-c unlimited`) while debugging
3. Diagnose “Too many open files” / “cannot fork”
4. Compare shell limits vs systemd service limits

## Examples with Explanations

### Show limits

```bash
ulimit -a
ulimit -n
ulimit -u
ulimit -H -n
ulimit -S -n
```

### Raise open files (session)

```bash
ulimit -n 65536
ulimit -n
```

Fails if hard limit is lower—check `ulimit -H -n` and raise via limits.d or systemd.

### Cores and stack

```bash
ulimit -c unlimited
ulimit -s 8192
```

### One-liner recipes

```bash
# Reproduce app under higher nofile
ulimit -n 100000 && ./my-server

# Show soft/hard nofile pair
printf 'soft=%s hard=%s\n' "$(ulimit -Sn)" "$(ulimit -Hn)"

# Compare with PID 1 or a service (systemd)
systemctl show nginx -p LimitNOFILE --value
cat /proc/$(pgrep -n nginx)/limits
```

### Persistent configuration (context)

```bash
# /etc/security/limits.d/99-nofile.conf  (pam_limits — login sessions)
# myuser soft nofile 65536
# myuser hard nofile 1048576

# systemd service drop-in
# [Service]
# LimitNOFILE=65536
```

`ulimit` alone in `~/.bashrc` does **not** affect systemd services.

## Notes & Pitfalls

- **Builtin**: not `/usr/bin/ulimit`; dash/busybox shells differ.
- **Non-interactive SSH** may skip bashrc—put service limits in systemd/unit files.
- Containers inherit cgroup and docker `--ulimit` settings; shell ulimit cannot exceed them.
- `unlimited` is not always valid for every resource.
- Changing `-n` in one terminal doesn’t affect already-running daemons.

## 2026-relevant notes

- Prefer **systemd** `LimitNOFILE=`, `TasksMax=`, and cgroup v2 pressure metrics over only pam limits on pure server images.
- Kubernetes sets pod resource limits separately; `ulimit` inside a pod is still constrained by the container runtime.
- Kernel `fs.file-max` and per-user limits both matter for “too many open files”.

## Related Commands

- `prlimit` — get/set limits of a running PID
- `systemctl show` — unit Limit* properties
- `cat /proc/PID/limits` — effective process limits
- `sysctl fs.file-max` — system-wide file ceiling

## Additional Resources

- `help ulimit` (bash)
- `man limits.conf`, `man systemd.exec`
