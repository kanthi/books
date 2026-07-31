# btop

## Overview
`btop` is a modern, interactive resource monitor for Linux. It displays real-time processor, memory, storage, network, and process usage statistics with a responsive visual terminal interface.

## Syntax
```bash
btop [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-lc`, `--low-color` | Run in 16-color mode for legacy terminals |
| `-t`, `--preset NUM` | Start with a specific layout preset |
| `-h`, `--help` | Show command line options |

## Interactive Keybindings
| Key | Action |
|-----|--------|
| `m` | Toggle memory view layout |
| `p` | Toggle process view sorting |
| `f` | Filter processes by name |
| `k` | Send termination signal to selected process |
| `q` | Quit `btop` |

## Key Use Cases
1. Visual monitoring of CPU core temperatures, frequencies, and load.
2. Tracking process tree hierarchies and memory usage in real time.
3. Live network bandwidth throughput monitoring per interface.

## Related Commands
- `top` - Standard Linux process monitor
- `htop` - Interactive ncurses process viewer
- `glances` - Cross-platform system monitoring tool
