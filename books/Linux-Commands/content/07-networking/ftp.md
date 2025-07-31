# ftp

## Overview
The `ftp` command is a file transfer protocol client used to transfer files between local and remote systems. While largely superseded by more secure alternatives, it's still used for legacy systems and public file servers.

## Syntax
```bash
ftp [options] [host]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-4` | Use IPv4 only |
| `-6` | Use IPv6 only |
| `-A` | Force active mode |
| `-a` | Use anonymous login |
| `-d` | Enable debugging |
| `-e` | Disable command editing |
| `-g` | Disable filename globbing |
| `-i` | Turn off interactive prompting |
| `-n` | No auto-login |
| `-p` | Use passive mode |
| `-v` | Verbose output |

## Key Use Cases
1. File transfer to/from FTP servers
2. Legacy system integration
3. Public file downloads
4. Automated file transfers
5. System administration

## Examples with Explanations
### Example 1: Connect to FTP Server
```bash
ftp ftp.example.com
```
Connects to FTP server and prompts for credentials

### Example 2: Anonymous FTP
```bash
ftp -a ftp.example.com
```
Connects using anonymous login

### Example 3: Non-interactive Mode
```bash
ftp -n ftp.example.com
```
Connects without automatic login

## FTP Commands
| Command | Description |
|---------|-------------|
| `ls` | List remote files |
| `cd` | Change remote directory |
| `lcd` | Change local directory |
| `pwd` | Show remote directory |
| `lpwd` | Show local directory |
| `get` | Download file |
| `put` | Upload file |
| `mget` | Download multiple files |
| `mput` | Upload multiple files |
| `binary` | Set binary transfer mode |
| `ascii` | Set ASCII transfer mode |
| `passive` | Toggle passive mode |
| `quit` | Exit FTP |

## File Transfer Examples
### Download Files
```bash
ftp> get filename.txt
ftp> mget *.txt
ftp> get remote.txt local.txt
```

### Upload Files
```bash
ftp> put filename.txt
ftp> mput *.txt
ftp> put local.txt remote.txt
```

## Transfer Modes
| Mode | Description |
|------|-------------|
| ASCII | Text files (default) |
| Binary | Binary files |
| Auto | Automatic detection |

Set transfer mode:
```bash
ftp> binary
ftp> ascii
```

## Common Usage Patterns
1. Batch download:
   ```bash
   ftp> mget *.log
   ```
2. Directory synchronization:
   ```bash
   ftp> lcd /local/path
   ftp> cd /remote/path
   ftp> mget *
   ```
3. Automated transfer:
   ```bash
   ftp> prompt off
   ftp> mput *.txt
   ```

## Passive vs Active Mode
- **Active Mode**: Server connects back to client
- **Passive Mode**: Client connects to server for data

Enable passive mode:
```bash
ftp> passive
```

## Scripting FTP Operations
1. Using here document:
   ```bash
   ftp -n ftp.example.com << EOF
   user username password
   binary
   cd /remote/path
   lcd /local/path
   mget *.txt
   quit
   EOF
   ```
2. Using command file:
   ```bash
   echo "user username password
   binary
   get file.txt
   quit" > ftp_commands.txt
   ftp -n ftp.example.com < ftp_commands.txt
   ```

## Security Considerations
1. Unencrypted protocol
2. Credentials sent in plain text
3. Data transmitted unencrypted
4. Use SFTP/SCP for secure transfers
5. Firewall configuration needed

## Related Commands
- `sftp` - Secure FTP
- `scp` - Secure copy
- `rsync` - Synchronization tool
- `wget` - Web downloader
- `curl` - Data transfer tool

## Best Practices
1. Use secure alternatives when possible
2. Use passive mode for firewalls
3. Set appropriate transfer modes
4. Verify file transfers
5. Use automation for repetitive tasks

## Automated FTP Scripts
1. Backup script:
   ```bash
   #!/bin/bash
   HOST="backup.server.com"
   USER="backup_user"
   PASS="backup_pass"

   ftp -n $HOST << EOF
   user $USER $PASS
   binary
   cd /backups
   lcd /local/backups
   mput *.tar.gz
   quit
   EOF
   ```
2. Download script:
   ```bash
   #!/bin/bash
   ftp -n ftp.example.com << EOF
   user anonymous anonymous@domain.com
   binary
   cd /pub/files
   mget *.zip
   quit
   EOF
   ```

## Error Handling
1. Connection errors:
   ```bash
   ftp -v ftp.server.com 2>&1 | grep -i error
   ```
2. Transfer verification:
   ```bash
   ftp> hash  # Show progress
   ftp> status  # Show connection status
   ```

## Performance Optimization
1. Use binary mode for non-text files
2. Enable hash marks for progress
3. Use passive mode for better connectivity
4. Consider parallel transfers for multiple files

## Troubleshooting
1. Connection refused
2. Login failures
3. Transfer mode issues
4. Firewall problems
5. Permission errors

## Modern Alternatives
Instead of FTP, consider:
1. `sftp` - Secure FTP over SSH
2. `scp` - Secure copy over SSH
3. `rsync` - Efficient file synchronization
4. `curl` - Modern data transfer
5. `wget` - Web-based downloads

## Integration Examples
1. Log rotation upload:
   ```bash
   # Upload rotated logs
   find /var/log -name "*.gz" -mtime -1 | while read file; do
       echo "put $file" | ftp -n backup.server.com
   done
   ```
2. Configuration deployment:
   ```bash
   ftp -n config.server.com << EOF
   user deploy deploy_pass
   ascii
   cd /configs
   mput *.conf
   quit
   EOF
   ```