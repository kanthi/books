# time

## Overview

`time` runs a command and reports how long it took. Bash provides a **builtin** `time` (pipeline-aware) and Ubuntu also ships **`/usr/bin/time`** (GNU time) with more format options. Use it for quick performance checks of scripts, builds, and one-liners. For deep profiling use `perf`, language profilers, or application metrics.

## Syntax

```bash
time command [args...]          # usually bash builtin
/usr/bin/time [options] command [args...]
```

## Common Options

### Bash builtin

Controlled by `TIMEFORMAT` (see `help time` / bash manual). No traditional flags like GNU time.

### GNU `/usr/bin/time` (package `time`)

| Option | Description |
|--------|-------------|
| `-v` | Verbose resource stats |
| `-p` | Portable output (real/user/sys) |
| `-f FORMAT` | Custom format string |
| `-o file` | Write timing to file |
| `-a` | Append to file |

If `type time` shows builtin, call `/usr/bin/time` explicitly for GNU features (`sudo apt install time` if missing).

## Examples with Explanations

### Basic timing

```bash
time sleep 2
time tar -czf /tmp/t.tgz /var/log
```

Reports **real** (wall clock), **user** (CPU userspace), **sys** (CPU kernel).

### Time a pipeline (bash builtin)

```bash
time du -sh /var/* 2>/dev/null | sort -h | tail
```

Builtin `time` can attribute the pipeline as a whole depending on shell rules.

### GNU verbose

```bash
/usr/bin/time -v sha256sum large.iso
```

Shows max RSS, page faults, voluntary context switches, exit status, etc.

### Portable three lines

```bash
/usr/bin/time -p make -j"$(nproc)"
```

### Custom format

```bash
/usr/bin/time -f 'real %e sec | maxrss %M KB' ./build.sh
```

### Compare two approaches

```bash
time gzip -k bigfile
time zstd -k bigfile
```

Wall clock is what operators feel; user+sys helps spot CPU-bound vs I/O-bound work.

### Bash TIMEFORMAT

```bash
TIMEFORMAT='real %3R s; user %3U s; sys %3S s'
time ls -R /usr/share/doc >/dev/null
```

## Notes

- `real` can exceed `user+sys` when waiting on disk/network/CPU contention.
- `user+sys` can exceed `real` on multi-threaded commands (CPU time summed across cores).
- Output of `time` often goes to **stderr**, separate from the command’s stdout.
- Alias/functions: `time` times the resolved command; use `command time` / full path if shadowed.
- Micro-benchmarks need warm caches and repeats; single runs mislead.

## Related Commands

- `perf stat` — hardware performance counters
- `strace -c` — syscall time summary
- `hyperfine` — benchmarking tool (extra install)
- `date +%s.%N` — manual timestamps around blocks
- `timeout` — limit runtime, not measure it

## Additional Resources

- `help time`
- `man time` (GNU)
- `man bash` (`TIMEFORMAT`)
