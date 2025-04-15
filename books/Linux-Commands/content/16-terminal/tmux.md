# tmux

## Overview
The `tmux` (Terminal Multiplexer) command creates a terminal session manager that allows multiple terminal sessions to be accessed and controlled from a single terminal. It's a modern alternative to screen.

## Syntax
```bash
tmux [options] [command]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-2` | Force 256 colors |
| `-c file` | Config file |
| `-f file` | Alternative config |
| `-L socket` | Socket name |
| `-S socket` | Socket path |
| `-u` | UTF-8 mode |
| `-v` | Verbose logging |
| `-V` | Show version |
| `-l` | List sessions |
| `-s session` | Session name |
| `-t target` | Target session |

## Key Bindings
| Command | Action |
|---------|---------|
| `Ctrl-b c` | Create window |
| `Ctrl-b n` | Next window |
| `Ctrl-b p` | Previous window |
| `Ctrl-b d` | Detach session |
| `Ctrl-b %` | Split vertical |
| `Ctrl-b "` | Split horizontal |
| `Ctrl-b x` | Kill pane |
| `Ctrl-b &` | Kill window |
| `Ctrl-b [` | Copy mode |
| `Ctrl-b ]` | Paste buffer |

## Key Use Cases
1. Session management
2. Remote work
3. Project organization
4. Process monitoring
5. Pair programming

## Examples with Explanations
### Example 1: New Session
```bash
tmux new -s mysession
```
Create named session

### Example 2: Attach Session
```bash
tmux attach -t mysession
```
Attach to existing session

### Example 3: List Sessions
```bash
tmux ls
```
Show running sessions

## Common Usage Patterns
1. Start named:
   ```bash
   tmux new -s name
   ```
2. Split window:
   ```bash
   Ctrl-b % (vertical)
   Ctrl-b " (horizontal)
   ```
3. Session management:
   ```bash
   tmux list-sessions
   tmux kill-session -t name
   ```

## Security Considerations
1. Socket permissions
2. Session access
3. Clipboard security
4. Remote access
5. Multi-user mode

## Related Commands
- `screen` - Terminal multiplexer
- `byobu` - Wrapper
- `tmate` - Sharing tool
- `abduco` - Session manager
- `dvtm` - Terminal manager

## Additional Resources
- [Tmux Manual](https://man7.org/linux/man-pages/man1/tmux.1.html)
- [Usage Guide](https://github.com/tmux/tmux/wiki)
- [System Administration](https://www.hamvocke.com/blog/a-quick-and-easy-guide-to-tmux/)

## Best Practices
1. Name sessions
2. Use windows
3. Configure status
4. Custom bindings
5. Regular cleanup

## Configuration
1. ~/.tmux.conf
2. Key bindings
3. Status line
4. Colors/theme
5. Plugin system

## Troubleshooting
1. Session issues
2. Color problems
3. Key conflicts
4. Plugin errors
5. Performance
