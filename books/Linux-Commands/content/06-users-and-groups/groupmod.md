# groupmod

## Overview

`groupmod` modifies an existing group: rename it, change its GID, or adjust related attributes depending on the implementation. Membership lists are often managed via `usermod`/`gpasswd` rather than `groupmod`.

Requires root privileges.

## Syntax

```bash
groupmod [options] GROUP
```

## Common Options

| Option | Description |
|--------|-------------|
| `-n NEWNAME`, `--new-name` | Rename group |
| `-g GID`, `--gid` | Change GID |
| `-o`, `--non-unique` | Allow non-unique GID |
| `-p PASSWORD` | Set encrypted password (rare; prefer gpasswd) |
| `-R CHROOT` | Chroot directory |
| `-P PREFIX` | Prefix directory |

## Examples with Explanations

### Rename a group

```bash
getent group devs
sudo groupmod -n developers devs
getent group developers
```

### Change GID

```bash
getent group developers
sudo groupmod -g 1200 developers
```

**Warning:** files owned by the old numeric GID are **not** rewritten automatically. Plan a `find`/`chgrp` migration.

### Migrate file ownership after GID change

```bash
old=1004
new=1200
sudo find /srv/data -group $old -exec chgrp $new {} +
```

Scope carefully; avoid full-filesystem finds without need.

### Non-unique GID (rare)

```bash
sudo groupmod -o -g 1000 shared
```

Usually a bad idea — collisions confuse tools.

### Verify

```bash
getent group developers
grep developers /etc/group /etc/gshadow
```

## Notes / Pitfalls

- Renaming may break configs that hard-code the old group name (sudoers, ACLs, unit files).
- Changing GID without file migration leaves orphaned ownership.
- Directory services: local `groupmod` won’t change LDAP groups.
- Running processes keep old credentials until re-login / re-spawn.
- Avoid editing `/etc/group` by hand when `groupmod` exists.

## 2026-relevant notes

- Infrastructure as code should declare desired group names/GIDs immutably; avoid frequent renames.
- Container images: GID consistency across images matters for shared volumes — set explicitly.
- Prefer supplementary group membership management with `usermod -aG` over renaming shared groups.

## Related Commands

- `groupadd` / `groupdel`
- `usermod` / `gpasswd`
- `getent group`
- `chgrp`
- `newgidmap` — user namespace gid maps (advanced)

## Additional Resources

- `man groupmod`
