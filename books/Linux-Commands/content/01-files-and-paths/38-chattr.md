# chattr / lsattr

## Overview

`chattr` sets **ext** file attributes (immutable, append-only, no-dump, etc.); `lsattr` lists them. These are separate from mode bits (`chmod`) and ACLs (`setfacl`). Classic operator uses: make a file immutable against accidental deletion, mark logs append-only, or exclude paths from `dump`. Attributes are filesystem-specific — full support is strongest on **ext2/3/4**; other FS may ignore or partially support flags.

## Syntax

```bash
lsattr [options] [file...]
chattr [options] mode file...
```

`mode` is `+-=` followed by attribute letters, e.g. `+i`, `-a`, `=i`.

## Common Options

### lsattr

| Option | Description |
|--------|-------------|
| `-a` | Include dotfiles |
| `-d` | List directories themselves, not contents |
| `-R` | Recursive |
| `-v` | Version/generation if available |
| `-l` | Long option names for flags (newer e2fsprogs) |

### chattr

| Option | Description |
|--------|-------------|
| `+X` / `-X` / `=X` | Add / remove / set exactly attribute `X` |
| `-R` | Recursive |
| `-V` | Verbose |
| `-f` | Suppress most errors |
| `-v version` | Set file version/generation |

### Important attribute letters

| Flag | Meaning (typical) |
|------|-------------------|
| `i` | **Immutable** — cannot modify, delete, rename, link (root must clear first) |
| `a` | **Append-only** — open only in append mode for writes |
| `A` | No atime updates |
| `c` | Compressed (FS-dependent; often no-op on plain ext4) |
| `d` | No dump |
| `e` | Extent format (usually set by FS; don’t clear casually) |
| `j` | Data journaling (ext3/4 specifics) |
| `s` | Secure deletion (often not honored as expected) |
| `S` | Synchronous updates |
| `u` | Undeletable (legacy; rarely useful) |

Most operators only need **`i`** and **`a`**.

## Safety

- **`chattr +i`** as root can lock out application writes until you remember to `-i` — document it.
- Recursive `+i` on a tree can break package upgrades and log rotation.
- Attributes are **not a substitute for backups or proper permissions**.
- On non-ext filesystems, commands may succeed partially or reject flags — verify with `lsattr` and test writes.
- Immutable system files can block `apt`/`dpkg` — clear before upgrades.

## Examples with Explanations

### List attributes

```bash
lsattr file.txt
lsattr -d /etc/hostname
lsattr -R /var/log/myapp 2>/dev/null | head
```

A line like `----i---------e------- file` means immutable (`i`) plus extent (`e`).

### Make a file immutable

```bash
sudo chattr +i /etc/myapp/critical.conf
lsattr /etc/myapp/critical.conf
# even root cannot overwrite until:
sudo chattr -i /etc/myapp/critical.conf
```

Useful against accidental `rm`/overwrite; not a strong security boundary against a malicious root.

### Append-only log

```bash
sudo chattr +a /var/log/myapp/audit.log
# app can append; cannot truncate/overwrite in place
# to rotate: clear a, rotate, restore a
sudo chattr -a /var/log/myapp/audit.log
```

Coordinate with logrotate (`endscript` hooks) if you use `+a`.

### Clear / set exactly

```bash
sudo chattr -i -a file
sudo chattr = file          # clear all settable attrs (careful)
```

### Protect a directory entry (directory itself)

```bash
sudo chattr +i /important-dir
# prevents adding/removing entries in some cases; know the semantics before using
sudo chattr -i /important-dir
```

Test on non-production paths — immutable directories surprise people.

### No-dump flag

```bash
sudo chattr +d /var/cache/bulk
lsattr -d /var/cache/bulk
```

Hints to `dump(8)` to skip; modern backup tools may ignore this flag unless coded for it.

### Combine with permissions

```bash
sudo chown root:root /etc/myapp/critical.conf
sudo chmod 644 /etc/myapp/critical.conf
sudo chattr +i /etc/myapp/critical.conf
```

Mode bits control who can read; `i` resists modification/deletion.

## Notes

- Requires appropriate privileges (usually root) for security-sensitive flags like `i` and `a`.
- `e` (extents) is normal on modern ext4 files — don’t treat it as a problem.
- XFS has `chattr`/`lsattr` compatibility for some flags but also its own `xfs_io`/`xfs_admin` tooling.
- Backups: confirm your backup agent preserves attributes if you rely on them after restore.
- Containers: attributes on bind-mounted host ext volumes work; the container root may still need CAP_LINUX_IMMUTABLE-related capabilities for `+i`.

## Related Commands

- `chmod` / `chown` — mode and ownership
- `getfacl` / `setfacl` — ACLs
- `ls -l` — basic metadata
- `stat` — inode details
- `chattr` man page attribute list for full alphabet

## Additional Resources

- `man chattr`, `man lsattr`
- `man 1 chattr` attribute table
