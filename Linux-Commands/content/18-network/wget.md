# wget

## Overview
The `wget` command is a network utility to retrieve files from the web using HTTP, HTTPS, and FTP protocols. It supports recursive download, file transfer resumption, and bandwidth limiting.

## Syntax
```bash
wget [options] [URL...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-O file` | Output to file |
| `-P prefix` | Directory prefix |
| `-c` | Continue download |
| `-r` | Recursive retrieval |
| `-l depth` | Maximum depth |
| `-np` | No parent |
| `-nd` | No directories |
| `-A list` | Accept list |
| `-R list` | Reject list |
| `-q` | Quiet mode |
| `-v` | Verbose mode |
| `--limit-rate` | Bandwidth limit |

## Key Use Cases
1. File download
2. Website mirroring
3. Recursive download
4. FTP retrieval
5. Automated downloads

## Examples with Explanations
### Example 1: Basic Download
```bash
wget https://example.com/file
```
Download single file

### Example 2: Continue Download
```bash
wget -c https://example.com/large-file
```
Resume interrupted download

### Example 3: Mirror Website
```bash
wget -m https://example.com
```
Mirror entire site

## Common Usage Patterns
1. Save as file:
   ```bash
   wget -O output.file URL
   ```
2. Recursive with depth:
   ```bash
   wget -r -l2 URL
   ```
3. Accept types:
   ```bash
   wget -A pdf,jpg URL
   ```

## Security Considerations
1. SSL verification
2. Authentication
3. Server load
4. Bandwidth usage
5. Robot rules

## Related Commands
- `curl` - Data transfer
- `http` - HTTP client
- `fetch` - File retrieval
- `aria2` - Download utility
- `axel` - Download accelerator

## Additional Resources
- [Wget Manual](https://www.gnu.org/software/wget/manual/wget.html)
- [Usage Guide](https://www.cyberciti.biz/tips/linux-wget-your-ultimate-command-line-downloader.html)
- [System Administration](https://www.tecmint.com/linux-wget-command-examples/)

## Best Practices
1. Use continue
2. Set timeouts
3. Limit bandwidth
4. Check robots.txt
5. Verify downloads

## Download Options
1. Single file
2. Multiple files
3. Recursive
4. Mirror
5. Timestamping

## Troubleshooting
1. SSL errors
2. DNS issues
3. Server errors
4. Permission denied
5. Space issues

## Output Formats
1. Progress bar
2. Dot progress
3. Quiet output
4. Debug info
5. Log file
