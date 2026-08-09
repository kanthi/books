---
title: "nmap"
---

## Command Overview

The `nmap` (Network Mapper) is a powerful open-source tool for network exploration, security scanning, and auditing. It can discover hosts and services on a network, detect operating systems, and identify potential vulnerabilities.

## Syntax

```bash
nmap [Scan Type] [Options] {target specification}
```

## Common Options

| Option | Description |
|--------|-------------|
| `-sS` | TCP SYN scan (default) |
| `-sT` | TCP connect scan |
| `-sU` | UDP scan |
| `-sN` | TCP NULL scan |
| `-sF` | TCP FIN scan |
| `-sX` | TCP XMAS scan |
| `-sA` | TCP ACK scan |
| `-sW` | TCP Window scan |
| `-sM` | TCP Maimon scan |
| `-sn` | Ping scan (disable port scan) |
| `-Pn` | Skip host discovery |
| `-p` | Port specification |
| `-F` | Fast scan (100 ports) |
| `-r` | Scan ports consecutively |
| `-T<0-5>` | Timing template |
| `-sV` | Version detection |
| `-O` | OS detection |
| `-A` | Enable OS detection, version detection, script scanning, and traceroute |
| `-oN` | Output normal format |
| `-oX` | Output XML format |
| `-oG` | Output grepable format |
| `-v` | Increase verbosity |
| `-d` | Increase debugging |
| `--script` | NSE script selection |
| `--script-args` | NSE script arguments |

## Key Use Cases

1. Network discovery
2. Port scanning
3. Service version detection
4. Operating system detection
5. Vulnerability assessment
6. Security auditing
7. Network inventory
8. Performance analysis

## Examples with Explanations

### 1. Basic Scan
```bash
$ nmap 192.168.1.0/24
Starting Nmap 7.94 ( https://nmap.org )
Nmap scan report for 192.168.1.1
Host is up (0.0020s latency).
Not shown: 995 closed ports
PORT    STATE SERVICE
22/tcp  open  ssh
80/tcp  open  http
443/tcp open  https
```
Scan entire subnet for open ports

### 2. Intensive Scan
```bash
$ nmap -A -T4 example.com
```
Aggressive scan with OS and version detection

### 3. Stealth Scan
```bash
$ sudo nmap -sS -p- example.com
```
SYN scan of all ports

### 4. Service Version Detection
```bash
$ nmap -sV -p 22,80,443 example.com
```
Detect service versions on specific ports

### 5. OS Detection
```bash
$ sudo nmap -O example.com
```
Identify operating system

## Understanding Nmap

### Scan Types
```bash
# TCP SYN Scan (Stealth)
$ sudo nmap -sS target

# TCP Connect Scan
$ nmap -sT target

# UDP Scan
$ sudo nmap -sU target

# SCTP INIT Scan
$ sudo nmap -sY target

# FIN Scan
$ sudo nmap -sF target
```

### Port Selection
```bash
# Specific ports
$ nmap -p 80,443 target

# Port ranges
$ nmap -p 1-1000 target

# All ports
$ nmap -p- target

# Top ports
$ nmap --top-ports 100 target

# Fast scan
$ nmap -F target
```

### Host Discovery
```bash
# Ping scan only
$ nmap -sn 192.168.1.0/24

# Skip ping
$ nmap -Pn target

# TCP SYN ping
$ nmap -PS22,80,443 target

# TCP ACK ping
$ nmap -PA22,80,443 target

# UDP ping
$ nmap -PU53 target
```

### Version Detection
```bash
# Light version detection
$ nmap -sV --version-intensity 5 target

# Aggressive version detection
$ nmap -sV --version-all target

# With script scanning
$ nmap -sV -sC target
```

### Script Scanning
```bash
# Default scripts
$ nmap -sC target

# Specific script
$ nmap --script=http-title target

# Script category
$ nmap --script=vuln target

# Multiple scripts
$ nmap --script=http-*,ssl-* target

# Script with arguments
$ nmap --script http-brute --script-args http-brute.path=/login target
```

### Output Formats
```bash
# Normal output
$ nmap -oN scan.txt target

# XML output
$ nmap -oX scan.xml target

# Grepable output
$ nmap -oG scan.grep target

# All formats
$ nmap -oA scan target
```

### Performance Tuning
```bash
# Timing templates
$ nmap -T0 target  # Paranoid
$ nmap -T1 target  # Sneaky
$ nmap -T2 target  # Polite
$ nmap -T3 target  # Normal
$ nmap -T4 target  # Aggressive
$ nmap -T5 target  # Insane

# Custom timing
$ nmap --min-rate 100 --max-rate 500 target
```

### Advanced Techniques
```bash
# Fragmented packets
$ sudo nmap -f target

# Custom MTU
$ sudo nmap --mtu 24 target

# Decoy scan
$ sudo nmap -D decoy1,decoy2,ME target

# Idle scan
$ sudo nmap -sI zombie_host target

# Source port manipulation
$ sudo nmap --source-port 53 target
```

### Firewall Evasion
```bash
# Fragment packets
$ sudo nmap -f target

# Use decoy
$ sudo nmap -D RND:10 target

# Spoof MAC
$ sudo nmap --spoof-mac Dell target

# Data length
$ sudo nmap --data-length 25 target
```

### NSE Scripts Examples
```bash
# SSL/TLS scanning
$ nmap --script ssl-enum-ciphers -p 443 target

# Vulnerability scanning
$ nmap --script vuln target

# Brute force
$ nmap --script brute target

# Default credential check
$ nmap --script http-default-accounts target

# DNS enumeration
$ nmap --script dns-brute target
```

### Best Practices
```bash
# Network inventory
$ nmap -sn -oX inventory.xml 192.168.1.0/24

# Security audit
$ sudo nmap -A -v -oA audit target

# Regular monitoring
$ nmap -sS -sV --open -oG monitor target

# Vulnerability assessment
$ nmap --script vuln -sV -p- target
```

## Related Commands

- `netcat` - Network utility
- `tcpdump` - Packet analyzer
- `wireshark` - Network protocol analyzer
- `hping3` - Network tool
- `masscan` - Mass IP port scanner

## Additional Resources

- Man page: `man nmap`
- Nmap reference guide
- NSE script documentation
- Network scanning guide
- Security best practices
- Port scanning techniques