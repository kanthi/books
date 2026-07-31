# unzip

## Overview
The `unzip` command extracts files from ZIP archives. It's the counterpart to `zip` and provides various options for extraction, testing, and listing archive contents.

## Syntax
```bash
unzip [options] archive.zip [file(s)] [-x excluded_files] [-d extract_dir]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-l` | List archive contents |
| `-t` | Test archive integrity |
| `-d dir` | Extract to directory |
| `-j` | Junk paths (flatten directory structure) |
| `-o` | Overwrite files without prompting |
| `-n` | Never overwrite existing files |
| `-u` | Update files (extract if newer) |
| `-f` | Freshen existing files only |
| `-v` | Verbose listing |
| `-q` | Quiet mode |
| `-x files` | Exclude specified files |
| `-p` | Extract to pipe (stdout) |

## Key Use Cases
1. Extract ZIP archives
2. List archive contents
3. Test archive integrity
4. Selective file extraction
5. Archive maintenance

## Examples with Explanations
### Example 1: Basic Extraction
```bash
unzip archive.zip
```
Extracts all files to current directory

### Example 2: Extract to Directory
```bash
unzip archive.zip -d /target/directory/
```
Extracts files to specified directory

### Example 3: List Contents
```bash
unzip -l archive.zip
```
Lists files in archive without extracting

### Example 4: Test Archive
```bash
unzip -t archive.zip
```
Tests archive integrity without extracting

## Selective Extraction
1. Extract specific files:
   ```bash
   unzip archive.zip file1.txt file2.txt
   ```
2. Extract by pattern:
   ```bash
   unzip archive.zip "*.txt"
   ```
3. Exclude files:
   ```bash
   unzip archive.zip -x "*.tmp" "temp/*"
   ```

## Advanced Options
| Option | Description |
|--------|-------------|
| `-C` | Match filenames case-insensitively |
| `-L` | Convert filenames to lowercase |
| `-a` | Auto-convert text files |
| `-b` | Treat all files as binary |
| `-M` | Pipe through more |
| `-z` | Display archive comment |
| `-Z` | Display zipinfo-style listing |

## Common Usage Patterns
1. Safe extraction:
   ```bash
   unzip -n archive.zip
   ```
2. Overwrite all:
   ```bash
   unzip -o archive.zip
   ```
3. Flatten directory structure:
   ```bash
   unzip -j archive.zip
   ```

## Archive Information
1. Detailed listing:
   ```bash
   unzip -v archive.zip
   ```
2. Archive comment:
   ```bash
   unzip -z archive.zip
   ```
3. Technical info:
   ```bash
   unzip -Z archive.zip
   ```

## Performance Analysis
- Fast extraction for most archives
- Memory usage depends on compression method
- Good for moderate-sized archives
- Handles password-protected archives
- Efficient selective extraction

## Related Commands
- `zip` - Create ZIP archives
- `tar` - Unix archiving
- `7z` - 7-Zip format
- `rar` - RAR archives
- `gunzip` - GNU zip decompression

## Best Practices
1. Test archives before extraction
2. Use appropriate extraction directory
3. Check available disk space
4. Verify file permissions after extraction
5. Handle filename conflicts appropriately

## Security Considerations
1. Zip bomb protection:
   ```bash
   unzip -l archive.zip | awk '{sum+=$1} END {if(sum>1000000000) print "Large archive warning"}'
   ```
2. Path traversal protection:
   ```bash
   unzip -j archive.zip  # Flatten paths
   ```
3. Verify archive source
4. Check extracted file permissions
5. Scan for malicious content

## Password-Protected Archives
1. Extract with password:
   ```bash
   unzip -P password archive.zip
   ```
2. Prompt for password:
   ```bash
   unzip archive.zip
   # Will prompt if password needed
   ```

## Integration Examples
1. Automated extraction:
   ```bash
   for archive in *.zip; do
       unzip -q "$archive" -d "${archive%.zip}"
   done
   ```
2. Backup restoration:
   ```bash
   unzip -o backup.zip -d /restore/location/
   ```
3. Selective processing:
   ```bash
   unzip -p archive.zip "*.txt" | grep "pattern"
   ```

## Error Handling
1. Check extraction success:
   ```bash
   if unzip -t archive.zip > /dev/null 2>&1; then
       unzip archive.zip
   else
       echo "Archive is corrupted"
   fi
   ```
2. Handle missing files:
   ```bash
   unzip archive.zip 2>/dev/null || echo "Extraction failed"
   ```

## Scripting Applications
1. Batch extraction:
   ```bash
   #!/bin/bash
   for zip_file in *.zip; do
       echo "Extracting $zip_file"
       unzip -q "$zip_file" -d "${zip_file%.zip}"
   done
   ```
2. Archive validation:
   ```bash
   validate_archive() {
       local archive="$1"
       if unzip -t "$archive" >/dev/null 2>&1; then
           echo "Valid: $archive"
           return 0
       else
           echo "Invalid: $archive"
           return 1
       fi
   }
   ```

## Troubleshooting
1. Corrupted archives
2. Insufficient disk space
3. Permission issues
4. Filename encoding problems
5. Path length limitations

## Output Formats
1. Simple list:
   ```bash
   unzip -l archive.zip | tail -n +4 | head -n -2
   ```
2. Size information:
   ```bash
   unzip -l archive.zip | grep -E "^\s*[0-9]"
   ```
3. Date sorting:
   ```bash
   unzip -v archive.zip | sort -k7,8
   ```