# rsync

## Overview
The `rsync` command is a fast and versatile file synchronization tool that efficiently transfers and synchronizes files between locations, locally or over a network.

## Syntax
```bash
rsync [options] source destination
rsync [options] source [source...] destination
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Archive mode (preserves permissions, times, etc.) |
| `-v` | Verbose output |
| `-r` | Recursive |
| `-u` | Update (skip newer files) |
| `-n` | Dry run (show what would be done) |
| `-z` | Compress during transfer |
| `-P` | Show progress and keep partial files |
| `--delete` | Delete files not in source |
| `--exclude=pattern` | Exclude files matching pattern |
| `--include=pattern` | Include files matching pattern |
| `-e ssh` | Use SSH for remote transfers |

## Archive Mode Components
The `-a` flag includes:
- `-r` (recursive)
- `-l` (copy symlinks as symlinks)
- `-p` (preserve permissions)
- `-t` (preserve modification times)
- `-g` (preserve group)
- `-o` (preserve owner)
- `-D` (preserve device files and special files)

## Key Use Cases
1. Backup files and directories
2. Synchronize directories
3. Mirror websites
4. Transfer files over network
5. Incremental backups

## Examples with Explanations
### Example 1: Basic Local Sync
```bash
rsync -av source/ destination/
```
Synchronizes source directory to destination with archive mode

### Example 2: Remote Sync via SSH
```bash
rsync -avz -e ssh local/ user@server:/remote/path/
```
Syncs local directory to remote server with compression

### Example 3: Dry Run
```bash
rsync -avn --delete source/ destination/
```
Shows what would be synchronized without making changes

## Remote Synchronization
1. Push to remote:
   ```bash
   rsync -av local/ user@host:/remote/
   ```
2. Pull from remote:
   ```bash
   rsync -av user@host:/remote/ local/
   ```
3. Between remote hosts:
   ```bash
   rsync -av host1:/path/ host2:/path/
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `--bwlimit=rate` | Limit bandwidth |
| `--timeout=seconds` | Set timeout |
| `--partial` | Keep partial files |
| `--inplace` | Update files in place |
| `--backup` | Make backups |
| `--backup-dir=dir` | Backup directory |
| `--log-file=file` | Log to file |
| `--stats` | Show transfer statistics |

## Common Usage Patterns
1. Incremental backup:
   ```bash
   rsync -av --delete /home/user/ /backup/user/
   ```
2. Exclude patterns:
   ```bash
   rsync -av --exclude='*.tmp' --exclude='cache/' source/ dest/
   ```
3. Bandwidth limited transfer:
   ```bash
   rsync -av --bwlimit=1000 large_files/ remote:/backup/
   ```

## Include/Exclude Patterns
1. Exclude temporary files:
   ```bash
   rsync -av --exclude='*.tmp' --exclude='*.log' source/ dest/
   ```
2. Include only specific types:
   ```bash
   rsync -av --include='*.txt' --exclude='*' source/ dest/
   ```
3. Complex patterns:
   ```bash
   rsync -av --exclude-from=exclude.txt source/ dest/
   ```

## Performance Analysis
- Delta-sync algorithm (only transfers differences)
- Compression reduces network usage
- Efficient for large files with small changes
- Minimal memory usage
- Good for slow connections

## Backup Strategies
1. Daily incremental:
   ```bash
   rsync -av --delete --backup --backup-dir=../backup-$(date +%Y%m%d) source/ dest/
   ```
2. Snapshot backups:
   ```bash
   rsync -av --link-dest=../previous source/ current/
   ```
3. Rotating backups:
   ```bash
   rsync -av --delete source/ backup/current/
   ```

## Related Commands
- `scp` - Secure copy
- `cp` - Copy files
- `tar` - Archive files
- `rclone` - Cloud sync
- `unison` - Bidirectional sync

## Additional Resources
- [Rsync Manual](https://rsync.samba.org/documentation.html)
- [Rsync Examples](https://www.tecmint.com/rsync-command-examples/)

## Best Practices
1. Always test with dry run first
2. Use archive mode for complete sync
3. Implement proper exclude patterns
4. Monitor transfer progress
5. Verify sync completion

## Security Considerations
1. Use SSH for remote transfers
2. Verify host keys
3. Use key-based authentication
4. Limit rsync access with restricted shells
5. Monitor transfer logs

## Troubleshooting
1. Permission denied errors
2. Network connectivity issues
3. Disk space problems
4. SSH authentication failures
5. Pattern matching issues

## Integration Examples
1. With cron for automated backups:
   ```bash
   0 2 * * * rsync -av --delete /home/ /backup/
   ```
2. With find for selective sync:
   ```bash
   find source/ -name "*.txt" -print0 | rsync -av --files-from=- --from0 source/ dest/
   ```
3. Monitoring script:
   ```bash
   rsync -av --stats source/ dest/ | tee sync.log
   ```

## Common Patterns
1. Website deployment:
   ```bash
   rsync -avz --delete local_site/ user@server:/var/www/html/
   ```
2. Database backup sync:
   ```bash
   rsync -av --compress-level=9 db_backups/ remote:/backups/db/
   ```
3. Media file sync:
   ```bash
   rsync -av --progress --partial media/ backup:/media/
   ```