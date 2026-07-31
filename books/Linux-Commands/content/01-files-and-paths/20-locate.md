# locate

## Overview
`locate` finds files by name using a **prebuilt database** (mlocate/plocate). Much faster than `find` for simple name queries, but results can be stale until the DB updates.

## Syntax
```bash
locate [options] pattern...
```

On Ubuntu today, `locate` is often provided by **plocate**.

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Case-insensitive |
| `-l N` / `-n N` | Limit results |
| `-b` | Match basename only |
| `-r` | Regex |
| `-c` | Count |
| `-e` | Only existing paths (still present) |
| `-0` | NUL delimit |
| `-d DB` | Alternate database |

## Database updates
```bash
sudo updatedb                 # mlocate-style
sudo systemctl start plocate-updatedb.service   # plocate
```
Daily cron/timer usually refreshes automatically.

## Examples with Explanations
### Basic
```bash
locate sshd_config
locate -i readme
locate -b '\.bashrc'
```

### Limit / count
```bash
locate -l 20 nginx
locate -c '*.png'
```

### Regex
```bash
locate -r '/etc/.*\.conf$'
```

### Existence filter
```bash
locate -e mydeletedfile
```

## Notes & Pitfalls
- Private files may be excluded from the DB depending on config/permissions.  
- Just-created files are invisible until `updatedb`.  
- Use `find` for size/time/permission predicates.

## Related Commands
- `find` — live criteria search  
- `which` / `type` — executables in PATH  
- `dpkg -S` / `rpm -qf` — which package owns a path
