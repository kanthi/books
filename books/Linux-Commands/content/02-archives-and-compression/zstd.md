# zstd

## Overview
`zstd` (Zstandard) is a fast lossless compressor with excellent ratio/speed tradeoffs. It is often preferable to `gzip` for logs, backups, and package artifacts.

## Syntax
```bash
zstd [options] [file...]
zstd -d [options] [file...]
zstdmt [options] [file...]   # multi-threaded alias/common packaging
```

## Common Options
| Option | Description |
|--------|-------------|
| `-#` | Compression level 1–19 (default 3); ultra up to 22 with --ultra |
| `-d / --decompress` | Decompress |
| `-c / --stdout` | Write to stdout |
| `-f` | Overwrite output |
| `-t` | Test integrity |
| `-T#` | Threads (0 = all CPUs) |
| `-o file` | Output path |
| `--rm` | Remove source after success |
| `-v` | Verbose |

## Key Use Cases
1. Compress backups and tarballs
2. Replace gzip for large log archives
3. Stream compress in pipelines
4. Multi-threaded bulk compression

## Examples with Explanations
### Compress a file
```bash
zstd big.log
# creates big.log.zst, keeps original unless --rm
```
Default level balances speed and size.

### Decompress
```bash
zstd -d big.log.zst
```
Restores `big.log` beside the archive.

### Tar + zstd (modern tar)
```bash
tar --zstd -cf project.tar.zst project/
tar --zstd -tf project.tar.zst
tar --zstd -xf project.tar.zst
```
GNU tar 1.31+ supports `--zstd` natively.

### Pipeline
```bash
tar -cf - mydir | zstd -T0 -19 -o mydir.tar.zst
```
High ratio with all cores; stream avoids temp tar.

### Decompress to stdout
```bash
zstd -dc data.json.zst | jq .
```
Chain into JSON tools without unpacking to disk.

## Notes & Pitfalls
- Prefer `.zst` extension; tools recognize it widely now.
- Level 19 is slow but dense; level 3 is a good default for logs.
- Package: `sudo apt install zstd`.

## Related Commands
- `tar` — archive then compress
- `gzip` / `xz` — older alternatives
- `zip` — multi-file archives with different ecosystem
