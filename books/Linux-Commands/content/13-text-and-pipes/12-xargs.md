# xargs

## Overview
`xargs` builds and executes command lines from standard input. It bridges tools that emit lists (files, IDs, URLs) to commands that expect argv parameters. Essential in pipelines with `find`, `git`, and text filters — and easy to get wrong with spaces or special characters unless you use NUL-delimited mode.

## Syntax
```bash
command | xargs [options] [utility [args...]]
xargs [options] -a file [utility [args...]]
```
If `utility` is omitted, `xargs` defaults to `/bin/echo`.

## Common Options
| Option | Description |
|--------|-------------|
| `-0` / `--null` | Input items are NUL-separated (safe for arbitrary filenames) |
| `-n N` | At most N args per command invocation |
| `-n 1` | One arg per invocation |
| `-P N` | Run up to N processes in parallel |
| `-I {}` | Replace `{}` in the command template with each item |
| `-i` | Like `-I {}` (deprecated form on some systems) |
| `-t` | Print the command before running it |
| `-p` | Prompt before each command |
| `-r` | Do not run if stdin is empty (GNU) |
| `-d delim` | Input delimiter (GNU) |
| `-L N` | Use at most N lines per command |
| `-a file` | Read items from file instead of stdin |
| `-x` | Exit if a single item is too long for the command line |

## Safety
- **Never** pipe raw `find` output into bare `xargs` when names may contain spaces or newlines. Use `find … -print0 | xargs -0 …`.
- `xargs` splits on whitespace by default — a filename `my file.txt` becomes two arguments.
- Parallel `-P` can overwhelm disks, APIs, or remote hosts; start low.
- Interactive prompts (`-p`) are for humans; do not use in unattended scripts without care.

## Examples with Explanations
### Basic: echo words as args
```bash
echo 'one two three' | xargs
# runs: echo one two three
```

### Delete files listed by find (NUL-safe)
```bash
find /tmp -name '*.tmp' -print0 | xargs -0 rm -f
```
Equivalent modern find:
```bash
find /tmp -name '*.tmp' -delete
```

### One invocation per item with placeholder
```bash
find . -name '*.md' -print0 | xargs -0 -I {} cp {} /backup/docs/
```
`-I {}` forces one item at a time and allows the placeholder anywhere in the command.

### Limit batch size
```bash
cat ids.txt | xargs -n 50 echo
# or feed a real tool:
cat ids.txt | xargs -n 100 my-bulk-api-delete
```
Avoids “argument list too long” and huge single CLI lines.

### Parallel compression
```bash
find . -type f -name '*.log' -print0 \
  | xargs -0 -P 4 -n 1 gzip
```
Four `gzip` workers, one file each.

### Show commands (`-t`) while learning
```bash
printf 'a\nb\nc\n' | xargs -n 1 -t rm -f
```

### Skip empty input (GNU)
```bash
grep -rl 'obsolete' . | xargs -r rm
# better NUL-safe:
grep -rlZ 'obsolete' . | xargs -0 -r rm
```
Without `-r`, some xargs still run the command once with no args — dangerous for `rm`.

### Lines as items (GNU `-d`)
```bash
xargs -d '\n' -n 1 echo < urls.txt
```
Still fails if lines contain embedded newlines (rare); for filenames prefer NUL.

### Placeholders with multiple uses
```bash
cat hosts.txt | xargs -I% sh -c 'ssh % "hostname; uptime"'
```
Quote carefully; prefer a real loop for complex remote commands.

### From a file directly
```bash
xargs -a packages.txt -n 1 sudo apt-get install -y
```
(Still review package lists before mass installs.)

### Combine with git
```bash
git ls-files -z '*.png' | xargs -0 ls -l
git grep -z -l 'TODO' | xargs -0 "$EDITOR"
```

## Understanding Output
`xargs` itself is quiet unless `-t`/`-p` is set; you see the **utility’s** stdout/stderr. Exit status is non-zero if any invocation fails (details vary; with `-P`, failures can interleave). Use `-t` when a pipeline “does nothing” — often the built command is not what you expected.

## Notes & Pitfalls
- **NUL safety is the professional default** for file paths: `-print0` / `-z` / `-Z` upstream + `xargs -0`.
- `-I {}` implies `-n 1` and disables some batching; good for clarity, slower for huge sets.
- Quoting inside `sh -c` with xargs is a common injection footgun — validate input or avoid `sh -c` when possible.
- “Argument list too long” (`E2BIG`) is exactly what batching with `-n` fixes.
- Busybox or non-GNU xargs may lack `-0`, `-r`, `-a`, `-d`, or `-P`. On Ubuntu GNU findutils xargs, these are available.
- For complex per-file logic, a `while IFS= read -r -d '' f; do …; done` loop is often clearer than nested xargs.

## Related Commands
- `find -exec … {} +` — batch without a separate xargs
- `parallel` (GNU) — richer job control if installed
- `xargs -0` + `grep -Z` / `git -z` — NUL-safe ecosystems
- `printf` / `tr '\n' '\0'` — convert delimiters carefully
- shell `while read` loops — when you need full shell features

## Additional Resources
- `man xargs`
- `man find` (especially `-print0`, `-exec`)
