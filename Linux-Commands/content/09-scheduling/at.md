# at

## Overview
The `at` command executes commands at a specified time. It's used for one-time task scheduling, unlike cron which handles recurring tasks.

## Syntax
```bash
at [-V] [-q queue] [-f file] [-mldbv] TIME
```

## Common Options
| Option | Description |
|--------|-------------|
| `-f file` | Read commands from file |
| `-m` | Send mail after execution |
| `-l` | List pending jobs (same as atq) |
| `-d` | Delete jobs (same as atrm) |
| `-v` | Show time of execution |
| `-q queue` | Use specified queue |
| `-b` | Batch mode (run when load permits) |
| `-V` | Show version |

## Time Specifications
| Format | Example | Description |
|--------|---------|-------------|
| HH:MM | 14:30 | Specific time |
| now + N units | now + 1 hour | Relative time |
| midnight | midnight | 00:00 tomorrow |
| noon | noon | 12:00 today |
| teatime | teatime | 16:00 today |

## Key Use Cases
1. Delayed execution
2. One-time tasks
3. Resource scheduling
4. Maintenance windows
5. Batch processing

## Examples with Explanations
### Example 1: Basic Usage
```bash
at 10:00 PM
command1
command2
