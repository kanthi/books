# chmod

## Overview
The `chmod` command changes file and directory permissions in Linux. It controls read, write, and execute permissions for owner, group, and others.

## Syntax
```bash
chmod [options] mode file...
chmod [options] octal-mode file...
chmod [options] --reference=rfile file...
```

## Common Options
| Option | Description |
|--------|-------------|
| `-R` | Recursive operation |
| `-v` | Verbose output |
| `-c` | Report changes only |
| `-f` | Suppress error messages |
| `--reference=file` | Use file's permissions |
| `--preserve-root` | Protect root directory |

## Permission Modes
| Symbol | Meaning |
|--------|---------|
| `r` | Read permission (4) |
| `w` | Write permission (2) |
| `x` | Execute permission (1) |
| `u` | User/owner |
| `g` | Group |
| `o` | Others |
| `a` | All (u+g+o) |

## Octal Notation
| Octal | Binary | Permissions |
|-------|--------|-------------|
| 0 | 000 | --- |
| 1 | 001 | --x |
| 2 | 010 | -w- |
| 3 | 011 | -wx |
| 4 | 100 | r-- |
| 5 | 101 | r-x |
| 6 | 110 | rw- |
| 7 | 111 | rwx |

## Key Use Cases
1. Set file permissions
2. Make files executable
3. Secure sensitive files
4. Configure directory access
5. Batch permission changes

## Examples with Explanations
### Example 1: Make File Executable
```bash
chmod +x script.sh
```
Adds execute permission for all users

### Example 2: Set Specific Permissions
```bash
chmod 755 file.txt
```
Sets rwxr-xr-x permissions (owner: rwx, group/others: r-x)

### Example 3: Recursive Directory Permissions
```bash
chmod -R 644 /path/to/directory
```
Sets rw-r--r-- permissions recursively

## Understanding Permission Strings
Format: `drwxrwxrwx`
- First character: file type (d=directory, -=file, l=link)
- Next 3: owner permissions (rwx)
- Next 3: group permissions (rwx)
- Last 3: other permissions (rwx)

## Common Usage Patterns
1. Secure private file:
   ```bash
   chmod 600 private.txt
   ```
2. Public readable directory:
   ```bash
   chmod 755 public_dir/
   ```
3. Remove all permissions:
   ```bash
   chmod 000 restricted_file
   ```

## Special Permissions
| Permission | Octal | Description |
|------------|-------|-------------|
| Setuid | 4000 | Run as owner |
| Setgid | 2000 | Run as group |
| Sticky bit | 1000 | Restrict deletion |

## Performance Analysis
- Minimal performance impact
- Recursive operations can be slow on large directories
- Use find with -exec for complex permission changes
- Consider using parallel processing for large datasets

## Related Commands
- `chown` - Change ownership
- `chgrp` - Change group
- `umask` - Default permissions
- `ls -l` - View permissions
- `stat` - Detailed file info

## Additional Resources
- [GNU chmod manual](https://www.gnu.org/software/coreutils/manual/html_node/chmod-invocation.html)
- [Linux File Permissions Guide](https://www.tecmint.com/understanding-file-permissions-and-ownership-in-linux/)

## Best Practices
1. Use least privilege principle
2. Be careful with recursive operations
3. Test permissions before applying
4. Document permission requirements
5. Use symbolic notation for clarity

## Security Considerations
1. Avoid 777 permissions
2. Protect sensitive files (600/700)
3. Use setuid/setgid carefully
4. Regular permission audits
5. Monitor permission changes