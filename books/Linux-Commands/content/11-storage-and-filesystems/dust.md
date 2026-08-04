# dust

## Overview

`dust` is a modern **`du` alternative** that shows disk usage as a readable tree/bars, helping you find large directories quickly. Written in Rust; optional install. For portable scripts use `du -sh`; for interactive TUI browsing also consider `ncdu`.

## Syntax

```bash
dust [options] [directory...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d DEPTH`, `--depth` | Max depth |
| `-n N`, `--number-of-lines` | Entries to show |
| `-r`, `--reverse` | Reverse natural order |
| `-p`, `--full-paths` | Full paths |
| `-s`, `--apparent-size` | Apparent size vs allocated |
| `-i`, `--ignore-directory` | Ignore path |
| `-X file` | Ignore from file |
| `-e`, `--filter` | Include only matching names |
| `-v`, `--invert-filter` | Invert filter |
| `-c`, `--no-colors` | Disable colors |
| `-b`, `--no-percent-bars` | No bars |
| `-z`, `--min-size` | Min size threshold |
| `-t`, `--file-types` | Group by filetype |
| `-w`, `--terminal-width` | Width |

Check `dust --help` for current flags.

## Examples with Explanations

### Find big directories

```bash
dust
dust -d 2 /var
dust -n 30 /home
```

### Apparent size

```bash
dust -s
du -sh --apparent-size *
```

### Ignore noise

```bash
dust -i node_modules -i .git
dust -X .dustignore
```

### File types

```bash
dust -t
```

### Compare with du / ncdu

```bash
du -h -d 1 /var | sort -h
dust -d 1 /var
ncdu /var
```

### Min size filter

```bash
dust -z 100M /
```

### Scripts: stick to du

```bash
du -sb /var/lib/docker
# dust is for humans
```

## Notes / Pitfalls

- Permission errors on other users’ dirs skew totals — run with appropriate rights.
- Hard links / snapshots / sparse files: understand apparent vs allocated.
- Network filesystems: slow; prefer scoped paths.
- Not preinstalled on servers.
- Colors in pipes may need `-c`.

## 2026-relevant notes

- Great laptop/dev host tool; production forensics still document `du`/`find`.
- Container disk growth: dust the overlay/graph roots carefully with host tools.
- Pair with `duf` for free space vs `dust` for “what ate it”.

## Related Commands

- `du` — portable usage
- `ncdu` — interactive TUI
- `duf` / `df` — free space
- `find -size` — size predicates
- `btrfs filesystem du` — special FS accounting

## Additional Resources

- `dust --help`
- [bootandy/dust](https://github.com/bootandy/dust)
