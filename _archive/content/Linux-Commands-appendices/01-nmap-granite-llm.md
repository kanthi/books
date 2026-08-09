# Nmap Command Template

## Command Overview
Nmap (Network Mapper) is a versatile tool used for network exploration, security auditing, and management. This template outlines common nmap commands to help you understand their purpose, syntax, and usage.

## Syntax
```bash
nmap [options] <target>
```

## Common Options
| Option | Description |
| --- | --- |
| -sS (TCP SYN Scan) | Stealth scan using TCP SYN packets.
| -sV (Version Detection) | Attempt to determine the target's software version.
| -p-<port-range> (Target Port Specifications) | Specify target ports for scanning.
| -O (OS Detection) | Enable OS detection heuristics.
| -A (Aggressive Scan) | Enable OS detection, version detection, script scanning, and traceroute.
| -T<timing template> (Timing Template) | Set timing options to adjust the speed of the scan.
| -oN, -oX, -oG, -oxml (Output Formats) | Save output in various formats: normal, XML, grepable, or XML respectively.

## Key Use Cases
1. Network mapping and discovery.
2. Port scanning to identify open ports on target hosts.
3. OS detection and service version enumeration.
4. Vulnerability assessment using Nmap scripts (nSE/nmap).
5. Performance monitoring and analysis of network devices.

## Examples with Explanations
1. **Basic TCP SYN Scan**
   ```bash
   nmap -sS 192.168.1.100
   ```
   This command scans the target host (192.168.1.100) using TCP SYN packets to identify open ports without completing the three-way handshake, thus reducing detection risk.

2. **OS Detection and Version Scan**
   ```bash
   nmap -O -sV 192.168.1.50
   ```
   This command combines OS detection (-O) with version detection (-sV) to determine the target's operating system and service versions running on open ports.

3. **Service Detection by Port**
   ```bash
   nmap -p- 192.168.1.75
   ```
   This command scans all 65,535 TCP ports on the specified host (192.168.1.75) to identify services running on open ports.

## Understanding Output
Nmap output typically includes:
- Open ports and their corresponding service names/versions.
- OS detection information (if enabled).
- Scan statistics, such as total time taken, number of hosts scanned, and host types identified.

## Common Usage Patterns
1. **Quick port scan**
   ```bash
   nmap -p 20-80 <target>
   ```
   Scans only specified ports (20 to 80) for faster results.

2. **Fast scan with minimal output**
   ```bash
   nmap -F 192.168.1.10
   ```
   Utilizes Nmap's "fast" mode to scan a predefined set of common ports more efficiently.

3. **Script-based vulnerability assessment**
   ```bash
   nmap --script vuln <target>
   ```
   Executes NSE scripts to detect potential vulnerabilities on the target host(s).

## Performance Analysis
1. Adjust timing templates using `-T<timing template>` for balance between scan speed and stealthiness, e.g., `-T4` for a good compromise.
2. Use parallel port scanning with `-Pn` (no ping) to reduce scan time when targeting likely reachable hosts.

## Related Commands
- **Netstat**: Display network statistics and current TCP/UDP connections (`netstat -tuln`).
- **TCPDump**: Capture and analyze network traffic in real-time (`tcpdump -i <interface>`).
- **Wireshark**: Graphical tool for analyzing captured network packets.

## Additional Resources
- [Nmap Official Documentation](https://nmap.org/book/man-experimental.html)
- [Nmap Cheat Sheet](https://resources.oreilly.com/files/?id=1036)