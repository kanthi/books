# hostnamectl

## Overview

`hostnamectl` queries and changes the system hostname and related machine identity fields on **systemd** systems. It is the preferred way to set a **persistent** hostname (vs classic `hostname` alone, which may only change the transient name until reboot).

## Syntax

```bash
hostnamectl [options] [command]
```

## Common Commands / Options

| Command / option | Description |
|------------------|-------------|
| `status` | Show current hostnames and OS info (default) |
| `set-hostname NAME` | Set hostname |
| `set-hostname NAME --static` | Static hostname |
| `set-hostname NAME --transient` | Transient only |
| `set-hostname NAME --pretty` | Pretty (presentation) name |
| `set-icon-name` / `set-chassis` / `set-deployment` / `set-location` | Machine metadata |
| `set-hostname "" --pretty` | Clear pretty name |
| `-H host` / `--machine=` | Operate on remote/container via systemd |
| `--no-ask-password` | Non-interactive privilege |

## Examples with Explanations

### Status

```bash
hostnamectl
hostnamectl status
```

Shows static/transient/pretty hostnames, machine ID icons, chassis, OS pretty name, kernel, architecture.

### Set hostname

```bash
sudo hostnamectl set-hostname app-01
hostnamectl
hostname
```

### Pretty name

```bash
sudo hostnamectl set-hostname "App Server 01" --pretty
sudo hostnamectl set-hostname app-01 --static
```

### Transient (temporary)

```bash
sudo hostnamectl set-hostname temp-probe --transient
```

### Chassis / location metadata

```bash
sudo hostnamectl set-chassis server
sudo hostnamectl set-location "rack-3-u12"
```

### Remote / container

```bash
hostnamectl -H alice@host.example
hostnamectl --machine=mycontainer
```

### Verify files

```bash
cat /etc/hostname
ls -l /etc/machine-id
hostname
```

## Notes / Pitfalls

- Requires systemd; classic SysV-only systems won’t have it.
- cloud-init may overwrite hostnames on next boot if configured to manage them.
- DNS is separate: setting hostname does not create DNS records.
- Valid hostname labels: prefer RFC-ish DNS labels for static names; pretty names can be freer.
- Containers may restrict hostname changes.

## 2026-relevant notes

- Standard admin path on almost all mainstream server distros.
- Inventory tools should read `hostnamectl` status or `/etc/hostname` + `/etc/os-release`.
- Pair with `timedatectl` for complete first-boot identity setup.

## Related Commands

- `hostname` — classic get/set
- `timedatectl` — time/timezone
- `localectl` — locale/keymap
- `resolvectl` — DNS
- `cat /etc/os-release` — distro identity

## Additional Resources

- `man hostnamectl`
