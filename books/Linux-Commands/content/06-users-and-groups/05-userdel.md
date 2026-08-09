# userdel

## Overview

`userdel` deletes a user account from the system. By default it removes the account entry but may leave the home directory and mail spool unless you pass `-r`. Always confirm you have backups and that no critical processes still run as that user.

## Syntax

```bash
userdel [options] LOGIN
```

## Common Options

| Option | Description |
|--------|-------------|
| `-r`, `--remove` | Remove home directory and mail spool |
| `-f`, `--force` | Force removal even if logged in / files busy (dangerous) |
| `-Z` | Remove SELinux user mapping (when applicable) |
| `-R CHROOT` | Chroot |
| `-P PREFIX` | Prefix |

## Examples with Explanations

### Delete account, keep home

```bash
id bob
sudo userdel bob
ls /home/bob                 # may still exist
```

### Delete account and home

```bash
sudo userdel -r bob
```

### Refuse when logged in

```bash
who | grep bob
loginctl user-status bob
sudo userdel bob             # may fail if logged in
# terminate sessions first:
sudo loginctl terminate-user bob
sudo userdel -r bob
```

### Processes still running

```bash
ps -u bob
sudo pkill -u bob
sudo userdel -r bob
```

### Orphan files outside home

```bash
# after delete, numeric UID may remain on files:
sudo find /var /srv -nouser 2>/dev/null | head
```

Reassign or delete intentionally.

### System users

```bash
# prefer package uninstall / systemd DynamicUser cleanup
# only manually remove custom system accounts you created
sudo userdel -r appuser
```

## Notes / Pitfalls

- Without `-r`, homes accumulate on disk — disk bloat and privacy residue.
- Force-deleting logged-in users can confuse running jobs; terminate cleanly first.
- Crontabs, systemd user units, and mail spools may need manual cleanup.
- UID reuse: deleting then creating a new user with same UID exposes old files — wipe or reown.
- LDAP users: use directory tools, not local `userdel`, for network accounts.

## 2026-relevant notes

- Prefer lifecycle via configuration management and IdP offboarding playbooks.
- Containers: removing users in a container image layer doesn’t rewrite earlier layers’ files.
- Check `loginctl`, `crontab -u`, and `/var/lib/systemd/` leftovers for interactive users.

## Related Commands

- `useradd` / `usermod`
- `passwd` / `chage`
- `groupdel`
- `find -nouser`
- `loginctl`
- `vipw` — manual editor (last resort)

## Additional Resources

- `man userdel`
