# htop

## Overview
The `htop` command is an interactive process viewer and system monitor. It's an enhanced version of `top` with a more user-friendly interface and additional features.

## Syntax
```bash
htop [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d delay` | Update delay in seconds |
| `-u user` | Show only user's processes |
| `-p pid` | Show only specific PIDs |
| `-s column` | Sort by column |
| `-C` | No color mode |
| `-h` | Show help |
| `--tree` | Show process tree |

## Interactive Keys
| Key | Action |
|-----|--------|
| `F1` | Help |
| `F2` | Setup |
| `F3` | Search |
| `F4` | Filter |
| `F5` | Tree view |
| `F6` | Sort by |
| `F7` | Nice - |
| `F8` | Nice + |
| `F9` | Kill |
| `F10` | Quit |
| `Space` | Tag process |
| `U` | Untag all |
| `t` | Tree mode |
| `H` | Hide/show threads |

## Display Information
| Column | Description |
|--------|-------------|
| PID | Process ID |
| USER | Process owner |
| PRI | Priority |
| NI | Nice value |
| VIRT | Virtual memory |
| RES | Resident memory |
| SHR | Shared memory |
| S | Process state |
| %CPU | CPU usage |
| %MEM | Memory usage |
| TIME+ | CPU time |
| COMMAND | Command line |

## Key Use Cases
1. Monitor system performance
2. Identify resource-heavy processes
3. Kill problematic processes
4. Analyze memory usage
5. Track CPU utilization

## Examples with Explanations
### Example 1: Basic Usage
```bash
htop
```
Launches interactive process monitor

### Example 2: Show Specific User
```bash
htop -u apache
```
Shows only apache user's processes

### Example 3: Tree View
```bash
htop --tree
```
Displays processes in tree format

## Process Management
1. Kill process: Select and press F9
2. Change priority: F7 (decrease) or F8 (increase)
3. Search processes: F3
4. Filter processes: F4
5. Tag multiple processes: Space

## System Information Display
Top panel shows:
- CPU usage per core
- Memory usage (RAM/Swap)
- Load averages
- Uptime
- Task counts

## Customization Options
1. Setup menu (F2):
   - Display options
   - Colors
   - Columns
   - Meters

2. Column configuration:
   - Add/remove columns
   - Reorder columns
   - Change column width

## Common Usage Patterns
1. Find memory hogs:
   - Sort by %MEM (F6 → M)
   - Look for high RES values

2. Find CPU intensive processes:
   - Sort by %CPU (F6 → P)
   - Monitor over time

3. Process tree analysis:
   - Enable tree view (F5)
   - Expand/collapse with +/-

## Performance Analysis
- Real-time updates
- Low system overhead
- Efficient display
- Responsive interface
- Minimal CPU usage

## Related Commands
- `top` - Basic process monitor
- `ps` - Process snapshot
- `pstree` - Process tree
- `iotop` - I/O monitoring
- `nethogs` - Network usage

## Additional Resources
- [Htop Manual](https://htop.dev/)
- [Process Monitoring Guide](https://www.tecmint.com/htop-command-examples/)

## Best Practices
1. Use tree view for process relationships
2. Monitor trends over time
3. Use filtering for specific analysis
4. Customize display for your needs
5. Learn keyboard shortcuts

## Advanced Features
1. Strace integration:
   - Select process and press 's'

2. Lsof integration:
   - Select process and press 'l'

3. Process following:
   - Follow process children

## Installation
Most distributions include htop:
```bash
# Ubuntu/Debian
sudo apt install htop

# CentOS/RHEL
sudo yum install htop

# Arch Linux
sudo pacman -S htop
```

## Configuration
Config file location: `~/.config/htop/htoprc`
- Saves display preferences
- Column configurations
- Color schemes
- Sort preferences

## Troubleshooting
1. Permission issues for some processes
2. High refresh rate impact
3. Terminal compatibility
4. Color display problems
5. Memory usage of htop itself

## Comparison with top
Advantages over top:
- Color display
- Mouse support
- Easier navigation
- Better process tree
- More intuitive interface
- Horizontal scrolling

## Integration Examples
1. With scripts:
   ```bash
   htop -d 1 -p $(pgrep firefox)
   ```
2. Remote monitoring:
   ```bash
   ssh server htop
   ```
3. Automated screenshots:
   ```bash
   htop -C > process_snapshot.txt
   ```