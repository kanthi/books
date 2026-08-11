# zgrep

## Overview

`zgrep` runs `grep` over **gzip-compressed** files without manual decompression. Useful for rotated logs (`*.gz`). Variants exist for other compressors (`xzgrep`, `bzgrep`, `zstdgrep`).

## Syntax

```bash
zgrep [grep-options] pattern [file...]
```

## Examples with Explanations

### Search compressed logs

```bash
zgrep -H 'error' /var/log/nginx/access.log.*.gz
zgrep -E 'HTTP/1\.[01]" 5[0-9]{2}' access.log.2.gz
```

### Recursive pattern over mixed trees

```bash
find /var/log -name '*.gz' -print0 | xargs -0 zgrep -H 'OutOfMemory'
```

### Count matches

```bash
zgrep -c 'ERROR' app.log.gz
```

## Notes & Pitfalls

- Performance is worse than grepping already-decompressed data — decompress hot logs if you query them constantly.  
- Binary matches: use `grep` flags carefully (`-a`, `-I`).  
- Confirm whether your `zgrep` shells out to `gzip -dc` + `grep`.

## Related Commands

- `grep` / `rg`  
- `zcat` / `zless`  
- `journalctl` — live system logs  
- `xzgrep` / `zstdgrep`  

## Additional Resources

- `man zgrep`
