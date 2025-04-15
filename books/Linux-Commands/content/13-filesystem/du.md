# du

## Overview
The `du` (Disk Usage) command estimates file and directory space usage. It's used to find disk consumption at directory and file levels.

## Syntax
```bash
du [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-h` | Human readable |
| `-s` | Summary only |
| `-c` | Show total |
| `-a` | Show all files |
| `-d N` | Max depth N |
| `--max-depth=N` | Same as -d N |
| `-x` | One file system |
| `-b` | Bytes |
| `-k` | Kilobytes |
| `-m` | Megabytes |
| `--time` | Show time |
| `--exclude` | Exclude pattern |

## Key Use Cases
1. Space analysis
2. Directory sizing
3. Cleanup planning
4. Storage management
5. Quota monitoring

## Examples with Explanations
### Example 1: Directory Summary
```bash
du -sh directory
```
Show directory total size

### Example 2: Top-level Sizes
```bash
du -h --max-depth=1
```
Show immediate subdirectories

### Example 3: All Files
```bash
du -ah
```
Show all files and directories

## Common Usage Patterns
1. Sort by size:
   ```bash
   du -h | sort -h
   ```
2. Large directories:
   ```bash
   du -h --threshold=1G
   ```
3. Exclude pattern:
   ```bash
   du -h --exclude="*.tmp"
   ```

## Security Considerations
1. File permissions
2. Directory access
3. Symbolic links
4. Hidden files
5. Network mounts

## Related Commands
- `df` - Disk free
- `ls` - List files
- `find` - Search files
- `ncdu` - NCurses disk usage
- `sort` - Sort output

## Additional Resources
- [Du Manual](https://man7.org/linux/man-pages/man1/du.1.html)
- [Disk Usage Guide](https://www.cyberciti.biz/faq/unix-linux-du-command-examples/)
- [System Administration](https://www.tecmint.com/check-linux-disk-usage-of-files-and-directories/)

## Best Practices
1. Regular checks
2. Sort output
3. Use summaries
4. Exclude temporary
5. Document large dirs

## Output Formats
1. Bytes
2. Human readable
3. Block counts
4. Summarized
5. Detailed

## Troubleshooting
1. Permission denied
2. Disk full
3. Long runtime
4. Memory usage
5. Link loops
