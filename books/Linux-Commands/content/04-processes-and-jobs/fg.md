# fg

## Overview
The `fg` command brings background or suspended jobs to the foreground. It's essential for job control, allowing you to interact with processes that are running in the background or have been suspended.

## Syntax
```bash
fg [job_spec]
```

## Job Specification
| Format | Description |
|--------|-------------|
| `%n` | Job number n |
| `%string` | Job whose command begins with string |
| `%?string` | Job whose command contains string |
| `%%` or `%+` | Current job (default) |
| `%-` | Previous job |

## Key Use Cases
1. Bring background jobs to foreground
2. Resume suspended processes
3. Interactive job control
4. Process management
5. Terminal multitasking

## Examples with Explanations
### Example 1: Bring Current Job to Foreground
```bash
fg
```
Brings the most recent job to foreground

### Example 2: Bring Specific Job
```bash
fg %1
```
Brings job number 1 to foreground

### Example 3: Bring Job by Command Name
```bash
fg %vim
```
Brings the vim job to foreground

## Common Workflow
1. Start background job:
   ```bash
   long_command &
   [1] 12345
   ```
2. Bring to foreground:
   ```bash
   fg %1
   long_command
   ```
3. Or resume suspended job:
   ```bash
   # Job was suspended with Ctrl+Z
   fg %1
   ```

## Job Control Cycle
| State | Command | Next State |
|-------|---------|------------|
| Running (fg) | `Ctrl+Z` | Suspended |
| Suspended | `fg` | Running (fg) |
| Suspended | `bg` | Running (bg) |
| Running (bg) | `fg` | Running (fg) |

## Common Usage Patterns
1. Quick foreground switch:
   ```bash
   # List jobs
   jobs
   # Bring job to foreground
   fg %2
   ```
2. Toggle between jobs:
   ```bash
   fg %1  # Switch to job 1
   ^Z     # Suspend
   fg %2  # Switch to job 2
   ```
3. Resume by partial command:
   ```bash
   fg %?backup  # Resume job containing "backup"
   ```

## Advanced Usage
1. Bring job and check status:
   ```bash
   jobs -l  # List with PIDs
   fg %1    # Bring to foreground
   ```
2. Conditional foreground:
   ```bash
   if jobs | grep -q "editor"; then
       fg %editor
   fi
   ```

## Performance Analysis
- Instant operation
- No resource overhead
- Shell built-in command
- Efficient process control
- Real-time job switching

## Related Commands
- `bg` - Put job in background
- `jobs` - List active jobs
- `kill` - Terminate processes
- `ps` - Process status
- `disown` - Remove from job control

## Best Practices
1. Check job status before using fg
2. Use specific job identifiers
3. Understand job states
4. Monitor job completion
5. Handle job control signals properly

## Error Handling
1. Job not found:
   ```bash
   fg %99  # Error if job doesn't exist
   ```
2. No current job:
   ```bash
   fg  # Error if no jobs available
   ```
3. Job already in foreground:
   ```bash
   fg %1  # No effect if already foreground
   ```

## Interactive Examples
1. Editor workflow:
   ```bash
   vim file.txt    # Start editor
   ^Z              # Suspend (Ctrl+Z)
   ls -la          # Do other work
   fg              # Resume editor
   ```
2. Compilation workflow:
   ```bash
   make &          # Start build in background
   vim source.c    # Edit while building
   ^Z              # Suspend editor
   fg %make        # Check build progress
   ```

## Scripting Applications
1. Job management function:
   ```bash
   resume_job() {
       local job_pattern="$1"
       if jobs | grep -q "$job_pattern"; then
           fg %"$job_pattern"
       else
           echo "Job not found: $job_pattern"
       fi
   }
   ```
2. Interactive job selector:
   ```bash
   select_job() {
       echo "Available jobs:"
       jobs
       read -p "Which job to foreground? " job_num
       fg %"$job_num"
   }
   ```

## Integration Examples
1. With job monitoring:
   ```bash
   # Monitor and manage jobs
   while true; do
       jobs
       read -p "Foreground job (or 'q' to quit): " choice
       case $choice in
           q) break ;;
           *) fg %"$choice" ;;
       esac
   done
   ```
2. Development environment:
   ```bash
   # Start development tools
   code . &           # Editor in background
   npm run dev &      # Dev server in background

   # Work with tools interactively
   fg %code          # Switch to editor
   ^Z                # Suspend
   fg %npm           # Check dev server
   ```

## Signal Handling
When bringing job to foreground:
- Job receives SIGCONT if suspended
- Terminal control is transferred
- Job can receive keyboard signals
- Ctrl+C sends SIGINT to foreground job
- Ctrl+Z sends SIGTSTP to suspend job

## Shell Compatibility
| Shell | Support | Features |
|-------|---------|----------|
| Bash | Full | Complete job control |
| Zsh | Enhanced | Advanced job management |
| Fish | Modern | User-friendly syntax |
| Dash | Basic | Limited job control |

## Troubleshooting
1. Job control disabled:
   ```bash
   set +m  # Disable job control
   set -m  # Enable job control
   ```
2. No controlling terminal
3. Job has exited
4. Permission issues
5. Shell doesn't support job control

## Security Considerations
1. Verify job ownership
2. Check process legitimacy
3. Monitor resource usage
4. Validate job commands
5. Control process privileges

## Alternative Methods
1. Direct process control:
   ```bash
   kill -CONT $PID  # Resume process
   ```
2. Screen/tmux sessions:
   ```bash
   screen -r session_name
   tmux attach -t session_name
   ```
3. Process substitution:
   ```bash
   command < <(background_process)
   ```

## Real-world Scenarios
1. System administration:
   ```bash
   # Start system monitor
   htop &
   # Do other work
   ps aux | grep problem_process
   # Return to monitor
   fg %htop
   ```
2. Development debugging:
   ```bash
   # Start debugger
   gdb program &
   # Edit source
   vim source.c
   ^Z
   # Return to debugger
   fg %gdb
   ```

## Job State Transitions
```
[Start] → Running(fg) → [Ctrl+Z] → Suspended
   ↓           ↑                        ↓
   &          fg                       bg
   ↓           ↑                        ↓
Running(bg) ←─────────────────── Running(bg)
```

## Monitoring and Control
1. Job status checking:
   ```bash
   jobs -l | grep Stopped
   fg %1  # Resume stopped job
   ```
2. Resource monitoring:
   ```bash
   # Before bringing to foreground
   ps -p $(jobs -p %1) -o pid,pcpu,pmem,cmd
   fg %1
   ```