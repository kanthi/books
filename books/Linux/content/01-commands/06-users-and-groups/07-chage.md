# chage

## Overview

`chage` (change age) views and modifies **password aging** policy for a user: last change date, minimum/maximum days between changes, warn days, and account inactivity/expiry. Complements `passwd` (set password) and is useful for compliance-driven rotation policies.

## Syntax

```bash
chage [options] LOGIN
chage -l LOGIN                 # list aging info
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l`, `--list` | Show aging info |
| `-d DATE`, `--lastday` | Last password change day |
| `-E DATE`, `--expiredate` | Account expiration date (`-1` never) |
| `-I DAYS`, `--inactive` | Days after password expiry until account inactive (`-1` never) |
| `-m DAYS`, `--mindays` | Minimum days between password changes |
| `-M DAYS`, `--maxdays` | Maximum password age |
| `-W DAYS`, `--warndays` | Warn days before password expiry |
| `-R CHROOT` | Chroot |

Dates are often `YYYY-MM-DD` or days since 1970-01-01 depending on option forms — see `man chage`.

## Examples with Explanations

### View policy

```bash
sudo chage -l alice
```

### Force change on next login

```bash
sudo chage -d 0 alice
# last day set so password is immediately expired → user must change
```

### Set max age 90 days, warn 14

```bash
sudo chage -M 90 -W 14 alice
```

### Disable aging

```bash
sudo chage -M -1 -E -1 alice
```

### Account expiry date

```bash
sudo chage -E 2026-12-31 contractor
sudo chage -E -1 contractor        # clear expiry
```

### Batch service accounts

```bash
# service accounts often should not expire interactively
sudo chage -M -1 -I -1 -E -1 svc_backup
```

### Combine with passwd

```bash
sudo passwd alice
sudo chage -l alice
```

## Notes / Pitfalls

- Requires shadow suite and proper privileges.
- Policies in `/etc/login.defs` supply defaults for new users; `chage` adjusts per-user.
- LDAP/sssd environments may store aging in the directory — local `chage` won’t apply.
- Forcing `-d 0` on service accounts can break automation that cannot interactively change passwords.
- Date formats and epoch-day forms are easy to mis-set — always `-l` to verify.

## 2026-relevant notes

- Prefer centralized IdP password policies when users live in SSO; use `chage` for local/system accounts.
- Compliance scanners still look at shadow aging fields on classic Linux servers.
- Pair with `passwd -S` and account locking (`usermod -L`) for full lifecycle control.

## Related Commands

- `passwd` — set/lock passwords
- `usermod` — account flags
- `chage -l` vs `passwd -S`
- `vipw` / `vipw -s` — edit passwd/shadow carefully
- `pam_unix` / `login.defs` — defaults

## Additional Resources

- `man chage`, `man shadow`
