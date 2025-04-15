# vmstat

## Overview
The `vmstat` (virtual memory statistics) command reports statistics about system processes, memory, paging, block I/O, traps, and CPU activity. It's an essential tool for system performance monitoring and troubleshooting.

## Syntax
```bash
vmstat [options] [delay [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Display active/inactive memory |
| `-f` | Display number of forks since boot |
| `-m` | Display slabinfo |
| `-n` | Display header only once |
| `-s` | Display memory statistics |
| `-d` | Display disk statistics |
| `-p partition` | Display partition statistics |
| `-S unit` | Display specific unit sizes |
| `-t` | Add timestamp to output |

## Key Use Cases
1. System performance monitoring
2. Memory usage analysis
3. CPU utilization tracking
4. I/O bottleneck identification
5. System load assessment

## Examples with Explanations
### Example 1: Basic Usage
```bash
vmstat 2 5
```
Display stats every 2 seconds, 5 times

### Example 2: Memory Statistics
```bash
vmstat -s
```
Show detailed memory statistics

### Example 3: Disk Statistics
```bash
vmstat -d
```
Display disk I/O statistics

## Understanding Output
Columns explained:
- Procs:
  - r: runnable processes
  - b: processes in uninterruptible sleep
- Memory:
  - swpd: virtual memory used
  - free: idle memory
  - buff: memory used as buffers
  - cache: memory used as cache
- Swap:
  - si: memory swapped in
  - so: memory swapped out
- IO:
  - bi: blocks received from device
  - bo: blocks sent to device
- System:
  - in: interrupts per second
  - cs: context switches per second
- CPU:
  - us: user time
  - sy: system time
  - id: idle time
  - wa: I/O wait time

## Common Usage Patterns
1. Real-time monitoring:
   ```bash
   vmstat 1
   ```
2. Check memory stats:
   ```bash
   vmstat -s | grep memory
   ```
3. Monitor swap usage:
   ```bash
   vmstat -w 2
   ```

## Performance Analysis
- First line shows averages since boot
- Subsequent lines show interval statistics
- High 'wa' indicates I/O bottleneck
- High 'r' suggests CPU contention
- Monitor swap activity (si/so)

## Related Commands
- `top` - Process activity
- `free` - Memory usage
- `iostat` - I/O statistics
- `sar` - System activity reporter
- `mpstat` - Processor statistics

## Additional Resources
- [Linux vmstat manual](https://man7.org/linux/man-pages/man8/vmstat.8.html)
- [System Performance Monitoring](https://www.tecmint.com/linux-performance-monitoring-with-vmstat/)
- [Memory Management Guide](https://www.kernel.org/doc/html/latest/admin-guide/mm/)
