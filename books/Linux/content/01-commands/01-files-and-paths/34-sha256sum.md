# sha256sum

## Overview

`sha256sum` computes or verifies **SHA-256** message digests. Operators use it to confirm ISO/downloads, detect bit-rot or accidental corruption, and check published checksums. It is not encryption and does not prove a file is free of malware — only that content matches an expected hash (or another copy).

Related tools: `sha1sum`, `md5sum` (weaker; avoid for new security checks), `b2sum`, `sha512sum`.

## Syntax

```bash
sha256sum [options] [file...]
sha256sum -c [options] checksums.txt
```

With no files (or `-`), reads stdin. Default output: `<hash>  <filename>` (two spaces = text mode).

## Common Options

| Option | Description |
|--------|-------------|
| `-b`, `--binary` | Binary mode marker (`*filename`) |
| `-t`, `--text` | Text mode (default on GNU/Linux) |
| `-c`, `--check` | Read checksums from files and verify |
| `--ignore-missing` | Skip missing files when checking |
| `--quiet` | When checking, only print failures |
| `--status` | Silent; exit status only |
| `--strict` | Non-zero exit on malformed lines |
| `-w`, `--warn` | Warn about improperly formatted lines |
| `--tag` | BSD-style output |

## Examples with Explanations

### Hash a file

```bash
sha256sum ubuntu-24.04.1-live-server-amd64.iso
# e3b0c442…  ubuntu-24.04.1-live-server-amd64.iso
```

Compare the printed digest to the publisher’s checksum page (preferably over HTTPS / signed).

### Hash several files

```bash
sha256sum *.iso
sha256sum file1 file2 | tee SHA256SUMS
```

### Stdin

```bash
echo -n 'hello' | sha256sum
cat archive.tar | sha256sum
```

Note: `echo` adds a newline unless `-n`; that changes the hash.

### Write and verify a checksum file

```bash
sha256sum image.iso config.yaml > SHA256SUMS
sha256sum -c SHA256SUMS
# image.iso: OK
# config.yaml: OK
```

Keep `SHA256SUMS` next to the files; run `-c` after transfer or storage.

### Quiet / script-friendly check

```bash
sha256sum -c --status SHA256SUMS && echo all-ok || echo FAIL
sha256sum -c --quiet SHA256SUMS
```

`--status` is ideal for CI: no stdout noise, rely on exit code.

### Verify published ISO pattern

```bash
# After downloading both the ISO and SHA256SUMS (or .sha256) from a trusted source:
sha256sum -c SHA256SUMS 2>&1 | grep iso
# or single line:
echo 'EXPECTEDHASH  ubuntu.iso' | sha256sum -c -
```

Always obtain the expected hash from a **trustworthy** channel (vendor site, signed list), not an untrusted mirror alone.

### Directory of artifacts

```bash
find dist -type f -print0 | sort -z | xargs -0 sha256sum > dist/SHA256SUMS
(cd dist && sha256sum -c SHA256SUMS)
```

Stable sort keeps the checksum file reproducible across machines.

### Compare two local copies without a list

```bash
sha256sum a/big.img b/big.img
# same hash → same content (collision risk is negligible for accidental errors)
```

For byte-identical compare of two paths, `cmp` is enough; hashes shine when one side is remote or listed.

## Notes

- On GNU/Linux the “text vs binary” distinction rarely changes results for normal files; Windows tools may differ in line-ending handling.
- Renaming a file does not change its hash; only content does.
- Truncation/corruption almost always changes the digest — a matching hash is strong integrity evidence against random errors.
- SHA-256 is a one-way fingerprint, not a MAC. For authenticity against an attacker, use **signed** checksums (GPG/cosign) or TLS from a trusted origin.
- Huge files: hashing is CPU + full sequential read; expect time proportional to size.

## Related Commands

- `md5sum` / `sha1sum` / `sha512sum` / `b2sum` — other digests
- `cmp` — direct byte compare of two files
- `diff` — line-oriented text compare
- `openssl dgst -sha256` — OpenSSL digest interface
- `gpg --verify` — signature verification for published artifacts

## Additional Resources

- `man sha256sum`
- Ubuntu installation checksum documentation (per-release)
