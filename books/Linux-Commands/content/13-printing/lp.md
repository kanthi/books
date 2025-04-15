# lp

## Overview
The `lp` command submits files for printing or alters a pending job. It's part of the CUPS (Common Unix Printing System) and is used to print files and manage print jobs.

## Syntax
```bash
lp [options] [file(s)]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-d printer` | Specify destination printer |
| `-n number` | Number of copies |
| `-q priority` | Job priority (1-100) |
| `-o option` | Set job options |
| `-P page-list` | Print specific pages |
| `-H hold` | Hold job for printing |
| `-t title` | Set job title |
| `-U username` | Specify username |
| `-i job-id` | Modify existing job |

## Key Use Cases
1. Print files
2. Manage print jobs
3. Set print options
4. Control print queue
5. Print specific pages

## Examples with Explanations
### Example 1: Basic Printing
```bash
lp document.pdf
```
Print document to default printer

### Example 2: Multiple Copies
```bash
lp -n 3 document.txt
```
Print three copies of the document

### Example 3: Specific Printer
```bash
lp -d printer_name file.pdf
```
Print to specified printer

## Understanding Output
Standard output includes:
- Job ID
- Printer name
- Status messages
- Error messages
- Queue position

## Common Usage Patterns
1. Print with options:
   ```bash
   lp -o sides=two-sided document.pdf
   ```
2. Print specific pages:
   ```bash
   lp -P 1-5 document.pdf
   ```
3. Hold print job:
   ```bash
   lp -H hold document.pdf
   ```

## Performance Analysis
- Monitor queue status
- Check printer availability
- Consider file size
- Watch for errors
- Monitor job progress

## Related Commands
- `lpstat` - Print system status
- `lpq` - Show print queue
- `lprm` - Remove print jobs
- `cancel` - Cancel print jobs
- `cupsenable` - Enable printer

## Additional Resources
- [CUPS Documentation](https://www.cups.org/documentation.html)
- [Linux Printing HOWTO](https://www.tldp.org/HOWTO/Printing-HOWTO/)
- [CUPS User Manual](https://www.cups.org/doc/user.html)
