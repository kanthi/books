# Intermediate Project

## Learning Goals

- Build a multi-module Rust package with **library + binary**.
- Combine structs, enums, traits (lightly), `Result` errors, and tests.
- Persist data, parse CLI commands, and keep the public API small.
- Optional stretch: background save worker via channels.
- Leave Intermediate with a maintainable project structure you can grow.

## Project: `taskr` — Task Tracker CLI

Ship a small **task tracker** that stores tasks on disk.

| Command | Behavior |
|---------|----------|
| `taskr add <text>` | Add a pending task |
| `taskr list` | List tasks (`--all` includes done) |
| `taskr done <id>` | Mark task completed |
| `taskr rm <id>` | Remove a task |
| `taskr help` | Usage |

Storage file: `tasks.json`-like **simpler line format** (stdlib only):

```text
1|pending|write tests
2|done|install rustup
```

Format: `id|status|text` where status is `pending` or `done`.

Why not full JSON without deps? Keeps the project focused on language design. Stretch: add `serde_json` later.

## Create the Package

```bash
cargo new taskr
cd taskr
```

Restructure:

```text
taskr/
  Cargo.toml
  src/
    main.rs
    lib.rs
    model.rs
    store.rs
    service.rs
    cli.rs
  tests/
    store_roundtrip.rs
```

`Cargo.toml`:

```toml
[package]
name = "taskr"
version = "0.1.0"
edition = "2024"
```

## Implementation

### `src/model.rs`

```rust
use std::fmt;
use std::str::FromStr;

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Status {
    Pending,
    Done,
}

impl fmt::Display for Status {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            Status::Pending => write!(f, "pending"),
            Status::Done => write!(f, "done"),
        }
    }
}

impl FromStr for Status {
    type Err = String;
    fn from_str(s: &str) -> Result<Self, Self::Err> {
        match s {
            "pending" => Ok(Status::Pending),
            "done" => Ok(Status::Done),
            other => Err(format!("unknown status: {other}")),
        }
    }
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Task {
    pub id: u32,
    pub status: Status,
    pub text: String,
}

impl Task {
    pub fn new(id: u32, text: impl Into<String>) -> Result<Self, String> {
        let text = text.into().trim().to_string();
        if text.is_empty() {
            return Err("task text empty".into());
        }
        if text.contains('|') {
            return Err("task text cannot contain '|'".into());
        }
        Ok(Self {
            id,
            status: Status::Pending,
            text,
        })
    }

    pub fn to_line(&self) -> String {
        format!("{}|{}|{}", self.id, self.status, self.text)
    }

    pub fn from_line(line: &str) -> Result<Self, String> {
        let mut parts = line.splitn(3, '|');
        let id = parts
            .next()
            .ok_or("missing id")?
            .parse()
            .map_err(|e| format!("id: {e}"))?;
        let status = parts.next().ok_or("missing status")?.parse()?;
        let text = parts.next().ok_or("missing text")?.to_string();
        if text.trim().is_empty() {
            return Err("empty text".into());
        }
        Ok(Self { id, status, text })
    }
}
```

### `src/store.rs`

```rust
use crate::model::Task;
use std::fs;
use std::path::{Path, PathBuf};

#[derive(Debug)]
pub enum StoreError {
    Io { path: PathBuf, source: std::io::Error },
    Parse { line: usize, message: String },
}

impl std::fmt::Display for StoreError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            StoreError::Io { path, source } => {
                write!(f, "I/O on {}: {source}", path.display())
            }
            StoreError::Parse { line, message } => {
                write!(f, "line {line}: {message}")
            }
        }
    }
}

impl std::error::Error for StoreError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            StoreError::Io { source, .. } => Some(source),
            StoreError::Parse { .. } => None,
        }
    }
}

pub fn default_path() -> PathBuf {
    std::env::var_os("TASKR_PATH")
        .map(PathBuf::from)
        .unwrap_or_else(|| PathBuf::from("tasks.db"))
}

pub fn load(path: impl AsRef<Path>) -> Result<Vec<Task>, StoreError> {
    let path = path.as_ref();
    if !path.exists() {
        return Ok(Vec::new());
    }
    let data = fs::read_to_string(path).map_err(|source| StoreError::Io {
        path: path.to_path_buf(),
        source,
    })?;
    let mut tasks = Vec::new();
    for (idx, line) in data.lines().enumerate() {
        let line = line.trim();
        if line.is_empty() {
            continue;
        }
        let task = Task::from_line(line).map_err(|message| StoreError::Parse {
            line: idx + 1,
            message,
        })?;
        tasks.push(task);
    }
    Ok(tasks)
}

pub fn save(path: impl AsRef<Path>, tasks: &[Task]) -> Result<(), StoreError> {
    let path = path.as_ref();
    let mut body = String::new();
    for t in tasks {
        body.push_str(&t.to_line());
        body.push('\n');
    }
    let tmp = path.with_extension("db.tmp");
    fs::write(&tmp, body.as_bytes()).map_err(|source| StoreError::Io {
        path: tmp.clone(),
        source,
    })?;
    fs::rename(&tmp, path).map_err(|source| StoreError::Io {
        path: path.to_path_buf(),
        source,
    })?;
    Ok(())
}
```

### `src/service.rs`

```rust
use crate::model::{Status, Task};
use crate::store::{self, StoreError};
use std::path::Path;

#[derive(Debug)]
pub enum ServiceError {
    Store(StoreError),
    Msg(String),
}

impl std::fmt::Display for ServiceError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ServiceError::Store(e) => write!(f, "{e}"),
            ServiceError::Msg(m) => write!(f, "{m}"),
        }
    }
}

impl std::error::Error for ServiceError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            ServiceError::Store(e) => Some(e),
            ServiceError::Msg(_) => None,
        }
    }
}

impl From<StoreError> for ServiceError {
    fn from(value: StoreError) -> Self {
        ServiceError::Store(value)
    }
}

impl From<String> for ServiceError {
    fn from(value: String) -> Self {
        ServiceError::Msg(value)
    }
}

pub struct TaskService {
    path: std::path::PathBuf,
}

impl TaskService {
    pub fn new(path: impl AsRef<Path>) -> Self {
        Self {
            path: path.as_ref().to_path_buf(),
        }
    }

    pub fn add(&self, text: &str) -> Result<Task, ServiceError> {
        let mut tasks = store::load(&self.path)?;
        let id = tasks.iter().map(|t| t.id).max().unwrap_or(0) + 1;
        let task = Task::new(id, text)?;
        tasks.push(task.clone());
        store::save(&self.path, &tasks)?;
        Ok(task)
    }

    pub fn list(&self, include_done: bool) -> Result<Vec<Task>, ServiceError> {
        let tasks = store::load(&self.path)?;
        Ok(tasks
            .into_iter()
            .filter(|t| include_done || t.status == Status::Pending)
            .collect())
    }

    pub fn mark_done(&self, id: u32) -> Result<(), ServiceError> {
        let mut tasks = store::load(&self.path)?;
        let Some(task) = tasks.iter_mut().find(|t| t.id == id) else {
            return Err(ServiceError::Msg(format!("task {id} not found")));
        };
        task.status = Status::Done;
        store::save(&self.path, &tasks)?;
        Ok(())
    }

    pub fn remove(&self, id: u32) -> Result<(), ServiceError> {
        let mut tasks = store::load(&self.path)?;
        let before = tasks.len();
        tasks.retain(|t| t.id != id);
        if tasks.len() == before {
            return Err(ServiceError::Msg(format!("task {id} not found")));
        }
        store::save(&self.path, &tasks)?;
        Ok(())
    }
}
```

### `src/cli.rs`

```rust
use crate::service::TaskService;
use crate::store;
use std::env;

#[derive(Debug)]
pub enum Command {
    Add { text: String },
    List { all: bool },
    Done { id: u32 },
    Remove { id: u32 },
    Help,
}

pub fn parse_args<I>(mut args: I) -> Result<Command, String>
where
    I: Iterator<Item = String>,
{
    let Some(cmd) = args.next() else {
        return Ok(Command::Help);
    };
    match cmd.as_str() {
        "help" | "-h" | "--help" => Ok(Command::Help),
        "add" => {
            let text = args.collect::<Vec<_>>().join(" ");
            if text.trim().is_empty() {
                return Err("usage: taskr add <text>".into());
            }
            Ok(Command::Add { text })
        }
        "list" => {
            let all = args.any(|a| a == "--all" || a == "-a");
            Ok(Command::List { all })
        }
        "done" => {
            let id = args
                .next()
                .ok_or("usage: taskr done <id>")?
                .parse()
                .map_err(|e| format!("id: {e}"))?;
            Ok(Command::Done { id })
        }
        "rm" | "remove" => {
            let id = args
                .next()
                .ok_or("usage: taskr rm <id>")?
                .parse()
                .map_err(|e| format!("id: {e}"))?;
            Ok(Command::Remove { id })
        }
        other => Err(format!("unknown command: {other}")),
    }
}

pub fn print_help() {
    eprintln!(
        "\
taskr — intermediate task tracker

USAGE:
  taskr add <text...>
  taskr list [--all]
  taskr done <id>
  taskr rm <id>
  taskr help

ENV:
  TASKR_PATH   override DB path (default ./tasks.db)
"
    );
}

pub fn run() -> Result<(), String> {
    let cmd = parse_args(env::args().skip(1))?;
    let svc = TaskService::new(store::default_path());
    match cmd {
        Command::Help => {
            print_help();
            Ok(())
        }
        Command::Add { text } => {
            let t = svc.add(&text).map_err(|e| e.to_string())?;
            println!("added #{} {}", t.id, t.text);
            Ok(())
        }
        Command::List { all } => {
            let tasks = svc.list(all).map_err(|e| e.to_string())?;
            if tasks.is_empty() {
                println!("(no tasks)");
                return Ok(());
            }
            for t in tasks {
                println!("{:>4}  [{:7}]  {}", t.id, t.status, t.text);
            }
            Ok(())
        }
        Command::Done { id } => {
            svc.mark_done(id).map_err(|e| e.to_string())?;
            println!("done #{id}");
            Ok(())
        }
        Command::Remove { id } => {
            svc.remove(id).map_err(|e| e.to_string())?;
            println!("removed #{id}");
            Ok(())
        }
    }
}
```

### `src/lib.rs`

```rust
pub mod cli;
pub mod model;
pub mod service;
pub mod store;

pub use model::{Status, Task};
pub use service::TaskService;
```

### `src/main.rs`

```rust
fn main() {
    if let Err(e) = taskr::cli::run() {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}
```

### Unit tests in `model` (add to `model.rs`)

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn roundtrip_line() {
        let t = Task::new(3, "ship it").unwrap();
        let parsed = Task::from_line(&t.to_line()).unwrap();
        assert_eq!(t, parsed);
    }

    #[test]
    fn rejects_pipe() {
        assert!(Task::new(1, "a|b").is_err());
    }
}
```

### Integration test `tests/store_roundtrip.rs`

```rust
use std::fs;
use taskr::model::{Status, Task};
use taskr::store;

#[test]
fn save_load() {
    let dir = std::env::temp_dir().join(format!("taskr-{}", std::process::id()));
    let _ = fs::create_dir_all(&dir);
    let path = dir.join("tasks.db");

    let tasks = vec![
        Task::new(1, "one").unwrap(),
        Task {
            id: 2,
            status: Status::Done,
            text: "two".into(),
        },
    ];
    store::save(&path, &tasks).unwrap();
    let loaded = store::load(&path).unwrap();
    assert_eq!(loaded, tasks);

    let _ = fs::remove_dir_all(&dir);
}
```

## Run and Verify

```bash
cargo test
cargo run -- add write intermediate project
cargo run -- add learn channels later
cargo run -- list
cargo run -- done 1
cargo run -- list
cargo run -- list --all
cargo run -- rm 2
cargo run -- list --all
cargo fmt
cargo clippy
```

## Architecture Review

```text
main  →  cli  →  service  →  store  →  filesystem
                    ↑
                  model
```

| Layer | Responsibility |
|-------|----------------|
| `model` | Pure domain types, parsing lines |
| `store` | Load/save only |
| `service` | Business operations |
| `cli` | Args + printing |
| `main` | Process exit |

This layering is the Intermediate skill beyond “everything in main.”

## Ownership Notes

- `Task` is **owned** data; lists are `Vec<Task>`.
- Service methods borrow `text: &str`, own returned `Task` clones when needed.
- Store borrows `&[Task]` on save—no needless moves.
- Errors are **typed** at store/service; CLI maps to `String` for simple exits (upgrade to `thiserror`/`anyhow` as stretch).

## Stretch Goals

1. **`taskr search <query>`** case-insensitive filter.
2. **Replace `String` CLI errors** with `anyhow` in the binary only.
3. **Background writer:** channel of `Vec<Task>` snapshots; worker thread writes disk (careful with shutdown/`join`).
4. **`serde` + JSON** storage.
5. **Library trait** `trait TaskRepo { fn load...; fn save...; }` with in-memory fake for tests.
6. **IDs as newtype** `struct TaskId(u32)` with `Display`/`FromStr`.

### Stretch sketch: in-memory repo for tests

```rust
pub trait TaskRepo {
    fn load(&self) -> Result<Vec<Task>, ServiceError>;
    fn save(&self, tasks: &[Task]) -> Result<(), ServiceError>;
}
```

Implement for a `struct FileRepo(PathBuf)` and `struct MemRepo(Mutex<Vec<Task>>)`.

## Hands-On Practice

1. Implement the project by typing modules yourself.
2. Add `search` stretch or `done` on already-done tasks should be idempotent—decide and test.
3. Break `tasks.db` with a bad line; ensure error shows line number.
4. Export `TASKR_PATH=/tmp/mytasks.db` and verify isolation.
5. Draw the module diagram from memory.
6. Write three new unit tests for `parse_args`.

```rust
#[cfg(test)]
mod cli_tests {
    use super::*;

    #[test]
    fn list_all_flag() {
        let cmd = parse_args(["list".into(), "--all".into()].into_iter()).unwrap();
        match cmd {
            Command::List { all } => assert!(all),
            _ => panic!("wrong cmd"),
        }
    }
}
```

(Place inside `cli.rs` with `use super::*` pattern.)

## Common Mistakes

- **Fat `main.rs`** without modules—hard to test.
- **Mixing printing into service layer** — keep side effects at CLI edge when possible.
- **Not testing parse/store separately**.
- **Racey multi-process writes** to the same db file—acceptable for personal tools; document the limitation.
- **Silent `unwrap` on I/O** in library modules.

## Chapter Summary

You completed an **Intermediate project**: modular design, domain model, persistence, typed errors, CLI, and tests. This is the template for real Rust tools.  

**Intermediate complete.** Continue into **Rust Advanced** (async, smart pointers, unsafe, macros, FFI, performance) when ready—still using the same ownership and module discipline.
