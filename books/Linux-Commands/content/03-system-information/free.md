# free

## Overview
`free` displays RAM and swap usage. On modern Linux, **available** is more meaningful than **free** alone (includes reclaimable cache).

## Syntax
```bash
free [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human units |
| `-m` / `-g` | MiB / GiB |
| `-s N` | Refresh every N seconds |
| `-t` | Totals line |
| `-w` | Wide |
| `-v` | Version |

## Examples with Explanations
```bash
free -h
free -m
free -h -s 2
watch -n 1 free -h
```

### Interpreting
- **buff/cache** — can usually be reclaimed for apps  
- **available** — estimate for new workloads without swapping  
- **swap used** rising under load → memory pressure  

```bash
# quick pressure signal
free -h | awk '/Mem:/ {print "avail",$7} /Swap:/ {print "swap used",$3}'
```

## Related Commands
- `vmstat` — si/so over time  
- `/proc/meminfo` — raw counters  
- `top` / `htop` — per-process RSS  
- `systemd-cgtop` — cgroup memory
