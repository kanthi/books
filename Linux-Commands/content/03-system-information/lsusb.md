# lsusb

## Overview
The `lsusb` command lists USB devices connected to the system. It provides information about USB buses and the devices connected to them.

## Syntax
```bash
lsusb [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` | Verbose mode |
| `-t` | Show USB device tree |
| `-s [[bus]:][devnum]` | Show only devices with specified bus/device numbers |
| `-d [vendor]:[product]` | Show only devices with specified vendor/product ID |
| `-D device` | Show only specified device |
| `-V` | Show version |
| `-h` | Show help message |

## Key Use Cases
1. Device identification
2. Hardware troubleshooting
3. System inventory
4. Driver verification
5. Device monitoring

## Examples with Explanations
### Example 1: Basic List
```bash
lsusb
```
Show all USB devices

### Example 2: Device Tree
```bash
lsusb -t
```
Show USB device hierarchy

### Example 3: Verbose Info
```bash
lsusb -v
```
Show detailed device information

## Understanding Output
Basic format:
```
Bus XXX Device XXX: ID XXXX:XXXX Vendor Product
```
Example:
```
Bus 001 Device 002: ID 8087:0024 Intel Corp. Integrated Rate Matching Hub
```

## Common Usage Patterns
1. Find specific device:
   ```bash
   lsusb -d vendor:product
   ```
2. Check device tree:
   ```bash
   lsusb -t
   ```
3. Monitor changes:
   ```bash
   watch lsusb
   ```

## Performance Analysis
- Quick execution
- USB bus scanning
- Device enumeration
- Database lookup time
- Real-time information

## Related Commands
- `lspci` - List PCI devices
- `lshw` - List hardware
- `udevadm` - Device manager
- `usb-devices` - Show USB info
- `dmesg` - Kernel messages

## Additional Resources
- [USB Utils Documentation](http://www.linux-usb.org/tools.html)
- [Linux USB Guide](https://www.kernel.org/doc/html/latest/usb/)
- [Hardware Management](https://www.tecmint.com/linux-usb-management/)

## Device Categories
1. Storage devices
2. Input devices
3. Printers
4. Cameras
5. Network adapters

## Best Practices
1. Regular device checks
2. Update USB database
3. Monitor connections
4. Document devices
5. Check power usage
