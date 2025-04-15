# mkdir

## Overview
The `mkdir` (make directory) command creates new directories. It can create multiple directories at once and create parent directories as needed.

## Syntax
```bash
mkdir [options] directory...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-p` | Create parent directories as needed |
| `-m mode` | Set file mode/permissions |
| `-v` | Print message for each directory |
| `-Z` | Set SELinux security context |
| `--help` | Display help message |
| `--version` | Output version information |
| `-context` | Set complete SELinux context |

## Key Use Cases
1. Create new directories
2. Create directory hierarchies
3. Set directory permissions
4. Create multiple directories
5. Create parent directories

## Examples with Explanations
### Example 1: Basic Usage
```bash
mkdir new_directory
```
Create a single directory

### Example 2: Create Parents
```bash
mkdir -p parent/child/grandchild
```
Create directory hierarchy

### Example 3: Set Permissions
```bash
mkdir -m 755 secure_dir
```
Create directory with specific permissions

## Understanding Output
- No output by default
- With -v:
  - Created directory messages
- Error messages for:
  - Permission denied
  - File exists
  - Invalid path
  - No space

## Common Usage Patterns
1. Create multiple directories:
   ```bash
   mkdir dir1 dir2 dir3
   ```
2. Create with parents:
   ```bash
   mkdir -p /path/to/new/dir
   ```
3. Create with permissions:
   ```bash
   mkdir -m 700 private_dir
   ```

## Performance Analysis
- Fast operation
- Minimal system impact
- Parent creation overhead
- Permission checking
- Directory entry updates

## Related Commands
- `rmdir` - Remove directories
- `rm` - Remove files/directories
- `ls` - List directory contents
- `chmod` - Change permissions
- `touch` - Create empty files

## Additional Resources
- [GNU Coreutils - mkdir](https://www.gnu.org/software/coreutils/manual/html_node/mkdir-invocation.html)
- [Linux File Permissions](https://www.kernel.org/doc/html/latest/admin-guide/security-files.html)
- [Directory Management Guide](https://tldp.org/LDP/abs/html/basic.html)
