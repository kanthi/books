# pwd

## Overview
The `pwd` (print working directory) command prints the name of the current working directory. It shows the full path from the root directory to your current location.

## Syntax
```bash
pwd [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-L` | Use PWD from environment (logical) |
| `-P` | Avoid symlinks (physical) |
| `--help` | Display help message |
| `--version` | Output version information |

## Key Use Cases
1. Show current location
2. Verify directory path
3. Use in scripts
4. Check symbolic links
5. Path confirmation

## Examples with Explanations
### Example 1: Basic Usage
```bash
pwd
```
Show current working directory

### Example 2: Physical Path
```bash
pwd -P
```
Show physical path (resolve symlinks)

### Example 3: Logical Path
```bash
pwd -L
```
Show logical path (with symlinks)

## Understanding Output
- Absolute path from root (/)
- One line output
- No trailing slash
- Error messages for:
  - Permission issues
  - Read errors
  - Path resolution problems

## Common Usage Patterns
1. Script directory check:
   ```bash
   current_dir=$(pwd)
   ```
2. Path verification:
   ```bash
   pwd -P
   ```
3. Directory navigation:
   ```bash
   cd $(pwd)
   ```

## Performance Analysis
- Fast execution
- Minimal resource usage
- Built-in shell command
- Path resolution impact
- Symlink overhead

## Related Commands
- `cd` - Change directory
- `ls` - List directory contents
- `dirname` - Strip last component
- `basename` - Strip directory path
- `realpath` - Resolve path

## Additional Resources
- [GNU Coreutils - pwd](https://www.gnu.org/software/coreutils/manual/html_node/pwd-invocation.html)
- [POSIX pwd specification](https://pubs.opengroup.org/onlinepubs/9699919799/utilities/pwd.html)
- [Shell Scripting Guide](https://tldp.org/LDP/abs/html/)
