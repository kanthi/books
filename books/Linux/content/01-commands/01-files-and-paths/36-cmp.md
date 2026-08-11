# cmp

## Overview

`cmp` compares two files **byte by byte**. It reports the first difference (byte number and line number) or stays silent if they match. Use it to verify copies, compare binaries, or confirm a write succeeded. Prefer `diff` for human-readable text changes; prefer `sha256sum` when comparing against a published digest or many files via a list.

## Syntax

```bash
cmp [options] file1 file2
```

Either file may be `-` for stdin (not both in all cases — see man page).

## Common Options

| Option | Description |
|--------|-------------|
| `-l`, `--verbose` | List all differing byte positions and values |
| `-s`, `--quiet`, `--silent` | No output; exit status only |
| `-n BYTES`, `--bytes=BYTES` | Compare at most `BYTES` |
| `-i BYTES`, `--ignore-initial=BYTES` | Skip first `BYTES` of both files |
| `-i BYTES1:BYTES2` | Skip different prefixes per file |
| `-b`, `--print-bytes` | Show differing bytes (with `-l`) |

## Examples with Explanations

### Basic equal / not equal

```bash
cmp a.bin b.bin && echo same || echo differ
cp a.bin a.copy
cmp a.bin a.copy && echo copy-ok
```

Silent success + exit 0 means identical through EOF of the shorter comparison path.

### Where they first differ

```bash
cmp report-v1.dat report-v2.dat
# report-v1.dat report-v2.dat differ: byte 1024, line 1
```

Byte index is 1-based in GNU cmp messages. Line number counts newlines seen — less meaningful for pure binary.

### Quiet for scripts

```bash
if cmp -s "$src" "$dst"; then
  echo 'unchanged'
else
  echo 'needs update'
fi
```

### List every difference (small files)

```bash
cmp -l file1 file2 | head
# byte_num  octal_val1  octal_val2
```

Noisy for large divergent files — stop with `head` or use `diff`/`sha256sum` instead.

### Compare after skipping headers

```bash
cmp -i 512 disk.img partition.img
cmp -i 0:2048 full.img payload.bin
```

Useful when one side has a preamble (MBR, archive header) the other lacks.

### Limit length

```bash
cmp -n 1M image.iso /dev/sdX
```

Compares only the first 1 MiB — e.g. quick check that a written ISO prefix matches without reading the whole medium.

### Against a device (careful read-only)

```bash
sudo cmp -n "$(stat -c%s ubuntu.iso)" ubuntu.iso /dev/sdX && echo usb-matches-iso-prefix
```

Read-only verification after `dd`. Still confirm device identity with `lsblk` first.

## Notes

- Exit status: `0` same, `1` different, `2` error (missing file, etc.).
- `cmp` stops at the first difference unless `-l`.
- For large “are these the same?” checks over the network, hashing or `rsync -nc` may be more practical.
- Text normalization (CRLF vs LF) is **not** ignored — bytes must match.
- Sparse files and special files follow normal read semantics; comparing devices needs privileges and caution.

## Related Commands

- `diff` — line-oriented text
- `sha256sum` — digest compare / published checksums
- `md5sum` — weaker legacy digest
- `comm` — compare sorted line sets
- `rsync -nc` — dry-run content check via rsync

## Additional Resources

- `man cmp`
