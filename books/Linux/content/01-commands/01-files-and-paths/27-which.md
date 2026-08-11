# which

## Overview

`which` locates executables by searching the `PATH` environment variable and printing the path of the first match. It is a traditional convenience for interactive use. For scripts, prefer **`command -v`** (POSIX) or **`type -P`** (bash) — they integrate better with shell functions, aliases, and builtins.

## Syntax

```bash
which [options] command...
```

Implementations differ (GNU `which`, Debian shell script `which`, BusyBox). Options are **not** fully portable.

## Common Options (GNU / common)

| Option | Description |
|--------|-------------|
| `-a` | Show all matches on `PATH`, not just the first |
| `-s` | Silent; exit status only (some versions) |
| `--version` / `--help` | Version / help (GNU) |

## Key Use Cases

1. Interactive “where is this binary?”
2. See which of several installs comes first (`-a`)
3. Quick sanity check after modifying `PATH`
4. Compare with shell resolution (`type`)

## Examples with Explanations

### Basic

```bash
which python3
which ls
which docker kubectl
```

### All matches

```bash
which -a python3
which -a java
```

Shows shadowing (e.g. `/usr/local/bin` before `/usr/bin`).

### Prefer command -v in scripts

```bash
# good for scripts
if command -v jq >/dev/null 2>&1; then
  jq --version
fi

# bash: PATH only, ignore functions/aliases
if type -P jq >/dev/null; then
  echo "jq binary found"
fi
```

### Compare resolution tools

```bash
type python3
type -a python3
command -v python3
which python3
which -a python3
```

| Tool | Sees aliases | Sees functions | Sees builtins | PATH binaries |
|------|--------------|----------------|---------------|---------------|
| `type` | yes | yes | yes | yes |
| `command -v` | yes* | yes* | yes | yes |
| `which` | often no | no | no | yes |

\*shell-dependent; still better than `which` for “what will run”.

### Debug PATH order

```bash
echo "$PATH" | tr ':' '\n' | nl
which -a node
```

### Silent existence (when -s exists)

```bash
which -s docker && echo present
# portable:
command -v docker >/dev/null && echo present
```

## Notes / Pitfalls

- Debian/Ubuntu historically shipped `which` as a shell script with different flags; don’t rely on GNU-only options in portable scripts.
- `which` may not know about shell aliases/functions you use interactively — misleading for “what runs when I type this”.
- Hashed commands in bash (`hash -r` to clear) affect speed of lookup, not usually `which`’s external search.
- Relative PATH entries (`.` or empty) are a security footgun — `which` will show what they resolve to.
- In login vs non-login shells, `PATH` differs; results differ.

## 2026-relevant notes

- Version managers (asdf, nvm, pyenv, mise) put shims early on `PATH` — `which -a` is useful to see real binaries behind shims.
- Containers often have a minimal PATH; `command -v` in entrypoints is the standard check.
- Prefer documenting `command -v` in runbooks and automation.

## Related Commands

- `command -v` / `command -V` — POSIX resolution
- `type` / `type -a` — bash detailed resolution
- `whereis` — binary/source/man search (rough)
- `ls -l` / `readlink -f` — inspect the binary found
- `enable` — manage bash builtins

## Additional Resources

- `man which` (if present), `help type`, `help command`
