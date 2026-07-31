# xz / unxz / xzcat

## Overview
`xz` provides high-ratio LZMA2 compression (`.xz`). Slower and more memory-hungry than gzip/zstd at high levels; common for source tarballs and package payloads.

## Syntax
```bash
xz [options] [file...]
unxz file.xz
xzcat file.xz
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Decompress |
| `-k` | Keep original |
| `-c` | stdout |
| `-#` / `-T n` | Level / threads |
| `-t` | Test |
| `-e` | Extreme (slower) |
| `-0`…`-9` | Compression level |

## Examples with Explanations
```bash
xz file.tar
xz -d file.tar.xz
xz -T0 -9 big.img             # all threads, high ratio
xzcat data.xz | jq .
tar -cJf src.tar.xz src/      # tar + xz
tar -xJf src.tar.xz
```

## Notes
- Peak RAM scales with level and threads — watch small systems.  
- `.lzma` is legacy raw LZMA; prefer `.xz`.  
- For interactive backups, `zstd -19` often feels snappier.

## Related Commands
- `zstd` / `gzip`  
- `tar -J`  
- `lz4` — speed-focused
