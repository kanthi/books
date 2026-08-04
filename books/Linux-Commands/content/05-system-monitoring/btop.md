# btop

## Overview

`btop` is a modern, interactive resource monitor with a polished TUI: CPU (often per-core with clocks/temps when available), memory, disks, network, and a process list. It sits in the same family as `htop` and `bashtop`/`bpytop`, with a denser visual layout.

```bash
sudo apt install btop    # Debian/Ubuntu when packaged
sudo dnf install btop
# or install from upstream releases if your distro lags
```

## Syntax

```bash
btop [options]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-lc`, `--low-color` | 16-color / limited terminals |
| `-t`, `--tty` | Force tty-friendly mode (check `--help` on your build) |
| `--utf-force` | Force UTF-8 drawing |
| `-p`, `--preset N` | Start with layout preset |
| `-u`, `--update MS` | Refresh rate in milliseconds |
| `-h`, `--help` | Help |

Exact flags vary slightly by version—run `btop -h`.

## Interactive Keybindings (typical)

| Key | Action |
|-----|--------|
| `↑` `↓` / `j` `k` | Move process selection |
| `Enter` | Process details / options |
| `f` | Filter processes |
| `m` | Memory-related layout toggle |
| `p` | Process sort / panel focus (version-dependent) |
| `k` or signal menu | Kill / send signal to selected process |
| `t` | Tree view (if enabled in version) |
| `FF2` / preset keys | Cycle presets |
| `Esc` / `q` | Back / quit |
| `?` or `h` | Help overlay |

If a key does nothing, open the in-app help—bindings are configurable.

## Key Use Cases

1. At-a-glance host health on a jump box
2. Spot CPU steal, memory pressure, or disk saturation visually
3. Find and signal runaway processes without remembering `ps` pipelines
4. Live network throughput per interface

## Examples with Explanations

### Start defaults

```bash
btop
```

### Low-color SSH / serial console

```bash
btop --low-color
# or
btop -lc
```

### Faster or slower refresh

```bash
btop -u 500
btop -u 2000
```

### One-liner recipes

```bash
# Prefer btop when available, else htop, else top
command -v btop >/dev/null && btop || command -v htop >/dev/null && htop || top

# Record a note of load while viewing (separate terminal)
while true; do printf '%s %s\n' "$(date -Iseconds)" "$(cat /proc/loadavg)"; sleep 5; done
```

## Notes & Pitfalls

- **Remote SSH**: needs a reasonable terminal (xterm-256color, width). Tiny terminals break layout—use `-lc` or resize.
- **Sensors/temps**: may need `lm-sensors` configured; containers often lack host sensors.
- **Permissions**: process details and some disk stats are richer as root but daily use as normal user is fine.
- **Not a logger**: for historical metrics use Prometheus node exporter, Netdata, or `sar`.
- Config usually lives under `~/.config/btop/`—back it up if you customize themes heavily.

## 2026-relevant notes

- `btop` is a strong default **interactive** monitor; keep `htop` for muscle memory and `top` for universal availability on rescue images.
- On servers, pair TUI tools with **`journalctl -f`**, **`ss -lntp`**, and **`dmesg -T`** rather than expecting one dashboard to explain outages.
- In Kubernetes/node shells, metrics may reflect the container cgroup, not the whole node—interpret carefully.

## Comparison to alternatives

| Tool | Notes |
|------|-------|
| `btop` | Modern TUI, visual meters |
| `htop` | Ubiquitous interactive process focus |
| `top` | Always there, minimal |
| `glances` | Cross-platform, optional web UI |
| `btm` / `zenith` | Other modern Rust/Go monitors |

## Related Commands

- `top` / `htop` — process monitors
- `vmstat` / `iostat` / `mpstat` — batch subsystem stats
- `nproc` / `free` / `df` — quick non-interactive checks
- `perf top` — function-level CPU profiling

## Additional Resources

- Upstream `btop` README for install and themes
- `man btop` when packaged
