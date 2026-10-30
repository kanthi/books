#!/usr/bin/env bash
# Generate _quarto.yml from content/ directory layout.
# Do not hand-edit _quarto.yml; re-run this script after structural changes.
# Supports nested sections (part → section → nested section → chapters).
set -euo pipefail
export LC_COLLATE=C

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BOOK_DIR="$(dirname "$SCRIPT_DIR")"
CONTENT_DIR="$BOOK_DIR/content"
QUARTO_YML="$BOOK_DIR/_quarto.yml"
BOOK_NAME="$(basename "$BOOK_DIR")"
BOOK_TITLE="${BOOK_TITLE:-Boring Linux}"

REPO_URL="${BOOK_REPO_URL:-https://github.com/kanthi/books}"
BOOK_AUTHOR="${BOOK_AUTHOR:-K19G}"

if [ ! -d "$CONTENT_DIR" ]; then
  echo "error: content/ not found at $CONTENT_DIR" >&2
  echo "Create content/<NN-part>/ chapters, then re-run this script." >&2
  exit 1
fi

extract_qmd_title() {
  local file="$1"
  local title=""

  if [ -f "$file" ]; then
    title="$(awk '
      BEGIN { in_fm=0 }
      /^---[[:space:]]*$/ {
        if (in_fm == 0) { in_fm=1; next }
        else { exit }
      }
      in_fm && /^title:[[:space:]]*/ {
        sub(/^title:[[:space:]]*/, "")
        gsub(/^["'\'']|["'\'']$/, "")
        print
        exit
      }
    ' "$file")"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi

    title="$(head -n 20 "$file" | grep -E '^#[[:space:]]+' | head -n 1 | sed -E 's/^#[[:space:]]+//')"
    title="${title%% \{*}"
    title="$(printf '%s' "$title" | sed -E 's/[[:space:]]+$//')"
    if [ -n "$title" ]; then
      printf '%s\n' "$title"
      return
    fi
  fi

  local dirname
  dirname="$(basename "$(dirname "$file")")"
  humanize_dir_title "$dirname"
}

# Title-case a directory basename with special cases and small-word rules.
humanize_dir_title() {
  local slug title
  slug="$(echo "$1" | sed -E 's/^[0-9]+-?//')"
  # Split CamelCase leftovers: LinearAlgebra → Linear Algebra
  slug="$(echo "$slug" | sed -E 's/([a-z])([A-Z])/\1-\2/g' | tr '[:upper:]' '[:lower:]')"

  case "$slug" in
    # Linux & Boring-Linux
    hardware-architecture-and-modern-userspace) printf '%s\n' "Hardware Architecture and Modern Userspace"; return ;;
    silicon-and-system-architecture) printf '%s\n' "Silicon & System Architecture"; return ;;
    os-architecture-and-filesystem-layout) printf '%s\n' "OS Architecture & Filesystem"; return ;;
    oxidized-userspace-and-binary-abi) printf '%s\n' "Oxidized Userspace & ABI"; return ;;
    workbook) printf '%s\n' "Workbook"; return ;;
    linux-kernel-internals-core-scheduling-and-locking) printf '%s\n' "Kernel Internals: Core, Scheduling, and Locking"; return ;;
    kernel-core-and-rust-for-linux) printf '%s\n' "Kernel Core & Rust-for-Linux"; return ;;
    syscall-boundary-and-interrupts) printf '%s\n' "Syscalls & Interrupts"; return ;;
    process-lifecycle-and-cpu-scheduling) printf '%s\n' "Process & CPU Scheduling"; return ;;
    kernel-synchronization-and-locking) printf '%s\n' "Synchronization & Locking"; return ;;
    linux-kernel-internals-memory-vfs-and-io) printf '%s\n' "Kernel Internals: Memory, VFS, and I/O"; return ;;
    virtual-memory-and-page-tables) printf '%s\n' "Virtual Memory & Page Tables"; return ;;
    physical-memory-folios-and-reclaim) printf '%s\n' "Physical Memory & Reclaim"; return ;;
    vfs-page-cache-and-async-io) printf '%s\n' "VFS, Page Cache & Async I/O"; return ;;
    block-layer-and-device-drivers) printf '%s\n' "Block Layer & Drivers"; return ;;
    linux-kernel-internals-isolation-security-and-ebpf) printf '%s\n' "Kernel Internals: Isolation, Security, and eBPF"; return ;;
    namespaces-and-container-primitives) printf '%s\n' "Namespaces & Primitives"; return ;;
    cgroups-v2-and-resource-accounting) printf '%s\n' "cgroups v2 & Accounting"; return ;;
    kernel-security-subsystems) printf '%s\n' "Kernel Security Subsystems"; return ;;
    ebpf-subsystem-and-live-updates) printf '%s\n' "eBPF & Live Updates"; return ;;
    systems-programming-and-automation) printf '%s\n' "Systems Programming and Automation"; return ;;
    shell-and-stream-engineering) printf '%s\n' "Shell & Stream Engineering"; return ;;
    systems-software-in-go-and-rust) printf '%s\n' "Go & Rust Systems Programming"; return ;;
    debugging-tracing-and-profiling) printf '%s\n' "Debugging, Tracing & Profiling"; return ;;
    systems-administration-and-immutable-linux) printf '%s\n' "Systems Administration and Immutable Linux"; return ;;
    boot-firmware-and-trusted-compute) printf '%s\n' "Boot, Firmware & Trusted Compute"; return ;;
    provisioning-and-lifecycle) printf '%s\n' "Provisioning & Lifecycle"; return ;;
    identity-authentication-and-privilege) printf '%s\n' "Identity & Privilege"; return ;;
    packaging-and-systemd-mastery) printf '%s\n' "Packaging & systemd"; return ;;
    immutable-and-image-based-os) printf '%s\n' "Immutable & Image-Based Linux"; return ;;
    storage-filesystems-and-encryption) printf '%s\n' "Storage, Filesystems, and Encryption"; return ;;
    block-devices-and-volume-management) printf '%s\n' "Block Devices & Volumes"; return ;;
    cryptographic-storage) printf '%s\n' "Cryptographic Storage"; return ;;
    local-and-copy-on-write-filesystems) printf '%s\n' "Local & CoW Filesystems"; return ;;
    networked-and-distributed-storage) printf '%s\n' "Networked & Distributed Storage"; return ;;
    storage-benchmarking-and-recovery) printf '%s\n' "Benchmarking & Recovery"; return ;;
    network-engineering-and-software-defined-networking) printf '%s\n' "Network Engineering and Software-Defined Networking"; return ;;
    linux-network-stack-and-configuration) printf '%s\n' "Network Stack & Configuration"; return ;;
    switching-bridging-and-overlays) printf '%s\n' "Switching, Bridging & Overlays"; return ;;
    dns-load-balancing-and-edge-ha) printf '%s\n' "DNS, Load Balancing & Edge HA"; return ;;
    vpns-and-packet-diagnostics) printf '%s\n' "VPNs & Packet Diagnostics"; return ;;
    security-cryptography-and-compliance) printf '%s\n' "Security, Cryptography, and Compliance"; return ;;
    mandatory-access-control-and-sandboxing) printf '%s\n' "Access Control & Sandboxing"; return ;;
    network-security-and-ssh-architecture) printf '%s\n' "Network Security & SSH"; return ;;
    cryptography-pki-and-post-quantum) printf '%s\n' "Cryptography, PKI & PQC"; return ;;
    auditing-compliance-and-vulnerability) printf '%s\n' "Auditing & Compliance"; return ;;
    high-performance-realtime-and-ai-infrastructure) printf '%s\n' "High-Performance, Real-Time, and AI Infrastructure"; return ;;
    deterministic-and-realtime-linux) printf '%s\n' "Real-Time & Low-Latency Linux"; return ;;
    kernel-bypass-and-ultra-fast-networking) printf '%s\n' "Kernel Bypass & Ultra-Fast Net"; return ;;
    gpu-compute-and-ai-cluster-engineering) printf '%s\n' "GPU & AI Cluster Engineering"; return ;;
    virtualization-and-private-cloud) printf '%s\n' "Virtualization and Private Cloud"; return ;;
    hypervisor-internals-and-kvm) printf '%s\n' "Hypervisor Internals & KVM"; return ;;
    hardware-passthrough-and-microvms) printf '%s\n' "Passthrough, MicroVMs & CoCo"; return ;;
    private-cloud-and-bare-metal) printf '%s\n' "Private Cloud & Bare-Metal"; return ;;
    running-multiple-kernels-on-one-bare-metal-server) printf '%s\n' "Running Multiple Kernels on One Bare-Metal Server"; return ;;
    linux-performance-engineering-and-server-benchmarking) printf '%s\n' "Linux Performance Engineering & Server Benchmarking"; return ;;
    containers-and-kubernetes-orchestration) printf '%s\n' "Containers and Kubernetes Orchestration"; return ;;
    container-runtimes-and-image-craft) printf '%s\n' "Container Runtimes & Images"; return ;;
    kubernetes-architecture-and-platform) printf '%s\n' "Kubernetes Architecture"; return ;;
    kubernetes-networking-storage-security) printf '%s\n' "K8s Net, Storage & Security"; return ;;
    devops-iac-and-platform-engineering) printf '%s\n' "DevOps, IaC, and Platform Engineering"; return ;;
    version-control-and-ci-cd-pipelines) printf '%s\n' "Version Control & CI/CD"; return ;;
    infrastructure-as-code-and-immutable) printf '%s\n' "IaC & Immutable Images"; return ;;
    configuration-and-model-driven-ops) printf '%s\n' "Config & Model-Driven Ops"; return ;;
    observability-sre-and-performance-engineering) printf '%s\n' "Observability, SRE, and Performance Engineering"; return ;;
    telemetry-pipelines-and-opentelemetry) printf '%s\n' "Telemetry & OpenTelemetry"; return ;;
    metrics-logs-traces-and-profiling) printf '%s\n' "Metrics, Logs, Traces & Profiling"; return ;;
    kernel-tracing-and-sre-practices) printf '%s\n' "Kernel Tracing & SRE"; return ;;
    gitops-and-cloud-native-control-planes) printf '%s\n' "GitOps and Cloud-Native Control Planes"; return ;;
    gitops-architecture-and-packaging) printf '%s\n' "GitOps & Packaging"; return ;;
    secrets-and-progressive-delivery) printf '%s\n' "Secrets & Progressive Delivery"; return ;;
    cloud-native-infrastructure-control) printf '%s\n' "Cloud-Native Control Planes"; return ;;
    appendices-runbooks-and-reference-blueprints) printf '%s\n' "Appendices, Runbooks, and Reference Blueprints"; return ;;
    migrations-and-interoperability) printf '%s\n' "Migrations & Interop"; return ;;
    production-emergency-runbooks) printf '%s\n' "Emergency Runbooks"; return ;;
    end-to-end-reference-blueprints) printf '%s\n' "Reference Blueprints"; return ;;
    devops-and-observability)   printf '%s\n' "DevOps and Observability"; return ;;
    gitops-and-cloud-native)    printf '%s\n' "GitOps and Cloud-Native"; return ;;
    appendices-and-runbooks)    printf '%s\n' "Appendices and Runbooks"; return ;;
    containers)                 printf '%s\n' "Containers"; return ;;
    kubernetes)                 printf '%s\n' "Kubernetes"; return ;;
    devops)                     printf '%s\n' "DevOps"; return ;;
    observability)              printf '%s\n' "Observability"; return ;;
    gitops)                     printf '%s\n' "GitOps"; return ;;
    cloud-native)               printf '%s\n' "Cloud-Native"; return ;;
    virtualization)             printf '%s\n' "Virtualization"; return ;;
    cloud)                      printf '%s\n' "Cloud"; return ;;
    packages-and-systemd)       printf '%s\n' "Packages and systemd"; return ;;
    tcp-ip-and-netplan)         printf '%s\n' "TCP/IP and Netplan"; return ;;
    dns-and-edge-services)      printf '%s\n' "DNS and Edge Services"; return ;;
    ssh-and-firewalls)          printf '%s\n' "SSH and Firewalls"; return ;;
    terminals-and-mux)          printf '%s\n' "Terminals and Multiplexers"; return ;;
    help-and-docs)              printf '%s\n' "Help and Docs"; return ;;
    services-and-runtime)       printf '%s\n' "Services and Runtime"; return ;;
    text-and-pipes)             printf '%s\n' "Text and Pipes"; return ;;
    files-and-paths)            printf '%s\n' "Files and Paths"; return ;;
    archives-and-compression)   printf '%s\n' "Archives and Compression"; return ;;
    processes-and-jobs)         printf '%s\n' "Processes and Jobs"; return ;;
    users-and-groups)           printf '%s\n' "Users and Groups"; return ;;
    storage-and-filesystems)    printf '%s\n' "Storage and Filesystems"; return ;;
    system-information)         printf '%s\n' "System Information"; return ;;
    system-monitoring)          printf '%s\n' "System Monitoring"; return ;;
    shell-commands)             printf '%s\n' "Shell Commands"; return ;;
    intro-to-shells)            printf '%s\n' "Intro to Shells"; return ;;
    bash-features)              printf '%s\n' "Bash Features"; return ;;
    lazyvim)                    printf '%s\n' "LazyVim"; return ;;
    modern-tools)               printf '%s\n' "Modern Tools"; return ;;
    # C
    file-io)                    printf '%s\n' "File I/O"; return ;;
    arrays-strings)             printf '%s\n' "Arrays and Strings"; return ;;
    data-types)                 printf '%s\n' "Data Types"; return ;;
    control-flow)               printf '%s\n' "Control Flow"; return ;;
    data-structures)            printf '%s\n' "Data Structures"; return ;;
    modern-c)                   printf '%s\n' "Modern C"; return ;;
    # Go
    concurrency-parallelism)    printf '%s\n' "Concurrency and Parallelism"; return ;;
    performance-tooling)        printf '%s\n' "Performance and Tooling"; return ;;
    network-systems)            printf '%s\n' "Network Systems"; return ;;
    systems-programming)        printf '%s\n' "Systems Programming"; return ;;
    distributed-infra)          printf '%s\n' "Distributed Infrastructure"; return ;;
    observability-sre)          printf '%s\n' "Observability and SRE"; return ;;
    security-hardening)         printf '%s\n' "Security Hardening"; return ;;
    performance-engineering)    printf '%s\n' "Performance Engineering"; return ;;
    modern-go-book-synthesis)   printf '%s\n' "Modern Go Synthesis"; return ;;
    go-deep-dives)              printf '%s\n' "Go Deep Dives"; return ;;
    concurrency-ground-up)      printf '%s\n' "Concurrency Ground Up"; return ;;
    web-development-in-go)      printf '%s\n' "Web Development in Go"; return ;;
    cli-tools-in-go)            printf '%s\n' "CLI Tools in Go"; return ;;
    # NixOS
    front-matter)               printf '%s\n' "Front Matter"; return ;;
    nix-on-linux)               printf '%s\n' "Nix on Linux"; return ;;
    nixos-host)                 printf '%s\n' "NixOS Host"; return ;;
    home-and-flake-layout)      printf '%s\n' "Home and Flake Layout"; return ;;
    services-and-security)      printf '%s\n' "Services and Security"; return ;;
    ops-and-fleet)              printf '%s\n' "Ops and Fleet"; return ;;
    # Maths
    pre-algebra)                printf '%s\n' "Pre-Algebra"; return ;;
    linear-algebra)             printf '%s\n' "Linear Algebra"; return ;;
    discrete-mathematics)       printf '%s\n' "Discrete Mathematics"; return ;;
    number-theory)              printf '%s\n' "Number Theory"; return ;;
    information-theory)         printf '%s\n' "Information Theory"; return ;;
    machine-learning-math)      printf '%s\n' "Machine Learning Math"; return ;;
    algorithms-complexity)      printf '%s\n' "Algorithms and Complexity"; return ;;
    graph-theory)               printf '%s\n' "Graph Theory"; return ;;
    numerical-methods)          printf '%s\n' "Numerical Methods"; return ;;
    data-science-math)          printf '%s\n' "Data Science Math"; return ;;
    probability-advanced)       printf '%s\n' "Probability (Advanced)"; return ;;
    linear-algebra-advanced)    printf '%s\n' "Linear Algebra (Advanced)"; return ;;
    complexity-theory)          printf '%s\n' "Complexity Theory"; return ;;
    # Networking
    lab-platform)               printf '%s\n' "Lab Platform"; return ;;
    networking-foundations)     printf '%s\n' "Networking Foundations"; return ;;
    layer-2)                    printf '%s\n' "Layer 2"; return ;;
    layer-3)                    printf '%s\n' "Layer 3"; return ;;
    interior-routing)           printf '%s\n' "Interior Routing"; return ;;
    ops-automation)             printf '%s\n' "Ops and Automation"; return ;;
    edge-and-services)          printf '%s\n' "Edge and Services"; return ;;
    policy-qos-hardening)       printf '%s\n' "Policy, QoS, and Hardening"; return ;;
    overlays-tunnels)           printf '%s\n' "Overlays and Tunnels"; return ;;
    fabrics-multi-area)         printf '%s\n' "Fabrics and Multi-Area"; return ;;
    # VCS (before generic CamelCase split effects: GitHub → git-hub)
    git)                        printf '%s\n' "Git"; return ;;
    github|git-hub)             printf '%s\n' "GitHub"; return ;;
    jj)                         printf '%s\n' "Jujutsu"; return ;;
    forges)                     printf '%s\n' "Forges"; return ;;
    gitlab)                     printf '%s\n' "GitLab"; return ;;
    mental-model)               printf '%s\n' "Mental Model"; return ;;
    install-and-config)         printf '%s\n' "Install and Config"; return ;;
    first-repository)           printf '%s\n' "First Repository"; return ;;
    commits-and-history)        printf '%s\n' "Commits and History"; return ;;
    branching-and-merging)      printf '%s\n' "Branching and Merging"; return ;;
    rebasing)                   printf '%s\n' "Rebasing"; return ;;
    remotes)                    printf '%s\n' "Remotes"; return ;;
    workflows)                  printf '%s\n' "Workflows"; return ;;
    stash-tags-and-cleanup)     printf '%s\n' "Stash, Tags, and Cleanup"; return ;;
    hooks)                      printf '%s\n' "Hooks"; return ;;
    submodules-and-worktrees)   printf '%s\n' "Submodules and Worktrees"; return ;;
    internals)                  printf '%s\n' "Internals"; return ;;
    performance-and-scale)      printf '%s\n' "Performance and Scale"; return ;;
    security)                   printf '%s\n' "Security"; return ;;
    troubleshooting)            printf '%s\n' "Troubleshooting"; return ;;
    git-fundamentals)           printf '%s\n' "Git Fundamentals"; return ;;
    core-operations)            printf '%s\n' "Core Operations"; return ;;
    git-internals)              printf '%s\n' "Git Internals"; return ;;
    advanced-branching)         printf '%s\n' "Advanced Branching"; return ;;
    rewriting-history)          printf '%s\n' "Rewriting History"; return ;;
    advanced-commands)          printf '%s\n' "Advanced Commands"; return ;;
    hooks-automation)           printf '%s\n' "Hooks and Automation"; return ;;
    open-source)                printf '%s\n' "Open Source"; return ;;
    orgs-and-teams)             printf '%s\n' "Orgs and Teams"; return ;;
    advanced-topics)            printf '%s\n' "Advanced Topics"; return ;;
    # Boring-Linux v2 (parts and sections)
    foundations-boot-and-platform) printf '%s\n' "Foundations, Boot and Platform"; return ;;
    machine-and-kernel-model) printf '%s\n' "The Machine and Kernel Model"; return ;;
    firmware-and-bootloaders) printf '%s\n' "Firmware and Bootloaders"; return ;;
    init-and-recovery) printf '%s\n' "Init Handoff and Recovery"; return ;;
    system-administration) printf '%s\n' "System Administration"; return ;;
    identity-and-access) printf '%s\n' "Identity and Access"; return ;;
    packages-and-updates) printf '%s\n' "Packages and Updates"; return ;;
    services-and-scheduling) printf '%s\n' "Services and Scheduling"; return ;;
    resources-and-kernel-tuning) printf '%s\n' "Resources and Kernel Tuning"; return ;;
    storage-administration) printf '%s\n' "Storage Administration"; return ;;
    block-devices-and-filesystems) printf '%s\n' "Block Devices and Filesystems"; return ;;
    volumes-and-encryption) printf '%s\n' "Volumes and Encryption"; return ;;
    network-storage-and-protection) printf '%s\n' "Network Storage and Protection"; return ;;
    network-administration) printf '%s\n' "Network Administration"; return ;;
    stack-and-addressing) printf '%s\n' "Stack and Addressing"; return ;;
    routing-and-switching) printf '%s\n' "Routing and Switching"; return ;;
    services-firewall-and-tunnels) printf '%s\n' "Name Services, Firewall and Tunnels"; return ;;
    performance-and-diagnosis) printf '%s\n' "Performance and Diagnosis"; return ;;
    security-administration) printf '%s\n' "Security Administration"; return ;;
    host-access-control) printf '%s\n' "Host Access Control"; return ;;
    remote-access-and-crypto) printf '%s\n' "Remote Access and Cryptography"; return ;;
    hardening-and-assurance) printf '%s\n' "Hardening and Assurance"; return ;;
    virtualization-administration) printf '%s\n' "Virtualization Administration"; return ;;
    kvm-qemu-libvirt) printf '%s\n' "KVM, QEMU and libvirt"; return ;;
    guest-storage-network-and-images) printf '%s\n' "Guest Storage, Network and Images"; return ;;
    advanced-and-alternative) printf '%s\n' "Advanced Topics"; return ;;
    container-administration) printf '%s\n' "Container Administration"; return ;;
    kernel-primitives) printf '%s\n' "Kernel Primitives"; return ;;
    images-runtimes-and-tools) printf '%s\n' "Images, Runtimes and Tools"; return ;;
    networking-and-security) printf '%s\n' "Networking and Security"; return ;;
    kubernetes-node) printf '%s\n' "Kubernetes from the Node"; return ;;
    service-administration) printf '%s\n' "Service Administration"; return ;;
    web-and-proxy) printf '%s\n' "Web and Proxy"; return ;;
    data-services) printf '%s\n' "Data Services"; return ;;
    availability-and-infrastructure-services) printf '%s\n' "Availability and Infrastructure Services"; return ;;
    observability) printf '%s\n' "Observability"; return ;;
    signals-and-host-tools) printf '%s\n' "Signals and Host Tools"; return ;;
    kernel-tracing-and-profiling) printf '%s\n' "Kernel Tracing and Profiling"; return ;;
    telemetry-pipelines) printf '%s\n' "Telemetry Pipelines"; return ;;
    monitoring-and-alerting) printf '%s\n' "Monitoring and Alerting"; return ;;
    metrics-with-prometheus) printf '%s\n' "Metrics with Prometheus"; return ;;
    dashboards-and-alerts) printf '%s\n' "Dashboards and Alerts"; return ;;
    coverage-and-resilience) printf '%s\n' "Coverage and Resilience"; return ;;
    devops) printf '%s\n' "DevOps"; return ;;
    automation-and-builds) printf '%s\n' "Automation and Builds"; return ;;
    ci-and-artifacts) printf '%s\n' "CI and Artifacts"; return ;;
    delivery-and-measurement) printf '%s\n' "Delivery and Measurement"; return ;;
    infrastructure-as-code) printf '%s\n' "Infrastructure as Code"; return ;;
    principles-and-configuration-management) printf '%s\n' "Principles and Configuration Management"; return ;;
    provisioning) printf '%s\n' "Provisioning"; return ;;
    images-and-first-boot) printf '%s\n' "Images and First Boot"; return ;;
    quality) printf '%s\n' "Quality"; return ;;
    gitops) printf '%s\n' "GitOps"; return ;;
    principles-and-repositories) printf '%s\n' "Principles and Repositories"; return ;;
    controllers-and-secrets) printf '%s\n' "Controllers and Secrets"; return ;;
    delivery-policy-and-scale) printf '%s\n' "Delivery, Policy and Scale"; return ;;
    platform-engineering) printf '%s\n' "Platform Engineering"; return ;;
    platform-as-product) printf '%s\n' "Platform as Product"; return ;;
    platform-foundations) printf '%s\n' "Platform Foundations"; return ;;
    running-the-platform) printf '%s\n' "Running the Platform"; return ;;
    site-reliability-engineering) printf '%s\n' "Site Reliability Engineering"; return ;;
    targets-and-toil) printf '%s\n' "Targets and Toil"; return ;;
    incidents-and-learning) printf '%s\n' "Incidents and Learning"; return ;;
    resilience) printf '%s\n' "Resilience"; return ;;
    forward-deployed-engineering) printf '%s\n' "Forward-Deployed Engineering"; return ;;
    role-and-discovery) printf '%s\n' "Role and Discovery"; return ;;
    working-under-constraint) printf '%s\n' "Working Under Constraint"; return ;;
    integration-and-communication) printf '%s\n' "Integration and Communication"; return ;;
    appendices) printf '%s\n' "Appendices"; return ;;
    reference) printf '%s\n' "Reference"; return ;;
    palace-index) printf '%s\n' "Palace Index"; return ;;
  esac

  title="$(echo "$slug" | sed 's/-/ /g' | awk '{
    small["and"]=1; small["or"]=1; small["to"]=1; small["of"]=1;
    small["for"]=1; small["in"]=1; small["on"]=1; small["the"]=1; small["a"]=1;
    for (i=1;i<=NF;i++) {
      w=tolower($i)
      if (i>1 && (w in small)) $i=w
      else $i=toupper(substr(w,1,1)) substr(w,2)
    }
    print
  }')"
  printf '%s\n' "$title"
}

get_metadata() {
  local dir="$1"
  local dirname order title
  dirname="$(basename "$dir")"

  if [[ $dirname =~ ^[0-9]+ ]]; then
    order="${BASH_REMATCH[0]}"
  else
    order="99"
  fi
  title="$(humanize_dir_title "$dirname")"
  printf '%s|%s\n' "$order" "$title"
}

TMP_FILE="$(mktemp)"
trap 'rm -f "$TMP_FILE"' EXIT

cat > "$TMP_FILE" <<EOL
project:
  type: book
  output-dir: _book
  # Dual-theme illustrated SVGs (dark siblings swapped in HTML — see includes/diagrams/STANDARD.md)
  resources:
    - images/*-dark.svg

book:
  title: "$BOOK_TITLE"
  author: "$BOOK_AUTHOR"
  date: last-modified
  navbar:
    pinned: true
    right:
      - icon: github
        href: $REPO_URL

  sidebar:
    style: docked
    collapse-level: 1
  reader-mode: true
  chapters:
    - index.qmd
EOL

# Overview stubs are authoring notes, not reader-facing chapters. Only expose
# parts/sections containing actual chapters so planned groups do not create
# empty navigation headings after their overview is omitted.
has_publishable_content() {
  local doc
  while IFS= read -r -d '' doc; do
    if [ "$(extract_qmd_title "$doc")" != "Overview" ]; then
      return 0
    fi
  done < <(find "$1" -type d -name '_*' -prune -o -type f \( -name '*.qmd' -o -name '*.md' \) -print0)
  return 1
}

emit_chapter_files() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local ext doc doc_name file_title

  for ext in qmd md; do
    if [ -f "$folder/index.$ext" ]; then
      file_title="$(extract_qmd_title "$folder/index.$ext")"
      [[ "$file_title" == "Overview" ]] && continue
      {
        echo "${ind}- text: \"$file_title\""
        echo "${ind}  file: ${rel}/index.$ext"
      } >> "$TMP_FILE"
      break
    fi
  done

  while IFS= read -r -d '' doc; do
    doc_name="$(basename "$doc")"
    [[ "$doc_name" == index.* ]] && continue
    file_title="$(extract_qmd_title "$doc")"
    [[ "$file_title" == "Overview" ]] && continue
    {
      echo "${ind}- text: \"$file_title\""
      echo "${ind}  file: ${rel}/${doc_name}"
    } >> "$TMP_FILE"
  done < <(find "$folder" -maxdepth 1 -type f \( -name "*.qmd" -o -name "*.md" \) -print0 2>/dev/null | sort -z)
}

emit_section() {
  local folder="$1"
  local rel="$2"
  local ind="$3"
  local nested_ind="${ind}  "
  local item_ind="${nested_ind}  "
  local name title sub sub_name sub_rel

  has_publishable_content "$folder" || return 0

  name="$(basename "$folder")"
  title="$(humanize_dir_title "$name")"

  {
    echo "${ind}- section: \"$title\""
    echo "${ind}  contents:"
  } >> "$TMP_FILE"

  for sub in "$folder"/*; do
    if [ -d "$sub" ] && [[ ! $(basename "$sub") == _* ]]; then
      sub_name="$(basename "$sub")"
      sub_rel="${rel}/${sub_name}"
      emit_section "$sub" "$sub_rel" "$item_ind"
    fi
  done

  emit_chapter_files "$folder" "$rel" "$item_ind"
}

process_directory() {
  local dir="$1"
  local metadata order title
  has_publishable_content "$dir" || return 0
  metadata="$(get_metadata "$dir")"
  order="$(echo "$metadata" | cut -d'|' -f1)"
  title="$(echo "$metadata" | cut -d'|' -f2)"

  {
    echo "    - part: \"$title\""
    echo "      contents:"
  } >> "$TMP_FILE"

  local subdir
  emit_chapter_files "$dir" "content/$(basename "$dir")" "        "

  for subdir in "$dir"/*; do
    if [ -d "$subdir" ] && [[ ! $(basename "$subdir") == _* ]]; then
      emit_section "$subdir" "content/$(basename "$dir")/$(basename "$subdir")" "        "
    fi
  done
}

categories=()
while IFS= read -r category; do
  if [ -d "$category" ] && [[ ! $(basename "$category") == _* ]]; then
    metadata="$(get_metadata "$category")"
    order="$(echo "$metadata" | cut -d'|' -f1)"
    categories+=("$order|$category")
  fi
done < <(find "$CONTENT_DIR" -maxdepth 1 -mindepth 1 -type d | sort)

if [ "${#categories[@]}" -gt 0 ]; then
  while IFS= read -r category_info; do
    [ -z "$category_info" ] && continue
    category_path="$(echo "$category_info" | cut -d'|' -f2)"
    process_directory "$category_path"
  done < <(printf "%s\n" "${categories[@]}" | sort -n)
fi

cat >> "$TMP_FILE" <<'EOL'

# Document-level (not valid under book:). HTML title block: date → Published; date-modified → Updated.
date-modified: last-modified

language:
  title-block-modified: "Updated"

format:
  html:
    theme:
      dark: [darkly, styles/dark.scss]
      light: [cosmo, styles/light.scss]
    syntax-highlighting:
      light: styles/zed-light.theme
      dark: styles/zed-dark.theme
    code-fold: true
    toc: true
    number-sections: false
    page-navigation: true
    include-after-body:
      - styles/reader-mode-body.html

  pdf:
    pdf-engine-max-runs: 4
    documentclass: scrreprt
    classoption: ["oneside"]
    number-sections: false
    colorlinks: true
    geometry:
      - top=25mm
      - left=25mm
      - right=25mm
      - bottom=25mm

  epub:
    toc: true
    number-sections: false
    css: styles/epub.css
EOL

mv "$TMP_FILE" "$QUARTO_YML"
trap - EXIT

echo "Updated _quarto.yml for book: $BOOK_NAME"
echo "  content: $CONTENT_DIR"
echo "  output:  $QUARTO_YML"
