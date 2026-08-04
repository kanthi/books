# Rust Book Syllabus (2026)

## Program Goal

Learn Rust from first principles to production-minded engineering through **small, focused chapters**. Each chapter has concept prose, compiling examples, practice tasks, and common mistakes. Prefer **Edition 2024**, a **stable toolchain (rustc 1.85+ / 1.8x series)**, and daily habits with `cargo`, `rustfmt`, and `clippy`.

This syllabus is the map for the **live** book path under `content/` (not the `_archive-*` deep-dive tree).

## Toolchain Snapshot (2026)

| Piece | Recommendation |
|-------|----------------|
| Installer | [rustup](https://rustup.rs) |
| Edition | `edition = "2024"` in new crates when your toolchain supports it; otherwise `2021` until you upgrade |
| Channel | `stable` for learning and shipping |
| Daily tools | `cargo check`, `cargo test`, `cargo fmt`, `cargo clippy` |
| Docs | `rustup doc --std`, docs.rs, The Rust Reference |

Check what you have:

```bash
rustc --version
cargo --version
rustup show
```

Expect something like `rustc 1.85.x` or newer on stable in 2026. Upgrade with:

```bash
rustup update stable
```

## Parts Overview

| Part | Directory | Chapters | Role |
|------|-----------|----------|------|
| Intro | `content/00-intro/` | 1 | Syllabus and study path |
| 1. Rust Basics | `content/01-rust-basics/` | 12 | Language core + CLI mini project |
| 2. Rust Intermediate | `content/02-rust-intermediate/` | 10 | Types, traits, tests, threads + project |
| 3. Rust Advanced | `content/03-rust-advanced/` | 10 | Async, unsafe, macros, FFI, Pin |
| 4. Systems Programming | `content/04-rust-systems-programming/` | 10 | Files, sockets, services, reliability |
| 5. Network Programming | `content/05-network-programming/` | 5 | HTTP, gRPC, QUIC, load tests |
| 6. Security Programming | `content/06-security-programming/` | 5 | Threat model, auth, TLS, hardening |
| 7. Distributed Systems | `content/07-distributed-systems/` | 5 | Consistency, messaging, scale |
| 8. Embedded / IoT | `content/08-embedded-iot/` | 5 | `no_std`, HAL, realtime, power |
| 9. Ops & Career | `content/09-observability-performance-career/` | 5 | Alerts, incidents, perf, career |

**This refresh deepens Parts 0–2.** Later parts remain in the tree for the full curriculum path; treat them as the next stages after Intermediate.

## Learning Flow

```mermaid
flowchart LR
    A[Basics] --> B[Intermediate]
    B --> C[Advanced]
    C --> D[Systems]
    D --> E[Network]
    E --> F[Security]
    F --> G[Distributed]
    G --> H[Embedded]
    H --> I[Observability / Performance / Career]
```

Suggested pace (flexible):

- **Basics:** ~1–2 chapters per study session; ownership and borrowing may take longer.
- **Intermediate:** 1 chapter per session; re-read lifetimes and error design if needed.
- **Projects:** do not skip `12-mini-project-cli-notes` or `10-intermediate-project`.

## Live Path — Part 1: Rust Basics

Path: `content/01-rust-basics/`

| # | File | Topic |
|---|------|--------|
| 01 | `01-what-is-rust-and-why.md` | Why Rust, safety, performance, ecosystem |
| 02 | `02-setup-and-first-program.md` | rustup, cargo, Hello World, project layout |
| 03 | `03-variables-and-mutability.md` | `let`, `mut`, shadowing, constants, statics |
| 04 | `04-data-types.md` | Scalars, compounds, inference, casting |
| 05 | `05-functions-and-expressions.md` | `fn`, returns, expressions vs statements |
| 06 | `06-control-flow.md` | `if`, loops, `match`, `let-else` |
| 07 | `07-ownership-basics.md` | Move, copy, drop, ownership rules |
| 08 | `08-borrowing-and-references.md` | `&T`, `&mut T`, borrow checker rules |
| 09 | `09-strings-and-slices.md` | `String`, `&str`, slices, UTF-8 |
| 10 | `10-collections-intro.md` | `Vec`, `HashMap`, iterators intro |
| 11 | `11-error-handling-intro.md` | `Option`, `Result`, `?`, panic vs recover |
| 12 | `12-mini-project-cli-notes.md` | CLI notes app (file I/O + Result) |

## Live Path — Part 2: Rust Intermediate

Path: `content/02-rust-intermediate/`

| # | File | Topic |
|---|------|--------|
| 01 | `01-structs-and-methods.md` | Structs, impl, associated functions |
| 02 | `02-enums-and-pattern-matching.md` | Enums, `match`, destructuring |
| 03 | `03-modules-and-crates.md` | Modules, visibility, crates, Cargo |
| 04 | `04-traits.md` | Traits, impl Trait, common std traits |
| 05 | `05-generics.md` | Generic types and functions, monomorphization |
| 06 | `06-lifetimes.md` | Lifetime annotations, elision, static |
| 07 | `07-testing.md` | Unit/integration tests, `cargo test` |
| 08 | `08-error-design.md` | Custom errors, `thiserror`/`anyhow` patterns |
| 09 | `09-concurrency-basics.md` | Threads, channels, `Send`/`Sync` intro |
| 10 | `10-intermediate-project.md` | Multi-module library + CLI + tests |

## Later Parts (outline)

After Intermediate, continue in order:

3. **Advanced** — async fundamentals, Tokio, smart pointers, unsafe, macros, FFI, performance, Pin/futures  
4. **Systems** — files/processes, Unix streams, sockets, framing, lifecycle, systemd, reliability, observability, chaos  
5. **Network** — HTTP services, gRPC, QUIC, load testing, resilience project  
6. **Security** — threat modeling, authZ/authN, TLS/mTLS, validation, audit/fuzz  
7. **Distributed** — consistency, idempotency, messaging, scale, capstone  
8. **Embedded** — `no_std`, HAL, realtime, power, capstone  
9. **Career/Ops** — alerts, postmortems, perf antipatterns, capacity, roadmap  

## How to Study Each Chapter

1. **Read** learning goals and concept sections before typing code.
2. **Type** examples by hand (do not only skim). Prefer `cargo new` scratch crates.
3. **Run** with `cargo run` / `cargo test`. Read compiler errors fully.
4. **Modify** each example at least twice (values, types, failure paths).
5. **Complete** hands-on practice before the next chapter.
6. **Hygiene:** `cargo fmt` and `cargo clippy` on practice crates.
7. **Notes:** keep a short log of borrow-checker and lifetime errors and how you fixed them.

### Scratch crate pattern

```bash
cd /tmp
cargo new rust-lesson-scratch --bin
cd rust-lesson-scratch
# paste chapter examples into src/main.rs
cargo run
cargo clippy
cargo fmt
```

For library-style lessons:

```bash
cargo new notes_lib --lib
cd notes_lib
cargo test
```

## Mental Models You Will Build

1. **Ownership** — every value has one owner; move ends the previous name’s access.
2. **Borrowing** — shared XOR exclusive references (at a given time).
3. **Types as contracts** — `Option`/`Result` force you to handle absence and failure.
4. **Zero-cost abstractions** — generics and traits compile down without a mandatory GC runtime.
5. **Fearless concurrency** — type system tracks what can cross threads safely.

## Success Criteria Before Leaving Basics

- Explain move vs copy vs borrow with a small example.
- Write a function that returns `Result` and uses `?`.
- Build and run the CLI notes mini project with add/list/persist behavior.
- Use `cargo fmt` and `cargo clippy` without fear.

## Success Criteria Before Leaving Intermediate

- Model domain data with structs and enums.
- Split code into modules and a small binary+lib layout.
- Write unit tests and at least one integration-style test.
- Design a custom error type (or use a clear `thiserror` pattern).
- Spawn threads and pass messages with channels without data races.

## What This Book Is Not

- A substitute for reading official docs when APIs change.
- A dump of every unstable nightly feature.
- Archive content under `content/_archive-*` (ignored by the portal generator for parts starting with `_`).

## Chapter Summary

You have the **2026 syllabus**: toolchain expectations, the ordered live path for Basics and Intermediate, later-part outline, and a study loop. Start with **What Is Rust and Why Rust**, then install the toolchain and write your first program.
