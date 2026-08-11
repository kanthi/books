---
title: Intro
---

# Intro

Pack, compress, and inspect archives for backup, distribution, and log history. Prefer `tar` with modern compressors (`zstd`, `xz`) for Linux trees; use zip when exchanging with non-Unix tools.

## Commands in this part

| Command | Role |
|---------|------|
| `tar` | tar packs multiple files into one archive (and extracts them). |
| `gzip` | gzip compresses or decompresses files using the DEFLATE algorithm (.gz). |
| `xz` | xz compresses and decompresses files in the XZ format (LZMA2), typically yielding better ratios than gzip/bzip2 at… |
| `bzip2` | bzip2 compresses files with the Burrows–Wheeler algorithm (.bz2). |
| `zstd` | zstd (Zstandard) is a modern compression tool offering an excellent speed vs ratio curve, levels from very fast to… |
| `zip` | zip creates ZIP archives widely used for cross-platform interchange (Windows, macOS, Linux). |
| `unzip` | unzip lists, tests, and extracts ZIP archives. |
| `zcat` | zcat writes gzip-compressed files to stdout as if they were uncompressed (equivalent to gzip -dc). |
| `zgrep` | zgrep runs grep over gzip-compressed files without manual decompression. |


## Suggested starting points

1. Create/extract trees: `tar` (+ `zstd`/`gzip`/`xz`).
2. Single-file compressors: `gzip`, `xz`, `bzip2`, `zstd`.
3. Interchange with Windows/macOS users: `zip` / `unzip`.
4. Search rotated logs without unpacking: `zgrep`, `zcat`.

## Related parts

- Files and paths — copy and verify before archiving
- Text and pipes — process extracted streams
- Networking — `rsync`/`scp` for transfer after packing

Continue with the individual command pages in this part.
