# lsattr

## Overview

`lsattr` lists **ext file attributes** set with `chattr` (immutable, append-only, no-dump, and others). Use it when a file refuses deletion/`chmod` despite normal permissions, or when auditing hardened configs.

Works on ext2/3/4 (and some other filesystems with partial support). See also `chattr`.

## Syntax

```bash
lsattr [options] [file...]
lsattr -R dir
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a` | Include files starting with `.` |
| `-d` | List directories like files (do not list contents) |
| `-R` | Recursive |
| `-v` | Show version/generation numbers when available |
| `-l` | Long option names (where supported) |

## Examples with Explanations

### List attributes

```bash
lsattr /etc/passwd
lsattr -a /var/log
```

A line like `----i---------e---- file` means the **immutable** (`i`) bit is set.

### Find immutable files under a tree

```bash
sudo lsattr -R /etc 2>/dev/null | grep -- '--i-'
```

### Directory itself, not children

```bash
lsattr -d /var/log/journal
```

## Understanding Output

Flags are a string of attribute letters (or `-` when unset). Common ones: `i` immutable, `a` append-only, `c` compressed (legacy), `e` extents, `A` no atime updates. Exact set depends on filesystem and kernel.

## Notes & Pitfalls

- Immutable root-owned files require `chattr -i` as root before edit/delete.  
- Not a substitute for DAC/ACL/SELinux — orthogonal layer.  
- Some network/filesystem types ignore these attributes.

## Related Commands

- `chattr` — set/clear attributes  
- `ls` / `stat` — classic metadata  
- `getfacl` — ACLs  

## Additional Resources

- `man lsattr`  
- `man chattr`
