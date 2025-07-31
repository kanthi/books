# du

## Overview
The `du` (disk usage) command displays the amount of disk space used by files and directories. It's essential for disk space management and finding large files or directories.

## Syntax
```bash
du [options] [file/directory...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human-readable sizes (K, M, G) |
| `-s` | Summary only (total for each argument) |
| `-a` | Show all files, not just directories |
| `-c` | Display grand total |
| `-d depth` | Maximum depth to display |
| `-x` | Stay on same filesystem |
| `-L` | Follow symbolic links |
| `-P` | Don't follow symbolic links |
| `-0` | End lines with null character |
| `--max-depth=n` | Limit directory depth |
| `--exclude=pattern` | Exclude files matching pattern |
| `--time` | Show modification time |

## Key Use Cases
1. Find disk space usage
2. Identify large directories
3. Disk cleanup planning
4. Storage analysis
5. System monitoring

## Examples with Explanations
### Example 1: Current Directory Usage
```bash
du -h
```
Shows disk usage of current directory and subdirectories

### Example 2: Summary Only
```bash
du -sh *
```
Shows total size of each item in current directory

### Example 3: Specific Directory
```bash
du -h /var/log
```
Shows disk usage of /var/log directory

### Example 4: Top-level Summary
```bash
du -h --max-depth=1 /home
```
Shows usage of immediate subdirectories only

## Finding Large Files/Directories
1. Largest directories:
   ```bash
   du -h | sort -hr | head -10
   ```
2. Largest files and directories:
   ```bash
   du -ah | sort -hr | head -20
   ```
3. Directories over 1GB:
   ```bash
   du -h | awk '$1 ~ /G/ {print}'
   ```

## Common Usage Patterns
1. Quick size check:
   ```bash
   du -sh directory_name
   ```
2. Find space hogs:
   ```bash
   du -h --max-depth=2 / | sort -hr | head -20
   ```
3. Exclude certain files:
   ```bash
   du -h --exclude="*.log" /var
   ```

## Advanced Usage
1. Show modification times:
   ```bash
   du -h --time /home/user
   ```
2. Stay on filesystem:
   ```bash
   du -hx /
   ```
3. Include all files:
   ```bash
   du -ah /etc | head -20
   ```

## Performance Analysis
- Can be slow on large filesystems
- I/O intensive operation
- Memory usage is minimal
- Use --max-depth to limit scope
- Consider excluding network mounts

## Related Commands
- `df` - Filesystem disk space usage
- `ls -la` - File sizes
- `find` - Find files by size
- `ncdu` - Interactive disk usage
- `tree` - Directory tree with sizes

## Best Practices
1. Use human-readable format (-h)
2. Limit depth for large directories
3. Exclude temporary files when needed
4. Use summary mode for quick checks
5. Combine with sort for analysis

## Disk Cleanup Strategies
1. Find old large files:
   ```bash
   find /home -size +100M -mtime +30 -exec du -h {} \;
   ```
2. Analyze log directories:
   ```bash
   du -h /var/log/* | sort -hr
   ```
3. Check user directories:
   ```bash
   du -sh /home/* | sort -hr
   ```

## Scripting Applications
1. Disk usage monitoring:
   ```bash
   #!/bin/bash
   THRESHOLD=80
   USAGE=$(du -s /home | awk '{print $1}')
   TOTAL=$(df /home | awk 'NR==2 {print $2}')
   PERCENT=$((USAGE * 100 / TOTAL))

   if [ $PERCENT -gt $THRESHOLD ]; then
       echo "Disk usage warning: ${PERCENT}%"
   fi
   ```
2. Cleanup automation:
   ```bash
   cleanup_large_files() {
       du -ah /tmp | awk '$1 ~ /[0-9]+G/ {print $2}' | \
       while read file; do
           echo "Large file found: $file"
           # Add cleanup logic
       done
   }
   ```

## Integration Examples
1. With find for targeted analysis:
   ```bash
   find /var -name "*.log" -exec du -h {} \; | sort -hr
   ```
2. System health check:
   ```bash
   echo "Top 10 largest directories:"
   du -h --max-depth=2 / 2>/dev/null | sort -hr | head -10
   ```
3. User quota monitoring:
   ```bash
   for user in $(ls /home); do
       echo "$user: $(du -sh /home/$user 2>/dev/null | cut -f1)"
   done
   ```

## Output Formatting
1. Custom format with awk:
   ```bash
   du -h | awk '{printf "%-10s %s\n", $1, $2}'
   ```
2. CSV output:
   ```bash
   du -sb * | awk '{printf "%s,%s\n", $1, $2}'
   ```
3. JSON-like format:
   ```bash
   du -sh * | awk '{printf "{\"size\":\"%s\",\"path\":\"%s\"}\n", $1, $2}'
   ```

## Troubleshooting
1. Permission denied errors
2. Slow performance on large directories
3. Network filesystem timeouts
4. Symbolic link loops
5. Filesystem crossing issues

## Security Considerations
1. May reveal directory structure
2. Can be resource intensive
3. Consider access permissions
4. Monitor for unusual disk usage
5. Protect sensitive directory information