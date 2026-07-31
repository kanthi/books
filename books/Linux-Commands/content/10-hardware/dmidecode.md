# dmidecode

## Overview
`dmidecode` dumps the DMI/SMBIOS tables: manufacturer, product, serial, BIOS version, memory slots, etc. Requires **root**.

## Syntax
```bash
sudo dmidecode [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-t type` | `system`, `bios`, `baseboard`, `memory`, `processor`, `chassis`, … |
| `-s keyword` | Print one string (`system-serial-number`, `system-product-name`, …) |
| `-u` | Dump raw |
| `-q` | Less verbose |

## Examples with Explanations
```bash
sudo dmidecode -t system
sudo dmidecode -t bios
sudo dmidecode -t memory
sudo dmidecode -s system-product-name
sudo dmidecode -s system-serial-number
sudo dmidecode -t processor | egrep 'Version|Core|Thread|Max Speed'
```

### Inventory one-liners
```bash
sudo dmidecode -s system-manufacturer
sudo dmidecode -s system-uuid
sudo dmidecode -t memory | grep -E 'Size:|Locator:|Speed:'
```

## Notes
- VMs often expose synthetic DMI data.  
- Serials are sensitive — sanitize before sharing.  
- Alternative: `lshw`, `/sys/class/dmi/id/*`.

## Related Commands
- `lshw`  
- `lscpu`  
- `cat /sys/class/dmi/id/product_name`
