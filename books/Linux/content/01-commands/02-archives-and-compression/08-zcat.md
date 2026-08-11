# zcat

## Overview

`zcat` writes **gzip-compressed** files to stdout as if they were uncompressed (equivalent to `gzip -dc`). Handy in pipelines without creating temporary files. For `.xz`/`.zst` use `xzcat`/`zstdcat` (or `zcat` only where your distro aliases them carefully — do not assume).

## Syntax

```bash
zcat [options] [file...]
gzip -dc file.gz
```

## Examples with Explanations

### Read a gzip log

```bash
zcat /var/log/syslog.1.gz | less
zcat app.log.gz | grep ERROR | tail
```

### Concatenate multiple

```bash
zcat part-*.gz > combined.log
```

### Portable explicit form

```bash
gzip -dc file.gz | jq .
```

## Notes & Pitfalls

- `zcat` on some systems is a symlink to `gzip -dc` and only handles gzip.  
- Compressed sparse/binary data still expands fully — watch disk when redirecting.  
- Prefer `zgrep` when you only need matches.

## Related Commands

- `gzip` / `gunzip`  
- `zgrep` / `zless`  
- `xzcat` / `bzcat` / `zstdcat`  
- `tar -xzOf` — extract one member to stdout  

## Additional Resources

- `man zcat` / `man gzip`
