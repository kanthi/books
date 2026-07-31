# sudo

## Overview
`sudo` runs a command as another user (default: root) according to policy in `/etc/sudoers` and `/etc/sudoers.d/*`. Prefer it over lingering in a root shell.

## Syntax
```bash
sudo [options] [command]
sudo -i
sudo -u user command
sudoedit file
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u user` | Run as user (not root) |
| `-i` | Login shell as target user |
| `-s` | Shell as target user |
| `-E` | Preserve environment (policy permitting) |
| `-k` | Invalidate cached credentials |
| `-l` | List allowed commands |
| `-n` | Non-interactive (fail if password needed) |
| `-v` | Validate/extend timestamp |
| `-e / sudoedit` | Edit file safely as root |

## Key Use Cases
1. Administrative package and service changes
2. Least-privilege elevation per command
3. Audited privileged actions (via logs)
4. Safe file edits as root

## Safety
Never chmod `sudoers` to world-writable. Always edit with `visudo`. Beware `sudo` pipelines: `sudo cat file | grep x` only elevates `cat`. Use `sudo sh -c '…'` when the whole pipeline needs root.

## Examples with Explanations
### Run one admin command
```bash
sudo apt update
sudo systemctl restart nginx
```
Elevates only those processes; returns to normal user after.

### Edit a system file
```bash
sudoedit /etc/hosts
# or: sudo -e /etc/ssh/sshd_config
```
Copies to a temp file and installs only if edit succeeds — safer than `sudo vim` quirks.

### Shell as root
```bash
sudo -i
```
Full root login environment when many admin steps are needed; exit when done.

### Run as another service user
```bash
sudo -u www-data ls /var/www
```
Debug permissions as the app user.

### See your privileges
```bash
sudo -l
```
Shows what policy allows for your account.

### Pass env var explicitly
```bash
sudo ENV=prod /usr/local/bin/deploy
```
Prefer explicit vars over blanket `-E`.

## Notes & Pitfalls
- Credential cache is typically ~15 minutes per tty; `sudo -k` clears it.
- Ubuntu ships an admin group (`sudo`) with broad rights via sudoers.
- Logs: `journalctl -u sudo` or `/var/log/auth.log` depending on distro.

## Related Commands
- `su` — switch user (different auth model)
- `passwd` — change passwords
- `visudo` — edit sudoers safely
- `pkexec` — polkit elevation on desktops
