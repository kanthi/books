# mv

## Overview
`mv` renames or moves files and directories — including across filesystems (copy+delete). Atomic rename applies only within the same filesystem.

## Syntax
```bash
mv [options] source dest
mv [options] source... directory
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Interactive |
| `-n` | No clobber |
| `-f` | Force |
| `-u` | Update if newer |
| `-v` | Verbose |
| `-b` | Backup dest |
| `-t dir` | Target directory first |

## Examples with Explanations
```bash
mv old.txt new.txt
mv file.txt /tmp/
mv -i *.md docs/
mv -n src dest
mv -t /backup/ *.log
```

### Atomic replace pattern
```bash
mv app.conf app.conf.bak
mv app.conf.new app.conf
```

## Notes
- Cross-device moves break hard links and may change performance.  
- Running processes keep old file content if they hold an open FD after replace.

## Related Commands
- `cp` / `rm`  
- `rename` — bulk regex rename (Perl/util-linux variants differ)  
- `rsync --remove-source-files`
