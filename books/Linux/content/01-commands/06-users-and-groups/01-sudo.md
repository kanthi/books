# sudo

## Overview

`sudo` runs a command as another user (default: **root**) according to policy in `/etc/sudoers` and `/etc/sudoers.d/*`. Prefer one-shot elevation over lingering in a root shell. On Ubuntu, members of the `sudo` group typically get full rights via the distro sudoers snippet.

## Syntax

```bash
sudo [options] [command]
sudo -i
sudo -u user command
sudoedit file          # same as sudo -e
```

## Common Options

| Option | Description |
|--------|-------------|
| `-u user` | Run as user (not root) |
| `-g group` | Set primary group for the command |
| `-i` | Login shell as target user (loads target profile) |
| `-s` | Shell as target user (minimal env change) |
| `-E` | Preserve environment (policy permitting — often restricted) |
| `-k` | Invalidate cached credentials |
| `-K` | Remove timestamp entirely |
| `-l` / `-l -U user` | List allowed commands |
| `-n` | Non-interactive (fail if a password would be needed) |
| `-v` | Validate / extend timestamp without running a command |
| `-e` / `sudoedit` | Edit file safely as root |
| `-b` | Run command in background |
| `-g group` | Primary group for the command |

## Key Use Cases

1. Administrative package and service changes  
2. Least-privilege elevation per command  
3. Audited privileged actions (auth log / journal)  
4. Safe file edits as root (`sudoedit`)  
5. Run maintenance as a service account (`-u`)  

## Safety

- **Never** `chmod` sudoers to world-writable. Always edit with `visudo`.  
- Pipelines: `sudo cat file | grep x` only elevates `cat`. Use `sudo sh -c '…'` or `sudo grep x file` when the whole pipeline needs root.  
- Avoid `sudo su` / `sudo -i` as a daily habit — harder to audit, easy to leave open.  
- Be careful with `sudo -E` and `env_keep` — leaking `LD_PRELOAD`/`PATH` into root is a classic privilege path.  
- `sudoedit` uses your editor on a temp copy; do not point `$EDITOR` at untrusted wrappers.

## Examples with Explanations

### Run one admin command

```bash
sudo apt update
sudo systemctl restart nginx
```

Elevates only those processes; your shell remains an unprivileged user.

### Edit a system file safely

```bash
sudoedit /etc/hosts
sudo -e /etc/ssh/sshd_config
```

Writes to a temporary file and installs only if the editor exits successfully — safer than some `sudo vim` permission edge cases.

### Root login shell when you need many steps

```bash
sudo -i
# … work …
exit
```

Loads root’s login environment (`HOME=/root`, profile scripts). Exit promptly when finished.

### Run as another service user

```bash
sudo -u www-data ls -la /var/www
sudo -u postgres psql -c '\conninfo'
```

Debug permissions and DB access as the account that actually runs the service.

### See your privileges

```bash
sudo -l
```

Shows what policy allows for your account (and matching host/command rules).

### Pass env vars explicitly (preferred over `-E`)

```bash
sudo ENV=prod /usr/local/bin/deploy
sudo --preserve-env=http_proxy,https_proxy apt update   # when policy allows
```

Prefer naming variables over blanket environment preservation.

### Credential cache control

```bash
sudo -v          # refresh timestamp
sudo -k          # drop cache for this tty (next sudo asks again)
```

Default timeout is often ~15 minutes per tty — do not assume it on shared jump hosts.

### Non-interactive / scripts

```bash
sudo -n true || { echo "sudo needs a password; cannot continue" >&2; exit 1; }
sudo -n systemctl is-active nginx
```

`-n` fails instead of prompting — essential for unattended scripts.

### Dangerous patterns to avoid

```bash
# BAD: elevates only the left side
sudo cat /etc/shadow | grep root

# GOOD:
sudo grep root /etc/shadow
sudo sh -c 'cat /etc/shadow | grep root'
```

### Read logs of sudo use

```bash
journalctl -u sudo -n 50 --no-pager          # when unit exists
grep -i sudo /var/log/auth.log | tail        # Debian/Ubuntu rsyslog path
journalctl _COMM=sudo -n 50 --no-pager
```

## Understanding Output

Successful commands look like the underlying tool’s output. Failures include password rejects, policy denials (`Sorry, user … is not allowed…`), and missing tty for password prompts. Exit status is usually that of the invoked command; policy denials return non-zero without running it.

## Notes & Pitfalls

- Ubuntu’s default is group-based admin (`%sudo ALL=(ALL:ALL) ALL`) — still prefer explicit command lists on hardened hosts.  
- Lecture/insults and password prompts are configured in sudoers (`Defaults`).  
- `sudo !!` re-runs the previous shell command with sudo — review `!!` expansion before Enter.  
- Root-equivalent via misconfigured `NOPASSWD: ALL` is convenient and dangerous; scope it tightly.  
- Containers: passwordless sudo inside images is common for convenience — treat those images as root-equivalent.

## Related Commands

- `visudo` — edit sudoers safely  
- `su` / `runuser` — switch user (different auth model)  
- `passwd` — change passwords  
- `pkexec` — polkit elevation on desktops  
- `loginctl` — session / lingering control  

## Additional Resources

- `man sudo` / `man sudoers`  
- `visudo(8)`
