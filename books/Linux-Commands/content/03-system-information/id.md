# id

## Overview

`id` prints the real and effective user and group IDs for a process (by default, yours), plus supplementary groups. It is the authoritative quick identity tool for permissions debugging — better than `whoami` alone when groups and numeric IDs matter.

## Syntax

```bash
id [options] [user]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-u`, `--user` | Print only user ID |
| `-g`, `--group` | Print only primary group ID |
| `-G`, `--groups` | Print all group IDs |
| `-n`, `--name` | Print names instead of numbers (with `-u`/`-g`/`-G`) |
| `-r`, `--real` | Real ID instead of effective |
| `-z`, `--zero` | NUL-terminate (with `-G` etc.) |
| `-A` | Security context extras on some systems |
| `-Z` | SELinux context (when available) |

## Examples with Explanations

### Default

```bash
id
# uid=1000(alice) gid=1000(alice) groups=1000(alice),27(sudo),100(users)
```

### Specific fields

```bash
id -u
id -un
id -g
id -gn
id -G
id -Gn
```

### Other users

```bash
id www-data
id -un root
getent passwd www-data
```

### Root check in scripts

```bash
if [ "$(id -u)" -ne 0 ]; then
  echo "need root" >&2
  exit 1
fi
```

### Real vs effective (setuid context)

```bash
id -u
id -ru
id -u -r
# if they differ, effective privileges differ from real user
```

### SELinux

```bash
id -Z
```

### Format for logs

```bash
printf 'User: %s (UID: %d)\n' "$(id -un)" "$(id -u)"
echo "groups=$(id -Gn)"
```

### Permission debugging pattern

```bash
id
namei -l /path/to/resource
ls -l /path/to/resource
getfacl /path/to/resource 2>/dev/null
```

## Notes / Pitfalls

- Names come from NSS (`passwd`/`group`/sssd/ldap) — offline LDAP can make lookups hang.
- Prefer numeric IDs in scripts for comparisons; names can rename.
- Supplementary groups affect file access; primary gid alone is incomplete.
- Containers may show only a subset of host groups or remapped UIDs.
- `id user` looks up that account; default is the calling process credentials.

## 2026-relevant notes

- Systemd user sessions and linger affect available groups for some services — debug with `id` inside the unit’s environment (`systemd-run --user`).
- Rootless containers: high UIDs on the host map to low UIDs inside.
- For policy (“must be in group docker”), check `id -nG | tr ' ' '\n' | grep -x docker`.

## Related Commands

- `whoami` — effective username only
- `groups` — group names shorthand
- `getent` — account database lookup
- `newgrp` / `sg` — run with alternate group
- `sudo` / `su` — change identity
- `getfacl` — ACL permissions

## Additional Resources

- `man id`
