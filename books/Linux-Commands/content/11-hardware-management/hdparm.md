# hdparm

## Overview
The `hdparm` command gets and sets SATA/IDE device parameters. It's used to tune and configure hard disk parameters for optimal performance.

## Syntax
```bash
hdparm [options] [device]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Display drive identification |
| `-I` | Detailed drive info |
| `-t` | Perform device read timing |
| `-T` | Perform cache read timing |
| `-d` | Get/set using_dma flag |
| `-a` | Get/set fs readahead |
| `-A` | Get/set drive lookahead |
| `-W` | Get/set drive write-caching |
| `-S` | Set standby timeout |
| `-y` | Put drive in standby |
| `-Y` | Put drive to sleep |
| `-C` | Check power mode |
| `-B` | Get/set Advanced Power Management |

## Key Use Cases
1. Drive performance
2. Power management
3. Drive configuration
4. Performance testing
5. Troubleshooting

## Examples with Explanations
### Example 1: Drive Info
```bash
hdparm -I /dev/sda
```
Show detailed drive information

### Example 2: Performance Test
```bash
hdparm -tT /dev/sda
```
Test drive reading speed

### Example 3: Power Mode
```bash
hdparm -C /dev/sda
```
Check drive power mode

## Common Usage Patterns
1. Enable DMA:
   ```bash
   hdparm -d1 /dev/sda
   ```
2. Set standby:
   ```bash
   hdparm -S 120 /dev/sda
   ```
3. Write cache:
   ```bash
   hdparm -W1 /dev/sda
   ```

## Security Considerations
1. Root access required
2. Data integrity
3. System stability
4. Power management
5. Performance impact

## Related Commands
- `smartctl` - SMART monitoring
- `fdisk` - Partition table
- `parted` - Partition manager
- `dd` - Disk operations
- `iostat` - I/O statistics

## Additional Resources
- [Hdparm Manual](https://man7.org/linux/man-pages/man8/hdparm.8.html)
- [Disk Performance Guide](https://www.cyberciti.biz/tips/linux-disk-performance-monitoring-howto.html)
- [Storage Management](https://www.tecmint.com/monitor-hard-disk-health-in-linux/)

## Best Practices
1. Backup before changes
2. Test settings
3. Document changes
4. Monitor performance
5. Regular maintenance

## Performance Tuning
1. DMA settings
2. Read-ahead
3. Write caching
4. Power management
5. Access patterns

## Troubleshooting
1. Performance issues
2. Power problems
3. Configuration errors
4. Compatibility
5. Data corruption
