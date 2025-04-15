# cp

## Overview
The `cp` (copy) command copies files and directories. It can preserve file attributes, handle recursive copying, and create backups.

## Syntax
```bash
cp [options] source... destination
```

## Common Options
| Option | Description |
|--------|-------------|
| `-r, -R` | Copy directories recursively |
| `-i` | Interactive (prompt before overwrite) |
| `-f` | Force copy (no prompting) |
| `-p` | Preserve attributes |
| `-a` | Archive mode (same as -dR --preserve=all) |
| `-u` | Update (copy only newer files) |
| `-v` | Verbose mode |
| `-n` | No overwrite |
| `-l` | Create hard links |
| `-s` | Create symbolic links |

## Key Use Cases
1. Copy files
2. Copy directories
3. Backup files
4. Preserve attributes
5. Create links

## Examples with Explanations
### Example 1: Basic File Copy
```bash
cp file1 file2
```
Copy file1 to file2

### Example 2: Recursive Directory Copy
```bash
cp -r dir1 dir2
```
Copy directory dir1 and contents to dir2

### Example 3: Preserve Attributes
```bash
cp -a source dest
```
Copy with all attributes preserved

## Understanding Output
- No output by default
- With -v:
  - 'file1 -> file2' format
- Error messages for:
  - Permission denied
  - No space
  - File exists
  - Source not found

## Common Usage Patterns
1. Safe copy (interactive):
   ```bash
   cp -i source dest
   ```
2. Update existing files:
   ```bash
   cp -u source/* dest/
   ```
3. Backup with timestamp:
   ```bash
   cp file{,.bak}
   ```

## Performance Analysis
- File size impact
- Disk I/O considerations
- Network transfer (if applicable)
- Attribute preservation overhead
- Hard link vs copy trade-offs

## Related Commands
- `mv` - Move/rename files
- `rm` - Remove files
- `rsync` - Remote file copy
- `scp` - Secure copy
- `dd` - Convert and copy

## Additional Resources
- [GNU Coreutils - cp](https://www.gnu.org/software/coreutils/manual/html_node/cp-invocation.html)
- [Linux File Operations](https://tldp.org/LDP/intro-linux/html/sect_03_03.html)
- [File Management Guide](https://www.tecmint.com/15-basic-cp-command-examples-in-linux/)
