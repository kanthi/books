# lspci

## Overview

`lspci` lists **PCI and PCI Express** devices: NICs, GPUs, storage controllers, USB controllers, bridges, and more. Part of the `pciutils` package (standard on Ubuntu servers). First stop for “is the NIC visible?”, “which driver is bound?”, and collecting `vendor:device` IDs for driver or firmware work.

## Syntax

```bash
lspci [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-v` / `-vv` / `-vvv` | Increasing verbosity (capabilities, BARs, …) |
| `-k` | Kernel driver in use and modules that can bind |
| `-nn` | Numeric vendor:device (and class) codes |
| `-s slot` | Only this slot (`[[domain:]bus:]slot[.func]`) |
| `-d vendor:device` | Filter by IDs (`8086:`, `10de:`, …) |
| `-t` | Tree of buses/bridges |
| `-mm` | Machine-readable key-value |
| `-D` | Always show domain numbers |
| `-n` | Numeric IDs only (no name resolution) |
| `-x` / `-xxx` | Hex config space dump (needs root for full) |

## Key Use Cases

1. Confirm a device is enumerated after install/passthrough
2. See which kernel driver owns a NIC/GPU/storage HBA
3. Collect `vendor:device` for DKMS/out-of-tree modules
4. Compare before/after firmware or hardware changes

## Examples with Explanations

### Everyday list

```bash
lspci
lspci -nn
```

Human names plus, with `-nn`, stable `[vvvv:dddd]` IDs for docs and `modprobe` quirks.

### Drivers and modules

```bash
lspci -k
lspci -nnk
```

`Kernel driver in use` is the bound driver; `Kernel modules` lists candidates. Empty driver often means missing firmware, blacklisted module, or unbound VFIO for passthrough.

### Network / GPU filters

```bash
lspci | grep -i ethernet
lspci | grep -i network
lspci | grep -i nvidia
lspci | grep -i 'non-volatile\|nvme\|raid\|scsi'
lspci -nnk | grep -A3 -i ethernet
```

### One device, deep detail

```bash
lspci -s 00:1f.2 -vv
sudo lspci -s 00:1f.2 -vvv
```

Slot address from the first column of `lspci`. Root unlocks more config space in deep dumps.

### Tree view

```bash
lspci -t
lspci -tv
```

Shows how devices hang off bridges — useful for bandwidth/topology discussions and multi-GPU layouts.

### Machine-readable

```bash
lspci -mmnn
lspci -mm | head
```

Easier for scripts than scraping the pretty format.

### ID database refresh

```bash
sudo update-pciids
lspci -nn | head
```

Refreshes `/usr/share/misc/pci.ids` so new devices resolve to names (IDs still work offline).

### Correlate with sysfs / ethtool

```bash
lspci -nnk | grep -A3 -i ethernet
# then for a netdev:
ethtool -i eth0
ls -l /sys/class/net/eth0/device/driver
```

lspci shows PCI binding; `ethtool -i` shows the netdev’s driver/firmware strings.

## Understanding Output

Default line shape:

```text
00:1f.2 SATA controller: Intel Corporation ... [8086:…. ] (rev ..)
│       │                 │                      │
│       │                 human name             vendor:device
bus:slot.func + class
```

| Piece | Role |
|-------|------|
| Domain/BDF | Address for `-s` and sysfs paths |
| Class | Ethernet, VGA, NVMe, bridge, … |
| Vendor/device IDs | Stable identity for drivers |
| `-k` lines | Bound driver vs available modules |

Sysfs path pattern: `/sys/bus/pci/devices/0000:bus:slot.func/`.

## Notes & Pitfalls

- Some extended reads need **root** (`-vvv`, full `-xxx`).
- Names depend on `pci.ids`; unknown devices still show IDs with `-nn`.
- SR-IOV VFs appear as extra devices — don’t confuse PF vs VF when binding drivers.
- GPU “not found” can be power/BIOS/resizability (BAR) issues — dmesg matters.
- Hotplug/cloud passthrough: re-run lspci after attach; guest may need reboot for some devices.
- `update-pciids` needs network; air-gapped hosts keep stale names only.

## Related Commands

- `lsusb` — USB bus inventory
- `lshw -class network -class display` — higher-level inventory
- `ethtool` — NIC driver/link settings
- `modinfo` / `lsmod` / `modprobe` — module details and load
- `dmesg` / `journalctl -b` — probe/firmware errors
- `setpci` — low-level PCI config (expert; easy to break systems)

## Additional Resources

- `man lspci`
- `man update-pciids`
- `man pci.ids`
