# crontab

## Overview

`crontab` installs, lists, and removes **per-user** crontab files that the `cron` daemon executes. Prefer `crontab -e` over editing spool files by hand. System-wide jobs live under `/etc/cron.d` and friends — see the `cron` chapter.

## Syntax

```bash
crontab [-u user] file
crontab [-u user] [-l | -r | -e] [-i]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | List current crontab |
| `-e` | Edit current crontab in `$EDITOR` / `$VISUAL` |
| `-r` | Remove entire crontab |
| `-i` | Prompt before `-r` |
| `-u user` | Operate on another user’s crontab (**root**) |

## Key Use Cases

1. Schedule periodic tasks as your own user  
2. Install a crontab from a file in config management  
3. Audit what a user has scheduled  
4. Clean up obsolete jobs safely  

## Safety

- `crontab -r` deletes **all** of that user’s jobs without a backup — use `-i` or list first.  
- Installing from a file replaces the whole crontab; keep the source in git.  
- Root using `-u` affects another account’s automation — verify the user name.

## Examples with Explanations

### List and edit

```bash
crontab -l
EDITOR=vim crontab -e
```

Empty crontab may print `no crontab for user` (exit status can be non-zero depending on version).

### Install from a file (idempotent in config mgmt)

```bash
cat > /tmp/my.cron <<'EOF'
SHELL=/bin/bash
PATH=/usr/local/bin:/usr/bin:/bin
MAILTO=""
*/15 * * * * /usr/local/bin/poll.sh >>$HOME/logs/poll.log 2>&1
0 3 * * * /usr/local/bin/backup.sh >>$HOME/logs/backup.log 2>&1
EOF
crontab /tmp/my.cron
crontab -l
```

Redirects and absolute paths avoid “worked in SSH, failed in cron”.

### Append a line carefully

```bash
(crontab -l 2>/dev/null; echo '0 4 * * 0 /usr/local/bin/weekly.sh') | crontab -
```

Race-prone if two installers run at once — prefer full-file installs from CM.

### Remove with confirmation

```bash
crontab -l > ~/crontab.backup.$(date +%F)
crontab -i -r
```

Always backup before delete.

### Root manages another user

```bash
sudo crontab -u deploy -l
sudo crontab -u deploy -e
```

### Validate schedule fragments

```bash
# After editing, re-list and reason about times:
crontab -l
# Cross-check system timers too:
systemctl list-timers --all
```

### Common job examples

```cron
# every 15 minutes
*/15 * * * * /usr/bin/flock -n /tmp/poll.lock /usr/local/bin/poll.sh

# weekdays 09:00
0 9 * * 1-5 /usr/local/bin/report.sh

# after reboot
@reboot /usr/local/bin/start-tunnel.sh
```

See `cron` for field semantics, environment, and debugging.

## Understanding Output

`crontab -l` prints the file body (comments and environment assignments included). Editors invoked by `-e` must exit zero for the new file to be installed; syntax is checked lightly — a bad command still “installs”.

## Notes & Pitfalls

- Per-user crontabs do **not** include a username field (unlike `/etc/crontab`).  
- `%` is special in some cron implementations — escape as `\%` in commands.  
- SELinux may block scripts that work in an interactive shell.  
- Desktop users: session-dependent jobs often need systemd user timers + lingering, not cron.  
- `crontab -e` uses `select-editor` on first run (Debian/Ubuntu).

## Related Commands

- `cron` — daemon and system locations  
- `anacron` — catch-up on machines that sleep  
- `at` — one-shot schedules  
- `systemctl list-timers` — systemd alternative  
- `flock` — prevent overlapping runs  

## Additional Resources

- `man 1 crontab`  
- `man 5 crontab`  
- [crontab.guru](https://crontab.guru/)
