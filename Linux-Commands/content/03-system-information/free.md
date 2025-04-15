# free

## Overview
The `free` command displays the total amount of free and used physical and swap memory in the system, as well as the buffers and caches used by the kernel.

## Syntax
```bash
free [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-b` | Show output in bytes |
| `-k` | Show output in kilobytes |
| `-m` | Show output in megabytes |
| `-g` | Show output in gigabytes |
| `-h` | Human readable output |
| `-s N` | Update every N seconds |
| `-t` | Show total line |
| `-w` | Wide output |
| `--si` | Use powers of 1000 not 1024 |

## Key Use Cases
1. Monitor system memory usage
2. Check available memory
3. Monitor swap usage
4. System performance analysis
5. Memory leak detection

## Examples with Explanations
### Example 1: Human Readable Output
```bash
free -h
```
Shows memory usage in human readable format

### Example 2: Continuous Monitoring
```bash
free -s 5
```
Updates memory statistics every 5 seconds

### Example 3: Total Memory Usage
```bash
free -t
```
Shows total memory usage including swap

## Understanding Output
Columns explained:
- total: Total installed memory
- used: Used memory
- free: Unused memory
- shared: Memory shared by multiple processes
- buff/cache: Memory used by buffers and cache
- available: Memory available for new applications

## Common Usage Patterns
1. Check memory status:
   ```bash
   free -h
   ```
2. Monitor memory changes:
   ```bash
   free -hs 1
   ```
3. Get detailed view:
   ```bash
   free -wt
   ```

## Performance Analysis
- Monitor available memory
- Watch swap usage
- Check buffer/cache usage
- Consider total vs available
- Monitor trends over time

## Related Commands
- `top` - Process viewer
- `vmstat` - Virtual memory stats
- `ps` - Process status
- `swapon` - Swap usage info
- `cat /proc/meminfo` - Detailed memory info

## Additional Resources
- [Linux free manual](https://man7.org/linux/man-pages/man1/free.1.html)
- [Memory Management Guide](https://www.kernel.org/doc/html/latest/admin-guide/mm/)
- [System Monitoring Tools](https://www.tecmint.com/linux-memory-management/)
