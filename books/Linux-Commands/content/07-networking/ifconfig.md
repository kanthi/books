# ifconfig

## Overview

`ifconfig` configures and displays network interfaces from the legacy **net-tools** package. On modern Linux, prefer **`ip`** from iproute2 (`ip addr`, `ip link`, `ip route`). This page exists for reading old docs, recovery shells that still ship net-tools, and muscle-memory translation to `ip`.

Many minimal images no longer install `ifconfig` by default.

## Syntax

```bash
ifconfig [interface]
ifconfig interface [address_family] options
```

## Common Options / forms

| Form | Description |
|------|-------------|
| `ifconfig` | List up interfaces (often only “up”) |
| `ifconfig -a` | All interfaces including down |
| `ifconfig eth0` | Show one interface |
| `ifconfig eth0 up` / `down` | Bring interface up/down |
| `ifconfig eth0 192.0.2.10 netmask 255.255.255.0` | Set IPv4 |
| `ifconfig eth0 add ...` | Additional addresses (implementation-dependent) |
| `ifconfig eth0 hw ether AA:BB:...` | Set MAC (may need down first) |
| `ifconfig eth0 mtu 1400` | Set MTU |
| `ifconfig eth0:0 ...` | Alias interface style (legacy) |

## Examples with Explanations

### Display

```bash
ifconfig
ifconfig -a
ifconfig eth0
```

### Preferred modern equivalents

```bash
ip -br link
ip -br addr
ip addr show dev eth0
ip link set eth0 up
ip addr add 192.0.2.10/24 dev eth0
ip route
```

### Bring up/down

```bash
sudo ifconfig eth0 up
sudo ifconfig eth0 down
# modern:
sudo ip link set eth0 up
```

### Set address (legacy)

```bash
sudo ifconfig eth0 192.0.2.10 netmask 255.255.255.0
# modern CIDR:
sudo ip addr add 192.0.2.10/24 dev eth0
```

### MTU

```bash
sudo ifconfig eth0 mtu 1400
sudo ip link set eth0 mtu 1400
```

### Install on Debian/Ubuntu if missing

```bash
sudo apt install net-tools
```

Still prefer learning `ip`.

## Notes / Pitfalls

- Output and available flags differ across Unixes; Linux net-tools is not identical to BSD.
- Changes are not persistent — use netplan/NetworkManager/systemd-networkd.
- Alias interfaces (`eth0:0`) are obsolete vs multiple addresses on one device.
- Scripts parsing `ifconfig` are fragile — use `ip -j` JSON when available.
- Wireless details: use `iw` / NetworkManager, not only ifconfig.

## 2026-relevant notes

- Teaching and certification materials may still show ifconfig; translate on sight to `ip`.
- Containers: `ip` is the standard; ifconfig often absent.
- For persistent config, never rely on either ifconfig or ip alone — use the distro network stack.

## Related Commands

- `ip` — modern interface/address/route tool
- `ss` — sockets (replaces netstat)
- `nmcli` / `networkctl` — higher-level management
- `ethtool` — NIC hardware settings
- `ifup` / `ifdown` — distro helper scripts (legacy)

## Additional Resources

- `man ifconfig` (if installed), `man ip`
