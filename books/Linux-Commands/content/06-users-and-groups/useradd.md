# useradd

## Overview
`useradd` creates a new user account and related files. On Ubuntu/Debian, **`adduser`** is a friendlier interactive wrapper; `useradd` is the low-level portable tool.

## Syntax
```bash
sudo useradd [options] login
```

## Common Options
| Option | Description |
|--------|-------------|
| `-m` | Create home from skel |
| `-G groups` | Supplementary groups |
| `-g group` | Primary group |
| `-s shell` | Login shell |
| `-u UID` | Numeric UID |
| `-r` | System account |
| `-c comment` | GECOS |
| `-d home` | Home path |
| `-e expire` | Expiry date |

## Examples with Explanations
```bash
sudo useradd -m -s /bin/bash alice
sudo passwd alice
sudo useradd -m -G sudo,docker -s /bin/bash bob
sudo useradd -r -s /usr/sbin/nologin appsvc
getent passwd alice
sudo adduser charlie          # Debian interactive alternative
```

### Defaults
See `/etc/login.defs` and `/etc/default/useradd`. Skeleton files come from `/etc/skel`.

## Related Commands
- `usermod` / `userdel`  
- `passwd` / `chage`  
- `adduser` / `deluser`  
- `getent passwd`
