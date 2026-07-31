# lspci

## Overview
`lspci` lists PCI devices (NICs, GPUs, storage controllers, bridges). Part of `pciutils`.

## Syntax
```bash
lspci [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-v` / `-vv` | Verbose |
| `-k` | Kernel drivers in use/modules |
| `-nn` | Numeric vendor:device codes |
| `-s slot` | Specific device |
| `-d vendor:device` | Filter IDs |
| `-t` | Tree |
| `-mm` | Machine-readable |

## Examples with Explanations
```bash
lspci
lspci -nn
lspci -k
lspci -v | less
lspci -s 00:1f.2 -vv
lspci | grep -i ethernet
lspci | grep -i nvidia
```

### Driver / module debug
```bash
lspci -nnk | grep -A3 -i network
```

## Notes
- Update PCI IDs: `sudo update-pciids`.  
- Needs root for some extended config space reads (`-vv` as root).  

## Related Commands
- `lsusb`  
- `lshw -class network`  
- `ethtool`  
- `modinfo` / `lsmod`
