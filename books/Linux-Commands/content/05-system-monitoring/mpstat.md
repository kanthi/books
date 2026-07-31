# mpstat

## Overview
`mpstat` (sysstat) reports **per-CPU** utilization so you can see imbalance, softirq load, or steal time on individual cores.

## Syntax
```bash
mpstat [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-P ALL` | Each CPU plus average |
| `-P 0,2` | Specific CPUs |
| `-u` | Utilization (default) |
| `-I SUM\|CPU\|SCPU\|ALL` | Interrupt statistics |
| `-A` | Equivalent to wide set of reports |
| `-o JSON` | JSON (newer sysstat) |

## Examples with Explanations
```bash
mpstat 1 5
mpstat -P ALL 1 5
mpstat -P ALL -u 1 3
mpstat -I SUM 1 3
```

### Interpret
- One CPU at 100% `usr` while others idle → single-thread bottleneck  
- High `%soft` → network/softirq pressure  
- High `%steal` → hypervisor contention  

### Pair with process tools
```bash
mpstat -P ALL 1 3 &
pidstat -u 1 3
```

## Install
```bash
sudo apt install sysstat
```

## Related Commands
- `vmstat` — aggregate  
- `sar -P ALL` — history  
- `top` then press `1`  
- `pidstat` — per-process
