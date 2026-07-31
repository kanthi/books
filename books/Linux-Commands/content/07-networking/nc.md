# nc (netcat)

## Overview
`nc` reads and writes TCP/UDP streams. Great for port checks, quick listeners, and one-off transfers. Behavior differs between **OpenBSD netcat**, **ncat** (nmap), and traditional netcat — check `nc -h`.

## Syntax
```bash
nc [options] host port
nc -l [options] port
```

## Common Options (vary by implementation)
| Option | Description |
|--------|-------------|
| `-l` | Listen |
| `-u` | UDP |
| `-v` | Verbose |
| `-n` | No DNS |
| `-z` | Scan only (zero-I/O) |
| `-w secs` | Timeout |
| `-k` | Listen keeps accepting (OpenBSD) |
| `-U` | UNIX socket |

## Safety
Do not expose shell-exec listeners on untrusted networks. Some builds offer `-e`/`-c` to exec programs — treat as dangerous. Prefer `ss`/`curl`/`nmap` for routine audits.

## Examples with Explanations
### Port open check
```bash
nc -zv example.com 443
nc -zvw3 192.168.1.10 22
```

### Simple TCP listener + client
```bash
# terminal A
nc -l 12345
# terminal B
nc 127.0.0.1 12345
```

### File transfer (trusted LAN)
```bash
# receiver
nc -l 9000 > file.bin
# sender
nc target 9000 < file.bin
```

### HTTP probe
```bash
printf 'GET / HTTP/1.0\r\nHost: example.com\r\n\r\n' | nc example.com 80 | head
```

### UDP
```bash
nc -u -l 9999
nc -u host 9999
```

### Banner grab
```bash
echo | nc -vw3 host 25
```

## Notes
- Prefer `nmap -p` for multi-port scanning ethics/scope.  
- For TLS, use `openssl s_client` or `curl -v`, not bare `nc`.  
- Package names: `netcat-openbsd`, `ncat`, `netcat-traditional`.

## Related Commands
- `ss` — local listeners  
- `nmap` — scanners  
- `curl` / `wget` — HTTP  
- `socat` — richer relay tool
