# lshw

## Overview

`lshw` (list hardware) probes the system and prints a hardware tree: CPU, memory, storage, network, firmware, and buses. Run as **root** (or with capabilities) for full DMI/PCI detail; unprivileged runs omit sensitive or privileged data.

```bash
sudo apt install lshw
sudo dnf install lshw
```

## Syntax

```bash
sudo lshw [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-short` | Compact table |
| `-class CLASS` / `-C` | Filter: `network`, `disk`, `memory`, `cpu`, `system`, `display`, `storage`, `power`, … |
| `-businfo` | Bus addresses / logical names |
| `-json` / `-xml` / `-html` | Export formats |
| `-sanitize` | Hide serials and UUIDs for sharing |
| `-numeric` | Numeric IDs |
| `-quiet` | Less noise |
| `-enable` / `-disable` tests | Control probe tests (see man) |

## Key Use Cases

1. Inventory machines for asset management
2. Identify NIC driver/logical name mismatches
3. Confirm RAM/slots and disk models
4. Generate sanitized HTML/JSON for tickets

## Examples with Explanations

### Quick overview

```bash
sudo lshw -short
sudo lshw -class system -short
```

### Network and disks

```bash
sudo lshw -class network -short
sudo lshw -C network -businfo
sudo lshw -class disk
sudo lshw -class storage
```

### Memory and CPU

```bash
sudo lshw -class memory
sudo lshw -class cpu -short
```

### Export

```bash
sudo lshw -json > /tmp/hw.json
sudo lshw -sanitize -html > /tmp/hw.html
sudo lshw -json | jq '.[].class' 2>/dev/null | sort -u
```

### One-liner recipes

```bash
# MAC and product for NICs
sudo lshw -class network | egrep 'description|product|serial|logical name|capacity'

# Disk models
sudo lshw -class disk | egrep 'description|product|serial|size|logical name'

# Compare businfo to ip link
sudo lshw -C network -businfo; ip -br link
```

## Notes & Pitfalls

- Without root, expect incomplete PCI/DMI data.
- **Virtual machines** report virtual hardware; use cloud metadata APIs for instance type.
- Probing can be slow on large systems; class filters help.
- Serial numbers are sensitive—use `-sanitize` before pasting into public issues.
- Prefer `lscpu`, `lsblk`, `ip link` for single-purpose questions; `lshw` is the wide inventory tool.

## 2026-relevant notes

- On servers, **`dmidecode`**, **`lshw`**, and **`lscpu`/`lsblk`** remain the classic trio; some fleets use `inxi`, `hwinfo`, or vendor out-of-band (iDRAC/iLO) for authoritative inventory.
- NVMe and virtual NICs rename often (`ens`, `enp`, `eth`)—trust `businfo` + `ip link` together.
- JSON export helps config-management facts when agent-based inventory isn’t installed.

## Related Commands

- `dmidecode` — SMBIOS/DMI tables
- `lspci` / `lsusb` — buses
- `lscpu` / `lsblk` / `lsmem` — focused views
- `ip link` — live interfaces
- `hwinfo` — alternate prober (SUSE heritage)

## Additional Resources

- `man lshw`
- Upstream ezix.org lshw documentation
