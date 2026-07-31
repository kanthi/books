# perf

## Overview
`perf` is the primary performance analysis tool for Linux. It taps into hardware performance counters and kernel tracepoints to profile CPU usage, memory access patterns, and kernel function calls.

## Syntax
```bash
perf [subcommand] [options]
```

## Common Subcommands
| Subcommand | Description |
|------------|-------------|
| `stat` | Collect performance counter statistics for a command |
| `record` | Run a command and record profiling data into `perf.data` |
| `report` | Read `perf.data` and display the performance profile summary |
| `top` | System-wide interactive profiling (similar to `top`, but for functions) |

## Key Use Cases
1. Identifying CPU bottleneck functions in software binaries.
2. Measuring cache misses and instruction counts.
3. System-wide kernel and user-space profiling.

## Examples with Explanations
### Example 1: Measuring Execution Counters
```bash
perf stat ./my_program
```
Executes `./my_program` and reports CPU cycles, instructions, context switches, and cache misses.

### Example 2: Interactive Real-time Function Profiling
```bash
perf top
```
Displays system-wide CPU consumption broken down by kernel and application function symbols.

## Related Commands
- `strace` - Trace system calls and signals
- `top` - Monitor running processes
