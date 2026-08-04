# ftp

## Overview

`ftp` is the classic interactive client for the **File Transfer Protocol**. On modern systems it is largely superseded by **`sftp`/`scp`/`rsync` over SSH** and HTTPS downloads (`curl`/`wget`). Prefer encrypted channels whenever possible — plain FTP sends credentials and data in cleartext.

Many distros ship `ftp` as `ftp` or `tnftp` / require installing `ftp` package; some only provide `lftp` or `sftp`.

## Syntax

```bash
ftp [options] [host]
ftp ftp://user@host/path     # URL form on some clients
```

## Common Options / commands

Client option flags vary. Once connected, interactive commands include:

| Command | Description |
|---------|-------------|
| `open host` | Connect |
| `user` | Authenticate |
| `ls` / `dir` | List remote |
| `cd` / `lcd` | Remote / local directory |
| `get` / `mget` | Download |
| `put` / `mput` | Upload |
| `binary` / `ascii` | Transfer mode |
| `passive` / `passive on` | Passive mode (usually required today) |
| `bye` / `quit` | Exit |
| `hash` | Progress hashes |
| `prompt` | Toggle mget/mput prompts |

## Examples with Explanations

### Interactive session

```bash
ftp ftp.example.com
# Name: anonymous
# Password: user@email
binary
passive
ls
get README
bye
```

### Prefer SFTP instead

```bash
sftp user@host
scp file user@host:/path/
rsync -avP file user@host:/path/
```

### lftp (better modern client)

```bash
lftp ftp://user@host
lftp -e 'set ftp:passive-mode true; mirror -c remote local; bye' host
```

### Scripted (discouraged for secrets)

```bash
ftp -n host <<'EOF'
user anonymous guest@
binary
get file.bin
bye
EOF
```

Credentials in scripts leak; use SSH keys or secret stores.

### Firewall note

Active FTP fails behind NATs; **passive mode** is the norm. Still painful vs SSH.

## Notes / Pitfalls

- Cleartext auth and data — avoid on untrusted networks.
- FTPS (FTP over TLS) is different from SFTP (SSH); know which you need.
- Corporate scanners still find open FTP servers — disable if unused.
- ASCII mode corrupts binaries — use `binary`.
- Many public mirrors moved to HTTPS only.

## 2026-relevant notes

- Treat FTP as legacy interoperability only.
- Default transfer should be `sftp`/`rsync`/`curl` https.
- If you must run a server, prefer SFTP chroots or HTTPS object storage.

## Related Commands

- `sftp` / `scp` / `rsync` — SSH-based transfer
- `lftp` / `ncftp` — richer FTP clients
- `curl` / `wget` — URL downloads
- `ssh` — remote shell + tunnels

## Additional Resources

- `man ftp`, `man sftp`
