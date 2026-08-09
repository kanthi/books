# pushd / popd / dirs

## Overview

`pushd`, `popd`, and `dirs` maintain a **directory stack** in bash. `pushd` changes directory and pushes the previous location; `popd` returns; `dirs` lists the stack. Handy when hopping between build trees, config dirs, and logs without losing your place. For a single previous directory, `cd -` is enough.

Light operator page — stack gymnastics in large scripts belong in ShellScripting practices.

## Syntax

```bash
pushd [dir]
pushd +N | -N
popd
popd +N | -N
dirs [-clpv] [+N | -N]
```

## Common Options

### dirs

| Option | Description |
|--------|-------------|
| `-l` | Long paths (no `~` abbreviation) |
| `-p` | One entry per line |
| `-v` | Numbered list |
| `-c` | Clear stack (bash) |

### pushd / popd

| Form | Description |
|------|-------------|
| `pushd dir` | Push current, `cd` to `dir` |
| `pushd` | Swap top two entries |
| `pushd +N` / `-N` | Rotate stack |
| `popd` | Pop top and `cd` there |
| `popd +N` | Delete Nth entry without rotating to it (see help) |

`set -o` / `shopt` can affect `cd` behavior (`cdspell`, `autocd`); stack commands still need valid paths.

## Examples with Explanations

### Jump and return

```bash
pwd
pushd /var/log
# ... inspect logs ...
popd
pwd
```

### Nested hops

```bash
pushd /etc/nginx
pushd /etc/ssl/certs
dirs -v
popd
popd
```

### List the stack

```bash
dirs
dirs -v
dirs -l -p
```

### Swap two project roots

```bash
cd ~/src/app
pushd ~/src/infra
pushd              # swap top two
```

### Numbered rotation

```bash
dirs -v
pushd +2           # bring entry 2 to top and cd
```

### Clear

```bash
dirs -c
```

## Notes

- Stack is **per shell session** — not shared across terminals.
- Failed `pushd` to a bad path usually leaves the stack unchanged (bash) — still verify `pwd`.
- Prefer absolute paths in muscle memory when trees are deep and symlinked.
- `CDPATH` can make `pushd some-name` resolve in unexpected directories — know if you set it.
- Fish/zsh have similar but not identical stack commands.

## Related Commands

- `cd` / `pwd` — basic navigation
- `cd -` — previous directory only
- `realpath` / `readlink -f` — resolve paths
- `tree` / `ls` — inspect destinations

## Additional Resources

- `help pushd`, `help popd`, `help dirs`
- `man bash` (DIRECTORY STACK)
