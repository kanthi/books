# cp

## Overview
`cp` copies files and directories. For large trees with updates, prefer `rsync`. Mind the difference between `cp src dest` and `cp src/ dest/` semantics with directories.

## Syntax
```bash
cp [options] source dest
cp [options] source... directory
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Archive: `-dR --preserve=all` |
| `-r` / `-R` | Recursive |
| `-i` | Interactive clobber |
| `-n` | No clobber |
| `-u` | Update only when newer |
| `-v` | Verbose |
| `-l` / `-s` | Hard / symlink instead of copy |
| `-p` | Preserve mode/ownership/timestamps |
| `--reflink=auto` | CoW clone when supported |
| `-L` / `-P` | Follow / never follow symlinks |

## Safety
`cp -a` into an existing directory nests differently based on trailing slashes and whether dest exists — dry-run mentally or use `rsync -n`.

## Examples with Explanations
```bash
cp file.txt file.bak
cp -i *.conf /etc/myapp/
cp -a project/ project-backup/
cp -a src/. dest/              # copy contents into dest
cp -u -v *.o build/
cp --reflink=auto big.img big-clone.img
cp -r --preserve=timestamps logs/ logs-copy/
```

## Related Commands
- `rsync` / `install`  
- `mv`  
- `scp`  
- `tar` pipeline
