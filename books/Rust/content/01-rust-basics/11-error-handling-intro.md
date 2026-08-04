# Error Handling Intro

## Learning Goals

- Use `Option<T>` for values that may be absent.
- Use `Result<T, E>` for operations that may fail.
- Propagate errors with the `?` operator.
- Choose among `unwrap`, `expect`, `unwrap_or`, and proper handling.
- Distinguish recoverable errors from panics; write functions that return `Result`.

## Two Pillars: `Option` and `Result`

Rust does not have null. Absence and failure are **typed**:

| Type | Meaning |
|------|---------|
| `Option<T>` | `Some(T)` or `None` — maybe no value |
| `Result<T, E>` | `Ok(T)` or `Err(E)` — success or error |

The compiler forces you to handle both cases (or deliberately ignore them).

## `Option<T>`

```rust
fn find_even(nums: &[i32]) -> Option<i32> {
    for &n in nums {
        if n % 2 == 0 {
            return Some(n);
        }
    }
    None
}

fn main() {
    match find_even(&[1, 3, 4, 5]) {
        Some(n) => println!("found {n}"),
        None => println!("none"),
    }
}
```

### Combinators

```rust
fn main() {
    let n: Option<i32> = Some(2);
    let doubled = n.map(|x| x * 2);
    let or_zero = n.unwrap_or(0);
    let via = n.and_then(|x| if x > 0 { Some(x + 1) } else { None });
    println!("{doubled:?} {or_zero} {via:?}");

    let text = Some("  42 ");
    let parsed: Option<i32> = text.map(str::trim).and_then(|s| s.parse().ok());
    println!("{parsed:?}");
}
```

### `if let` / `let-else`

```rust
fn main() {
    let user = Some(String::from("ada"));
    if let Some(name) = user {
        println!("hi {name}");
    }

    let config = Some("8080");
    let Some(port_str) = config else {
        eprintln!("missing port");
        return;
    };
    println!("port_str={port_str}");
}
```

## `Result<T, E>`

```rust
use std::fs;
use std::io;

fn read_username(path: &str) -> Result<String, io::Error> {
    fs::read_to_string(path)
}

fn main() {
    match read_username("username.txt") {
        Ok(name) => println!("user={name}"),
        Err(e) => eprintln!("failed: {e}"),
    }
}
```

Many standard library fallible ops return `Result`: parse, I/O, channel recv, etc.

### Parse example

```rust
fn parse_port(s: &str) -> Result<u16, std::num::ParseIntError> {
    s.parse()
}

fn main() {
    for s in ["8080", "nope"] {
        match parse_port(s) {
            Ok(p) => println!("ok {p}"),
            Err(e) => println!("err {e}"),
        }
    }
}
```

## The `?` Operator

`?` means: if `Err`/`None` (in functions returning `Result`/`Option`), **return early** with that failure; otherwise unwrap the success.

```rust
use std::fs::File;
use std::io::{self, Read};

fn read_file(path: &str) -> Result<String, io::Error> {
    let mut f = File::open(path)?;
    let mut s = String::new();
    f.read_to_string(&mut s)?;
    Ok(s)
}

// even shorter:
fn read_file_short(path: &str) -> Result<String, io::Error> {
    std::fs::read_to_string(path)
}

fn main() {
    match read_file_short("Cargo.toml") {
        Ok(s) => println!("{} bytes", s.len()),
        Err(e) => eprintln!("{e}"),
    }
}
```

### `?` with `Option`

```rust
fn second(xs: &[i32]) -> Option<i32> {
    let mut it = xs.iter();
    it.next()?;
    it.next().copied()
}

fn main() {
    println!("{:?}", second(&[10, 20, 30]));
    println!("{:?}", second(&[10]));
}
```

### `main` can return `Result`

```rust
use std::io;

fn main() -> Result<(), io::Error> {
    let cwd = std::env::current_dir()?;
    println!("cwd={}", cwd.display());
    Ok(())
}
```

If `main` returns `Err`, the process exits with a non-zero status and an error message.

## `unwrap` and `expect`

```rust
fn main() {
    let x = Some(3).unwrap(); // panics on None
    let y: i32 = "42".parse().expect("must be int");
    println!("{x} {y}");
}
```

| Method | Behavior |
|--------|----------|
| `unwrap()` | Panic on failure with default message |
| `expect("msg")` | Panic with your message (better for debugging) |
| `unwrap_or(v)` | Default on failure |
| `unwrap_or_else(|| …)` | Lazy default |
| `unwrap_or_default()` | `Default::default()` |

**Learning use:** `unwrap`/`expect` are fine in examples and tests when failure is impossible or should abort. **Production libraries:** prefer returning `Result` and mapping errors.

## Mapping Errors

```rust
fn double_port(s: &str) -> Result<u32, String> {
    let p: u16 = s
        .parse()
        .map_err(|e| format!("parse port: {e}"))?;
    Ok(u32::from(p) * 2)
}

fn main() {
    println!("{:?}", double_port("8080"));
    println!("{:?}", double_port("x"));
}
```

Intermediate chapters cover custom error types and crates like `thiserror` / `anyhow`. For now, `String` errors are acceptable in exercises.

## Panic vs Recoverable Error

**Panic** (`panic!`, out-of-bounds index, `unwrap` on bad data): for bugs or unrecoverable situations.

```rust
fn main() {
    // panic!("something is very wrong");
    let v = vec![1, 2];
    // let _ = v[99]; // panic
    println!("{:?}", v.get(99)); // safe alternative
}
```

**Recoverable:** I/O, user input, network—return `Result` and let callers decide.

## Chaining Fallible Steps

```rust
use std::num::ParseIntError;

fn sum_line(line: &str) -> Result<i32, ParseIntError> {
    let mut total = 0;
    for part in line.split_whitespace() {
        total += part.parse::<i32>()?;
    }
    Ok(total)
}

fn main() {
    println!("{:?}", sum_line("1 2 3"));
    println!("{:?}", sum_line("1 x 3"));
}
```

## Converting Between `Option` and `Result`

```rust
fn main() {
    let o = Some(5);
    let r: Result<i32, &str> = o.ok_or("missing");
    println!("{r:?}");

    let r: Result<i32, &str> = Err("bad");
    let o = r.ok(); // Option — discards error detail
    println!("{o:?}");

    let n: Option<i32> = "5".parse().ok();
    println!("{n:?}");
}
```

## Worked Example: Config Loader Shape

```rust
use std::collections::HashMap;
use std::fs;
use std::io;

fn parse_kv_line(line: &str) -> Option<(String, String)> {
    let line = line.trim();
    if line.is_empty() || line.starts_with('#') {
        return None;
    }
    let (k, v) = line.split_once('=')?;
    Some((k.trim().to_string(), v.trim().to_string()))
}

fn load_config(path: &str) -> Result<HashMap<String, String>, io::Error> {
    let text = fs::read_to_string(path)?;
    let mut map = HashMap::new();
    for line in text.lines() {
        if let Some((k, v)) = parse_kv_line(line) {
            map.insert(k, v);
        }
    }
    Ok(map)
}

fn require_key<'a>(cfg: &'a HashMap<String, String>, key: &str) -> Result<&'a str, String> {
    cfg.get(key)
        .map(|s| s.as_str())
        .ok_or_else(|| format!("missing key: {key}"))
}

fn main() {
    // Write a temp-like example in memory for demo without requiring a file:
    let sample = "\
# demo
host = localhost
port = 8080
";
    let mut cfg = HashMap::new();
    for line in sample.lines() {
        if let Some((k, v)) = parse_kv_line(line) {
            cfg.insert(k, v);
        }
    }
    match require_key(&cfg, "port") {
        Ok(p) => println!("port={p}"),
        Err(e) => eprintln!("{e}"),
    }
    match load_config("does-not-exist.cfg") {
        Ok(m) => println!("loaded {} keys", m.len()),
        Err(e) => eprintln!("load failed (expected in demo): {e}"),
    }
}
```

## Worked Example: CLI Parse with `?`

```rust
use std::env;
use std::num::ParseIntError;

#[derive(Debug)]
struct Args {
    name: String,
    times: u32,
}

fn parse_args() -> Result<Args, String> {
    let mut args = env::args().skip(1);
    let name = args.next().ok_or_else(|| "missing name".to_string())?;
    let times_s = args.next().unwrap_or_else(|| "1".to_string());
    let times: u32 = times_s
        .parse()
        .map_err(|e: ParseIntError| format!("times: {e}"))?;
    Ok(Args { name, times })
}

fn main() {
    match parse_args() {
        Ok(a) => {
            for i in 1..=a.times {
                println!("{i}: hello, {}!", a.name);
            }
        }
        Err(e) => {
            eprintln!("usage: greeter <name> [times]\nerror: {e}");
            std::process::exit(2);
        }
    }
}
```

```bash
cargo run -- Ferris 3
cargo run --
```

## Hands-On Practice

1. Write `fn parse_bool(s: &str) -> Result<bool, String>` accepting `true/false/yes/no/1/0`.
2. Write `fn first_line(path: &str) -> Result<String, std::io::Error>` using `?`.
3. Convert a chain of `Option`s with `?` inside a function returning `Option`.
4. Replace three `unwrap`s in a scratch program with `match` or `?`.
5. Use `expect` only in a unit test where setup must succeed.
6. Intentionally open a missing file; print the `io::Error` kind/display.

```rust
fn parse_bool(s: &str) -> Result<bool, String> {
    match s.trim().to_ascii_lowercase().as_str() {
        "true" | "yes" | "1" => Ok(true),
        "false" | "no" | "0" => Ok(false),
        other => Err(format!("invalid bool: {other}")),
    }
}

fn main() {
    for s in ["yes", "0", "maybe"] {
        println!("{s:?} → {:?}", parse_bool(s));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn yes() {
        assert_eq!(parse_bool("yes").unwrap(), true);
    }
}
```

## Common Mistakes

- **`unwrap()` in library code** on user input paths.
- **Ignoring `Result` with `let _ = fallible();`** — use `?` or handle explicitly; enable `#[must_use]` discipline via clippy.
- **Using `Option` for real failures** that need error messages—prefer `Result`.
- **Huge nested `match`** — use `?`, combinators, and early returns.
- **Panicking for normal empty states** — `None` is normal; do not `unwrap` it away without cause.

## Chapter Summary

`Option` models absence; `Result` models success/failure. Prefer **`?`** and explicit handling over silent panics. Use `unwrap`/`expect` sparingly and intentionally. You now have enough error machinery for a real mini project. Next: **CLI notes app**—ownership, strings, collections, and `Result` working together.
