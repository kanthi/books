# zstd

## Overview

`zstd` (Zstandard) is a modern compression tool offering an excellent **speed vs ratio** curve, levels from very fast to extremely dense, optional multithreading, and framing with checksums. It is the preferred default for many new local pipelines, package systems, and container layers. Extension: `.zst`.

## Syntax

```bash
zstd [options] [file...]
zstd -d [options] [file...]
zstdcat [file...]
unzstd [file...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-d`, `--decompress` | Decompress |
| `-c`, `--stdout` | Write to stdout |
| `-f`, `--force` | Overwrite / compress links |
| `-o file` | Output file name |
| `-k` / `--rm` | Keep sources (default keep) / remove sources after success |
| `-t` | Test integrity |
| `-T#` | Threads (`-T0` = all cores) |
| `-#` | Level 1–19 (default 3); ultra with `--ultra -20`…`-22` |
| `-v` | Verbose |
| `-q` | Quiet |
| `-l` / `--list` | Show frame info |
| `--train` | Build a dictionary (advanced) |
| `-D dict` | Compress/decompress with dictionary |
| `--long` | Long distance matching mode |

Unlike classic gzip defaults, **zstd keeps the original file** unless you pass `--rm`.

## Examples with Explanations

### Basic

```bash
zstd file.tar
zstd -d file.tar.zst
zstd -o out.zst file
unzstd file.tar.zst
```

### Levels and threads

```bash
zstd -1 -T0 fast.log
zstd -19 -T0 cold.img
zstd --ultra -22 -T0 deepest.img   # very slow/heavy
for l in 1 3 6 9 15 19; do
  zstd -$l -f -o /tmp/t.zst sample.bin && ls -lh /tmp/t.zst
done
```

### Pipelines with tar

```bash
tar -I 'zstd -T0' -cf backup.tar.zst dir/
tar --zstd -cf backup.tar.zst dir/          # GNU tar 1.31+
zstd -dc backup.tar.zst | tar xf -
tar -I zstd -xf backup.tar.zst
```

### Integrity

```bash
zstd -t backup.tar.zst
zstd -l backup.tar.zst
```

### Remove source when desired

```bash
zstd --rm big.img
```

### Dictionaries (small similar files)

```bash
zstd --train -o dict samples/*
zstd -D dict small1 small2
zstd -d -D dict small1.zst
```

Useful for massive numbers of similar tiny JSON/logs.

## Notes / Pitfalls

- Confirm consumers understand `.zst` before replacing gzip in public APIs.
- Ultra levels need large memory windows — watch small VMs.
- Default **keeps** inputs; scripts ported from gzip may leave duplicates if they assume deletion.
- `tar --zstd` requires sufficiently new GNU tar; `-I 'zstd -T0'` is explicit and flexible.
- Older enterprise appliances may still demand `.gz`.

## 2026-relevant notes

- Default choice for many new internal artifacts, caches, and log archives.
- Kernel squashfs, package managers, and container tooling increasingly support zstd natively.
- Compare: **gzip** (universal), **xz** (max ratio, slow), **zstd** (best general default).

## Related Commands

- `gzip` / `xz` / `bzip2` — alternatives
- `tar` — archive integration
- `zstdcat` / `zstdgrep` (if packaged)
- `pzstd` — parallel client in some packages
- `lz4` — even faster, lower ratio

## Additional Resources

- `man zstd`
- [facebook/zstd](https://github.com/facebook/zstd)
