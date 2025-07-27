# mpstat

## Overview
The `mpstat` command reports processors related statistics. It shows CPU utilization for all CPUs or specific ones.

## Syntax
```bash
mpstat [options] [interval [count]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-A` | All CPU info |
| `-P ALL` | All processors |
| `-P list` | CPU list |
| `-u` | CPU utilization |
| `-I` | Interrupts info |
| `-n` | Header once |
| `-T` | Temperature |
| `-V` | Version info |
| `-o JSON` | JSON output |
| `-N` | Node stats |

## Output Fields
| Field | Description |
|-------|-------------|
| CPU | Processor number |
| %usr | User time |
| %nice | Nice time |
| %sys | System time |
| %iowait | IO wait time |
| %irq | Hardware interrupt |
| %soft | Software interrupt |
| %steal | Hypervisor time |
| %guest | Virtual CPU time |
| %idle | Idle time |

## Key Use Cases
1. CPU monitoring
2. Performance analysis
3. Load balancing
4. System tuning
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
mpstat
```
All CPU average

### Example 2: Per CPU
```bash
mpstat -P ALL
```
All processors stats

### Example 3: Interval
```bash
mpstat 2 5
```
Every 2s, 5 times

## Common Usage Patterns
1. All CPUs:
   ```bash
   mpstat -P ALL 1
   ```
2. Specific CPU:
   ```bash
   mpstat -P 0
   ```
3. With interrupts:
   ```bash
   mpstat -I ALL
   ```

## Performance Metrics
1. CPU usage
2. System load
3. Interrupt rates
4. IO wait
5. Idle time

## Related Commands
- `vmstat` - Virtual memory
- `iostat` - IO stats
- `sar` - System activity
- `top` - System monitor
- `pidstat` - Process stats

## Additional Resources
- [Mpstat Manual](https://man7.org/linux/man-pages/man1/mpstat.1.html)
- [CPU Guide](https://www.cyberciti.biz/faq/linux-mpstat-command-examples-tutorial-usage/)
- [System Administration](https://www.tecmint.com/linux-mpstat-command-examples/)

## Best Practices
1. Regular monitoring
2. Check all CPUs
3. Track trends
4. Document baselines
5. Compare cores

## Performance Analysis
1. CPU utilization
2. Load distribution
3. Interrupt handling
4. System overhead
5. Process impact

## Troubleshooting
1. High CPU usage
2. Load imbalance
3. Interrupt storms
4. System overhead
5. Process issues

## Common Issues
1. CPU saturation
2. Uneven loads
3. High interrupts
4. System time
5. Poor scaling
