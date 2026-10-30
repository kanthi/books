# Linux Performance Engineering & Server Benchmarking — Syllabus & Curriculum
## From Kernel Internals to Production Optimization

> **Track:** Advanced Linux Systems Engineering & Performance Specialization  
> **Target Platform:** Ubuntu 26.04 LTS ("Resolute Raccoon"), Linux 6.x+, Modern x86_64 / ARM64 Server Hardware  
> **Status:** Accepted Syllabus & Planning Brief

---

## Purpose and Scope

This curriculum delivers an exhaustive, production-grade guide to Linux systems performance engineering, kernel instrumentation, workload characterization, hardware-level profiling, subsystem tuning, and rigorous benchmarking. Moving methodically from first principles (queueing theory, latency percentiles, and statistical variance) through kernel subsystems (scheduler, virtual memory, NUMA, VFS/page cache, block layer, and network stack) to observability (eBPF, perf, flame graphs, PSI) and production hardening, it bridges low-level kernel mechanics with enterprise site reliability engineering.

---

## Detailed Table of Contents

### Introduction: The Discipline of Performance Engineering
- Performance Is a System Property, Not a Configuration
- Latency, Throughput, Utilization, Saturation, Availability
- The Measurement Imperative
- Common Pitfalls and How to Avoid Them

### Chapter 1: The Performance Engineering Methodology
- Characterizing the Workload
- Defining Success: SLOs, SLIs and Performance Targets
- Baseline Creation and Reference Measurements
- Experimental Design: Variables, Controls and Reproducibility
- Statistical Rigor: Variance, Outliers and Significance
- The Diagnosis Loop: From Symptom to Root Cause

### Chapter 2: Linux Kernel Architecture and Performance
- Kernel Space and User Space: The Boundary Cost
- System Calls: Entry, Exit and Overhead
- Processes, Threads and the Task Structure
- Context Switching: Mechanics and Cost
- Interrupts, Softirqs and Bottom Halves
- Synchronization Primitives: Locks, Spinlocks and Contention

### Chapter 3: CPU Architecture and Performance Counters
- Modern CPU Microarchitecture: Pipelines and Parallelism
- Cache Hierarchy: L1, L2, L3, TLB and Cache Misses
- Branch Prediction and Speculative Execution
- Cores, Hyperthreading and SMT
- CPU Frequency Scaling and Power States
- Performance Counters and Hardware Events

### Chapter 4: CPU Scheduling and Process Placement
- The Completely Fair Scheduler: Internal Mechanics
- Virtual Runtime, Timeslices and Fairness
- Real-Time Scheduling: SCHED_FIFO, SCHED_RR, SCHED_DEADLINE
- CPU Affinity, Isolation and Task Migration
- Load Balancing Across NUMA Nodes

### Chapter 5: Memory Management: Virtual Memory and Pages
- Virtual Memory: Address Spaces and Page Tables
- Page Faults: Minor and Major Faults
- Physical Memory: Allocation and Management
- Swapping: Mechanics, Costs and Modern Behavior
- Huge Pages and Transparent Huge Pages
- Memory Accounting: RSS, PSS and Kernel Metrics

### Chapter 6: NUMA Architecture and Memory Placement
- What NUMA Means for Performance
- NUMA Nodes, Local vs Remote Memory Access
- NUMA-Aware Allocation and Policies
- Diagnosing NUMA Imbalance
- Optimizing for NUMA: Placement and Binding
- NUMA in Virtualized and Cloud Environments

### Chapter 7: The Page Cache and Memory-Mapped Files
- Page Cache: Architecture and Behavior
- Read-Ahead and Write-Behind
- Memory-Mapped Files and mmap
- Cache Pressure and Eviction Policies
- Dirty Page Management and Writeback

### Chapter 8: I/O Subsystems: From Block Layer to Disk
- The I/O Path: From open() to the Disk
- The Block Layer and Request Queues
- I/O Schedulers: noop, deadline, cfq, mq-deadline, kyber, bfq
- Block Devices and Queueing Models
- I/O Merge, Splitting and Bio Structures
- I/O Completion and Interrupt Handling

### Chapter 9: Storage Technologies and Performance Characteristics
- HDDs: Seek Latency, Rotational Latency and Throughput
- SSDs: NAND Characteristics, Wear Leveling and GC
- NVMe: Protocol Advantages and Queue Architecture
- RAID and Hardware Controllers
- Cloud Block Storage and Shared Storage
- Choosing Storage for the Workload

### Chapter 10: Filesystems and Mount Options
- ext4: Journaling, Allocation and Performance
- XFS: Design Principles and Scalability
- btrfs and Copy-on-Write Semantics
- Filesystem Journaling and Write Performance
- Mount Options: Performance Implications
- Filesystem-Level Caching and Coherency

### Chapter 11: The Networking Stack and Performance
- The Networking Data Path
- Socket Buffering and Memory
- NIC Interrupts and Softirq Processing
- RSS, RPS, XPS: Distributing Network Load
- TCP Congestion Control and Buffer Tuning
- UDP and Raw Sockets Performance

### Chapter 12: Network Performance Tuning in Practice
- Core TCP Parameters and Their Effects
- Socket Buffer Sizing Strategy
- Congestion Control Algorithm Selection
- Multiqueue Configuration and RSS Tuning
- Validating Network Performance Changes

### Chapter 13: System Call Tracing and Process Analysis
- strace and ltrace: Mechanics and Use Cases
- perf: Architecture and Profiling Modes
- ftrace: Kernel Tracing Infrastructure
- Tracepoints and Dynamic Probes
- SystemTap: Overview and Comparison
- Building a Tracing Strategy

### Chapter 14: eBPF and BPF-Based Observability
- eBPF Architecture and Safety Model
- BPF Map Types and Communication
- bpftrace: High-Level Tracing
- BCC Tools: Key Utilities
- Writing Custom BPF Programs
- eBPF Overhead and Production Safety

### Chapter 15: Performance Analysis Tools and Flame Graphs
- Flame Graphs: Construction and Interpretation
- perf Record and Report
- Hotspot Analysis and Call Path Tracing
- Combining Tools: Integrated Workflows
- Sampling vs Tracing: Trade-offs
- Automated Analysis Pipelines

### Chapter 16: System Monitoring and Observability
- Classic Tools: sar, vmstat, iostat, mpstat, pidstat
- Modern Monitoring: top, htop, numastat
- Network Monitoring: ss, ethtool, nstat
- Pressure Stall Information and Modern Metrics
- Building Production Dashboards and Alerting

### Chapter 17: Benchmarking: Design and Execution
- What Makes a Valid Benchmark
- Designing Representative Workloads
- Test Environment Isolation and Control
- Warm-Up, Steady State and Cooldown
- Repetition, Reproducibility and Statistical Analysis
- Benchmarking Mistakes: Gaming, Noise and Bias

### Chapter 18: Benchmarking Tools and Suites
- fio: Storage Benchmarking Deep Dive
- stress-ng: Comprehensive System Stress Testing
- sysbench: CPU, Memory, File I/O, Database Tests
- iperf3: Network Throughput and Latency
- lmbench: Latency and Bandwidth Microbenchmarks
- Application-Level: wrk, ApacheBench, curl
- Phoronix Test Suite and Comparative Testing

### Chapter 19: CPU and Memory Tuning for Production
- CPU Governor Selection and Configuration
- IRQ Affinity and NUMA-Optimal Placement
- CPU Isolation for Critical Workloads
- Huge Pages: Configuring and Validating
- Memory Sysctl Parameters
- Validating CPU and Memory Tuning

### Chapter 20: I/O and Filesystem Tuning for Production
- I/O Scheduler Selection by Workload
- Filesystem Mount Options for Performance
- Writeback and Dirty Page Tuning
- Device-Level Parameters: Queue Depth and Read-Ahead
- SSD and NVMe-Specific Tuning
- Validating I/O Performance Improvements

### Chapter 21: cgroups, systemd and Resource Management
- cgroups v1 vs v2: Architecture Differences
- CPU Controllers and Throttling
- Memory Controllers: Limits and Pressure
- I/O Controllers: Throttling and Prioritization
- systemd Resource Controls and Service Isolation
- ulimits and Resource Limits

### Chapter 22: Containers, Virtualization and Noisy Neighbors
- Container Performance: Isolation and Overhead
- cgroups and Namespaces in Containers
- Virtualization Overhead: Hypervisors and Emulation
- Detecting and Mitigating Noisy Neighbors
- Cloud vs Bare Metal: Performance Implications
- Best Practices for Containerized Workloads

### Chapter 23: Databases and High-Performance Applications
- How Databases Use Linux: I/O and Memory Patterns
- Shared Memory and IPC for Databases
- Locking and Contention in Database Workloads
- NUMA and Database Placement
- Application Runtimes: JVM, Go, Python Considerations
- Tail Latency Optimization

### Chapter 24: Distributed Systems and Cluster Performance
- Distributed Latency: Network and System Contributions
- Clock Synchronization and Time Skew
- Network Partitions and Performance
- Consensus Protocols and Performance Costs
- Cluster Resource Management
- Observability at Scale

### Chapter 25: Production Case Studies
- Case Study: CPU Saturation from Interrupt Storms
- Case Study: Memory Pressure and Swapping Crisis
- Case Study: NUMA Imbalance Causing 5x Latency
- Case Study: I/O Bottleneck on Shared Storage
- Case Study: Noisy Neighbor in Multi-Tenant Cloud

### Chapter 26: Capacity Planning and Performance Regression
- Capacity Modeling and Forecasting
- Baseline Management and Versioning
- Regression Detection: Automated and Manual
- Load Testing and Stress Testing Strategies
- Performance Budgets and Guardrails
- Continuous Performance Validation

### Chapter 27: Advanced Topics and Emerging Technologies
- Real-Time Kernels and PREEMPT_RT
- Kernel Bypass: DPDK, XDP and AF_XDP
- x86-64 vs ARM64: Performance Differences
- RDMA and Low-Latency Networking
- eBPF in Production: Advanced Patterns
- Future Directions: Kernel and Hardware Trends

### Conclusion: Putting It All Together
- The Engineer’s Mindset for Performance
- When Not to Optimize
- Building a Performance Culture
