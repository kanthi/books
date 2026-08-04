# column

## Overview

`column` formats text into aligned columns or a table. Ideal for making command output or colon-separated files readable. Commonly used with `mount`, `fstab`-like data, and custom script output. From `util-linux`.

## Syntax

```bash
column [options] [file...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-t`, `--table` | Create a table; determine columns automatically |
| `-s sep`, `--separator` | Input separator characters |
| `-o sep`, `--output-separator` | Output separator (default two spaces) |
| `-N names` | Column names header (newer) |
| `-R cols` | Right-align columns |
| `-J` | JSON output (newer util-linux) |
| `-x` | Fill columns before rows |
| `-c width` | Output width |
| `-n` | Disable “merge empty columns” behavior variants |
| `-l num` | Max columns keep (see man) |

## Examples with Explanations

### Table-ize whitespace

```bash
mount | column -t
df -h | column -t
ps -eo pid,user,comm,%cpu --sort=-%cpu | head | column -t
```

### Custom separators

```bash
column -t -s: /etc/passwd | less
echo -e 'a|b|c\n1|2|3' | column -t -s'|'
```

### Headers (newer)

```bash
printf 'user:uid:shell\nalice:1000:/bin/bash\n' | column -t -s: -N USER,UID,SHELL
```

### Right-align numbers

```bash
printf 'name val\na 10\nbb 3\n' | column -t -R 2
```

### JSON (when available)

```bash
mount | column -t -J | jq .
```

### Pretty fstab view

```bash
grep -vE '^\s*(#|$)' /etc/fstab | column -t
```

### Pipelines

```bash
systemctl list-units --type=service --state=running | column -t
```

## Notes / Pitfalls

- Input with inconsistent field counts produces jagged tables — clean data first.
- Wide Unicode can misalign in some terminals.
- Default without `-t` wraps differently (classic column mode) — for tables always use `-t`.
- Features like `-N`/`-J` need sufficiently new util-linux.
- Don’t use as a CSV parser for complex quoting — use `csvkit`/`python` for real CSV.

## 2026-relevant notes

- Still the fastest path to readable admin tables over SSH.
- JSON mode helps bridge to `jq` tooling when available.
- For TUI tables, tools like `procs`/`eza` already format themselves.

## Related Commands

- `awk` / `cut` / `paste` — field extraction/combine
- `rs` — reshape (BSD/some systems)
- `jq` -C / `column` — JSON vs text
- `tabs` / `expand` — tab handling
- `printf` — manual formatting

## Additional Resources

- `man column`
