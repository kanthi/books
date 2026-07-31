# cd

## Overview
The `cd` (change directory) command is used to change the current working directory in Linux and Unix-like operating systems. It's one of the most fundamental shell commands.

## Syntax
```bash
cd [options] [directory]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-L` | Follow symbolic links (default) |
| `-P` | Use physical directory structure |
| `-e` | Exit if error occurs |
| `--help` | Display help message |
| `-` | Change to previous directory |
| `~` | Change to home directory |
| `..` | Move up one directory |
| `.` | Current directory |

## Key Use Cases
1. Navigate directory structure
2. Return to home directory
3. Move between directories
4. Access relative paths
5. Follow symbolic links

## Examples with Explanations
### Example 1: Basic Navigation
```bash
cd /usr/local/bin
```
Change to specified directory

### Example 2: Return Home
```bash
cd ~
# or simply
cd
```
Change to home directory

### Example 3: Previous Directory
```bash
cd -
```
Return to previous directory

## Understanding Output
- No output on success
- Error messages for:
  - Permission denied
  - No such directory
  - Not a directory
  - Path too long

## Common Usage Patterns
1. Relative navigation:
   ```bash
   cd ../directory
   ```
2. Absolute navigation:
   ```bash
   cd /absolute/path
   ```
3. Home subdirectory:
   ```bash
   cd ~/Documents
   ```

## Performance Analysis
- Built-in shell command
- Instant execution
- No external process
- Memory efficient
- Path resolution impact

## Related Commands
- `pwd` - Print working directory
- `ls` - List directory contents
- `pushd` - Push directory
- `popd` - Pop directory
- `dirs` - Display directory stack

## Additional Resources
- [Bash Manual - cd](https://www.gnu.org/software/bash/manual/html_node/Bourne-Shell-Builtins.html#index-cd)
- [Directory Navigation Guide](https://tldp.org/LDP/abs/html/basic.html)
- [Shell Scripting Tutorial](https://www.shellscript.sh/)
## Additional Examples
```bash
cd /var/log
cd -              # previous directory
cd ~alice         # home of user
cd /usr/local/bin && pwd
```
