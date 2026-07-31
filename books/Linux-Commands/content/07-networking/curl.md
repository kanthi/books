# curl

## Overview
`curl` transfers data to/from URLs. It supports HTTP(S), FTP, SFTP, and many other protocols — the Swiss army knife for APIs, downloads, and health checks.

## Syntax
```bash
curl [options] [URL...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-O` | Save using remote file name |
| `-o file` | Save to file |
| `-L` | Follow redirects |
| `-f` | Fail on HTTP errors (exit non-zero) |
| `-sS` | Silent but show errors |
| `-v` | Verbose (headers, TLS) |
| `-I` | HEAD request |
| `-X METHOD` | Custom method |
| `-H "K: V"` | Request header |
| `-d data` / `--json` | Body (form / JSON helper on new curl) |
| `-u user:pass` | Auth |
| `-A agent` | User-Agent |
| `-m secs` | Max time |
| `-w fmt` | Write-out variables after transfer |
| `-k` | Insecure TLS (avoid in prod) |
| `-C -` | Resume transfer |

## Key Use Cases
1. Download artifacts  
2. Call REST APIs  
3. Debug HTTP headers and TLS  
4. Script health checks  

## Examples with Explanations
### Download
```bash
curl -LO https://example.com/file.tgz
```

### API GET with pretty JSON
```bash
curl -sS https://api.github.com/repos/jqlang/jq | jq .
```

### POST JSON
```bash
curl -sS -X POST https://httpbin.org/post \
  -H 'Content-Type: application/json' \
  -d '{"name":"ada","ok":true}' | jq .
```

### Headers only
```bash
curl -sSI https://example.com
```

### Follow redirects, fail on 404
```bash
curl -fsSL -o out.html https://example.com/missing || echo "failed:$?"
```

### Timing metrics
```bash
curl -o /dev/null -sS -w 'dns:%{time_namelookup} connect:%{time_connect} ttfb:%{time_starttransfer} total:%{time_total}\n' https://example.com
```

### Auth header
```bash
curl -sS -H "Authorization: Bearer $TOKEN" https://api.example.com/v1/me
```

### Upload file
```bash
curl -F "file=@./report.pdf" https://httpbin.org/post
```

## Notes & Pitfalls
- Without `-f`, HTTP 404 can still exit 0.  
- Quote URLs with `&` query strings.  
- Prefer `--netrc` or env vars over hardcoding secrets in process lists.  

## Related Commands
- `wget` — download-centric alternative  
- `httpie` / `xh` — friendlier HTTP CLIs if installed  
- `jq` — JSON post-processing  
- `openssl s_client` — deep TLS debug  

## Additional Resources
- `man curl`  
- [curl everything curl book](https://everything.curl.dev/)
