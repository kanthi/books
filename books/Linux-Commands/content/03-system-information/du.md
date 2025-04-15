# du

## Overview
The `du` (disk usage) command estimates file space usage. It summarizes disk usage of each file and directory recursively.

## Syntax
```bash
du [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human readable sizes |
| `-s` | Display only total |
| `-c` | Show grand total |
| `-a` | Show all files |
| `-b` | Show size in bytes |
| `-k` | Show size in kilobytes |
| `-m` | Show size in megabytes |
| `--max-depth=N` | Show subdirs only to depth N |
| `--apparent-size` | Print apparent sizes |
| `--time` | Show last modification time |
| `-x` | Stay on one filesystem |

## Key Use Cases
1. Storage analysis
2. Directory size checking
3. Disk cleanup
4. Space monitoring
5. Quota management

## Examples with Explanations
### Example 1: Directory Summary
```bash
du -sh *
```
Show total size of each item in current directory

### Example 2: Depth Limited
```bash
du --max-depth=2 /home
```
Show usage up to 2 levels deep

### Example 3: Sort by Size
```bash
du -h | sort -hr
```
Show sorted usage by size

## Understanding Output
Format:
```
Size    Path
4.0K    ./file1
8.0K    ./dir1
12K     .
```

## Common Usage Patterns
1. Find large directories:
   ```bash
   du -h --max-depth=1 | sort -hr
   ```
2. Check specific directory:
   ```bash
   du -sh /var/log
   ```
3. Show all files:
   ```bash
   du -ah
   ```

## Performance Analysis
- I/O intensive operation
- Directory traversal impact
- Large directory handling
- Memory usage considerations
- Network filesystem impact

## Related Commands
- `df` - Filesystem usage
- `ls` - List files
- `find` - Search files
- `ncdu` - NCurses disk usage
- `baobab` - Disk usage analyzer

## Additional Resources
- [GNU Coreutils - du](https://www.gnu.org/software/coreutils/manual/html_node/du-invocation.html)
- [Linux Storage Management](https://tldp.org/LDP/sag/html/disk-resources.html)
- [Disk Usage Analysis](https://www.tecmint.com/check-linux-disk-usage-of-files-and-directories/)

## Best Practices
1. Use human readable format
2. Limit depth for large trees
3. Consider filesystem boundaries
4. Sort output when needed
5. Regular monitoring

## Common Issues
1. Permission denied errors
2. Network latency
3. Hard link counting
4. Sparse file handling
5. Special filesystem types
