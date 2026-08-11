# pwd

## Overview

`pwd` (print working directory) writes the absolute path of the current directory. Shells often implement `pwd` as a **builtin** that can show a **logical** path (may include symlink components via `$PWD`) or a **physical** path (symlinks resolved).

Use it after deep navigation, in scripts that log context, and whenever logical vs physical paths matter (bind mounts, symlinked project roots).

## Syntax

```bash
pwd [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-L` | Logical path (`$PWD`; may retain symlink names) — often default for the builtin |
| `-P` | Physical path (resolve all symlinks) |
| `--help` | Help (external `/bin/pwd`) |

`help pwd` documents the **bash builtin**; `man pwd` documents the external binary. Behavior can differ slightly.

## Key Use Cases

1. Confirm location after many `cd`s
2. Capture cwd in scripts and logs
3. Compare logical vs physical paths through symlink trees
4. Build absolute paths for configs and tooling
5. Debug “wrong directory” issues in containers and chroots

## Examples with Explanations

### Basics

```bash
pwd
pwd -P
pwd -L
type pwd                 # builtin or external?
/bin/pwd -P              # force external binary
```

### Capture in scripts

```bash
current_dir=$(pwd)
current_dir=$PWD           # logical; no subprocess
phys=$(pwd -P)
echo "running in $phys"
```

Prefer `"$PWD"` when you want the logical path without spawning a process; call `pwd -P` when you need the real path.

### Symlink illustration

```bash
mkdir -p /tmp/realdir
ln -sfn /tmp/realdir /tmp/linkdir
cd /tmp/linkdir
pwd -L    # often /tmp/linkdir
pwd -P    # /tmp/realdir
ls -ld .  # may still show link path depending on tools
```

### Prompt and logging recipes

```bash
# Show physical path in a custom prompt experiment
PS1='\u@\h $(pwd -P)$ '

# Log absolute cwd with a command
echo "$(date -Is) cwd=$(pwd -P) cmd=$*" >> ~/cmd.log
```

### Resolve then act

```bash
# Ensure absolute before relative ops
cd "$(pwd)/subdir"

# Physical home resolution
cd -P ~
pwd -P

# Fail if cwd vanished (deleted out from under the shell)
pwd -P || echo "cwd invalid"
```

### Compare with realpath

```bash
pwd -P
realpath .
realpath -e .
```

`realpath .` is often equivalent to physical cwd; `realpath` also works on arbitrary paths, not just cwd.

### Directory stack awareness

```bash
pushd /var/log >/dev/null
pwd
popd >/dev/null
pwd
dirs -v
```

## Notes / Pitfalls

- Builtin vs `/bin/pwd` can disagree on default `-L`/`-P` semantics; check `type pwd` and `help pwd`.
- If the directory was deleted while you were inside it, `pwd` may error or show a stale `$PWD`.
- Don’t mix logical and physical paths blindly in scripts (e.g. `cd` by logical path, then `pwd -P` for logs).
- `cd` following symlinks leaves a logical path unless you use `cd -P` or `set -o physical` (bash).
- In subshells, cwd changes don’t affect the parent: `(cd /tmp && pwd)` vs later `pwd`.

## 2026-relevant notes

- Containers: `WORKDIR` in the image defines initial cwd; `pwd` inside the container reflects that namespace’s mounts.
- Network filesystems and bind mounts: physical paths help correlate with host mounts (`findmnt`, `df`).
- Pair with `realpath` for **file** paths; reserve `pwd` for **directory** context.

## Related Commands

- `cd` — change directory
- `realpath` — resolve arbitrary paths
- `readlink -f` — canonical path (GNU)
- `dirname` / `basename` — split path components
- `ls` — list contents
- `findmnt` — what is mounted where

## Additional Resources

- `help pwd` (bash), `man pwd`
