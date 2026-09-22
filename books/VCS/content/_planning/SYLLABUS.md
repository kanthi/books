# VCS: Architectures, Platforms, Operations, and GitOps

**Subtitle:** From Git fundamentals to hosting platforms, automation, and GitOps at scale  
**Path:** `books/VCS/`  
**Status:** TOC frozen. **Core Git (Parts I–II) deepened** to chapters 1–15. **Prose:** original pages in chapters 1–15, plus chapter 7 in full (reset, restore, checkout) and chapter 25 in full (Gitea and Forgejo). Chapters 4 and 5, and the extra tail pages in the other core chapters, are still stubs. Later parts are stubs except chapter 25. Linux is the primary host.

This file is the single table of contents. It consolidates the two source outlines (25-chapter compressed book + 63-chapter complete guide) into one progressive journey.

Old syllabi: `archive/SYLLABUS-git-github-jj-forges.md`, `archive/SYLLABUS-hosting-20ch.md`.

---

## Book shape (Quarto)

`index.qmd` is the door (front matter). Nine parts. Each chapter is one section directory. The first page is always `00-theory.qmd`. Each remaining bullet is one page.

| Part | Dir | Chapters |
|------|-----|----------|
| Front matter | `index.qmd` | unnumbered door |
| I Git Foundations | `content/01-git-foundations/` | 1–5 |
| II Everyday Git Workflows | `content/02-everyday-workflows/` | 6–15 |
| III Power Skills, Internals, Recovery | `content/03-power-skills/` | 16–21 |
| IV Hosting Platforms | `content/04-platforms/` | 22–29 |
| V Operating a Git Platform | `content/05-operating/` | 30–40 |
| VI GitHub Actions | `content/06-github-actions/` | 41–42 |
| VII GitOps Foundations | `content/07-gitops/` | 43–44 |
| VIII Argo CD in Depth | `content/08-argo-cd/` | 45–54 |
| IX Progressive Delivery | `content/09-argo-rollouts/` | 55–66 |
| Appendices | `content/99-appendices/` | A–E |

---

## Writing rules (when content starts)

- **Reader:** first-time learner to GitOps practitioner (software engineers, DevOps, platform/SRE). Define terms on first use. Depth ramps: user → installer → admin → operator → GitOps.
- **Host:** **Linux is the primary target.** Paths, package managers, `chmod`, `sed -i`, systemd-adjacent notes, and credential helpers (`libsecret`) are Linux. Other operating systems are out of scope unless a protocol URL requires a one-line mention.
- **Independence:** this book stands alone. Minimum SSH, container, Kubernetes, and reverse-proxy facts live here.
- **Replace the old book:** wipe `content/01-git/`, `02-github/`, `03-jj/`, `04-forges/` at the start of the first writing pass. Jujutsu is a short emerging-trends mention only.
- **Labs:** Git chapters use a tiny desk project. Platform chapters 24–29 each get an equal shallow lab (account or compose). GitOps parts use Docker, kind or K3s, kubectl, Helm.
- **Recurring desk repos:** `desk-web`, `desk-api`, `desk-infra`.
- **No reteaching:** developer Git stays in Parts I–III. Platform chapters do not restart Git. Git-level security (Ch 20) vs platform supply chain (Ch 34). Branching as a *workflow* (Ch 15) vs *enforcement* (Ch 31). CI as a forge capability (Ch 32) vs Actions as a product (Part VI) vs GitOps engines (Parts VII–IX).
- **Overlap:** Ch 23 *names* a platform component; Part V *operates* it.
- **Theory:** every chapter directory starts with `00-theory.qmd` (sidebar **Theory**). It states invariants, a mental-model diagram, what can break, and how later pages in that chapter are applications of the theory. Commands come after theory, not instead of it.
- **Local render:** HTML only until core prose is done (`content/_planning/html-only`). `./indipub.sh VCS` skips PDF/EPUB. CI is unchanged.

---

## Front matter — `index.qmd`

- Why this book exists
- Who this book is for (software engineers, DevOps, platform/SRE, GitOps practitioners)
- What you will master
- How to read this so it sticks
- The companion kit: Docker, kind or K3s, kubectl, Helm, Git
- Conventions and heredoc usage
- Acknowledgements

---

## Part I: Git Foundations

`content/01-git-foundations/`

### Chapter 1 — The Git Mental Model

`01-mental-model/`

- The version control landscape
- The directed acyclic graph (DAG)
- The three-tree model and the staging area
- Object types: blob, tree, commit, tag
- References: branches, tags, and HEAD
- The distributed model and its implications
- Detached HEAD
- Revisions and ranges (`HEAD~`, `HEAD^`, `A..B`, `A...B`)

### Chapter 2 — Installation and Configuration

`02-install-and-config/`

- Installing Git and getting the right tools
- Config layers: system, global, local
- Identity, email, and essential settings
- Authentication: SSH vs HTTPS
- Editor, pager, and difftool on Linux
- Aliases
- Updating Git on Linux

### Chapter 3 — Your First Repository

`03-first-repository/`

- Initializing a repository
- The add/commit cycle
- `git status`, `git log`, `git diff` (and DiffTool)
- Undoing mistakes
- Hands-on: build a tiny project
- `.gitignore` in depth
- Interactive add (`git add -p`)
- `git rm` and `git mv`
- What not to commit

### Chapter 4 — Inspecting History

`04-inspecting-history/`

- Advanced `git log`
- Two-dot and three-dot ranges
- `git show` and `--stat`
- `git blame`
- Pickaxe (`-S`, `-G`) and `--follow`
- `git shortlog`
- Hands-on: history archaeology

### Chapter 5 — Ignore Files, Attributes, and Git LFS

`05-ignore-attributes-lfs/`

- gitignore patterns, global excludes, `.git/info/exclude`
- `gitattributes` (text/binary, eol, filters)
- `export-ignore` and `git archive`
- Git LFS: pointers, `git lfs install`, what a forge stores
- Hands-on: ignore and LFS

---

## Part II: Everyday Git Workflows

`content/02-everyday-workflows/`

### Chapter 6 — Commits and History Management

`01-commits-and-history/`

- Commit anatomy
- Commit messages that matter: Conventional Commits
- Amending and fixing an incorrect commit message
- Unstaging an added file
- Hands-on: amend and rewrite a commit
- Commit templates
- Empty commits and splitting a commit
- Trailers and `.mailmap`
- Reading a commit with `git show`

### Chapter 7 — Reset, Restore, and Checkout

`02-reset-restore-checkout/`

- Soft, mixed, and hard reset (which trees move)
- `restore` vs `reset` vs `revert`
- Resetting paths
- `switch`, `restore`, and old `checkout`
- Hands-on: reset lab

### Chapter 8 — Branching and Merging

`03-branching-and-merging/`

- Branch to create a safe working area
- Merge types: fast-forward, recursive, octopus
- Three-way merge
- Merge conflicts: in Git and in teams
- Creating a fast-forward merge for a clean history
- Hands-on: simulate a real merge conflict
- `mergetool`
- `--ours` / `--theirs` and rename detection
- Orphan branches
- Comparing branches (`A..B`, `A...B`, merge-base)
- `rerere`

### Chapter 9 — Rebasing and Rewriting History

`04-rebasing/`

- Why rebase? Clean history vs merge commits
- Interactive rebase: squash, reorder, fixup, polish
- Rebase conflicts: how they differ from merge conflicts
- Pull with rebase when your branch is out of date
- The debate: rebase vs merge
- Hands-on: clean up a messy history
- `rebase --onto`
- `autosquash` and `commit --fixup`
- `rebase --exec`
- `--update-refs` and `--keep-base` (stacked branches)

### Chapter 10 — Cherry-Pick, Revert, and Undoing Merges

`05-cherry-pick-and-revert/`

- Cherry-pick: moving commits surgically; backporting fixes
- Deploying hotfixes without merging features
- `git revert` and unmerging changes
- Real production emergency scenarios
- Ranges and `-x`
- Empty picks and `--skip`

### Chapter 11 — Remotes and Collaboration

`06-remotes/`

- Remote mechanics: fetch, pull, push
- Multiple remotes; tracking branches
- Force-push dangers
- Pull requests, code review, and handling conflicts in teams
- Hands-on: fork, clone, branch, commit, push, and PR
- Tracking and upstream (`@{u}`)
- Refspecs
- `git bundle` (sneakernet / air-gap)
- Prune and rename remotes
- Forks vs clones

### Chapter 12 — Stashing, Tagging, and Cleanup

`07-stash-tags-cleanup/`

- Stash mechanics, including patch stashes
- Tags: lightweight vs annotated
- Cleanup commands
- Hands-on: stash, work on another branch, apply
- `git stash branch`
- `git describe`
- `git archive`

### Chapter 13 — Git Hooks and Automation

`08-hooks/`

- Hook types: pre-commit, commit-msg, pre-push
- Writing your first hook; hook templates
- CI/CD integration (client-side; forge CI is Ch 32)
- Hands-on: create a pre-commit hook
- `prepare-commit-msg`
- `post-checkout` and `post-merge`
- `--no-verify`

### Chapter 14 — Submodules and Worktrees

`09-submodules-and-worktrees/`

- Submodule mechanics: add, update, clone; common pitfalls
- Git worktrees: the modern alternative
- When to use which
- Hands-on: a repo with a submodule and a worktree
- `foreach` and `sync`
- `deinit` and `absorbgitdirs`
- Worktree locks and `prune`

### Chapter 15 — Advanced Branching Workflows

`10-branching-workflows/`

- Git Flow
- GitHub Flow and trunk-based development
- Feature flags and deployment
- Monorepos vs polyrepos (developer view)
- Choosing a strategy
- The forking workflow
- Stacked changes
- Release tags and changelogs

---

## Part III: Power Skills, Internals, and Recovery

`content/03-power-skills/`

### Chapter 16 — Git Internals

`01-internals/`

- The object store: blobs, trees, commits, tags in `.git/objects`
- SHA-1, SHA-256, and content addressing
- Packfiles, compression, and how `git log` works under the hood
- Internals that affect server design (preview of Ch 23)
- Hands-on: explore the object store with `git cat-file`

### Chapter 17 — The Reflog: Recovering Lost Work

`02-reflog/`

- How the reference log works
- Recover deleted branches in seconds
- The 30-day safety window
- Real recovery scenarios, step by step

### Chapter 18 — Bisect: Finding Bugs

`03-bisect/`

- Binary search to hunt bugs and regressions
- Automate with your test suite
- 2 AM production debugging example
- Hands-on: find a regression with `git bisect`

### Chapter 19 — Performance and Scale

`04-performance-and-scale/`

- Large repositories: what “large” means and common bottlenecks
- Shallow clones, sparse checkout, and partial clones
- Performance tuning with `git config`

### Chapter 20 — Git-Level Security and Best Practices

`05-git-security/`

- Signed commits and tags: GPG and SSH
- Secrets in history: removal and prevention
- Audit trails at the Git layer
- Security scanning: pre-commit and CI integration
- Hands-on: remove a committed secret

### Chapter 21 — Troubleshooting and Repository Repair

`06-troubleshooting/`

- Corrupted repositories: `git fsck` and repair
- Common error patterns: causes and fixes
- Recovery procedures
- Hands-on: simulate a corrupted repo and recover

---

## Part IV: Hosting Platforms and Architectures

`content/04-platforms/`

### Chapter 22 — The GitHub Monoculture Problem

`01-github-monoculture/`

- How GitHub became the default
- Risks of platform lock-in
- The regulatory and geopolitical dimension
- What “beyond GitHub” actually means
- A framework for this part

### Chapter 23 — The Architecture of a Git Hosting Platform

`02-platform-architecture/`

- Git alone vs Git hosting
- Core platform components
- The protocol stack: SSH, HTTP, and Git smart protocols
- Storage architectures: filesystem, distributed storage, object stores
- Authentication, authorization, and identity integration (the component)
- Extensibility: webhooks, APIs, plugins
- Architectural styles: monolith vs microservices
- Operational complexity: the hidden cost

### Chapter 24 — GitLab, the Full-Stack Platform

`03-gitlab/`

- History and philosophy
- Architecture: Omnibus, monolith, Kubernetes
- Feature set: CI/CD, registry, security, DevOps
- Operational requirements, scaling, and licensing (FOSS vs Premium)
- Hands-on: GitLab CE compose or gitlab.com
- When GitLab is the right choice

### Chapter 25 — Gitea and Forgejo, Lightweight and Community-Driven

`04-gitea-and-forgejo/`

- Origins and design philosophy; Go, SQLite, single-binary simplicity
- The Forgejo fork: why it happened and what changed
- Comparison: Gitea vs Forgejo vs GitLab
- Deployment patterns; scaling limits and workarounds
- Hands-on: Gitea compose and Forgejo compose
- When Gitea or Forgejo is the right choice

### Chapter 26 — Bitbucket, Enterprise and Cloud Integration

`05-bitbucket/`

- Bitbucket Cloud vs Bitbucket Data Center
- Architecture and deployment models
- Jira and the Atlassian ecosystem
- Branch permissions, Code Insights, audit logs
- Comparison with GitLab and GitHub
- Hands-on: Bitbucket Cloud
- When Bitbucket fits

### Chapter 27 — Gerrit, Code Review as a First-Class Citizen

`06-gerrit/`

- What Gerrit actually is; the review-centric model
- Change-Ids, drafts, and approval chains
- Integration with Jenkins, CI, and other tools
- Operational considerations: performance and complexity
- Gerrit in practice: Android, Kubernetes, and other major projects
- Hands-on: Gerrit compose — one change, one review
- When Gerrit is the right choice

### Chapter 28 — SourceHut, Minimalist Philosophy and Tools

`07-sourcehut/`

- Philosophy: tools, not platforms
- The sr.ht suite: Git, issues, mailing lists, CI
- Architecture: Python, mail-driven workflows, hook scripts
- Comparison with feature-rich platforms
- Hands-on: sourcehut.org or a documented subset self-host
- When SourceHut makes sense

### Chapter 29 — Other Notable Solutions and Niche Platforms

`08-niche-platforms/`

- Codeberg and community-run instances (hands-on: Codeberg account)
- GitBucket and GitHub-compatible alternatives
- Gogs: the ancestor of Gitea
- Phabricator / Phorge and Arcanist
- Self-hosted GitHub Enterprise Server
- Summary of niche platforms

---

## Part V: Operating a Git Platform

`content/05-operating/`

### Chapter 30 — Authentication, Authorization, and Identity

`01-identity/`

- Password, SSH keys, OAuth, SAML
- LDAP, Active Directory, and enterprise identity
- RBAC and fine-grained permissions
- SSH key management at scale
- Multi-factor authentication and hardening

### Chapter 31 — Repository Governance and Policy Enforcement

`02-governance/`

- Branching models revisited: enforcement implications
- Protecting branches; code owners and review requirements
- Monorepo vs polyrepo trade-offs (operator view)
- Conventional commits, structured history, and governance automation

### Chapter 32 — CI/CD Integration and Automation

`03-cicd/`

- Webhooks: the universal glue
- Native CI: GitLab CI, GitHub Actions, Gitea Actions
- External CI: Jenkins, Drone, Cirrus, Buildkite
- Pipeline architecture, runners, executors, and build infrastructure
- GitOps preview: Git as the source of truth (full treatment in Part VII)

### Chapter 33 — Package and Artifact Management

`04-packages/`

- Container registries: GitLab Registry, Harbor, and alternatives
- Language-specific package managers
- Artifact storage, retention policies, and CI integration
- Self-hosted registry architecture

### Chapter 34 — Security and Supply Chain Protection

`05-security/`

- Git-level security revisited on the server: signed commits, tags, verification
- Dependency scanning and vulnerability management
- Software Bill of Materials (SBOM)
- Secrets detection and management
- Supply chain attacks: lessons from real incidents
- Platform-level security hardening

### Chapter 35 — Decentralized, Federated, and Experimental Models

`06-federation/`

- Git’s native distribution as a decentralization primitive
- Federated hosting and cross-instance collaboration
- Are we ready for decentralized code hosting?

### Chapter 36 — Storage, Performance, and Scalability

`07-storage-and-scale/`

- Repository growth: when size becomes a problem
- Storage options: local, NFS, Ceph, S3-compatible
- Cloning and fetch performance
- Database scaling for Git platforms
- CDN strategies and geo-distributed hosting
- Benchmarks and performance profiles

### Chapter 37 — High Availability, Backup, and Disaster Recovery

`08-ha-and-dr/`

- Backup strategies: bare clones, dumps, and replication
- Point-in-time recovery and versioning
- Geo-redundant and multi-region deployments
- Disaster recovery planning
- Monitoring and alerting for repository health

### Chapter 38 — Observability, Logging, and Auditing

`09-observability/`

- Operational metrics: what to measure and why
- Log aggregation and analysis
- Audit logging for compliance
- Tracing user actions across the platform
- Compliance frameworks: SOC 2, ISO 27001, GDPR
- Security monitoring and incident response

### Chapter 39 — Enterprise Deployment, Compliance, and Air-Gapped Environments

`10-enterprise-and-airgap/`

- Air-gapped and offline deployments
- Multi-cloud and hybrid architectures
- Compliance and data residency
- Enterprise support and SLAs
- Capacity planning and TCO analysis

### Chapter 40 — Migration, Interoperability, and Emerging Trends

`11-migration-and-future/`

- Migration strategies: tools and processes
- Preserving history, permissions, and metadata
- Interoperability between platforms
- Emerging trends: AI-assisted development, collaboration, ecosystem evolution
- Making your choice: a decision framework
- The future of code hosting

---

## Part VI: CI/CD Automation with GitHub Actions

`content/06-github-actions/`

### Chapter 41 — GitHub Actions Fundamentals

`01-fundamentals/`

- Automate tasks in GitHub with Actions
- Workflow anatomy: events, jobs, steps
- The workflow runtime and environment contexts
- Authoring, debugging, and validating workflows
- Building and validating your code

### Chapter 42 — Custom Actions, Runtime, and Releases

`02-custom-actions-and-releases/`

- Building custom GitHub Actions
- Reuse, matrix, cache, artifacts, secrets, and environments
- Releasing software with Actions
- Security notes: pinning, `GITHUB_TOKEN`, OIDC (full supply-chain is Ch 34)

---

## Part VII: GitOps Foundations

`content/07-gitops/`

### Chapter 43 — What Is GitOps and Why It Matters

`01-what-is-gitops/`

- Common DevOps pain points: manual kubectl, script proliferation, security gaps
- The four pillars of GitOps
- Deploy faster, recover faster, secure deployments, self-documenting systems
- Push-based vs pull-based deployments
- Environment repositories; multiple apps and environments; preview environments
- Trunk-based development vs pull requests in a GitOps world
- GitOps vs DevOps, CIOps, NoOps
- When to use GitOps vs traditional CI/CD; common misconceptions

### Chapter 44 — GitOps Quickstart with Flux

`02-flux-quickstart/`

- Application and environment repositories
- Continuous delivery pipeline with GitHub Actions
- Flux Operator on Kubernetes: install and pull-based deployment
- The future of GitOps (and why Part VIII is Argo CD)

---

## Part VIII: Argo CD in Depth

`content/08-argo-cd/`

### Chapter 45 — Argo CD Concepts and Architecture

`01-concepts-and-architecture/`

- Where Argo CD came from, and why that gap existed
- What Argo CD actually does: reconciliation and immutable infrastructure
- The five-step reconciliation loop; declare outcomes, not steps
- The components: API server, application controller, repo server, Redis, Dex, ApplicationSet controller, Web UI, CLI
- Applications and projects; how Git becomes manifests
- How a change travels from Git to the cluster
- Desired vs actual state, sync status, and sync history

### Chapter 46 — Installing Argo CD and Standing Up the Lab

`02-install-and-lab/`

- Two servers, a cluster, and an app to deploy
- Installing K3s (or kind); kubeconfig; kubectl
- Install methods: full, minimal (core), custom, Helm, Kustomize
- Reaching the Web UI; CLI; token login; adding clusters

### Chapter 47 — Your First Application and Sync Policy

`03-applications-and-sync/`

- Creating an application via CLI vs declarative manifests
- Sync policy: auto-sync, self-healing, jitter, cluster drift
- Pruning, exceptions, propagation policy, and garbage collection
- Retries and backoff; ignoring differences; selective sync; replace vs merge; server-side apply
- Namespace automation, labels, history limits
- Recap exercise

### Chapter 48 — Cluster Management and State Comparison

`04-clusters-and-diff/`

- In-cluster vs external clusters; registration and discovery
- Git polling vs webhook-based synchronization
- Desired vs actual state: diff algorithms and change detection
- Application health and monitoring

### Chapter 49 — Sync Phases, Hooks, and Waves

`05-hooks-and-waves/`

- How a sync runs in phases; a first PostSync smoke test
- `generateName` vs `name`; hook cleanup; ordering with sync waves
- What happens when a hook fails
- Hook anti-patterns and the `BeforeHookCreation` trap

### Chapter 50 — Local Users and RBAC

`06-users-and-rbac/`

- Creating a user is two unrelated operations
- Accounts; the `p` line and the `g` line; project scoping
- Verifying grants

### Chapter 51 — Argo CD with Helm

`07-helm/`

- Helm vs plain Kubernetes resources
- Creating, packaging, and versioning charts; Helm repositories
- Deploying and upgrading charts; overriding values; multiple sources
- Helm hooks vs Argo CD hooks

### Chapter 52 — ApplicationSets, App-of-Apps, and Repository Patterns

`08-applicationsets-and-patterns/`

- The problem ApplicationSets solve; list generator and beyond
- The app-of-apps pattern; repository patterns for GitOps
- Multi-branch CI/CD: one application per Git branch
- Build → registry → Helm package → application update

### Chapter 53 — Notifications, Secrets, and Blue-Green with Argo CD

`09-notifications-secrets-bluegreen/`

- Slack notifications for sync events
- Secret management strategies
- Blue-green deployments with Argo CD

### Chapter 54 — Argo CD vs the Alternatives

`10-argo-vs-alternatives/`

- Argo CD vs Flux, Tekton, Jenkins X, Spinnaker
- Choosing your GitOps engine

---

## Part IX: Progressive Delivery with Argo Rollouts

`content/09-argo-rollouts/`

### Chapter 55 — Introducing Argo Rollouts

`01-introducing-rollouts/`

- Where Kubernetes RollingUpdate stops and progressive delivery begins
- Canary and blue-green fundamentals
- Gradual releases and deployment risk

### Chapter 56 — Rollout Resources and Lifecycle

`02-resources-and-lifecycle/`

- Rollout vs Deployment; the controller; ReplicaSets
- Stable and canary versions; the rollout lifecycle
- AnalysisTemplates, experiments, and resource relationships

### Chapter 57 — Building the Rollouts Lab

`03-rollouts-lab/`

- Docker, kind, Argo CD, Argo Rollouts
- Services, rollout manifests, GitOps deployment, verifying state

### Chapter 58 — Your First Canary Release

`04-first-canary/`

- Canary strategy and steps; traffic progression and pauses
- Promotion, abortion, and rollout inspection

### Chapter 59 — Traffic-Based Canaries with Istio

`05-istio-canaries/`

- Istio traffic management: Gateway, VirtualService, DestinationRule
- Stable and canary subsets; weighted canary traffic
- Replica-based vs traffic-based routing

### Chapter 60 — Validating Releases with AnalysisTemplates and Prometheus

`06-analysis-and-prometheus/`

- AnalysisTemplate and AnalysisRun; Prometheus queries
- Success and failure conditions; automatic aborts
- Inline vs background analysis

### Chapter 61 — Rollout Experiments

`07-experiments/`

- Running versions side by side; experiment templates
- Analysis during experiments; lifecycle and failed experiments
- Experiments vs AnalysisTemplates

### Chapter 62 — HPA and Canary Interactions

`08-hpa-and-canary/`

- HPA with replica-based canaries
- Metrics server, CPU load, and canary scaling
- Istio routing and `setCanaryScale`

### Chapter 63 — Blue-Green Deployments

`09-blue-green/`

- Active and preview services; the blue-green lifecycle
- Pre-promotion and post-promotion analysis
- Manual and automatic promotion; rollback behavior

### Chapter 64 — Rollout Notifications with Slack

`10-rollout-notifications/`

- Notification architecture and scope (namespace vs cluster)
- Triggers, templates, subscriptions, and Slack configuration
- Troubleshooting notifications

### Chapter 65 — Migrating Existing Deployments to Rollouts

`11-migrating-to-rollouts/`

- Migration strategies and `workloadRef`
- Direct conversion and Argo CD synchronization
- Canary migration, aborts, retries, scaling down the old Deployment
- StatefulSet limitations

### Chapter 66 — Capstone: Where to Go From Here

`12-capstone/`

- A working mental model, end to end
- Progressive delivery in larger environments

---

## Appendices

`content/99-appendices/`

### Appendix A — Understanding questions and answers

Four focused questions with detailed answers after each part.

### Appendix B — Git competency checklists

- Level 1: 6 essential skills everyone needs
- Level 2: 5 power skills (reflog, interactive rebase, cherry-pick, bisect, Conventional Commits)
- Level 3: 5 advanced specialist topics

### Appendix C — Real-world scenario playbook

- Sanjay’s deleted branch panic → recovered with reflog
- Ajay’s messy history → cleaned with interactive rebase
- Maya’s critical hotfix → deployed with cherry-pick
- The team’s mysterious production bug → fixed with bisect
- Professional commit messages

### Appendix D — Lab environment reference

Docker, kind/K3s, kubectl, Helm, Argo CD/Rollouts setup; heredoc and shell conventions.

### Appendix E — Command quick reference and glossary

---

## How the two outlines were merged

1. **Spine is the 63-chapter guide.** The 25-chapter outline is the same journey at coarser grain (platforms in one chapter, all of Rollouts in one chapter). Unique bullets from the short outline (Flux Operator, Istio VirtualService/DestinationRule, `setCanaryScale`, `workloadRef`, hook anti-patterns, `p`/`g` RBAC lines, Sanjay/Ajay/Maya scenarios) are sections inside the matching long-outline chapters.
2. **Git is one path.** Reflog, rebase, cherry-pick, bisect, hooks, stash, and internals each appear once (Parts I–III). Workbook lessons became hands-on sections.
3. **Branching is split by audience.** Developer workflows in Ch 15; platform enforcement in Ch 31.
4. **CI is split three ways.** Forge-level integration (Ch 32), GitHub Actions as a product (Part VI), GitOps engines (Parts VII–IX).
5. **Security is split two ways.** Git-level (Ch 20) and platform/supply chain (Ch 34).
6. **Two Argo CD books → Part VIII.** Architecture, install, sync, hooks, RBAC, Helm, ApplicationSets, patterns, comparison: one progression.
7. **Learning framework → appendices** so Q&A, checklists, and scenarios serve the whole book.
8. **Front matter lives in `index.qmd`**, not as numbered chapters.
9. **Jujutsu and the old four-part VCS tree are out of the sidebar.** Mention Jujutsu only under emerging trends if at all.

---

## Writing progress

- **Done:** Parts I–II original prose; **core TOC deepened** (chs 1–15) with new stub sub-pages; Parts III–IX + appendices scaffolded.
- **Prose remaining:** new core sub-pages (stubs); Parts III–IX; appendices.
