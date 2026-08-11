# groupadd

## Overview

`groupadd` creates a new group entry in the local group database (`/etc/group`, and `/etc/gshadow` when used). Groups grant shared file access and sudo/role membership without sharing login accounts. On Ubuntu, interactive admins sometimes use `addgroup`; automation should prefer `groupadd` for stable flags.

## Syntax

```bash
sudo groupadd [options] GROUP
```

## Common Options

| Option | Description |
|--------|-------------|
| `-g GID`, `--gid` | Numeric GID |
| `-r`, `--system` | System group (GID from system range in `login.defs`) |
| `-f`, `--force` | Exit successfully if group already exists; still fails on GID conflict unless handled |
| `-K KEY=VAL` | Override `/etc/login.defs` defaults for this invocation |
| `-o`, `--non-unique` | Allow non-unique GID (usually avoid) |
| `-p PASSWORD` | Encrypted group password (rare; prefer no group passwords) |
| `-U USERS`, `--users` | Comma-separated user list to add (util-linux; version-dependent) |

## Related membership tools

Creating a group is only half the job — membership is managed with:

```bash
sudo usermod -aG GROUP USER
sudo gpasswd -a USER GROUP
sudo gpasswd -d USER GROUP
getent group GROUP
id USER
```

## Safety

- Pick GIDs deliberately when using NFS or shared storage; mismatched GIDs mean “same name, different access”.
- Do not reuse GIDs of deleted groups until you understand leftover file ownership on disk.
- Group passwords are an old pattern; modern sites use explicit membership instead.
- Naming collisions with system groups (`sudo`, `adm`, `disk`, `docker`) are high risk — list first.

## Key Use Cases

1. Create application/shared-data groups (`appdata`, `deploy`)
2. Create system groups for daemons
3. Align GIDs across a fleet for shared filesystems
4. Prepare groups before `useradd -G` / `usermod -aG`

## Examples with Explanations

### Example: simple project group

```bash
sudo groupadd appdata
getent group appdata
```

Creates the group with the next available GID from the user range.

### Example: fixed GID for NFS fleet

```bash
sudo groupadd -g 12000 appdata
getent group appdata
```

Use the same GID on every server that mounts the same export.

### Example: system group for a daemon

```bash
sudo groupadd -r appsvc
getent group appsvc
```

System GID range is defined in `/etc/login.defs` (`SYS_GID_MIN` / `SYS_GID_MAX`).

### Example: create group then add members (`-aG`)

```bash
sudo groupadd deploy
sudo usermod -aG deploy alice
sudo usermod -aG deploy bob
getent group deploy
id alice
```

Always **append** with `usermod -aG` so existing supplementary groups remain intact.

### Example: Ubuntu interactive alternative

```bash
sudo addgroup designers
```

Debian/Ubuntu helper; fine for humans, less ideal for exact GID control in scripts.

### Example: idempotent-ish create in scripts

```bash
if ! getent group appdata >/dev/null; then
  sudo groupadd -g 12000 appdata
fi
```

Or experiment with `groupadd -f` carefully — still verify GID when identity matters.

### Example: shared directory ownership pattern

```bash
sudo groupadd appdata
sudo mkdir -p /srv/appdata
sudo chown root:appdata /srv/appdata
sudo chmod 2775 /srv/appdata
# setgid bit (2) → new files inherit group appdata
```

Classic multi-user write directory pattern; pair with sensible umask or ACL if needed.

### Example: list and inspect

```bash
getent group | tail
getent group sudo
grep '^docker:' /etc/group
```

Prefer `getent` so NSS sources (LDAP) are included.

## Notes & Pitfalls

- **Name vs number**: tools and NFS care about GID; humans care about names — keep them consistent across systems.
- Deleting groups (`groupdel`) does not rewrite file ownership on disk — orphaned GIDs appear in `ls -ln`.
- Membership changes need re-login to appear in a user’s active session.
- Directory services: create groups in FreeIPA/LDAP when that is the source of truth.
- `docker`/socket groups grant near-root power — treat membership as privileged.

## Related Commands

- `groupdel` / `groupmod` — delete/rename/change GID
- `gpasswd` — members and administrators of a group
- `usermod -aG` — append user to group
- `useradd -G` — supplementary groups at creation time
- `getent group` / `id` — verify
- `addgroup` — Debian/Ubuntu helper

## Additional Resources

- `man groupadd`
- `man group(5)`
- `man login.defs`
