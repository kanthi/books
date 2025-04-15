# screen

## Overview
The `screen` command is a full-screen window manager that multiplexes a physical terminal between several processes. It allows you to run multiple terminal sessions inside a single terminal window.

## Syntax
```bash
screen [options] [command [args]]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-S name` | Set session name |
| `-r [pid]` | Reattach session |
| `-d` | Detach session |
| `-D` | Detach and logout |
| `-R` | Reattach if exists |
| `-x` | Attach to running |
| `-ls` | List sessions |
| `-L` | Enable logging |
| `-m` | Ignore $STY |
| `-c file` | Config file |
| `-v` | Version info |

## Key Bindings
| Command | Action |
|---------|---------|
| `Ctrl-a c` | Create window |
| `Ctrl-a n` | Next window |
| `Ctrl-a p` | Previous window |
| `Ctrl-a d` | Detach session |
| `Ctrl-a k` | Kill window |
| `Ctrl-a ?` | Help screen |
| `Ctrl-a "` | Window list |
| `Ctrl-a A` | Rename window |
| `Ctrl-a S` | Split horizontal |
| `Ctrl-a |` | Split vertical |

## Key Use Cases
1. Session management
2. Remote work
3. Process monitoring
4. Multiple terminals
5. Long-running tasks

## Examples with Explanations
### Example 1: New Session
```bash
screen -S mysession
```
Create named session

### Example 2: Reattach
```bash
screen -r mysession
```
Reattach to session

### Example 3: List Sessions
```bash
screen -ls
```
Show running sessions

## Common Usage Patterns
1. Start named:
   ```bash
   screen -S name
   ```
2. Detach/reattach:
   ```bash
   Ctrl-a d
   screen -r
   ```
3. Kill session:
   ```bash
   screen -X -S [session] quit
   ```

## Security Considerations
1. Session access
2. Multi-user mode
3. Process isolation
4. Log security
5. Remote access

## Related Commands
- `tmux` - Terminal multiplexer
- `byobu` - Screen wrapper
- `dtach` - Session detachment
- `nohup` - Run background
- `disown` - Job control

## Additional Resources
- [Screen Manual](https://www.gnu.org/software/screen/manual/screen.html)
- [Usage Guide](https://www.cyberciti.biz/faq/linux-screen-command-examples-usage-tutorial/)
- [System Administration](https://www.tecmint.com/screen-command-examples-to-manage-linux-terminals/)

## Best Practices
1. Name sessions
2. Use logging
3. Configure startup
4. Monitor status
5. Clean up

## Configuration
1. .screenrc file
2. Key bindings
3. Status line
4. Window setup
5. Logging options

## Troubleshooting
1. Session issues
2. Permission problems
3. Display errors
4. Key binding conflicts
5. Resource limits
