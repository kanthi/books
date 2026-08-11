# readlink

## Overview

`readlink` prints the target of a symbolic link, or with GNU flags like `-f`/`-e`/`-m`, canonicalizes paths by resolving symlinks (similar territory to `realpath`). Essential for debugging link chains, deploy symlinks, and locating the real path of `$0` in scripts.

## Syntax

```bash
readlink [options] file...
```

## Common Options (GNU)

| Option | Description |
|--------|-------------|
| `-f`, `--canonicalize` | Canonical path; all but last component must exist |
| `-e`, `--canonicalize-existing` | All components must exist |
| `-m`, `--canonicalize-missing` | No component need exist; still normalize |
| `-n`, `--no-newline` | Do not output trailing newline |
| `-q`, `-s` | Suppress most errors |
| `-v` | Verbose errors |
| `-z` | NUL-terminate output |
| `--` | End of options |

Without flags, `readlink` prints the **raw** symlink contents (may be relative) and fails if the path is not a symlink.

## Key Use Cases

1. Show immediate symlink target
2. Resolve full canonical path (`-f`/`-e`)
3. Script location detection
4. Verify deploy `current` links
5. Safe path comparisons

## Examples with Explanations

### Immediate target

```bash
ln -s ../etc/hosts /tmp/h
readlink /tmp/h
# ../etc/hosts
```

### Canonical forms

```bash
readlink -f /tmp/h
readlink -e /usr/bin/python3
readlink -m /not/yet/created
```

| Flag | Missing path behavior |
|------|------------------------|
| `-e` | Fail if any component missing |
| `-f` | Last component may be missing (GNU) |
| `-m` | Tolerate missing components |

### Multiple links

```bash
readlink -f /usr/bin/python /usr/bin/java
```

### Script directory pattern

```bash
#!/usr/bin/env bash
SELF=$(readlink -f "$0")
ROOT=$(dirname "$SELF")
cd "$ROOT"
```

### BusyBox / portability note

```bash
# portable-ish alternative when readlink -f missing:
realpath "$(dirname "$0")"
# or
python3 -c 'import os,sys; print(os.path.realpath(sys.argv[1]))' "$0"
```

### Inspect vs ls

```bash
ls -l /usr/bin/python3
readlink /usr/bin/python3
readlink -f /usr/bin/python3
```

### NUL-safe with find

```bash
find /opt -type l -print0 | while IFS= read -r -d '' L; do
  printf '%s -> %s\n' "$L" "$(readlink "$L")"
done
```

## Notes / Pitfalls

- Bare `readlink` **errors** on non-symlinks; `readlink -f` works on regular files too (returns canonical path).
- Relative symlink text is relative to the **link’s directory**, not your cwd.
- `readlink -f` behavior differs slightly across BSD/GNU; check man pages on non-Linux.
- Prefer `realpath` when you always want canonicalize semantics by name clarity.
- Race: target can change between resolve and use — TOCTOU in security-sensitive code.

## 2026-relevant notes

- Deploy tooling still relies on `readlink -f` for resolving release symlinks.
- In containers, resolved paths reflect container mounts, not host paths.
- Combine with `namei -l` when permissions on intermediate components fail.

## Related Commands

- `realpath` — canonicalize paths
- `ln -s` — create symlinks
- `ls -l` — show link arrow
- `stat` — inode metadata
- `namei` — stepwise path resolution
- `dirname` / `basename` — split paths

## Additional Resources

- `man readlink`
