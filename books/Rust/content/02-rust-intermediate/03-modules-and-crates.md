# Modules and Crates

## Learning Goals

- Explain packages, crates, and modules in Cargo’s model.
- Organize code with `mod`, `use`, and filesystem layouts.
- Apply privacy rules (`pub`, `pub(crate)`, private by default).
- Split a binary + library package for testable design.
- Add a dependency from crates.io and use it.

## Packages, Crates, Modules

| Term | Meaning |
|------|---------|
| **Package** | What Cargo builds; defined by `Cargo.toml` |
| **Crate** | A compilation unit: library and/or binaries |
| **Module** | Namespace inside a crate for privacy and organization |

A package can contain **at most one library crate** and **any number of binary crates**.

```text
my_app/
  Cargo.toml
  src/
    lib.rs          # library crate root (optional but recommended)
    main.rs         # default binary crate root
    bin/extra.rs    # extra binary
```

## Inline Modules

```rust
mod network {
    pub fn connect() {
        println!("connected");
    }

    fn internal() {
        println!("secret");
    }

    pub mod tcp {
        pub fn send() {
            println!("tcp send");
            super::internal();
        }
    }
}

fn main() {
    network::connect();
    network::tcp::send();
    // network::internal(); // private
}
```

- Parent modules can access child private items; siblings cannot see each other’s private items.
- `super` = parent, `crate` = crate root, `self` = current.

## Filesystem Modules

For larger code:

```text
src/
  main.rs
  network.rs          # mod network;
  network/
    mod.rs            # alternative style for network module root
    tcp.rs
```

Modern style (Rust 2018+):

```text
src/
  lib.rs
  network/
    mod.rs
    tcp.rs
```

Or:

```text
src/
  lib.rs
  network.rs       # contains `pub mod tcp;`
  network/tcp.rs
```

### Example layout

`src/lib.rs`:

```rust
pub mod network;
pub mod notes;

pub use notes::{load, save, Note};
```

`src/notes.rs`:

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Note {
    pub id: u32,
    pub text: String,
}

pub fn load() -> Vec<Note> {
    Vec::new()
}

pub fn save(_notes: &[Note]) {}
```

`src/network/mod.rs`:

```rust
pub mod tcp;

pub fn connect() {
    tcp::handshake();
}
```

`src/network/tcp.rs`:

```rust
pub fn handshake() {
    println!("handshake");
}
```

`src/main.rs`:

```rust
use my_app::{network, Note};

fn main() {
    network::connect();
    let n = Note {
        id: 1,
        text: "hi".into(),
    };
    println!("{n:?}");
}
```

Replace `my_app` with your package name from `Cargo.toml`.

## Privacy Rules

Items are **private by default**.

```rust
mod outer {
    pub struct Thing {
        pub name: String,
        secret: u32,
    }

    impl Thing {
        pub fn new(name: impl Into<String>) -> Self {
            Self {
                name: name.into(),
                secret: 42,
            }
        }

        pub fn secret(&self) -> u32 {
            self.secret
        }
    }

    pub(crate) fn crate_visible() {}
}

fn main() {
    let t = outer::Thing::new("x");
    println!("{} {}", t.name, t.secret());
    outer::crate_visible();
}
```

| Visibility | Who can use |
|------------|-------------|
| (default) | Same module + descendants |
| `pub` | Everyone |
| `pub(crate)` | Same crate |
| `pub(super)` | Parent module |

Making a struct `pub` does **not** make its fields public—mark fields separately.

## The `use` Keyword

```rust
use std::collections::HashMap;
use std::fs::{self, File};
use std::io::{self, Read, Write as IoWrite};

fn main() -> io::Result<()> {
    let mut m: HashMap<_, _> = HashMap::new();
    m.insert("k", 1);
    let _ = File::open("Cargo.toml");
    fs::metadata("Cargo.toml")?;
    Ok(())
}
```

### Re-exports

```rust
// lib.rs
mod internal {
    pub struct Engine;
}
pub use internal::Engine; // clients use mycrate::Engine
```

### Idiomatic paths

- Prefer `use crate::notes::Note` inside the same crate.
- External crates: `use serde::Serialize;`
- Bring traits into scope to use their methods: `use std::io::Write;`

## Binary + Library Pattern

This is the Intermediate default for real tools:

```toml
# Cargo.toml
[package]
name = "notes"
version = "0.1.0"
edition = "2024"
```

```text
src/lib.rs   # API + tests
src/main.rs  # thin CLI
```

`src/lib.rs`:

```rust
pub fn greet(name: &str) -> String {
    format!("Hello, {name}!")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn greets() {
        assert_eq!(greet("a"), "Hello, a!");
    }
}
```

`src/main.rs`:

```rust
use notes::greet;

fn main() {
    println!("{}", greet("Rust"));
}
```

```bash
cargo test
cargo run
```

Integration tests live in `tests/*.rs` and can only see **public** API:

```rust
// tests/greet.rs
use notes::greet;

#[test]
fn integration() {
    assert!(greet("x").contains("x"));
}
```

## Adding Dependencies

```bash
cargo add serde --features derive
# or edit Cargo.toml:
```

```toml
[dependencies]
serde = { version = "1", features = ["derive"] }
```

```rust
use serde::Serialize;

#[derive(Serialize)]
struct Point {
    x: i32,
    y: i32,
}
```

```bash
cargo build
```

Pick versions intentionally; run `cargo update` carefully in apps.

## Workspaces (Awareness)

Large monorepos use workspaces:

```toml
[workspace]
members = ["crates/core", "crates/cli"]
```

You do not need a workspace yet; know it exists for multi-crate projects.

## `mod` Declaration Rules

In the crate root (`lib.rs` / `main.rs`):

```rust
mod a; // looks for a.rs or a/mod.rs
```

In `a.rs`:

```rust
pub mod b; // looks for a/b.rs
```

Do not declare `mod a;` from random files that are not parents—structure must match the tree.

## Worked Example: Small Crate Map

```text
notes/
  Cargo.toml
  src/
    lib.rs
    main.rs
    model.rs
    storage.rs
    cli.rs
```

`lib.rs`:

```rust
mod model;
mod storage;
pub mod cli;

pub use model::Note;
pub use storage::{load_notes, save_notes};
```

`model.rs`:

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Note {
    pub id: u32,
    pub text: String,
}
```

`storage.rs`:

```rust
use crate::Note;
use std::path::Path;

pub fn load_notes(_path: impl AsRef<Path>) -> Result<Vec<Note>, String> {
    Ok(vec![])
}

pub fn save_notes(_path: impl AsRef<Path>, _notes: &[Note]) -> Result<(), String> {
    Ok(())
}
```

`cli.rs`:

```rust
use crate::{load_notes, save_notes, Note};

pub fn run() -> Result<(), String> {
    let mut notes = load_notes("notes.db")?;
    notes.push(Note {
        id: 1,
        text: "hi".into(),
    });
    save_notes("notes.db", &notes)?;
    Ok(())
}
```

`main.rs`:

```rust
fn main() {
    if let Err(e) = notes::cli::run() {
        eprintln!("{e}");
        std::process::exit(1);
    }
}
```

## Hands-On Practice

1. Take any Basics project and split it into `lib.rs` + `main.rs`.
2. Move types into `model.rs` and I/O into `storage.rs` with `mod` declarations.
3. Make only the CLI-facing functions `pub`; keep helpers private.
4. Add an integration test under `tests/`.
5. `cargo add uuid` (or another small crate) and generate an id in a constructor—or skip network and use a local pure crate if offline.
6. Run `cargo doc --open` and check your public API surface.

```bash
cargo new mod_lab --lib
cd mod_lab
mkdir -p src
# edit lib.rs / add modules / add src/main.rs by changing package or cargo new --bin sibling
```

Minimal multi-file lib:

```rust
// src/lib.rs
mod math;

pub use math::add;

// src/math.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn unused_private() {}

// tests/add.rs
#[test]
fn adds() {
    assert_eq!(mod_lab::add(2, 2), 4);
}
```

## Common Mistakes

- **`pub` on everything** — larger API, harder evolution.
- **Circular modules** — redesign dependencies; extract shared module.
- **Declaring `mod foo` in multiple places**.
- **Putting logic only in `main.rs`** — hard to test; extract lib.
- **Confusing package name and module path** — `use package_name::...` for extern; `crate::` inside.

## Chapter Summary

Cargo packages contain crates; crates contain modules. Privacy is **closed by default**. Prefer **library + thin binary**, clear module boundaries, and intentional `pub` surfaces. Next: **traits**—shared behavior across types.
