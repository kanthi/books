# scp

## Overview
The `scp` (secure copy) command securely transfers files between hosts over SSH. It provides encrypted file transfer with authentication and maintains file permissions and timestamps.

## Syntax
```bash
scp [options] source destination
scp [options] source... destination
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r` | Recursive copy (directories) |
| `-p` | Preserve timestamps and permissions |
| `-v` | Verbose output |
| `-q` | Quiet mode |
| `-C` | Enable compression |
| `-P port` | Specify SSH port |
| `-i keyfile` | Use specific SSH key |
| `-o option` | SSH options |
| `-l limit` | Bandwidth limit (Kbit/s) |
| `-S program` | SSH program to use |

## File Transfer Patterns
| Pattern | Description |
|---------|-------------|
| `file user@host:path` | Local to remote |
| `user@host:file path` | Remote to local |
| `user@host1:file user@host2:path` | Remote to remote |
| `*.txt user@host:dir/` | Multiple files |

## Key Use Cases
1. Secure file transfer
2. Remote backup
3. Configuration deployment
4. Log file collection
5. Development file sync

## Examples with Explanations
### Example 1: Copy File to Remote
```bash
scp file.txt user@server:/home/user/
```
Copies local file to remote server

### Example 2: Copy from Remote
```bash
scp user@server:/var/log/app.log ./
```
Downloads remote file to current directory

### Example 3: Recursive Directory Copy
```bash
scp -r project/ user@server:/opt/
```
Copies entire directory structure

## Authentication Methods
1. Password authentication:
   ```bash
   scp file.txt user@server:/path/
   ```
2. SSH key authentication:
   ```bash
   scp -i ~/.ssh/id_rsa file.txt user@server:/path/
   ```
3. SSH agent:
   ```bash
   ssh-add ~/.ssh/id_rsa
   scp file.txt user@server:/path/
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `-4` | Force IPv4 |
| `-6` | Force IPv6 |
| `-B` | Batch mode (no passwords/passphrases) |
| `-F configfile` | SSH config file |
| `-T` | Disable strict filename checking |
| `-3` | Copy between remote hosts via local |

## Common Usage Patterns
1. Preserve attributes:
   ```bash
   scp -p file.txt user@server:/backup/
   ```
2. Compressed transfer:
   ```bash
   scp -C largefile.tar user@server:/tmp/
   ```
3. Custom SSH port:
   ```bash
   scp -P 2222 file.txt user@server:/path/
   ```

## Performance Optimization
1. Enable compression for slow connections:
   ```bash
   scp -C file.txt user@server:/path/
   ```
2. Limit bandwidth:
   ```bash
   scp -l 1000 file.txt user@server:/path/
   ```
3. Use cipher optimization:
   ```bash
   scp -o Cipher=aes128-ctr file.txt user@server:/path/
   ```

## Batch Operations
1. Multiple files:
   ```bash
   scp file1.txt file2.txt user@server:/backup/
   ```
2. Wildcard patterns:
   ```bash
   scp *.log user@server:/logs/
   ```
3. From file list:
   ```bash
   cat filelist.txt | xargs -I {} scp {} user@server:/dest/
   ```

## Security Considerations
1. Use SSH keys instead of passwords
2. Verify host keys
3. Use specific SSH configurations
4. Limit user permissions on target
5. Monitor transfer logs

## Related Commands
- `rsync` - More efficient sync tool
- `sftp` - Interactive secure FTP
- `ssh` - Secure shell
- `wget` - Download files
- `curl` - Transfer data

## Additional Resources
- [SCP Manual](https://man.openbsd.org/scp)
- [SSH File Transfer Guide](https://www.tecmint.com/scp-command-examples/)

## Best Practices
1. Use SSH keys for automation
2. Test with small files first
3. Verify transfers with checksums
4. Use compression for large files
5. Monitor network usage

## SSH Configuration
Create `~/.ssh/config` for easier usage:
```
Host myserver
    HostName server.example.com
    User myuser
    Port 2222
    IdentityFile ~/.ssh/mykey
```

Then use:
```bash
scp file.txt myserver:/path/
```

## Error Handling
1. Connection refused:
   ```bash
   scp -v file.txt user@server:/path/  # Debug mode
   ```
2. Permission denied:
   ```bash
   scp -o PreferredAuthentications=publickey file.txt user@server:/path/
   ```
3. Host key verification:
   ```bash
   scp -o StrictHostKeyChecking=no file.txt user@server:/path/
   ```

## Scripting Examples
1. Automated backup:
   ```bash
   #!/bin/bash
   DATE=$(date +%Y%m%d)
   scp -r /important/data/ backup@server:/backups/$DATE/
   ```
2. Log collection:
   ```bash
   for host in server1 server2 server3; do
       scp $host:/var/log/app.log logs/$host-app.log
   done
   ```
3. Deployment script:
   ```bash
   scp -r dist/ production@server:/var/www/html/
   ```

## Progress Monitoring
1. Verbose output:
   ```bash
   scp -v file.txt user@server:/path/
   ```
2. With progress (using pv):
   ```bash
   pv file.txt | ssh user@server 'cat > /path/file.txt'
   ```
3. Using rsync for progress:
   ```bash
   rsync --progress -e ssh file.txt user@server:/path/
   ```

## Troubleshooting
1. Connection timeouts
2. Authentication failures
3. Permission issues
4. Network interruptions
5. Disk space problems

## Integration Examples
1. With find:
   ```bash
   find . -name "*.conf" -exec scp {} user@server:/configs/ \;
   ```
2. With tar:
   ```bash
   tar czf - directory/ | ssh user@server 'tar xzf - -C /destination/'
   ```
3. Backup script:
   ```bash
   scp -r /home/user/ backup@server:/backups/$(date +%Y%m%d)/
   ```