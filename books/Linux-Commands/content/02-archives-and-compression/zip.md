# zip

## Overview
The `zip` command creates compressed archive files in ZIP format. It's widely compatible across different operating systems and supports various compression methods.

## Syntax
```bash
zip [options] archive.zip file1 file2...
unzip [options] archive.zip
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r` | Recursive (include subdirectories) |
| `-u` | Update existing archive |
| `-f` | Freshen existing entries |
| `-d` | Delete entries from archive |
| `-m` | Move files to archive |
| `-j` | Junk directory paths |
| `-e` | Encrypt archive |
| `-x pattern` | Exclude files |
| `-i pattern` | Include only files |
| `-v` | Verbose output |
| `-q` | Quiet mode |

## Compression Levels
| Level | Description |
|-------|-------------|
| `-0` | No compression (store only) |
| `-1` | Fastest compression |
| `-6` | Default compression |
| `-9` | Best compression |

## Key Use Cases
1. Create portable archives
2. Compress multiple files
3. Cross-platform file sharing
4. Backup directories
5. Distribute software packages

## Examples with Explanations
### Example 1: Create Basic Archive
```bash
zip archive.zip file1.txt file2.txt
```
Creates archive containing specified files

### Example 2: Recursive Directory Archive
```bash
zip -r backup.zip /home/user/documents/
```
Archives entire directory structure

### Example 3: Extract Archive
```bash
unzip archive.zip
```
Extracts all files from archive

## Archive Management
1. Add files to existing archive:
   ```bash
   zip -u archive.zip newfile.txt
   ```
2. Delete files from archive:
   ```bash
   zip -d archive.zip oldfile.txt
   ```
3. List archive contents:
   ```bash
   unzip -l archive.zip
   ```

## Advanced Operations
1. Password protection:
   ```bash
   zip -e secure.zip sensitive.txt
   ```
2. Exclude patterns:
   ```bash
   zip -r archive.zip directory/ -x "*.tmp"
   ```
3. Update only newer files:
   ```bash
   zip -u archive.zip *.txt
   ```

## Unzip Options
| Option | Description |
|--------|-------------|
| `-l` | List contents |
| `-t` | Test archive |
| `-d dir` | Extract to directory |
| `-j` | Junk paths |
| `-o` | Overwrite without prompting |
| `-n` | Never overwrite |
| `-q` | Quiet mode |
| `-v` | Verbose listing |

## Common Usage Patterns
1. Backup with date:
   ```bash
   zip backup-$(date +%Y%m%d).zip *.txt
   ```
2. Exclude hidden files:
   ```bash
   zip -r archive.zip directory/ -x "*/.*"
   ```
3. Extract to specific directory:
   ```bash
   unzip archive.zip -d /target/directory/
   ```

## Performance Analysis
- Good compression ratios
- Moderate CPU usage
- Memory efficient
- Fast extraction
- Good for mixed file types

## File Compatibility
- Cross-platform support
- Windows native support
- macOS built-in support
- Linux standard tool
- Mobile device support

## Related Commands
- `tar` - Unix archiving
- `gzip` - GNU compression
- `7z` - 7-Zip format
- `rar` - RAR archives
- `bzip2` - Alternative compression

## Additional Resources
- [Zip Manual](http://infozip.sourceforge.net/mans.html)
- [Archive Examples](https://www.tecmint.com/zip-unzip-command-examples/)

## Best Practices
1. Use descriptive archive names
2. Test archives after creation
3. Consider compression vs speed trade-offs
4. Use encryption for sensitive data
5. Verify extraction success

## Security Considerations
1. Password protect sensitive archives
2. Verify archive integrity
3. Be cautious with zip bombs
4. Check extraction paths
5. Validate archive sources

## Integration Examples
1. With find:
   ```bash
   find . -name "*.log" | zip logs.zip -@
   ```
2. Automated backup:
   ```bash
   zip -r backup-$(date +%Y%m%d).zip /important/data/
   ```
3. Selective archiving:
   ```bash
   zip -r project.zip . -x "node_modules/*" "*.git/*"
   ```

## Troubleshooting
1. Archive corruption issues
2. Path length limitations
3. Permission problems
4. Disk space errors
5. Character encoding issues

## Archive Testing
1. Test integrity:
   ```bash
   unzip -t archive.zip
   ```
2. Verbose test:
   ```bash
   zip -T archive.zip
   ```
3. Check specific files:
   ```bash
   unzip -t archive.zip file.txt
   ```