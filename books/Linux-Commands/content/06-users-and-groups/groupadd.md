# groupadd / groupmod / groupdel

## Overview
These tools create, modify, and delete groups in the local group database (`/etc/group`, `/etc/gshadow`).

## Syntax
```bash
sudo groupadd [options] group
sudo groupmod [options] group
sudo groupdel group
```

## Common Options (`groupadd`)
| Option | Description |
|--------|-------------|
| `-g GID` | Specific GID |
| `-r` | System group (low GID) |
| `-f` | Exit success if exists |

## Examples with Explanations
```bash
sudo groupadd developers
sudo groupadd -g 2001 staff
sudo groupadd -r appdata
sudo groupmod -n devs developers
sudo groupdel oldgroup
getent group developers
```

### Membership
Prefer `usermod -aG` or `gpasswd -a user group`:
```bash
sudo usermod -aG developers alice
grep ^developers /etc/group
```

## Related Commands
- `usermod -aG`  
- `gpasswd`  
- `getent group`  
- `id`
