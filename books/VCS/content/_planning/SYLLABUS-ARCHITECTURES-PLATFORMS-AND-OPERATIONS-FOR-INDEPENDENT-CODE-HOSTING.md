# Architectures, Platforms and Operations for Independent Code Hosting
## Syllabus & Curriculum Specification

> **Track:** Independent Code Hosting, Git Forge Architecture & Platform Operations  
> **Host Platform:** Linux (POSIX shell, systemd, containers, reverse proxies)  
> **Status:** Accepted Syllabus & Canonical Architecture Map  
> **Reference Path:** `books/VCS/` (Parts IV & V; Foundations in Parts I–III)

---

## Purpose and Scope

This curriculum delivers an authoritative, production-grade guide to designing, deploying, securing, and operating independent, sovereign, and self-hosted Git forge infrastructure. It addresses the growing need for organizations to avoid single-vendor lock-in, meet strict regulatory and data-residency mandates, and operate air-gapped or high-availability code hosting systems.

The syllabus moves methodically from the geopolitical and technological drivers of independent hosting through platform architecture, deep comparative analysis of production forges (GitLab, Forgejo/Gitea, Bitbucket Data Center, Gerrit, SourceHut), identity and governance, to enterprise-scale operations, storage scaling, high availability, disaster recovery, and compliance.

---

## Detailed Table of Contents

### Chapter 1: The GitHub Monoculture Problem
- How GitHub Became Default
- Risks of Platform Lock-in
- The Regulatory and Geopolitical Dimension
- What “Beyond GitHub” Actually Means
- A Framework for This Book

### Chapter 2: Git Fundamentals for Infrastructure Engineers
- The Distributed Model and Its Implications
- Objects, References and Pack Files
- Remote Communication Protocols
- Hooks, Attributes and Configuration Layers
- Git Internals That Affect Server Design

### Chapter 3: The Architecture of a Git Hosting Platform
- Git Alone vs Git Hosting
- Core Platform Components
- The Protocol Stack: SSH, HTTP and Git Smart Protocols
- Storage Architectures: Filesystem, Distributed Storage and Object Stores
- Authentication, Authorization and Identity Integration
- Extensibility: Webhooks, APIs and Plugins
- Architectural Styles: Monolith vs Microservices
- Operational Complexity: The Hidden Cost

### Chapter 4: GitLab, The Full-Stack Platform
- History and Philosophy: From a Side Project to Enterprise Platform
- Architecture: Omnibus, Monolith and Kubernetes Deployment
- Feature Set: CI/CD, Registry, Security and DevOps Features
- Operational Requirements: Resource Profile and Scaling
- Licensing: FOSS vs Premium and What That Means
- When GitLab Is the Right Choice

### Chapter 5: Gitea and Forgejo, Lightweight and Community-Driven
- Gitea: Origins and Design Philosophy
- Architecture: Go, SQLite and Single-Binary Simplicity
- The Forgejo Fork: Why It Happened and What Changed
- Comparison: Gitea vs Forgejo vs GitLab
- Deployment Patterns for Small Teams and Personal Use
- Scaling Gitea: Limits and Workarounds
- When Gitea or Forgejo Is the Right Choice

### Chapter 6: Bitbucket, Enterprise and Cloud Integration
- Bitbucket Cloud vs Bitbucket Data Center
- Architecture and Deployment Models
- Jira and Atlassian Ecosystem Integration
- Enterprise Features: Branch Permissions, Code Insights, Audit Logs
- Comparison with GitLab and GitHub
- When Bitbucket Fits

### Chapter 7: Gerrit, Code Review as a First-Class Citizen
- What Gerrit Actually Is
- Architecture: The Review-Centric Model
- Workflow: Change IDs, Drafts and Approval Chains
- Integration with Jenkins, CI Systems and Other Tools
- Operational Considerations: Performance and Complexity
- Gerrit in Practice: Android, Kubernetes and Other Major Projects
- When Gerrit Is the Right Choice

### Chapter 8: SourceHut, Minimalist Philosophy and Tools
- SourceHut Philosophy: Tools, Not Platforms
- The sr.ht Suite: Git, Issues, Mailing Lists, CI
- Architecture: Python, Mail-Driven Workflows and Simplicity
- Extensibility and Automation via Hook Scripts
- Comparison with Feature-Rich Platforms
- When SourceHut Makes Sense

### Chapter 9: Other Notable Solutions and Niche Platforms
- Codeberg and Community-Run Instances
- GitBucket and GitHub-Compatible Alternatives
- Gogs: The Ancestor of Gitea
- Phabricator and Arcanist
- Self-Hosted GitHub Enterprise Server
- Summary of Niche Platforms

### Chapter 10: Authentication, Authorization and Identity
- Authentication Methods: Password, SSH Keys, OAuth, SAML
- LDAP, Active Directory and Enterprise Identity Integration
- Role-Based Access Control and Fine-Grained Permissions
- SSH Key Management at Scale
- Multi-Factor Authentication and Hardening

### Chapter 11: Repository Governance, Branching Strategies and Collaboration Models
- Branching Models: Git Flow, Trunk-Based, GitHub Flow
- Protecting Branches and Enforcing Policies
- Code Owners and Review Requirements
- Monorepos vs Polyrepos: Architectural Trade-Offs
- Conventional Commits and Structured History
- Governance Tools and Automation

### Chapter 12: CI/CD Integration and Automation
- Webhooks: The Universal Glue
- Native CI Systems: GitLab CI, GitHub Actions, Gitea Actions
- External CI: Jenkins, Drone, Cirrus and Buildkite
- Pipeline Architecture and Design Patterns
- Runners, Executors and Build Infrastructure
- GitOps: Using Git as the Source of Truth for Infrastructure

### Chapter 13: Package and Artifact Management
- Container Registries: GitLab Registry, Harbor and Alternatives
- Language-Specific Package Managers
- Artifact Storage and Retention Policies
- Integration with CI Pipelines
- Self-Hosted Registry Architecture

### Chapter 14: Security and Supply Chain Protection
- Git-Level Security: Signed Commits, Tags and Verifications
- Dependency Scanning and Vulnerability Management
- Software Bill of Materials and SBOM Generation
- Secrets Detection and Management
- Supply Chain Attacks: Lessons from Real Incidents
- Platform-Level Security Hardening

### Chapter 15: Decentralized, Federated and Experimental Models
- Git’s Native Distribution as a Decentralization Primitive
- Federated Hosting and Cross-Instance Collaboration
- Are We Ready for Decentralized Code Hosting?

### Chapter 16: Storage, Performance and Scalability
- Git Repository Growth: When Does Size Become a Problem?
- Storage Options: Local, NFS, Ceph, S3-Compatible
- Cloning and Fetch Performance
- Database Scaling for Git Platforms
- CDN Strategies and Geo-Distributed Hosting
- Benchmarks and Performance Profiles

### Chapter 17: High Availability, Backup and Disaster Recovery
- Backup Strategies: Bare Clones, Dumps and Replication
- Point-in-Time Recovery and Versioning
- Geo-Redundant and Multi-Region Deployments
- Disaster Recovery Planning for Git Infrastructure
- Monitoring and Alerting for Repository Health

### Chapter 18: Observability, Logging and Auditing
- Operational Metrics: What to Measure and Why
- Log Aggregation and Analysis
- Audit Logging for Compliance
- Tracing User Actions Across the Platform
- Compliance Frameworks: SOC2, ISO 27001, GDPR
- Security Monitoring and Incident Response

### Chapter 19: Enterprise Deployment, Compliance and Air-Gapped Environments
- Air-Gapped and Offline Deployments
- Multi-Cloud and Hybrid Architectures
- Compliance and Data Residency Requirements
- Enterprise Support and SLAs
- Capacity Planning and TCO Analysis

### Chapter 20: Migration, Interoperability and Emerging Trends
- Migration Strategies: Tools and Processes
- Preserving History, Permissions and Metadata
- Interoperability Between Platforms
- Emerging Trends: AI-Assisted Development, Enhanced Collaboration, Ecosystem Evolution
- Making Your Choice: A Decision Framework
- The Future of Code Hosting

---

## Mapping to the VCS Book Structure

In the consolidated 66-chapter VCS monorepo structure, this 20-chapter specialization curriculum is realized across **Part IV (Hosting Platforms and Architectures)**, **Part V (Operating a Git Platform)**, and the prerequisite infrastructure fundamentals in **Parts I–III**:

| 20-Chapter Track | Topic | Book Location / Directory | Book Chapter |
|---|---|---|---|
| **Ch 1** | The GitHub Monoculture Problem | `content/04-platforms/01-github-monoculture/` | Chapter 22 |
| **Ch 2** | Git Fundamentals for Infrastructure Engineers | `content/01-git-foundations/` & `content/03-power-skills/01-internals/` | Chapters 1, 2, 5, 11, 13, 16 |
| **Ch 3** | The Architecture of a Git Hosting Platform | `content/04-platforms/02-platform-architecture/` | Chapter 23 |
| **Ch 4** | GitLab, The Full-Stack Platform | `content/04-platforms/03-gitlab/` | Chapter 24 |
| **Ch 5** | Gitea and Forgejo, Lightweight and Community-Driven | `content/04-platforms/04-gitea-and-forgejo/` | Chapter 25 |
| **Ch 6** | Bitbucket, Enterprise and Cloud Integration | `content/04-platforms/05-bitbucket/` | Chapter 26 |
| **Ch 7** | Gerrit, Code Review as a First-Class Citizen | `content/04-platforms/06-gerrit/` | Chapter 27 |
| **Ch 8** | SourceHut, Minimalist Philosophy and Tools | `content/04-platforms/07-sourcehut/` | Chapter 28 |
| **Ch 9** | Other Notable Solutions and Niche Platforms | `content/04-platforms/08-niche-platforms/` | Chapter 29 |
| **Ch 10** | Authentication, Authorization and Identity | `content/05-operating/01-identity/` | Chapter 30 |
| **Ch 11** | Repository Governance, Branching Strategies and Collaboration Models | `content/05-operating/02-governance/` | Chapter 31 |
| **Ch 12** | CI/CD Integration and Automation | `content/05-operating/03-cicd/` | Chapter 32 |
| **Ch 13** | Package and Artifact Management | `content/05-operating/04-packages/` | Chapter 33 |
| **Ch 14** | Security and Supply Chain Protection | `content/05-operating/05-security/` | Chapter 34 |
| **Ch 15** | Decentralized, Federated and Experimental Models | `content/05-operating/06-federation/` | Chapter 35 |
| **Ch 16** | Storage, Performance and Scalability | `content/05-operating/07-storage-and-scale/` | Chapter 36 |
| **Ch 17** | High Availability, Backup and Disaster Recovery | `content/05-operating/08-ha-and-dr/` | Chapter 37 |
| **Ch 18** | Observability, Logging and Auditing | `content/05-operating/09-observability/` | Chapter 38 |
| **Ch 19** | Enterprise Deployment, Compliance and Air-Gapped Environments | `content/05-operating/10-enterprise-and-airgap/` | Chapter 39 |
| **Ch 20** | Migration, Interoperability and Emerging Trends | `content/05-operating/11-migration-and-future/` | Chapter 40 |
