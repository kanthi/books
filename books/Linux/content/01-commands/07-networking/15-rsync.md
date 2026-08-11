# rsync

## Overview
`rsync` synchronizes files and directories locally or over a remote shell (almost always SSH). It copies only changed blocks when possible, can preserve permissions/ownership/times, and is the standard tool for backups, deploys, and large tree moves on Ubuntu servers and workstations.

Trailing slashes matter: `src/` copies the *contents* of `src` into the destination; `src` (no slash) copies the directory itself as a child of the destination.

## Syntax
```bash
rsync [OPTIONS] SOURCE... DEST
rsync [OPTIONS] SOURCE... [USER@]HOST:DEST
rsync [OPTIONS] [USER@]HOST:SOURCE DEST
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Archive mode: recursive + preserve perms, times, symlinks, devices (`-rlptgoD`) |
| `-v` | Verbose (list transferred files) |
| `-z` | Compress data in flight (helps over slow links; less useful on LAN/SSD) |
| `-P` | `--partial --progress` — keep partial files and show progress |
| `-n` / `--dry-run` | Show what would happen; transfer nothing |
| `-e ssh` | Use SSH as remote shell (often default nowadays) |
| `--delete` | Delete files on dest that are not on source (mirror) |
| `--exclude=PAT` | Skip matching paths |
| `--include=PAT` | Include pattern (order with exclude matters) |
| `-x` | Don't cross filesystem boundaries |
| `-H` | Preserve hard links |
| `-A` | Preserve ACLs |
| `-X` | Preserve extended attributes |
| `--bwlimit=RATE` | Throttle (e.g. `10m` = 10 MB/s) |
| `--info=progress2` | Overall progress bar (GNU rsync) |
| `--checksum` / `-c` | Compare by checksum, not size+mtime |
| `-u` | Skip files newer on destination |

## Safety
- **`--delete` can remove large parts of the destination.** Always run with `-n` first and read the file list.
- Confirm trailing `/` intent before a mirror. `rsync -a --delete src/ dest/` is not the same as `src dest/`.
- Remote paths use `host:path` or `host:/abs/path`. A missing colon can make rsync create a local directory named like the remote host.
- Prefer SSH keys and a dedicated deploy user; avoid running rsync as root over the network unless you need ownership preservation on system trees.

## Examples with Explanations
### Dry-run first (always for delete or production)
```bash
rsync -anv --delete \
  --exclude '.git' \
  ./site/ user@server:/var/www/site/
# review the list, then drop -n:
rsync -av --delete \
  --exclude '.git' \
  ./site/ user@server:/var/www/site/
```

### Local archive backup with progress
```bash
rsync -aHAX --info=progress2 /home/alice/ /mnt/backup/alice/
```
`-aHAX` is a solid “full metadata” local copy on Linux when ACLs/xattrs matter (e.g. home dirs, containers).

### Push project over SSH
```bash
rsync -azP -e 'ssh -p 2222' \
  ./build/ deploy@app.example.com:/srv/app/current/
```
`-z` compresses; `-P` helps on long transfers that may interrupt.

### Pull logs from a server
```bash
rsync -azP user@server:/var/log/nginx/ ./nginx-logs/
```

### Mirror with excludes
```bash
rsync -a --delete \
  --exclude 'node_modules' \
  --exclude '.cache' \
  --exclude '*.tmp' \
  ./project/ /backup/project/
```

### Throttled backup (shared link)
```bash
rsync -azP --bwlimit=5m /data/ user@offsite:/backups/data/
```

### One filesystem only (skip other mounts)
```bash
rsync -ax / /mnt/root-backup/
```
Useful when `/` has bind mounts or extra disks you do not want pulled into the backup.

### Checksum mode when clocks or touch times lie
```bash
rsync -avc ./release/ user@server:/opt/app/
```
Slower; compares content hashes instead of relying on size and mtime.

### Show only what would change (itemize)
```bash
rsync -ani --delete ./src/ ./dest/
```
`-i` itemizes reasons for each transfer (permission change, size, etc.).

## Understanding Output
With `-v`, each transferred path is printed. `--info=progress2` shows aggregate bytes and rate. Dry-run (`-n`) still lists actions but does not write. Exit status `0` means success; non-zero usually means partial failure (permissions, vanished files, network).

## Notes & Pitfalls
- **Trailing slash is the #1 footgun.** Practice with `-n` until muscle memory is solid.
- Archive mode does **not** include hard links (`-H`), ACLs (`-A`), or xattrs (`-X`) by default — add them when needed.
- `--delete` does not delete excluded files on the destination unless you also use options like `--delete-excluded` (be even more careful).
- Sparse files, open databases, and live VMs need application-consistent backups; rsync alone is not a snapshot tool.
- For very large trees, run from `tmux`/`screen` so a dropped SSH session does not kill the job; combine with `-P` to resume.

## Related Commands
- `scp` — simple one-shot copy over SSH (no delta sync)
- `sftp` — interactive SSH file transfer
- `cp -a` — local recursive copy without remote/delta features
- `tar` over `ssh` — stream archives when rsync is unavailable
- `rclone` — cloud object storage sync (if installed)

## Additional Resources
- `man rsync`
- `man rsyncd.conf` (daemon mode, less common for SSH workflows)
