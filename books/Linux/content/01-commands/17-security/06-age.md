# age

## Overview

`age` is a **simple, modern file encryption** tool: small explicit keys, no config file, and UNIX-style pipes. Operators use it to encrypt backups, secrets, and tarballs for transport without the ceremony of OpenPGP. Prefer **`age`** when you want “encrypt this file to these recipients and decrypt later with an identity file.” Prefer **`gpg`** when you need signatures, web-of-trust workflows, or verifying vendor-signed checksum lists (see Related). Prefer `openssl` for TLS cert triage — different problem space.

On Ubuntu 22.04/24.04 Server, install from universe:

```bash
sudo apt update
sudo apt install age
age --version
age-keygen --version
```

Jammy ships age **1.0.x**; Noble ships **1.1.x**. Both cover the classic X25519 workflow below. Newer upstream builds also offer post-quantum hybrid keys (`age-keygen -pq`); check `age-keygen --help` before relying on `-pq` on an older package.

## Syntax

```bash
age-keygen [-o OUTPUT]                  # generate identity (+ print recipient)
age-keygen -y [-o OUTPUT] [IDENTITY]    # identity → recipient(s)

age [-e] (-r RECIPIENT | -R PATH)... [-a] [-o OUTPUT] [INPUT]
age [-e] -p [-a] [-o OUTPUT] [INPUT]    # passphrase (interactive)
age -d [-i IDENTITY]... [-o OUTPUT] [INPUT]
```

## Common Options

| Option | Description |
|--------|-------------|
| `-r`, `--recipient` | Encrypt to one recipient string (`age1…`, or `ssh-ed25519` / `ssh-rsa …`) |
| `-R`, `--recipients-file` | Encrypt to recipients listed in a file (one per line; `#` comments OK) |
| `-i`, `--identity` | Decrypt with an identity file (native age secret, passphrase-wrapped identity, or SSH private key) |
| `-d`, `--decrypt` | Decrypt mode |
| `-p`, `--passphrase` | Encrypt with an interactive passphrase (not combinable with `-r`/`-R`) |
| `-a`, `--armor` | ASCII-armor ciphertext (PEM-like `AGE ENCRYPTED FILE`) |
| `-o`, `--output` | Output path (overwrites if present) |
| `-e`, `--encrypt` | Explicit encrypt mode (required when encrypting with `-i`) |
| `-y` (keygen) | Convert an identity file to its public recipient string(s) |
| `-pq` (keygen) | Generate a post-quantum hybrid ML-KEM-768 + X25519 identity (newer age only) |

## Safety

- **Identity files are private keys.** Mode `600`, directory not world-readable, never commit to git or paste into tickets.
- Encrypting to the **wrong recipient** succeeds locally — only the matching identity can decrypt. Confirm the `age1…` string (or SSH fingerprint) out-of-band before shipping secrets.
- `-o` **overwrites** an existing output path without prompting.
- Passphrase mode (`-p`) is for “encrypt for myself with a memorable secret.” Do not combine mental models: a passphrase-encrypted file is not the same as a passphrase-**protected identity** file.
- SSH recipients are a **convenience**. Prefer native age keys for long-term encryption; SSH keys are often rotated for auth and may live on hardware tokens / `ssh-agent` (neither is supported for decrypt).
- Do **not** mix classic (`age1…`) and post-quantum (`age1pq1…`) recipients on one ciphertext — that would defeat the PQ guarantee. Newer age rejects that combination.
- Partial decrypt failures never release unauthenticated plaintext, but a failed run can still leave a truncated `-o` file you created — verify exit status before trusting outputs.

## Key Use Cases

1. Generate a key pair; encrypt a file or stream to your public recipient; decrypt with the identity.
2. Encrypt one artifact to several teammates via `-r` / `-R`.
3. Armor ciphertext for email or paste (`-a`).
4. Reuse an existing Ed25519/RSA SSH public key as a recipient when the peer has no age key yet.
5. Pipe `tar` into `age` for encrypted directory archives.

## Examples with Explanations

### Example: install and confirm the toolchain

```bash
sudo apt update
sudo apt install -y age
age --version
age-keygen --version
# Ubuntu 22.04 (jammy): typically age 1.0.x from universe
# Ubuntu 24.04 (noble): typically age 1.1.x from universe
```

If `apt` cannot find the package, enable the **universe** component and retry. For a newer upstream binary than the distro package, use the [official install options](https://github.com/FiloSottile/age#installation) — this page assumes the Ubuntu package unless noted.

### Example: generate a native identity

```bash
umask 077
age-keygen -o ~/age-key.txt
# Public key: age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
chmod 600 ~/age-key.txt
```

`age-keygen` writes the **identity** (secret) to the file and prints the **recipient** (public) to stderr when not writing to a TTY. The identity file looks like:

```text
# created: 2024-01-02T15:30:45+01:00
# public key: age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
AGE-SECRET-KEY-1...
```

Back up the identity offline. Share only the `age1…` public string.

On age builds that support it, prefer post-quantum hybrid keys for new long-lived identities:

```bash
age-keygen -pq -o ~/age-key-pq.txt
# Public key: age1pq1…   (much longer than classic age1…)
# Identity line: AGE-SECRET-KEY-PQ-1…
```

### Example: identity → recipient string

```bash
age-keygen -y ~/age-key.txt
# age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
```

Use this when you have the identity file and need the public string for a recipients list or a colleague’s `-r` flag — without opening the file and copying by hand.

### Example: encrypt and decrypt a file (native recipient)

```bash
RECIPIENT="$(age-keygen -y ~/age-key.txt)"
age -r "$RECIPIENT" -o secrets.env.age secrets.env
# or armor for mail/paste:
age -a -r "$RECIPIENT" -o secrets.env.age secrets.env

age -d -i ~/age-key.txt -o secrets.env secrets.env.age
chmod 600 secrets.env
```

Anyone with the recipient can encrypt; only the matching identity decrypts. Armor (`-a`) is detected automatically on decrypt — you do not pass `-a` to `-d`.

### Example: multiple recipients and a recipients file

```bash
age -o report.tar.gz.age \
  -r age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p \
  -r age1zggyaq84g3u5l9hc1amf5eenc9h66ysyzx9h4j9un9au0z9wl34jsj5r3t \
  report.tar.gz

cat > recipients.txt <<'EOF'
# Alice — ops laptop
age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p
# Bob — backup host
age1zggyaq84g3u5l9hc1amf5eenc9h66ysyzx9h4j9un9au0z9wl34jsj5r3t
EOF
age -R recipients.txt -o report.tar.gz.age report.tar.gz
```

Every listed recipient can decrypt independently. Keep `recipients.txt` as ordinary public data; never put `AGE-SECRET-KEY-…` lines there.

### Example: passphrase encrypt (no key file)

```bash
age -p -o notes.txt.age notes.txt
# Enter passphrase (leave empty to autogenerate a secure one):

age -d -o notes.txt notes.txt.age
# Enter passphrase:
```

Good for ad-hoc “encrypt this for myself on another machine” without managing identity files. For automation and multi-recipient sharing, use native keys instead.

### Example: passphrase-protected identity file

```bash
# Wrap a newly generated identity with a passphrase
age-keygen | age -p -o ~/age-key.age
# note the Public key: age1… line from stderr — store that as the recipient

age -r age1ql3z7hjy54pw3hyww5ayyfg7zqgvc7w3j2elw8zmrj2kg5sfn9aqmcac8p \
  -o secrets.env.age secrets.env

age -d -i ~/age-key.age -o secrets.env secrets.env.age
# Enter passphrase for identity file "…/age-key.age":
```

The identity file itself is an age-encrypted blob of `AGE-SECRET-KEY-…` lines. Decrypting data prompts for that passphrase only when this identity is needed. For most single-user laptops, a plain `600` identity file is enough; wrap it when the identity might sit on shared or less-trusted storage.

### Example: encrypt to an SSH public key

```bash
age -R ~/.ssh/id_ed25519.pub -o example.jpg.age example.jpg
age -d -i ~/.ssh/id_ed25519 -o example.jpg example.jpg.age
```

Supported SSH types: **Ed25519** and **RSA ≥ 2048**. age ignores unsupported keys in a `-R` file with a warning (handy with `authorized_keys` or `https://github.com/<user>.keys`). Decrypt needs the **private key file** on disk — not `ssh-agent`, not a YubiKey-held SSH key.

### Example: compose with tar (directory archive)

```bash
RECIPIENT="$(age-keygen -y ~/age-key.txt)"
tar czf - /var/backups/app | age -r "$RECIPIENT" > app-backup.tar.gz.age

age -d -i ~/age-key.txt app-backup.tar.gz.age | tar tzf - | head
age -d -i ~/age-key.txt -o app-backup.tar.gz app-backup.tar.gz.age
tar xzf app-backup.tar.gz -C /restore/path
```

`age` encrypts a **single stream or file**, not a directory tree. Always archive first (`tar`/`cpio`), then encrypt; reverse the order on restore. Binary ciphertext through a pipe needs no `-a`.

### Example: encrypt using an identity file’s matching recipient

```bash
# Explicit -e required when -i is used for encryption
age -e -i ~/age-key.txt -o self.age secrets.env
age -d -i ~/age-key.txt -o secrets.env self.age
```

Equivalent to converting the identity with `age-keygen -y` and passing `-R`. Useful in scripts that only keep the identity path on hand.

## Understanding Output

| Item | Meaning |
|------|---------|
| `Public key: age1…` / `age1pq1…` | Recipient string — safe to share / put in `-r` / recipients files |
| `AGE-SECRET-KEY-1…` / `AGE-SECRET-KEY-PQ-1…` | Identity — secret; stays in the key file |
| `.age` ciphertext | Binary by default; small overhead per recipient plus streaming AEAD |
| Armored blob | PEM-like with type `AGE ENCRYPTED FILE`; decrypt auto-detects |
| Exit status `0` | Full encrypt/decrypt succeeded; non-zero → do not trust partial `-o` |

There is no “Good signature” story — age is encryption (and AEAD integrity of the ciphertext), not a signing tool. For authenticity of downloads, use `gpg --verify` on vendor signatures.

## Notes & Pitfalls

- **age vs gpg:** age wins on simple file encryption UX and scripting. gpg wins on signatures, keyservers, and Ubuntu ISO / `SHA256SUMS.gpg` verification workflows.
- Ubuntu package versions lag upstream; confirm `age-keygen --help` for `-pq` before documenting PQ keys in your runbooks.
- Binary age output to a TTY is refused unless you force `-o -` — prefer a file or a pipe.
- `-R -` reads recipients from stdin; then you **must** pass an INPUT filename (stdin is already used).
- Do not put identity material in `recipients.txt`. Comments (`#`) and blank lines are fine in recipient lists.
- Plugins (for example YubiKey) use `age1…plugin…` recipients and matching `AGE-PLUGIN-…` identities; install the plugin binary on `PATH` when you decrypt.
- macOS Homebrew and distro packages are fine; this page’s install path is Ubuntu `apt`.

## Related Commands

- `gpg` — OpenPGP encrypt/sign/verify; use for signed checksums and existing PGP workflows
- `openssl` — TLS/cert inspection; not a replacement for age file encryption
- `ssh-keygen` — create SSH keys you may reuse as age recipients
- `tar` / `gzip` — archive before encrypting directories
- `sha256sum` — integrity of plaintext or of published digests (after signature verify with gpg)

## Additional Resources

- `man age` / `man age-keygen` (Ubuntu jammy/noble)
- [age README and install matrix](https://github.com/FiloSottile/age)
- [age format specification](https://age-encryption.org/v1)
- [Debian/Ubuntu age(1) man page](https://manpages.debian.org/testing/age/age.1.en.html)
