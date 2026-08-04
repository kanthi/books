# lsusb

## Overview

`lsusb` lists USB devices connected to the system (buses, IDs, vendor/product strings). Essential for debugging docks, keys, serial adapters, and whether a device is even enumerated before loading drivers.

Package: often `usbutils`.

## Syntax

```bash
lsusb [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-v`, `--verbose` | Detailed descriptors |
| `-vv` | Even more verbose |
| `-t` | Tree view |
| `-s [[bus]:][devnum]` | Show only specific device |
| `-d vendor:product` | Filter by ID |
| `-D device` | Query device node under `/dev/bus/usb` |
| `-k` | Kernel driver binding info (when supported) |

## Examples with Explanations

### List devices

```bash
lsusb
lsusb -t
```

### Filter

```bash
lsusb -d 0781:5567
lsusb -s 001:005
```

### Verbose probe

```bash
sudo lsusb -v | less
sudo lsusb -v -d 1d6b:0002 | less
```

### Correlate with kernel messages

```bash
lsusb
dmesg -w
# plug device, watch enumeration
journalctl -k -f
```

### Find device nodes

```bash
ls -l /dev/bus/usb/*/*
ls -l /dev/ttyUSB* /dev/ttyACM* 2>/dev/null
```

### Tree + drivers

```bash
lsusb -t
# shows hubs and nesting; helpful for power/hub issues
```

## Notes / Pitfalls

- Permission: some verbose details need root.
- Unauthorized USB policy (USBGuard) may block devices that still appear partially.
- VMs need USB passthrough configured; host `lsusb` ≠ guest.
- IDs are hex vendor:product from the USB-IF database; strings can be generic.
- Unstable enumeration often means cable/power/hub issues, not software.

## 2026-relevant notes

- USB-C docks create deep hub trees — use `-t`.
- `usbguard`, `udev` rules, and secure boot policies affect usability more than `lsusb` itself.
- For serial adapters, also check `dmesg` for `ttyUSB`/`ttyACM` assignment.

## Related Commands

- `lspci` — PCI devices
- `lshw` — hardware inventory
- `dmesg` / `journalctl -k` — kernel enumeration logs
- `udevadm info` — device metadata
- `usb-devices` — alternate text dump
- `modprobe` — load drivers

## Additional Resources

- `man lsusb`
