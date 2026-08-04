# passwd

## Overview

`passwd` sets or changes user passwords and can lock/unlock accounts or expire passwords. Ordinary users change their own password; root can set any user’s password and manage lock state. Aging policy is refined with `chage`.

## Syntax

```bash
passwd [options] [LOGIN]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-S`, `--status` | Account password status |
| `-l`, `--lock` | Lock password (prefix `!` in shadow) |
| `-u`, `--unlock` | Unlock password |
| `-d`, `--delete` | Delete password (careful: may allow passwordless login depending on PAM) |
| `-e`, `--expire` | Expire password; force change on next login |
| `-n MIN` / `-x MAX` / `-w WARN` / `-i INACT` | Aging shortcuts (often prefer `chage`) |
| `-a`, `--all` | Status for all users (root) |
| `--stdin` | Read password from stdin (root; scripts — prefer chpasswd carefully) |

## Examples with Explanations

### Change passwords

```bash
passwd                     # own password
sudo passwd alice          # set alice’s password as root
```

### Status

```bash
passwd -S alice
sudo passwd -Sa | head
```

Typical status letters: `P` (usable password), `L` (locked), `NP` (no password) — confirm with `man passwd` on your distro.

### Lock / unlock

```bash
sudo passwd -l alice
sudo passwd -u alice
sudo usermod -L alice      # related
sudo usermod -U alice
```

Locking disables password auth; SSH keys may still work depending on config.

### Force change next login

```bash
sudo passwd -e alice
# or
sudo chage -d 0 alice
```

### Scripted set (controlled environments)

```bash
echo 'alice:NewSecurePass' | sudo chpasswd
# passwd --stdin is not portable across all distros
```

Prefer configuration management vaults over shell history for secrets.

### Service accounts

```bash
sudo passwd -l svc_backup
# or lock shell:
sudo usermod -s /usr/sbin/nologin svc_backup
```

## Notes / Pitfalls

- PAM policy enforces complexity/retries — errors may be vague.
- Root bypasses most complexity checks — still use strong secrets.
- Deleting passwords (`-d`) can be dangerous with certain PAM stacks.
- LDAP/sssd users: password changes may need `passwd` via SSSD or IdP self-service.
- Shadow file integrity: never edit `/etc/shadow` by hand if tools exist.

## 2026-relevant notes

- Prefer SSO/IdP for humans; local `passwd` for break-glass and system accounts.
- SSH certificate / key-only logins reduce password surface.
- Pair with `chage` for compliance aging on local accounts.

## Related Commands

- `chage` — aging policy
- `chpasswd` — batch updates
- `usermod -L/-U` — lock flags
- `vipw -s` — edit shadow carefully
- `pam-auth-update` — PAM stacks (Debian family)

## Additional Resources

- `man passwd`, `man shadow`, `man chage`
