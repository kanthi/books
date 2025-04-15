# sar

## Overview
The `sar` (System Activity Reporter) command collects, reports, and saves system activity information. It provides comprehensive system performance monitoring capabilities.

## Syntax
```bash
sar [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | I/O and transfer rate statistics |
| `-B` | Paging statistics |
| `-d` | Block device activity |
| `-n` | Network statistics |
| `-P` | Per-processor statistics |
| `-r` | Memory utilization |
| `-S` | Swap space utilization |
| `-u` | CPU utilization |
| `-v` | Process, inode, file tables |
| `-w` | System switching activity |
| `-A` | All statistics |
| `-f file` | Extract records from file |
| `-o file` | Save records to file |

## Key Use Cases
1. Performance monitoring
2. System analysis
3. Resource tracking
4. Capacity planning
5. Troubleshooting

## Examples with Explanations
### Example 1: CPU Usage
```bash
sar -u 2 5
```
Show CPU stats every 2 seconds, 5 times

### Example 2: Memory Stats
```bash
sar -r
```
Show memory utilization

### Example 3: Network Stats
```bash
sar -n DEV
```
Show network interface statistics

## Understanding Output
CPU statistics:
- %user: User time
- %nice: Nice time
- %system: System time
- %iowait: I/O wait time
- %steal: Time stolen by virtualization
- %idle: Idle time

Memory statistics:
- kbmemfree: Free memory
- kbmemused: Used memory
- %memused: Memory used percentage
- kbbuffers: Memory used as buffers
- kbcached: Memory used as cache

## Common Usage Patterns
1. Daily monitoring:
   ```bash
   sar -A > report.txt
   ```
2. Network analysis:
   ```bash
   sar -n ALL 1
   ```
3. Historical data:
   ```bash
   sar -f /var/log/sa/sa01
   ```

## Performance Analysis
- System resource usage
- Performance bottlenecks
- Resource trends
- Capacity issues
- Historical patterns

## Related Commands
- `iostat` - I/O statistics
- `vmstat` - Virtual memory stats
- `mpstat` - CPU statistics
- `netstat` - Network statistics
- `top` - Process monitoring

## Additional Resources
- [Sar Documentation](https://man7.org/linux/man-pages/man1/sar.1.html)
- [System Performance Guide](https://www.brendangregg.com/linuxperf.html)
- [Performance Monitoring](https://www.tecmint.com/linux-performance-monitoring-with-sar/)

## Best Practices
1. Regular data collection
2. Historical analysis
3. Trend monitoring
4. Alert thresholds
5. Documentation

## Data Collection
1. Automated collection
2. Data retention
3. Report generation
4. Analysis tools
5. Storage management
