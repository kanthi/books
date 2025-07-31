# diff

## Overview
The `diff` command compares files line by line and displays the differences. It's essential for version control, code review, and file comparison tasks.

## Syntax
```bash
diff [options] file1 file2
diff [options] directory1 directory2
```

## Common Options
| Option | Description |
|--------|-------------|
| `-u` | Unified diff format |
| `-c` | Context diff format |
| `-i` | Ignore case differences |
| `-w` | Ignore whitespace |
| `-b` | Ignore changes in whitespace |
| `-B` | Ignore blank lines |
| `-r` | Recursive directory comparison |
| `-q` | Brief output (only if files differ) |
| `-s` | Report identical files |
| `-y` | Side-by-side comparison |
| `--color` | Colorize output |

## Output Formats
| Format | Description |
|--------|-------------|
| Normal | Default format with line numbers |
| Unified (-u) | Git-style format |
| Context (-c) | Shows context around changes |
| Side-by-side (-y) | Two-column comparison |

## Key Use Cases
1. Compare file versions
2. Code review
3. Configuration changes
4. Backup verification
5. Patch creation

## Examples with Explanations
### Example 1: Basic Comparison
```bash
diff file1.txt file2.txt
```
Shows differences between two files

### Example 2: Unified Format
```bash
diff -u original.txt modified.txt
```
Shows differences in unified format (like Git)

### Example 3: Directory Comparison
```bash
diff -r dir1/ dir2/
```
Recursively compares two directories

## Understanding Output
Normal format symbols:
- `a` - Added lines
- `d` - Deleted lines
- `c` - Changed lines
- `<` - Lines from first file
- `>` - Lines from second file

Example:
```
2c2
< old line
---
> new line
```

## Common Usage Patterns
1. Ignore whitespace:
   ```bash
   diff -w file1.txt file2.txt
   ```
2. Side-by-side view:
   ```bash
   diff -y file1.txt file2.txt
   ```
3. Quick check if files differ:
   ```bash
   diff -q file1.txt file2.txt
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `--exclude=pattern` | Exclude files matching pattern |
| `--exclude-from=file` | Exclude patterns from file |
| `-x pattern` | Exclude files matching pattern |
| `-N` | Treat absent files as empty |
| `-a` | Treat all files as text |
| `--strip-trailing-cr` | Strip carriage returns |

## Patch Creation
Create patches for later application:
```bash
diff -u original.txt modified.txt > changes.patch
```

Apply patches:
```bash
patch original.txt < changes.patch
```

## Performance Analysis
- Efficient for text files
- Memory usage scales with file size
- Good for moderate-sized files
- Consider alternatives for binary files
- Fast for small differences

## Related Commands
- `cmp` - Compare files byte by byte
- `comm` - Compare sorted files
- `patch` - Apply diff patches
- `git diff` - Git version comparison
- `vimdiff` - Visual diff editor

## Additional Resources
- [GNU diff manual](https://www.gnu.org/software/diffutils/manual/diff.html)
- [Diff Command Guide](https://www.tecmint.com/diff-command-examples/)

## Best Practices
1. Use unified format for patches
2. Ignore irrelevant whitespace
3. Use recursive mode for directories
4. Consider binary file handling
5. Use with version control systems

## Directory Comparison
1. Compare structures:
   ```bash
   diff -r --brief dir1/ dir2/
   ```
2. Exclude files:
   ```bash
   diff -r --exclude="*.log" dir1/ dir2/
   ```
3. Show only differences:
   ```bash
   diff -r -q dir1/ dir2/
   ```

## Integration Examples
1. With git:
   ```bash
   git diff > changes.patch
   ```
2. With find:
   ```bash
   diff <(find dir1 -type f | sort) <(find dir2 -type f | sort)
   ```
3. Configuration management:
   ```bash
   diff -u /etc/config.orig /etc/config
   ```

## Scripting Applications
1. Backup verification:
   ```bash
   if diff -q original.txt backup.txt > /dev/null; then
       echo "Backup is identical"
   fi
   ```
2. Configuration monitoring:
   ```bash
   diff /etc/passwd /etc/passwd.bak || echo "Password file changed"
   ```
3. Automated testing:
   ```bash
   diff expected_output.txt actual_output.txt || exit 1
   ```

## Special Cases
1. Binary files:
   ```bash
   diff -q binary1 binary2
   ```
2. Large files:
   ```bash
   diff --speed-large-files file1 file2
   ```
3. Case-insensitive:
   ```bash
   diff -i file1.txt file2.txt
   ```

## Troubleshooting
1. Binary file warnings
2. Memory issues with large files
3. Character encoding problems
4. Permission denied errors
5. Directory structure differences

## Output Redirection
1. Save differences:
   ```bash
   diff file1.txt file2.txt > differences.txt
   ```
2. Suppress output:
   ```bash
   diff file1.txt file2.txt > /dev/null
   ```
3. Error handling:
   ```bash
   diff file1.txt file2.txt 2>&1 | tee diff.log
   ```

## Color Output
Modern diff versions support color:
```bash
diff --color=always file1.txt file2.txt
```

Environment variable:
```bash
export DIFF_COLORS="old=31:new=32:hunk=36"
```