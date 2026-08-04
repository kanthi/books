# sysctl

## Overview

`sysctl` reads and writes **kernel parameters** exposed under `/proc/sys/`. Changes with `-w` apply immediately to the running kernel; persistence requires files under `/etc/sysctl.conf` or `/etc/sysctl.d/*.conf`.

## Syntax

```bash
sysctl [options] [variable[=value] ...]
sysctl -p [file]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Dump all |
| `-w var=val` | Write (some builds allow `var=val` alone) |
| `-p [file]` | Load from file (default `/etc/sysctl.conf`) |
| `-e` | Ignore unknown keys |
| `-n` | Values only |
| `-N` | Names only |
| `-r` pattern | Filter names by regex |

## Key Use Cases

1. Enable IP forwarding for routers/Kubernetes nodes
2. Tune vm.swappiness, inotify limits, file-max
3. Apply security-related knobs (rp_filter, kptr_restrict)
4. Inspect live vs on-disk config drift

## Examples with Explanations

### Read

```bash
sysctl net.ipv4.ip_forward
sysctl -a | rg 'ip_forward|swappiness|file-max'
sysctl -n vm.swappiness
```

### Write (runtime)

```bash
sudo sysctl -w net.ipv4.ip_forward=1
sudo sysctl -w vm.swappiness=10
sudo sysctl -w fs.inotify.max_user_watches=524288
```

### Persist

```bash
# /etc/sysctl.d/99-local.conf
# net.ipv4.ip_forward = 1
# vm.swappiness = 10
sudo sysctl --system
# or
sudo sysctl -p /etc/sysctl.d/99-local.conf
```

### One-liner recipes

```bash
# Forwarding check on a potential router
sysctl net.ipv4.ip_forward net.ipv6.conf.all.forwarding

# Common developer inotify fix
sudo sysctl -w fs.inotify.max_user_watches=524288

# Show non-default-ish network stack subset
sysctl net.core.somaxconn net.ipv4.tcp_tw_reuse 2>/dev/null
```

## Notes & Pitfalls

- Typos with `-w` can break networking—prefer dry-run knowledge and staged files.
- Some keys are **read-only** or namespaced in containers (harder/impossible to change).
- Distribution defaults live in multiple `sysctl.d` snippets—use `sysctl --system` order carefully.
- Don’t copy random “performance” sysctl pastebins without understanding.

## 2026-relevant notes

- Kubernetes/kube-proxy and CNI docs still require specific sysctls; prefer documented allowlists.
- Prefer **systemd-sysctl** (`sysctl --system`) over editing only `/etc/sysctl.conf`.
- Cgroup v2 and container runtimes own many resource controls that old sysctl guides mis-attribute.

## Related Commands

- `cat /proc/sys/...` — direct access
- `systemctl` — services may set knobs
- `sysctl --system` — apply all conf
- `prlimit` / `ulimit` — process limits (different layer)

## Additional Resources

- `man sysctl`, `man sysctl.d`
- Kernel `Documentation/admin-guide/sysctl/`
