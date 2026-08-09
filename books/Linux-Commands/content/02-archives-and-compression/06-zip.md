# zip

## Overview

`zip` creates **ZIP** archives widely used for cross-platform interchange (Windows, macOS, Linux). Unlike `tar` + compressor pipelines, zip typically **compresses each member** and stores a central directory. Prefer `tar` + `gzip`/`zstd` for Unix-native backups with permissions/owners; use `zip` when recipients expect `.zip` or you need simple selective compression of mixed files.

## Syntax

```bash
zip [options] archive.zip file...
zip [options] archive.zip -r dir/
```

## Common Options

| Option | Description |
|--------|-------------|
| `-r` | Recurse into directories |
| `-q` | Quiet |
| `-v` | Verbose |
| `-u` | Update existing entries |
| `-m` | Move files into zip (delete after) |
| `-e` | Encrypt (traditional; weak by modern standards) |
| `-P pass` | Password on CLI (visible in process list — avoid) |
| `-x pattern` | Exclude patterns |
| `-i pattern` | Include patterns |
| `-y` | Store symbolic links as links (Unix) |
| `-j` | Junk (store) path names — flatten |
| `-0` … `-9` | Compression level (0 = store) |
| `-s size` | Split archive into segments |
| `-F` / `-FF` | Fix archive |

## Examples with Explanations

### Create archives

```bash
zip notes.zip *.txt
zip -r project.zip project/
zip -r project.zip project/ -x 'project/node_modules/*' -x '*.git*'
```

### Update and list

```bash
zip -u project.zip project/README.md
zip -sf project.zip                 # show files (zipinfo-like)
unzip -l project.zip                # often clearer listing
```

### Flatten paths

```bash
zip -j flat.zip path/to/a.txt path/to/b.txt
```

### Store without compression

```bash
zip -0 -r media.zip photos/         # already-compressed JPEGs
```

### Encryption (know the limits)

```bash
zip -e secret.zip secrets.txt
# traditional zip crypto is weak; prefer 7z AES or age/gpg for real secrets
```

### Split archives

```bash
zip -r -s 100m backup.zip data/
```

### Exclude junk

```bash
zip -r src.zip src/ -x '*/__pycache__/*' -x '*.pyc' -x '*/.DS_Store'
```

### Date-stamped backup

```bash
zip -r "backup-$(date +%Y%m%d).zip" documents/
```

## Notes / Pitfalls

- Unix permissions, owners, and special files are a poor fit; `tar` preserves more faithfully.
- Password on the command line (`-P`) leaks via `ps` — interactive `-e` is better but still weak crypto.
- Large file ZIP64 support depends on zip version; very old unzip may fail.
- Default may follow or store links differently than you expect — test with `-y`.
- Windows/macOS clients may mishandle exotic UTF-8 names depending on flags/tools.

## 2026-relevant notes

- For secure sharing, prefer `age`, `gpg`, or encrypted 7z over zip’s traditional encryption.
- CI artifacts often use zip for multi-OS consumers — keep compression level modest for speed.
- `unzip` / `bsdunzip` / Explorer all need to open your result — avoid exotic extensions.

## Related Commands

- `unzip` — extract / list
- `zipinfo` — detailed listing
- `7z` — stronger formats/crypto
- `tar` — Unix-native archives
- `zstd` / `gzip` — stream compressors

## Additional Resources

- `man zip`
