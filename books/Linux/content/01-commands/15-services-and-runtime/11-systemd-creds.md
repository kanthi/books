# systemd-creds

## Overview

`systemd-creds` lists, shows, **encrypts**, and **decrypts** [system and service credentials](https://systemd.io/CREDENTIALS/) — small secrets and parameters passed into units as files under `$CREDENTIALS_DIRECTORY`, not as inherited environment variables. Encrypted credentials use AES256-GCM with a key derived from the **TPM2**, a host secret under `/var/lib/systemd/credential.secret`, or both (default when TPM and persistent `/var` exist).

Companion unit settings (see `systemd.exec(5)`): `LoadCredential=`, `LoadCredentialEncrypted=`, `SetCredential=`, `SetCredentialEncrypted=`, `ImportCredential=`.

## Syntax

```bash
systemd-creds [OPTIONS] list
systemd-creds [OPTIONS] cat NAME
systemd-creds encrypt [OPTIONS] INPUT|- OUTPUT|-
systemd-creds decrypt [OPTIONS] INPUT|- OUTPUT|-
systemd-creds setup   # ensure host credential secret exists (as needed)
```

Common options:

| Option | Meaning |
|--------|---------|
| `--system` | Operate on **system** credentials (PID1), not the current service context |
| `--name=NAME` | Embed/override credential name in the encrypted blob |
| `-p` / `--pretty` | With `encrypt` and stdout: print a `SetCredentialEncrypted=` line for unit files |
| `--with-key=host\|tpm2\|auto\|…` | Select encryption key backend (see man page; `auto` is typical) |
| `-H` / `-T` | Shortcuts affecting host/TPM key use (see `systemd-creds(1)`) |

## Safety

- Plaintext files used as `encrypt` input should be `shred -u` (or equivalent) after producing ciphertext.
- `SetCredential=` in unit files is **world-readable** — never put raw secrets there; use `SetCredentialEncrypted=` or `LoadCredentialEncrypted=`.
- Decryption needs the **same machine** key material (TPM +/or `/var` secret). Ciphertext is not portable across hosts by default.
- Credentials are limited (~1 MiB per service aggregate). Not a general secret store for huge blobs.
- Prefer `PrivateMounts=` / sandboxing so `$CREDENTIALS_DIRECTORY` is not visible to other services.

## Examples with Explanations

### Encrypt a file and load it in a transient service

```bash
echo -n 'supersecret' > /tmp/db.pass
systemd-creds encrypt --name=dbpass /tmp/db.pass /etc/credstore.encrypted/dbpass.cred
shred -u /tmp/db.pass

sudo systemd-run -P --wait \
  -p LoadCredentialEncrypted=dbpass:/etc/credstore.encrypted/dbpass.cred \
  systemd-creds cat dbpass
# prints: supersecret
```

`LoadCredentialEncrypted=` decrypts at activation and exposes plaintext only as `$CREDENTIALS_DIRECTORY/dbpass` inside the service.

### Emit `SetCredentialEncrypted=` for a unit file

```bash
systemd-ask-password -n | systemd-creds encrypt --name=mysql-password -p - -
# Paste the printed SetCredentialEncrypted=mysql-password: \ … block into the unit [Service] section
```

### Relative names and credstore search paths

With a **relative** source, systemd searches system credentials, then `/etc/credstore/`, `/run/credstore/`, `/usr/lib/credstore/` (and `*.encrypted` variants for encrypted load/import):

```bash
sudo mkdir -p /etc/credstore.encrypted
sudo systemd-creds encrypt --name=api-token - /etc/credstore.encrypted/api-token.cred <<'EOF'
tok_desk_example
EOF

# Unit snippet:
# [Service]
# LoadCredentialEncrypted=api-token
# ExecStart=/usr/local/bin/app --token-file=${CREDENTIALS_DIRECTORY}/api-token
```

### List / show in context

```bash
# From an interactive shell (usually empty):
systemd-creds list

# System credentials passed into the machine:
systemd-creds --system list
systemd-creds --system cat some-name
```

### Application read pattern

```bash
# Inside the service (ExecStart script):
#   test -n "$CREDENTIALS_DIRECTORY"
#   install -m 0400 "$CREDENTIALS_DIRECTORY/dbpass" /run/app/db.pass
# Or point the daemon at %d/dbpass via Environment= or ExecStart=
```

In unit files, `%d` expands to the credential directory — useful for `Environment=TOKEN_FILE=%d/api-token` without hardcoding `/run/credentials/…`.

### TPM / host key notes

```bash
# Default encrypt binds to local TPM2 + host secret when available
systemd-creds encrypt --name=backup ./plaintext ./plaintext.cred

# Initrd/generator consumers may need TPM-only wrapping so /var is not required yet:
systemd-creds encrypt --with-key=auto-initrd --name=early ./plaintext ./plaintext.cred
```

Exact `--with-key=` values evolve with systemd releases — check `systemd-creds encrypt --help` on the target host.

## Related Commands

| Command / setting | Role |
|-------------------|------|
| `LoadCredential=` | Load plaintext credential from path / AF_UNIX / system cred |
| `LoadCredentialEncrypted=` | Load ciphertext; decrypt at activation |
| `SetCredentialEncrypted=` | Embed ciphertext in the unit file |
| `ImportCredential=` | Pull from credstore / system credentials by name/glob |
| `systemd-run -p LoadCredentialEncrypted=` | Experiment without writing a unit |
| `systemd-ask-password` | Prompt; pipe into `systemd-creds encrypt -p` |

## Try this

1. Encrypt a one-line secret to `/tmp/demo.cred`, run `systemd-run` with `LoadCredentialEncrypted=`, and `cat` it via `systemd-creds`.
2. Generate a `SetCredentialEncrypted=` line with `-p` and drop it into a throwaway unit under `/etc/systemd/system/`.
3. Compare `systemd-creds encrypt --help` key backends on a machine with and without TPM2.
4. Confirm a non-root service user can read `$CREDENTIALS_DIRECTORY/NAME` but another user cannot.

## Sources

- [systemd — System and Service Credentials](https://systemd.io/CREDENTIALS/)
- [systemd-creds(1)](https://www.freedesktop.org/software/systemd/man/latest/systemd-creds.html)
- [systemd.exec(5) — credential settings](https://www.freedesktop.org/software/systemd/man/latest/systemd.exec.html)
