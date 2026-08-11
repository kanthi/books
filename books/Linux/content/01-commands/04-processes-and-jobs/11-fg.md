# fg

## Overview

`fg` resumes a job in the **foreground**, giving it the terminal again (stdin/stdout/signals). Use it to continue a stopped job interactively or to pull a background job back for interaction.

## Syntax

```bash
fg [job_spec]
```

Default is the current job (`%+`).

## Job specification

| Spec | Meaning |
|------|---------|
| `%n` | Job number n |
| `%name` | Command begins with name |
| `%?str` | Command contains str |
| `%%` / `%+` | Current |
| `%-` | Previous |

## Examples with Explanations

### After Ctrl-Z

```bash
vim bigfile.txt
# Ctrl-Z
jobs
fg
# or
fg %vim
```

Classic suspend-and-resume editor workflow.

### Pull background job forward

```bash
./server &
jobs -l
fg %1
# Ctrl-C now kills the server (foreground signals)
```

### Switch between jobs

```bash
jobs
fg %1
# Ctrl-Z
fg %2
```

### With pipelines

```bash
tar czf - dir | ssh host 'cat > backup.tgz' &
jobs
fg %1
```

### Script note

```bash
set -m
sleep 5 &
fg %1
```

Usually unnecessary — scripts should `wait` on PIDs instead.

## Notes / Pitfalls

- Only jobs of the current shell.
- Foreground job receives terminal-generated signals (`Ctrl-C` → SIGINT, `Ctrl-Z` → SIGTSTP).
- If job is already foreground, `fg` errors.
- Background jobs needing stdin will stop with SIGTTIN — `fg` to provide input.
- Job numbers change as jobs complete — verify with `jobs` first.

## 2026-relevant notes

- Interactive recovery still common; long-running prod work belongs in systemd/tmux.
- SSH drop kills foreground jobs; use multiplexers for remote interactive work.
- Know difference: `fg` (shell job) vs `docker attach` / `kubectl attach` (container).

## Related Commands

- `bg` — resume in background
- `jobs` — list
- `kill %1` — signal a job
- `Ctrl-Z` — stop foreground
- `tmux` — better multi-tasking than many suspended jobs

## Additional Resources

- `help fg`, `man bash`
