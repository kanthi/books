# xz

## Overview

`xz` compresses and decompresses files in the **XZ** format (LZMA2), typically yielding better ratios than gzip/bzip2 at the cost of more CPU and memory — especially at high presets. Common for source tarballs (`*.tar.xz`), package payloads, and cold archives.

Companion commands: `unxz`, `xzcat`, `xzgrep`.

## Syntax

```bash
xz [options] [file...]
unxz [options] [file...]
xzcat [file...]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-z` / `-d` | Compress (default) / decompress |
| `-c` | Write to stdout |
| `-k`, `--keep` | Keep input files |
| `-f` | Force |
| `-t` | Test integrity |
| `-l` | List information about `.xz` files |
| `-0` … `-9` | Compression preset (default 6); higher = smaller/slower/more RAM |
| `-e`, `--extreme` | Try harder within preset (more CPU) |
| `-T N`, `--threads=N` | Multithreaded compression (when built with support) |
| `-v` | Verbose |
| `-q` | Quiet |
| `--memlimit=SIZE` | Cap memory usage |

## Examples with Explanations

### Basic

```bash
xz file.tar
xz -k file.tar
unxz file.tar.xz
xz -d file.tar.xz
```

### Pipelines with tar

```bash
tar -cJf archive.tar.xz dir/          # tar invokes xz
tar -caf archive.tar.xz dir/          # auto by extension (GNU tar)
xz -dc archive.tar.xz | tar xf -
tar -xJf archive.tar.xz
```

### Presets and threads

```bash
xz -0 -T0 fast.dat          # fast, multi-thread (T0 = all cores when supported)
xz -9e cold-archive.img     # max effort; watch RAM
xz -T4 -6 backup.sql
```

### Test and list

```bash
xz -t archive.tar.xz
xz -l *.xz
xz -lv package.tar.xz
```

### Keep and stdout

```bash
xz -kc file > file.xz
xzcat file.xz | less
```

### Memory safety on small hosts

```bash
xz --memlimit=50% -T2 big.img
```

High `-9` on a 1 GB VPS can invoke the OOM killer — lower preset or set a memlimit.

### Convert from gzip (recompress)

```bash
gzip -dc old.tar.gz | xz -T0 -c > new.tar.xz
```

## Notes / Pitfalls

- Decompression is faster than compression but still heavier than gzip for weak CPUs.
- Multi-threaded mode increases memory roughly with threads × preset needs.
- Not as ubiquitous as `.gz` on ancient appliances — confirm consumer support.
- Default may delete inputs without `-k` (like gzip).
- Don’t use extreme presets for live log shipping; use zstd/gzip.

## 2026-relevant notes

- Many distros ship packages and kernel sources as `.tar.xz`.
- For new internal pipelines, **zstd** often wins on speed with comparable ratio at mid levels; xz remains fine for cold distribution archives.
- `pixz` / threaded xz variants exist for parallelize-friendly workflows.

## Related Commands

- `unxz` / `xzcat` / `xzgrep` — decompress helpers
- `gzip` / `zstd` / `bzip2` — alternatives
- `tar -J` / `tar --xz` — archive integration
- `lzma` — legacy LZMA utils (related family)
- `7z` — multi-format archiver

## Additional Resources

- `man xz`
