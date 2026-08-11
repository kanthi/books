# xxd

## Overview

`xxd` creates a **hex dump** of a file (or stdin) and can reverse a dump back to binary. Operators use it to inspect magic numbers, protocol payloads, firmware blobs, and corrupted headers. It ships with Vim on many Ubuntu installs (`vim-common`). Alternatives: `hexdump`, `od`, `hexyl` (nicer TUI).

## Syntax

```bash
xxd [options] [file]
xxd -r [options] [file]
```

Default: hex + ASCII side panel. No file means stdin.

## Common Options

| Option | Description |
|--------|-------------|
| `-p`, `-ps`, `-postscript`, `-plain` | Continuous plain hex (no addresses/ASCII) |
| `-i` | C include-style array |
| `-r`, `-revert` | Reverse: hex dump → binary |
| `-r -p` | Reverse plain hex |
| `-g N`, `-groupsize N` | Bytes per group (default 2) |
| `-c N`, `-cols N` | Bytes per line |
| `-l LEN`, `-len LEN` | Stop after `LEN` bytes |
| `-s OFF`, `-seek OFF` | Start at offset (supports `+`/`-` relative forms) |
| `-u` | Uppercase hex |
| `-b` | Bits (binary) dump |
| `-e` | Little-endian style grouping (when supported) |
| `-a` | Autoskip nul lines (like `*`) |

## Examples with Explanations

### Basic dump

```bash
xxd /bin/ls | head
xxd -l 64 file.bin
```

First lines show file offset, hex bytes, and ASCII.

### Limit and offset

```bash
xxd -s 0x100 -l 32 firmware.bin
xxd -s -16 file.bin          # last 16 bytes (GNU/common form)
```

Jump to headers, ELF sections, or trailing magic without dumping the whole file.

### Plain hex (scripts / compare)

```bash
xxd -p -l 16 file.bin
# 7f454c4602010100...
xxd -p file.bin | tr -d '\n' | head -c 32; echo
```

### C array for embedding

```bash
xxd -i blob.bin > blob.h
# unsigned char blob_bin[] = { 0x... };
```

Handy for tiny firmware embeds in C/Go build pipelines (prefer proper resource packing for large assets).

### Reverse plain hex to binary

```bash
echo '68656c6c6f' | xxd -r -p > hello.bin
xxd -p hello.bin
# 68656c6c6f
```

Also works with classic `xxd` output via `xxd -r`.

### Edit a few bytes (workflow)

```bash
xxd -l 256 config.bin > config.hex
# edit carefully in editor
xxd -r config.hex > config-new.bin
cmp -l config.bin config-new.bin | head
```

For serious binary patching use proper tools; `xxd` is fine for small fixes.

### Inspect file magic

```bash
xxd -l 4 photo.jpg
# ... ff d8 ff e0 ...  JPEG SOI
xxd -l 8 /bin/ls
# ... 7f 45 4c 46 ...  ELF
file photo.jpg /bin/ls
```

Pair with `file` for classification; `xxd` shows the raw bytes.

### Grouping and columns for readability

```bash
xxd -g 1 -c 16 packet.bin | head
xxd -g 4 -c 16 -u header.bin | head
```

### Bits view

```bash
xxd -b -l 8 flags.bin
```

Shows bit patterns — occasional use for flag bytes.

## Notes

- Large dumps flood the terminal — always prefer `-l` / `head` for first look.
- Plain hex reverse (`-r -p`) ignores whitespace; classic reverse expects `xxd`’s address format.
- Package: often `vim-common` on Ubuntu (`dpkg -S $(which xxd)`).
- Offsets in the left column are hexadecimal by default.
- Not a disassembler — use `objdump`/`llvm-objdump` for instructions.

## Related Commands

- `file` — classify content
- `strings` — printable spans
- `od` / `hexdump` — other dump formats
- `cmp` — compare binaries
- `sha256sum` — integrity after edits
- `readelf` / `objdump` — ELF structure

## Additional Resources

- `man xxd`
