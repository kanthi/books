# lscpu

## Overview
The `lscpu` command displays detailed information about the CPU architecture, including processor type, cores, threads, cache sizes, and various CPU features.

## Syntax
```bash
lscpu [options]
```

## Common Options
| Option | Description |
|--------|-------------|
| `-a` | Include offline CPUs |
| `-b` | Online CPUs only |
| `-c` | Compatible format |
| `-e` | Extended readable format |
| `-p` | Parsable format |
| `-s directory` | Use specific sysfs directory |
| `-x` | Include hex and binary flags |
| `-y` | Show physical IDs |

## Key Information Displayed
| Field | Description |
|-------|-------------|
| Architecture | CPU architecture (x86_64, ARM, etc.) |
| CPU op-mode(s) | 32-bit, 64-bit |
| Byte Order | Little Endian, Big Endian |
| CPU(s) | Total number of logical CPUs |
| Thread(s) per core | Hyperthreading info |
| Core(s) per socket | Physical cores per CPU |
| Socket(s) | Number of CPU sockets |
| Model name | CPU brand and model |
| CPU MHz | Current frequency |
| CPU max MHz | Maximum frequency |
| CPU min MHz | Minimum frequency |
| Cache sizes | L1, L2, L3 cache information |

## Key Use Cases
1. System inventory
2. Performance analysis
3. Virtualization planning
4. Hardware compatibility checks
5. System monitoring setup

## Examples with Explanations
### Example 1: Basic CPU Information
```bash
lscpu
```
Shows complete CPU information in human-readable format

### Example 2: Parsable Format
```bash
lscpu -p
```
Outputs CPU information in comma-separated format for scripting

### Example 3: Extended Format
```bash
lscpu -e
```
Shows extended information including NUMA topology

## Understanding CPU Topology
Key relationships:
- **Socket**: Physical CPU package
- **Core**: Physical processing unit
- **Thread**: Logical processing unit (with hyperthreading)
- **NUMA Node**: Memory locality group

Calculation:
```
Total CPUs = Sockets × Cores per socket × Threads per core
```

## Common Usage Patterns
1. Check CPU count:
   ```bash
   lscpu | grep "CPU(s):"
   ```
2. Get CPU model:
   ```bash
   lscpu | grep "Model name"
   ```
3. Check virtualization support:
   ```bash
   lscpu | grep Virtualization
   ```

## Performance Analysis
Information useful for performance:
- Cache sizes (L1, L2, L3)
- CPU frequency ranges
- Thread/core ratios
- NUMA topology
- CPU flags and features

## Scripting Examples
1. Extract CPU count:
   ```bash
   CPU_COUNT=$(lscpu | grep "^CPU(s):" | awk '{print $2}')
   ```
2. Check architecture:
   ```bash
   ARCH=$(lscpu | grep "Architecture:" | awk '{print $2}')
   ```
3. Get CPU model:
   ```bash
   MODEL=$(lscpu | grep "Model name:" | cut -d':' -f2 | xargs)
   ```

## Parsable Output Format
Using `-p` option provides CSV-like output:
```
# CPU,Core,Socket,Node,,L1d,L1i,L2,L3
0,0,0,0,,32K,32K,256K,8192K
1,1,0,0,,32K,32K,256K,8192K
```

## Related Commands
- `cat /proc/cpuinfo` - Detailed CPU information
- `nproc` - Number of processing units
- `lshw -C cpu` - Hardware information
- `dmidecode -t processor` - BIOS CPU information
- `lstopo` - Hardware topology

## Additional Resources
- [lscpu Manual](https://man7.org/linux/man-pages/man1/lscpu.1.html)
- [CPU Information Guide](https://www.tecmint.com/lscpu-command-examples/)

## Best Practices
1. Use parsable format for scripts
2. Check virtualization capabilities
3. Monitor CPU frequency scaling
4. Understand NUMA topology for optimization
5. Verify CPU features for software requirements

## Virtualization Information
CPU virtualization features:
- **VT-x/AMD-V**: Hardware virtualization
- **VT-d/AMD-Vi**: I/O virtualization
- **EPT/NPT**: Extended/Nested page tables

Check support:
```bash
lscpu | grep -E "(vmx|svm)"
```

## NUMA Topology
For multi-socket systems:
```bash
lscpu | grep NUMA
```

Shows:
- NUMA node count
- CPU-to-node mapping
- Memory locality information

## CPU Flags and Features
Important flags:
- **sse, sse2, sse3**: SIMD instructions
- **aes**: AES encryption support
- **avx, avx2**: Advanced vector extensions
- **rdrand**: Hardware random number generator

## Frequency Information
Modern CPUs show:
- Base frequency
- Maximum turbo frequency
- Current frequency
- Scaling governor information

## Integration Examples
1. System monitoring:
   ```bash
   echo "CPU: $(lscpu | grep 'Model name' | cut -d':' -f2 | xargs)"
   ```
2. Performance tuning:
   ```bash
   CORES=$(lscpu | grep "Core(s) per socket" | awk '{print $4}')
   make -j$CORES
   ```
3. Capacity planning:
   ```bash
   lscpu -p | grep -v "^#" | wc -l
   ```

## Troubleshooting
1. Missing CPU information
2. Incorrect core counts
3. Frequency scaling issues
4. Virtualization detection problems
5. NUMA topology confusion

## Output Filtering
1. Get specific information:
   ```bash
   lscpu | grep -i cache
   ```
2. Extract numeric values:
   ```bash
   lscpu | grep "CPU(s):" | grep -o '[0-9]*'
   ```
3. Format for reports:
   ```bash
   lscpu | grep -E "(Architecture|CPU\(s\)|Model name)"
   ```