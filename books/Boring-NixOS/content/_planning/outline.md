# Boring NixOS — Curriculum & Outline

**Subtitle:** From Zero to Production — Reproducible Systems at Scale

## Introduction: The Reproducibility Crisis
- The Heisenbugs That Cost Teams
- Why Traditional Tooling Fails
- A Different Approach: Declarative, Immutable Infrastructure
- What This Book Will Teach You

## Chapter 1: Nix Fundamentals — How It Actually Works
- The Store Model and Content-Addressable Paths
- How Hashes Create Deterministic Dependencies
- Dependency Graphs and the Nix Database
- Garbage Collection and Space Management
- Your First Nix Expressions

## Chapter 2: The Nix Language — From Basics to Advanced Patterns
- Expressions, Values, and Types
- Let-In Blocks and Local Bindings
- Functions and Argument Defaults
- Attribute Sets and Recursive Definitions
- Conditionals, Lists, and Comprehensions
- Importing Files and Building Abstractions

## Chapter 3: Reproducible Development Environments
- Nix Shells and the devShell Concept
- Multi-Language Development Environments
- Flakes for Reproducible Dev Environments
- Environment Management with Home Manager
- Migrating from Docker Desktop to Nix DevShells

## Chapter 4: Package Management and Overlays
- The Nix Package Manager in Practice
- Understanding the Flakes Input System
- Creating and Composing Overlays
- Custom Package Definitions
- Managing Dependencies Across Projects

## Chapter 5: Building Packages from Source
- The Derivation Build Process
- Building C and C++ Projects with CMake
- Rust Packages with Cargo
- Python Packages with Pip and Setuptools
- Go Modules and Node.js Packages
- Cross-Compilation for Multiple Platforms

## Chapter 6: NixOS — Declarative System Configuration
- The NixOS Module System Architecture
- Configuring Your First NixOS Machine
- Service Management with systemd
- Networking, Firewall, and Security
- Users, Groups, and SSH Configuration
- Hardware Configuration and Drivers

## Chapter 7: Home Manager — User-Level Declarative Configuration
- Home Manager and the Module System
- Managing Dotfiles Declaratively
- Shell and Editor Configuration
- Application Settings and Preferences
- Combining NixOS and Home Manager

## Chapter 8: CI/CD with Nix — Build Pipelines That Actually Work
- Setting Up Binary Caches
- GitHub Actions with Nix
- GitLab CI Integration
- Build Caching Strategies
- Testing in CI Pipelines
- Secrets Management in CI

## Chapter 9: Containers and Kubernetes with Nix
- Creating Container Images with Nix
- Kubernetes Manifests as Nix Modules
- Helm Charts Generated from Nix
- GitOps with Argo CD and Flux
- Service Mesh and Observability

## Chapter 10: Infrastructure as Code — Terraform, OpenTofu, and Beyond
- Managing Terraform Providers with Nix
- OpenTofu Integration
- Ansible Provisioning with Nix
- Cloud Provider Configuration
- Multi-Cloud Deployment Patterns

## Chapter 11: Secrets Management and Security
- Why Secrets Are Hard with Declarative Config
- Using SOPS for Encrypted Configuration
- Hashicorp Vault Integration
- Age Encryption for Simple Secrets
- Security Hardening Patterns

## Chapter 12: Platform Engineering at Scale
- The Internal Developer Platform Pattern
- Monorepo Strategies with Nix
- Multi-Platform Development and Distribution
- Build Optimization and Performance Tuning
- Debugging and Troubleshooting Production Issues
- Testing Strategies for Nix Configurations
- Maintenance, Upgrades, and Migration
- Enterprise Operational Checklists
