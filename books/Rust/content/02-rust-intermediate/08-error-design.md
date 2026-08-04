# Error Design

## Learning Goals

- Design custom error enums for libraries with clear variants.
- Implement `Display` and `Error` for ergonomic reporting.
- Convert between error types with `From` and `?`.
- Choose among **typed errors**, **`thiserror`**, and **`anyhow`** styles.
- Avoid `unwrap` in library code; map errors at application boundaries.

## Principles

1. **Libraries:** prefer structured errors callers can match on (`enum`).
2. **Applications:** often prefer ergonomic boxed/trait errors (`anyhow`) for glue code.
3. **Preserve context** when crossing layers (“read config: …”).
4. **Don’t mix panics** with expected failures.

## Custom Error Enum (Std Only)

```rust
use std::fmt;
use std::num::ParseIntError;

#[derive(Debug)]
enum NotesError {
    Io(std::io::Error),
    Parse(String),
    EmptyText,
    NotFound { id: u32 },
}

impl fmt::Display for NotesError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            NotesError::Io(e) => write!(f, "I/O error: {e}"),
            NotesError::Parse(msg) => write!(f, "parse error: {msg}"),
            NotesError::EmptyText => write!(f, "note text is empty"),
            NotesError::NotFound { id } => write!(f, "note id {id} not found"),
        }
    }
}

impl std::error::Error for NotesError {
    fn source(&self) -> Option<&(dyn std::error::Error + 'static)> {
        match self {
            NotesError::Io(e) => Some(e),
            _ => None,
        }
    }
}

impl From<std::io::Error> for NotesError {
    fn from(value: std::io::Error) -> Self {
        NotesError::Io(value)
    }
}

impl From<ParseIntError> for NotesError {
    fn from(value: ParseIntError) -> Self {
        NotesError::Parse(value.to_string())
    }
}

type Result<T> = std::result::Result<T, NotesError>;

fn parse_id(s: &str) -> Result<u32> {
    Ok(s.trim().parse()?)
}

fn main() {
    match parse_id("x") {
        Ok(id) => println!("{id}"),
        Err(e) => {
            eprintln!("{e}");
            if let Some(src) = std::error::Error::source(&e) {
                eprintln!("caused by: {src}");
            }
        }
    }
}
```

With `From`, `?` converts automatically.

## Mapping Context Without Losing Type

```rust
use std::fs;

fn load(path: &str) -> Result<String, NotesError> {
    fs::read_to_string(path).map_err(|e| {
        // still Io, Display already prefixes
        NotesError::Io(e)
    })
}
```

Or richer variants:

```rust
#[derive(Debug)]
enum NotesError {
    ReadFile {
        path: String,
        source: std::io::Error,
    },
    // ...
}
```

```rust
impl fmt::Display for NotesError {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        match self {
            NotesError::ReadFile { path, source } => {
                write!(f, "read {path}: {source}")
            }
            // ...
            _ => write!(f, "error"),
        }
    }
}
```

(Complete matching omitted for brevity—keep exhaustiveness in real code.)

## `thiserror` Pattern (Idiomatic Libraries)

Add dependency:

```bash
cargo add thiserror
```

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum NotesError {
    #[error("I/O error")]
    Io(#[from] std::io::Error),

    #[error("parse error: {0}")]
    Parse(String),

    #[error("note text is empty")]
    EmptyText,

    #[error("note id {id} not found")]
    NotFound { id: u32 },
}
```

This generates `Display`, `Error`, and `From` for annotated sources—less boilerplate, same design.

## `anyhow` Pattern (Applications)

```bash
cargo add anyhow
```

```rust
use anyhow::{anyhow, Context, Result};

fn parse_port(s: &str) -> Result<u16> {
    let p: u16 = s
        .parse()
        .with_context(|| format!("parsing port from {s:?}"))?;
    if p == 0 {
        return Err(anyhow!("port must be non-zero"));
    }
    Ok(p)
}

fn main() -> Result<()> {
    let p = parse_port("8080")?;
    println!("{p}");
    Ok(())
}
```

- `Result<T>` defaults to `Result<T, anyhow::Error>`.
- Great for binaries and glue.
- Downside: callers cannot easily `match` specific variants unless you keep typed errors underneath.

### Hybrid

Library returns `NotesError`; binary does:

```rust
fn main() -> anyhow::Result<()> {
    run_app().map_err(anyhow::Error::from)?;
    Ok(())
}
```

Or simply print typed errors without anyhow.

## When to Use What

| Context | Prefer |
|---------|--------|
| Reusable library crate | `enum` + `thiserror` (or manual `Error`) |
| CLI / service main | `anyhow` or similar |
| Tiny scripts / learning | `Result<T, String>` temporarily |
| Performance-critical hot path | Avoid heavy allocations in error path if possible |

## Error Enum Design Tips

```rust
#[derive(Debug, Error)]
pub enum ConfigError {
    #[error("missing field `{0}`")]
    MissingField(&'static str),

    #[error("invalid value for `{field}`: {message}")]
    InvalidValue {
        field: &'static str,
        message: String,
    },

    #[error(transparent)]
    Io(#[from] std::io::Error),
}
```

- Prefer **specific variants** over a single `Message(String)` when callers branch.
- Use `transparent` / `source` to chain underlying errors.
- Keep variants stable if you are a public library—adding variants is a breaking change unless non_exhaustive.

```rust
#[non_exhaustive]
#[derive(Debug, Error)]
pub enum ApiError {
    #[error("unauthorized")]
    Unauthorized,
    #[error("not found")]
    NotFound,
}
```

## Converting Option to Result

```rust
fn require<'a>(map: &'a std::collections::HashMap<String, String>, key: &str) -> Result<&'a str, NotesError> {
    map.get(key)
        .map(|s| s.as_str())
        .ok_or(NotesError::Parse(format!("missing {key}")))
}
```

With anyhow: `.ok_or_else(|| anyhow!("missing {key}"))?`.

## Application Boundary

```rust
fn main() {
    if let Err(e) = run() {
        eprintln!("error: {e}");
        // optionally chain:
        let mut src = std::error::Error::source(&e);
        while let Some(s) = src {
            eprintln!("caused by: {s}");
            src = s.source();
        }
        std::process::exit(1);
    }
}

fn run() -> Result<(), NotesError> {
    let id = parse_id("10")?;
    if id == 0 {
        return Err(NotesError::EmptyText);
    }
    Ok(())
}
```

Exit codes: map certain errors to distinct codes if scripting needs it.

## Worked Example: Notes Domain Errors

```rust
use std::fs;
use std::path::Path;
use thiserror::Error;

#[derive(Debug, Error)]
pub enum NotesError {
    #[error("failed to read {path}")]
    Read {
        path: String,
        #[source]
        source: std::io::Error,
    },
    #[error("failed to write {path}")]
    Write {
        path: String,
        #[source]
        source: std::io::Error,
    },
    #[error("invalid note on line {line}: {message}")]
    InvalidLine { line: usize, message: String },
    #[error("empty note text")]
    EmptyText,
    #[error("note {id} not found")]
    NotFound { id: u32 },
}

#[derive(Debug, Clone, PartialEq, Eq)]
pub struct Note {
    pub id: u32,
    pub text: String,
}

pub fn parse_line(line_no: usize, line: &str) -> Result<Option<Note>, NotesError> {
    let line = line.trim();
    if line.is_empty() {
        return Ok(None);
    }
    let Some((id, text)) = line.split_once('|') else {
        return Err(NotesError::InvalidLine {
            line: line_no,
            message: "expected id|text".into(),
        });
    };
    let id = id.trim().parse().map_err(|e| NotesError::InvalidLine {
        line: line_no,
        message: format!("id: {e}"),
    })?;
    let text = text.trim().to_string();
    if text.is_empty() {
        return Err(NotesError::EmptyText);
    }
    Ok(Some(Note { id, text }))
}

pub fn load(path: impl AsRef<Path>) -> Result<Vec<Note>, NotesError> {
    let path_ref = path.as_ref();
    if !path_ref.exists() {
        return Ok(vec![]);
    }
    let data = fs::read_to_string(path_ref).map_err(|source| NotesError::Read {
        path: path_ref.display().to_string(),
        source,
    })?;
    let mut notes = Vec::new();
    for (i, line) in data.lines().enumerate() {
        if let Some(n) = parse_line(i + 1, line)? {
            notes.push(n);
        }
    }
    Ok(notes)
}

pub fn remove(notes: &mut Vec<Note>, id: u32) -> Result<(), NotesError> {
    let before = notes.len();
    notes.retain(|n| n.id != id);
    if notes.len() == before {
        return Err(NotesError::NotFound { id });
    }
    Ok(())
}

fn main() {
    match parse_line(1, "1|hello") {
        Ok(n) => println!("{n:?}"),
        Err(e) => eprintln!("{e}"),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn not_found() {
        let mut v = vec![Note {
            id: 1,
            text: "a".into(),
        }];
        let err = remove(&mut v, 9).unwrap_err();
        assert!(matches!(err, NotesError::NotFound { id: 9 }));
    }
}
```

If you are offline / avoiding deps in exercises, replace `thiserror` with the manual `Display`+`Error`+`From` pattern from earlier—same design.

## Anti-Patterns

```rust
// Opaque and unmatchable everywhere:
fn f() -> Result<(), String> { Err("something failed".into()) }

// Panic for user typos:
fn g(s: &str) -> i32 { s.parse().unwrap() }

// Discarding source:
// Err(format!("{e}")) without storing source error
```

## Hands-On Practice

1. Design `enum ParseDateError` with variants for format, out-of-range month/day.
2. Implement `Display` + `Error` manually once.
3. Rewrite with `thiserror` if you can add the crate.
4. Write `fn load_config(path: &str) -> Result<Config, ConfigError>` with context-rich I/O errors.
5. In a binary `main`, print error chains.
6. Unit test `matches!` on specific variants.

```rust
#[derive(Debug)]
enum ParseDateError {
    Format,
    Month(u8),
    Day(u8),
}

impl std::fmt::Display for ParseDateError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ParseDateError::Format => write!(f, "expected YYYY-MM-DD"),
            ParseDateError::Month(m) => write!(f, "invalid month {m}"),
            ParseDateError::Day(d) => write!(f, "invalid day {d}"),
        }
    }
}

impl std::error::Error for ParseDateError {}

fn parse_date(s: &str) -> Result<(u16, u8, u8), ParseDateError> {
    let mut parts = s.split('-');
    let (Some(y), Some(m), Some(d), None) = (parts.next(), parts.next(), parts.next(), parts.next()) else {
        return Err(ParseDateError::Format);
    };
    let y: u16 = y.parse().map_err(|_| ParseDateError::Format)?;
    let m: u8 = m.parse().map_err(|_| ParseDateError::Format)?;
    let d: u8 = d.parse().map_err(|_| ParseDateError::Format)?;
    if !(1..=12).contains(&m) {
        return Err(ParseDateError::Month(m));
    }
    if !(1..=31).contains(&d) {
        return Err(ParseDateError::Day(d));
    }
    Ok((y, m, d))
}

fn main() {
    for s in ["2026-08-04", "2026-13-01", "nope"] {
        println!("{s}: {:?}", parse_date(s));
    }
}
```

## Common Mistakes

- **`Result<T, Box<dyn Error>>` everywhere in libraries** without documenting downcast strategy.
- **Stringly errors only** — hard to handle programmatically.
- **Losing context** when mapping I/O errors.
- **`unwrap` in library constructors** for user data.
- **Changing public error enums carelessly** — breaking change for downstream `match`.

## Chapter Summary

Good error design makes failures **actionable**. Use **typed enums** (often with `thiserror`) in libraries, **ergonomic error reports** in applications, and always preserve context. Next: **concurrency basics**—threads and channels with the type system on your side.
