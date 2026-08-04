# Help and documentation tools

This part covers how to find answers **on the system itself** before searching the web. Offline docs match the versions you actually installed — critical when flags change between releases.

## Commands in this part

| Command | Role |
|---------|------|
| `man` | Full manuals by section |
| `info` | Texinfo hypertext manuals (GNU depth) |
| `help` | Shell builtin help (`bash` / similar) |
| `whatis` | One-line man summaries (`man -f`) |
| `apropos` | Keyword search of man names/descriptions (`man -k`) |

## Suggested workflow

1. **Quick hint:** `whatis cmd` or `cmd --help`.
2. **Full story:** `man cmd`; try `man 5 name` / `man 8 name` for configs and admin tools.
3. **Forgot the name:** `apropos keyword` (then open the best hit with `man`).
4. **GNU deep dive:** `info coreutils`, `info bash`, or `info <tool>`.
5. **Shell builtin:** `type cmd` then `help cmd` if it is a builtin.
6. Optional community cheat sheets (`tldr`, `cheat`) if installed — never a substitute for `man` on production flags.

## Shell builtins vs external commands

```bash
type ls                 # external path (usually)
type cd                 # builtin
type -a kill            # often both
help cd                 # builtin docs
man ls                  # external manual
ls --help               # short flags from the binary
```

| Kind | Where docs live |
|------|-----------------|
| Builtin (`cd`, `[[`, `declare`) | `help`, `man bash` |
| External (`ls`, `ip`, `systemctl`) | `man`, often `--help`, sometimes `info` |
| Config formats | `man 5 …` |
| Admin tools | `man 8 …` |

## Rebuild the man index when search is empty

```bash
sudo mandb
whatis ls
apropos network
```

Minimal containers may lack man pages entirely — install `man-db` and documentation packages, or read docs on a fuller host.

## Practical one-liners

```bash
# What package owns this binary? (Debian/Ubuntu)
dpkg -S "$(command -v systemctl)"

# Dump a man page to text
man systemctl | col -b > /tmp/systemctl.txt

# Search descriptions, then open
man -k nftables | head
man 8 nft

# Builtin inventory (bash)
compgen -b | less
```

## Notes / Pitfalls

- Web search returns flags for **other** distro versions; confirm with local `man`.
- Translated pages can be incomplete — `LANG=C man …` forces English.
- `apropos` / `whatis` need a fresh `mandb` after big package installs.
- Prefer modern tools in examples you follow: `ip`/`ss` over `ifconfig`/`netstat`, `systemctl`/`journalctl` over sysv-only docs, unless you are on a legacy host.

## 2026-relevant notes

- Systemd, iproute2, Podman, and nftables man pages are first-class; learn to read them.
- AI assistants help discovery; **verify** destructive or network-facing flags against local manuals.
- Immutable and container OSes may ship stripped docs — keep a documentation environment handy.

## Related Commands

- Individual pages: `man`, `info`, `help`, `apropos`, `whatis`
- `type` / `command -v` — resolve names
- `mandb` — rebuild whatis database

Continue with the individual command pages in this part.
