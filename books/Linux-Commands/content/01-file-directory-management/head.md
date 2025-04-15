# head

## Overview
The `head` command outputs the first part of files. By default, it prints the first 10 lines of each file to standard output.

## Syntax
```bash
head [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-n num` | Print first num lines |
| `-c num` | Print first num bytes |
| `-q` | Never print headers |
| `-v` | Always print headers |
| `--bytes=[-]num` | Print first num bytes |
| `--lines=[-]num` | Print first num lines |
| `-z` | Line delimiter is NUL |
| `--help` | Display help message |
| `--version` | Output version information |

## Key Use Cases
1. View file beginning
2. Check file headers
3. Monitor log files
4. Quick file inspection
5. Data sampling

## Examples with Explanations
### Example 1: Default Usage
```bash
head file.txt
```
Show first 10 lines

### Example 2: Specific Lines
```bash
head -n 5 file.txt
```
Show first 5 lines

### Example 3: Multiple Files
```bash
head -n 3 file1 file2
```
Show first 3 lines of each file

## Understanding Output
- Default: 10 lines
- With multiple files:
  - ==> filename <== headers
- Error messages for:
  - File not found
  - Permission denied
  - Invalid number argument

## Common Usage Patterns
1. View file start:
   ```bash
   head -n 20 file
   ```
2. Check byte count:
   ```bash
   head -c 1000 file
   ```
3. Monitor new log entries:
   ```bash
   head -f logfile
   ```

## Performance Analysis
- Fast operation
- Memory efficient
- Handles large files well
- Stream processing
- Multiple file overhead

## Related Commands
- `tail` - Output file end
- `cat` - Concatenate files
- `less` - File pager
- `more` - File perusal
- `sed` - Stream editor

## Additional Resources
- [GNU Coreutils - head](https://www.gnu.org/software/coreutils/manual/html_node/head-invocation.html)
- [Linux Text Processing](https://tldp.org/LDP/abs/html/textproc.html)
- [File Viewing Guide](https://www.tecmint.com/view-contents-of-file-in-linux/)

## Use Cases
1. Log file inspection
2. File format verification
3. Quick content preview
4. Data sampling
5. Script debugging
