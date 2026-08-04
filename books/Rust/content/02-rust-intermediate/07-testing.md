# Testing

## Learning Goals

- Write unit tests with `#[test]` and `#[cfg(test)]`.
- Use assertions: `assert!`, `assert_eq!`, `assert_ne!`, `should_panic`, `Result` tests.
- Organize unit tests vs integration tests vs doc tests.
- Run and filter tests with `cargo test` options.
- Build a minimal quality habit: tests + `fmt` + `clippy`.

## Why Test in Rust?

Rust’s type system prevents many bugs, not **logic** bugs. Tests document intent and protect refactors—especially around parsing, state transitions, and error paths.

```bash
cargo new test_lab --lib
cd test_lab
cargo test
```

## Unit Tests Next to Code

```rust
// src/lib.rs
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}

pub fn divide(a: i32, b: i32) -> Result<i32, String> {
    if b == 0 {
        return Err("division by zero".into());
    }
    Ok(a / b)
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_works() {
        assert_eq!(add(2, 2), 4);
    }

    #[test]
    fn divide_ok() {
        assert_eq!(divide(10, 2).unwrap(), 5);
    }

    #[test]
    fn divide_zero() {
        assert!(divide(1, 0).is_err());
    }
}
```

- `#[cfg(test)]` compiles the module only for tests.
- `use super::*;` imports the parent module items.

## Assertions

```rust
#[cfg(test)]
mod assert_demo {
    #[test]
    fn basics() {
        assert!(1 + 1 == 2);
        assert_eq!(2 + 2, 4);
        assert_ne!(2 + 2, 5);
        assert_eq!(vec![1, 2], vec![1, 2], "vecs should match");
    }
}
```

Custom messages print on failure.

### Floating point

```rust
#[cfg(test)]
mod floats {
    #[test]
    fn approx() {
        let x = 0.1 + 0.2;
        assert!((x - 0.3).abs() < 1e-10);
    }
}
```

## Tests Returning `Result`

Put these next to the `divide` function in the same `#[cfg(test)] mod tests` block:

```rust
#[test]
fn divide_result_style() -> Result<(), String> {
    let v = divide(8, 2)?;
    assert_eq!(v, 4);
    Ok(())
}
```

## Expecting Panics

```rust
pub fn guess(n: i32) {
    if !(1..=100).contains(&n) {
        panic!("guess out of range: {n}");
    }
}

#[cfg(test)]
mod panic_tests {
    use super::*;

    #[test]
    #[should_panic]
    fn rejects_zero() {
        guess(0);
    }

    #[test]
    #[should_panic(expected = "out of range")]
    fn message_matches() {
        guess(101);
    }
}
```

Prefer `Result` APIs for recoverable cases; use panic tests for true invariants.

## Controlling Tests

```bash
cargo test
cargo test divide          # filter by name
cargo test -- --nocapture  # show println!
cargo test -- --test-threads=1
cargo test -- --ignored    # run #[ignore] tests
cargo test --lib           # only unit tests in lib
cargo test --test name     # specific integration file
```

```rust
#[test]
#[ignore]
fn expensive() {
    // run with: cargo test -- --ignored
}
```

## Integration Tests

```text
tests/
  api.rs
  common/mod.rs   # shared helpers (not a test target itself if structured carefully)
```

```rust
// tests/api.rs
use test_lab::add;

#[test]
fn public_api_add() {
    assert_eq!(add(1, 2), 3);
}
```

Integration tests treat your crate as an **external user**—only `pub` items are visible. This pushes good API design.

## Documentation Tests

```rust
/// Squares a number.
///
/// ```
/// use test_lab::square;
/// assert_eq!(square(4), 16);
/// ```
pub fn square(n: i32) -> i32 {
    n * n
}
```

```bash
cargo test --doc
```

Doc tests keep examples honest.

## Testing Private Helpers

Unit tests inside the same module tree can access private functions:

```rust
fn normalize(s: &str) -> &str {
    s.trim()
}

pub fn word_count(s: &str) -> usize {
    normalize(s).split_whitespace().count()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn normalize_trims() {
        assert_eq!(normalize("  a  "), "a");
    }
}
```

## Setup Patterns

```rust
struct Notes {
    items: Vec<String>,
}

impl Notes {
    fn new() -> Self {
        Self { items: vec![] }
    }
    fn add(&mut self, s: impl Into<String>) {
        self.items.push(s.into());
    }
    fn len(&self) -> usize {
        self.items.len()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn fixture() -> Notes {
        let mut n = Notes::new();
        n.add("a");
        n.add("b");
        n
    }

    #[test]
    fn starts_with_two() {
        assert_eq!(fixture().len(), 2);
    }
}
```

For file I/O, use unique temp paths:

```rust
#[cfg(test)]
mod fileish {
    use std::fs;
    use std::path::PathBuf;

    fn tmp(name: &str) -> PathBuf {
        let mut p = std::env::temp_dir();
        p.push(format!("rust-test-{}-{}", std::process::id(), name));
        p
    }

    #[test]
    fn write_read() {
        let p = tmp("notes.txt");
        fs::write(&p, "hi").unwrap();
        let s = fs::read_to_string(&p).unwrap();
        assert_eq!(s, "hi");
        let _ = fs::remove_file(&p);
    }
}
```

## Module Organization for Tests

```rust
// src/lib.rs
pub mod parse;
pub mod store;

#[cfg(test)]
mod tests {
    // cross-module unit tests if needed
}
```

Or put `tests` submodule inside each file’s module.

## Coverage of Error Paths

```rust
pub fn parse_id(s: &str) -> Result<u32, String> {
    if s.is_empty() {
        return Err("empty".into());
    }
    s.parse().map_err(|e| format!("parse: {e}"))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn ok() {
        assert_eq!(parse_id("7").unwrap(), 7);
    }

    #[test]
    fn empty() {
        assert_eq!(parse_id("").unwrap_err(), "empty");
    }

    #[test]
    fn not_a_number() {
        assert!(parse_id("x").unwrap_err().contains("parse"));
    }
}
```

Test **both** success and failure—error messages are part of UX for CLIs.

## Worked Example: Notes Parser Suite

```rust
#[derive(Debug, PartialEq, Eq)]
pub struct Note {
    pub id: u32,
    pub text: String,
}

pub fn parse_note(line: &str) -> Result<Option<Note>, String> {
    let line = line.trim();
    if line.is_empty() {
        return Ok(None);
    }
    let (id, text) = line
        .split_once('|')
        .ok_or_else(|| format!("bad line: {line}"))?;
    let id = id
        .trim()
        .parse()
        .map_err(|e| format!("id: {e}"))?;
    let text = text.trim().to_string();
    if text.is_empty() {
        return Err("empty text".into());
    }
    Ok(Some(Note { id, text }))
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses() {
        assert_eq!(
            parse_note("1|hello").unwrap(),
            Some(Note {
                id: 1,
                text: "hello".into()
            })
        );
    }

    #[test]
    fn blank() {
        assert_eq!(parse_note("  ").unwrap(), None);
    }

    #[test]
    fn missing_bar() {
        assert!(parse_note("1hello").is_err());
    }

    #[test]
    fn empty_text() {
        assert_eq!(parse_note("1|").unwrap_err(), "empty text");
    }
}
```

## Quality Gate Habit

```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
```

In CI (and personally), treat these as one unit. Locally while learning, run them often.

## Hands-On Practice

1. Create a lib crate with `pub fn is_palindrome(s: &str) -> bool` (ignore case and spaces) and thorough tests.
2. Add a `#[should_panic]` test for a deliberate invariant function.
3. Add an integration test file.
4. Add a doc example that `cargo test --doc` runs.
5. Write table-driven tests with arrays of `(input, expected)`.
6. Break the implementation on purpose; ensure tests fail, then fix.

```rust
pub fn is_palindrome(s: &str) -> bool {
    let cleaned: String = s
        .chars()
        .filter(|c| !c.is_whitespace())
        .flat_map(|c| c.to_lowercase())
        .collect();
    let rev: String = cleaned.chars().rev().collect();
    cleaned == rev
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn table() {
        let cases = [
            ("", true),
            ("a", true),
            ("ab", false),
            ("Aba", true),
            ("never odd or even", true),
        ];
        for (input, expected) in cases {
            assert_eq!(is_palindrome(input), expected, "input={input:?}");
        }
    }
}
```

## Common Mistakes

- **Only testing happy paths**.
- **Brittle tests on exact error strings** across layers—assert stable prefixes or error kinds when you design custom errors.
- **Shared mutable global state** across tests—prefer isolation.
- **Ignoring flaky time/network tests** without `#[ignore]` or better design.
- **Huge integration tests only** — unit tests give faster signal.

## Chapter Summary

`cargo test` is central to Rust workflow. Put **unit tests** beside code, **integration tests** in `tests/`, and keep **doc examples** executable. Assert success and failure paths. Next: **error design**—structuring failures for libraries and applications.
