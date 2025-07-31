# xz

## Overview
The `xz` command compresses files using the LZMA2 compression algorithm. It provides the best compression ratios among common compression tools but requires more CPU time and memory.

## Syntax
```bash
xz [options] [file...]
unxz [options] [file...]
xzcat [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c` | Write to stdout |
| `-d` | Decompress |
| `-f` | Force overwrite |
| `-k` | Keep original files |
| `-l` | List compressed file info |
| `-t` | Test integrity |
| `-v` | Verbose output |
| `-q` | Quiet mode |
| `-0` to `-9` | Compression level |
| `-e` | Use extreme compression |
| `-T threads` | Use multiple threads |
| `-M limit` | Memory usage limit |

## Compression Levels
| Level | Description | Memory Usage |
|-------|-------------|--------------|
| `-0` | Fastest | ~3 MB |
| `-6` | Default | ~94 MB |
| `-9` | Best | ~674 MB |
| `-9e` | Extreme | ~674 MB |

## Key Use Cases
1. Maximum compression ratio
2. Long-term archival
3. Bandwidth-limited transfers
4. Software distribution
5. Backup optimization

## Examples with Explanations
### Example 1: Basic Compression
```bash
xz file.txt
```
Compresses file.txt to file.txt.xz and removes original

### Example 2: Keep Original
```bash
xz -k file.txt
```
Compresses file but keeps the original

### Example 3: Maximum Compression
```bash
xz -9e file.txt
```
Uses extreme compression for best ratio

### Example 4: Multi-threaded
```bash
xz -T 4 largefile.txt
```
Uses 4 threads for compression

## Understanding Compression
LZMA2 characteristics:
- Excellent compression ratios
- High memory usage
- CPU intensive
- Dictionary-based compression
- Good for repetitive data

## Common Usage Patterns
1. Compress to stdout:
   ```bash
   xz -c file.txt > file.txt.xz
   ```
2. List file information:
   ```bash
   xz -l file.txt.xz
   ```
3. Test compressed file:
   ```bash
   xz -t file.txt.xz
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `--check=type` | Integrity check type |
| `--memlimit=limit` | Memory usage limit |
| `--threads=num` | Number of threads |
| `--block-size=size` | Block size |
| `--extreme` | Extreme compression mode |

## Related Commands
| Command | Description |
|---------|-------------|
| `unxz` | Decompress xz files |
| `xzcat` | View compressed files |
| `xzgrep` | Search compressed files |
| `xzless` | Page through compressed files |
| `xzdiff` | Compare compressed files |

## Performance Analysis
- Slowest compression speed
- Best compression ratios
- High memory requirements
- Multi-threading support
- Good for archival purposes

## Memory Management
1. Set memory limit:
   ```bash
   xz -M 100MiB file.txt
   ```
2. Check memory usage:
   ```bash
   xz -l compressed.xz
   ```
3. Low-memory compression:
   ```bash
   xz -0 file.txt
   ```

## File Extensions
| Extension | Description |
|-----------|-------------|
| `.xz` | Standard xz |
| `.txz` | Tar + xz |
| `.tar.xz` | Tar + xz |

## Integration Examples
1. With tar:
   ```bash
   tar -cJf archive.tar.xz directory/
   ```
2. Database backup:
   ```bash
   pg_dump database | xz -9 > backup.sql.xz
   ```
3. Log archival:
   ```bash
   find /var/log -name "*.log" -mtime +30 -exec xz {} \;
   ```

## Multi-threading
1. Auto-detect cores:
   ```bash
   xz -T 0 file.txt
   ```
2. Specific thread count:
   ```bash
   xz -T 8 largefile.txt
   ```
3. Memory per thread:
   ```bash
   xz -T 4 -M 400MiB file.txt
   ```

## Scripting Applications
1. Batch compression:
   ```bash
   #!/bin/bash
   for file in *.txt; do
       xz -k -v "$file"
       echo "Compressed: $file"
   done
   ```
2. Optimal compression:
   ```bash
   compress_optimal() {
       local file="$1"
       local cores=$(nproc)
       xz -9e -T "$cores" -k "$file"
   }
   ```

## Integrity Checking
1. Built-in checks:
   ```bash
   xz --check=crc64 file.txt
   ```
2. Verify integrity:
   ```bash
   xz -t file.txt.xz && echo "File OK"
   ```
3. List check type:
   ```bash
   xz -l file.txt.xz | grep Check
   ```

## Best Practices
1. Use for long-term storage
2. Consider memory requirements
3. Use multi-threading for large files
4. Test compressed files
5. Monitor system resources during compression

## Comparison with Other Tools
| Tool | Ratio | Speed | Memory | CPU |
|------|-------|-------|--------|-----|
| gzip | 3:1 | Fast | Low | Low |
| bzip2 | 4:1 | Medium | Medium | Medium |
| xz | 5:1 | Slow | High | High |

## Troubleshooting
1. Out of memory errors
2. Slow compression speed
3. Corrupted files
4. Thread synchronization issues
5. Disk space problems

## Security Considerations
1. Verify file integrity
2. Check available resources
3. Monitor compression processes
4. Validate file sources
5. Test decompression before deleting originals

## Advanced Configuration
1. Custom presets:
   ```bash
   xz --preset=6e file.txt
   ```
2. Block size optimization:
   ```bash
   xz --block-size=1MiB file.txt
   ```
3. Dictionary size:
   ```bash
   xz --lzma2=dict=16MiB file.txt
   ```