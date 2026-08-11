# pidof

## Overview

`pidof` prints the PIDs of running programs matched by name. It is a quick alternative to `pgrep -x` for simple lookups and remains common in init scripts and one-liners. For flexible pattern matching, prefer `pgrep`.

## Syntax

```bash
pidof [options] program [program...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-s` | Single PID only (first/one) |
| `-c` | Only processes with same root (chroot) |
| `-x` | Also match scripts (by script name) |
| `-o omitpid` | Omit PID(s); often `-o %PPID` or self |
| `-z` | Skip zombies (when supported) |

Options vary slightly between implementations (sysvinit-utils vs others).

## Examples with Explanations

### Basics

```bash
pidof nginx
pidof sshd
pidof bash
```

### Single PID

```bash
pidof -s nginx
kill -HUP "$(pidof -s nginx)"
```

### Scripts

```bash
pidof -x backup.sh
pgrep -f backup.sh          # often clearer for scripts
```

### Existence gate

```bash
if pidof dockerd >/dev/null; then
  echo docker running
fi
```

### Omit PIDs

```bash
pidof -o $$ bash            # other bashes, not this script’s shell if named bash
pidof -o %PPID nginx
```

### Feed to kill

```bash
kill $(pidof myapp)
# safer with pgrep:
pgrep -x myapp | xargs -r kill
```

### Compare tools

```bash
pidof nginx
pgrep -x nginx
pgrep -a nginx
systemctl status nginx
```

## Notes / Pitfalls

- Name matching is not always exact across threads/workers — verify with `ps`.
- Multiple PIDs print space-separated — quote carefully in scripts.
- Race: process may exit between `pidof` and `kill`.
- Containers: only sees processes in the same PID namespace.
- Prefer `systemctl` for supervised services instead of raw PID kills.

## 2026-relevant notes

- systemd units: `systemctl show -p MainPID nginx`.
- `pgrep`/`pkill` from procps are more expressive for modern scripts.
- Rootless stacks may have multiple same-named processes per user — be specific.

## Related Commands

- `pgrep` / `pkill` — pattern match / signal
- `kill` / `killall` — signal by PID / name
- `ps` — detailed process list
- `systemctl` — service PIDs
- `pidwait` / `pwait` — wait for PID exit (if installed)

## Additional Resources

- `man pidof`
