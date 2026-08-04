# realpath

## Overview

`realpath` prints the resolved absolute path of each argument, expanding `.` / `..` and optionally resolving symbolic links. Use it for canonical comparisons, stable script roots, and turning relative paths into absolute ones without reinventing path logic in bash.

GNU `realpath` overlaps with `readlink -f`/`-e`/`-m` but is clearer when “canonicalize this path” is the intent.

## Syntax

```bash
realpath [options] file...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-e`, `--canonicalize-existing` | All components must exist |
| `-m`, `--canonicalize-missing` | No component need exist |
| `-s`, `--no-symlinks` | Do not expand symlinks |
| `-q`, `--quiet` | Suppress most error messages |
| `-z`, `--zero` | NUL-terminated output |
| `--relative-to=DIR` | Print path relative to DIR |
| `--relative-base=DIR` | Absolute unless under base |
| `-L` / `-P` | Logical / physical variants (see man) |

Default (no `-e`/`-m`) is similar to canonicalizing with last component requirements depending on version — prefer explicit `-e` or `-m` in scripts.

## Key Use Cases

1. Absolute canonical paths
2. Relative path between two locations
3. Script root detection
4. Compare whether two path strings name the same place
5. Normalize user input paths

## Examples with Explanations

### Absolute paths

```bash
realpath ../file.txt
realpath -e /etc/hosts
realpath -m /not/yet/created
realpath -m ./build/out/binary
```

### Relative formatting

```bash
realpath --relative-to=/home/user /home/user/docs/file.txt
# docs/file.txt
realpath --relative-to="$PWD" /etc/hosts
realpath --relative-base=/srv /srv/app/bin/tool
```

### Script root

```bash
#!/usr/bin/env bash
set -euo pipefail
ROOT=$(realpath "$(dirname "$0")")
# or resolve the script itself first if it may be a symlink:
ROOT=$(dirname "$(realpath -e "$0")")
cd "$ROOT"
```

### Same-file check

```bash
p1=$(realpath -e "$1")
p2=$(realpath -e "$2")
[[ $p1 == "$p2" ]] && echo 'same path'
# stronger: compare device+inode
stat -c '%d:%i' "$p1" "$p2"
```

### No symlink expand

```bash
realpath -s /tmp/linkdir
```

### Batch NUL-safe

```bash
printf '%s\0' ./* | xargs -0 realpath -e
```

### Combine with find

```bash
find . -name '*.so' -print0 | xargs -0 realpath
```

## Notes / Pitfalls

- Without `-m`, missing paths error — good for validation, bad for pre-creating destinations.
- Canonicalization depends on current mounts and namespaces (containers differ from hosts).
- Race conditions apply: resolved path may change before use.
- BusyBox may offer a smaller `realpath`; test flags.
- `realpath .` vs `pwd -P` — similar idea for cwd.

## 2026-relevant notes

- Prefer `realpath` in new scripts over ad-hoc bash string chopping.
- Build systems and monorepos use relative-from-root paths extensively — `--relative-to` helps generate them.
- Network FS: resolving through automount points can trigger mounts as a side effect.

## Related Commands

- `readlink -f` — GNU canonicalize via readlink
- `pwd -P` — physical cwd
- `dirname` / `basename` — split components
- `cd -P` — physical change directory
- `stat` — identity via inode
- `findmnt` — mount context

## Additional Resources

- `man realpath`
