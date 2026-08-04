# locate

## Overview

`locate` finds files by **name** using a prebuilt database (historically mlocate; on modern Ubuntu often **plocate**). It is much faster than walking the live filesystem with `find` for simple name queries, but results can be **stale** until the database is updated.

Use `find` when you need live data or predicates (size, mtime, permissions, content).

## Syntax

```bash
locate [options] pattern...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-i` | Case-insensitive |
| `-l N` / `-n N` | Limit to N results |
| `-b` / `--basename` | Match basename only |
| `-r` / `--regexp` | Extended regex |
| `-c` | Count matches |
| `-e` | Only print paths that still exist |
| `-0` | NUL-delimited output |
| `-d DB` / `--database=DB` | Alternate database path |
| `-A` | Match all patterns (AND; when supported) |
| `-w` | Match whole path as a word (implementation-dependent) |

Check `man locate` / `man plocate` for your provider.

## Database updates

```bash
sudo updatedb
# plocate often uses a systemd unit/timer:
sudo systemctl start plocate-updatedb.service
systemctl status plocate-updatedb.timer
```

Daily timers/cron usually refresh automatically. Freshly created files won’t appear until the next update.

## Examples with Explanations

### Basic

```bash
locate sshd_config
locate -i readme
locate -b '\.bashrc'
locate nginx.conf
```

### Limit and count

```bash
locate -l 20 nginx
locate -n 50 '*.service'
locate -c '*.png'
```

### Regex

```bash
locate -r '/etc/.*\.conf$'
locate -r 'systemd.*\.service$'
```

### Basename-only

```bash
locate -b 'passwd'
# vs full path match noise:
locate passwd | head
```

### Existence filter

```bash
locate -e mydeletedfile     # suppress already-removed paths still in DB
```

### NUL-safe handoff

```bash
locate -0 -b 'TODO.md' | xargs -0 ls -l
```

### When locate is empty

```bash
command -v locate
dpkg -l plocate mlocate 2>/dev/null
sudo apt install plocate     # Debian/Ubuntu example
sudo systemctl start plocate-updatedb.service
```

## locate vs find

| Need | Tool |
|------|------|
| Fast name search system-wide | `locate` |
| Just-created files | `find` / `fd` |
| Size / mtime / mode filters | `find` |
| Content search | `rg` / `grep -R` |
| PATH executables only | `command -v` / `type` |

## Notes / Pitfalls

- Security/privacy: databases may omit unreadable paths or require permissions to query — don’t assume world visibility of private files.
- Patterns are often substring matches against full paths — expect noise without `-b` or regex anchors.
- Network filesystems may be excluded from `updatedb` for performance (see `PRUNEPATHS` / plocate config).
- Different implementations (mlocate vs plocate) change defaults and speed; prefer distro docs.
- `locate` is not a real-time security audit of “what exists now”.

## 2026-relevant notes

- **plocate** is the common modern default — faster compressed DB.
- Immutable/ostree systems may index differently; containers often lack a DB entirely.
- For developer trees, `fd`/`find` inside the project beats system `locate`.

## Related Commands

- `find` — live criteria search
- `fd` — modern friendly finder
- `updatedb` / `plocate-updatedb` — refresh DB
- `which` / `type` — executables on PATH
- `dpkg -S` / `rpm -qf` — which package owns a path

## Additional Resources

- `man locate`, `man plocate`, `man updatedb`
