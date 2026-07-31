# vmstat

## Overview
`vmstat` reports virtual memory, processes, CPU, and I/O counters. Ideal for a quick “is it CPU, RAM, or disk?” loop in a terminal.

## Syntax
```bash
vmstat [options] [delay [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `delay count` | Sample every *delay* seconds, *count* times |
| `-w` | Wide columns |
| `-S M` | Units (k/K/m/M) |
| `-a` | Active/inactive memory |
| `-s` | Event counters summary |
| `-d` | Disk stats |
| `-t` | Timestamp each line |

## Reading the columns (classic)
| Area | Fields | Hints |
|------|--------|-------|
| Procs | `r`, `b` | `r` > CPU count → runnable contention; `b` blocked on I/O |
| Memory | `swpd`, `free`, `buff`, `cache` | Rising `swpd` + low free → pressure |
| Swap | `si`, `so` | Continuous swap in/out → RAM shortage |
| IO | `bi`, `bo` | Blocks in/out |
| System | `in`, `cs` | Interrupts, context switches |
| CPU | `us`, `sy`, `id`, `wa`, `st` | `wa` I/O wait; `st` steal (VM) |

**First line** is often averages since boot — prefer the subsequent sample lines when using a delay.

## Examples with Explanations
### Live sample
```bash
vmstat 1 10
vmstat -w 1 5
```

### Summary counters
```bash
vmstat -s
```

### Disk
```bash
vmstat -d 1 5
```

### Timestamped
```bash
vmstat -t 2 5
```

## Patterns
- High `r`, high `us`/`sy` → CPU bound  
- High `b` or `wa` → I/O bound (pair with `iostat -xz`)  
- `so`/`si` non-zero sustained → add RAM or reduce cache pressure  
- High `st` → noisy neighbor / undersized VM  

## Related Commands
- `iostat` — per-device I/O  
- `mpstat` — per-CPU  
- `free -h` — memory snapshot  
- `top` / `pidstat` — per-process  
- `sar` — historical (sysstat)
