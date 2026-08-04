# telnet

## Overview

`telnet` is a historic remote terminal protocol client. **Do not use telnet for remote logins** — it is unencrypted. The remaining legitimate use is as a **crude TCP debugging tool**: check whether a port accepts connections and speak simple line-based protocols by hand.

Prefer `ssh` for logins and `nc`/`openssl s_client`/`curl -v` for protocol debugging.

## Syntax

```bash
telnet [options] host port
telnet host               # default port 23 (avoid)
```

## Common Options

| Option | Description |
|--------|-------------|
| `host port` | Connect to TCP port |
| `-4` / `-6` | Address family |
| `-e char` | Escape character |
| `-E` | Disable escape |
| `-l user` | Autologin user (legacy servers) |

Interactive: escape default often `Ctrl-]`, then `quit`.

## Examples with Explanations

### Port open check

```bash
telnet 192.0.2.10 22
# Trying... Connected to ...  → TCP open
# Connection refused → closed
# Timeout → filtered/dropped
```

Prefer:

```bash
nc -vz 192.0.2.10 22
# or
timeout 3 bash -c 'echo >/dev/tcp/192.0.2.10/22' && echo open
```

### Speak HTTP manually

```bash
telnet example.com 80
# then type:
GET / HTTP/1.0
Host: example.com

# blank line ends headers
```

### SMTP banner grab (authorized testing only)

```bash
telnet mail.example.com 25
```

### Escape and quit

```text
Ctrl-]
telnet> quit
```

### Prefer TLS-aware tools for HTTPS/SMTPS

```bash
openssl s_client -connect example.com:443 -servername example.com
curl -vI https://example.com
```

## Notes / Pitfalls

- Remote shell over telnet is **obsolete and unsafe**.
- “Connected” only means TCP handshake succeeded — not that the app protocol is healthy.
- Line endings and locale can confuse interactive protocol tests.
- Some minimal images omit telnet clients — install `telnet` or use `nc`.
- Never put passwords into telnet sessions on shared screen recordings.

## 2026-relevant notes

- Keep `nc`/`nmap`/`curl` in the toolbox; telnet is optional nostalgia/debug.
- Cloud security groups vs app failures: telnet/nc distinguish network path from HTTP 500s.
- IPv6: explicitly test with `-6` when dual-stack.

## Related Commands

- `nc` / `ncat` — flexible network swiss army knife
- `ssh` — secure remote login
- `openssl s_client` — TLS debugging
- `curl` -v — HTTP debugging
- `nmap` — broader port scans (authorized)

## Additional Resources

- `man telnet`
