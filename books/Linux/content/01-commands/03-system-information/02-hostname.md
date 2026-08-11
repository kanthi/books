# hostname

## Overview

`hostname` prints or sets the system hostname. On modern systemd systems, prefer **`hostnamectl`** for persistent hostname changes and clearer status. The classic `hostname` command remains useful for quick reads and scripts.

Related names: static hostname, pretty hostname, transient hostname (DHCP/cloud).

## Syntax

```bash
hostname [options] [name]
```

## Common Options

| Option | Description |
|--------|-------------|
| *(none)* | Print hostname |
| `name` | Set hostname (needs root; often transient without systemd integration) |
| `-f`, `--fqdn` | Fully qualified domain name (best effort) |
| `-s`, `--short` | Short name (before first dot) |
| `-i`, `--ip-address` | Addresses for host (unreliable; prefer `ip`) |
| `-I` | All IP addresses on interfaces (not DNS) |
| `-d` | DNS domain name (best effort) |
| `-A` | All FQDNs |
| `-y` | NIS domain |
| `--help` | Help |

Behavior of DNS-related flags depends on resolver configuration and `/etc/hosts`.

## Examples with Explanations

### Read

```bash
hostname
hostname -s
hostname -f
hostname -I
```

### Prefer hostnamectl on systemd

```bash
hostnamectl
hostnamectl status
sudo hostnamectl set-hostname app-01
```

This updates the persistent hostname properly on systemd hosts.

### Temporary classic set (legacy)

```bash
sudo hostname app-temp
# may not survive reboot without writing config / hostnamectl
```

### Scripts

```bash
h=$(hostname -s)
echo "running on $h"
```

### Correlate with DNS / addresses

```bash
hostname -f
getent hosts "$(hostname -f)"
ip -br addr
```

`-i`/`-f` can lie if `/etc/hosts` and DNS disagree — verify with `ip` and `resolvectl`.

## Notes / Pitfalls

- Setting via bare `hostname` without `hostnamectl`/config is a common “lost after reboot” mistake.
- Cloud images may regenerate hostnames via cloud-init.
- FQDN detection is best-effort, not a pure DNS authoritative query.
- Containers have their own hostname (pod name, docker `--hostname`).
- Valid hostname rules: prefer short DNS labels (`a-z`, `0-9`, `-`).

## 2026-relevant notes

- systemd hosts: **`hostnamectl`** is the supported admin interface.
- Kubernetes sets pod hostnames independently of node hostname.
- Inventory tools (Ansible) often use inventory names that differ from `hostname` — don’t assume equality.

## Related Commands

- `hostnamectl` — systemd hostname management
- `resolvectl` / `getent hosts` — name resolution
- `ip` — addresses
- `uname -n` — nodename (usually same as hostname)
- `nmcli` — NetworkManager host/domain bits

## Additional Resources

- `man hostname`, `man hostnamectl`
