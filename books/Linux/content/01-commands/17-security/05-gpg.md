# gpg

## Overview

`gpg` (GnuPG) is the OpenPGP tool for **encrypting**, **decrypting**, **signing**, and **verifying** files and data. Operators use it to protect backups and secrets off-box, to exchange confidential artifacts with colleagues, and — most often on Ubuntu servers — to **verify signed checksum lists** before trusting an ISO or release tarball. Prefer GnuPG for human/operator file crypto and signature checks; use `openssl` for TLS cert triage and ACME clients for certificate issuance.

On Ubuntu 22.04/24.04 Server the package is `gnupg` (GnuPG 2.x; `gpg` is the CLI). Minimal installs may already include it; if not, install once and keep the keyring under `~/.gnupg` backed up and mode-restricted.

```bash
sudo apt update
sudo apt install gnupg
gpg --version
```

## Syntax

```bash
gpg [options] command [args]
gpg -c file                    # symmetric encrypt
gpg -e -r recipient file       # public-key encrypt
gpg -d file.gpg                # decrypt
gpg -b --armor file            # detached ASCII signature
gpg --verify sig data          # verify signature
```

## Common Options

| Option | Description |
|--------|-------------|
| `-c`, `--symmetric` | Encrypt with a passphrase (AES-256 default on modern GnuPG) |
| `-e`, `--encrypt` | Encrypt to one or more public keys |
| `-d`, `--decrypt` | Decrypt to stdout (or `-o`); also verifies an inner signature |
| `-s`, `--sign` | Sign with your private key (combinable with encrypt) |
| `-b`, `--detach-sign` | Create a detached signature (preferred for releases) |
| `-a`, `--armor` | ASCII-armor output (`.asc` instead of binary `.gpg`/`.sig`) |
| `-r`, `--recipient` | Recipient user-id / email / fingerprint for `-e` |
| `-u`, `--local-user` | Select which private key signs |
| `-o`, `--output` | Output path (avoid overwriting sources by accident) |
| `-k`, `--list-keys` | List public keys |
| `-K`, `--list-secret-keys` | List secret keys |
| `--fingerprint` | List keys with fingerprints (compare out-of-band) |
| `--import` / `--export` | Import or export keys |
| `--full-generate-key` | Interactive key generation (all options) |
| `--batch` | Non-interactive / script-friendly mode |
| `--yes` | Assume yes on prompts (use carefully) |

## Safety

- **Private keys and passphrases** never belong in tickets, chat, or world-readable paths. Keep `~/.gnupg` at `700` and secret key material at `600`.
- Encrypting to the wrong recipient is silent until decrypt fails elsewhere — always confirm **fingerprint** over a second channel before trusting an imported key.
- `gpg --verify` reporting “Good signature” with trust `[unknown]` only means the crypto matched **some** key in your keyring — not that you have identified the signer. Compare fingerprints, then assign ownertrust if you rely on that key regularly.
- Symmetric encryption (`-c`) caches the passphrase in `gpg-agent` briefly; use `--no-symkey-cache` when sharing a console.
- Never email or paste `--export-secret-keys` output. Paper or offline encrypted backups only.
- For unattended verify-only workflows, prefer `gpgv` with an explicit `--keyring` of keys you already trust.

## Key Use Cases

1. Symmetric encrypt a config or backup tarball for transport.
2. Generate or import a key, list fingerprints, exchange public keys.
3. Encrypt a file to a colleague’s public key; decrypt inbound mail attachments.
4. Detached-sign a release artifact; verify a vendor’s signature.
5. Verify Ubuntu/ISO `SHA256SUMS` + `.gpg` before installing from a mirror.

## Examples with Explanations

### Example: install and confirm the toolchain

```bash
sudo apt update
sudo apt install -y gnupg
gpg --version
# gpg (GnuPG) 2.4.x on Ubuntu 24.04 (noble); 2.2.x on 22.04 (jammy)
```

Ubuntu’s `gnupg` meta-package pulls in `gpg`, `gpg-agent`, and related helpers. Re-check after major upgrades if scripts assume specific default ciphers.

### Example: generate a key pair (interactive)

```bash
gpg --full-generate-key
# Choose: (1) RSA and RSA, 3072+ bits — or the offered ECC default on newer GnuPG
# Real name / email / comment → passphrase → wait for entropy
```

This walks through algorithm, size/curve, expiry, and user-id. A revocation certificate is written under `~/.gnupg/openpgp-revocs.d/` — back that up offline. For fully scripted labs, prefer `gpg --batch --passphrase … --quick-generate-key` (see Notes).

### Example: list keys and show fingerprints

```bash
gpg --list-secret-keys --keyid-format=long
gpg --list-keys --keyid-format=long
gpg --fingerprint alice@example.com
```

Fingerprints are the 40-hex identity you compare on a call or printed card before trusting a key. Prefer fingerprint (or full fingerprint) over short key IDs — short IDs are forgeable.

### Example: export and import a public key

```bash
gpg --armor --export alice@example.com > alice-public.asc
# hand alice-public.asc to the peer over any channel; authenticity comes from fingerprint check

gpg --import bob-public.asc
gpg --fingerprint bob@example.com
# Compare every hex group with Bob over a second channel before encrypting to him
```

`--armor` (`-a`) produces mail-safe ASCII. Import alone does **not** mean “trusted” — only that the key is available for encrypt/verify once you decide it is the right one.

### Example: symmetric encrypt and decrypt a file

```bash
gpg --symmetric --armor secrets.env
# prompts for passphrase twice → writes secrets.env.asc

gpg --decrypt --output secrets.env secrets.env.asc
# or: gpg -d -o secrets.env secrets.env.asc
chmod 600 secrets.env
```

Symmetric mode needs no key pair — good for “encrypt this tarball for myself on another host.” Prefer `--armor` when the ciphertext must survive email or paste; omit it for large binaries (smaller `.gpg`). Always write decrypt output with `-o` to a controlled path rather than relying on embedded filenames.

### Example: public-key encrypt and decrypt

```bash
# Encrypt for Bob (his public key must already be imported)
gpg --encrypt --recipient bob@example.com --armor report.tar.gz
# → report.tar.gz.asc

# Bob decrypts with his private key
gpg --decrypt --output report.tar.gz report.tar.gz.asc
```

Anyone with Bob’s public key can encrypt; only Bob’s private key decrypts. Combine with signing when you also need authenticity: `gpg -s -e -r bob@example.com file`.

### Example: detached sign and verify (ASCII)

```bash
gpg --detach-sign --armor release.tar.gz
# → release.tar.gz.asc   (signature only; original file unchanged)

gpg --verify release.tar.gz.asc release.tar.gz
# gpg: Good signature from "Alice <alice@example.com>"
```

Detached signatures are the release-engineering default: ship `artifact` + `artifact.asc` (or `.sig`). Always pass **both** the signature and the data to `--verify`; do not rely on suffix guessing. Cleartext (`--clear-sign`) is for human-readable messages, not binary releases.

### Example: verify a signed checksum list (download integrity)

```bash
# Typical Ubuntu Server ISO layout next to the image:
#   SHA256SUMS          — published digests
#   SHA256SUMS.gpg      — detached signature over that list

gpg --keyid-format long --verify SHA256SUMS.gpg SHA256SUMS
# If the signing key is missing, fetch from a trusted keyserver or keyring, then:
#   gpg --keyserver hkps://keyserver.ubuntu.com --recv-keys <FINGERPRINT>
# Re-run verify, then confirm the fingerprint matches Ubuntu’s published Image Signing key.

sha256sum -c --ignore-missing SHA256SUMS
```

Workflow: (1) verify the signature on `SHA256SUMS`, (2) only then run `sha256sum -c`. A matching hash without a verified signature only proves integrity against the list you downloaded — not that Canonical (or the vendor) published that list. On a stock Ubuntu system, `ubuntu-keyring` / archive keyrings often already hold the CD Image signing keys; use `gpgv --keyring /usr/share/keyrings/…` when you want verify-only against a pinned keyring.

### Example: armor / dearmor a keyring blob for apt-style keyrings

```bash
# Convert ASCII public key material to a binary keyring file (common for /usr/share/keyrings)
curl -fsSL https://example.com/project.asc | sudo gpg --dearmor -o /usr/share/keyrings/project.gpg
sudo chmod 644 /usr/share/keyrings/project.gpg
```

`gpg --dearmor` / `--enarmor` pack or unpack OpenPGP ASCII armor. Modern `apt` sources often point at a `.gpg` keyring under `/usr/share/keyrings/` rather than the legacy trusted.gpg keyring — keep permissions non-secret (`644`) for public keys.

## Understanding Output

| Message / field | Meaning |
|-----------------|--------|
| `Good signature from "…"` | Cryptographic match to a key you have; check trust/fingerprint next |
| `BAD signature` | Data or signature was altered, or wrong key — do not trust the file |
| `Can't check signature: No public key` | Import the signer’s key (after fingerprint check) and retry |
| `[unknown]` trust | Key is present but you have not assigned ownertrust / certified it |
| `sec` / `ssb` vs `pub` / `sub` | Secret primary/subkey vs public primary/subkey in `--list-*` output |
| `#` after `sec`/`ssb` | Secret key not currently usable (e.g. offline / stub) |

Exit status is non-zero on failed verify/decrypt — usable in scripts with `set -e` or `gpg --verify … \|\| exit 1`. For machine parsing of key lists, use `--with-colons` (human `--list-keys` format is not stable).

## Notes & Pitfalls

- **Short key IDs are unsafe** for identification; always use full fingerprints.
- `gpg` and `gpg2` on older docs usually mean the same GnuPG 2.x binary named `gpg` on current Ubuntu.
- Default symmetric cipher is AES-256 on modern GnuPG; do not weaken it with casual `--cipher-algo` experiments.
- Agent caching: decrypt/sign may not re-prompt immediately — expected with `gpg-agent`.
- Batch/CI keygen needs `--batch`, explicit algorithm, and a controlled passphrase source; interactive `--full-generate-key` is for humans.
- macOS/Homebrew and BusyBox environments differ; this page assumes GNU userland on Ubuntu Server.
- Encrypting a directory: archive first (`tar czf - dir | gpg -c -o dir.tgz.gpg`), then decrypt/extract in reverse — `gpg` operates on files/streams, not trees.

## Related Commands

- `gpgv` — verify-only tool against a trusted keyring (good for scripts)
- `sha256sum` — check digests after the signature on the checksum file is verified
- `openssl` — TLS/cert inspection; different problem space than OpenPGP file crypto
- `ssh-keygen` — SSH identities (not interchangeable with OpenPGP keys)
- `apt-key` — **deprecated**; use `signed-by=` + `/usr/share/keyrings/*.gpg` instead

## Additional Resources

- `man gpg` (Ubuntu jammy/noble)
- [GnuPG operational commands](https://www.gnupg.org/documentation/manuals/gnupg/Operational-GPG-Commands.html)
- [Ubuntu image integrity verification](https://documentation.ubuntu.com/security/software-integrity/image-verification/)
- [Ubuntu: set up and manage PGP keys](https://documentation.ubuntu.com/project/contributors/setup/set-up-and-manage-pgp-keys/)
