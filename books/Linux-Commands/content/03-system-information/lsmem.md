# lsmem

## Overview
The `lsmem` command displays information about memory ranges and their online/offline status. It's particularly useful for systems with memory hotplug capabilities and NUMA architectures.

## Syntax
```bash
lsmem [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | List all memory ranges |
| `-b` | Show output in bytes |
| `-h` | Human-readable sizes |
| `-o columns` | Specify output columns |
| `-r` | Raw output format |
| `-S` | Split by node |
| `-s` | Show summary only |
| `--sysroot=dir` | Use alternative sysfs root |

## Output Columns
| Column | Description |
|--------|-------------|
| RANGE | Memory address range |
| SIZE | Size of memory range |
| STATE | Online/Offline status |
| REMOVABLE | Whether memory can be removed |
| BLOCK | Memory block number |
| NODE | NUMA node number |
| ZONES | Memory zones |

## Key Use Cases
1. Memory inventory
2. NUMA topology analysis
3. Memory hotplug management
4. System capacity planning
5. Memory troubleshooting

## Examples with Explanations
### Example 1: Basic Memory Information
```bash
lsmem
```
Shows memory ranges and their status

### Example 2: Human-Readable Sizes
```bash
lsmem -h
```
Displays memory sizes in human-readable format (KB, MB, GB)

### Example 3: Summary Only
```bash
lsmem -s
```
Shows only summary information

## Understanding Memory States
| State | Description |
|-------|-------------|
| online | Memory is available for use |
| offline | Memory is not available |
| going-offline | Memory is being taken offline |
| going-online | Memory is being brought online |

## Memory Block Management
Memory is managed in blocks:
- Block size typically 128MB or 256MB
- Blocks can be individually onlined/offlined
- Useful for memory hotplug operations

## Common Usage Patterns
1. Check total memory:
   ```bash
   lsmem -s | grep "Total online memory"
   ```
2. List offline memory:
   ```bash
   lsmem | grep offline
   ```
3. Show NUMA distribution:
   ```bash
   lsmem -S
   ```

## NUMA Memory Information
For NUMA systems:
- Shows memory distribution across nodes
- Helps with memory locality optimization
- Useful for performance tuning

## Memory Hotplug Operations
1. Check removable memory:
   ```bash
   lsmem | grep "yes" | grep "REMOVABLE"
   ```
2. Find offline blocks:
   ```bash
   lsmem -a | awk '$3=="offline" {print $4}'
   ```

## Performance Analysis
Memory information useful for:
- Memory bandwidth optimization
- NUMA-aware application tuning
- Memory pressure analysis
- Capacity planning

## Related Commands
- `free` - Memory usage statistics
- `cat /proc/meminfo` - Detailed memory information
- `numactl --hardware` - NUMA topology
- `dmidecode -t memory` - Physical memory information
- `lshw -C memory` - Hardware memory details

## Additional Resources
- [lsmem Manual](https://man7.org/linux/man-pages/man1/lsmem.1.html)
- [Memory Management Guide](https://www.kernel.org/doc/html/latest/admin-guide/mm/memory-hotplug.html)

## Best Practices
1. Monitor memory hotplug status
2. Understand NUMA topology
3. Check removable memory before maintenance
4. Use with other memory analysis tools
5. Consider memory block alignment

## Scripting Examples
1. Count online memory blocks:
   ```bash
   lsmem | grep -c "online"
   ```
2. Get total memory size:
   ```bash
   lsmem -s | grep "Total online memory" | awk '{print $4}'
   ```
3. Check NUMA nodes:
   ```bash
   lsmem -o NODE | grep -v NODE | sort -u
   ```

## Memory Zones
Common memory zones:
- **DMA**: Direct Memory Access zone
- **DMA32**: 32-bit DMA zone
- **Normal**: Regular memory zone
- **HighMem**: High memory zone (32-bit systems)
- **Movable**: Memory that can be migrated

## System Integration
1. Memory monitoring:
   ```bash
   watch -n 5 'lsmem -s'
   ```
2. NUMA optimization:
   ```bash
   lsmem -S | grep "node 0"
   ```
3. Capacity reporting:
   ```bash
   echo "Total Memory: $(lsmem -s | grep 'Total online' | awk '{print $4}')"
   ```

## Troubleshooting
1. Memory not showing up
2. Offline memory blocks
3. NUMA node misalignment
4. Memory hotplug failures
5. Inconsistent memory reporting

## Advanced Usage
1. Custom column output:
   ```bash
   lsmem -o RANGE,SIZE,STATE,NODE
   ```
2. Raw format for parsing:
   ```bash
   lsmem -r
   ```
3. Alternative sysfs root:
   ```bash
   lsmem --sysroot=/alternative/path
   ```

## Memory Block Operations
To manage memory blocks (requires root):
```bash
# Online a memory block
echo online > /sys/devices/system/memory/memory64/state

# Offline a memory block
echo offline > /sys/devices/system/memory/memory64/state
```

## Integration Examples
1. With NUMA tools:
   ```bash
   lsmem -S && numactl --hardware
   ```
2. Memory pressure monitoring:
   ```bash
   lsmem -s && free -h
   ```
3. System inventory:
   ```bash
   echo "Memory Layout:" && lsmem -h
   ```

## Output Formatting
1. Specific columns:
   ```bash
   lsmem -o SIZE,STATE | column -t
   ```
2. Summary with details:
   ```bash
   lsmem -s && echo "---" && lsmem
   ```
3. Node-specific information:
   ```bash
   lsmem | awk '$6==0 {print}'  # Node 0 only
   ```