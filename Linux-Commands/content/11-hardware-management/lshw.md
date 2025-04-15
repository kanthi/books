# lshw

## Overview
The `lshw` (List Hardware) command provides detailed information about the physical hardware configuration of the machine. It can report exact memory configuration, firmware version, mainboard configuration, CPU version and speed, cache configuration, bus speed, etc.

## Syntax
```bash
lshw [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-short` | Brief output |
| `-businfo` | Bus information |
| `-class class` | Show specific class |
| `-C class` | Same as -class |
| `-html` | HTML output |
| `-xml` | XML output |
| `-json` | JSON output |
| `-sanitize` | Hide sensitive info |
| `-numeric` | Numeric IDs |
| `-quiet` | Less verbose |
| `-version` | Show version |

## Hardware Classes
| Class | Description |
|-------|-------------|
| `system` | System info |
| `cpu` | Processor |
| `memory` | Memory devices |
| `disk` | Storage |
| `network` | Network interfaces |
| `display` | Display adapters |
| `multimedia` | Multimedia devices |
| `power` | Power device |
| `input` | Input devices |

## Key Use Cases
1. Hardware inventory
2. System diagnostics
3. Configuration check
4. Troubleshooting
5. Documentation

## Examples with Explanations
### Example 1: Basic Usage
```bash
lshw -short
```
Brief hardware list

### Example 2: Specific Class
```bash
lshw -class disk
```
Show storage devices

### Example 3: HTML Output
```bash
lshw -html > hardware.html
```
Generate HTML report

## Common Usage Patterns
1. Full system scan:
   ```bash
   lshw
   ```
2. Network devices:
   ```bash
   lshw -class network
   ```
3. Memory info:
   ```bash
   lshw -class memory
   ```

## Security Considerations
1. Sensitive information
2. System access
3. Output sanitization
4. Report distribution
5. Access control

## Related Commands
- `hwinfo` - Hardware info
- `dmidecode` - DMI table decoder
- `lspci` - PCI devices
- `lsusb` - USB devices
- `lscpu` - CPU info

## Additional Resources
- [LSHW Manual](https://ezix.org/project/wiki/HardwareLiSter)
- [Hardware Guide](https://www.cyberciti.biz/faq/linux-list-hardware-information/)
- [System Information](https://www.tecmint.com/commands-to-collect-system-and-hardware-information-in-linux/)

## Best Practices
1. Regular scanning
2. Documentation
3. Change tracking
4. Report formatting
5. Data protection

## Output Formats
1. Text (default)
2. HTML
3. XML
4. JSON
5. Short format

## Troubleshooting
1. Missing information
2. Access errors
3. Output format
4. Device detection
5. System compatibility
