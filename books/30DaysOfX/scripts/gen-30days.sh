#!/usr/bin/env bash
# gen-30days.sh — Generate 30DaysOfX content by combining 90DaysOfX chapters
set -euo pipefail

SRC90="$(cd ../90DaysOfX && pwd)"
DST30="$(pwd)"

combine_day() {
  local dest="$1"
  local title="$2"
  shift 2
  local sources=("$@")

  cat > "$dest" <<EOF
---
title: "$title"
date-modified: "2025-07-30"
---

# $title

EOF

  local first=true
  for src in "${sources[@]}"; do
    if [ ! -f "$src" ]; then
      echo "  WARNING: Source not found: $src" >&2
      continue
    fi

    if [ "$first" = true ]; then
      first=false
    else
      echo "" >> "$dest"
      echo "---" >> "$dest"
      echo "" >> "$dest"
    fi

    awk '
      BEGIN { in_fm=0; fm_done=0 }
      /^---[[:space:]]*$/ {
        if (fm_done == 0) {
          if (in_fm == 0) { in_fm=1; next }
          else { in_fm=0; fm_done=1; next }
        }
      }
      fm_done == 1 || in_fm == 0 && fm_done == 0 && NR > 1 { print }
    ' "$src" >> "$dest"
  done
}

echo "=== Generating Go Volume ==="
mkdir -p "$DST30/content/01-go"

cat > "$DST30/content/01-go/00-sub-book-overview.qmd" <<'GOOVERVIEW'
---
title: "Go — volume overview"
date-modified: "2025-07-30"
---

# Go — volume overview

An intensive 30-day sprint through Go programming, condensed from the 90-day curriculum. Each day combines ~3 original sessions for accelerated learners.

## Baseline

- **Go 1.26.x** (or latest stable)
- Editor with `gopls` LSP
- Terminal with `go` toolchain

## Four stages

| Stage | Days | Focus | Gate |
|-------|------|-------|------|
| **I — Core Language** | 1–8 | Toolchain, types, structs, interfaces, errors, testing | Gate I (Day 8) |
| **II — Concurrency & Generics** | 9–15 | Goroutines, channels, sync, generics, fuzzing | Gate II (Day 15) |
| **III — Stdlib & Services** | 16–22 | io, net/http, database/sql, REST, auth, gRPC | Gate III (Day 22) |
| **IV — Production & Capstone** | 23–30 | Profiling, containers, observability, architecture, capstone | Gate IV (Day 30) |

## Exit criteria

- Race-clean concurrent program with generics
- HTTP microservice with database, auth, and tests
- Profiled, containerized capstone application
- Understanding of Go architecture patterns
GOOVERVIEW

cat > "$DST30/content/01-go/01-syllabus.qmd" <<'GOSYLLABUS'
---
title: "Go Syllabus"
date-modified: "2025-07-30"
---

# Go — 30-day syllabus

Each day combines ~3 original 90-day chapters.

## Stage I — Core Language (Days 1–8)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 1 | Toolchain, variables, types & control flow | Days 1–3 |
| 2 | Functions, arrays & slices | Days 4–5 |
| 3 | Maps, structs & methods | Days 6–7 |
| 4 | Pointers, packages & Stage I review | Days 8–10 |
| 5 | Interfaces, type assertions & errors | Days 11–13 |
| 6 | Panic/recover & modules in depth | Days 14–15 |
| 7 | Testing: table-driven, fakes & mocks | Days 16–18 |
| **8** | **Gate I — Core language checkpoint** | Review |

## Stage II — Concurrency & Generics (Days 9–15)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 9 | Goroutines, channels & select | Days 19–21 |
| 10 | Sync primitives, worker pools & context | Days 22–24 |
| 11 | Race detector, concurrency patterns & errgroup | Days 25–27 |
| 12 | Memory model, integration & Stage III gate | Days 28–30 |
| 13 | Generics: type params, structs & judgment | Days 31–33 |
| 14 | Fuzzing, golden files & Go 1.26 quality | Days 34–37 |
| **15** | **Gate II — Concurrency & generics checkpoint** | Day 38 |

## Stage III — Stdlib & Services (Days 16–22)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 16 | io interfaces, bufio & encoding/json | Days 39–41 |
| 17 | os/exec, time & net basics | Days 42–44 |
| 18 | HTTP server, client & slog | Days 45–47 |
| 19 | Templates, httptest & Stage V gate | Days 48–50 |
| 20 | database/sql, migrations & REST design | Days 51–53 |
| 21 | Auth, validation & gRPC | Days 54–57 |
| **22** | **Gate III — Stdlib & services checkpoint** | Days 58–62 |

## Stage IV — Production & Capstone (Days 23–30)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 23 | Build tags, linting & profiling | Days 63–65 |
| 24 | Benchmarks, GC tuning & containers | Days 66–68 |
| 25 | Observability, CLI & security scanning | Days 69–72 |
| 26 | Architecture: boundaries & hexagonal design | Days 73, 75–76 |
| 27 | Config, graceful shutdown & feature flags | Days 77–79 |
| 28 | Load testing, security & capstone design | Days 80–82 |
| 29 | Capstone build — core to polish | Days 83–88 |
| **30** | **Gate IV — Capstone hardening & retrospective** | Days 89–90 |
GOSYLLABUS

GO_SRC="$SRC90/content/01-go"

combine_day "$DST30/content/01-go/02-day-01.qmd" "Day 1 — Toolchain, Variables, Types & Control Flow" \
  "$GO_SRC/02-day-01-toolchain-mental-model.qmd" "$GO_SRC/03-day-02-variables-types-constants.qmd" "$GO_SRC/04-day-03-control-flow.qmd"

combine_day "$DST30/content/01-go/03-day-02.qmd" "Day 2 — Functions, Arrays & Slices" \
  "$GO_SRC/05-day-04-functions.qmd" "$GO_SRC/06-day-05-slices.qmd"

combine_day "$DST30/content/01-go/04-day-03.qmd" "Day 3 — Maps, Structs & Methods" \
  "$GO_SRC/07-day-06-maps.qmd" "$GO_SRC/08-day-07-structs-methods.qmd"

combine_day "$DST30/content/01-go/05-day-04.qmd" "Day 4 — Pointers, Packages & Stage I Review" \
  "$GO_SRC/09-day-08-pointers-escape.qmd" "$GO_SRC/10-day-09-packages-layout.qmd" "$GO_SRC/11-day-10-stage-i-gate.qmd"

combine_day "$DST30/content/01-go/06-day-05.qmd" "Day 5 — Interfaces, Type Assertions & Errors" \
  "$GO_SRC/12-day-11-interfaces.qmd" "$GO_SRC/13-day-12-type-assert.qmd" "$GO_SRC/14-day-13-errors.qmd"

combine_day "$DST30/content/01-go/07-day-06.qmd" "Day 6 — Panic/Recover & Modules in Depth" \
  "$GO_SRC/15-day-14-panic-recover.qmd" "$GO_SRC/16-day-15-modules-deep.qmd"

combine_day "$DST30/content/01-go/08-day-07.qmd" "Day 7 — Testing: Table-Driven, Fakes & Stage II Gate" \
  "$GO_SRC/17-day-16-table-tests.qmd" "$GO_SRC/18-day-17-fakes-mocks.qmd" "$GO_SRC/19-day-18-stage-ii-gate.qmd"

cat > "$DST30/content/01-go/09-day-08.qmd" <<'GATE1'
---
title: "Day 8 — Gate I: Core Language Checkpoint"
date-modified: "2025-07-30"
---

# Day 8 — Gate I: Core Language Checkpoint

Today is your first gate. Review everything from Days 1–7 and verify you can work confidently with Go's core language features.

## Self-assessment checklist

- [ ] Set up a Go module from scratch (`go mod init`)
- [ ] Declare variables with both `var` and `:=`, understand zero values
- [ ] Write functions with multiple returns, named returns, and variadic parameters
- [ ] Use `if`, `switch`, `for` (including `range`) confidently
- [ ] Create and manipulate slices (append, copy, reslicing)
- [ ] Use maps with comma-ok pattern
- [ ] Define structs with methods (value and pointer receivers)
- [ ] Understand pointer semantics and escape analysis basics
- [ ] Organize code into packages with proper visibility
- [ ] Define and implement interfaces (implicit satisfaction)
- [ ] Use type assertions and type switches
- [ ] Handle errors idiomatically (`error` interface, wrapping with `%w`, `errors.Is`/`As`)
- [ ] Use `panic`/`recover` appropriately (rare cases only)
- [ ] Understand Go modules (`go.mod`, `go.sum`, `go get`, `go mod tidy`)
- [ ] Write table-driven tests with `t.Run()` subtests
- [ ] Create test fakes/mocks using interfaces

## Gate project

Build a **CLI tool** that:

1. Accepts command-line arguments
2. Uses at least 3 custom types with methods
3. Implements at least 1 interface
4. Has proper error handling (no panics for expected errors)
5. Includes table-driven tests with >80% coverage
6. Is organized into multiple packages

Run `go vet` and `go test -race ./...` — both must pass cleanly.

::: {.callout-tip}
If any checklist item feels uncertain, revisit that day's material before proceeding to Stage II.
:::
GATE1

combine_day "$DST30/content/01-go/10-day-09.qmd" "Day 9 — Goroutines, Channels & Select" \
  "$GO_SRC/20-day-19-goroutines.qmd" "$GO_SRC/21-day-20-channels.qmd" "$GO_SRC/22-day-21-select.qmd"

combine_day "$DST30/content/01-go/11-day-10.qmd" "Day 10 — Sync Primitives, Worker Pools & Context" \
  "$GO_SRC/23-day-22-sync-primitives.qmd" "$GO_SRC/24-day-23-worker-pools.qmd" "$GO_SRC/25-day-24-context.qmd"

combine_day "$DST30/content/01-go/12-day-11.qmd" "Day 11 — Race Detector, Concurrency Patterns & errgroup" \
  "$GO_SRC/26-day-25-race-detector.qmd" "$GO_SRC/27-day-26-concurrency-patterns.qmd" "$GO_SRC/28-day-27-errgroup.qmd"

combine_day "$DST30/content/01-go/13-day-12.qmd" "Day 12 — Memory Model, Integration & Stage III Gate" \
  "$GO_SRC/29-day-28-memory-model.qmd" "$GO_SRC/30-day-29-concurrency-integration.qmd" "$GO_SRC/31-day-30-stage-iii-gate.qmd"

combine_day "$DST30/content/01-go/14-day-13.qmd" "Day 13 — Generics: Type Parameters, Structs & Judgment" \
  "$GO_SRC/32-day-31-generics-intro.qmd" "$GO_SRC/33-day-32-generic-structs.qmd" "$GO_SRC/34-day-33-generics-judgment.qmd"

combine_day "$DST30/content/01-go/15-day-14.qmd" "Day 14 — Fuzzing, Golden Files & Go 1.26 Quality" \
  "$GO_SRC/35-day-34-fuzzing.qmd" "$GO_SRC/36-day-35-golden-files.qmd" "$GO_SRC/37-day-36-concurrent-tests.qmd" "$GO_SRC/38-day-37-go126-quality.qmd"

combine_day "$DST30/content/01-go/16-day-15.qmd" "Day 15 — Gate II: Concurrency & Generics Checkpoint" \
  "$GO_SRC/39-day-38-stage-iv-gate.qmd"

combine_day "$DST30/content/01-go/17-day-16.qmd" "Day 16 — io Interfaces, bufio & encoding/json" \
  "$GO_SRC/40-day-39-io-interfaces.qmd" "$GO_SRC/41-day-40-bufio-bytes-strings.qmd" "$GO_SRC/42-day-41-encoding-json.qmd"

combine_day "$DST30/content/01-go/18-day-17.qmd" "Day 17 — os/exec, Time & Network Basics" \
  "$GO_SRC/43-day-42-os-exec.qmd" "$GO_SRC/44-day-43-time.qmd" "$GO_SRC/45-day-44-net-basics.qmd"

combine_day "$DST30/content/01-go/19-day-18.qmd" "Day 18 — HTTP Server, Client & Structured Logging" \
  "$GO_SRC/46-day-45-http-server.qmd" "$GO_SRC/47-day-46-http-client.qmd" "$GO_SRC/48-day-47-slog.qmd"

combine_day "$DST30/content/01-go/20-day-19.qmd" "Day 19 — Templates, httptest & Stage V Gate" \
  "$GO_SRC/49-day-48-templates-regexp.qmd" "$GO_SRC/50-day-49-httptest.qmd" "$GO_SRC/51-day-50-stage-v-gate.qmd"

combine_day "$DST30/content/01-go/21-day-20.qmd" "Day 20 — database/sql, Migrations & REST Design" \
  "$GO_SRC/52-day-51-database-sql.qmd" "$GO_SRC/53-day-52-migrations.qmd" "$GO_SRC/54-day-53-rest-design.qmd"

combine_day "$DST30/content/01-go/22-day-21.qmd" "Day 21 — Auth, Validation & gRPC" \
  "$GO_SRC/55-day-54-auth-basics.qmd" "$GO_SRC/56-day-55-validation-api.qmd" "$GO_SRC/57-day-56-grpc-or-rest-a.qmd" "$GO_SRC/58-day-57-grpc-or-rest-b.qmd"

combine_day "$DST30/content/01-go/23-day-22.qmd" "Day 22 — Caching, Real-time, TLS & Stage VI Gate" \
  "$GO_SRC/59-day-58-caching.qmd" "$GO_SRC/60-day-59-websockets-sse.qmd" "$GO_SRC/61-day-60-tls-awareness.qmd" "$GO_SRC/62-day-61-integration-tests.qmd" "$GO_SRC/63-day-62-stage-vi-gate.qmd"

combine_day "$DST30/content/01-go/24-day-23.qmd" "Day 23 — Build Tags, Linting & Profiling" \
  "$GO_SRC/64-day-63-build-tags.qmd" "$GO_SRC/65-day-64-staticcheck.qmd" "$GO_SRC/66-day-65-pprof.qmd"

combine_day "$DST30/content/01-go/25-day-24.qmd" "Day 24 — Benchmarks, GC Tuning & Containers" \
  "$GO_SRC/67-day-66-benchmarks.qmd" "$GO_SRC/68-day-67-gc-tuning.qmd" "$GO_SRC/69-day-68-containers.qmd"

combine_day "$DST30/content/01-go/26-day-25.qmd" "Day 25 — Observability, CLI & Security Scanning" \
  "$GO_SRC/70-day-69-prometheus-metrics.qmd" "$GO_SRC/71-day-70-otel-light.qmd" "$GO_SRC/72-day-71-cli-ergonomics.qmd" "$GO_SRC/73-day-72-govulncheck.qmd"

combine_day "$DST30/content/01-go/27-day-26.qmd" "Day 26 — Architecture: Boundaries & Hexagonal Design" \
  "$GO_SRC/74-day-73-elective-k8s-or-deepen.qmd" "$GO_SRC/76-day-75-package-boundaries.qmd" "$GO_SRC/77-day-76-hexagonal-lite.qmd"

combine_day "$DST30/content/01-go/28-day-27.qmd" "Day 27 — Config, Graceful Shutdown & Feature Flags" \
  "$GO_SRC/78-day-77-config-layering.qmd" "$GO_SRC/79-day-78-graceful-shutdown.qmd" "$GO_SRC/80-day-79-feature-flags.qmd"

combine_day "$DST30/content/01-go/29-day-28.qmd" "Day 28 — Load Testing, Security & Capstone Design" \
  "$GO_SRC/81-day-80-load-test.qmd" "$GO_SRC/82-day-81-security-checklist.qmd" "$GO_SRC/83-day-82-capstone-design.qmd"

combine_day "$DST30/content/01-go/30-day-29.qmd" "Day 29 — Capstone Build: Core to Polish" \
  "$GO_SRC/84-day-83-capstone-build-1.qmd" "$GO_SRC/85-day-84-capstone-build-2.qmd" "$GO_SRC/86-day-85-capstone-build-3.qmd" \
  "$GO_SRC/87-day-86-capstone-build-4.qmd" "$GO_SRC/88-day-87-capstone-build-5.qmd" "$GO_SRC/89-day-88-capstone-build-6.qmd"

combine_day "$DST30/content/01-go/31-day-30.qmd" "Day 30 — Capstone Hardening & Retrospective" \
  "$GO_SRC/90-day-89-capstone-harden.qmd" "$GO_SRC/91-day-90-retrospective.qmd"

echo "=== Generating NixOS Volume ==="
mkdir -p "$DST30/content/02-nixos"

cat > "$DST30/content/02-nixos/00-sub-book-overview.qmd" <<'NIXOVERVIEW'
---
title: "NixOS — volume overview"
date-modified: "2025-07-30"
---

# NixOS — volume overview

An intensive 30-day sprint through Nix & NixOS, condensed from the 90-day curriculum.

## Baseline

- **Nix 2.34.x** · **NixOS 26.05 Yarara**
- Disposable VM or spare machine
- Flakes-capable Nix installation

## Four stages

| Stage | Days | Focus | Gate |
|-------|------|-------|------|
| **I — Nix Foundations** | 1–8 | Nix language, store, flakes, NixOS install, host config | Gate I (Day 8) |
| **II — Daily Driver** | 9–15 | Home Manager, direnv, secrets, services, containers | Gate II (Day 15) |
| **III — Packaging & Fleet** | 16–22 | stdenv, packaging, deployment, CI, testing | Gate III (Day 22) |
| **IV — Mastery & Capstone** | 23–30 | Internals, ecosystem, capstone infrastructure | Gate IV (Day 30) |

## Exit criteria

- Flake-driven NixOS host with rollback testing
- Workstation with Home Manager + sops-nix secrets
- Custom packages deployed to fleet via Colmena/deploy-rs
- Production-grade NixOS infrastructure with CI and disaster recovery
NIXOVERVIEW

cat > "$DST30/content/02-nixos/01-syllabus.qmd" <<'NIXSYLLABUS'
---
title: "NixOS Syllabus"
date-modified: "2025-07-30"
---

# NixOS — 30-day syllabus

## Stage I — Nix Foundations (Days 1–8)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 1 | Lab setup, why Nix, store & language basics | Lab 0 + Days 1–3 |
| 2 | Functions, laziness & nixpkgs lib | Days 4–5 |
| 3 | Derivations, modern CLI & first flake | Days 6–8 |
| 4 | Classic CLI & Stage I gate | Days 9–10 |
| 5 | NixOS install, flake host & generations | Days 11–13 |
| 6 | Users, networking & system packages | Days 14–16 |
| 7 | systemd services & NixOS modules | Days 17–19 |
| **8** | **Gate I — Boot, filesystems & checkpoint** | Days 20–22 |

## Stage II — Daily Driver (Days 9–15)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 9 | Flake layout, lock management & Home Manager | Days 23–25 |
| 10 | HM files/XDG, HM services & direnv | Days 26–28 |
| 11 | flake-parts, checks, overlays & Gate II | Days 29–32 |
| 12 | Secrets: sops-nix & agenix | Days 33–35 |
| 13 | Hardening, firewall & TLS reverse proxy | Days 36–38 |
| 14 | PostgreSQL, nixos-containers & Podman | Days 39–41 |
| **15** | **Gate III — Observability, K3s & checkpoint** | Days 42–44 |

## Stage III — Packaging & Fleet (Days 16–22)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 16 | stdenv phases, fetchers & Go packaging | Days 45–47 |
| 17 | Python/Rust packaging, patching & outputs | Days 48–50 |
| 18 | Debug builds, nixpkgs layout & binary caches | Days 51–53 |
| 19 | Remote builders, reproducibility & Gate IV | Days 54–56 |
| 20 | Disko, impermanence & deploy-rs | Days 57–59 |
| 21 | Colmena, shared modules & nixos-generators | Days 60–62 |
| **22** | **Gate V — Terraform, nixosTest & CI** | Days 63–66 |

## Stage IV — Mastery & Capstone (Days 23–30)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 23 | GC, Secure Boot, backups & Gate V | Days 67–70 |
| 24 | Evaluator internals, module system & store daemon | Days 71–73 |
| 25 | Performance, CA derivations & advanced testing | Days 74–76 |
| 26 | Ecosystem, comparisons & upgrade planning | Days 77–80 |
| 27 | Troubleshooting & architecture review | Days 81–82 |
| 28 | Capstone: flake, host & secrets | Days 83–85 |
| 29 | Capstone: deploy, CI & disaster recovery | Days 86–89 |
| **30** | **Gate VI — Retrospective & NixOS roadmap** | Day 90 |
NIXSYLLABUS

NIX_SRC="$SRC90/content/02-nixos"

combine_day "$DST30/content/02-nixos/02-day-01.qmd" "Day 1 — Lab Setup, Why Nix, Store & Language Basics" \
  "$NIX_SRC/01a-lab-overview-and-roles.qmd" "$NIX_SRC/01b-lab-journey-single-server.qmd" "$NIX_SRC/01c-lab-nixos-dev-machine.qmd" \
  "$NIX_SRC/01d-lab-elitebook-2570p.qmd" "$NIX_SRC/01e-lab-ops-cheatsheet.qmd" \
  "$NIX_SRC/02-day-01-why-nix-exists.qmd" "$NIX_SRC/03-day-02-store-and-closures.qmd" "$NIX_SRC/04-day-03-language-attrsets.qmd"

combine_day "$DST30/content/02-nixos/03-day-02.qmd" "Day 2 — Functions, Laziness & nixpkgs lib" \
  "$NIX_SRC/05-day-04-language-functions.qmd" "$NIX_SRC/06-day-05-laziness-imports-lib.qmd"

combine_day "$DST30/content/02-nixos/04-day-03.qmd" "Day 3 — Derivations, Modern CLI & First Flake" \
  "$NIX_SRC/07-day-06-derivations-idea.qmd" "$NIX_SRC/08-day-07-modern-cli.qmd" "$NIX_SRC/09-day-08-first-flake.qmd"

combine_day "$DST30/content/02-nixos/05-day-04.qmd" "Day 4 — Classic CLI & Stage I Gate" \
  "$NIX_SRC/10-day-09-classic-cli.qmd" "$NIX_SRC/11-day-10-stage-i-gate.qmd"

combine_day "$DST30/content/02-nixos/06-day-05.qmd" "Day 5 — NixOS Install, Flake Host & Generations" \
  "$NIX_SRC/12-day-11-install-nixos.qmd" "$NIX_SRC/13-day-12-flake-host.qmd" "$NIX_SRC/14-day-13-rebuild-generations.qmd"

combine_day "$DST30/content/02-nixos/07-day-06.qmd" "Day 6 — Users, Networking & System Packages" \
  "$NIX_SRC/15-day-14-users-access.qmd" "$NIX_SRC/16-day-15-networking-firewall.qmd" "$NIX_SRC/17-day-16-packages-programs.qmd"

combine_day "$DST30/content/02-nixos/08-day-07.qmd" "Day 7 — systemd Services & NixOS Modules" \
  "$NIX_SRC/18-day-17-systemd-nix.qmd" "$NIX_SRC/19-day-18-modules-consumer.qmd" "$NIX_SRC/20-day-19-custom-module.qmd"

combine_day "$DST30/content/02-nixos/09-day-08.qmd" "Day 8 — Boot, Filesystems & Gate I" \
  "$NIX_SRC/21-day-20-boot-hardware.qmd" "$NIX_SRC/22-day-21-filesystems-intro.qmd" "$NIX_SRC/23-day-22-stage-ii-gate.qmd"

combine_day "$DST30/content/02-nixos/10-day-09.qmd" "Day 9 — Flake Layout, Lock Management & Home Manager" \
  "$NIX_SRC/24-day-23-flake-layout.qmd" "$NIX_SRC/25-day-24-lock-discipline.qmd" "$NIX_SRC/26-day-25-home-manager.qmd"

combine_day "$DST30/content/02-nixos/11-day-10.qmd" "Day 10 — HM Files/XDG, HM Services & direnv" \
  "$NIX_SRC/27-day-26-hm-files-xdg.qmd" "$NIX_SRC/28-day-27-hm-services.qmd" "$NIX_SRC/29-day-28-direnv-devshell.qmd"

combine_day "$DST30/content/02-nixos/12-day-11.qmd" "Day 11 — flake-parts, Checks, Overlays & Gate II" \
  "$NIX_SRC/30-day-29-flake-parts.qmd" "$NIX_SRC/31-day-30-flake-checks.qmd" "$NIX_SRC/32-day-31-overlays-light.qmd" "$NIX_SRC/33-day-32-stage-iii-gate.qmd"

combine_day "$DST30/content/02-nixos/13-day-12.qmd" "Day 12 — Secrets: sops-nix & agenix" \
  "$NIX_SRC/34-day-33-secret-problem.qmd" "$NIX_SRC/35-day-34-sops-nix.qmd" "$NIX_SRC/36-day-35-agenix.qmd"

combine_day "$DST30/content/02-nixos/14-day-13.qmd" "Day 13 — Hardening, Firewall & TLS Reverse Proxy" \
  "$NIX_SRC/37-day-36-hardening.qmd" "$NIX_SRC/38-day-37-firewall-discipline.qmd" "$NIX_SRC/39-day-38-tls-front-door.qmd"

combine_day "$DST30/content/02-nixos/15-day-14.qmd" "Day 14 — PostgreSQL, nixos-containers & Podman" \
  "$NIX_SRC/40-day-39-data-service.qmd" "$NIX_SRC/41-day-40-nixos-containers.qmd" "$NIX_SRC/42-day-41-podman-docker.qmd"

combine_day "$DST30/content/02-nixos/16-day-15.qmd" "Day 15 — Observability, K3s & Gate III" \
  "$NIX_SRC/43-day-42-observability.qmd" "$NIX_SRC/44-day-43-k3s-optional.qmd" "$NIX_SRC/45-day-44-stage-iv-gate.qmd"

combine_day "$DST30/content/02-nixos/17-day-16.qmd" "Day 16 — stdenv Phases, Fetchers & Go Packaging" \
  "$NIX_SRC/46-day-45-stdenv-phases.qmd" "$NIX_SRC/47-day-46-fetchers-fod.qmd" "$NIX_SRC/48-day-47-language-eco-a.qmd"

combine_day "$DST30/content/02-nixos/18-day-17.qmd" "Day 17 — Python/Rust Packaging, Patching & Outputs" \
  "$NIX_SRC/49-day-48-language-eco-b.qmd" "$NIX_SRC/50-day-49-patching-overrides.qmd" "$NIX_SRC/51-day-50-multiple-outputs.qmd"

combine_day "$DST30/content/02-nixos/19-day-18.qmd" "Day 18 — Debug Builds, nixpkgs Layout & Binary Caches" \
  "$NIX_SRC/52-day-51-debug-builds.qmd" "$NIX_SRC/53-day-52-nixpkgs-layout.qmd" "$NIX_SRC/54-day-53-binary-caches.qmd"

combine_day "$DST30/content/02-nixos/20-day-19.qmd" "Day 19 — Remote Builders, Reproducibility & Gate IV" \
  "$NIX_SRC/55-day-54-remote-builders.qmd" "$NIX_SRC/56-day-55-reproducibility-honesty.qmd" "$NIX_SRC/57-day-56-stage-v-gate.qmd"

combine_day "$DST30/content/02-nixos/21-day-20.qmd" "Day 20 — Disko, Impermanence & deploy-rs" \
  "$NIX_SRC/58-day-57-disko.qmd" "$NIX_SRC/59-day-58-impermanence.qmd" "$NIX_SRC/60-day-59-deploy-rs.qmd"

combine_day "$DST30/content/02-nixos/22-day-21.qmd" "Day 21 — Colmena, Shared Modules & nixos-generators" \
  "$NIX_SRC/61-day-60-colmena.qmd" "$NIX_SRC/62-day-61-shared-modules.qmd" "$NIX_SRC/63-day-62-images-generators.qmd"

combine_day "$DST30/content/02-nixos/23-day-22.qmd" "Day 22 — Terraform, nixosTest & CI Pipeline" \
  "$NIX_SRC/64-day-63-terraform-boundary.qmd" "$NIX_SRC/65-day-64-nixos-test.qmd" "$NIX_SRC/66-day-65-more-tests.qmd" "$NIX_SRC/67-day-66-ci-pipeline.qmd"

combine_day "$DST30/content/02-nixos/24-day-23.qmd" "Day 23 — GC, Secure Boot, Backups & Gate V" \
  "$NIX_SRC/68-day-67-gc-hygiene.qmd" "$NIX_SRC/69-day-68-secure-boot-tpm.qmd" "$NIX_SRC/70-day-69-backup-story.qmd" "$NIX_SRC/71-day-70-stage-vi-gate.qmd"

combine_day "$DST30/content/02-nixos/25-day-24.qmd" "Day 24 — Evaluator Internals, Module System & Store Daemon" \
  "$NIX_SRC/72-day-71-evaluator.qmd" "$NIX_SRC/73-day-72-module-system-deep.qmd" "$NIX_SRC/74-day-73-store-daemon.qmd"

combine_day "$DST30/content/02-nixos/26-day-25.qmd" "Day 25 — Performance, CA Derivations & Advanced Testing" \
  "$NIX_SRC/75-day-74-nix-performance.qmd" "$NIX_SRC/76-day-75-ca-derivations.qmd" "$NIX_SRC/77-day-76-nixos-test-mastery.qmd"

combine_day "$DST30/content/02-nixos/27-day-26.qmd" "Day 26 — Ecosystem, Comparisons & Upgrade Planning" \
  "$NIX_SRC/78-day-77-ecosystem-map.qmd" "$NIX_SRC/79-day-78-comparative-landscape.qmd" "$NIX_SRC/80-day-79-release-notes-2605.qmd" "$NIX_SRC/81-day-80-upgrade-planning.qmd"

combine_day "$DST30/content/02-nixos/28-day-27.qmd" "Day 27 — Troubleshooting & Architecture Review" \
  "$NIX_SRC/82-day-81-troubleshooting-drill.qmd" "$NIX_SRC/83-day-82-architecture-review.qmd"

combine_day "$DST30/content/02-nixos/29-day-28.qmd" "Day 28 — Capstone: Flake, Host & Secrets" \
  "$NIX_SRC/84-day-83-capstone-1.qmd" "$NIX_SRC/85-day-84-capstone-2.qmd" "$NIX_SRC/86-day-85-capstone-3.qmd"

combine_day "$DST30/content/02-nixos/30-day-29.qmd" "Day 29 — Capstone: Deploy, CI & Disaster Recovery" \
  "$NIX_SRC/87-day-86-capstone-4.qmd" "$NIX_SRC/88-day-87-capstone-5.qmd" "$NIX_SRC/89-day-88-disaster-recovery.qmd" "$NIX_SRC/90-day-89-rollback-and-tests.qmd"

combine_day "$DST30/content/02-nixos/31-day-30.qmd" "Day 30 — Retrospective & NixOS Roadmap" \
  "$NIX_SRC/91-day-90-retrospective.qmd"

echo "=== Generating Maths Volume ==="
mkdir -p "$DST30/content/03-maths"

cat > "$DST30/content/03-maths/00-sub-book-overview.qmd" <<'MATHOVERVIEW'
---
title: "Maths — volume overview"
date-modified: "2025-07-30"
---

# Maths — volume overview

An intensive 30-day sprint through discrete mathematics for CS, condensed from the 90-day curriculum. Pen and paper first — no coding labs.

## Baseline

- Pen, paper, and willingness to do proofs
- No programming required (though CS context is provided)

## Four stages

| Stage | Days | Focus | Gate |
|-------|------|-------|------|
| **I — Numbers & Algebra** | 1–8 | Integers, fractions, bases, exponents, algebra, functions, summation | Gate I (Day 4), Gate II (Day 8) |
| **II — Logic & Structures** | 9–15 | Propositional/predicate logic, proofs, induction, sets, relations | Gate III (Day 12), Gate IV (Day 15) |
| **III — Counting & Graphs** | 16–22 | Combinatorics, recurrences, graph theory | Gate V (Day 20), Gate VI (Day 24) |
| **IV — Applied & Capstone** | 23–30 | Number theory, crypto math, asymptotics, probability, capstone dossier | Gate VII (Day 27), Capstone (Day 30) |

## Exit criteria

- Number sense and algebra fluency
- Ability to write and verify proofs (direct, contradiction, induction)
- Combinatorics and graph theory competence
- Mathematical dossier demonstrating integrated understanding
MATHOVERVIEW

cat > "$DST30/content/03-maths/01-syllabus.qmd" <<'MATHSYLLABUS'
---
title: "Mathematics Syllabus"
date-modified: "2025-07-30"
---

# Mathematics — 30-day syllabus

## Stage I — Numbers & Algebra (Days 1–8)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 1 | Integers, fractions & decimals | Days 1–3 |
| 2 | Factors, primes & integer division | Days 4–5 |
| 3 | Number bases & binary arithmetic | Days 6–7 |
| 4 | Exponents, logarithms & Gate I | Days 8–10 |
| 5 | Variables, linear equations & inequalities | Days 11–13 |
| 6 | Systems, polynomials & factoring | Days 14–16 |
| 7 | Rational expressions, functions & quadratics | Days 17–19 |
| **8** | **Exponential functions, summation & Gate II** | Days 20–22 |

## Stage II — Logic & Structures (Days 9–15)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 9 | Propositional logic, Boolean algebra & normal forms | Days 23–25 |
| 10 | Quantifiers & direct proof | Days 26–28 |
| 11 | Contrapositive, cases & induction | Days 29–31 |
| 12 | Strong induction, fallacies & Gate III | Days 32–34 |
| 13 | Sets, set operations & Cartesian products | Days 35–37 |
| 14 | Relations, equivalence relations & partial orders | Days 38–40 |
| **15** | **Bijections, composition, countability & Gate IV** | Days 41–43, 46 |

## Stage III — Counting & Graphs (Days 16–22)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 16 | Types analogy & pigeonhole principle | Days 44–45 |
| 17 | Counting rules, permutations & combinations | Days 47–49 |
| 18 | Binomial theorem, stars-and-bars & inclusion-exclusion | Days 50–52 |
| 19 | CS counting & recurrence relations | Days 53–55 |
| 20 | Story proofs, counting workshop & Gate V | Days 56–58 |
| 21 | Graphs, paths & trees | Days 59–61 |
| **22** | **BFS/DFS, DAGs & shortest paths** | Days 62–64 |

## Stage IV — Applied & Capstone (Days 23–30)

| Day | Topics | 90-Day Sources |
|-----|--------|----------------|
| 23 | Bipartite, Euler/Hamilton & graph coloring | Days 65–67 |
| 24 | Graph modeling & Gate VI | Days 68–70 |
| 25 | Divisibility, Euclidean algorithm & modular arithmetic | Days 71–73 |
| 26 | Modular inverses, Fermat/Euler & hashing | Days 74–76 |
| 27 | Crypto math, CRT, PRNGs & Gate VII | Days 77–80 |
| 28 | Asymptotic notation & complexity analysis | Days 81–84 |
| 29 | Probability, conditional probability & expectation | Days 85–87 |
| **30** | **Capstone dossier & retrospective** | Days 88–90 |
MATHSYLLABUS

combine_day "$DST30/content/03-maths/01a-how-to-study-maths.qmd" "How to study maths for CS" \
  "$SRC90/content/03-maths/01a-how-to-study-maths.qmd"

MATH_SRC="$SRC90/content/03-maths"

combine_day "$DST30/content/03-maths/02-day-01.qmd" "Day 1 — Integers, Fractions & Decimals" \
  "$MATH_SRC/02-day-01-integers-order-ops.qmd" "$MATH_SRC/03-day-02-fractions.qmd" "$MATH_SRC/04-day-03-decimals-percent.qmd"

combine_day "$DST30/content/03-maths/03-day-02.qmd" "Day 2 — Factors, Primes & Integer Division" \
  "$MATH_SRC/05-day-04-factors-primes.qmd" "$MATH_SRC/06-day-05-div-mod.qmd"

combine_day "$DST30/content/03-maths/04-day-03.qmd" "Day 3 — Number Bases & Binary Arithmetic" \
  "$MATH_SRC/07-day-06-bases.qmd" "$MATH_SRC/08-day-07-binary-arith.qmd"

combine_day "$DST30/content/03-maths/05-day-04.qmd" "Day 4 — Exponents, Logarithms & Gate I" \
  "$MATH_SRC/09-day-08-exp-logs.qmd" "$MATH_SRC/10-day-09-error.qmd" "$MATH_SRC/11-day-10-gate-i.qmd"

combine_day "$DST30/content/03-maths/06-day-05.qmd" "Day 5 — Variables, Linear Equations & Inequalities" \
  "$MATH_SRC/12-day-11-variables.qmd" "$MATH_SRC/13-day-12-linear-eq.qmd" "$MATH_SRC/14-day-13-inequalities.qmd"

combine_day "$DST30/content/03-maths/07-day-06.qmd" "Day 6 — Systems, Polynomials & Factoring" \
  "$MATH_SRC/15-day-14-systems.qmd" "$MATH_SRC/16-day-15-polynomials.qmd" "$MATH_SRC/17-day-16-factoring.qmd"

combine_day "$DST30/content/03-maths/08-day-07.qmd" "Day 7 — Rational Expressions, Functions & Quadratics" \
  "$MATH_SRC/18-day-17-rational-expr.qmd" "$MATH_SRC/19-day-18-functions.qmd" "$MATH_SRC/20-day-19-lin-quad.qmd"

combine_day "$DST30/content/03-maths/09-day-08.qmd" "Day 8 — Exponential Functions, Summation & Gate II" \
  "$MATH_SRC/21-day-20-exponential.qmd" "$MATH_SRC/22-day-21-summation.qmd" "$MATH_SRC/23-day-22-gate-ii.qmd"

combine_day "$DST30/content/03-maths/10-day-09.qmd" "Day 9 — Propositional Logic, Boolean Algebra & Normal Forms" \
  "$MATH_SRC/24-day-23-propositions.qmd" "$MATH_SRC/25-day-24-boolean.qmd" "$MATH_SRC/26-day-25-equivalence.qmd"

combine_day "$DST30/content/03-maths/11-day-10.qmd" "Day 10 — Quantifiers & Direct Proof" \
  "$MATH_SRC/27-day-26-quantifiers.qmd" "$MATH_SRC/28-day-27-nested-quant.qmd" "$MATH_SRC/29-day-28-direct-proof.qmd"

combine_day "$DST30/content/03-maths/12-day-11.qmd" "Day 11 — Contrapositive, Cases & Induction" \
  "$MATH_SRC/30-day-29-contrapositive.qmd" "$MATH_SRC/31-day-30-cases.qmd" "$MATH_SRC/32-day-31-induction.qmd"

combine_day "$DST30/content/03-maths/13-day-12.qmd" "Day 12 — Strong Induction, Fallacies & Gate III" \
  "$MATH_SRC/33-day-32-strong-induction.qmd" "$MATH_SRC/34-day-33-fallacies.qmd" "$MATH_SRC/35-day-34-gate-iii.qmd"

combine_day "$DST30/content/03-maths/14-day-13.qmd" "Day 13 — Sets, Set Operations & Cartesian Products" \
  "$MATH_SRC/36-day-35-sets.qmd" "$MATH_SRC/37-day-36-set-ops.qmd" "$MATH_SRC/38-day-37-products.qmd"

combine_day "$DST30/content/03-maths/15-day-14.qmd" "Day 14 — Relations, Equivalence Relations & Partial Orders" \
  "$MATH_SRC/39-day-38-relations.qmd" "$MATH_SRC/40-day-39-equivalence.qmd" "$MATH_SRC/41-day-40-posets.qmd"

combine_day "$DST30/content/03-maths/16-day-15.qmd" "Day 15 — Bijections, Composition, Countability & Gate IV" \
  "$MATH_SRC/42-day-41-injections.qmd" "$MATH_SRC/43-day-42-composition.qmd" "$MATH_SRC/44-day-43-countability.qmd" "$MATH_SRC/47-day-46-gate-iv.qmd"

combine_day "$DST30/content/03-maths/17-day-16.qmd" "Day 16 — Types Analogy & Pigeonhole Principle" \
  "$MATH_SRC/45-day-44-types.qmd" "$MATH_SRC/46-day-45-pigeonhole.qmd"

combine_day "$DST30/content/03-maths/18-day-17.qmd" "Day 17 — Counting Rules, Permutations & Combinations" \
  "$MATH_SRC/48-day-47-product-sum.qmd" "$MATH_SRC/49-day-48-permutations.qmd" "$MATH_SRC/50-day-49-combinations.qmd"

combine_day "$DST30/content/03-maths/19-day-18.qmd" "Day 18 — Binomial Theorem, Stars-and-Bars & Inclusion-Exclusion" \
  "$MATH_SRC/51-day-50-binomial.qmd" "$MATH_SRC/52-day-51-stars-bars.qmd" "$MATH_SRC/53-day-52-ie.qmd"

combine_day "$DST30/content/03-maths/20-day-19.qmd" "Day 19 — CS Counting & Recurrence Relations" \
  "$MATH_SRC/54-day-53-counting-cs.qmd" "$MATH_SRC/55-day-54-rec-intro.qmd" "$MATH_SRC/56-day-55-rec-solve.qmd"

combine_day "$DST30/content/03-maths/21-day-20.qmd" "Day 20 — Story Proofs, Counting Workshop & Gate V" \
  "$MATH_SRC/57-day-56-story-proofs.qmd" "$MATH_SRC/58-day-57-count-workshop.qmd" "$MATH_SRC/59-day-58-gate-v.qmd"

combine_day "$DST30/content/03-maths/22-day-21.qmd" "Day 21 — Graphs, Paths & Trees" \
  "$MATH_SRC/60-day-59-graphs.qmd" "$MATH_SRC/61-day-60-paths.qmd" "$MATH_SRC/62-day-61-trees.qmd"

combine_day "$DST30/content/03-maths/23-day-22.qmd" "Day 22 — BFS/DFS, DAGs & Shortest Paths" \
  "$MATH_SRC/63-day-62-bfs-dfs.qmd" "$MATH_SRC/64-day-63-dags.qmd" "$MATH_SRC/65-day-64-shortest.qmd"

combine_day "$DST30/content/03-maths/24-day-23.qmd" "Day 23 — Bipartite, Euler/Hamilton & Graph Coloring" \
  "$MATH_SRC/66-day-65-bipartite.qmd" "$MATH_SRC/67-day-66-euler-ham.qmd" "$MATH_SRC/68-day-67-color.qmd"

combine_day "$DST30/content/03-maths/25-day-24.qmd" "Day 24 — Graph Modeling & Gate VI" \
  "$MATH_SRC/69-day-68-graphs-cs.qmd" "$MATH_SRC/70-day-69-model.qmd" "$MATH_SRC/71-day-70-gate-vi.qmd"

combine_day "$DST30/content/03-maths/26-day-25.qmd" "Day 25 — Divisibility, Euclidean Algorithm & Modular Arithmetic" \
  "$MATH_SRC/72-day-71-divis.qmd" "$MATH_SRC/73-day-72-euclid.qmd" "$MATH_SRC/74-day-73-mod.qmd"

combine_day "$DST30/content/03-maths/27-day-26.qmd" "Day 26 — Modular Inverses, Fermat/Euler & Hashing" \
  "$MATH_SRC/75-day-74-inv.qmd" "$MATH_SRC/76-day-75-fermat.qmd" "$MATH_SRC/77-day-76-hash.qmd"

combine_day "$DST30/content/03-maths/28-day-27.qmd" "Day 27 — Crypto Math, CRT, PRNGs & Gate VII" \
  "$MATH_SRC/78-day-77-crypto.qmd" "$MATH_SRC/79-day-78-crt.qmd" "$MATH_SRC/80-day-79-rng.qmd" "$MATH_SRC/81-day-80-gate-vii.qmd"

combine_day "$DST30/content/03-maths/29-day-28.qmd" "Day 28 — Asymptotic Notation & Complexity Analysis" \
  "$MATH_SRC/82-day-81-big-o.qmd" "$MATH_SRC/83-day-82-growth.qmd" "$MATH_SRC/84-day-83-loops.qmd" "$MATH_SRC/85-day-84-master.qmd"

combine_day "$DST30/content/03-maths/30-day-29.qmd" "Day 29 — Probability, Conditional Probability & Expectation" \
  "$MATH_SRC/86-day-85-prob.qmd" "$MATH_SRC/87-day-86-cond.qmd" "$MATH_SRC/88-day-87-expect.qmd"

combine_day "$DST30/content/03-maths/31-day-30.qmd" "Day 30 — Capstone Dossier & Retrospective" \
  "$MATH_SRC/89-day-88-cap-outline.qmd" "$MATH_SRC/90-day-89-cap-draft.qmd" "$MATH_SRC/91-day-90-cap-final.qmd"

echo "=== Generation Complete ==="
