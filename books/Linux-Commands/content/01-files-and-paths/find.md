# find

## Overview
`find` walks a directory tree and selects files by name, type, time, size, permissions, and more. It can also **act** on matches (`-exec`, `-delete`). Prefer it for precise searches; use `locate` only for pre-indexed name lookups.

## Syntax
```bash
find [path...] [expression]
```

Expression primaries are AND by default; use `-o`, `\!`, and escaped parentheses `\(` `\)` for complex logic.

## Common Options / Primaries
| Primary / option | Description |
|------------------|-------------|
| `-name PAT` / `-iname PAT` | Basename glob (case-insensitive with `-iname`) |
| `-path PAT` / `-ipath PAT` | Full path glob |
| `-regex PAT` | Path regex (see `-regextype`) |
| `-type f\|d\|l\|b\|c\|p\|s` | File type |
| `-size n[cwbkMGT]` | Size (`+n` greater, `-n` less) |
| `-mtime n` / `-mmin n` | Modified *n* days / minutes ago |
| `-atime` / `-ctime` | Access / inode change time |
| `-user` / `-group` | Owner |
| `-perm mode` | Permissions (`-perm -u+x`, `-perm /u=x`) |
| `-empty` | Empty file or directory |
| `-maxdepth n` / `-mindepth n` | Limit descent |
| `-xdev` | Do not cross filesystems |
| `-prune` | Do not descend into match |
| `-print0` | NUL-delimited paths (safe for weird names) |
| `-exec cmd {} \;` | Run per file |
| `-exec cmd {} +` | Batched args (like xargs) |
| `-delete` | Delete match (implies depth-first) |

## Key Use Cases
1. Locate files by name, age, or size across trees  
2. Clean temp/log artifacts safely  
3. Feed paths into greps, compressors, or fixers  
4. Audit permissions and setuid files  
5. Stay on one mount with `-xdev` during disk hunts  

## Safety
`-delete` and `-exec rm` are irreversible. Test with `-print` first. Quote globs so the shell does not expand them (`-name '*.log'`). Prefer `-exec … {} +` or `-print0 | xargs -0` for speed and safety with spaces.

## Examples with Explanations
### Find by name (case-insensitive)
```bash
find /var/log -iname '*.log' -type f
```
Basename match only; still recurses into subdirectories.

### Limit depth
```bash
find /etc -maxdepth 2 -type f -name '*.conf'
```
Avoids walking huge trees when you know the shape.

### Large files on one filesystem
```bash
find / -xdev -type f -size +500M -printf '%s\t%p\n' 2>/dev/null | sort -nr | head
```
`-xdev` skips other mounts (NFS, USB). `2>/dev/null` hides permission noise.

### Modified in the last day
```bash
find ~/projects -type f -mtime -1
```
`-mtime -1` = less than 24 hours ago (integer day semantics; see also `-mmin`).

### Exclude a directory
```bash
find . -path './.git' -prune -o -path './node_modules' -prune -o -type f -name '*.js' -print
```
`-prune` skips those trees; structure is: prune OR (criteria AND print).

### Safe batch action
```bash
find /var/tmp -type f -mtime +30 -print0 | xargs -0 -r rm -v
```
NUL-delimited pipeline handles spaces; `-r` skips `rm` if empty.

### Exec with batching
```bash
find . -type f -name '*.png' -exec gzip -9 {} +
```
One `gzip` with many args — faster than `\;`.

### Permission audit (setuid)
```bash
find /usr -xdev -perm -4000 -type f -printf '%m %u %p\n' 2>/dev/null
```
Classic security inventory.

### Empty directories
```bash
find . -type d -empty
```

## Understanding Output
Default is one path per line (`-print`). Use `-printf` for custom columns (size, mtime, mode). Exit status is non-zero if errors occurred during traversal (e.g. permission denied), even if some matches printed.

## Common Usage Patterns
### Newest N files under a tree
```bash
find . -type f -printf '%T@ %p\n' | sort -nr | head | cut -d' ' -f2-
```

### Delete with interactive dry-run
```bash
find /tmp -type f -mtime +14 -print   # review
find /tmp -type f -mtime +14 -delete  # then delete
```

## Notes & Pitfalls
- Day filters (`-mtime`) truncate; for “last 2 hours” use `-mmin -120`.
- Globs in `-name` are **not** regex; use `-regex` for regular expressions.
- `find -delete` deletes directories only when empty (after contents removed in depth-first order).
- Prefer `locate` for “I only know a filename and the DB is fresh”; prefer `find` for live criteria.

## Related Commands
- `locate` / `updatedb` — indexed name search  
- `fd` — modern friendlier finder (if installed)  
- `grep -R` — search *contents*  
- `du` / `ncdu` — size-oriented exploration  
- `xargs -0` — build argument lists from `-print0`  

## Additional Resources
- `man find`  
- [GNU Findutils manual](https://www.gnu.org/software/findutils/manual/html_mono/find.html)
