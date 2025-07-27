# free

## Overview
The `free` command displays the amount of free and used memory in the system. It shows information about both physical and swap memory.

## Syntax
```bash
free [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Bytes |
| `-k` | Kilobytes |
| `-m` | Megabytes |
| `-g` | Gigabytes |
| `-h` | Human readable |
| `-w` | Wide output |
| `-s N` | Repeat every N sec |
| `-c N` | Repeat N times |
| `-t` | Show total |
| `-l` | Show low/high |

## Output Fields
| Field | Description |
|-------|-------------|
| total | Total memory |
| used | Used memory |
| free | Unused memory |
| shared | Shared memory |
| buff/cache | Buffer/cache |
| available | Available memory |

## Key Use Cases
1. Memory monitoring
2. System resources
3. Performance analysis
4. Capacity planning
5. Troubleshooting

## Examples with Explanations
### Example 1: Basic Usage
```bash
free
```
Show memory info

### Example 2: Human Readable
```bash
free -h
```
Easy to read format

### Example 3: Continuous
```bash
free -s 5
```
Update every 5 seconds

## Common Usage Patterns
1. Quick check:
   ```bash
   free -h
   ```
2. Monitor changes:
   ```bash
   free -s 1 -c 10
   ```
3. Total memory:
   ```bash
   free -t
   ```

## Memory Types
1. Physical memory
2. Swap memory
3. Buffer memory
4. Cache memory
5. Shared memory

## Related Commands
- `vmstat` - Virtual memory
- `top` - System monitor
- `ps` - Process status
- `swapon` - Swap info
- `meminfo` - Memory info

## Additional Resources
- [Free Manual](https://man7.org/linux/man-pages/man1/free.1.html)
- [Memory Guide](https://www.cyberciti.biz/faq/linux-free-command-memory-usage/)
- [System Administration](https://www.tecmint.com/linux-free-command-examples/)

## Best Practices
1. Regular checks
2. Use human readable
3. Monitor trends
4. Check available
5. Document usage

## Performance Analysis
1. Memory usage
2. Swap usage
3. Buffer usage
4. Cache usage
5. Available memory

## Troubleshooting
1. Low memory
2. High swap
3. Cache usage
4. Memory leaks
5. System performance

## Common Issues
1. Memory pressure
2. Swap thrashing
3. Cache problems
4. Memory fragmentation
5. Resource exhaustion
