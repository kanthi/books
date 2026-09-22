# Independent Code Hosting — syllabus

**Book title:** Architectures, Platforms and Operations for Independent Code Hosting  
**Path:** `books/VCS/`  
**Status:** TOC frozen. Chapter prose, labs, and diagrams wait for a writing pass.

This file is the canonical table of contents. Chapter titles and section titles below are the outline. Do not add chapters without updating this file first.

Old Git / GitHub / Jujutsu / Forges syllabus: `archive/SYLLABUS-git-github-jj-forges.md`.

---

## Book shape (Quarto)

`index.qmd` is the door (unnumbered). Twenty numbered chapters sit in five parts so the sidebar is a journey. Parts are folders; they do not add chapters.

| Part | Dir | Chapters |
|------|-----|----------|
| Foundations | `content/01-foundations/` | 1–3 |
| Platforms | `content/02-platforms/` | 4–9 |
| Capabilities | `content/03-capabilities/` | 10–15 |
| Operations | `content/04-operations/` | 16–19 |
| Choice | `content/05-choice/` | 20 |

Each chapter is one section directory. Each bullet under a chapter is one page (H2). Directories are created when that chapter’s writing pass starts.

---

## Writing rules (when content starts)

- **Reader:** first-time learner to operator. Define forge, remote, lock-in, and protocol on first use. Depth ramps: user → installer → admin → operator → chooser.
- **Independence:** this book stands alone. Minimum SSH, container, and reverse-proxy facts live here.
- **Replace the old book:** wipe `content/01-git/`, `02-github/`, `03-jj/`, `04-forges/` at the start of the first writing pass. Jujutsu is out of scope.
- **GitHub:** Ch 1 (lock-in), comparisons in Ch 5–6 and Ch 12 (Actions), GHES in Ch 9. No extra GitHub chapter.
- **Labs:** equal shallow lab in each of Ch 4–9 (account or compose, one repo, one change, one native extra, tear-down). Recurring desk repos: `desk-web`, `desk-api`, `desk-infra`.
- **Overlap:** Ch 3 *names* a component; later chapters *operate* it (identity, storage, CI, security).

---

## Table of Contents

### Chapter 1: The GitHub Monoculture Problem

`content/01-foundations/01-github-monoculture/`

- How GitHub Became Default
- Risks of Platform Lock-in
- The Regulatory and Geopolitical Dimension
- What “Beyond GitHub” Actually Means
- A Framework for This Book

### Chapter 2: Git Fundamentals for Infrastructure Engineers

`content/01-foundations/02-git-fundamentals/`

- The Distributed Model and Its Implications
- Objects, References, and Pack Files
- Remote Communication Protocols
- Hooks, Attributes, and Configuration Layers
- Git Internals That Affect Server Design

### Chapter 3: The Architecture of a Git Hosting Platform

`content/01-foundations/03-platform-architecture/`

- Git Alone vs Git Hosting
- Core Platform Components
- The Protocol Stack: SSH, HTTP, and Git Smart Protocols
- Storage Architectures: Filesystem, Distributed Storage, and Object Stores
- Authentication, Authorization, and Identity Integration
- Extensibility: Webhooks, APIs, and Plugins
- Architectural Styles: Monolith vs Microservices
- Operational Complexity: The Hidden Cost

### Chapter 4: GitLab, The Full-Stack Platform

`content/02-platforms/01-gitlab/`

- History and Philosophy: From a Side Project to Enterprise Platform
- Architecture: Omnibus, Monolith, and Kubernetes Deployment
- Feature Set: CI/CD, Registry, Security, and DevOps Features
- Operational Requirements: Resource Profile and Scaling
- Licensing: FOSS vs Premium and What That Means
- When GitLab Is the Right Choice

### Chapter 5: Gitea and Forgejo, Lightweight and Community-Driven

`content/02-platforms/02-gitea-and-forgejo/`

- Gitea: Origins and Design Philosophy
- Architecture: Go, SQLite, and Single-Binary Simplicity
- The Forgejo Fork: Why It Happened and What Changed
- Comparison: Gitea vs Forgejo vs GitLab
- Deployment Patterns for Small Teams and Personal Use
- Scaling Gitea: Limits and Workarounds
- When Gitea or Forgejo Is the Right Choice

### Chapter 6: Bitbucket, Enterprise and Cloud Integration

`content/02-platforms/03-bitbucket/`

- Bitbucket Cloud vs Bitbucket Data Center
- Architecture and Deployment Models
- Jira and Atlassian Ecosystem Integration
- Enterprise Features: Branch Permissions, Code Insights, Audit Logs
- Comparison with GitLab and GitHub
- When Bitbucket Fits

### Chapter 7: Gerrit, Code Review as a First-Class Citizen

`content/02-platforms/04-gerrit/`

- What Gerrit Actually Is
- Architecture: The Review-Centric Model
- Workflow: Change IDs, Drafts, and Approval Chains
- Integration with Jenkins, CI Systems, and Other Tools
- Operational Considerations: Performance and Complexity
- Gerrit in Practice: Android, Kubernetes, and Other Major Projects
- When Gerrit Is the Right Choice

### Chapter 8: SourceHut, Minimalist Philosophy and Tools

`content/02-platforms/05-sourcehut/`

- SourceHut Philosophy: Tools, Not Platforms
- The sr.ht Suite: Git, Issues, Mailing Lists, CI
- Architecture: Python, Mail-Driven Workflows, and Simplicity
- Extensibility and Automation via Hook Scripts
- Comparison with Feature-Rich Platforms
- When SourceHut Makes Sense

### Chapter 9: Other Notable Solutions and Niche Platforms

`content/02-platforms/06-niche-platforms/`

- Codeberg and Community-Run Instances
- GitBucket and GitHub-Compatible Alternatives
- Gogs: The Ancestor of Gitea
- Phabricator and Arcanist
- Self-Hosted GitHub Enterprise Server
- Summary of Niche Platforms

### Chapter 10: Authentication, Authorization, and Identity

`content/03-capabilities/01-identity/`

- Authentication Methods: Password, SSH Keys, OAuth, SAML
- LDAP, Active Directory, and Enterprise Identity Integration
- Role-Based Access Control and Fine-Grained Permissions
- SSH Key Management at Scale
- Multi-Factor Authentication and Hardening

### Chapter 11: Repository Governance, Branching Strategies, and Collaboration Models

`content/03-capabilities/02-governance/`

- Branching Models: Git Flow, Trunk-Based, GitHub Flow
- Protecting Branches and Enforcing Policies
- Code Owners and Review Requirements
- Monorepos vs Polyrepos: Architectural Trade-Offs
- Conventional Commits and Structured History
- Governance Tools and Automation

### Chapter 12: CI/CD Integration and Automation

`content/03-capabilities/03-cicd/`

- Webhooks: The Universal Glue
- Native CI Systems: GitLab CI, GitHub Actions, Gitea Actions
- External CI: Jenkins, Drone, Cirrus, and Buildkite
- Pipeline Architecture and Design Patterns
- Runners, Executors, and Build Infrastructure
- GitOps: Using Git as the Source of Truth for Infrastructure

### Chapter 13: Package and Artifact Management

`content/03-capabilities/04-packages/`

- Container Registries: GitLab Registry, Harbor, and Alternatives
- Language-Specific Package Managers
- Artifact Storage and Retention Policies
- Integration with CI Pipelines
- Self-Hosted Registry Architecture

### Chapter 14: Security and Supply Chain Protection

`content/03-capabilities/05-security/`

- Git-Level Security: Signed Commits, Tags, and Verifications
- Dependency Scanning and Vulnerability Management
- Software Bill of Materials and SBOM Generation
- Secrets Detection and Management
- Supply Chain Attacks: Lessons from Real Incidents
- Platform-Level Security Hardening

### Chapter 15: Decentralized, Federated, and Experimental Models

`content/03-capabilities/06-federation/`

- Git’s Native Distribution as a Decentralization Primitive
- Federated Hosting and Cross-Instance Collaboration
- Are We Ready for Decentralized Code Hosting?

### Chapter 16: Storage, Performance, and Scalability

`content/04-operations/01-storage-and-scale/`

- Git Repository Growth: When Does Size Become a Problem?
- Storage Options: Local, NFS, Ceph, S3-Compatible
- Cloning and Fetch Performance
- Database Scaling for Git Platforms
- CDN Strategies and Geo-Distributed Hosting
- Benchmarks and Performance Profiles

### Chapter 17: High Availability, Backup, and Disaster Recovery

`content/04-operations/02-ha-and-dr/`

- Backup Strategies: Bare Clones, Dumps, and Replication
- Point-in-Time Recovery and Versioning
- Geo-Redundant and Multi-Region Deployments
- Disaster Recovery Planning for Git Infrastructure
- Monitoring and Alerting for Repository Health

### Chapter 18: Observability, Logging, and Auditing

`content/04-operations/03-observability/`

- Operational Metrics: What to Measure and Why
- Log Aggregation and Analysis
- Audit Logging for Compliance
- Tracing User Actions Across the Platform
- Compliance Frameworks: SOC2, ISO 27001, GDPR
- Security Monitoring and Incident Response

### Chapter 19: Enterprise Deployment, Compliance, and Air-Gapped Environments

`content/04-operations/04-enterprise-and-airgap/`

- Air-Gapped and Offline Deployments
- Multi-Cloud and Hybrid Architectures
- Compliance and Data Residency Requirements
- Enterprise Support and SLAs
- Capacity Planning and TCO Analysis

### Chapter 20: Migration, Interoperability, and Emerging Trends

`content/05-choice/01-migration-and-future/`

- Migration Strategies: Tools and Processes
- Preserving History, Permissions, and Metadata
- Interoperability Between Platforms
- Emerging Trends: AI-Assisted Development, Enhanced Collaboration, Ecosystem Evolution
- Making Your Choice: A Decision Framework
- The Future of Code Hosting

---

## Not started yet

- Chapter files and labs
- `index.qmd` rewrite
- Wipe of old `content/01-git/` … `04-forges/`
- `books/AGENTS.md` / `VCS/README.md` blurb
- `scripts/update-index.sh` until the first writing pass creates dirs
