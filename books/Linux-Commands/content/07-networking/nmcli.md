# nmcli

## Overview
`nmcli` is the command-line client for NetworkManager. On Ubuntu desktops/servers with NM enabled, it is the supported way to manage connections, devices, and Wi‑Fi — not long-lived hand edits of `ifconfig`.

## Syntax
```bash
nmcli [OPTIONS] OBJECT {COMMAND | help}
```

## Common Options
| Option | Description |
|--------|-------------|
| `general status` | NM state summary |
| `connection show` | List connection profiles |
| `device status` | List interfaces and state |
| `device wifi list` | Scan SSIDs |
| `-t / -f` | Terse / field selection for scripts |

## Key Use Cases
1. Inspect live network state
2. Create Ethernet/Wi‑Fi profiles
3. Bring connections up/down
4. Script NM without the GUI

## Examples with Explanations
### Overview
```bash
nmcli general status
nmcli device status
nmcli connection show
```
First three commands for “what is NM doing?”.

### Active connection details
```bash
nmcli -f NAME,UUID,TYPE,DEVICE,STATE connection show --active
```
Compact view of what is currently up.

### Bring a profile down/up
```bash
nmcli connection down "Wired connection 1"
nmcli connection up "Wired connection 1"
```
Bounce a known profile after config changes.

### Add static Ethernet (example)
```bash
nmcli connection add type ethernet ifname eth0 con-name office-static \
  ipv4.method manual ipv4.addresses 192.168.1.50/24 \
  ipv4.gateway 192.168.1.1 ipv4.dns "1.1.1.1 8.8.8.8"
```
Creates a reusable profile; adjust iface/name for your host.

### Wi‑Fi connect
```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "secret"
```
Interactive join; prefer saved profiles for permanence.

### Reload after file edits
```bash
nmcli connection reload
nmcli connection up <name>
```
Pick up profile changes from disk.

## Notes & Pitfalls
- On minimal servers using `systemd-networkd` + netplan only, NM/`nmcli` may be absent.
- Prefer connection profiles over ephemeral `ip addr add` for persistent config.
- Use `nmcli -g` / `-t` for machine-readable scripting.

## Related Commands
- `ip` — kernel addresses/routes (lower level)
- `resolvectl` — systemd-resolved DNS
- `journalctl -u NetworkManager` — NM logs
- `netplan` — Ubuntu declarative config (may render NM or networkd)
