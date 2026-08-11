# usermod

## Overview

`usermod` modifies an existing user account: shell, home, groups, UID, lock state, expiry, and more. Prefer targeted flags over hand-editing `/etc/passwd`. For group membership, know the difference between **replace** (`-G`) and **append** (`-aG`) — forgetting `-a` is a classic outage that drops sudo rights.

## Syntax

```bash
sudo usermod [options] LOGIN
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l NEWNAME`, `--login` | Rename login |
| `-c COMMENT`, `--comment` | GECOS field |
| `-d HOME`, `--home` | New home path |
| `-m`, `--move-home` | Move home contents when used with `-d` |
| `-s SHELL`, `--shell` | Login shell |
| `-u UID`, `--uid` | Change UID (files not auto-chowned everywhere) |
| `-g GROUP`, `--gid` | Primary group |
| `-G GROUPS`, `--groups` | **Set** supplementary groups to this list (replaces!) |
| `-a`, `--append` | With `-G`, **append** groups instead of replacing |
| `-L`, `--lock` | Lock password |
| `-U`, `--unlock` | Unlock password |
| `-e DATE`, `--expiredate` | Account expiry (`YYYY-MM-DD` or empty to clear) |
| `-f DAYS`, `--inactive` | Inactivity after password expiry |
| `-p PASSWORD` | Set encrypted password (prefer `passwd`) |
| `-r` | When changing UID, experimental options vary — read man page carefully |

**Critical group flags:** always use **`-aG`** to add supplementary groups without wiping existing ones.

## Safety

- **`usermod -G group user` without `-a` replaces all supplementary groups.** Operators have locked themselves out of `sudo` this way. Prefer:

  ```bash
  sudo usermod -aG docker alice
  ```

- Changing UID/home on a live logged-in user confuses running sessions; schedule maintenance.
- Locking (`-L`) blocks password auth; SSH keys may still work — know your access paths.
- Rename (`-l`) does not rewrite crontabs, systemd units, mail spools, or ACLs automatically.

## Key Use Cases

1. Add a user to `sudo`, `docker`, or app groups (**`-aG`**)
2. Change login shell or GECOS
3. Move/rename home during account cleanup
4. Lock contractors without deleting data immediately

## Examples with Explanations

### Example: append supplementary groups (`-aG`)

```bash
id alice
sudo usermod -aG docker,sudo alice
id alice
# alice must re-login (or newgrp) for group membership to apply fully
```

**`-aG`** is the safe daily form. Verify with `id` after a fresh login.

### Example: wrong vs right group edit

```bash
# DANGEROUS — replaces supplementary groups with only "docker"
sudo usermod -G docker alice

# CORRECT — append docker, keep sudo and others
sudo usermod -aG docker alice
```

If you truly intend to set the definitive list, pass the full list explicitly:

```bash
sudo usermod -G sudo,docker,adm alice
```

### Example: change shell

```bash
sudo usermod -s /bin/bash alice
getent passwd alice
```

Common fix when an account was created with `nologin` by mistake (for human users only).

### Example: lock and unlock

```bash
sudo usermod -L alice
passwd -S alice
sudo usermod -U alice
```

Related: `passwd -l`/`-u`. Locking is not the same as setting shell to nologin — consider both for service accounts.

### Example: move home directory

```bash
sudo usermod -d /srv/homes/alice -m alice
ls -la /srv/homes/alice
getent passwd alice
```

`-m` moves files from the old home. Ensure destination parent exists; watch disk space and SELinux/AppArmor contexts on hardened systems.

### Example: rename login

```bash
sudo usermod -l newalice alice
# often also:
sudo usermod -d /home/newalice -m newalice
```

Update references in sudoers, cron, CI credentials, and docs.

### Example: change primary group

```bash
sudo groupadd appteam
sudo usermod -g appteam alice
id alice
```

Primary group affects default group of newly created files (with usual umask/dir sticky behaviors).

### Example: change UID carefully

```bash
sudo usermod -u 12000 alice
# fix ownership of home (minimum):
sudo chown -R alice:alice /home/alice
# search for old UID leftovers if needed:
sudo find / -xdev -uid 1001 2>/dev/null
```

UID changes do not rewrite the whole filesystem for you.

### Example: expiry

```bash
sudo usermod -e 2026-12-31 alice
sudo usermod -e '' alice          # clear expiry (syntax may vary; confirm man)
sudo chage -l alice
```

### Example: service account hardening

```bash
sudo usermod -s /usr/sbin/nologin -L appsvc
```

No interactive shell + locked password for non-human accounts (SSH keys should also be absent).

## Notes & Pitfalls

- Group changes apply to **new** sessions; existing SSH sessions keep old group sets until re-login.
- `newgrp` / `sg` can temporarily switch for testing without full logout.
- Directory services (sssd/LDAP): modify the identity source of truth, not only the local cache.
- `-a` without `-G` is an error; they are a pair for append mode.
- Prefer `gpasswd -a user group` as an alternative for single-group adds.

## Related Commands

- `useradd` / `userdel` — create/delete
- `groupadd` / `gpasswd` / `groupmod` — group side
- `passwd` / `chage` — password and aging
- `id` / `getent` — verify
- `vipw` — last-resort file edit (avoid)

## Additional Resources

- `man usermod`
- `man group(5)`, `man passwd(5)`
