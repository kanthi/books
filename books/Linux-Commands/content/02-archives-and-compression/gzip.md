# gzip

## Overview

`gzip` compresses or decompresses files using the DEFLATE algorithm (`.gz`). It is the most universal compression tool on Unix-like systems — logs, tarballs (`tar.gz` / `.tgz`), and HTTP content-encoding all speak gzip. Default behavior **replaces** the input file with `file.gz` (use `-k` / `--keep` to retain the original on modern gzip).

For better speed/ratio tradeoffs on new pipelines, consider `zstd`. For maximum ratio on cold archives, consider `xz`. Keep `gzip` for compatibility.

## Syntax

```bash
gzip [options] [file...]
gunzip [options] [file...]
gzcat / zcat [file...]          # decompress to stdout
```

## Common Options

| Option | Description |
|--------|-------------|
| `-c`, `--stdout` | Write to stdout; keep inputs |
| `-d`, `--decompress` | Decompress (same as `gunzip`) |
| `-k`, `--keep` | Keep input files |
| `-f`, `--force` | Force overwrite / compress links |
| `-n` / `-N` | Don’t save / do save original name & time |
| `-q` | Quiet |
| `-r` | Recursive directories |
| `-t` | Test integrity |
| `-v` | Verbose |
| `-1` … `-9` | Fastest … best compression (default 6) |
| `-l` | List compressed size / ratio for `.gz` files |

## Examples with Explanations

### Compress / decompress

```bash
gzip file.txt                 # creates file.txt.gz, removes file.txt
gzip -k file.txt              # keep original
gunzip file.txt.gz
gzip -d file.txt.gz           # same
```

### stdout pipelines

```bash
gzip -c file.txt > file.txt.gz
gunzip -c file.txt.gz > file.txt
tar cf - dir | gzip -9 > dir.tar.gz
gzip -dc dir.tar.gz | tar xf -
```

### Level tradeoffs

```bash
gzip -1 fast.log              # CPU cheap
gzip -9 archive.dat           # smaller, slower
```

### Test and list

```bash
gzip -t file.txt.gz
gzip -l *.gz
```

### Recursive logs

```bash
gzip -r /var/log/old/         # careful: compresses in place
find /var/log -name '*.log' -mtime +7 -exec gzip -9 {} +
```

### View without extracting

```bash
zcat file.txt.gz | less
zgrep 'ERROR' app.log.gz
zless app.log.gz
```

### Integrity in scripts

```bash
if gzip -t backup.gz 2>/dev/null; then
  echo ok
fi
```

## Notes / Pitfalls

- Without `-k`, the source file is removed after successful compression.
- Compressing already-compressed data (jpeg, mp4, `.gz`) wastes CPU and may grow size.
- `gzip -r` is easy to over-apply on system directories — scope with `find`.
- Concatenated `.gz` members are valid; some tools only read the first.
- Sparse files and special files: stick to regular files.

## 2026-relevant notes

- Still the interchange default for tarballs and many APIs.
- Prefer `zstd` for local high-volume logs when all consumers support it.
- `pigz` provides parallel gzip when you need multi-core compression of large streams.

## Related Commands

- `gunzip` / `zcat` / `zgrep` / `zless` — decompress / search / page
- `pigz` — parallel gzip
- `xz` / `zstd` / `bzip2` — alternate compressors
- `tar` — archive + compress combo
- `gzip -l` vs `stat` — size inspection

## Additional Resources

- `man gzip`
