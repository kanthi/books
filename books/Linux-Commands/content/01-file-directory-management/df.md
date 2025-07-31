# df

## Overview
The `df` (disk free) command displays filesystem disk space usage information. It shows available and used space for mounted filesystems, essential for system monitoring and disk management.

## Syntax
```bash
df [options] [filesystem...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human-readable sizes (K, M, G) |
| `-H` | Human-readable with powers of 1000 |
| `-T` | Show filesystem type |
| `-i` | Show inode information |
| `-a` | Include dummy filesystems |
| `-l` | Local filesystems only |
| `-x type` | Exclude filesystem type |
| `-t type` | Include only filesystem type |
| `--total` | Display grand total |
| `--sync` | Sync before getting usage info |

## Key Use Cases
1. Check available disk space
2. Monitor filesystem usage
3. System health monitoring
4. Capacity planning
5. Troubleshoot disk full issues

## Examples with Explanations
### Example 1: Basic Usage
```bash
df -h
```
Shows disk usage in human-readable format

### Example 2: Specific Filesystem
```bash
df -h /home
```
Shows usage for filesystem containing /home

### Example 3: Show Filesystem Types
```bash
df -hT
```
Displays filesystem types along with usage

### Example 4: Inode Information
```bash
df -hi
```
Shows inode usage instead of block usage

## Understanding Output
Default columns:
- **Filesystem**: Device or filesystem name
- **1K-blocks**: Total space in 1K blocks
- **Used**: Used space
- **Available**: Available space
- **Use%**: Percentage used
- **Mounted on**: Mount point

Example output:
```
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda1        20G   15G  4.2G  79% /
/dev/sda2       100G   45G   50G  48% /home
```

## Common Usage Patterns
1. Check root filesystem:
   ```bash
   df -h /
   ```
2. Monitor all local filesystems:
   ```bash
   df -hl
   ```
3. Find full filesystems:
   ```bash
   df -h | awk '$5 > 90 {print}'
   ```

## Filesystem Types
Common filesystem types:
- **ext4**: Linux native filesystem
- **xfs**: High-performance filesystem
- **btrfs**: Advanced Linux filesystem
- **ntfs**: Windows filesystem
- **vfat**: FAT32 filesystem
- **tmpfs**: Temporary filesystem in RAM
- **nfs**: Network filesystem

## Advanced Usage
1. Exclude specific types:
   ```bash
   df -h -x tmpfs -x devtmpfs
   ```
2. Show only specific type:
   ```bash
   df -h -t ext4
   ```
3. Include totals:
   ```bash
   df -h --total
   ```

## Monitoring and Alerting
1. Check for full filesystems:
   ```bash
   df -h | awk '$5 > 95 {print "WARNING: " $6 " is " $5 " full"}'
   ```
2. Monitor specific threshold:
   ```bash
   USAGE=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
   if [ $USAGE -gt 80 ]; then
       echo "Root filesystem is ${USAGE}% full"
   fi
   ```

## Performance Analysis
- Fast operation
- Reads filesystem metadata
- Minimal system impact
- Real-time information
- Good for automated monitoring

## Related Commands
- `du` - Directory disk usage
- `lsblk` - List block devices
- `mount` - Show mounted filesystems
- `findmnt` - Find mounted filesystems
- `iostat` - I/O statistics

## Best Practices
1. Regular monitoring of disk space
2. Set up alerts for high usage
3. Use human-readable format
4. Monitor both space and inodes
5. Exclude irrelevant filesystems

## Scripting Applications
1. Disk space monitoring:
   ```bash
   #!/bin/bash
   THRESHOLD=90
   df -h | awk -v thresh=$THRESHOLD '
   NR>1 && $5+0 > thresh {
       print "WARNING: " $6 " is " $5 " full"
   }'
   ```
2. System health check:
   ```bash
   check_disk_space() {
       echo "=== Disk Space Report ==="
       df -h | grep -vE '^Filesystem|tmpfs|cdrom'
       echo ""
       echo "=== Critical Usage (>90%) ==="
       df -h | awk '$5 > 90 {print $0}'
   }
   ```

## Integration Examples
1. With cron for monitoring:
   ```bash
   # Check disk space every hour
   0 * * * * df -h | awk '$5 > 90 {print}' | mail -s "Disk Alert" admin@domain.com
   ```
2. System status dashboard:
   ```bash
   echo "System Status - $(date)"
   echo "Disk Usage:"
   df -h | grep -v tmpfs
   echo ""
   echo "Inode Usage:"
   df -hi | awk '$5 > 80 {print}'
   ```

## Inode Monitoring
1. Check inode usage:
   ```bash
   df -hi
   ```
2. Find filesystems with high inode usage:
   ```bash
   df -hi | awk '$5 > 80 {print "High inode usage: " $6 " (" $5 ")"}'
   ```
3. Monitor both space and inodes:
   ```bash
   df -h && echo "--- Inodes ---" && df -hi
   ```

## Troubleshooting
1. Filesystem shows 100% but space available
2. Inode exhaustion
3. Stale NFS mounts
4. Permission issues
5. Filesystem corruption

## Network Filesystems
1. Show only local filesystems:
   ```bash
   df -hl
   ```
2. Include network filesystems:
   ```bash
   df -h -t nfs -t cifs
   ```
3. Exclude network filesystems:
   ```bash
   df -h -x nfs -x cifs
   ```

## Output Formatting
1. Custom format:
   ```bash
   df -h | awk '{printf "%-20s %8s %8s %8s %s\n", $1, $2, $3, $4, $6}'
   ```
2. CSV format:
   ```bash
   df -h | awk 'NR>1 {printf "%s,%s,%s,%s,%s,%s\n", $1,$2,$3,$4,$5,$6}'
   ```
3. JSON format:
   ```bash
   df -h | awk 'NR>1 {printf "{\"fs\":\"%s\",\"size\":\"%s\",\"used\":\"%s\",\"avail\":\"%s\",\"use\":\"%s\",\"mount\":\"%s\"}\n", $1,$2,$3,$4,$5,$6}'
   ```

## Automation Examples
1. Cleanup trigger:
   ```bash
   #!/bin/bash
   for fs in $(df -h | awk '$5 > 85 {print $6}'); do
       echo "Filesystem $fs is getting full"
       # Trigger cleanup scripts
       cleanup_logs.sh "$fs"
   done
   ```
2. Capacity planning:
   ```bash
   df -h | awk '
   NR>1 {
       gsub(/%/, "", $5)
       if ($5 > 70) print $6 " will need attention soon (" $5 "%)"
   }'
   ```