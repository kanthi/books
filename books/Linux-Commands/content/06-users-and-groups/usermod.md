# usermod

## Overview
`usermod` modifies an existing user account: groups, shell, home, lock state, and more.

## Syntax
```bash
sudo usermod [options] LOGIN
```

## Common Options
| Option | Description |
|--------|-------------|
| `-aG group,group` | **Append** supplementary groups |
| `-G groups` | Set supplementary groups (replaces list!) |
| `-g group` | Primary group |
| `-d home -m` | New home and move contents |
| `-s shell` | Login shell |
| `-l newname` | Rename login |
| `-L` / `-U` | Lock / unlock password |
| `-e YYYY-MM-DD` | Account expiry |
| `-u UID` | Change UID (careful with file ownership) |

## Safety
**`-G` without `-a` resets** secondary groups to only those listed — easy way to drop someone from `sudo`. Always prefer **`-aG`** to add groups.

## Examples with Explanations
### Add to sudo / docker
```bash
sudo usermod -aG sudo alice
sudo usermod -aG docker alice
# re-login for group membership to apply
id alice
```

### Change shell / home
```bash
sudo usermod -s /bin/zsh alice
sudo usermod -d /home/alice2 -m alice
```

### Lock / unlock
```bash
sudo usermod -L alice
sudo usermod -U alice
sudo passwd -S alice
```

### Rename
```bash
sudo usermod -l newbob bob
# also rename home if desired with -d -m
```

## Notes
- Active sessions keep old groups until re-login (`newgrp` / re-SSH).  
- Changing UID leaves old-owned files behind — `find / -user OLDUID`.  
- Prefer `vipw` only if you know the format; `usermod` is safer.

## Related Commands
- `useradd` / `userdel`  
- `passwd` / `chage`  
- `gpasswd` / `groupmems`  
- `id` / `getent passwd`
