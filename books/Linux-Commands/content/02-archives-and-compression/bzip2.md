# bzip2

## Overview

`bzip2` compresses files with the Burrows–Wheeler algorithm (`.bz2`). It typically achieves better ratios than gzip but is slower and has largely been superseded by **xz** (better ratio) and **zstd** (better speed/ratio balance) for new work. You will still encounter `.bz2` and `.tar.bz2` in older archives and some software distributions.

## Syntax

```bash
bzip2 [options] [file...]
bunzip2 [options] [file...]
bzcat [file...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-c` | Write to stdout |
| `-d` | Decompress |
| `-z` | Compress (default) |
| `-k` | Keep input files |
| `-f` | Force |
| `-t` | Test integrity |
| `-v` | Verbose |
| `-q` | Quiet |
| `-s` | Small memory mode |
| `-1` … `-9` | Block size / effort (100k–900k blocks) |

## Examples with Explanations

### Compress / decompress

```bash
bzip2 file.txt
bzip2 -k file.txt
bunzip2 file.txt.bz2
bzip2 -d file.txt.bz2
```

### Pipelines

```bash
bzip2 -c file.txt > file.txt.bz2
bzcat file.txt.bz2 | less
tar cjf archive.tar.bz2 dir/
tar xjf archive.tar.bz2
```

### Levels

```bash
bzip2 -1 quick.dat
bzip2 -9 small.dat
```

### Test

```bash
bzip2 -t file.txt.bz2
```

### Search compressed

```bash
bzgrep 'ERROR' app.log.bz2
bzless app.log.bz2
```

### Prefer modern tools when choosing

```bash
# old style
tar cjf backup.tar.bz2 data/
# modern defaults for new archives
tar --zstd -cf backup.tar.zst data/
# or
tar cJf backup.tar.xz data/
```

## Notes / Pitfalls

- Deletes inputs by default without `-k`.
- CPU-heavy relative to gzip/zstd for similar tasks.
- Memory scales with block size (`-s` helps constrained systems).
- Less common in new HTTP APIs than gzip/br/zstd.
- Parallel variant: `pbzip2` / `lbzip2` if installed.

## 2026-relevant notes

- Maintain decompression support for legacy artifacts; avoid bzip2 for new internal pipelines unless required.
- GNU tar still supports `-j` / `--bzip2`.
- If an upstream only publishes `.tar.bz2`, trust `tar xjf` / `bzip2 -d` rather than recompressing without need.

## Related Commands

- `bunzip2` / `bzcat` / `bzgrep` / `bzless`
- `gzip` / `xz` / `zstd`
- `tar -j`
- `pbzip2` — parallel bzip2

## Additional Resources

- `man bzip2`
