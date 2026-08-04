# visudo

## Overview

`visudo` safely edits the **sudoers** configuration (`/etc/sudoers` and files under `/etc/sudoers.d/`). It locks the file and **syntax-checks** before installing changes — preventing a bad edit from locking out all sudo access. Always use `visudo` instead of editing sudoers directly with a random editor.

## Syntax

```bash
visudo [options]
visudo -f file
```

## Common Options

| Option | Description |
|--------|-------------|
| `-f file`, `--file=file` | Edit a specific file (e.g. drop-in) |
| `-c`, `--check` | Check syntax only |
| `-s`, `--strict` | Stricter parse |
| `-q`, `--quiet` | Quiet |
| `-x file` | Export as JSON (newer) / legacy dump options vary |
| `-N` | No default includes (see man) |

Editor from `$EDITOR` / `$VISUAL` / compile-time default (`vi`/`nano`).

## Examples with Explanations

### Edit main sudoers

```bash
sudo visudo
```

### Edit a drop-in (preferred)

```bash
sudo visudo -f /etc/sudoers.d/90-alice
```

Drop-ins should be numeric-prefixed and avoid `.` or `~` in names (sudo ignores many invalid names).

### Check syntax

```bash
sudo visudo -c
sudo visudo -cf /etc/sudoers.d/90-alice
```

### Common policy snippets (examples)

```bash
# /etc/sudoers.d/90-alice  (via visudo -f)
alice ALL=(ALL) ALL
# passwordless for a single command (still risky):
alice ALL=(root) NOPASSWD: /usr/bin/systemctl restart nginx
# group based:
%sudo ALL=(ALL:ALL) ALL
```

Understand tag implications (`NOPASSWD`, `SETENV`, `NOEXEC`) before deploying.

### Recover from broken sudoers (prevention)

If you never skip `visudo`, you avoid the classic lockout. Recovery usually needs:

- console/root login
- or break-glass cloud serial console
- then `visudo` fix

### Test as user

```bash
sudo -l -U alice
sudo -u alice sudo -l
```

## Notes / Pitfalls

- Never `nano /etc/sudoers` without visudo — a typo can deny all sudo.
- Last matching rule wins in many cases — order matters.
- `#includedir /etc/sudoers.d` is standard; file names must meet sudo’s filters.
- `NOPASSWD: ALL` is almost always too broad for humans.
- Keep a root console session open while testing policy changes on remote hosts.

## 2026-relevant notes

- Prefer small drop-ins per role over one monolithic sudoers file.
- Many orgs move to SSH certs + policy engines; sudoers still ubiquitous on servers.
- Audit with `sudo -l` and central config management (Ansible `template` + validate).

## Related Commands

- `sudo` / `sudo -l`
- `sudoedit` — edit files as another user safely
- `pkexec` — polkit privilege (desktop/admin)
- `su` — switch user
- editor env: `EDITOR=vim visudo`

## Additional Resources

- `man visudo`, `man sudoers`
