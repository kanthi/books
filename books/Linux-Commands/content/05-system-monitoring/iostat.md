# iostat

## Overview
`iostat` (sysstat package) shows CPU load and **per-device** I/O rates/utilization. Use it to find busy disks and whether the system is I/O-wait bound.

## Syntax
```bash
iostat [options] [interval [count]]
iostat [options] [interval [count]] [device...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-x` | Extended device stats (`%util`, `await`, …) |
| `-z` | Skip idle devices |
| `-y` | Skip first (since-boot) report |
| `-d` / `-c` | Devices only / CPU only |
| `-h` / `-m` / `-k` | Human / MB / KB units |
| `-p` | Include partitions |
| `-t` | Timestamps |
| `-N` | Device-mapper names |

## Key extended fields
| Field | Meaning |
|-------|---------|
| `r/s` `w/s` | Read/write requests per sec |
| `rkB/s` `wkB/s` | Throughput |
| `await` | Avg wait (queue + service) ms |
| `aqu-sz` | Avg queue length |
| `%util` | Device busy % (~saturation at 100% for simple devices) |

## Examples with Explanations
### Extended live
```bash
iostat -xz 1 5
iostat -xyz 1 10
```

### One device
```bash
iostat -xz 1 5 nvme0n1
```

### CPU only
```bash
iostat -c 1 5
```

### Partitions
```bash
iostat -xzp 1 3
```

## Notes
- Install: `sudo apt install sysstat`.  
- First report without `-y` is since boot; use interval mode for “now”.  
- Multipath/RAID can make `%util` interpretation subtler.

## Related Commands
- `vmstat` — system-level view  
- `iotop` — per-process I/O (if installed)  
- `lsblk` — device names  
- `sar -d` — historical disk
