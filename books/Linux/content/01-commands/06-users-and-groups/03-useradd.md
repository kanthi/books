# useradd

## Overview

`useradd` creates a new user account and related system entries (`/etc/passwd`, `/etc/shadow`, `/etc/group` as needed). On **Ubuntu/Debian**, the friendlier interactive wrapper is **`adduser`**; `useradd` is the low-level, script-friendly tool common in configuration management. Creating a login-ready human usually means: `useradd -m` → `passwd` → optional groups → verify with `getent`/`id`.

## Syntax

```bash
sudo useradd [options] LOGIN
```

## Common Options

| Option | Description |
|--------|-------------|
| `-m`, `--create-home` | Create home directory from skeleton |
| `-M` | Do **not** create home (override defaults) |
| `-d HOME`, `--home-dir` | Home path (default under `/home`) |
| `-s SHELL`, `--shell` | Login shell |
| `-g GROUP`, `--gid` | Primary group (name or GID) |
| `-G GROUPS`, `--groups` | Comma-separated **supplementary** groups |
| `-u UID`, `--uid` | Numeric UID |
| `-c COMMENT`, `--comment` | GECOS (full name, room, …) |
| `-r`, `--system` | System account (UID from system range; often no aging) |
| `-e EXPIRE`, `--expiredate` | Account expiry (`YYYY-MM-DD`) |
| `-f INACTIVE` | Days after password expiry until disable |
| `-p PASSWORD` | **Encrypted** password string (prefer `passwd`/`chpasswd`) |
| `-k SKEL` | Skeleton directory (default `/etc/skel`) |
| `-N` | Do not create a group with the same name as the user |
| `-U` | Create a same-named user-private group (common default) |
| `-D` | Display (or set, with flags) default `useradd` values |

## Defaults and files

| Path | Role |
|------|------|
| `/etc/login.defs` | UID/GID ranges, mail dir, umask-related defaults |
| `/etc/default/useradd` | Default shell, home base, expire, skeleton |
| `/etc/skel/` | Files copied into new homes with `-m` |
| `/etc/passwd` / `/etc/shadow` / `/etc/group` | Account databases |

View effective defaults:

```bash
sudo useradd -D
```

## Safety

- Do not pass cleartext secrets on the command line via `-p` — they land in shell history and process listings; use `passwd` or carefully controlled `chpasswd`.
- Choose UIDs deliberately when syncing NFS/LDAP identities — collisions break ownership.
- System accounts (`-r`) should usually get `/usr/sbin/nologin` or `/bin/false`.
- Creating users with `sudo`/admin groups is a privilege decision — prefer documented role groups.

## Key Use Cases

1. Provision local human accounts on Ubuntu servers
2. Create service accounts for daemons
3. Align UID/GID with networked filesystems
4. Script reproducible account creation in labs/CI images

## Examples with Explanations

### Example: human user with home and bash

```bash
sudo useradd -m -s /bin/bash -c 'Alice Admin' alice
sudo passwd alice
id alice
getent passwd alice
ls -la /home/alice
```

`-m` is easy to forget — without it, no home directory is created on many defaults.

### Example: Ubuntu interactive alternative

```bash
sudo adduser charlie
```

Walks through password and GECOS prompts; preferred for one-off humans on Debian/Ubuntu.

### Example: supplementary groups at creation

```bash
sudo useradd -m -s /bin/bash -G sudo,docker bob
id bob
```

`-G` sets supplementary groups. On Ubuntu, membership in `sudo` grants sudo via the default sudoers rule (still verify policy).

### Example: service / system account

```bash
sudo useradd -r -s /usr/sbin/nologin -d /nonexistent -c 'App service' appsvc
getent passwd appsvc
```

No interactive shell; often no home. Pair with systemd `User=` directives.

### Example: fixed UID/GID for NFS

```bash
sudo groupadd -g 12000 appdata
sudo useradd -m -u 12000 -g appdata -s /bin/bash appuser
id appuser
```

Match numeric IDs across servers that share filesystems without centralized identity.

### Example: account expiry

```bash
sudo useradd -m -e 2026-12-31 -s /bin/bash contractor
sudo chage -l contractor
```

Expiry disables login after the date; refine aging with `chage`.

### Example: custom home location

```bash
sudo useradd -m -d /srv/homes/alice -s /bin/bash alice
```

Ensure parent directories exist and permissions make sense before login.

### Example: do not create user-private group

```bash
sudo useradd -m -N -g users -s /bin/bash dave
```

`-N` avoids a per-user group when site policy uses a shared primary group.

### Example: verify skeleton contents

```bash
ls -la /etc/skel
sudo useradd -m -k /etc/skel -s /bin/bash skeltest
ls -la /home/skeltest
sudo userdel -r skeltest
```

Custom skeletons help place mandatory `.bashrc` snippets or ssh config templates.

## Notes & Pitfalls

- **`useradd` vs `adduser`**: different tools; scripts should call `useradd` for stable flags; humans on Ubuntu often use `adduser`.
- Without `-m`, applications expecting `$HOME` fail in confusing ways.
- Primary group (`-g`) vs supplementary (`-G`): both matter for file access.
- LDAP/FreeIPA/sssd environments: create users in the identity system, not only locally — local-only accounts confuse operators.
- Removing accounts is `userdel` (see that page); home cleanup needs `-r` carefully.
- Default shell paths differ: `/bin/bash` vs `/usr/bin/bash` — use paths present on the image (`getent passwd` after creation).

## Related Commands

- `adduser` — Debian/Ubuntu interactive helper
- `usermod` — modify existing accounts
- `userdel` — delete accounts
- `groupadd` / `gpasswd` — groups
- `passwd` / `chage` — passwords and aging
- `getent` / `id` — verify lookups

## Additional Resources

- `man useradd`
- `man login.defs`
- `man adduser` (Debian/Ubuntu)
