# more

## Overview
The `more` command is a file perusal filter for viewing text one screen at a time. It's simpler than `less` but still useful for basic file viewing.

## Syntax
```bash
more [options] file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d` | Display help prompt |
| `-f` | Count logical lines |
| `-l` | Suppress line-break treatment |
| `-s` | Squeeze multiple blank lines |
| `-u` | Suppress underlining |
| `-5` | Screen every 5 lines |
| `-p` | Clear screen before display |
| `+/pattern` | Start at pattern |
| `+num` | Start at line number |

## Key Use Cases
1. View text files
2. Read documentation
3. Display command output
4. Basic file navigation
5. Quick file inspection

## Examples with Explanations
### Example 1: Basic Usage
```bash
more file.txt
```
View file one screen at a time

### Example 2: Start at Pattern
```bash
more +/pattern file.txt
```
Start viewing at first occurrence of pattern

### Example 3: Line Numbers
```bash
more +5 file.txt
```
Start viewing from line 5

## Understanding Output
Commands during viewing:
- Space: Next page
- Enter: Next line
- b: Previous page
- /pattern: Search pattern
- =: Show current line number
- q: Quit
- h: Help

## Common Usage Patterns
1. View with line numbers:
   ```bash
   more -d file
   ```
2. Squeeze blank lines:
   ```bash
   more -s file
   ```
3. Pipe command output:
   ```bash
   command | more
   ```

## Performance Analysis
- Simple and lightweight
- Forward-only scrolling
- Limited memory usage
- Quick startup
- Basic feature set

## Related Commands
- `less` - Enhanced pager
- `cat` - Display file contents
- `pg` - Another pager
- `view` - Read-only vim
- `most` - Another pager

## Additional Resources
- [More Manual](https://man7.org/linux/man-pages/man1/more.1.html)
- [Text Processing Guide](https://tldp.org/LDP/abs/html/textproc.html)
- [File Viewing Tools](https://www.tecmint.com/linux-more-command-and-less-command-examples/)

## Limitations
1. No backward scrolling
2. Limited search capabilities
3. Basic feature set
4. No file editing
5. Single file viewing

## Best Practices
1. Use for quick views
2. Consider less for large files
3. Use with pipes
4. Learn key commands
5. Know when to switch to less
