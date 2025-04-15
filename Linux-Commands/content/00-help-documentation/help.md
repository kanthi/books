# help

## Overview
The `help` command displays information about shell (bash) built-in commands. It provides quick reference documentation for commands that are part of the shell itself.

## Syntax
```bash
help [-dms] [pattern ...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Output short description |
| `-m` | Display usage in pseudo-manpage format |
| `-s` | Output only brief syntax |
| `-i` | Output detailed information |
| `pattern` | Show help for commands matching pattern |

## Key Use Cases
1. Get help on shell builtins
2. Check command syntax
3. View command options
4. Learn about shell features
5. Quick reference guide

## Examples with Explanations
### Example 1: Basic Help
```bash
help cd
```
Show help for cd builtin command

### Example 2: Brief Syntax
```bash
help -s read
```
Show only syntax for read command

### Example 3: Detailed Information
```bash
help -i test
```
Show detailed information about test command

## Understanding Output
Help output includes:
- Command syntax
- Description
- Options
- Arguments
- Examples
- Related commands

## Common Usage Patterns
1. List all builtins:
   ```bash
   help
   ```
2. Get command syntax:
   ```bash
   help -s command
   ```
3. Search for command:
   ```bash
   help command | grep keyword
   ```

## Performance Analysis
- Instant access to documentation
- No external files needed
- Shell-specific information
- Memory efficient
- Always available

## Related Commands
- `man` - System manual pages
- `info` - GNU info documentation
- `type` - Show command type
- `which` - Locate command
- `whatis` - Show command description

## Additional Resources
- [Bash Manual](https://www.gnu.org/software/bash/manual/)
- [Bash Builtin Commands](https://www.gnu.org/software/bash/manual/html_node/Bash-Builtins.html)
- [Shell Scripting Guide](https://tldp.org/LDP/abs/html/)
