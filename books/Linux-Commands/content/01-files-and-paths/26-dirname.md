# dirname

## Overview

`dirname` removes the last path component, returning the directory portion of a path. Together with `basename` it covers most shell path-splitting needs: locating a script’s directory, ensuring parent dirs exist, and computing sibling paths.

## Syntax

```bash
dirname [OPTION] NAME...
```

## Common Options

| Option | Description |
|--------|-------------|
| `-z`, `--zero` | NUL-terminated output |

GNU coreutils accepts multiple NAME arguments and prints one line each.

## Key Use Cases

1. Find a script’s directory
2. `mkdir -p` parents before writing a file
3. Compute sibling paths
4. Normalize path structure in scripts
5. Logging / display of parent locations

## Examples with Explanations

### Basics

```bash
dirname /path/to/file.txt
# /path/to
dirname file.txt
# .
dirname /usr/local/bin/
# /usr/local
dirname /usr
# /
dirname /
# /
```

### Multiple arguments

```bash
dirname /a/b /c/d/e
```

### Script directory pattern

```bash
#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
# better when $0 is a symlink:
SCRIPT_DIR=$(cd "$(dirname "$(readlink -f "$0")")" && pwd)
cd "$SCRIPT_DIR"
```

### Ensure parent exists

```bash
out=/var/lib/myapp/data/file.db
mkdir -p "$(dirname "$out")"
touch "$out"
```

### Sibling paths

```bash
conf=/etc/myapp/app.conf
dir=$(dirname "$conf")
cp "$conf" "$dir/app.conf.bak"
```

### Combine with realpath

```bash
abs=$(realpath -m "$1")
parent=$(dirname "$abs")
```

### Parameter expansion alternative (bash)

```bash
f=/path/to/file.txt
echo "${f%/*}"            # /path/to  (careful with no-slash cases)
# dirname is safer for edge cases like no slash → "."
```

### NUL-safe

```bash
find /etc -name '*.conf' -print0 |
  xargs -0 -n1 dirname |
  sort -u
```

## Notes / Pitfalls

- `dirname file` (no slash) → `.` not empty string — important for `cd`.
- Trailing slashes are normalized by GNU dirname.
- Don’t implement security checks with string dirname alone; canonicalize first.
- Hot loops: bash `${f%/*}` is faster but handle “no slash” yourself.
- `dirname` does not require the path to exist.

## 2026-relevant notes

- Still the readable choice in installer and devops shell scripts.
- For complex path logic, consider Python/`pathlib` in larger tools.
- Pair with `realpath -m` when creating outputs under computed absolute parents.

## Related Commands

- `basename` — final component
- `realpath` — canonicalize
- `readlink -f` — resolve script path
- `mkdir -p` — create parents
- `cd` / `pwd` — navigate and display
- bash expansions — `${f%/*}`

## Additional Resources

- `man dirname`
