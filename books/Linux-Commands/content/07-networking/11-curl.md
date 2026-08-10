# curl

## Overview

`curl` transfers data to/from URLs. It supports HTTP(S), FTP, SFTP, and many other protocols — the default tool for APIs, downloads, health checks, and quick TLS debugging. Prefer `curl` in scripts for predictable flags; use `wget` when you want recursive site mirrors.

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
| `-f` | Fail on HTTP ≥400 (exit non-zero) |
| `-sS` | Silent progress, but show errors |
| `-v` / `-vv` | Verbose (headers, TLS) |
| `-I` | HEAD request only |
| `-X METHOD` | Custom method (`POST`, `PUT`, …) |
| `-H "K: V"` | Request header |
| `-d data` | Body (form-encoded by default) |
| `--json data` | JSON body + content-type (curl 7.82+) |
| `-u user:pass` | HTTP auth |
| `-A agent` | User-Agent |
| `-m secs` / `--max-time` | Overall time limit |
| `--connect-timeout secs` | Connect phase only |
| `-w fmt` | Write-out variables after transfer |
| `-k` | Insecure TLS (lab only) |
| `-C -` | Resume transfer |
| `-x proxy` | HTTP/SOCKS proxy |
| `-b` / `-c` | Cookie read / write jar |
| `--retry N` | Retry transient failures |

## Key Use Cases

1. Download artifacts and releases  
2. Call REST APIs  
3. Debug HTTP headers and TLS  
4. Scripted health checks and deploys  

## Safety

- Prefer env vars / netrc over secrets on the command line (`ps` can see argv).  
- `-k` disables certificate verification — never in production automation.  
- Recursive fetchers and huge mirrors belong to `wget`/`rclone` with bandwidth limits.

## Examples with Explanations

### Download

```bash
curl -fL -O https://example.com/file.tgz
curl -fL -o app.tgz https://example.com/file.tgz
```

`-f` fails on HTTP errors; `-L` follows redirects common on CDN links.

### API GET with pretty JSON

```bash
curl -sS https://api.github.com/repos/jqlang/jq | jq .
```

`-sS` keeps scripts clean while still reporting failures.

### POST JSON

```bash
curl -sS -X POST https://httpbin.org/post \
  -H 'Content-Type: application/json' \
  --data-binary '{"name":"ada","ok":true}' | jq .

# newer curl:
curl -sS --json '{"name":"ada"}' https://httpbin.org/post | jq .
```

### Headers only / method checks

```bash
curl -sSI https://example.com
curl -sS -o /dev/null -w '%{http_code}\n' https://example.com
```

### Follow redirects, treat 404 as failure

```bash
curl -fsSL -o out.html https://example.com/missing || echo "failed:$?"
```

`-f` makes 4xx/5xx non-zero — essential in CI.

### Timing metrics

```bash
curl -o /dev/null -sS -w \
  'dns:%{time_namelookup} connect:%{time_connect} tls:%{time_appconnect} ttfb:%{time_starttransfer} total:%{time_total} code:%{http_code}\n' \
  https://example.com
```

Useful for “is it DNS, TCP, TLS, or the app?”

### Auth

```bash
curl -sS -H "Authorization: Bearer $TOKEN" https://api.example.com/v1/me
curl -sS -u "$USER:$PASS" https://example.com/private/
curl -sS --netrc-file ~/.netrc https://example.com/private/
```

### Upload file (multipart)

```bash
curl -fL -F "file=@./report.pdf;type=application/pdf" https://httpbin.org/post
```

### Client certificate (mTLS)

```bash
curl -sS --cert client.pem --key client.key --cacert ca.pem https://svc.internal/health
```

### Proxy and retries

```bash
curl -fsSL --retry 3 --retry-delay 2 -x http://proxy:8080 -O https://example.com/file
```

### Show response headers + body separately

```bash
curl -sS -D headers.txt -o body.json https://api.example.com/v1/x
```

## Understanding Output

Default is the response body on stdout and a progress meter on stderr. HTTP status does **not** affect exit code unless `-f` (or you inspect `%{http_code}`). Write-out variables expand after the transfer completes.

## Notes & Pitfalls

- Quote URLs containing `&`, `?`, or shell globs.  
- HTTP/2 and HTTP/3 behavior depends on how curl was built.  
- Multiple URLs on one command line are sequential.  
- `curl | jq` fails closed if either side fails when `set -o pipefail` is on.

## Related Commands

- `wget` — download-centric alternative  
- `httpie` / `xh` — friendlier human HTTP CLIs  
- `jq` — JSON post-processing  
- `openssl s_client` — deep TLS debug  
- `ss` / `dig` — connectivity / DNS triage  

## Additional Resources

- `man curl`  
- [Everything curl](https://everything.curl.dev/)
