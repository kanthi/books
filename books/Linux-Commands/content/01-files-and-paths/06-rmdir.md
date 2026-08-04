# rmdir

## Overview

`rmdir` removes **empty** directories only. It is safer than `rm -r` when you want the kernel to refuse deletion if anything is still inside. For recursive removal of non-empty trees, use `rm -r` (carefully) or empty the tree first with `find`/`rm`.

## Syntax

```bash
rmdir [options] directory...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-p`, `--parents` | Remove directory **and** empty ancestors |
| `--ignore-fail-on-non-empty` | Do not error when a directory is non-empty |
| `-v`, `--verbose` | Print a line for each directory removed |
| `--help` | Help |
| `--version` | Version |

There is **no** `-f` force that deletes contents — by design.

## Key Use Cases

1. Remove empty directories safely
2. Tear down a path of empty parents (`-p`)
3. Verify a directory is empty (failure means “not empty” or other error)
4. Clean scaffolding left after build/install scripts
5. Safer automation than blanket `rm -rf`

## Examples with Explanations

### Basic removal

```bash
mkdir /tmp/empty_dir
rmdir /tmp/empty_dir
```

### Non-empty fails

```bash
mkdir -p /tmp/d
echo x > /tmp/d/file
rmdir /tmp/d
# rmdir: failed to remove '/tmp/d': Directory not empty
rm /tmp/d/file
rmdir /tmp/d
```

### Remove parent chain

```bash
mkdir -p /tmp/a/b/c
rmdir -p /tmp/a/b/c
# removes c, then b, then a if each is empty
```

Equivalent idea: `rmdir /tmp/a/b/c /tmp/a/b /tmp/a` from deepest up.

### Verbose

```bash
rmdir -v empty1 empty2
```

### Ignore non-empty (continue batch)

```bash
rmdir --ignore-fail-on-non-empty dir1 dir2 dir3
echo $?
```

Useful when cleaning many dirs and some still have files.

### Test emptiness in scripts

```bash
if rmdir "$dir" 2>/dev/null; then
  echo "removed empty $dir"
else
  echo "not empty or missing: $dir"
fi
```

### Combine with find (empty dirs only)

```bash
# list empty directories
find /tmp/project -type d -empty

# delete empty directories depth-first
find /tmp/project -depth -type d -empty -delete
# or
find /tmp/project -depth -type d -empty -exec rmdir {} +
```

### Brace / multi targets

```bash
mkdir -p logs/{app,nginx,db}
# ... later, if empty:
rmdir logs/app logs/nginx logs/db logs 2>/dev/null
```

## Notes / Pitfalls

- Hidden files (including `.gitkeep`, `.DS_Store`) make a directory non-empty.
- You need write permission on the **parent** directory to remove an entry.
- `rmdir -p` stops when it hits a non-empty ancestor; earlier empties are already gone.
- Never confuse with `rm -r`; `rmdir` will not delete files.
- Mount points and sticky directories (e.g. `/tmp`) follow special rules; you may not remove others’ dirs there.

## 2026-relevant notes

- Build systems and containers often leave empty layers of dirs; `find -type d -empty` is the scalable cleanup.
- Prefer explicit empty-dir removal in deploy scripts over recursive force deletes.
- On immutable OS trees, empty-dir removal may be blocked by filesystem policy — expect EROFS/EPERM.

## Related Commands

- `rm` — remove files and (with `-r`) trees
- `mkdir` — create directories
- `find -type d -empty` — locate empty dirs
- `rm -r` — recursive delete (dangerous)
- `unlink` — remove a single filesystem entry

## Additional Resources

- `man rmdir`
- [GNU coreutils — rmdir](https://www.gnu.org/software/coreutils/manual/html_node/rmdir-invocation.html)
