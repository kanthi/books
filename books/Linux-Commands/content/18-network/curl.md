# curl

## Overview
The `curl` command is a tool for transferring data using various protocols. It supports HTTP, HTTPS, FTP, FTPS, SCP, SFTP, TFTP, DICT, TELNET, LDAP, and FILE.

## Syntax
```bash
curl [options] [URL...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-o file` | Output to file |
| `-O` | Remote filename |
| `-L` | Follow redirects |
| `-i` | Include headers |
| `-I` | Headers only |
| `-v` | Verbose |
| `-s` | Silent mode |
| `-u user:pass` | Authentication |
| `-X method` | Request method |
| `-H header` | Add header |
| `-d data` | POST data |
| `-F field=value` | Form data |

## HTTP Methods
| Method | Description |
|--------|-------------|
| GET | Retrieve data |
| POST | Submit data |
| PUT | Update data |
| DELETE | Remove data |
| HEAD | Headers only |
| OPTIONS | Show options |
| PATCH | Partial update |

## Key Use Cases
1. API testing
2. File download
3. Web scraping
4. Data transfer
5. Site testing

## Examples with Explanations
### Example 1: Basic GET
```bash
curl https://example.com
```
Get webpage content

### Example 2: Save Output
```bash
curl -o file.html https://example.com
```
Save to file

### Example 3: POST Data
```bash
curl -X POST -d "data" https://api.example.com
```
Send POST request

## Common Usage Patterns
1. Download file:
   ```bash
   curl -O https://example.com/file
   ```
2. With auth:
   ```bash
   curl -u user:pass https://api.example.com
   ```
3. JSON POST:
   ```bash
   curl -H "Content-Type: application/json" -d '{"key":"value"}' URL
   ```

## Security Considerations
1. SSL verification
2. Credentials handling
3. Data exposure
4. Cookie security
5. Redirect safety

## Related Commands
- `wget` - File download
- `http` - HTTP client
- `fetch` - File retrieval
- `nc` - Netcat
- `telnet` - Remote access

## Additional Resources
- [Curl Manual](https://curl.se/docs/manual.html)
- [Usage Guide](https://curl.se/docs/httpscripting.html)
- [System Administration](https://www.tecmint.com/linux-curl-command-examples/)

## Best Practices
1. Use SSL
2. Handle errors
3. Set timeouts
4. Verify URLs
5. Check responses

## Output Options
1. Headers
2. Body
3. Progress
4. Errors
5. Timing

## Troubleshooting
1. SSL errors
2. DNS issues
3. Timeout
4. Authentication
5. Protocol errors

## Protocol Support
1. HTTP/HTTPS
2. FTP/FTPS
3. SCP/SFTP
4. LDAP
5. SMTP/POP3
