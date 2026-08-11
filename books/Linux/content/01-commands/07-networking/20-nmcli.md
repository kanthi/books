# nmcli

## Overview

`nmcli` is the CLI for **NetworkManager**. On many Ubuntu desktops/servers with NM enabled it is the supported way to manage connections, devices, and Wi‑Fi—prefer connection profiles over ephemeral `ifconfig`/`ip addr add` for persistent config.

## Syntax

```bash
nmcli [OPTIONS] OBJECT {COMMAND | help}
```

Objects include: `general`, `networking`, `device`, `connection`, `radio`, `monitor`, …

## Common Commands

| Command | Description |
|---------|-------------|
| `general status` | NM state |
| `device status` | Interfaces + state |
| `device wifi list` | Scan SSIDs |
| `connection show` | Profiles |
| `connection up/down NAME` | Activate/deactivate |
| `connection add …` | Create profile |
| `connection modify …` | Change settings |
| `connection reload` | Reload from disk |
| `networking off/on` | Global NM networking |

Useful global flags: `-t` terse, `-f` fields, `-g` values only, `-p` pretty.

## Key Use Cases

1. Inspect live NM state without a GUI
2. Create Ethernet/Wi‑Fi profiles
3. Bring connections up/down safely
4. Script NM on headless laptops/servers

## Examples with Explanations

### Overview

```bash
nmcli general status
nmcli device status
nmcli connection show
nmcli -f NAME,UUID,TYPE,DEVICE,STATE connection show --active
```

### Bounce a connection

```bash
nmcli connection down "Wired connection 1"
nmcli connection up "Wired connection 1"
```

### Static Ethernet profile

```bash
nmcli connection add type ethernet ifname eth0 con-name office-static \
  ipv4.method manual \
  ipv4.addresses 192.168.1.50/24 \
  ipv4.gateway 192.168.1.1 \
  ipv4.dns "1.1.1.1,8.8.8.8"
nmcli connection up office-static
```

### DHCP Ethernet

```bash
nmcli connection add type ethernet ifname eth0 con-name office-dhcp ipv4.method auto
```

### Wi‑Fi

```bash
nmcli device wifi list
nmcli device wifi connect "SSID" password "secret"
nmcli connection modify SSID wifi-sec.psk "new-secret"
```

### Reload and DNS insight

```bash
nmcli connection reload
nmcli connection up <name>
nmcli dev show eth0 | rg 'IP4|IP6|DNS'
resolvectl status
```

### One-liner recipes

```bash
# Airplane-mode-ish
nmcli radio wifi off
nmcli radio wifi on

# Script-friendly active names
nmcli -t -f NAME c show --active

# Delete a profile
nmcli connection delete office-static
```

## Notes & Pitfalls

- Minimal cloud images may use **systemd-networkd + netplan** without NM—`nmcli` won’t exist.
- Ephemeral `ip addr add` can fight NM; put durable config in profiles or netplan.
- Wi‑Fi secrets end up in profile files—protect permissions.
- VPN plugins vary; check `nmcli connection show` types available.

## 2026-relevant notes

- Prefer **netplan** YAML on Ubuntu servers when that is the distro’s source of truth—it may render NM or networkd backends.
- DoT/DNS settings increasingly appear in NM/resolved integration—verify with `resolvectl`.
- `ifconfig` is not the management API for NM systems.

## Related Commands

- `ip` — kernel addresses/routes
- `resolvectl` — systemd-resolved
- `journalctl -u NetworkManager` — logs
- `nmtui` — curses UI
- `networkctl` — networkd

## Additional Resources

- `man nmcli`
- NetworkManager documentation
