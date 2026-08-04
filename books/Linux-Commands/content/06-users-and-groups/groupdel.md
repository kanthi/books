# groupdel

## Overview

`groupdel` deletes a group from the system group database (typically `/etc/group` and `/etc/gshadow`). It does **not** delete users who had that group as supplementary — it removes the group entry. You cannot delete a group that is still any user’s **primary** group.

Requires root (or equivalent CAP_DAC / account tools).

## Syntax

```bash
groupdel [options] GROUP
```

## Common Options

| Option | Description |
|--------|-------------|
| `-f`, `--force` | Force deletion in some situations (implementation-dependent; use carefully) |
| `-h`, `--help` | Help |
| `-R`, `--root CHROOT` | Apply in chroot |
| `-P`, `--prefix PREFIX` | Alternate passwd/group prefix tree |

## Examples with Explanations

### Delete a group

```bash
getent group oldteam
sudo groupdel oldteam
getent group oldteam || echo gone
```

### Refuse if primary group

```bash
sudo groupdel alice
# groupdel: cannot remove the primary group of user 'alice'
```

Change users’ primary group first:

```bash
sudo usermod -g users alice
sudo groupdel alice
```

### Check membership first

```bash
getent group devs
# see members field
grep -E '^devs:' /etc/group
sudo libuser-groupdel 2>/dev/null   # alternate tools exist
# list users with primary gid:
gid=$(getent group devs | cut -d: -f3)
awk -F: -v g="$gid" '$4==g {print $1}' /etc/passwd
```

### Automation cleanup

```bash
if getent group tempci >/dev/null; then
  sudo groupdel tempci
fi
```

### LDAP / remote groups

```bash
getent group eng
# if from sssd/ldap, groupdel on local files won't remove directory groups
```

Use your directory admin tools for networked accounts.

## Notes / Pitfalls

- Files previously group-owned keep the **numeric GID** — they become “orphan” GIDs in `ls -l` until reowned.
- Does not modify ACLs that referenced the group name (may become unresolved).
- Always inventory with `getent group` and filesystem owners before deleting shared groups.
- Busy production groups (e.g. shared data) need migration of ownership first.
- Containers: deleting groups inside a container doesn’t affect the host.

## 2026-relevant notes

- Prefer configuration management (Ansible users modules) over one-off groupdel on fleets.
- System groups for systemd DynamicUser units are managed differently — don’t manually delete unknown system groups.
- Audit file ownership: `find / -group oldgid` can be expensive; scope paths.

## Related Commands

- `groupadd` / `groupmod` — create / modify
- `useradd` / `usermod` — user membership
- `getent group` — lookup
- `gpasswd` — administer group members
- `chgrp` / `chown` — fix file ownership

## Additional Resources

- `man groupdel`
