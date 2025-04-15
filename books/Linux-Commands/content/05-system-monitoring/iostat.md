# iostat

## Overview
The `iostat` command reports CPU statistics and input/output statistics for devices and partitions. It's useful for monitoring system input/output device loading.

## Syntax
```bash
iostat [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Display CPU utilization |
| `-d` | Display device utilization |
| `-h` | Human readable sizes |
| `-k` | Display in kilobytes |
| `-m` | Display in megabytes |
| `-N` | Display registered device mapper names |
| `-p [device]` | Display statistics for block devices |
| `-t` | Print time information |
| `-x` | Display extended statistics |
| `-y` | Omit first report |
| `-z` | Omit devices with no activity |

## Key Use Cases
1. System performance monitoring
2. Disk I/O analysis
3. Bottleneck identification
4. Capacity planning
5. Performance tuning

## Examples with Explanations
### Example 1: Basic Usage
```bash
iostat
```
Show CPU and device statistics

### Example 2: Extended Stats
```bash
iostat -x 2 5
```
Show extended stats every 2 seconds, 5 times

### Example 3: Device Specific
```bash
iostat -p sda 1
```
Monitor specific device every second

## Understanding Output
CPU statistics:
- %user: User level processing
- %nice: User level with nice priority
- %system: System level processing
- %iowait: Waiting for I/O
- %steal: Time stolen by virtualization
- %idle: Idle time

Device statistics:
- tps: Transfers per second
- kB_read/s: Kilobytes read per second
- kB_wrtn/s: Kilobytes written per second
- kB_read: Total kilobytes read
- kB_wrtn: Total kilobytes written

## Common Usage Patterns
1. Continuous monitoring:
   ```bash
   iostat 2
   ```
2. Specific device analysis:
   ```bash
   iostat -xd /dev/sda
   ```
3. Human readable format:
   ```bash
   iostat -h -p ALL
   ```

## Performance Analysis
- I/O bottleneck detection
- Disk utilization patterns
- CPU usage correlation
- Read/write ratios
- Queue length analysis

## Related Commands
- `vmstat` - Virtual memory stats
- `mpstat` - CPU statistics
- `sar` - System activity reporter
- `top` - Process monitoring
- `dstat` - Versatile tool

## Additional Resources
- [Iostat Documentation](https://linux.die.net/man/1/iostat)
- [System Performance Guide](https://www.brendangregg.com/linuxperf.html)
- [I/O Monitoring Guide](https://www.tecmint.com/linux-performance-monitoring-with-iostat-and-vmstat/)

## Best Practices
1. Regular monitoring
2. Baseline establishment
3. Alert thresholds
4. Trend analysis
5. Documentation

## Troubleshooting
1. High wait times
2. Queue length issues
3. Bandwidth bottlenecks
4. Device saturation
5. CPU bottlenecks
