# Project 1: CLI Notes App

## Goal

Build a command-line notes manager to practice ownership, file I/O, and error handling.

## Feature Scope

- `notes add "text"`
- `notes list`
- `notes done <id>`
- data persisted in a local file

## Data Model

```rust
#[derive(Debug, Clone)]
struct Note {
    id: u32,
    text: String,
    done: bool,
}
```

## Minimal CLI Routing

```rust
use std::env;

fn main() {
    let args: Vec<String> = env::args().collect();
    match args.get(1).map(String::as_str) {
        Some("add") => println!("add flow"),
        Some("list") => println!("list flow"),
        Some("done") => println!("done flow"),
        _ => println!("Usage: notes <add|list|done> ..."),
    }
}
```

## File Storage Example

```rust
use std::fs;
use std::path::Path;

fn ensure_data_file(path: &Path) -> std::io::Result<()> {
    if !path.exists() {
        fs::write(path, "[]")?;
    }
    Ok(())
}
```

## Suggested Crates

- `serde`, `serde_json` for JSON persistence
- `clap` for command parsing
- `anyhow` for ergonomic error propagation

## Quality Checklist

- `cargo fmt --check`
- `cargo clippy -- -D warnings`
- `cargo test`

## Extension Ideas

1. Add tags and filtering.
2. Add due dates.
3. Add export to Markdown.

## Detailed Implementation Plan

1. Parse command arguments.
2. Load notes from JSON file.
3. Apply command mutation/query.
4. Persist updated notes.
5. Print user-friendly output.

## Example: JSON Persistence

```rust
use serde::{Deserialize, Serialize};
use std::fs;

#[derive(Debug, Clone, Serialize, Deserialize)]
struct Note {
    id: u32,
    text: String,
    done: bool,
}

fn load_notes(path: &str) -> anyhow::Result<Vec<Note>> {
    let raw = fs::read_to_string(path).unwrap_or_else(|_| "[]".to_string());
    Ok(serde_json::from_str(&raw)?)
}

fn save_notes(path: &str, notes: &[Note]) -> anyhow::Result<()> {
    let raw = serde_json::to_string_pretty(notes)?;
    fs::write(path, raw)?;
    Ok(())
}
```

## Example: Add and Complete Commands

```rust
fn add_note(notes: &mut Vec<Note>, text: String) {
    let id = notes.iter().map(|n| n.id).max().unwrap_or(0) + 1;
    notes.push(Note { id, text, done: false });
}

fn complete_note(notes: &mut [Note], id: u32) -> bool {
    if let Some(n) = notes.iter_mut().find(|n| n.id == id) {
        n.done = true;
        return true;
    }
    false
}
```

## Suggested Test Cases

- add command creates incremental IDs.
- done command marks correct note.
- loading empty/missing file initializes default state.

## Project Rubric

- Correctness: 40%
- Error handling quality: 25%
- Code structure and naming: 20%
- Documentation and UX: 15%
