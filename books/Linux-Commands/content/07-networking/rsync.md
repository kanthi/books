# rsync

## Overview
`rsync` synchronizes files and directories locally or over SSH. It transfers only differences, preserves attributes, and is the standard tool for backups and deploys.

## Syntax
```bash
rsync [options] SOURCE... DEST
```
Trailing slashes matter: `src/` copies *contents*; `src` copies the directory itself.

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Archive: `-rlptgoD` |
| `-v` | Verbose |
| `-z` | Compress during transfer |
| `-P` | `--partial --progress` |
| `-n` / `--dry-run` | Simulate |
| `-e ssh` | Remote shell |
| `--delete` | Remove dest files not in source |
| `--exclude=PAT` | Exclude |
| `-x` | One filesystem |
| `--bwlimit=RATE` | Throttle |

## Safety
`--delete` can wipe destination files. Always `-n` first. Know whether trailing `/` is intended.

## Examples with Explanations
### Local copy
```bash
rsync -aHAX --info=progress2 /src/project/ /backup/project/
```

### Dry-run remote backup
```bash
rsync -anv -e ssh /var/www/ user@server:/backups/www/
rsync -av -e ssh /var/www/ user@server:/backups/www/
```

### Mirror with delete
```bash
rsync -a --delete --exclude '.git' ./site/ user@server:/var/www/site/
```

### Resume-friendly large copy
```bash
rsync -aP large.iso user@server:/data/
```

### Pull from remote
```bash
rsync -av user@server:/var/log/app/ ./logs/
```

## Related Commands
- `scp` — simple copy, no delta  
- `tar` over `ssh` — stream trees  
- `rclone` — cloud backends  
- `cp -a` — local only
