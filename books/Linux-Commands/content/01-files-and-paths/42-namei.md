# namei

## Overview

`namei` walks a path component by component, showing whether each element is a file, directory, or symlink — and optionally the permission checks a process would face. Excellent for debugging “permission denied” on deep paths and symlink loops.

Package: usually `util-linux` (preinstalled on Ubuntu).

## Syntax

```bash
namei [options] pathname...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-l` | Long listing (mode, owner, group) |
| `-m` | Mode bits only style (see man) |
| `-o` | Show owner |
| `-v` | Vertical layout |
| `-x` | Show mount point crossings |
| `-n` | Don’t follow symlinks (show link itself) |

## Examples with Explanations

### Diagnose a path

```bash
namei -l /var/www/html/index.html
```

Reveals which directory lacks `x` for your user or which symlink target is wrong.

### Follow ownership along the way

```bash
namei -l /home/alice/.ssh/authorized_keys
```

Classic SSH “modes are too open” / wrong ownership investigations.

### Mount boundaries

```bash
namei -x /mnt/data/subdir/file
```

Shows when a path crosses into another mount.

## Notes & Pitfalls

- Interprets the path as the **calling user** would for access checks when using modes.  
- Symlink cycles are reported instead of hanging forever.  
- Still verify with `ls -ld` on each component for ACLs (`getfacl`).

## Related Commands

- `ls -ld` — single component metadata  
- `realpath` / `readlink -f` — resolve final path  
- `stat` — inode details  
- `getfacl` — ACL beyond mode bits  

## Additional Resources

- `man namei`
