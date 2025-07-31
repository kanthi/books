# bzip2

## Overview
The `bzip2` command compresses files using the Burrows-Wheeler block sorting text compression algorithm. It typically achieves better compression ratios than gzip but uses more CPU time.

## Syntax
```bash
bzip2 [options] [file...]
bunzip2 [options] [file...]
bzcat [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Write to stdout |
| `-d` | Decompress |
| `-f` | Force overwrite |
| `-k` | Keep original files |
| `-q` | Quiet mode |
| `-v` | Verbose output |
| `-t` | Test integrity |
| `-1` to `-9` | Compression level |
| `-s` | Small memory usage |
| `--fast` | Same as -1 |
| `--best` | Same as -9 |

## Compression Levels
| Level | Description |
|-------|-------------|
| `-1` | Fastest compression |
| `-6` | Default compression |
| `-9` | Best compression |
| `--fast` | Fastest (same as -1) |
| `--best` | Best (same as -9) |

## Key Use Cases
1. High-ratio file compression
2. Archive preparation
3. Backup compression
4. Bandwidth-limited transfers
5. Long-term storage

## Examples with Explanations
### Example 1: Basic Compression
```bash
bzip2 file.txt
```
Compresses file.txt to file.txt.bz2 and removes original

### Example 2: Keep Original
```bash
bzip2 -k file.txt
```
Compresses file but keeps the original

### Example 3: Decompress
```bash
bunzip2 file.txt.bz2
```
Decompresses file back to original

### Example 4: Best Compression
```bash
bzip2 -9 largefile.txt
```
Uses maximum compression level

## Understanding Compression
Compression characteristics:
- Better ratios than gzip
- Slower than gzip
- Good for text files
- Block-based compression
- Memory usage varies by level

## Common Usage Patterns
1. Compress to stdout:
   ```bash
   bzip2 -c file.txt > file.txt.bz2
   ```
2. Test compressed file:
   ```bash
   bzip2 -t file.txt.bz2
   ```
3. Verbose compression:
   ```bash
   bzip2 -v file.txt
   ```

## Related Commands
| Command | Description |
|---------|-------------|
| `bunzip2` | Decompress bzip2 files |
| `bzcat` | View compressed files |
| `bzgrep` | Search compressed files |
| `bzless` | Page through compressed files |
| `bzdiff` | Compare compressed files |

## Advanced Usage
1. Small memory mode:
   ```bash
   bzip2 -s file.txt
   ```
2. Force compression:
   ```bash
   bzip2 -f existing.txt.bz2
   ```
3. Quiet operation:
   ```bash
   bzip2 -q *.txt
   ```

## Performance Analysis
- CPU intensive compression
- Excellent compression ratios
- Memory usage: 400k + (8 × block size)
- Good for archival storage
- Consider time vs space trade-offs

## File Extensions
| Extension | Description |
|-----------|-------------|
| `.bz2` | Standard bzip2 |
| `.tbz` | Tar + bzip2 |
| `.tbz2` | Tar + bzip2 |
| `.tar.bz2` | Tar + bzip2 |

## Related Commands
- `gzip` - Faster compression
- `xz` - Better compression
- `tar` - Archive files
- `zip` - Cross-platform archives
- `7z` - 7-Zip format

## Best Practices
1. Use for long-term storage
2. Consider CPU vs compression trade-offs
3. Test compressed files
4. Keep originals for critical data
5. Use appropriate compression levels

## Integration Examples
1. With tar:
   ```bash
   tar -cjf archive.tar.bz2 directory/
   ```
2. Backup compression:
   ```bash
   mysqldump database | bzip2 > backup.sql.bz2
   ```
3. Log compression:
   ```bash
   find /var/log -name "*.log" -mtime +7 -exec bzip2 {} \;
   ```

## Scripting Applications
1. Automated compression:
   ```bash
   #!/bin/bash
   for file in *.txt; do
       bzip2 -k "$file"
       echo "Compressed: $file"
   done
   ```
2. Space-saving backup:
   ```bash
   backup_compress() {
       local source="$1"
       local dest="$2"
       tar -c "$source" | bzip2 -9 > "$dest.tar.bz2"
   }
   ```

## Memory Usage
Block sizes and memory usage:
- Block size 100k: ~1.2MB memory
- Block size 200k: ~2.4MB memory
- Block size 900k: ~10.8MB memory
- Use `-s` for reduced memory usage

## Troubleshooting
1. Out of memory errors
2. Corrupted compressed files
3. Slow compression speed
4. Disk space issues
5. Permission problems

## Comparison with Other Tools
| Tool | Speed | Ratio | CPU Usage |
|------|-------|-------|-----------|
| gzip | Fast | Good | Low |
| bzip2 | Medium | Better | Medium |
| xz | Slow | Best | High |

## Security Considerations
1. Verify file integrity after compression
2. Test decompression before deleting originals
3. Check available disk space
4. Monitor compression processes
5. Validate compressed file sources