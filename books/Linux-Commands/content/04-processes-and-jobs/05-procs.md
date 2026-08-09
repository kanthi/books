# procs

## Overview

`procs` is a modern replacement for `ps` written in Rust, with colorized output, tree views, keyword highlighting, and friendlier defaults. Optional install (`cargo install procs`, distro packages). Keep `ps` for portability and scripts.

## Syntax

```bash
procs [options] [query...]
procs --help
```

## Common Options

| Option | Description |
|--------|-------------|
| `-a`, `--and` | All keywords must match |
| `-o`, `--or` | Any keyword (default-ish behavior depends version) |
| `-d`, `--tree` | Tree view |
| `-w`, `--watch` | Watch mode refresh |
| `-p`, `--pager` | Use pager |
| `--sortd KEY` / `--sorta KEY` | Sort descending/ascending |
| `--only COL` | Show specific columns |
| `--insert COL` | Add columns |
| `--json` | JSON output |
| `--color` | Color mode |
| `query` | Filter by keyword (command, user, …) |

Flags evolve quickly — check `procs --help` for your version.

## Examples with Explanations

### Everyday

```bash
procs
procs nginx
procs alice
procs --tree
procs -w
```

### Sorting

```bash
procs --sortd cpu
procs --sortd mem
procs --sorta pid
```

### Columns

```bash
procs --only pid,user,cmd
procs --insert tcp,udp
```

### JSON for tooling

```bash
procs --json nginx | jq .
```

### Compare with ps

```bash
ps aux | head
procs
ps -fp $(pgrep -d, nginx)
procs nginx
```

### Watch like top (lightweight)

```bash
procs -w
# or
watch -n1 procs --sortd cpu
```

## Notes / Pitfalls

- Not installed by default on servers — don’t require it in production scripts.
- Keyword filtering is convenience, not a security boundary.
- Column names differ from `ps` — learn the map once.
- JSON schema may change across versions; pin version in automation.
- Permissions still limit visibility of other users’ full command lines.

## 2026-relevant notes

- Part of the modern CLI set with `bat`, `eza`, `fd`, `rg`, `btop`.
- For portable ops docs, show `ps` equivalents alongside `procs`.
- Prefer `pgrep`/`systemctl` for scripting; use `procs` interactively.

## Related Commands

- `ps` — portable process status
- `pgrep` / `pkill` — match / signal
- `top` / `htop` / `btop` — interactive monitors
- `pstree` — tree view
- `pidof` — PIDs by name

## Additional Resources

- `procs --help`
- [dalance/procs](https://github.com/dalance/procs)
