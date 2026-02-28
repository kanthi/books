# Getting Started with Rust

## Why This Chapter Matters

Before writing advanced Rust, you need frictionless tooling. This chapter sets up a reproducible developer environment.

## Install and Verify

```bash
rustup --version
rustup update
rustc --version
cargo --version
```

Use stable for learning first:

```bash
rustup default stable
rustup component add rustfmt clippy
```

## Create Your First Project

```bash
cargo new hello_rust
cd hello_rust
cargo run
```

`cargo run` does compile + execute. `cargo build --release` builds optimized binaries.

## Understand Project Layout

```text
hello_rust/
  Cargo.toml
  src/
    main.rs
```

- `Cargo.toml`: package metadata + dependencies.
- `src/main.rs`: binary entry point.
- `src/lib.rs`: optional reusable library module.

## Example: CLI Arguments

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    if args.len() < 2 {
        println!("Usage: hello_rust <name>");
        return;
    }
    println!("Hello, {}!", args[1]);
}
```

Run:

```bash
cargo run -- King
```

## Example: Add a Dependency

`Cargo.toml`:

```toml
[dependencies]
anyhow = "1"
```

Use it:

```rust
fn parse_port(s: &str) -> anyhow::Result<u16> {
    Ok(s.parse::<u16>()?)
}
```

## Practice

1. Create a new project named `temperature_cli`.
2. Parse one argument and print Celsius to Fahrenheit conversion.
3. Run `cargo fmt` and `cargo clippy`.

## Key Takeaways

- Rust tooling is opinionated and productive.
- `cargo` handles build, test, docs, and dependency workflow.
- Start every project with formatting and linting enabled.

## Deep Dive: Cargo Workflow You Will Use Daily

### Build Profiles

`Cargo.toml` supports profile tuning:

```toml
[profile.dev]
opt-level = 1

[profile.release]
lto = true
codegen-units = 1
```

Use release profile for benchmarking and production builds.

### Useful Day-1 Commands

```bash
cargo check
cargo test
cargo run -- --help
cargo clippy --all-targets --all-features
```

`cargo check` is fast and should be part of your edit loop.

## Example: Small CLI with Subcommands (Manual Parsing)

```rust
use std::env;

fn main() {
    let mut args = env::args();
    let _bin = args.next();

    match args.next().as_deref() {
        Some("sum") => {
            let a: i32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(0);
            let b: i32 = args.next().and_then(|s| s.parse().ok()).unwrap_or(0);
            println!("{}", a + b);
        }
        Some("repeat") => {
            let text = args.next().unwrap_or_else(|| "hello".to_string());
            let n: usize = args.next().and_then(|s| s.parse().ok()).unwrap_or(1);
            for _ in 0..n {
                println!("{text}");
            }
        }
        _ => {
            println!("Usage: app <sum a b | repeat text n>");
        }
    }
}
```

## Troubleshooting Guide

- Command not found for `rustup`: ensure PATH includes `$HOME/.cargo/bin`.
- Build error after toolchain switch: run `cargo clean` once.
- Slow first build: expected due to crate compilation and caching.

## Review Questions

1. When should you use `cargo check` vs `cargo build`?
2. Why keep `clippy` in your default workflow?
3. Why benchmark with release profile, not debug profile?
