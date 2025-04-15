# sar

## Overview
The `sar` (System Activity Reporter) command collects, reports, and saves system activity information. It provides historical and real-time system statistics.

## Syntax
```bash
sar [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-A` | All statistics |
| `-b` | IO transfer rates |
| `-B` | Paging statistics |
| `-c` | Process creation |
| `-d` | Block device activity |
| `-n` | Network statistics |
| `-P` | Per-processor stats |
| `-q` | Queue length |
| `-r` | Memory utilization |
| `-S` | Swap space stats |
| `-u` | CPU utilization |
| `-v` | Kernel tables |
| `-w` | Task creation |
| `-W` | Swapping stats |

## Output Types
| Type | Description |
|------|-------------|
| CPU | Processor usage |
| Memory | Memory stats |
| Swap | Swap activity |
| IO | Input/output |
| Network | Network stats |
| Process | Process stats |
| Queue | System queue |
| Disk | Disk activity |

## Key Use Cases
1. System monitoring
2. Performance analysis
3. Capacity planning
4. Trend analysis
5. Troubleshooting

## Examples with Explanations
### Example 1: CPU Usage
```bash
sar -u
```
CPU statistics

### Example 2: Memory
```bash
sar -r
```
Memory statistics

### Example 3: Network
```bash
sar -n DEV
```
Network interface stats

## Common Usage Patterns
1. Real-time monitoring:
   ```bash
   sar 1 5
   ```
2. Daily stats:
   ```bash
   sar -f /var/log/sa/sa01
   ```
3. All stats:
   ```bash
   sar -A
   ```

## Related Commands
- `vmstat` - Virtual memory
- `iostat` - IO stats
- `mpstat` - CPU stats
- `pidstat` - Process stats
- `top` - System monitor

## Additional Resources
- [Sar Manual](https://man7.org/linux/man-pages/man1/sar.1.html)
- [Performance Guide](https://www.cyberciti.biz/faq/linux-sar-command-examples-tutorial-usage/)
- [System Administration](https://www.tecmint.com/linux-sar-command-examples/)

## Best Practices
1. Regular collection
2. Data retention
3. Baseline creation
4. Trend analysis
5. Alert setup

## Performance Analysis
1. System load
2. Resource usage
3. Bottlenecks
4. Capacity issues
5. Performance trends

## Troubleshooting
1. System issues
2. Resource constraints
3. Performance problems
4. Capacity limits
5. Trend analysis

## Data Collection
1. Historical data
2. Real-time stats
3. System logs
4. Performance metrics
5. Resource usage
