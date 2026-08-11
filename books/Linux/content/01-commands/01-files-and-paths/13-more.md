# more

## Overview

`more` is a simple historical **pager** that displays text one screen at a time. On modern Linux, **`less` is almost always the better interactive choice** (bi-directional scroll, better search). `more` remains useful for POSIX familiarity, tiny environments, and scripts that expect the classic pager name.

## Syntax

```bash
more [options] [file ...]
command | more
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d` | Prompt with more helpful “press space” text |
| `-f` | Count logical lines (don’t fold long lines as multiple) |
| `-l` | Do not treat form-feed specially |
| `-c` / `-p` | Paint from top / clear then show (terminal-dependent) |
| `-s` | Squeeze multiple blank lines |
| `-u` | Suppress underlining |
| `+num` | Start at line number |
| `+/pattern` | Start at pattern |
| `-n num` | Screen size (lines) |

Feature sets differ between implementations (util-linux vs BSD heritage).

## Common keys

| Key | Action |
|-----|--------|
| `Space` | Next page |
| `Enter` | Next line |
| `q` | Quit |
| `/pattern` | Search (implementation-dependent) |
| `h` | Help (if supported) |
| `b` | Back (often **not** available in classic more) |

Limited backward movement is the classic reason people switch to `less`.

## Examples with Explanations

### Basic

```bash
more /etc/os-release
more +20 /var/log/dmesg
more +/failed /var/log/syslog
```

### Pipelines

```bash
dmesg | more
seq 1 200 | more
ls -l /usr/bin | more
```

### Prefer less when available

```bash
# interactive systems
less /var/log/syslog

# force more only if required
PAGER=more man ls
```

### Start position

```bash
more +100 /var/log/kern.log
more +/error app.log
```

### Tiny environments

```bash
# busybox / recovery shells may only have more
more /etc/passwd
```

### Compare pagers

```bash
printf '%s\n' {1..200} | more
printf '%s\n' {1..200} | less
```

Notice bidirectional movement and search comfort in `less`.

## Notes / Pitfalls

- Default `PAGER` / `MANPAGER` on desktop distros is usually `less`, not `more`.
- Behavior of flags is **less portable** than many coreutils tools.
- Not ideal for huge logs; still reads sequentially.
- Some `more` versions exit automatically at EOF when not a tty — good for scripts, surprising interactively.
- Teaching material still mentions `more`; production muscle memory should favor `less`.

## 2026-relevant notes

- Recovery initramfs and busybox environments may ship `more` only — know both.
- `systemctl` / `journalctl` respect `$SYSTEMD_PAGER` / `$PAGER`; set to `less -R` for color.
- Don’t write new tooling that requires `more`-specific keybindings.

## Related Commands

- `less` — preferred full-featured pager
- `most` — alternate pager
- `bat` — highlighting viewer
- `pg` — historical pager (rare)
- `cat` — dump entire file

## Additional Resources

- `man more`
