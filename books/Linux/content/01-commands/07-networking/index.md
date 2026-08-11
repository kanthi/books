---
title: Intro
---

# Intro

Configure and diagnose connectivity: addresses and routes (`ip`), sockets (`ss`), DNS, HTTP clients, SSH/file transfer, firewalls, and packet capture. Prefer modern tools (`ip`/`ss`/`nft`) over legacy ones.

## Commands in this part

| Command | Role |
|---------|------|
| `ip` | ip (from iproute2) configures and displays interfaces, addresses, routes, neighbors, rules, and tunnels. |
| `ss` | ss (socket statistics) inspects TCP/UDP/UNIX sockets. |
| `ping` | ping sends ICMP Echo Request packets and reports whether a host answers with Echo Reply, plus round-trip time (RTT). |
| `traceroute` | traceroute maps the path packets take toward a destination by sending probes with increasing TTL and reading ICMP… |
| `mtr` | mtr (My Traceroute) combines continuous ping and traceroute: it probes each hop on the path and updates loss and… |
| `dig` | dig (Domain Information Groper) queries DNS servers and prints detailed answers. |
| `host` | host is a simple DNS lookup utility from BIND tools. |
| `nslookup` | nslookup queries DNS name servers interactively or non-interactively. |
| `doggo` | doggo is a modern command-line DNS client with colorful, human-friendly output. |
| `resolvectl` | resolvectl manages and queries systemd-resolved: DNS servers, search/route domains, LLMNR/mDNS, DNSSEC/DoT status,… |
| `curl` | curl transfers data to/from URLs. |
| `wget` | wget is a non-interactive downloader for HTTP(S), FTP, and related protocols. |
| `ssh` | ssh (OpenSSH client) creates encrypted sessions to a remote host for shell access, command execution, port… |
| `scp` | scp (secure copy) copies files to or from a remote host over SSH. |
| `rsync` | rsync synchronizes files and directories locally or over a remote shell (almost always SSH). |
| `nc` | nc (netcat) is a Swiss-army TCP/UDP tool: open connections, listen for inbound sockets, scan ports simply, and pipe… |
| `tcpdump` | tcpdump captures and displays packets on a network interface. |
| `nmap` | The nmap (Network Mapper) is a powerful open-source tool for network exploration, security scanning, and auditing. |
| `openssl` | openssl is a Swiss-army toolkit for TLS/SSL, X.509 certificates, keys, digests, and simple encrypted files. |
| `nmcli` | nmcli is the CLI for NetworkManager. |
| `ufw` | ufw (Uncomplicated Firewall) is Ubuntu’s friendly frontend to netfilter. |
| `nft` | nft is the userspace CLI for nftables, the modern Linux packet-filtering framework that replaces legacy iptables… |
| `iptables` | iptables configures IPv4 packet filtering/NAT via netfilter. |
| `ifconfig` | ifconfig configures and displays network interfaces from the legacy net-tools package. |
| `netstat` | netstat displays network connections, listening sockets, routing tables, and interface statistics from the legacy… |
| `ftp` | ftp is the classic interactive client for the File Transfer Protocol. |
| `telnet` | telnet is a historic remote terminal protocol client. |
| `ssh-keygen` | ssh-keygen creates and manages SSH key pairs, fingerprints host keys, and can update known_hosts. |
| `ssh-copy-id` | ssh-copy-id installs your public key on a remote account’s ~/.ssh/authorized_keys with safer permissions than… |
| `sftp` | sftp is the interactive SSH file-transfer client (SFTP subsystem). |
| `ethtool` | ethtool queries and controls Ethernet NIC settings: link speed/duplex, offloads, ring parameters, and driver info. |
| `firewall-cmd` | firewall-cmd is the client for firewalld, the dynamic firewall manager on Fedora, RHEL, CentOS Stream, and many… |


## Suggested starting points

1. Local stack: `ip`, `ss`, `nmcli`/`resolvectl` as appropriate.
2. Path checks: `ping`, `traceroute`/`mtr`, then `dig`/`host` for DNS.
3. HTTP and APIs: `curl` (and `wget` for simple downloads).
4. Remote admin: `ssh`, keys via `ssh-keygen`/`ssh-copy-id`, files via `scp`/`sftp`/`rsync`.
5. Firewalls: `ufw` (Ubuntu), `firewall-cmd` (firewalld), or `nft`/`iptables`.
6. Deep debug: `tcpdump`, `nmap`, `openssl`, `ethtool`.

## Related parts

- System monitoring — correlate with host load
- Security — host hardening beyond the firewall
- Services and runtime — network targets and sockets

Continue with the individual command pages in this part.
