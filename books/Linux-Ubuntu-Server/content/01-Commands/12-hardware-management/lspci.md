# lspci

## Overview
The `lspci` command displays information about PCI buses in the system and devices connected to them. It's essential for hardware identification and troubleshooting.

## Syntax
```bash
lspci [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` | Verbose output |
| `-vv` | Very verbose output |
| `-k` | Show kernel drivers |
| `-mm` | Machine-readable output |
| `-t` | Show bus tree |
| `-s [[[[<domain>]:]<bus>]:][<device>][.[<func>]]` | Show specific device |
| `-d [<vendor>]:[<device>]` | Show specific vendor/device |
| `-i <file>` | Use specified ID database |

## Key Use Cases
1. Hardware identification
2. Driver troubleshooting
3. System inventory
4. Hardware compatibility checks
5. Performance analysis

## Examples with Explanations
### Example 1: Basic Device List
```bash
lspci
```
Shows basic information about PCI devices

### Example 2: Detailed Information
```bash
lspci -v
```
Shows verbose information including driver details

### Example 3: Kernel Modules
```bash
lspci -k
```
Shows kernel modules used by each device

## Understanding Output
Standard output format:
```
Bus:Device.Function Class: Vendor Device (Rev XX)
```
Example:
```
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 620 (rev 07)
```

## Common Usage Patterns
1. Check graphics card:
   ```bash
   lspci | grep -i vga
   ```
2. View network interfaces:
   ```bash
   lspci | grep -i ethernet
   ```
3. Check specific device details:
   ```bash
   lspci -s 00:02.0 -v
   ```

## Performance Analysis
- Minimal system impact
- Quick hardware inventory
- Driver-hardware relationship
- Resource allocation
- IRQ assignments

## Related Commands
- `lsusb` - List USB devices
- `lshw` - List hardware
- `dmidecode` - DMI table decoder
- `hwinfo` - Hardware information
- `dmesg` - Kernel ring buffer

## Additional Resources
- [Linux lspci manual](https://man7.org/linux/man-pages/man8/lspci.8.html)
- [PCI ID Repository](https://pci-ids.ucw.cz/)
- [Hardware Management Guide](https://www.tecmint.com/linux-pci-devices/)
