# help (shell builtin)

## Overview

`help` shows documentation for **shell builtins** — commands implemented inside the shell itself (`cd`, `export`, `read`, `[[`, `declare`, job control, etc.), not as separate binaries under `/usr/bin`. External programs use `--help` or `man` instead.

If `man cd` looks wrong or minimal, you are probably looking at a stub; the real reference is `help cd` (bash) or the shell’s own manual.

## Syntax

```bash
help [-dms] [pattern ...]
```

Bash-oriented options (check `help help` on your shell):

| Option | Description |
|--------|-------------|
| `-d` | Short description only |
| `-m` | Manpage-like layout |
| `-s` | Short usage synopsis |
| *pattern* | Builtin name or pattern to match |

## Common Options / discovery helpers

| Command | Description |
|---------|-------------|
| `help` | List topics / usage overview |
| `help name` | Full builtin help |
| `type name` | How the shell resolves `name` |
| `type -a name` | All candidates (builtin + PATH) |
| `command -v name` | Path or builtin indicator |
| `compgen -b` | List bash builtins |
| `enable -a` | Enabled/disabled builtins |

## Examples with Explanations

### Read builtin docs

```bash
help cd
help [[
help declare
help read
help -m printf          # man-like layout for the builtin printf
help | less             # browse all topics
```

### Builtin vs external

```bash
type cd                 # builtin
type ls                 # usually /usr/bin/ls (hashed)
type -a echo            # may show builtin and /usr/bin/echo
type -a kill            # often both: shell kill + /bin/kill
help cd                 # works for builtin
ls --help               # external GNU flag
man ls                  # full external manual
```

Prefer `type` / `command -v` in scripts over `which` for resolving names.

### List builtins (bash)

```bash
compgen -b | column
compgen -b | grep -E '^(cd|pushd|popd|dirs)$'
enable -a | head
```

### Disable / re-enable a builtin (rare, debugging)

```bash
enable -n echo          # force external echo next
type echo
enable echo             # restore builtin
```

Useful when testing whether a weird `echo` behavior comes from the builtin or a shadowed binary.

### Conditional help in interactive setups

```bash
# only define an alias if the real command exists
if type -P rg >/dev/null; then
  alias grep='rg'
fi
```

`type -P` searches PATH only (ignores builtins/aliases/functions).

### Job-control and shell language topics

```bash
help jobs
help fg
help bg
help wait
help trap
help set
help shopt
```

These are not separate man pages in the same way; learn them via `help` + `man bash`.

## Notes / Pitfalls

- `help` is primarily for **interactive** humans. Non-interactive scripts still *run* builtins; they just don’t need `help`.
- **zsh** uses `run-help` (often bound to `Esc-h`) and different docs; **fish** integrates web/local docs under `help`.
- `help printf` is the **shell** printf; `man 1 printf` / `man 3 printf` are different tools/APIs.
- Aliases and functions shadow names: `type foo` before assuming you are reading the right help.
- BusyBox / dash environments have smaller builtin sets; don’t assume full bash `help` text.

## 2026-relevant notes

- Bash 5.x remains the default interactive shell on many servers; `help` text tracks your installed bash, not a website.
- For deep language reference (arrays, coprocs, `mapfile`, loadable builtins), combine `help` with `man bash` / `info bash`.
- In containers, shells are often `bash` or `sh` → `dash`; verify with `echo $0` and `help` availability.

## Related Commands

- `man bash` / `info bash` — full shell language reference
- `type` / `command -V` — resolve names
- `whatis` / `man` — external commands
- `compgen` / `complete` — completion and name generation
- `set` / `shopt` — shell options (see `help set`)

## Additional Resources

- `help help`, `man bash`
- [Bash Reference Manual](https://www.gnu.org/software/bash/manual/)
