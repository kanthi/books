# unzip

## Overview
The `unzip` command extracts files from ZIP archives. It supports listing, testing, and extracting compressed files created by PKZIP or similar programs.

## Syntax
```bash
unzip [options] file[.zip] [files...] [-x files...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List contents |
| `-t` | Test integrity |
| `-v` | Verbose listing |
| `-q` | Quiet mode |
| `-n` | Never overwrite |
| `-o` | Always overwrite |
| `-d dir` | Extract to dir |
| `-j` | Junk paths |
| `-P pass` | Use password |
| `-x files` | Exclude files |
| `-Z` | ZipInfo mode |
| `-C` | Match case |

## Key Use Cases
1. Archive extraction
2. Content viewing
3. Archive testing
4. Selective extraction
5. Cross-platform usage

## Examples with Explanations
### Example 1: Extract Archive
```bash
unzip archive.zip
```
Extract all files

### Example 2: List Contents
```bash
unzip -l archive.zip
```
Show archive contents

### Example 3: Extract to Directory
```bash
unzip archive.zip -d /target/
```
Extract to specific location

## Common Usage Patterns
1. Test archive:
   ```bash
   unzip -t archive.zip
   ```
2. View contents:
   ```bash
   unzip -v archive.zip
   ```
3. Extract single file:
   ```bash
   unzip archive.zip file.txt
   ```

## Security Considerations
1. Password protection
2. File permissions
3. Path traversal
4. Symbolic links
5. Overwrite risks

## Related Commands
- `zip` - Create archives
- `zipinfo` - Detailed info
- `tar` - Archive files
- `gunzip` - Decompress
- `7z` - Alternative archiver

## Additional Resources
- [Unzip Manual](https://linux.die.net/man/1/unzip)
- [Archive Guide](https://www.cyberciti.biz/faq/linux-unzip-command-examples/)
- [System Administration](https://www.tecmint.com/unzip-command-examples/)

## Best Practices
1. Test before extract
2. Check space
3. Use target dir
4. Verify contents
5. Handle overwrites

## Output Modes
1. Normal
2. Verbose
3. Quiet
4. List only
5. Test only

## Troubleshooting
1. Password issues
2. Corruption
3. Space problems
4. Permission errors
5. Character encoding
