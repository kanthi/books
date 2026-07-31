# which

## Overview
The `which` command locates executable files in the system PATH. It shows the full path of commands that would be executed when typed in the shell.

## Syntax
```bash
which [options] command...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Show all matches in PATH |
| `-s` | Silent mode (exit status only) |
| `--version` | Show version |
| `--help` | Show help |

## Key Use Cases
1. Find executable locations
2. Verify command availability
3. Check PATH configuration
4. Troubleshoot command issues
5. Script validation

## Examples with Explanations
### Example 1: Find Command Location
```bash
which python
```
Shows the path to the python executable

### Example 2: Multiple Commands
```bash
which python java gcc
```
Shows paths for multiple commands

### Example 3: All Matches
```bash
which -a python
```
Shows all python executables in PATH

## Understanding Output
- Returns full path if found
- No output if command not found
- Exit status 0 if found, 1 if not found
- Searches PATH directories in order

## Common Usage Patterns
1. Check if command exists:
   ```bash
   which git > /dev/null && echo "Git is installed"
   ```
2. Find all versions:
   ```bash
   which -a python
   ```
3. Script validation:
   ```bash
   command -v python || echo "Python not found"
   ```

## PATH Environment
The `which` command searches directories in the PATH environment variable:
```bash
echo $PATH
```

PATH order matters:
- First match is returned
- Earlier directories take precedence
- Use `-a` to see all matches

## Performance Analysis
- Very fast operation
- No filesystem scanning
- Only searches PATH directories
- Minimal resource usage
- Efficient for scripting

## Related Commands
- `whereis` - Find binaries, sources, manuals
- `locate` - Find files by name
- `type` - Display command type
- `command -v` - POSIX-compliant alternative
- `hash` - Remember command locations

## Additional Resources
- [Which Manual](https://www.gnu.org/software/which/)
- [Command Location Guide](https://www.tecmint.com/which-command-examples/)

## Best Practices
1. Use in scripts to check dependencies
2. Combine with conditional statements
3. Use `command -v` for portability
4. Check exit status for automation
5. Use `-a` to see all available versions

## Alternative Commands
1. `command -v` (POSIX standard):
   ```bash
   command -v python
   ```
2. `type` command:
   ```bash
   type python
   ```
3. `hash` for cached locations:
   ```bash
   hash python
   ```

## Scripting Examples
1. Dependency check:
   ```bash
   for cmd in git python make; do
       which "$cmd" > /dev/null || echo "$cmd not found"
   done
   ```
2. Version selection:
   ```bash
   PYTHON=$(which python3 || which python)
   ```
3. Conditional execution:
   ```bash
   which docker > /dev/null && docker --version
   ```

## Troubleshooting
1. Command not found in PATH
2. Permission issues
3. Symlink resolution
4. Shell built-ins not shown
5. Alias interference

## Shell Built-ins
Note: `which` doesn't find shell built-ins like:
- `cd`
- `echo` (in some shells)
- `pwd`
- `history`

Use `type` to identify built-ins:
```bash
type cd
```

## Integration Examples
1. With if statements:
   ```bash
   if which node > /dev/null; then
       node --version
   fi
   ```
2. With variables:
   ```bash
   EDITOR=$(which vim || which nano || which vi)
   ```
3. Error handling:
   ```bash
   which python3 || { echo "Python3 required"; exit 1; }
   ```
## Additional Examples
```bash
which ls
which -a python3          # all matches in PATH
type -a ls                # shell builtin-aware alternative
command -v ls
```
