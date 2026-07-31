# rm

## Overview
`rm` removes directory entries (unlinks files). By default it does **not** remove directories unless `-r` is given. There is no undelete in coreutils — recovery requires backups or filesystem tools.

## Syntax
```bash
rm [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r` / `-R` | Recursive (directories) |
| `-f` | Force; ignore missing, no prompts |
| `-i` | Prompt each |
| `-I` | Prompt once if many/recursive |
| `-v` | Verbose |
| `--one-file-system` | Do not recurse into other mounts |
| `--preserve-root` | Default: refuse `/` recursive remove |

## Safety
**Never** experiment with `rm -rf /` or unquoted globs as root. Prefer:
- `trash-cli` / file manager trash when available  
- Move to a quarantine dir first  
- `find … -print` dry-run before `-delete`  
Refuse muscle-memory `alias rm='rm -i'` as your only protection — scripts bypass aliases.

## Examples with Explanations
### Files
```bash
rm file.txt
rm -v file1 file2
```

### Interactive
```bash
rm -i *.log
```

### Directory tree
```bash
rm -r build/
rm -rf build/   # no prompt; double-check path
```

### Refuse accidental root
```bash
rm -rf / --preserve-root   # still refused; do not try variants
```

### Safer recursive pattern
```bash
# dry run
find ./tmpdir -type f -name '*.tmp' -print
# delete
find ./tmpdir -type f -name '*.tmp' -delete
```

### One filesystem
```bash
sudo rm -r --one-file-system /mnt/usb/data
```
Avoids walking into bind mounts you did not intend.

## Notes & Pitfalls
- Globs are expanded by the shell **before** `rm` runs.  
- Hidden files: `rm *` does not remove dotfiles; `rm -r dir` does remove them inside `dir`.  
- Busy files may unlink but space frees when last fd closes (`lsof` deleted files).  
- ZFS/btrfs snapshots and backups are real recovery options — not `rm` itself.  

## Related Commands
- `unlink` — single file  
- `rmdir` — empty directories only  
- `find -delete` — selective tree deletes  
- `shred` — overwrite content (not always effective on SSDs/CoW)  
- `trash-put` — soft delete if installed  

## Additional Resources
- `man rm`
