# visudo

## Overview
`visudo` safely edits the `/etc/sudoers` file. It locks the file against simultaneous edits and performs syntax checking before saving to prevent accidental lockout.

## Syntax
```bash
visudo [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-c`, `--check` | Check syntax of sudoers file without editing |
| `-f`, `--file FILE` | Edit or check specified file instead of default `/etc/sudoers` |
| `-s`, `--strict` | Enable strict syntax checking |

## Key Use Cases
1. Safely modifying administrative permissions in `/etc/sudoers`.
2. Validating custom sudo configuration files in `/etc/sudoers.d/`.

## Examples with Explanations
### Example 1: Check Sudoers Syntax
```bash
visudo -c
```
Parses `/etc/sudoers` and validates syntax without opening an editor.

## Related Commands
- `sudo` - Execute command as another user
- `passwd` - Change user password
