# hwinfo

## Overview
The `hwinfo` command provides comprehensive hardware information. It's a powerful tool that probes for hardware and displays detailed information about various hardware components.

## Syntax
```bash
hwinfo [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `--short` | Brief hardware list |
| `--arch` | Show architecture info |
| `--bios` | Show BIOS info |
| `--block` | Show block devices |
| `--cpu` | Show CPU info |
| `--disk` | Show disk devices |
| `--memory` | Show memory info |
| `--network` | Show network devices |
| `--pci` | Show PCI devices |
| `--usb` | Show USB devices |
| `--all` | Show all hardware |
| `--save-config` | Save hardware config |
| `--log file` | Write log to file |

## Key Use Cases
1. Hardware inventory
2. System diagnostics
3. Driver verification
4. System documentation
5. Troubleshooting

## Examples with Explanations
### Example 1: Brief Summary
```bash
hwinfo --short
```
Show brief hardware list

### Example 2: CPU Info
```bash
hwinfo --cpu
```
Show detailed CPU information

### Example 3: Storage Info
```bash
hwinfo --disk --short
```
Show brief disk information

## Understanding Output
Categories of information:
- System overview
- CPU details
- Memory configuration
- Storage devices
- Network interfaces
- Peripheral devices

## Common Usage Patterns
1. Full system scan:
   ```bash
   hwinfo --all
   ```
2. Network check:
   ```bash
   hwinfo --network
   ```
3. Save hardware info:
   ```bash
   hwinfo --all --log hardware.log
   ```

## Performance Analysis
- Comprehensive scanning
- Resource intensive
- Database lookups
- Device probing time
- Log file generation

## Related Commands
- `lshw` - List hardware
- `lspci` - List PCI devices
- `lsusb` - List USB devices
- `dmidecode` - DMI table info
- `inxi` - System information

## Additional Resources
- [Hardware Info Documentation](https://github.com/openSUSE/hwinfo)
- [Linux Hardware Guide](https://tldp.org/HOWTO/Hardware-HOWTO/)
- [System Information Tools](https://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/)

## Hardware Categories
1. Processors
2. Memory modules
3. Storage devices
4. Network adapters
5. Peripheral devices

## Best Practices
1. Regular hardware audits
2. Document configurations
3. Monitor changes
4. Keep logs
5. Update hardware database
