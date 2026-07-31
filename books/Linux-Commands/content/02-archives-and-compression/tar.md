# tar

## Overview
`tar` packs multiple files into one archive (and extracts them). Compression is added via flags or pipes (`gzip`, `xz`, `zstd`). GNU tar is the Linux default.

## Syntax
```bash
tar [OPTIONS] -f ARCHIVE [FILES...]
```

Mnemonic ops: **c**reate, e**x**tract, **t**list, plus compression letters.

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Create |
| `-x` | Extract |
| `-t` | List |
| `-f file` | Archive path (required in practice) |
| `-v` | Verbose |
| `-z` | gzip |
| `-J` | xz |
| `-I zstd` / `--zstd` | zstd (GNU tar 1.31+) |
| `-C dir` | Change directory |
| `-p` | Preserve permissions (extract) |
| `--exclude=PAT` | Exclude glob |
| `--strip-components=n` | Drop n path prefix levels on extract |
| `-a` | Auto-compress from archive suffix |

## Key Use Cases
1. Source/release tarballs  
2. Backup directories  
3. Move trees between hosts (with `ssh`)  
4. Inspect packages without unpacking fully  

## Safety
Extracting as root can overwrite system paths if the archive contains absolute or `../` paths. Prefer extracting as unprivileged user into a clean directory; inspect with `-t` first. Avoid piping untrusted tar to disk as root.

## Examples with Explanations
### Create gzip archive
```bash
tar -czvf project.tar.gz project/
```

### Create zstd archive
```bash
tar --zstd -cf project.tar.zst project/
# or: tar -c project | zstd -T0 -o project.tar.zst
```

### List
```bash
tar -tzf project.tar.gz | head
tar -tvf project.tar.gz | head
```

### Extract
```bash
tar -xzf project.tar.gz
tar -xzf project.tar.gz -C /tmp/unpack
```

### Strip top-level directory
```bash
tar -xzf project.tar.gz --strip-components=1 -C /opt/app
```

### Exclude patterns
```bash
tar -czf src.tar.gz --exclude='.git' --exclude='node_modules' .
```

### Stream over ssh
```bash
tar -C /var/www -czf - site | ssh backup 'cat > /backups/site.tgz'
ssh backup 'cat /backups/site.tgz' | tar -C /restore -xzf -
```

### Append is special
GNU tar can update some archives, but **prefer rebuilding** compressed archives rather than `--append`.

## Common Usage Patterns
### Quick directory move
```bash
tar -C /src -cf - mydir | tar -C /dst -xf -
```

## Notes & Pitfalls
- Order of options is flexible with GNU tar but put `-f` next to the filename.  
- Binary integrity: pair with `sha256sum` for releases.  
- Sparse files: `--sparse` when needed.  

## Related Commands
- `gzip` / `xz` / `zstd` — compressors  
- `zip` / `unzip` — PKZip format  
- `rsync` — sync without full archive  
- `cpio` / `pax` — alternate archivers  

## Additional Resources
- `man tar`
