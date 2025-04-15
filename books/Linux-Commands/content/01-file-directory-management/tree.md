# tree

## Overview
The `tree` command displays directory structure in a tree-like format. It's useful for visualizing directory hierarchies and file organization.

## Syntax
```bash
tree [options] [directory...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Show all files |
| `-d` | List directories only |
| `-f` | Print full path prefix |
| `-i` | Don't print indentation lines |
| `-l` | Follow symbolic links |
| `-p` | Print protections |
| `-s` | Print size |
| `-h` | Print size in human readable format |
| `-u` | Print user name |
| `-g` | Print group name |
| `-L level` | Max display depth |
| `--prune` | Prune empty directories |
| `--filelimit n` | Don't descend dirs with > n files |
| `--dirsfirst` | List directories first |

## Key Use Cases
1. Directory visualization
2. Project structure analysis
3. File system navigation
4. Documentation generation
5. Directory comparison

## Examples with Explanations
### Example 1: Basic Usage
```bash
tree
```
Show directory structure

### Example 2: Limited Depth
```bash
tree -L 2
```
Show only two levels deep

### Example 3: Directory Only
```bash
tree -d
```
Show only directories

## Understanding Output
```
.
├── dir1
│   ├── file1
│   └── file2
└── dir2
    └── file3

2 directories, 3 files
```

## Common Usage Patterns
1. Project overview:
   ```bash
   tree -L 2 project/
   ```
2. Show with details:
   ```bash
   tree -pugh
   ```
3. Filter output:
   ```bash
   tree -P '*.py'
   ```

## Performance Analysis
- Directory traversal impact
- Memory usage for large trees
- Output formatting overhead
- Pattern matching speed
- Symbolic link handling

## Related Commands
- `ls` - List directory contents
- `find` - Search files
- `du` - Disk usage
- `pwd` - Print working directory
- `locate` - Find files

## Additional Resources
- [Tree Manual](http://mama.indstate.edu/users/ice/tree/)
- [Directory Structure Guide](https://www.tecmint.com/linux-tree-command-examples/)
- [File System Navigation](https://tldp.org/LDP/intro-linux/html/sect_03_01.html)

## Output Formatting
1. Color options
2. HTML output
3. XML output
4. JSON output
5. Custom patterns

## Best Practices
1. Use depth limits for large directories
2. Consider file limits
3. Filter unnecessary files
4. Use appropriate output format
5. Handle symbolic links carefully
