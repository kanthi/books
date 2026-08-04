# Vi: The Original Visual Editor

Vi (Visual Interface) is the original screen-oriented text editor for Unix systems. Created by Bill Joy in 1976, it remains one of the most fundamental and ubiquitous editors in the Unix/Linux world.

## Why Learn Vi?

- **Universal availability**: Found on every Linux distribution and Unix system
- **Minimal resource usage**: Works even on minimal Linux installations and embedded systems
- **Foundation knowledge**: Understanding vi helps with vim, neovim, and other vi-like editors
- **Emergency situations**: Often the only editor available in Linux rescue modes and single-user mode
- **System administration**: Essential for Linux server management and configuration
- **POSIX compliance**: Standardized behavior across Linux distributions

## Vi Modes

Vi operates in different modes, which is its defining characteristic:

### 1. Command Mode (Normal Mode)
- Default mode when vi starts
- Used for navigation and text manipulation commands
- Press `Esc` to return to this mode

### 2. Insert Mode
- Used for typing text
- Enter with `i`, `a`, `o`, or other insert commands
- Exit with `Esc`

### 3. Command-Line Mode
- Used for file operations and advanced commands
- Enter with `:` from command mode
- Execute with `Enter`

## Basic Operations

### Starting Vi

```bash
# Open new file
vi filename.txt

# Open existing file
vi /path/to/file.txt

# Open file at specific line
vi +25 filename.txt

# Open file at first occurrence of pattern
vi +/pattern filename.txt

# Open multiple files
vi file1.txt file2.txt file3.txt
```

### Exiting Vi

```bash
# Save and quit
:wq

# Quit without saving
:q!

# Save file
:w

# Save as new filename
:w newfilename.txt

# Quit (only if no changes)
:q
```

## Navigation Commands

### Basic Movement

```bash
# Character movement
h    # Move left
j    # Move down
k    # Move up
l    # Move right

# Word movement
w    # Move to beginning of next word
b    # Move to beginning of previous word
e    # Move to end of current word

# Line movement
0    # Move to beginning of line
^    # Move to first non-blank character
$    # Move to end of line

# Screen movement
H    # Move to top of screen
M    # Move to middle of screen
L    # Move to bottom of screen
```

### Advanced Navigation

```bash
# Page movement
Ctrl+f   # Page forward
Ctrl+b   # Page backward
Ctrl+d   # Half page down
Ctrl+u   # Half page up

# Line jumping
G        # Go to last line
1G       # Go to first line
25G      # Go to line 25
gg       # Go to first line (vim extension)

# Pattern searching
/pattern    # Search forward for pattern
?pattern    # Search backward for pattern
n           # Next search result
N           # Previous search result

# Character finding
fx       # Find next 'x' on current line
Fx       # Find previous 'x' on current line
tx       # Move to character before next 'x'
Tx       # Move to character after previous 'x'
;        # Repeat last f, F, t, or T command
,        # Repeat last f, F, t, or T command in reverse
```

## Text Editing Commands

### Inserting Text

```bash
i    # Insert before cursor
a    # Insert after cursor
I    # Insert at beginning of line
A    # Insert at end of line
o    # Open new line below current line
O    # Open new line above current line
```

### Deleting Text

```bash
x    # Delete character under cursor
X    # Delete character before cursor
dd   # Delete entire line
D    # Delete from cursor to end of line
dw   # Delete word
db   # Delete word backward
d$   # Delete to end of line
d0   # Delete to beginning of line
```

### Changing Text

```bash
r    # Replace single character
R    # Replace mode (overwrite)
cw   # Change word
cc   # Change entire line
C    # Change from cursor to end of line
s    # Substitute character
S    # Substitute line
```

### Copying and Pasting

```bash
yy   # Yank (copy) entire line
Y    # Yank entire line
yw   # Yank word
y$   # Yank to end of line
p    # Paste after cursor
P    # Paste before cursor
```

## Working with Multiple Files

```bash
# Open next file
:n

# Open previous file
:prev

# List all files
:args

# Edit new file
:e filename.txt

# Switch between files
:b filename
```

## Search and Replace

### Basic Search

```bash
# Search forward
/search_term

# Search backward
?search_term

# Case-sensitive search
/\Csearch_term

# Whole word search
/\<word\>
```

### Search and Replace

```bash
# Replace first occurrence on current line
:s/old/new/

# Replace all occurrences on current line
:s/old/new/g

# Replace all occurrences in file
:%s/old/new/g

# Replace with confirmation
:%s/old/new/gc

# Replace in specific line range
:1,10s/old/new/g
```

## Advanced Features

### Marks and Bookmarks

```bash
# Set mark 'a' at current position
ma

# Go to mark 'a'
'a

# Go to exact position of mark 'a'
`a

# List all marks
:marks
```

### Registers

```bash
# Yank to register 'a'
"ayy

# Paste from register 'a'
"ap

# View all registers
:reg
```

### Macros

```bash
# Start recording macro in register 'a'
qa

# Stop recording
q

# Execute macro 'a'
@a

# Execute macro 'a' 10 times
10@a
```

## Configuration

### Vi Configuration File (.exrc)

```bash
# ~/.exrc
set number          # Show line numbers
set autoindent      # Auto-indent new lines
set tabstop=4       # Set tab width
set shiftwidth=4    # Set indent width
set showmatch       # Show matching brackets
set ignorecase      # Ignore case in searches
set wrapscan        # Wrap searches around file
```

### Environment Variables

```bash
# Set default editor
export EDITOR=vi
export VISUAL=vi

# Set vi options
export EXINIT='set number autoindent tabstop=4'
```

## Real-World Scenarios

### Scenario 1: Emergency Linux System Recovery

```bash
# Linux system in single-user mode, only vi available
# Edit critical configuration file
vi /etc/fstab

# Navigate to problematic line causing boot failure
/UUID=bad-uuid

# Delete the problematic line
dd

# Save and exit
:wq

# Alternative: Fix systemd service file
vi /etc/systemd/system/problematic.service

# Comment out problematic line
I# <Esc>

# Save and exit
:wq

# Reload systemd and reboot
:!systemctl daemon-reload && reboot
```

### Scenario 2: Linux Log File Analysis

```bash
# Open systemd journal or log file
vi /var/log/syslog
# or
vi /var/log/systemd/journal.log

# Go to end of file to see recent entries
G

# Search backward for critical errors
?CRITICAL
?ERROR
?Failed

# Navigate through error occurrences
N    # Previous error
n    # Next error

# Copy error line for analysis
yy

# Open new file to save errors
:e /tmp/error_analysis.txt

# Paste error
p

# Add timestamp and system info
O
# Type analysis header
System: $(hostname) - $(date)
Error Analysis:
<Esc>

# Save and return to log
:w
:b syslog
```

### Scenario 3: Linux System Configuration

```bash
# Open multiple Linux configuration files
vi /etc/hosts /etc/resolv.conf /etc/hostname

# Edit first file (/etc/hosts)
# Add new host entry for local network
o
192.168.1.100    newserver.local
192.168.1.101    database.local
192.168.1.102    webserver.local

# Save and move to next file
:w
:n

# Edit resolv.conf for DNS configuration
# Change nameserver to Google DNS
/nameserver
cw
nameserver 8.8.8.8<Esc>
o
nameserver 8.8.4.4

# Save and move to next file
:w
:n

# Edit hostname for system identification
# Replace entire content
:%d
i
production-server

# Save all and exit
:wq

# Verify changes took effect
:!hostnamectl status
```

## Vi vs Modern Editors

### Advantages of Vi

- **Ubiquity**: Available everywhere
- **Speed**: Fast startup and operation
- **Keyboard-driven**: No mouse required
- **Powerful**: Complex operations with few keystrokes
- **Stable**: Unchanged interface for decades

### Limitations

- **Learning curve**: Modal editing is initially confusing
- **Limited features**: No syntax highlighting, plugins, etc.
- **No GUI**: Text-only interface
- **Basic functionality**: Lacks modern IDE features

## Tips and Best Practices

### Essential Tips

1. **Master the modes**: Understanding when you're in which mode is crucial
2. **Use Esc liberally**: When in doubt, press Esc to return to command mode
3. **Learn movement commands**: Efficient navigation is key to vi mastery
4. **Practice regularly**: Vi skills deteriorate without use
5. **Use :help**: Built-in help system is comprehensive

### Common Mistakes

1. **Typing in command mode**: Results in unintended commands
2. **Forgetting to save**: Always :w before :q
3. **Case sensitivity**: Commands are case-sensitive
4. **Not using counts**: Numbers multiply commands (5dd deletes 5 lines)

### Productivity Shortcuts

```bash
# Repeat last command
.

# Undo last change
u

# Join lines
J

# Change case
~

# Increment number
Ctrl+a

# Decrement number
Ctrl+x
```

## Troubleshooting

### Common Issues

1. **Can't exit vi**
   ```bash
   # Press Esc first, then
   :q!
   ```

2. **Accidentally in replace mode**
   ```bash
   # Press Esc to return to command mode
   Esc
   ```

3. **Lost changes**
   ```bash
   # Check for swap file
   :recover
   ```

4. **File is read-only**
   ```bash
   # Force write
   :w!
   # Or save as new file
   :w newfilename
   ```

### Recovery Options

```bash
# Recover from swap file
vi -r filename.txt

# List available swap files
vi -r

# Start vi in recovery mode
vi -r
```

Vi remains an essential skill for any Linux user or system administrator. While modern editors offer more features, vi's simplicity, universality, and efficiency make it invaluable for quick edits, system recovery, and situations where other editors aren't available.
## Next steps

- [Vim](../02-vim/index.md) — everyday improved vi
- [tmux](../11-tmux/index.md) — keep vi sessions alive over SSH
- [Choosing an Editor](../00-intro/01-choosing-an-editor.md) — when to graduate beyond vi
