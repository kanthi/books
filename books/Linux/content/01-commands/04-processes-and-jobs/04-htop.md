# htop

## Overview

`htop` is an interactive process viewer with a clearer UI than classic `top`: mouse support, tree view, easy search/filter, color meters, and safer multi-select kill. It is **not** always installed by default on Ubuntu servers — install with `apt`. For automation, keep using `ps`/`pgrep`; `htop` is for humans at a terminal.

## Syntax

```bash
htop [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d DELAY` | Update delay in **tenths** of a second (`-d 10` ≈ 1s) |
| `-u USER` | Show only this user |
| `-p PID[,PID…]` | Restrict to these PIDs |
| `-t`, `--tree` | Start in tree view |
| `-C`, `--no-color` | Monochrome |
| `-s COLUMN` | Sort by column name |
| `-H DEPTH` | Hide threads beyond depth (version-dependent) |

Install on Ubuntu:

```bash
sudo apt update
sudo apt install htop
```

## Useful keys

| Key | Action |
|-----|--------|
| `F1` / `h` | Help |
| `F2` / `S` | Setup (meters, columns, display options) |
| `F3` / `/` | Search |
| `F4` / `\` | Filter (hide non-matches) |
| `F5` / `t` | Tree view |
| `F6` / `>` | Choose sort column |
| `F7` / `F8` | Decrease / increase nice |
| `F9` / `k` | Kill — pick signal from a list (**prefer TERM**) |
| `Space` | Tag process |
| `c` | Tag process **and** its children (with tree) |
| `U` | Untag all |
| `u` | User filter |
| `H` | Hide user threads |
| `K` | Hide kernel threads |
| `M` / `P` / `T` | Sort memory / CPU / time |
| `p` | Show full paths |
| `I` | Invert sort |
| `l` | List open files (`lsof`) if available |
| `s` | `strace` selected process (if permitted) |
| `q` | Quit |

## Key Use Cases

1. Interactive incident triage with filters and trees
2. Finding the parent of a worker storm
3. Niceness tweaks and careful multi-process kill
4. Per-user resource glance on shared hosts

## Examples with Explanations

### Example: start htop

```bash
htop
```

Meters at the top, process table below. Use mouse or keys to select rows.

### Example: only your processes

```bash
htop -u "$USER"
```

Cuts system noise during personal debugging.

### Example: tree view for process storms

```bash
htop -t
# or press F5 inside htop
```

Parent/child relationships show which master spawned runaway workers.

### Example: attach to known PIDs

```bash
htop -p "$(pgrep -d, nginx)"
```

Focuses the display on nginx-related PIDs only.

### Example: slower refresh on overloaded boxes

```bash
htop -d 20
```

Two-second delay (20 tenths) reduces sampling cost while you think.

### Example: kill workflow inside htop

1. Filter with `F4` or search with `F3`
2. Tag targets with `Space` (optional)
3. `F9` / `k` → choose **`SIGTERM`** first
4. Wait; only then send **`SIGKILL`** to leftovers

Never default to SIGKILL out of habit.

### Example: nice a batch job interactively

Select the process → `F8` a few times to make it friendlier (higher nice), or `F7` if you have privilege to make it more aggressive.

### Example: setup persistence

`F2` → adjust CPU meter style, add columns (`IO_RATE`, `STARTTIME`, …) → leave setup; htop writes `~/.config/htop/htoprc` automatically on exit in modern versions.

## Understanding Output

- **CPU bars** — per-core usage; colors distinguish user/system/irq/nice/io-wait/steal depending on version and setup.
- **Memory bar** — used vs buffers/cache; green/blue conventions differ from `free` wording but convey pressure.
- **Load average** — same kernel figures as `uptime`/`top`.
- **Process states** — same single-letter codes as `ps` (`R`, `S`, `D`, `Z`, `T`, …).

## Notes & Pitfalls

- Not for scripts: output is interactive and not a stable API.
- Kill and renice still obey **permissions** — root for others’ processes and for negative nice.
- Kernel threads clutter the view; toggle `K`/`H` for clarity.
- Container hosts: PIDs may be host-namespaced depending on where you run `htop`.
- Alternatives: `btop` (pretty), `atop` (historical accounting), classic `top` (always there).

## Related Commands

- `top` — ubiquitous interactive monitor
- `btop` — modern TUI alternative
- `ps` / `pgrep` — snapshots and selection
- `vmstat` / `iostat` / `pidstat` — subsystem rates
- `nice` / `renice` / `ionice` — priority controls

## Additional Resources

- `man htop`
- [htop.dev](https://htop.dev/)
