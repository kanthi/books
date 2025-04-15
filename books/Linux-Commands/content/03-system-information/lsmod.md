# lsmod

## Overview
The `lsmod` command shows the status of modules in the Linux kernel. It displays information about all loaded kernel modules.

## Syntax
```bash
lsmod
```

## Common Options
Note: lsmod doesn't typically take options as it simply shows the contents of `/proc/modules` in a formatted way.

## Key Use Cases
1. Kernel module inspection
2. System troubleshooting
3. Driver verification
4. Module dependency checking
5. System monitoring

## Examples with Explanations
### Example 1: List All Modules
```bash
lsmod
```
Show all loaded kernel modules

### Example 2: Filter Output
```bash
lsmod | grep video
```
Show only video-related modules

### Example 3: Sort by Size
```bash
lsmod | sort -k 2 -n
```
List modules sorted by size

## Understanding Output
Columns explained:
- Module: Name of module
- Size: Memory size in bytes
- Used: Reference count
- Used by: List of dependent modules

Example output:
```
Module                  Size  Used by
bluetooth             557056  23
rfcomm                 81920  4
bnep                   24576  2
```

## Common Usage Patterns
1. Check module status:
   ```bash
   lsmod | grep module_name
   ```
2. Find dependencies:
   ```bash
   lsmod | grep -w 'module'
   ```
3. Module size analysis:
   ```bash
   lsmod | sort -k 2 -nr | head
   ```

## Performance Analysis
- Fast execution
- Reads from /proc
- Minimal system impact
- Real-time information
- No disk I/O required

## Related Commands
- `modinfo` - Module information
- `insmod` - Insert module
- `rmmod` - Remove module
- `modprobe` - Add/remove modules
- `depmod` - Generate dependencies

## Additional Resources
- [Linux Kernel Documentation](https://www.kernel.org/doc/html/latest/admin-guide/modules.html)
- [Module Management Guide](https://tldp.org/LDP/lkmpg/2.6/html/x44.html)
- [System Administration Guide](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/system_administrators_guide/ch-working_with_kernel_modules)

## Module Management
1. Loading modules
2. Removing modules
3. Dependency tracking
4. Parameter setting
5. Blacklisting

## Best Practices
1. Regular module checks
2. Document dependencies
3. Monitor module size
4. Check module parameters
5. Maintain security
