# openssl

## Overview

`openssl` is a Swiss-army toolkit for TLS/SSL, X.509 certificates, keys, digests, and simple encrypted files. Operators use it to inspect certificates, test TLS handshakes to a host:port, generate CSRs/self-signed certs for labs, and convert PEM/DER formats. It is not a full ACME client — prefer `certbot`/`acme.sh` for Let’s Encrypt production issuance. Deep crypto design and application embedding belong elsewhere; this page is **operator triage**.

## Syntax

```bash
openssl <subcommand> [options]
openssl help
openssl help s_client
```

Common subcommands: `s_client`, `x509`, `req`, `rsa`, `ec`, `pkey`, `dgst`, `rand`, `enc`, `version`.

## Common Subcommands & Options

| Area | Command sketch | Role |
|------|----------------|------|
| TLS probe | `openssl s_client -connect host:443` | Live handshake + cert chain |
| Show cert | `openssl x509 -in f.pem -noout -text` | Decode PEM certificate |
| CSR | `openssl req -new -…` | Certificate signing request |
| Digest | `openssl dgst -sha256 file` | Hash file |
| Random | `openssl rand -hex 16` | Random bytes |
| Connect SNI | `s_client -servername name -connect …` | Virtual-host TLS |

### s_client (frequent flags)

| Option | Description |
|--------|-------------|
| `-connect host:port` | Target |
| `-servername name` | SNI (required for most vhosts) |
| `-showcerts` | Print full chain |
| `-starttls smtp\|imap\|…` | STARTTLS protocols |
| `-alpn h2,http/1.1` | ALPN offer |
| `-tls1_2` / `-tls1_3` | Pin protocol (version-dependent) |
| `-status` | OCSP stapling request |

### x509 (frequent flags)

| Option | Description |
|--------|-------------|
| `-in file` / `-out file` | Input/output |
| `-noout` | Don’t emit encoded cert |
| `-text` | Full decode |
| `-subject` `-issuer` `-dates` | Short fields |
| `-fingerprint -sha256` | Fingerprint |
| `-inform PEM\|DER` | Encoding |

## Safety

- Never paste **private keys** into tickets/chat. Mode `600`, dedicated paths.
- Self-signed lab certs are fine for experiments; browsers/clients will warn — don’t disable verification in production clients casually.
- `openssl enc` password-based file encryption is easy to misuse (KDF/parameters); prefer age/GPG for human file encryption workflows unless you know the flags.
- Old TLS versions may be disabled in modern OpenSSL builds — failures can mean policy, not “host down”.

## Examples with Explanations

### Version and providers

```bash
openssl version -a
```

Confirms library version (3.x on current Ubuntu LTS).

### Probe a website’s certificate

```bash
echo | openssl s_client -servername example.com -connect example.com:443 2>/dev/null | openssl x509 -noout -subject -issuer -dates
```

`echo |` completes the session so `s_client` exits. Always set **SNI** (`-servername`) for shared hosting.

### Full chain and leaf details

```bash
echo | openssl s_client -showcerts -servername example.com -connect example.com:443 2>/dev/null | less
echo | openssl s_client -servername example.com -connect example.com:443 2>/dev/null \
  | openssl x509 -noout -text | less
```

### SHA-256 fingerprint

```bash
echo | openssl s_client -servername example.com -connect example.com:443 2>/dev/null \
  | openssl x509 -noout -fingerprint -sha256
openssl x509 -in /etc/ssl/certs/ssl-cert-snakeoil.pem -noout -fingerprint -sha256
```

### Inspect a local PEM cert

```bash
openssl x509 -in fullchain.pem -noout -subject -issuer -dates
openssl x509 -in fullchain.pem -noout -ext subjectAltName
```

### STARTTLS (mail example)

```bash
openssl s_client -starttls smtp -connect mail.example.com:587 -servername mail.example.com
```

### Generate lab key + self-signed cert

```bash
openssl req -x509 -newkey rsa:2048 -keyout lab.key -out lab.crt -days 365 -nodes \
  -subj '/CN=lab.local'
chmod 600 lab.key
```

For anything public-facing, use a real CA (ACME). `-nodes` leaves the key unencrypted on disk — protect the file.

### CSR for an external CA

```bash
openssl req -new -newkey rsa:2048 -nodes -keyout app.key -out app.csr \
  -subj '/CN=app.example.com'
openssl req -in app.csr -noout -text | head
```

### PEM ↔ DER

```bash
openssl x509 -in cert.pem -outform DER -out cert.der
openssl x509 -inform DER -in cert.der -out cert.pem
```

### Digests (alternate to *sum tools)

```bash
openssl dgst -sha256 image.iso
openssl dgst -sha512 file.bin
```

### Random secrets

```bash
openssl rand -base64 32
openssl rand -hex 16
```

### Quick HTTPS port check (banner/handshake only)

```bash
echo | timeout 5 openssl s_client -connect 203.0.113.10:443 -servername app.example.com
```

Useful when `curl` fails and you need to see whether TLS negotiates at all.

## Notes

- Ubuntu packages: `openssl` CLI; libraries via `libssl*`.
- Certificate stores: system CAs under `/etc/ssl/certs` (managed by `ca-certificates`).
- `s_client` is a debugger, not a browser — it may accept certs your app stack rejects depending on flags/defaults.
- OpenSSL 3 moved some algorithms to the “legacy” provider; rare old ciphers need extra config.
- Prefer `curl -vI --tlsv1.2` for HTTP-level checks; use `openssl s_client` for raw TLS/cert focus.

## Related Commands

- `curl` — HTTPS client with cert options
- `certbot` / ACME clients — issuance/renewal
- `update-ca-certificates` — trust store
- `sha256sum` — simple file digests
- `nft` / `ufw` — not TLS; path/firewall side
- `dig` / `host` — DNS before TLS troubleshooting

## Additional Resources

- `man openssl`, `man openssl-s_client`, `man openssl-x509`
- [OpenSSL documentation](https://www.openssl.org/docs/)
