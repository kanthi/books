# fsck

## Overview
The `fsck` (File System Check) command checks and optionally repairs Linux filesystems. It's a front-end for filesystem-specific checkers (fsck.fstype).

## Syntax
```bash
fsck [options] [-t type] [filesystem...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-A` | Check all filesystems |
| `-C` | Display progress bar |
| `-f` | Force check |
| `-M` | Skip mounted |
| `-N` | Don't execute |
| `-P` | Parallel check |
| `-R` | Skip root filesystem |
| `-T` | Don't show title |
| `-V` | Verbose |
| `-y` | Assume yes |

## Exit Codes
| Code | Description |
|------|-------------|
| 0 | No errors |
| 1 | Filesystem fixed |
| 2 | System should be rebooted |
| 4 | Filesystem errors left |
| 8 | Operational error |
| 16 | Usage or syntax error |
| 32 | Fsck canceled |
| 128 | Shared library error |

## Key Use Cases
1. Filesystem repair
2. Error checking
3. System maintenance
4. Recovery operations
5. Boot problems

## Examples with Explanations
### Example 1: Basic Check
```bash
fsck /dev/sdb1
```
Check specific device

### Example 2: Force Check
```bash
fsck -f /dev/sdc1
```
Force check even if clean

### Example 3: Auto-repair
```bash
fsck -y /dev/sdd1
```
Automatically fix errors

## Common Usage Patterns
1. Check all:
   ```bash
   fsck -A -V
   ```
2. Dry run:
   ```bash
   fsck -N /dev/sdb1
   ```
3. Progress bar:
   ```bash
   fsck -C /dev/sdc1
   ```

## Security Considerations
1. Root access
2. Data integrity
3. System stability
4. Backup importance
5. Mount status

## Related Commands
- `e2fsck` - ext2/3/4 check
- `xfs_repair` - XFS check
- `btrfs check` - Btrfs check
- `mount` - Mount filesystem
- `tune2fs` - Adjust parameters

## Additional Resources
- [Fsck Manual](https://man7.org/linux/man-pages/man8/fsck.8.html)
- [Filesystem Guide](https://www.cyberciti.biz/faq/linux-check-disk-for-errors-with-fsck-command/)
- [System Administration](https://www.tecmint.com/fsck-repair-file-system-errors-in-linux/)

## Best Practices
1. Regular checks
2. Unmount first
3. Backup data
4. Document errors
5. Monitor logs

## Error Types
1. Inode errors
2. Block errors
3. Directory errors
4. Superblock issues
5. Journal problems

## Troubleshooting
1. Boot issues
2. Mount failures
3. Data corruption
4. Performance problems
5. System crashes
