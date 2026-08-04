# file

## Overview

`file` classifies files by inspecting **content magic** (and optionally the filesystem type), not just the name extension. Use it on unknown downloads, mystery binaries, compressed blobs, and scripts without a reliable extension.

It reads magic patterns from a database (e.g. `/usr/share/misc/magic`). Classification is heuristic — good for ops triage, not a security sandbox.

## Syntax

```bash
file [options] file...
file -               # read stdin
```

## Common Options

| Option | Description |
|--------|-------------|
| `-b`, `--brief` | Don’t prefix filename |
| `-i`, `--mime` | MIME type output |
| `-I` | MIME with encoding (some versions) |
| `-z` | Look inside compressed files |
| `-L` | Follow symlinks |
| `-s` | Allow special/block files |
| `-k` | Keep going; don’t stop at first match |
| `-f listfile` | Read filenames from listfile |
| `-e test` | Exclude a test (e.g. `soft`, `tokens`) |
| `-h` | Don’t follow symlinks (default often) |

## Examples with Explanations

### Basic classification

```bash
file /bin/ls
file /etc/hosts
file mystery.bin
file photo.jpg note.txt archive.tar.gz
```

### Brief and MIME

```bash
file -b mystery.bin
file -i photo.jpg
# photo.jpg: image/jpeg; charset=binary
file -bi photo.jpg
```

### Inside compressed data

```bash
file -z backup.tar.gz
file -z something.xz
```

### Symlinks

```bash
file /usr/bin/python3
file -L /usr/bin/python3
```

### Scripts and interpreters

```bash
file bootstrap.sh
# may report: Bourne-Again shell script, ASCII text executable
head -1 bootstrap.sh      # shebang check
```

### Stdin

```bash
head -c 256 blob | file -
curl -fsSL https://example.com/file | file -
```

### Batch unknown directory

```bash
file *
find . -type f -print0 | xargs -0 file | grep -i 'executable\|ELF'
```

### Guard uploads / pipelines

```bash
mime=$(file -bi "$upload" | cut -d';' -f1)
case $mime in
  image/jpeg|image/png) echo ok ;;
  *) echo "rejected: $mime" >&2; exit 1 ;;
esac
```

### ELF deep dive (after file)

```bash
file /usr/local/bin/app
readelf -h /usr/local/bin/app
ldd /usr/local/bin/app
```

## Notes / Pitfalls

- Extensions lie; `file` can too — polyglots and crafted headers fool magic.
- Text encodings may be guessed; don’t treat as authoritative Unicode detection.
- Very large files: `file` only needs the beginning — still be careful with special devices.
- Without `-s`, behavior on device nodes is limited.
- Magic DB age depends on package `libmagic` / `file` updates.

## 2026-relevant notes

- Container distroless images may omit `file`; copy samples to a debug image.
- For security scanning, use dedicated malware/YARA tooling beyond `file`.
- MIME output pairs well with web and S3 content-type checks in shell tooling.

## Related Commands

- `stat` — metadata, not content type
- `hexdump` / `xxd` — raw bytes
- `strings` — printable spans in binaries
- `readelf` / `objdump` — ELF analysis
- `identify` (ImageMagick) — image details
- `ls -l` — names and modes only

## Additional Resources

- `man file`
- [libmagic / file(1) docs](https://www.darwinsys.com/file/)
