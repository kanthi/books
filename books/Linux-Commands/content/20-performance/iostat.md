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
| `-c` | CPU utilization |
| `-d` | Device utilization |
| `-h` | Human readable |
| `-k` | In kilobytes |
| `-m` | In megabytes |
| `-N` | Device mapper names |
| `-p` | Partition stats |
| `-t` | Print time |
| `-x` | Extended stats |
| `-y` | Since boot |
| `-z` | Omit idle |

## Output Fields
| Field | Description |
|-------|-------------|
| tps | Transfers per second |
| kB_read/s | Kilobytes read per second |
| kB_wrtn/s | Kilobytes written per second |
| kB_read | Total kilobytes read |
| kB_wrtn | Total kilobytes written |
| await | Average wait time |
| svctm | Service time |
| %util | Utilization |

## Key Use Cases
1. IO monitoring
2. Disk performance
3. System analysis
4. Capacity planning
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
iostat
```
Basic statistics

### Example 2: Extended Stats
```bash
iostat -x
```
Detailed information

### Example 3: Continuous
```bash
iostat 2 10
```
Every 2s, 10 times

## Common Usage Patterns
1. Device monitoring:
   ```bash
   iostat -d
   ```
2. Extended info:
   ```bash
   iostat -xz
   ```
3. Specific device:
   ```bash
   iostat -p sda
   ```

## Performance Metrics
1. Throughput
2. Response time
3. Queue length
4. Utilization
5. Service time

## Related Commands
- `vmstat` - Virtual memory
- `mpstat` - CPU stats
- `sar` - System activity
- `top` - System monitor
- `dstat` - System stats

## Additional Resources
- [Iostat Manual](https://man7.org/linux/man-pages/man1/iostat.1.html)
- [IO Guide](https://www.cyberciti.biz/faq/linux-iostat-command-examples-tutorial-usage/)
- [System Administration](https://www.tecmint.com/linux-iostat-command-examples/)

## Best Practices
1. Regular monitoring
2. Check trends
3. Use intervals
4. Document baselines
5. Compare devices

## Performance Analysis
1. IO patterns
2. Device load
3. Queue depth
4. Response times
5. Bandwidth usage

## Troubleshooting
1. IO bottlenecks
2. Device saturation
3. Queue buildup
4. High latency
5. Low throughput

## Common Issues
1. Disk contention
2. Queue saturation
3. High wait times
4. Device overload
5. Poor performance
