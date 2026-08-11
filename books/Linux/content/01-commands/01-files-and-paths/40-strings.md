# strings

## Overview

`strings` extracts **printable character sequences** from binary files. Operators use it to skim unknown binaries for version strings, URLs, error messages, file paths, and config keys without a full reverse-engineering setup. It is a triage tool — noisy, incomplete, and easy to miss UTF-16 or compressed data.

## Syntax

```bash
strings [options] file...
```

Reads each file and prints sequences of printable characters longer than a minimum length (default often 4).

## Common Options

| Option | Description |
|--------|-------------|
| `-n N`, `--bytes=N` | Minimum sequence length (default 4) |
| `-a`, `--all` | Scan entire file (not only initialized data sections) |
| `-t o\|d\|x` | Print offset in octal/decimal/hex before each string |
| `-e enc` | Encoding: `s` (7-bit), `S` (8-bit), `b`/`l` (16-bit big/little), `B`/`L` (32-bit) |
| `-w`, `--include-all-whitespace` | Include wider whitespace in sequences |
| `-f`, `--print-file-name` | Prefix each line with filename |
| `-d` | Only data sections (object files; opposite of scanning all on some systems) |

GNU binutils `strings` is the Ubuntu default (`binutils` package).

## Examples with Explanations

### Basic scan

```bash
strings /usr/local/bin/app | less
strings /usr/local/bin/app | grep -i version
```

### Longer strings only (less noise)

```bash
strings -n 10 mystery.bin | head -50
strings -n 8 firmware.img | grep -E 'https?://|\.so|error'
```

Raising `-n` drops short garbage sequences.

### Offsets for later xxd

```bash
strings -t x -n 8 blob | head
# 00004a0 some_version_string
xxd -s 0x4a0 -l 64 blob
```

Hex offsets pair well with `xxd -s`.

### UTF-16 little-endian (Windows-ish binaries)

```bash
strings -e l -n 6 app.exe | head
strings -el -n 6 app.exe | grep -i http
```

Default 7/8-bit scan misses many wide-char strings.

### Multiple files

```bash
strings -f -n 8 /lib/x86_64-linux-gnu/*.so.6 2>/dev/null | grep -i 'OpenSSL\|GNU'
```

`-f` labels which file each hit came from.

### Full file scan

```bash
strings -a -n 8 packed.bin | less
```

Some binaries hide strings outside default sections; `-a` scans everything.

### Pipe from another command

```bash
dd if=/dev/sdX bs=1M count=2 status=none | strings -n 8 | head
curl -fsSL https://example.com/file | strings -n 6 | head
```

Useful for quick content smell tests on images or downloads.

### Hunt secrets carefully

```bash
strings -n 12 config.dump | grep -iE 'password|token|secret|api_key'
```

May surface accidental leaks in binaries or core dumps — handle output as sensitive.

## Notes

- Compressed or encrypted regions will not yield meaningful plaintext.
- Minimum length trade-off: low `-n` → noise; high `-n` → missed short tokens.
- Not a substitute for proper malware analysis sandboxes.
- Output can be huge; always filter with `grep`/`head`/`less`.
- License strings and compiler markers often identify build toolchain and versions.

## Related Commands

- `file` — type classification
- `xxd` / `hexdump` — raw bytes
- `readelf` / `objdump` — structured ELF
- `grep -a` — treat binary as text for patterns
- `binwalk` — firmware carving (separate install)
- `nm` / `objdump -T` — symbol tables when not stripped

## Additional Resources

- `man strings`
