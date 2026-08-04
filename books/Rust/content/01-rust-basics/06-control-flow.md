# Control Flow

## Learning Goals

- Use `if` / `else if` / `else` as statements and expressions.
- Master `loop`, `while`, and `for`—including ranges and iterators.
- Apply `match` for exhaustive branching.
- Use modern patterns: `if let`, `let-else`, and simple guards.
- Control flow without becoming spaghetti; prefer clear exits and iterators.

## `if` Expressions

Conditions must be `bool` (no truthy/falsy integers):

```rust
fn main() {
    let n = 7;
    if n < 0 {
        println!("negative");
    } else if n == 0 {
        println!("zero");
    } else {
        println!("positive");
    }

    let parity = if n % 2 == 0 { "even" } else { "odd" };
    println!("{n} is {parity}");
}
```

## Infinite `loop` with `break` / `continue`

`loop` is infinite until `break`. It can **return a value**:

```rust
fn main() {
    let mut count = 0;
    let result = loop {
        count += 1;
        if count == 5 {
            break count * 2;
        }
    };
    println!("result = {result}");
}
```

`continue` skips to the next iteration:

```rust
fn main() {
    let mut n = 0;
    loop {
        n += 1;
        if n % 2 == 0 {
            continue;
        }
        if n > 7 {
            break;
        }
        println!("odd {n}");
    }
}
```

### Loop labels

Nested loops can break outer loops with labels:

```rust
fn main() {
    let mut found = None;
    'outer: for i in 1..=3 {
        for j in 1..=3 {
            if i * j == 6 {
                found = Some((i, j));
                break 'outer;
            }
        }
    }
    println!("found = {found:?}");
}
```

## `while`

```rust
fn main() {
    let mut n = 3;
    while n > 0 {
        println!("{n}...");
        n -= 1;
    }
    println!("liftoff");
}
```

Prefer `for` when iterating collections; use `while` for condition-driven loops (e.g. reading until empty—later with I/O).

## `for` and Ranges

```rust
fn main() {
    for i in 1..4 {
        // 1, 2, 3
        println!("half-open {i}");
    }
    for i in 1..=4 {
        // 1..=4 inclusive
        println!("inclusive {i}");
    }
    for i in (1..=5).rev() {
        println!("rev {i}");
    }
}
```

Iterate collections:

```rust
fn main() {
    let names = ["ada", "grace", "linus"];
    for name in names {
        println!("hello {name}");
    }
    // indices
    for (i, name) in names.iter().enumerate() {
        println!("{i}: {name}");
    }
}
```

Ownership note: `for x in vec` **moves** (or copies) elements depending on type. `for x in &vec` borrows. `for x in &mut vec` mutably borrows.

```rust
fn main() {
    let mut xs = vec![1, 2, 3];
    for x in &xs {
        println!("borrow {x}");
    }
    for x in &mut xs {
        *x *= 2;
    }
    println!("{xs:?}");
}
```

## `match` — Exhaustive Branching

```rust
fn dice_hint(n: u8) -> &'static str {
    match n {
        1 => "min",
        2 | 3 => "low",
        4..=5 => "mid",
        6 => "max",
        _ => "invalid die",
    }
}

fn main() {
    for n in 1..=7 {
        println!("{n}: {}", dice_hint(n));
    }
}
```

`match` must be **exhaustive**. Use `_` for the rest.

### Destructuring and useful patterns

```rust
fn main() {
    let pair = (2, -2);
    match pair {
        (0, 0) => println!("origin"),
        (x, y) if x == y => println!("diagonal {x}"),
        (x, y) if x + y == 0 => println!("anti-sum zero"),
        (x, _) if x > 0 => println!("positive x={x}"),
        _ => println!("other"),
    }
}
```

### Matching `Option` and `Result`

```rust
fn main() {
    let maybe = Some(3);
    match maybe {
        Some(n) if n > 0 => println!("positive {n}"),
        Some(n) => println!("non-positive {n}"),
        None => println!("empty"),
    }

    let res: Result<i32, &str> = Ok(10);
    match res {
        Ok(v) => println!("ok {v}"),
        Err(e) => println!("err {e}"),
    }
}
```

## `if let` for Single-Pattern Focus

When you only care about one pattern:

```rust
fn main() {
    let config = Some(String::from("dark"));
    if let Some(theme) = config {
        println!("theme = {theme}");
    }
    // `config` was moved into the pattern if Some — design APIs accordingly
}
```

Borrowing version:

```rust
fn main() {
    let config = Some(String::from("dark"));
    if let Some(theme) = &config {
        println!("theme = {theme}");
    }
    println!("still have {config:?}");
}
```

## `let-else` (Modern Idiom)

`let-else` binds on success or diverges in the `else` block—excellent for early validation:

```rust
fn parse_port(s: &str) -> Result<u16, String> {
    let Ok(p) = s.parse::<u16>() else {
        return Err(format!("not a u16: {s}"));
    };
    if p == 0 {
        return Err("port 0 not allowed".into());
    }
    Ok(p)
}

fn main() {
    for s in ["8080", "nope", "0"] {
        match parse_port(s) {
            Ok(p) => println!("{s} → {p}"),
            Err(e) => println!("{s} → {e}"),
        }
    }
}
```

Another shape—exit `main`-like helpers:

```rust
fn first_token(line: &str) -> Option<&str> {
    let mut parts = line.split_whitespace();
    let Some(tok) = parts.next() else {
        return None;
    };
    Some(tok)
}

fn main() {
    println!("{:?}", first_token("cargo test"));
    println!("{:?}", first_token("   "));
}
```

## `while let`

Keep looping while a pattern matches:

```rust
fn main() {
    let mut stack = vec![1, 2, 3];
    while let Some(top) = stack.pop() {
        println!("pop {top}");
    }
}
```

## Choosing a Construct

| Need | Prefer |
|------|--------|
| Boolean branch | `if` / `else` |
| Many alternatives / enums | `match` |
| One happy pattern | `if let` or `let-else` |
| Counted iteration | `for` + range |
| Condition until false | `while` |
| Retry until success value | `loop` + `break value` |
| Drain `Option`/`Iterator` | `while let` |

## Worked Example: FizzBuzz with Style

```rust
fn fizzbuzz(n: u32) -> String {
    match (n % 3, n % 5) {
        (0, 0) => "FizzBuzz".into(),
        (0, _) => "Fizz".into(),
        (_, 0) => "Buzz".into(),
        _ => n.to_string(),
    }
}

fn main() {
    for n in 1..=20 {
        println!("{:>2}: {}", n, fizzbuzz(n));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn basics() {
        assert_eq!(fizzbuzz(1), "1");
        assert_eq!(fizzbuzz(3), "Fizz");
        assert_eq!(fizzbuzz(5), "Buzz");
        assert_eq!(fizzbuzz(15), "FizzBuzz");
    }
}
```

## Worked Example: Simple Menu Loop

```rust
use std::io::{self, Write};

fn prompt(msg: &str) -> io::Result<String> {
    print!("{msg}");
    io::stdout().flush()?;
    let mut buf = String::new();
    io::stdin().read_line(&mut buf)?;
    Ok(buf.trim().to_string())
}

fn main() -> io::Result<()> {
    loop {
        println!("1) greet  2) quit");
        let choice = prompt("> ")?;
        match choice.as_str() {
            "1" => {
                let name = prompt("name: ")?;
                println!("Hello, {name}!");
            }
            "2" | "q" | "quit" => {
                println!("bye");
                break;
            }
            other => println!("unknown: {other}"),
        }
    }
    Ok(())
}
```

```bash
cargo run
```

## Hands-On Practice

1. Implement temperature classification: cold / mild / hot with `if` expressions returning labels.
2. Sum all multiples of 3 or 5 below 100 using `for` and a `mut` accumulator.
3. Rewrite that sum with ` (1..100).filter(...).sum()`.
4. Use `match` on a `u8` HTTP-ish status to print categories (2xx, 3xx, 4xx, 5xx, other).
5. Parse CLI args in a loop: print help for `-h`, set verbose for `-v`, collect remaining as paths.
6. Practice `let-else` by rejecting empty strings before processing.

```rust
fn category(status: u16) -> &'static str {
    match status {
        200..=299 => "success",
        300..=399 => "redirect",
        400..=499 => "client error",
        500..=599 => "server error",
        _ => "unknown",
    }
}

fn main() {
    for s in [200u16, 301, 404, 500, 99] {
        println!("{s} → {}", category(s));
    }
}
```

## Common Mistakes

- **Using non-bool conditions** (`if 1` is a type error—good!).
- **Forgetting `_` in `match`** so the program does not compile.
- **Moving inside `if let Some(x) = option`** when you still need `option` later—borrow with `if let Some(x) = &option`.
- **Off-by-one with ranges** (`1..n` vs `1..=n`).
- **Busy loops** without sleeping/blocking in real services—fine for CPU exercises, bad for servers (later async/threads).
- **Deep nesting** — extract functions; use `let-else` for guard clauses.

## Chapter Summary

Control flow in Rust is **expression-friendly** and **exhaustive** when you use `match`. Prefer `for` for iteration, `loop` when you need a value from a retry, and modern **`let-else`** for clean validation. Combined with functions, you can structure real CLI flows. Next comes the heart of Rust: **ownership basics**.
