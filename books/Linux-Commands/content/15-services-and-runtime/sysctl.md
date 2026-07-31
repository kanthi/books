# sysctl

## Overview
`sysctl` is used to modify kernel parameters at runtime. The parameters available are those listed under `/proc/sys/`.

## Syntax
```bash
sysctl [options] [variable[=value]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a`, `--all` | Display all currently available kernel variables |
| `-w` | Write/modify a kernel parameter value in memory |
| `-p [file]` | Load sysctl settings from a configuration file (default `/etc/sysctl.conf`) |
| `-e` | Ignore errors about unknown keys |

## Key Use Cases
1. Tuning network stack performance and IP forwarding.
2. Adjusting virtual memory swappiness (`vm.swappiness`).
3. Configuring security controls like kernel pointer restriction (`kernel.kptr_restrict`).

## Examples with Explanations
### Example 1: Enabling IP Forwarding
```bash
sysctl -w net.ipv4.ip_forward=1
```
Enables IPv4 routing in memory immediately.

### Example 2: Reloading Configuration
```bash
sysctl -p /etc/sysctl.d/99-custom.conf
```
Applies kernel configuration settings from `/etc/sysctl.d/99-custom.conf`.

## Related Commands
- `dmesg` - Kernel ring buffer log viewer
- `systemctl` - Service manager
