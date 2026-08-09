# wget

## Overview
`wget` is a non-interactive downloader for HTTP(S), FTP, and related protocols. It shines at recursive site fetches, resume, rate limiting, and simple “get this URL into a file” scripts. For complex APIs and arbitrary methods, `curl` is usually better; for bulk downloads and mirroring, `wget` is often clearer.

## Syntax
```bash
wget [OPTIONS] [URL...]
wget [OPTIONS] -i url-list.txt
```

## Common Options
| Option | Description |
|--------|-------------|
| `-O file` | Write to this filename (`-` = stdout) |
| `-o logfile` | Write messages to log file |
| `-c` | Continue / resume partial download |
| `-q` | Quiet |
| `-v` / `-nv` | Verbose / non-verbose |
| `-b` | Go to background after start |
| `-P dir` | Directory prefix for saved files |
| `-N` | Timestamping (re-get only if newer) |
| `--limit-rate=RATE` | Throttle (e.g. `500k`) |
| `--timeout=SECS` | Network timeout |
| `--tries=N` | Retry count (`0` = infinite) |
| `--retry-connrefused` | Retry even on connection refused |
| `-U agent` | User-Agent string |
| `--header='K: V'` | Extra HTTP header |
| `--user=` / `--password=` | Auth (prefer netrc; see Safety) |
| `-r` | Recursive download |
| `-l N` | Recursion depth |
| `-np` | No parent (stay under URL path) |
| `-k` | Convert links for local viewing |
| `-p` | Page requisites (CSS/images for HTML) |
| `-m` | Mirror shorthand (`-r -N -l inf --no-remove-listing`) |
| `-A` / `-R` | Accept / reject filename patterns |
| `--spider` | Check existence without downloading |
| `--no-check-certificate` | Skip TLS verify (**avoid**) |

## Safety
- Do not put passwords on the command line (`ps` can see them). Prefer `~/.wgetrc` permissions `600` or `.netrc` with tight modes, or prompt-based tools.
- Recursive `-r` can pull far more than intended (entire sites). Use `-np`, `-l`, and `-A`/`-R` limits.
- `--no-check-certificate` disables TLS verification — only for lab debugging of broken certs, never production automation.
- Respect site `robots.txt` and terms; `-e robots=off` exists but is often rude or disallowed.

## Examples with Explanations
### Simple download (keeps remote name)
```bash
wget https://example.com/files/app-1.2.3.tgz
```

### Save under a specific name
```bash
wget -O app.tgz https://example.com/files/app-latest.tgz
```

### Resume interrupted download
```bash
wget -c https://example.com/big.iso
```

### Quiet download into a directory
```bash
mkdir -p ~/downloads
wget -q -P ~/downloads https://example.com/tool.deb
```

### Rate-limited fetch with retries
```bash
wget --limit-rate=1m --tries=5 --timeout=30 \
  https://example.com/dataset.tar.gz
```

### Multiple URLs from a file
```bash
wget -i urls.txt -P ./artifacts/
```
One URL per line in `urls.txt`.

### Spider: check if URL is reachable
```bash
wget --spider -q https://example.com/health && echo up || echo down
```

### Authenticated download (prefer netrc)
```bash
# ~/.netrc (chmod 600):
# machine example.com login USER password SECRET
wget https://example.com/private/build.zip
```

### Custom header (e.g. token) without logging token in shell history carefully
```bash
wget --header="Authorization: Bearer ${TOKEN}" \
  -O release.json https://api.example.com/v1/release
```
Still prefer env vars over pasting secrets into shell history.

### One-page offline copy (HTML + assets)
```bash
wget -p -k -P ./mirror https://example.com/docs/intro.html
```
`-p` gets page requisites; `-k` rewrites links for local browsing.

### Bounded recursive mirror of a docs tree
```bash
wget -r -np -nH -l 3 -P ./docs \
  https://example.com/manual/
```
- `-np` — do not ascend to parent  
- `-nH` — no host-prefixed directory  
- `-l 3` — depth limit  

### Timestamped re-sync of a single artifact
```bash
wget -N https://example.com/app.tgz
```
Skips download if local file is already up to date (server must send proper timestamps).

## Understanding Output
Default progress shows percent, bar, speed, and ETA. `-q` silences progress (errors still appear unless fully quieted). HTTP error codes produce non-zero exit status in modern wget — check `$?` in scripts. Partial files remain when interrupted unless you clean them; `-c` reuses them.

## Notes & Pitfalls
- `-O` with multiple URLs concatenates into one file — usually wrong; use `-P` or separate invocations.
- Recursive mode creates directory trees; know where `-P` points before filling the disk.
- Some CDNs need a browser-like User-Agent (`-U`) or extra headers; prefer fixing the URL/API over spoofing when you control the service.
- For REST APIs with POST/JSON, use `curl`; `wget` can POST (`--post-data`) but is less ergonomic.
- On Ubuntu, package is typically `wget` from `apt`; GNU wget 1.x is the common default (`wget --version`).

## Related Commands
- `curl` — flexible transfers and APIs
- `aria2c` — multi-connection downloads (if installed)
- `apt` / `apt-get` — packages, not arbitrary URLs
- `rsync` — sync trees you already host over SSH
- `sha256sum` — verify downloads after fetch

## Additional Resources
- `man wget`
- `/usr/share/doc/wget/` on Debian/Ubuntu packages
