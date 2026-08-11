# findmnt

## Overview

`findmnt` lists or searches mounted filesystems in tree or table form. It is clearer than parsing `mount` output and friendlier for scripts (`-J`, `-n`, `-o`, `-r`). First tool for “what is mounted where?”, fstab verification, and busy-mount debugging before `umount`.

## Syntax

```bash
findmnt [options] [device|mountpoint]
```

## Common Options

| Option | Description |
|--------|-------------|
| (none) | Tree of all mounts |
| `-t types` | Filter by FS types (`ext4,xfs,nfs`) |
| `-S source` | Match source device/path |
| `-T path` | Filesystem that contains this path |
| `-D` | df-like size columns |
| `-o list` | Select columns |
| `-n` | No header |
| `-r` | Raw (no tree art) |
| `-J` | JSON |
| `-f` | First match only |
| `-R` | Sub-tree of a mountpoint |
| `--verify` | Check `/etc/fstab` against reality (util-linux) |
| `-A` / `-l` | All / list format |

Useful columns: `TARGET,SOURCE,FSTYPE,OPTIONS,UUID,LABEL,SIZE,USE%`.

## Key Use Cases

1. Human-readable mount inventory (better than raw `mount`)
2. Which mount owns a path (`-T`)
3. df-like capacity with mount context (`-D`)
4. Scripted JSON/table for monitoring
5. Verify fstab before reboot (`--verify`)

## Examples with Explanations

### Full tree

```bash
findmnt
findmnt -t ext4,xfs,btrfs,nfs
```

Tree shows mount hierarchy (binds and API filesystems included). Filter types to cut tmpfs/proc noise when scanning “real” disks.

### df-like sizes

```bash
findmnt -D
findmnt -D -t ext4,xfs
```

Combines mount table with used/available — often nicer than juggling `df` + `mount`.

### What holds this path?

```bash
findmnt -T /var/log
findmnt -T .
findmnt -T /var/lib/docker
```

Critical with bind mounts and nested volumes: `df /var/lib/docker` can surprise you; `-T` shows the owning mount.

### By source or target

```bash
findmnt /
findmnt -S /dev/sdb1
findmnt /mnt/data
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS /mnt/data
```

### Script-friendly

```bash
findmnt -n -o SOURCE /
findmnt -nro TARGET,FSTYPE
findmnt -J | jq -r '.filesystems[].target'
```

`-n` drops headers; `-r` raw fields; JSON for structured tools.

### Busy mount debugging

```bash
findmnt /mnt/data
findmnt -R /mnt/data
sudo lsof +f -- /mnt/data | head
sudo fuser -vm /mnt/data
```

See exact mount options and nested mounts before `umount`.

### Verify fstab

```bash
findmnt --verify
findmnt --verify --verbose
```

Catches missing devices, bad options, or stale UUIDs **before** the next boot fails.

### NFS / bind focus

```bash
findmnt -t nfs,nfs4
findmnt -o TARGET,SOURCE,FSTYPE,OPTIONS -t nfs,nfs4
findmnt | grep bind   # binds often show same source path twice
```

## Understanding Output

| Column | Meaning |
|--------|---------|
| `TARGET` | Mountpoint |
| `SOURCE` | Device, UUID path, or bind source |
| `FSTYPE` | Filesystem type |
| `OPTIONS` | `rw`, `noexec`, `nosuid`, NFS opts, … |
| Size cols (`-D`) | Capacity like `df` |

Tree indentation reflects mount nesting (e.g. bind under `/mnt`). Pseudo filesystems (`proc`, `sysfs`, `cgroup2`) dominate unfiltered views on modern systemd systems.

## Notes & Pitfalls

- Unfiltered output is noisy — filter with `-t` or look at specific targets.
- Namespace matters: inside containers/`unshare` you see that mount NS only.
- `findmnt -T` follows the mount covering a path, not “directory exists”.
- Options string is long; use `-o` to extract what you need.
- Prefer `findmnt` over scraping `/proc/mounts` in new scripts (still OK to read `/proc/self/mountinfo` for deep debugging).

## Related Commands

- `mount` / `umount` — attach/detach
- `lsblk -f` / `blkid` — device identity
- `df -h` — classic capacity
- `lsof` / `fuser` — busy mounts
- `systemctl status *.mount` — systemd mount units

## Additional Resources

- `man findmnt`
- `man mount`
- `man fstab`
