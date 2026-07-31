# lshw

## Overview
`lshw` lists hardware (CPU, memory, storage, NICs, firmware). Run as **root** for full DMI/PCI detail.

## Syntax
```bash
sudo lshw [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-short` | Compact table |
| `-class` / `-C` | Filter: `network`, `disk`, `memory`, `cpu`, `system`, `display` |
| `-businfo` | Bus addresses |
| `-json` / `-xml` / `-html` | Export formats |
| `-sanitize` | Hide serials/UUIDs |
| `-numeric` | Numeric vendor/device IDs |
| `-quiet` | Less noise |

## Examples with Explanations
```bash
sudo lshw -short
sudo lshw -class network -short
sudo lshw -class disk
sudo lshw -class memory
sudo lshw -C network -businfo
sudo lshw -json | jq '.[0].product'
sudo lshw -sanitize -html > /tmp/hw.html
```

### Inventory one-liners
```bash
sudo lshw -class system -short
sudo lshw -class cpu -short
sudo lshw -class network | egrep 'description|serial|product|logical name|capacity'
```

## Related Commands
- `dmidecode` — BIOS/DMI tables  
- `lspci` / `lsusb`  
- `lscpu` / `lsblk`  
- `ip link`
