# ethtool

## Overview

`ethtool` queries and controls **Ethernet NIC** settings: link speed/duplex, offloads, ring parameters, and driver info. Use it when `ip link` shows a device but performance or link negotiation looks wrong. Requires root for most changes.

```bash
sudo apt install ethtool
```

## Syntax

```bash
ethtool [options] devname
ethtool -s devname …          # change settings
```

## Common Options

| Option | Description |
|--------|-------------|
| *(dev)* | Show basic link settings |
| `-i` | Driver and firmware info |
| `-k` | Offload features |
| `-K` | Change offloads |
| `-S` | NIC/driver statistics |
| `-g` / `-G` | Ring buffer get/set |
| `-s` | Change speed/duplex/autoneg/wol |
| `-p` | Identify port (blink LED) |

## Safety

- Forcing speed/duplex incorrectly causes silent poor performance or link down. Prefer autoneg when the peer supports it.  
- Offload changes can fix or break checksum issues — test with care on production.

## Examples with Explanations

### Link status

```bash
ethtool eth0
# Speed, Duplex, Auto-negotiation, Link detected
```

### Driver info

```bash
ethtool -i eth0
```

### Statistics

```bash
ethtool -S eth0 | egrep -i 'err|drop|crc|miss'
```

### Identify physical port

```bash
sudo ethtool -p eth0 5          # blink ~5 seconds
```

### Offloads

```bash
ethtool -k eth0 | head
sudo ethtool -K eth0 gro off    # example; know why you toggle
```

### Persist settings

Use distro network config (`netplan`, NetworkManager, systemd-networkd) or `ethtool` udev/systemd oneshot units — bare `ethtool -s` does not survive reboot alone.

## Related Commands

- `ip link` / `ip -s link` — state and counters  
- `nmcli` — NetworkManager  
- `lspci` — hardware identity  
- `dmesg` — driver attach messages  

## Additional Resources

- `man ethtool`
