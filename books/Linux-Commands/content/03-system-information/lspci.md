# lspci

## Overview
The `lspci` command lists all PCI buses and devices connected to them. It provides detailed information about hardware devices in the system.

## Syntax
```bash
lspci [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` | Verbose mode |
| `-vv` | Very verbose mode |
| `-k` | Show kernel drivers |
| `-n` | Show PCI vendor/device codes |
| `-mm` | Machine readable format |
| `-t` | Show bus tree |
| `-s [[[[<domain>]:]<bus>]:][<device>][.[<func>]]` | Show specific device |
| `-d [<vendor>]:[<device>]` | Show specific vendor/device |
| `-i <file>` | Use specified ID database |
| `-D` | Show domain numbers |

## Key Use Cases
1. Hardware identification
2. Driver troubleshooting
3. System inventory
4. Hardware verification
5. Device monitoring

## Examples with Explanations
### Example 1: Basic List
```bash
lspci
```
Show basic device list

### Example 2: Verbose Info
```bash
lspci -v
```
Show detailed device information

### Example 3: Kernel Drivers
```bash
lspci -k
```
Show kernel modules for devices

## Understanding Output
Format:
```
Bus:Device.Function Class: Vendor Device Description
```
Example:
```
00:02.0 VGA compatible controller: Intel Corporation UHD Graphics 620
```

## Common Usage Patterns
1. Check graphics card:
   ```bash
   lspci | grep -i vga
   ```
2. Network interfaces:
   ```bash
   lspci | grep -i ethernet
   ```
3. Show device tree:
   ```bash
   lspci -t
   ```

## Performance Analysis
- Fast execution
- System bus scanning
- PCI configuration space access
- Database lookup time
- Memory efficient

## Related Commands
- `lsusb` - List USB devices
- `lshw` - List hardware
- `dmidecode` - DMI table decoder
- `hwinfo` - Hardware information
- `udevadm` - Device manager

## Additional Resources
- [PCI Utils Documentation](https://mj.ucw.cz/sw/pciutils/pciutils.html)
- [Linux Hardware Guide](https://tldp.org/HOWTO/Hardware-HOWTO/)
- [System Information Guide](https://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/)

## Hardware Categories
1. Graphics cards
2. Network interfaces
3. Storage controllers
4. USB controllers
5. Audio devices

## Best Practices
1. Regular hardware checks
2. Driver verification
3. Update PCI database
4. Document changes
5. Monitor performance
