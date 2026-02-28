# Error Handling, Testing, and Tooling

## Model Errors Explicitly

```rust
#[derive(Debug)]
enum AppError {
    NotFound,
    InvalidInput(String),
    Io(std::io::Error),
}
```

## Result-Based Flows

```rust
fn parse_age(input: &str) -> Result<u8, AppError> {
    let age = input
        .parse::<u8>()
        .map_err(|_| AppError::InvalidInput(input.to_string()))?;
    Ok(age)
}
```

## Unit Tests

```rust
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parse_valid_age() {
        assert_eq!(parse_age("42").unwrap(), 42);
    }

    #[test]
    fn parse_invalid_age() {
        assert!(parse_age("abc").is_err());
    }
}
```

## Integration Tests

Create `tests/cli_smoke.rs`:

```rust
#[test]
fn smoke() {
    assert_eq!(2 + 2, 4);
}
```

## Toolchain Discipline

```bash
cargo fmt --check
cargo clippy -- -D warnings
cargo test
cargo doc --no-deps
```

## Practice

1. Replace all `unwrap()` in one module with typed errors.
2. Add unit tests for success and failure paths.
3. Add one doc test to public API docs.

## Deep Dive: Error Layering

Use domain errors internally, map to transport errors at boundaries.

```rust
#[derive(Debug)]
enum DomainError {
    DuplicateEmail,
    InvalidAge,
}

fn map_http_status(err: &DomainError) -> u16 {
    match err {
        DomainError::DuplicateEmail => 409,
        DomainError::InvalidAge => 400,
    }
}
```

## Table-Driven Testing Example

```rust
#[test]
fn age_cases() {
    let cases = [("10", true), ("", false), ("abc", false), ("255", true)];
    for (input, ok) in cases {
        assert_eq!(parse_age(input).is_ok(), ok, "input={input}");
    }
}
```

## CI Quality Gate Suggestion

```bash
cargo fmt --check && cargo clippy -- -D warnings && cargo test
```

## Review Questions

1. Why map errors at boundary layers?
2. What makes a test flaky?
3. Why should CI fail on lint warnings for core crates?
