# lsusb

## Overview
`lsusb` lists devices on the USB buses (keyboards, NICs, storage, serial adapters, phones). Provided by the `usbutils` package.

## Syntax
```bash
lsusb [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` | Verbose descriptors (noisy; pipe to `less`) |
| `-t` | Topology tree |
| `-s [[bus]:][devnum]` | Single device |
| `-d vendor:product` | Filter by IDs (from `lsusb` first column) |
| `-D /dev/bus/usb/...` | Dump a device node |
| `-v -s 001:005` | Verbose for one device |

## Examples with Explanations
```bash
lsusb
lsusb -t
lsusb -d 0781:5581
sudo lsusb -v 2>/dev/null | less
```

### After plugging a device
```bash
dmesg | tail -40
journalctl -k -n 40 --no-pager
lsusb
lsblk -f          # if it is storage
```

### Watch for hotplug
```bash
watch -n 1 lsusb
```

## Notes
- IDs look like `Bus 001 Device 005: ID abcd:1234 Vendor Product`.  
- Permissions may limit verbose descriptor detail without root.  
- Update ID database periodically with distro packages (`usb.ids`).

## Related Commands
- `lspci` — PCI devices  
- `dmesg` / `journalctl -k`  
- `udevadm info --name=/dev/ttyUSB0`  
- `lsblk` / `usb-devices`
