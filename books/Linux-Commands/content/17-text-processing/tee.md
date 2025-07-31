# tee

## Overview
The `tee` command reads from standard input and writes to both standard output and files simultaneously. It's like a T-junction for data streams.

## Syntax
```bash
tee [options] [file...]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Append to files |
| `-i` | Ignore interrupt signals |
| `-p` | Diagnose errors writing to pipes |

## Key Use Cases
1. Save command output while viewing
2. Log pipeline data
3. Duplicate data streams
4. Debug pipeline operations
5. Create multiple output files

## Examples with Explanations
### Example 1: Basic Usage
```bash
ls -la | tee file_list.txt
```
Shows directory listing and saves to file

### Example 2: Append Mode
```bash
date | tee -a log.txt
```
Adds timestamp to log file while displaying

### Example 3: Multiple Files
```bash
ps aux | tee process1.txt process2.txt
```
Saves process list to multiple files

## Common Usage Patterns
1. Log command output:
   ```bash
   make 2>&1 | tee build.log
   ```
2. Monitor and save:
   ```bash
   tail -f /var/log/syslog | tee current.log
   ```
3. Pipeline debugging:
   ```bash
   cat data.txt | process1 | tee intermediate.txt | process2
   ```

## Advanced Usage
1. Ignore interrupts:
   ```bash
   long_command | tee -i output.log
   ```
2. Append to multiple files:
   ```bash
   echo "data" | tee -a log1.txt log2.txt log3.txt
   ```
3. Combine with sudo:
   ```bash
   echo "config" | sudo tee /etc/config.conf
   ```

## Performance Analysis
- Minimal overhead
- Efficient for data duplication
- Good for pipeline operations
- Handles large data streams well
- Low memory usage

## Related Commands
- `split` - Split files
- `cat` - Concatenate files
- `dd` - Data duplicator
- `pv` - Pipe viewer
- `logger` - System logger

## Best Practices
1. Use for important command logging
2. Combine with error redirection
3. Consider append vs overwrite
4. Use with sudo for privileged writes
5. Monitor disk space when logging

## Integration Examples
1. Build logging:
   ```bash
   ./configure && make 2>&1 | tee build.log
   ```
2. System monitoring:
   ```bash
   vmstat 1 | tee -a system_stats.log
   ```
3. Backup with logging:
   ```bash
   rsync -av /data/ /backup/ | tee backup.log
   ```

## Sudo Integration
Write to protected files:
```bash
echo "new config" | sudo tee /etc/protected.conf > /dev/null
```

## Pipeline Debugging
Insert tee to inspect data:
```bash
cat input.txt |
  process1 |
  tee debug1.txt |
  process2 |
  tee debug2.txt |
  process3 > output.txt
```

## Error Handling
Capture both stdout and stderr:
```bash
command 2>&1 | tee output.log
```

## Scripting Applications
1. Dual logging:
   ```bash
   exec > >(tee -a script.log)
   exec 2>&1
   ```
2. Progress monitoring:
   ```bash
   long_process | tee >(wc -l > progress.txt)
   ```