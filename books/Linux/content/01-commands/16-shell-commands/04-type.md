# type / command

## Overview

`type` explains **how the shell will resolve a name** — alias, keyword, function, builtin, or external file. `command` runs a program **bypassing** functions/aliases of the same name (and can query paths). Together they answer: “Why did *that* run?” when `which` alone misleads (it ignores builtins/aliases depending on setup).

## Syntax

```bash
type [-afptP] name [name...]
command [-pVv] command [arg...]
```

## Common Options

### type (bash)

| Option | Description |
|--------|-------------|
| `-a` | All locations / matches |
| `-t` | Single word: `alias`, `keyword`, `function`, `builtin`, `file` |
| `-p` | Path to disk executable if `file` |
| `-P` | Force path search even if non-file |
| `-f` | Suppress function lookup |

### command

| Option | Description |
|--------|-------------|
| `-v` / `-V` | Describe command (similar spirit to `type`) |
| `-p` | Use default PATH search |
| *(default)* | Execute, skipping shell functions/aliases |

## Examples with Explanations

### What is this name?

```bash
type ls
type type
type echo cd time
type -a python3
```

Typical: `ls is aliased to …`, `echo is a shell builtin`, `python3 is /usr/bin/python3`.

### Machine-readable kind

```bash
type -t ls
# alias
type -t mkdir
# file
```

Useful in scripts choosing behavior.

### Path only

```bash
type -p sha256sum
# /usr/bin/sha256sum
```

Empty if pure builtin/alias without a file.

### Run without alias/function

```bash
command ls            # unaliased ls
command -v ls
command -p ls
```

### Compare to which / command -v

```bash
which ls
type ls
command -v ls
```

`which` is an external program and can disagree with the shell’s true resolution — prefer `type`/`command -v` inside bash.

### Debug “wrong binary”

```bash
type -a node
echo "$PATH"
```

Multiple `file` hits show PATH order; the first is used for external commands.

## Notes

- Keywords (`if`, `for`) are not executables — `type` reports `keyword`.
- Hashed paths: bash caches external locations (`hash`); after moves, `hash -r` refreshes.
- `command` is also the safe way to call externals from functions named the same.
- Dash/`sh` may have fewer `type` features — check `help type` in your shell.

## Related Commands

- `which` / `whereis` — external path helpers
- `alias` — define aliases
- `hash` — bash command path cache
- `export` / `env` — PATH and environment

## Additional Resources

- `help type`, `help command`
- `man bash`
