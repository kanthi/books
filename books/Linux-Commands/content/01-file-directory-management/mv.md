# mv

## Overview
The `mv` (move) command moves or renames files and directories. It can move multiple files to a directory and includes options for safe operations.

## Syntax
```bash
mv [options] source... destination
```

## Common Options
| Option | Description |
|--------|-------------|
| `-i` | Interactive (prompt before overwrite) |
| `-f` | Force move (no prompting) |
| `-n` | No overwrite |
| `-u` | Update (move only newer files) |
| `-v` | Verbose mode |
| `-b` | Create backup |
| `-t target` | Move all sources into target directory |
| `--strip-trailing-slashes` | Remove trailing slashes |
| `--suffix=suffix` | Backup suffix (default ~) |

## Key Use Cases
1. Move files
2. Rename files
3. Move directories
4. Safe file operations
5. Bulk file movement

## Examples with Explanations
### Example 1: Rename File
```bash
mv oldname newname
```
Rename file from oldname to newname

### Example 2: Move to Directory
```bash
mv file1 file2 directory/
```
Move multiple files to directory

### Example 3: Safe Move
```bash
mv -i source dest
```
Move with confirmation prompt

## Understanding Output
- No output by default
- With -v:
  - 'renamed file1 -> file2' format
- Error messages for:
  - Permission denied
  - No space
  - File exists
  - Source not found

## Common Usage Patterns
1. Safe moving:
   ```bash
   mv -i * ../newdir/
   ```
2. Create backup:
   ```bash
   mv -b file1 file2
   ```
3. Update existing:
   ```bash
   mv -u source/* dest/
   ```

## Performance Analysis
- Fast operation (metadata update)
- Cross-filesystem considerations
- Directory entry updates
- Backup creation overhead
- Permission checking

## Related Commands
- `cp` - Copy files
- `rm` - Remove files
- `rename` - Rename files
- `rsync` - Remote sync
- `mmv` - Multiple move

## Additional Resources
- [GNU Coreutils - mv](https://www.gnu.org/software/coreutils/manual/html_node/mv-invocation.html)
- [Linux File Management](https://tldp.org/LDP/intro-linux/html/sect_03_03.html)
- [File Operations Guide](https://www.tecmint.com/mv-command-examples-in-linux/)
