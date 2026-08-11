# chown

## Overview

`chown` (change owner) sets the **user** and/or **group** ownership of files and directories. Only root (or a process with `CAP_CHOWN`) can change the user owner on typical Linux systems. Changing the group may be allowed if you are a member of the target group (rules vary; root always can).

Ownership is central to discretionary access control together with `chmod` modes and ACLs.

## Syntax

```bash
chown [options] OWNER[:GROUP] file...
chown [options] :GROUP file...
chown [options] --reference=RFILE file...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-R`, `--recursive` | Operate on directory trees |
| `-H` / `-L` / `-P` | Symlink traversal policy with `-R` |
| `-h` | Affect symlink itself, not target (when supported) |
| `-c` | Report only when a change is made |
| `-v` | Verbose |
| `-f` | Suppress most error messages |
| `--from=CURRENT` | Change only if currently owned by CURRENT |
| `--reference=RFILE` | Copy ownership from RFILE |
| `--preserve-root` | Do not recurse on `/` (default on GNU) |

## OWNER:GROUP forms

| Form | Meaning |
|------|---------|
| `user` | Set owner; group unchanged |
| `user:group` | Set owner and group |
| `user:` | Set owner; group to user’s primary group (GNU) |
| `:group` | Set group only (like `chgrp`) |
| numeric `0:0` | UID:GID by number |

## Examples with Explanations

### Basic

```bash
sudo chown alice file.txt
sudo chown alice:alice file.txt
sudo chown alice:devs project/
sudo chown :devs project/          # group only
sudo chown 1000:1000 file.txt      # numeric
```

### Recursive web tree

```bash
sudo chown -R www-data:www-data /var/www/html
sudo chown -R alice:alice /home/alice/proj
```

### Reference file

```bash
sudo chown --reference=/var/www/html/index.html /var/www/html/app.php
```

### Conditional change

```bash
sudo chown --from=root:root alice:alice file.txt
```

Useful in scripts that should not clobber unexpected owners.

### Symlinks

```bash
sudo chown -h alice linkname        # change the link’s owner if supported
sudo chown -R -H alice dir_with_links
```

Know whether you mean the symlink or its target; mistakes reassign the wrong object.

### Deploy pattern

```bash
sudo install -o root -g root -m 644 app.conf /etc/myapp/app.conf
sudo chown -R appuser:appuser /var/lib/myapp
```

Often `install`/`rsync --chown` is cleaner than copy + chown.

### Audit before change

```bash
find /srv/data -not -user app -o -not -group app
sudo find /srv/data -not -user app -exec chown app:app {} +
```

## Notes / Pitfalls

- Recursive `chown -R` on the wrong path is a classic outage (`/` or `/usr`). Prefer absolute paths and double-check.
- NFS root_squash maps root to `nobody` — remote `chown` may fail or not stick as expected.
- Containers: numeric UIDs inside user namespaces map differently on the host.
- Changing ownership does not change mode bits; pair with `chmod`/`setfacl` as needed.
- Sticky directories and special bits behave independently of owner changes.

## 2026-relevant notes

- systemd services: prefer `User=` / `Group=` in units and `StateDirectory=` ownership over ad-hoc chown in scripts.
- Rootless Podman/Docker: host UID remapping means `chown` inside may show as high UIDs on the host.
- For bulk sync with ownership, `rsync -a --chown=user:group` is often safer and more visible.

## Related Commands

- `chmod` — change mode bits
- `chgrp` — change group only
- `ls -l` / `stat` — inspect ownership
- `id` — your uid/gids
- `install` — copy with owner/mode
- `setfacl` / `getfacl` — ACLs
- `namei -l` — path component owners

## Additional Resources

- `man chown`
