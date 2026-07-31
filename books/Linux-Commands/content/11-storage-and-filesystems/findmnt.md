# findmnt

## Overview
`findmnt` lists or searches mounted filesystems in table or tree form. Clearer than parsing `mount` output and convenient in scripts (`-J`, `-n`, `-o`).

## Syntax
```bash
findmnt [options] [device|mountpoint]
```

## Common Options
| Option | Description |
|--------|-------------|
| (none) | Tree of mounts |
| `-t types` | Filter FS types |
| `-S source` | Match source device |
| `-T path` | Filesystem containing path |
| `-D` | df-like size columns |
| `-o list` | Columns |
| `-n` | No header |
| `-r` | Raw |
| `-J` | JSON |
| `-f` | First only |
| `--verify` | Check fstab (newer) |

## Examples with Explanations
```bash
findmnt
findmnt -D
findmnt -t ext4,xfs,nfs
findmnt -T /var/log
findmnt /
findmnt -S /dev/sdb1
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS /mnt/data
findmnt -J | jq -r '.filesystems[].target'
findmnt --verify
```

### Busy mount debugging
```bash
findmnt /mnt/data
sudo lsof +f -- /mnt/data | head
```

## Related Commands
- `mount` / `umount`  
- `lsblk -f` / `df -h`  
- `blkid`
