# vmstat

## Overview
The `vmstat` command reports virtual memory statistics. It provides information about processes, memory, paging, block IO, traps, and CPU activity.

## Syntax
```bash
vmstat [options] [delay [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Active/inactive memory |
| `-f` | Fork statistics |
| `-m` | Slab info |
| `-n` | Header once |
| `-s` | Event counters |
| `-d` | Disk statistics |
| `-p partition` | Partition stats |
| `-S unit` | Output units |
| `-t` | Timestamp |
| `-w` | Wide output |

## Output Fields
| Field | Description |
|-------|-------------|
| r | Running processes |
| b | Blocked processes |
| swpd | Virtual memory |
| free | Idle memory |
| buff | Buffer memory |
| cache | Cache memory |
| si | Swapped in |
| so | Swapped out |
| bi | Blocks in |
| bo | Blocks out |
| in | Interrupts |
| cs | Context switches |
| us | User time |
| sy | System time |
| id | Idle time |
| wa | IO wait |
| st | Stolen time |

## Key Use Cases
1. Memory monitoring
2. System performance
3. IO analysis
4. CPU utilization
5. Process states

## Examples with Explanations
### Example 1: Basic Usage
```bash
vmstat
```
Current statistics

### Example 2: Continuous
```bash
vmstat 2 10
```
Every 2s, 10 times

### Example 3: Disk Stats
```bash
vmstat -d
```
Show disk statistics

## Common Usage Patterns
1. Real-time monitoring:
   ```bash
   vmstat 1
   ```
2. Memory details:
   ```bash
   vmstat -s
   ```
3. Disk activity:
   ```bash
   vmstat -d -p /dev/sda1
   ```

## Related Commands
- `free` - Memory usage
- `top` - Process activity
- `iostat` - IO statistics
- `sar` - System activity
- `mpstat` - CPU statistics

## Additional Resources
- [Vmstat Manual](https://man7.org/linux/man-pages/man8/vmstat.8.html)
- [Performance Guide](https://www.cyberciti.biz/faq/linux-vmstat-command-examples-tool-tutorial/)
- [System Administration](https://www.tecmint.com/linux-vmstat-command-examples/)

## Best Practices
1. Regular monitoring
2. Set intervals
3. Compare trends
4. Document baselines
5. Check all metrics

## Performance Analysis
1. Memory usage
2. CPU utilization
3. IO activity
4. Process states
5. System load

## Troubleshooting
1. High memory use
2. Swap activity
3. IO bottlenecks
4. CPU saturation
5. Process blocking

## Common Issues
1. Memory pressure
2. Swap thrashing
3. IO congestion
4. CPU contention
5. Process queuing
