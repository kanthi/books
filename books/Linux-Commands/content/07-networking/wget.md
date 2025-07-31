# wget

## Overview
The `wget` command is a non-interactive network downloader that retrieves files from web servers using HTTP, HTTPS, and FTP protocols. It's designed for robust downloading with retry capabilities.

## Syntax
```bash
wget [options] [URL...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-O file` | Output to file |
| `-c` | Continue partial download |
| `-r` | Recursive download |
| `-np` | No parent directories |
| `-k` | Convert links for local viewing |
| `-p` | Download page requisites |
| `-m` | Mirror website |
| `-q` | Quiet mode |
| `-v` | Verbose output |
| `-t n` | Retry n times |
| `-T n` | Timeout in seconds |
| `--limit-rate=rate` | Limit download speed |

## Download Types
| Type | Description |
|------|-------------|
| Single file | Download one file |
| Recursive | Download directory structure |
| Mirror | Complete website copy |
| Resume | Continue interrupted download |
| Batch | Multiple URLs from file |

## Key Use Cases
1. Download files from web
2. Mirror websites
3. Automated downloads
4. Backup web content
5. Batch file retrieval

## Examples with Explanations
### Example 1: Basic Download
```bash
wget https://example.com/file.zip
```
Downloads file to current directory

### Example 2: Save with Different Name
```bash
wget -O myfile.zip https://example.com/file.zip
```
Downloads and saves with specified name

### Example 3: Resume Download
```bash
wget -c https://example.com/largefile.iso
```
Continues interrupted download

## Recursive Downloads
1. Download website:
   ```bash
   wget -r -np -k https://example.com/
   ```
2. Mirror with limits:
   ```bash
   wget -m -l 2 https://example.com/
   ```
3. Download directory:
   ```bash
   wget -r -np https://example.com/files/
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `--user-agent=agent` | Set user agent |
| `--referer=url` | Set referer |
| `--header=header` | Add HTTP header |
| `--post-data=data` | POST request |
| `--cookies=on/off` | Handle cookies |
| `--no-check-certificate` | Skip SSL verification |
| `--spider` | Check if file exists |

## Common Usage Patterns
1. Download with rate limit:
   ```bash
   wget --limit-rate=200k https://example.com/file.zip
   ```
2. Background download:
   ```bash
   wget -b https://example.com/largefile.iso
   ```
3. Download from file list:
   ```bash
   wget -i urls.txt
   ```

## Authentication
1. Basic auth:
   ```bash
   wget --user=username --password=password URL
   ```
2. Certificate auth:
   ```bash
   wget --certificate=cert.pem --private-key=key.pem URL
   ```
3. Cookie authentication:
   ```bash
   wget --load-cookies=cookies.txt URL
   ```

## Performance Analysis
- Efficient for large files
- Good retry mechanisms
- Bandwidth limiting available
- Parallel downloads possible
- Resume capability reduces waste

## Related Commands
- `curl` - More versatile HTTP client
- `aria2` - Multi-connection downloader
- `axel` - Light download accelerator
- `lftp` - Sophisticated FTP client
- `rsync` - File synchronization

## Additional Resources
- [GNU Wget Manual](https://www.gnu.org/software/wget/manual/wget.html)
- [Wget Examples](https://www.tecmint.com/wget-command-examples/)

## Best Practices
1. Use appropriate retry settings
2. Respect robots.txt
3. Limit download rate for courtesy
4. Use resume for large files
5. Verify downloaded files

## Website Mirroring
1. Complete mirror:
   ```bash
   wget -m -p -E -k -K -np https://example.com/
   ```
2. Limited depth:
   ```bash
   wget -r -l 3 -k -p https://example.com/
   ```
3. Specific file types:
   ```bash
   wget -r -A "*.pdf,*.doc" https://example.com/
   ```

## Security Considerations
1. Verify SSL certificates
2. Be cautious with --no-check-certificate
3. Validate downloaded content
4. Use secure protocols when possible
5. Check file integrity

## Troubleshooting
1. SSL certificate errors
2. Connection timeouts
3. Server blocking requests
4. Disk space issues
5. Permission problems

## Integration Examples
1. With cron for scheduled downloads:
   ```bash
   0 2 * * * wget -q -O /backup/file.zip https://example.com/file.zip
   ```
2. With find for cleanup:
   ```bash
   wget https://example.com/file.zip && find . -name "*.tmp" -delete
   ```
3. Batch processing:
   ```bash
   for url in $(cat urls.txt); do wget "$url"; done
   ```