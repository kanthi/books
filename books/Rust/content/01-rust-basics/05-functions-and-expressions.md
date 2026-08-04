# Functions and Expressions

## Learning Goals

- Define functions with parameters, return types, and clear names.
- Distinguish **statements** from **expressions**.
- Return values with or without the `return` keyword.
- Pass arguments by value (move/copy) and prepare for borrowing.
- Structure small programs as composable functions with tests in mind.

## Defining Functions

```rust
fn main() {
    greet("Rust");
    let sum = add(2, 40);
    println!("sum = {sum}");
}

fn greet(name: &str) {
    println!("Hello, {name}!");
}

fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

Rules:

- Function names: `snake_case`.
- Parameter types are **required**.
- Return type uses `-> Type` when not unit `()`.
- Order: you can call functions defined later in the same module (no header files).

## Statements vs Expressions

Rust is **expression-oriented**. Most constructs produce values.

| Kind | Examples | Produces value? |
|------|----------|-----------------|
| Statement | `let x = 1;`, item declarations | No (or not usable as value) |
| Expression | `1 + 2`, `if`, blocks `{ ... }`, function calls | Yes |

```rust
fn main() {
    let y = {
        let x = 3;
        x + 1 // no semicolon → expression value of the block
    };
    println!("y = {y}");
}
```

If you add a semicolon to the last line of a block, the block becomes a statement-ish unit value `()`:

```rust
fn main() {
    let y = {
        let x = 3;
        x + 1; // semicolon → block value is ()
    };
    println!("y = {y:?}");
}
```

## Returning Values

Two equivalent styles for early clarity:

```rust
fn double(n: i32) -> i32 {
    return n * 2; // explicit return
}

fn triple(n: i32) -> i32 {
    n * 3 // expression body — preferred idiomatic style
}

fn main() {
    println!("{} {}", double(5), triple(5));
}
```

Use `return` for **early exits**:

```rust
fn first_even(nums: &[i32]) -> Option<i32> {
    for &n in nums {
        if n % 2 == 0 {
            return Some(n);
        }
    }
    None
}

fn main() {
    println!("{:?}", first_even(&[1, 3, 4, 5]));
}
```

## `if` Is an Expression

```rust
fn abs_label(n: i32) -> &'static str {
    if n < 0 {
        "negative"
    } else if n == 0 {
        "zero"
    } else {
        "positive"
    }
}

fn main() {
    let n = -3;
    let label = abs_label(n);
    let magnitude = if n < 0 { -n } else { n };
    println!("{n} is {label}, magnitude {magnitude}");
}
```

Both branches of an `if` expression used for assignment must have **compatible types**.

## Parameters: Copy, Move, and Borrow (Ownership Link)

### `Copy` types (e.g. integers)

```rust
fn takes_copy(x: i32) {
    println!("x = {x}");
}

fn main() {
    let n = 10;
    takes_copy(n);
    println!("still have n = {n}");
}
```

### Owned non-`Copy` types move

```rust
fn takes_string(s: String) {
    println!("s = {s}");
}

fn main() {
    let name = String::from("ferris");
    takes_string(name);
    // println!("{name}"); // error: moved
}
```

### Borrow instead of move

```rust
fn takes_str(s: &str) {
    println!("s = {s}");
}

fn main() {
    let name = String::from("ferris");
    takes_str(&name);
    println!("still have {name}");
}
```

### Returning ownership

```rust
fn append_exclaim(mut s: String) -> String {
    s.push('!');
    s
}

fn main() {
    let s = String::from("hi");
    let s = append_exclaim(s);
    println!("{s}");
}
```

Idiomatic alternative with mutable borrow (next ownership chapters expand this):

```rust
fn append_exclaim_mut(s: &mut String) {
    s.push('!');
}

fn main() {
    let mut s = String::from("hi");
    append_exclaim_mut(&mut s);
    println!("{s}");
}
```

## Multiple Return Values via Tuples

```rust
fn div_rem(a: i32, b: i32) -> (i32, i32) {
    (a / b, a % b)
}

fn main() {
    let (q, r) = div_rem(17, 5);
    println!("q={q} r={r}");
}
```

Prefer a small struct when the tuple’s meaning gets unclear (Intermediate).

## Associated Style: Methods (Preview)

Functions associated with a type live in `impl` blocks:

```rust
struct Celsius(f64);

impl Celsius {
    fn to_fahrenheit(&self) -> f64 {
        self.0 * 9.0 / 5.0 + 32.0
    }
}

fn main() {
    let t = Celsius(20.0);
    println!("{}°F", t.to_fahrenheit());
}
```

You will master structs/methods in Intermediate Part 2.

## Divergence: `-> !`

Functions that never return use the never type `!` (e.g. infinite loop or always panic):

```rust
fn crash(msg: &str) -> ! {
    panic!("{msg}");
}

fn main() {
    let config: Option<i32> = None;
    let port = config.unwrap_or_else(|| crash("missing port"));
    println!("{port}");
}
```

Rare in beginner code; useful to know for type checking branches.

## Documentation Comments

```rust
/// Adds two integers.
///
/// # Examples
///
/// ```
/// assert_eq!(add(2, 2), 4);
/// ```
fn add(a: i32, b: i32) -> i32 {
    a + b
}

fn main() {
    println!("{}", add(2, 3));
}
```

`cargo doc --open` renders `///` docs for public items in libraries.

## Function Pointers and `fn` Types (Light Touch)

```rust
fn apply(f: fn(i32) -> i32, x: i32) -> i32 {
    f(x)
}

fn square(n: i32) -> i32 {
    n * n
}

fn main() {
    println!("{}", apply(square, 6));
}
```

Closures (`|x| x * x`) are more flexible and appear with iterators.

## Worked Example: Small Pure Pipeline

```rust
fn parse_i32(s: &str) -> Result<i32, std::num::ParseIntError> {
    s.trim().parse()
}

fn clamp(n: i32, lo: i32, hi: i32) -> i32 {
    n.max(lo).min(hi)
}

fn label_score(score: i32) -> &'static str {
    if score >= 90 {
        "excellent"
    } else if score >= 70 {
        "good"
    } else {
        "needs work"
    }
}

fn main() {
    let raw = "  87 ";
    match parse_i32(raw) {
        Ok(n) => {
            let score = clamp(n, 0, 100);
            println!("{score} → {}", label_score(score));
        }
        Err(e) => eprintln!("parse error: {e}"),
    }
}
```

## Expressions Everywhere Practice

```rust
fn pick(flag: bool) -> i32 {
    match flag {
        true => 1,
        false => 0,
    }
}

fn main() {
    let n = 4;
    let msg = match n {
        0 => "zero",
        1..=3 => "small",
        _ => "big",
    };
    println!("{msg}, pick={}", pick(true));
}
```

## Hands-On Practice

1. Write `fn area(width: u32, height: u32) -> u32` and call it from `main`.
2. Rewrite a multi-step calculation using a block expression assigned to `let result = { ... }`.
3. Implement `fn longest_len(a: &str, b: &str) -> usize` using only lengths (no lifetime issues yet).
4. Write a function that takes `String` and returns `String` uppercased (`s.to_uppercase()`).
5. Write a version that takes `&str` and returns `String`—prefer this API.
6. Add unit tests in the same file with `#[cfg(test)]` for pure functions.

```rust
fn longest_len(a: &str, b: &str) -> usize {
    a.len().max(b.len())
}

fn shout(s: &str) -> String {
    s.to_uppercase()
}

fn main() {
    println!("{}", longest_len("hi", "hello"));
    println!("{}", shout("rust"));
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn longest_works() {
        assert_eq!(longest_len("a", "abc"), 3);
    }

    #[test]
    fn shout_works() {
        assert_eq!(shout("ok"), "OK");
    }
}
```

```bash
cargo test
```

## Common Mistakes

- **Semicolon on the final expression** accidentally returning `()` instead of a value.
- **Missing return type** when the function clearly returns something.
- **Moving `String` into helpers** and wondering why the caller lost it—borrow with `&str` when you only need to read.
- **Inconsistent branch types** in `if`/`match` expressions.
- **Huge `main`** — extract functions early; easier to test.

## Chapter Summary

Functions are the primary unit of organization. Rust’s **expression-oriented** style makes blocks, `if`, and `match` return values cleanly. Prefer **expression bodies** over unnecessary `return`, pass **`&str`** when you only need to read text, and keep functions small. Next: **control flow**—loops and branching patterns you will use in every program.
