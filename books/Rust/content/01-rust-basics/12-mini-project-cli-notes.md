# Mini Project: CLI Notes App

## Learning Goals

- Combine ownership, strings, collections, and `Result` in one small program.
- Build a CLI that **adds**, **lists**, and **persists** notes to a file.
- Structure code as functions with clear error propagation (`?`).
- Practice `cargo run -- <args>`, tests for pure helpers, and clippy/fmt hygiene.
- Leave Basics with a portfolio-ready micro-tool you understand end-to-end.

## Project Spec

Build **`notes`**: a command-line notes tool.

| Command | Behavior |
|---------|----------|
| `notes add <text...>` | Append a note with an auto-increment id |
| `notes list` | Print all notes |
| `notes` / help | Show usage |

Persistence: plain text file `notes.db` in the current directory:

```text
1|buy milk
2|learn rust ownership
```

Constraints for this chapter (keep it basic-friendly):

- Standard library only (no clap yet).
- `Result` + `?` for I/O and parsing.
- `String` / `Vec` / file I/O from `std::fs`.

## Create the Project

```bash
cargo new notes
cd notes
```

Set edition in `Cargo.toml` if needed:

```toml
[package]
name = "notes"
version = "0.1.0"
edition = "2024"
```

## Design

```text
main
  ├─ parse Args from env::args
  ├─ load notes from path  → Vec<Note>
  ├─ dispatch command
  │    ├─ Add → push note, save
  │    └─ List → print
  └─ map errors to exit code
```

### Data model

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
struct Note {
    id: u32,
    text: String,
}
```

### Ownership notes

- Load returns **owned** `Vec<Note>`.
- Add takes `&mut Vec<Note>` and owned/borrowed text.
- Save **borrows** the slice of notes to write.
- Parsing a line borrows `&str` and produces owned `Note`.

## Full Implementation

Replace `src/main.rs` with the following complete program:

```rust
use std::env;
use std::fs::{self, OpenOptions};
use std::io::{self, Write};
use std::path::Path;
use std::process;

const DB_PATH: &str = "notes.db";

#[derive(Debug, Clone, PartialEq, Eq)]
struct Note {
    id: u32,
    text: String,
}

#[derive(Debug)]
enum Command {
    Add { text: String },
    List,
    Help,
}

fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e}");
        process::exit(1);
    }
}

fn run() -> Result<(), String> {
    let cmd = parse_args(env::args().skip(1))?;
    match cmd {
        Command::Help => {
            print_help();
            Ok(())
        }
        Command::List => {
            let notes = load_notes(DB_PATH)?;
            list_notes(&notes);
            Ok(())
        }
        Command::Add { text } => {
            let mut notes = load_notes(DB_PATH)?;
            add_note(&mut notes, &text);
            save_notes(DB_PATH, &notes)?;
            let last = notes.last().expect("just added");
            println!("added note #{}: {}", last.id, last.text);
            Ok(())
        }
    }
}

fn print_help() {
    eprintln!(
        "\
notes — tiny CLI notebook

USAGE:
  notes add <text...>   Add a note
  notes list            List notes
  notes help            Show this help

Data file: {DB_PATH} (current directory)
"
    );
}

fn parse_args<I>(mut args: I) -> Result<Command, String>
where
    I: Iterator<Item = String>,
{
    let Some(cmd) = args.next() else {
        return Ok(Command::Help);
    };
    match cmd.as_str() {
        "help" | "-h" | "--help" => Ok(Command::Help),
        "list" | "ls" => Ok(Command::List),
        "add" => {
            let text = args.collect::<Vec<_>>().join(" ");
            let text = text.trim().to_string();
            if text.is_empty() {
                return Err("add requires note text".into());
            }
            Ok(Command::Add { text })
        }
        other => Err(format!("unknown command: {other}")),
    }
}

fn parse_note_line(line: &str) -> Result<Option<Note>, String> {
    let line = line.trim();
    if line.is_empty() {
        return Ok(None);
    }
    let Some((id_str, text)) = line.split_once('|') else {
        return Err(format!("invalid line (expected id|text): {line}"));
    };
    let id: u32 = id_str
        .trim()
        .parse()
        .map_err(|e| format!("bad id in '{line}': {e}"))?;
    let text = text.trim().to_string();
    if text.is_empty() {
        return Err(format!("empty text in line: {line}"));
    }
    Ok(Some(Note { id, text }))
}

fn load_notes(path: impl AsRef<Path>) -> Result<Vec<Note>, String> {
    let path = path.as_ref();
    if !path.exists() {
        return Ok(Vec::new());
    }
    let data = fs::read_to_string(path).map_err(|e| format!("read {}: {e}", path.display()))?;
    let mut notes = Vec::new();
    for (lineno, line) in data.lines().enumerate() {
        match parse_note_line(line) {
            Ok(Some(n)) => notes.push(n),
            Ok(None) => {}
            Err(e) => return Err(format!("line {}: {e}", lineno + 1)),
        }
    }
    Ok(notes)
}

fn next_id(notes: &[Note]) -> u32 {
    notes.iter().map(|n| n.id).max().unwrap_or(0) + 1
}

fn add_note(notes: &mut Vec<Note>, text: &str) {
    let note = Note {
        id: next_id(notes),
        text: text.to_string(),
    };
    notes.push(note);
}

fn format_note_line(note: &Note) -> String {
    format!("{}|{}", note.id, note.text)
}

fn save_notes(path: impl AsRef<Path>, notes: &[Note]) -> Result<(), String> {
    let path = path.as_ref();
    let mut body = String::new();
    for n in notes {
        body.push_str(&format_note_line(n));
        body.push('\n');
    }
    // Write atomically-ish: write temp then rename when possible.
    let tmp = path.with_extension("db.tmp");
    fs::write(&tmp, body.as_bytes()).map_err(|e| format!("write {}: {e}", tmp.display()))?;
    fs::rename(&tmp, path).map_err(|e| format!("rename to {}: {e}", path.display()))?;
    Ok(())
}

fn list_notes(notes: &[Note]) {
    if notes.is_empty() {
        println!("(no notes yet)");
        return;
    }
    for n in notes {
        println!("{:>4}  {}", n.id, n.text);
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_line_ok() {
        let n = parse_note_line("2|hello world").unwrap().unwrap();
        assert_eq!(
            n,
            Note {
                id: 2,
                text: "hello world".into()
            }
        );
    }

    #[test]
    fn parse_skips_blank() {
        assert!(parse_note_line("  ").unwrap().is_none());
    }

    #[test]
    fn parse_args_add() {
        let args = ["add".into(), "buy".into(), "milk".into()].into_iter();
        match parse_args(args).unwrap() {
            Command::Add { text } => assert_eq!(text, "buy milk"),
            other => panic!("unexpected {other:?}"),
        }
    }

    #[test]
    fn next_id_from_empty() {
        assert_eq!(next_id(&[]), 1);
    }

    #[test]
    fn add_increments() {
        let mut notes = vec![Note {
            id: 1,
            text: "a".into(),
        }];
        add_note(&mut notes, "b");
        assert_eq!(notes[1].id, 2);
        assert_eq!(notes[1].text, "b");
    }
}
```

### Optional: append-only variant note

The implementation above **rewrites the whole file** on save (simple and correct for small files). An append-only `OpenOptions` approach is a good stretch goal:

```rust
fn append_note_line(path: &Path, note: &Note) -> io::Result<()> {
    let mut f = OpenOptions::new().create(true).append(true).open(path)?;
    writeln!(f, "{}", format_note_line(note))?;
    Ok(())
}
```

Full rewrite makes edits/deletes easier later.

## Run It

```bash
cargo run -- help
cargo run -- add buy milk
cargo run -- add learn ownership and Result
cargo run -- list
cat notes.db
cargo test
cargo fmt
cargo clippy
```

Expected list shape:

```text
   1  buy milk
   2  learn ownership and Result
```

## How the Pieces Map to Earlier Chapters

| Feature | Chapter skill |
|---------|----------------|
| `Note` fields | data types, later structs |
| `Command` enum | preview of Intermediate enums |
| `parse_args` + `let-else` | control flow |
| `String` / split / format | strings |
| `Vec<Note>` | collections |
| `load_notes` / `save_notes` `Result` | error handling |
| `&mut Vec`, `&[Note]`, `&str` | ownership + borrowing |

## Walkthrough: Add Path

1. `parse_args` builds `Command::Add { text }` — owns the text `String`.
2. `load_notes` returns owned vector (empty if no file).
3. `add_note` **mutably borrows** the vec, pushes a new owned `Note`.
4. `save_notes` **immutably borrows** notes, writes UTF-8 lines.
5. Errors bubble as `Result<(), String>` via `?` and `map_err`.

## Stretch Goals (Pick 1–2)

1. **`notes remove <id>`** — filter vec, save again.
2. **`notes search <query>`** — case-insensitive substring filter.
3. **Custom path** via env `NOTES_PATH` or `--file`.
4. **Timestamps** — store `id|epoch|text` (still parse carefully).
5. Split into `lib.rs` + `main.rs` with public API and integration tests.
6. Replace `String` errors with a small `enum NotesError` (preview of Intermediate error design).

### Stretch sketch: remove

```rust
fn remove_note(notes: &mut Vec<Note>, id: u32) -> bool {
    let before = notes.len();
    notes.retain(|n| n.id != id);
    notes.len() != before
}
```

### Stretch sketch: search

```rust
fn search_notes<'a>(notes: &'a [Note], query: &str) -> Vec<&'a Note> {
    let q = query.to_lowercase();
    notes
        .iter()
        .filter(|n| n.text.to_lowercase().contains(&q))
        .collect()
}
```

## Library Split (Recommended Upgrade)

```bash
# after it works as a binary, restructure:
# src/lib.rs  — Note, load, save, parse, add
# src/main.rs — CLI only
```

`src/lib.rs` (core):

```rust
// pub use the types and functions you tested
// main becomes thin:
// notes::run_cli() or call public functions
```

`main.rs` thin wrapper:

```rust
fn main() {
    if let Err(e) = notes::run() {
        eprintln!("error: {e}");
        std::process::exit(1);
    }
}
```

(Adjust module paths to match your split.) This layout matches Intermediate project habits.

## Testing Strategy

- **Unit tests** for pure functions: parse line, parse args, next_id, add_note.
- **File tests** (optional): write to a temp directory.

```rust
#[test]
fn save_load_roundtrip() {
    let dir = std::env::temp_dir().join(format!("notes-test-{}", std::process::id()));
    let _ = fs::create_dir_all(&dir);
    let path = dir.join("notes.db");
    let notes = vec![
        Note {
            id: 1,
            text: "a".into(),
        },
        Note {
            id: 2,
            text: "b".into(),
        },
    ];
    save_notes(&path, &notes).unwrap();
    let loaded = load_notes(&path).unwrap();
    assert_eq!(loaded, notes);
    let _ = fs::remove_dir_all(&dir);
}
```

## Hands-On Practice

1. Type the program yourself (do not only paste-run). Fix compiler errors as they appear.
2. Add `notes list` empty-state confirmation after deleting `notes.db`.
3. Implement `remove` or `search` stretch goal.
4. Break a line in `notes.db` manually; ensure load reports a clear error.
5. Run `cargo test`, `cargo clippy`, `cargo fmt`.
6. Write a short README section in your own words: how ownership flows on `add`.

## Common Mistakes

- **Forgetting to save** after mutating the in-memory vec.
- **Using `unwrap` on every I/O** instead of `map_err` + `?`.
- **Parsing with `split('|')` only** and not handling missing `|`.
- **Storing notes in memory only** and wondering why list is empty in a new process.
- **Race-prone multi-process writes** — fine for a personal tool; real multi-writer systems need locking (later).
- **UTF-8 text with manual byte indices** — stick to `split_once` and full-string text.

## Chapter Summary

You built a **CLI notes app** that loads and saves a line-oriented database, parses commands, and handles errors without panicking on normal failure paths. This project is the capstone of **Rust Basics**: ownership, borrowing, strings, vectors, and `Result`.  

**Basics complete.** Continue to **Rust Intermediate**: structs and methods, enums and pattern matching, modules, traits, generics, lifetimes, testing, error design, concurrency, and a larger intermediate project.
