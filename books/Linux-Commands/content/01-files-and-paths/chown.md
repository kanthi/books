# chown

## Overview
`chown` changes file **owner** and/or **group**. Often paired with `chmod` when fixing service data directories.

## Syntax
```bash
chown [options] owner[:group] file...
chown [options] :group file...
chown [options] --reference=rfile file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-R` | Recursive |
| `-h` | Affect symlink itself, not target |
| `-v` / `-c` | Verbose / only when changed |
| `--from=o:g` | Only if current owner matches |
| `--preserve-root` | Do not recurse on `/` |

## Safety
Recursive chown on `/` or large trees can break a system. Prefer narrow paths. Preserve root with `--preserve-root` (default for recursive in modern coreutils).

## Examples with Explanations
### Owner and group
```bash
sudo chown alice file.txt
sudo chown alice:developers project/
sudo chown :developers file.txt      # group only
sudo chown -R www-data:www-data /var/www/app
```

### Numeric IDs
```bash
sudo chown 1000:1000 file.txt
```

### Only if currently root-owned
```bash
sudo chown --from=root:root alice:alice file.txt
```

### Reference
```bash
sudo chown --reference=good.txt bad.txt
```

### Symlinks
```bash
sudo chown -h alice linkname
```

## Notes
- Names resolve via NSS (`getent passwd`); IDs work offline.  
- Sticky/setuid bits interact with ownership — know your security model.  
- ACLs (`setfacl`) may still grant access beyond owner/group/other.

## Related Commands
- `chmod` — mode bits  
- `chgrp` — group only  
- `id` / `getent` — resolve users  
- `install -o -g` — copy with owner  
- `ls -l` / `stat` — inspect
