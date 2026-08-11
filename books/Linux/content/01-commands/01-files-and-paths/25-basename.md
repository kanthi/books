# basename

## Overview

`basename` strips the directory portion (and optionally a suffix) from a path, leaving the final component. It is the complement of `dirname` for simple path surgery in shell scripts — naming logs, deriving output files, and parsing `$0`.

## Syntax

```bash
basename NAME [SUFFIX]
basename OPTION... NAME...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a`, `--multiple` | Treat all arguments as NAMEs |
| `-s SUF`, `--suffix=SUF` | Strip suffix (implies multiple mode when combined properly) |
| `-z`, `--zero` | NUL-terminated output |

Traditional form: `basename /path/to/file.txt .txt` → `file`.

## Key Use Cases

1. Extract filename from a path
2. Strip extensions
3. Derive names from `$0` or CLI args
4. Build sibling output paths in loops
5. Clean display names in logs

## Examples with Explanations

### Basics

```bash
basename /path/to/file.txt
# file.txt
basename /path/to/file.txt .txt
# file
basename /path/to/dir/
# dir
basename /
# /   (or implementation-defined root behavior)
```

### Multiple names

```bash
basename -a /a/b /c/d
basename -a -s .conf /etc/ssh/sshd_config /etc/systemd/logind.conf
```

### Script name

```bash
SCRIPT_NAME=$(basename "$0")
echo "usage: $SCRIPT_NAME [options]"
```

### Strip extension patterns

```bash
f=/data/report.2024.csv
base=$(basename "$f")           # report.2024.csv
stem=$(basename "$f" .csv)      # report.2024
# careful: only strips exact suffix match at end
```

### Loop rename

```bash
for f in /var/log/app/*.log; do
  b=$(basename "$f")
  gzip -c "$f" > "/backup/${b}.gz"
done
```

### Combine with dirname

```bash
path=/opt/app/bin/tool
echo "dir=$(dirname "$path") name=$(basename "$path")"
```

### NUL-safe pipeline

```bash
find . -type f -name '*.md' -print0 |
  while IFS= read -r -d '' f; do
    basename -z "$f"
  done
```

### Parameter expansion alternative

```bash
# bash-only equivalents often used instead of basename
f=/path/to/file.txt
echo "${f##*/}"           # file.txt
echo "${f##*/}" | sed 's/\.txt$//'
# or
b=${f##*/}; echo "${b%.txt}"
```

Builtins avoid spawning `basename` in hot loops.

## Notes / Pitfalls

- Suffix strip requires an **exact** trailing match; `.tar.gz` must be stripped carefully (often twice or with special logic).
- Trailing slashes: GNU `basename` handles them; still quote variables.
- Don’t use for security canonicalization — use `realpath` / proper validation.
- BusyBox `basename` may lack `-a`/`-z`.
- Filenames with newlines need `-z` / careful reading.

## 2026-relevant notes

- In hot path bash, prefer `${var##*/}` over external `basename`.
- Still excellent for readability in admin scripts and one-liners.
- Pair with `realpath` when the path may contain `..` or symlinks before basenaming for display only.

## Related Commands

- `dirname` — parent path
- `realpath` — canonicalize
- `readlink` — resolve links
- bash parameter expansion — `${f##*/}`, `${f%.*}`
- `cut` / `sed` — ad-hoc parsing

## Additional Resources

- `man basename`
