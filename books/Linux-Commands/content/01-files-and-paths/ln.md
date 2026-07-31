# ln

## Overview
`ln` creates **hard links** or **symbolic links** (symlinks). Symlinks are the usual tool for path aliases; hard links share inode data on the same filesystem.

## Syntax
```bash
ln [options] target link_name
ln [options] target... directory
```

## Common Options
| Option | Description |
|--------|-------------|
| `-s` | Symbolic link |
| `-f` | Force replace |
| `-n` | Treat link_name as normal file if symlink to dir |
| `-v` | Verbose |
| `-r` | Relative symlink (GNU) |
| `-b` | Backup before overwrite |

## Examples with Explanations
### Symlinks
```bash
ln -s /usr/bin/python3 ~/bin/python
ln -s ../config/app.env .env
ln -sfr ../targets/current app   # relative, force (GNU)
ls -l
readlink -f app
```

### Hard links
```bash
ln important.dat important-hard.dat
ls -li important*.dat            # same inode
```

### Replace safely
```bash
ln -sfn /opt/app/releases/1.2 /opt/app/current
```

## Notes
- Hard links cannot cross filesystems or link directories (normally).  
- Broken symlinks show in `ls` (often red); `test -e` fails.  
- Prefer `ln -s` for version switches (`current` → release).

## Related Commands
- `readlink` / `realpath`  
- `stat`  
- `cp -a` — copy preserving links  
- `symlink` syscall docs
