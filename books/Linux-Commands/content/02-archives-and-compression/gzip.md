# gzip / gunzip / zcat

## Overview
`gzip` compresses single files with the DEFLATE algorithm (`.gz`). For multi-file archives, combine with `tar`. Prefer `zstd` for better speed/ratio on modern systems when available.

## Syntax
```bash
gzip [options] [file...]
gunzip [options] [file...]
zcat file.gz
```

## Common Options
| Option | Description |
|--------|-------------|
| `-k` | Keep original (GNU) |
| `-d` | Decompress |
| `-c` | Write to stdout |
| `-#` | Level 1–9 (fast–best) |
| `-t` | Test integrity |
| `-n` / `-N` | Strip / keep name+time in header |
| `-r` | Recursive (careful) |
| `-v` | Verbose |

## Examples with Explanations
```bash
gzip large.log                 # → large.log.gz, removes original
gzip -k large.log              # keep original
gzip -d large.log.gz
gunzip large.log.gz
zcat large.log.gz | less
gzip -c file > file.gz         # keep original via stdout
tar -czf a.tgz dir/            # tar+gzip
```

### Level tradeoff
```bash
gzip -1 fast.log
gzip -9 slow-but-small.log
```

## Related Commands
- `zstd` / `xz` / `bzip2`  
- `tar`  
- `pigz` — parallel gzip
