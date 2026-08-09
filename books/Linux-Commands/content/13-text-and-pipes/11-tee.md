# tee

## Overview
`tee` reads stdin and writes it to both standard output **and** one or more files. It is the standard way to keep a pipeline’s live output while saving a copy for logs, audits, or later processing. Named after a T-splitter in plumbing.

## Syntax
```bash
command | tee [OPTIONS] [FILE...]
command | tee [OPTIONS] FILE | other-command
```
With no files, `tee` only copies stdin to stdout (still useful with options like `-a` rarely alone).

## Common Options
| Option | Description |
|--------|-------------|
| `-a` / `--append` | Append to files instead of overwriting |
| `-i` / `--ignore-interrupts` | Ignore SIGINT (less common in scripts) |
| `-p` | Diagnose errors writing to non-pipes (GNU; behavior with SIGPIPE) |

## Safety
- `tee file` **truncates** `file` by default when the pipeline starts — same class of footgun as `> file`. Use `-a` to append.
- Writing into system paths needs appropriate privileges (`sudo tee` pattern below).
- Do not `tee` secrets into world-readable locations; check umask and directory permissions.

## Examples with Explanations
### Save output and still see it
```bash
ping -c 4 1.1.1.1 | tee ping.log
```

### Append to a running log
```bash
./deploy.sh 2>&1 | tee -a deploy.log
```
`2>&1` captures stderr too so the log is complete.

### Split to multiple files
```bash
./build.sh 2>&1 | tee build.log build-copy.log
```

### Continue the pipeline after saving
```bash
dmesg | tee dmesg.full | grep -i error
```
Full capture in `dmesg.full`; only errors scroll on the terminal.

### Write files that need root (classic sudo tee)
```bash
echo 'net.ipv4.ip_forward=1' | sudo tee /etc/sysctl.d/99-forward.conf
```
Why not `sudo echo … > file`? The redirect is applied by the **local shell** before `sudo`, so the file open happens as you, not root. `sudo tee` opens the file as root.

### Same pattern: append as root
```bash
echo 'export PATH="/opt/bin:$PATH"' | sudo tee -a /etc/environment
```
(Validate distro conventions before editing `/etc/environment`.)

### Suppress terminal output but keep the file
```bash
make 2>&1 | tee build.log >/dev/null
# or simply:
make 2>&1 > build.log
```
`tee` is only needed when you still want a branch (multiple files, or later pipe stages).

### Capture and process with jq later
```bash
curl -sS https://api.github.com/repos/jqlang/jq \
  | tee repo.json \
  | jq -r '.stargazers_count'
```

### Timestamped session log with a second process
```bash
./long-job.sh 2>&1 | tee -a "job-$(date +%F).log"
```

### Combine with process substitution (bash) for dual processing
```bash
./app 2>&1 | tee >(logger -t myapp) | grep -i error
```
Sends a copy to syslog via `logger` while grepping errors on the terminal (bash/zsh).

### Preserve exit status of the left side (bash pipefail)
```bash
set -o pipefail
make 2>&1 | tee build.log
```
Without `pipefail`, the pipeline’s exit status is `tee`’s (usually 0) even if `make` failed.

## Understanding Output
Whatever arrives on stdin is duplicated to each listed file and to stdout, byte-for-byte (text or binary). Order is preserved. If a file cannot be opened, GNU tee reports an error and still attempts other outputs; check exit status in scripts.

## Notes & Pitfalls
- **Truncation default:** `tee log` overwrites; `tee -a log` appends.
- **Exit codes:** with default bash pipes, failures on the left can be masked — enable `set -o pipefail` in scripts.
- Buffering: when stdout is a pipe, some programs fully buffer; you may see delayed terminal output. Tools like `stdbuf -oL` can force line buffering when needed.
- Binary data works; avoid viewing huge binary tees in the terminal.
- `tee` is not a remote multipath tool — for network fan-out use `socat`, message buses, or log shippers.
- Multiple writers appending to one log without coordination can interleave lines; for concurrent jobs prefer separate logs or a proper logger.

## Related Commands
- shell redirects `>` / `>>` — single destination, no T-split
- `script` — record an entire interactive terminal session
- `logger` — send lines to syslog
- `sponge` (moreutils) — soak stdin then write (safe in-place pipeline edits)
- `pv` — progress meter in pipelines (if installed)

## Additional Resources
- `man tee`
- GNU coreutils info: `info tee`
