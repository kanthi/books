# gzip

## Overview
The `gzip` command compresses or expands files using Lempel-Ziv coding (LZ77). It replaces the original file with a compressed version by default.

## Syntax
```bash
gzip [options] [files...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Decompress |
| `-c` | Write to stdout |
| `-f` | Force operation |
| `-k` | Keep input files |
| `-l` | List information |
| `-n` | No name/time |
| `-N` | Save name/time |
| `-q` | Quiet mode |
| `-r` | Recursive |
| `-t` | Test integrity |
| `-v` | Verbose mode |
| `-#` | Compression level (1-9) |

## File Extensions
| Extension | Description |
|-----------|-------------|
| `.gz` | Gzipped file |
| `.tgz` | Gzipped tar archive |
| `.Z` | Compressed file |

## Key Use Cases
1. File compression
2. Space saving
3. Data transfer
4. Archive creation
5. Log compression

## Examples with Explanations
### Example 1: Compress File
```bash
gzip file.txt
```
Creates file.txt.gz

### Example 2: Decompress File
```bash
gzip -d file.txt.gz
```
Restores original file

### Example 3: View Contents
```bash
gzip -l file.txt.gz
```
Show compression info

## Common Usage Patterns
1. Maximum compression:
   ```bash
   gzip -9 file
   ```
2. Keep original:
   ```bash
   gzip -k file
   ```
3. Recursive compress:
   ```bash
   gzip -r directory/
   ```

## Security Considerations
1. File permissions
2. Original deletion
3. Data integrity
4. Resource usage
5. Symbolic links

## Related Commands
- `gunzip` - Decompress
- `zcat` - View compressed
- `tar` - Archive files
- `bzip2` - Alternative compression
- `xz` - Alternative compression

## Additional Resources
- [Gzip Manual](https://man7.org/linux/man-pages/man1/gzip.1.html)
- [Compression Guide](https://www.cyberciti.biz/faq/linux-gzip-command-examples/)
- [System Administration](https://www.tecmint.com/linux-compress-decompress-gzip-files/)

## Best Practices
1. Test integrity
2. Keep originals
3. Choose level
4. Document changes
5. Regular testing

## Compression Levels
1. Level 1 (fastest)
2. Level 6 (default)
3. Level 9 (best)
4. Memory usage
5. CPU usage

## Troubleshooting
1. Space issues
2. Permission errors
3. Corruption
4. Performance
5. Memory limits
