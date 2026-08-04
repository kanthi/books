# Setup and First Program

## Learning Goals

- Install Rust with **rustup** and verify `rustc` / `cargo` versions.
- Create, build, and run a binary crate with Cargo.
- Explain the default project layout (`Cargo.toml`, `src/main.rs`).
- Use `cargo check`, `fmt`, `clippy`, and `doc` as daily tools.
- Understand edition, package name, and where dependencies are declared.

## Install with rustup

The supported way to install Rust is **rustup**, which manages toolchains (stable, beta, nightly) and components (`rustfmt`, `clippy`, `rust-src`, etc.).

### macOS / Linux

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# follow prompts; then restart the shell or source the env file
source "$HOME/.cargo/env"
```

### Verify

```bash
rustc --version
cargo --version
rustup show
```

You want a recent **stable** compiler (1.85+ / 1.8x series is fine for this book’s 2026 target). Update anytime:

```bash
rustup update stable
rustup default stable
```

### Useful components

```bash
rustup component add rustfmt clippy rust-src
rustup doc --std   # offline standard library docs in the browser
```

### Windows note

Prefer the official rustup installer from [rustup.rs](https://rustup.rs). For MSVC targets you need the Visual C++ build tools; for GNU targets, follow current rustup docs. WSL2 is a smooth path if you already live in Linux tooling.

## Your First Cargo Project

```bash
cargo new hello_cargo
cd hello_cargo
cargo run
```

Expected output ends with something like:

```text
Hello, world!
```

### What `cargo new` created

```text
hello_cargo/
├── Cargo.toml
└── src/
    └── main.rs
```

- **`Cargo.toml`** — package manifest (name, version, edition, dependencies).
- **`src/main.rs`** — binary entry point with `fn main()`.

Library crates use `cargo new --lib` and `src/lib.rs` instead of `main.rs`.

## Anatomy of `Cargo.toml`

A minimal manifest looks like:

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2024"

[dependencies]
```

Notes for 2026:

- Prefer **`edition = "2024"`** when your stable toolchain supports it. If Cargo errors on the edition, use `"2021"` until you upgrade rustc, then bump.
- Package `name` is how Cargo refers to the crate; binary name defaults to it.
- Dependencies go under `[dependencies]` as you add crates from crates.io later.

You generally **do not** hand-invoke `rustc` for multi-file projects. Cargo orchestrates builds, dependency resolution, and target directories.

## Hello, World — Explained

Default `src/main.rs`:

```rust
fn main() {
    println!("Hello, world!");
}
```

- `fn main()` is the program entry point for binaries.
- `println!` is a **macro** (the `!` marks macros). It writes to stdout with a newline.
- Statements end with `;` when they do not produce a value used as an expression.

Slightly richer first program:

```rust
fn main() {
    let name = "Rustacean";
    let year = 2026;
    println!("Hello, {name}! Welcome to Rust in {year}.");
    eprintln!("(diagnostics go to stderr with eprintln!)");
}
```

```bash
cargo run
```

## Build Artifacts and Profiles

```bash
cargo build          # debug build → target/debug/
cargo build --release  # optimized → target/release/
cargo run --release
```

| Profile | Speed to compile | Runtime speed | Typical use |
|---------|------------------|---------------|-------------|
| dev (default) | Faster | Slower | Day-to-day learning |
| release | Slower | Faster | Benchmarks, shipping |

The `target/` directory is gitignored in most projects. Do not commit build products.

## The Daily Cargo Loop

```bash
cargo check    # typecheck without full codegen — fastest feedback
cargo run      # build + run binary
cargo test     # run tests (empty project still works)
cargo fmt      # format all Rust sources
cargo clippy   # lints beyond the compiler
cargo clean    # delete target/ if you need a full rebuild
```

Example of fixing a clippy/style issue early: prefer format args:

```rust
fn main() {
    let x = 42;
    // older style still works:
    // println!("x = {}", x);
    // idiomatic:
    println!("x = {x}");
}
```

## `println!` Formatting Basics

```rust
fn main() {
    let a = 10;
    let b = 3.5;
    let name = "cargo";

    println!("a = {a}, b = {b}, name = {name}");
    println!("a in hex = {a:x}, debug tuple = {:?}", (a, b));
    println!("padded = {a:04}");
}
```

- `{var}` — display format (`Display`).
- `{:?}` — debug format (`Debug`).
- Specifiers like `:x`, `:04` control number formatting.

## Multiple Binaries and `src/bin` (Optional Preview)

A package can grow extra binaries under `src/bin/`:

```text
src/
  main.rs          # default binary (package name)
  bin/
    tool.rs        # cargo run --bin tool
```

For this chapter, stick to a single `main.rs`. You will structure multi-binary/workspace layouts later.

## Environment and PATH

After rustup install, ensure `~/.cargo/bin` is on your `PATH` so `cargo` and `rustc` resolve:

```bash
echo "$PATH" | tr ':' '\n' | grep cargo
which cargo
which rustc
```

If commands are missing, re-source the env file or restart the terminal.

## Editor Setup (Recommended)

Any editor works. Helpful additions:

- **rust-analyzer** (VS Code, Zed, Neovim, etc.) for inline errors and go-to-definition.
- Format on save via rustfmt.
- Run `cargo check` on save if your editor supports it.

You do not need a heavy IDE to learn; a terminal + editor is enough.

## A Tiny “First Real” Program

Create a project that greets from command-line arguments:

```bash
cargo new greeter
cd greeter
```

`src/main.rs`:

```rust
use std::env;

fn main() {
    let mut args = env::args().skip(1); // skip program name
    let name = args.next().unwrap_or_else(|| "world".to_string());
    let times: usize = args
        .next()
        .and_then(|s| s.parse().ok())
        .unwrap_or(1);

    for i in 1..=times {
        println!("{i}: Hello, {name}!");
    }
}
```

```bash
cargo run
cargo run -- Ferris
cargo run -- Rust 3
```

Notes:

- `env::args()` yields the program name first; we `skip(1)`.
- `unwrap_or` / `unwrap_or_else` provide defaults without panicking on missing args.
- Later chapters replace casual unwraps with proper `Result` handling for fallible parsing in libraries.

## Library Crate Quick Look

```bash
cargo new greeter_lib --lib
cd greeter_lib
```

`src/lib.rs`:

```rust
/// Returns a greeting string.
pub fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greets() {
        assert_eq!(greet("Rust"), "Hello, Rust!");
    }
}
```

```bash
cargo test
```

You will deepen testing in Intermediate. Early exposure shows that **tests live next to code** and run with one command.

## Offline Docs

```bash
rustup doc --std
# or package-local:
cargo doc --open
```

Reading `std` docs is a core skill. Prefer docs + compiler messages over random outdated blog snippets.

## Hands-On Practice

1. Install/update rustup. Record `rustc --version` and `cargo --version`.
2. `cargo new setup_lab` and change the message to include your name and the year 2026.
3. Run `cargo build --release` and execute the binary from `target/release/` directly.
4. Break the program (e.g. remove a semicolon wrongly, or call an undefined function). Run `cargo check` and fix from the error message alone.
5. Add the greeter-with-args example; try zero, one, and two arguments.
6. Run `cargo fmt` and `cargo clippy`. Address any clippy suggestions you understand.
7. Create a `--lib` crate with one public function and one unit test; `cargo test` must pass.

```rust
// practice: deliberate error exploration — fix until `cargo check` is clean
fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    let sum = add(2, 40);
    println!("2 + 40 = {sum}");
    assert_eq!(sum, 42);
}
```

## Common Mistakes

- **Installing only an old distro package** of Rust without rustup — versions lag; prefer rustup for learning.
- **Editing files outside the project** and wondering why `cargo run` does nothing.
- **Confusing `cargo run` args** — pass program args after `--`: `cargo run -- --help` style patterns.
- **Committing `target/`** — large and machine-specific; keep it out of git.
- **Ignoring edition** — mismatched mental model with books written for older editions; set edition intentionally.
- **Using `rustc main.rs` only** — fine for one-file experiments, incomplete for real crates and dependencies.

## Chapter Summary

You installed Rust with **rustup**, created a Cargo project, ran **Hello World**, and learned the **manifest + `src/main.rs`** layout. Daily tools are `check`, `run`, `test`, `fmt`, and `clippy`. Next: **variables and mutability**—how Rust binds names to values and why immutability is the default.
