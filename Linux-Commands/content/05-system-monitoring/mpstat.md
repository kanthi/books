# mpstat

## Overview
The `mpstat` command reports processor-related statistics. It displays CPU utilization for each available processor and overall averages.

## Syntax
```bash
mpstat [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-A` | Report all CPU statistics |
| `-I` | Report interrupts statistics |
| `-P {cpu|ALL}` | Processor to monitor |
| `-u` | CPU utilization |
| `-V` | Version information |
| `-n` | Report summary in JSON format |
| `--dec=N` | Number of decimal places |

## Key Use Cases
1. CPU performance monitoring
2. Load balancing analysis
3. System troubleshooting
4. Performance tuning
5. Capacity planning

## Examples with Explanations
### Example 1: Basic Usage
```bash
mpstat
```
Show CPU statistics

### Example 2: All CPUs
```bash
mpstat -P ALL 2 5
```
Show all CPU stats every 2 seconds, 5 times

### Example 3: Specific CPU
```bash
mpstat -P 0
```
Show statistics for CPU 0

## Understanding Output
Fields explained:
- %usr: User level processing
- %nice: User level with nice priority
- %sys: System level processing
- %iowait: Waiting for I/O
- %irq: Hardware interrupts
- %soft: Software interrupts
- %steal: Time stolen by virtualization
- %guest: Time spent running virtual CPU
- %idle: Idle time

## Common Usage Patterns
1. Continuous monitoring:
   ```bash
   mpstat 1
   ```
2. CPU-specific analysis:
   ```bash
   mpstat -P 1 2
   ```
3. JSON output:
   ```bash
   mpstat -n -P ALL
   ```

## Performance Analysis
- Per-processor utilization
- Interrupt handling
- I/O wait impact
- Virtualization overhead
- Load distribution

## Related Commands
- `vmstat` - Virtual memory stats
- `iostat` - I/O statistics
- `sar` - System activity reporter
- `top` - Process monitoring
- `nmon` - Performance monitor

## Additional Resources
- [Mpstat Documentation](https://man7.org/linux/man-pages/man1/mpstat.1.html)
- [CPU Performance Guide](https://www.brendangregg.com/linuxperf.html)
- [System Monitoring](https://www.tecmint.com/linux-cpu-monitoring/)

## Best Practices
1. Regular monitoring
2. Baseline establishment
3. Load balancing checks
4. Interrupt distribution
5. Performance correlation

## Troubleshooting
1. High CPU usage
2. Interrupt storms
3. I/O bottlenecks
4. Load imbalances
5. Virtualization issues
