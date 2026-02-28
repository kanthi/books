# Core Language Foundations

## Variables and Mutability

Rust variables are immutable by default.

```rust
fn main() {
    let x = 10;
    let mut y = 20;
    y += 1;
    println!("x={x}, y={y}");
}
```

Use immutability unless mutation is required.

## Types You Will Use Daily

- Scalars: `i32`, `u64`, `f64`, `bool`, `char`
- Compounds: tuples, arrays, slices
- Owned text: `String`
- Borrowed text: `&str`

```rust
fn main() {
    let pair: (i32, &str) = (42, "answer");
    let arr = [1, 2, 3, 4];
    println!("{} {} {}", pair.0, pair.1, arr[2]);
}
```

## Control Flow and Match

```rust
fn classify(n: i32) -> &'static str {
    match n {
        n if n < 0 => "negative",
        0 => "zero",
        1..=9 => "small positive",
        _ => "large positive",
    }
}
```

## Functions and Expressions

Functions can return expression values implicitly.

```rust
fn square(n: i32) -> i32 {
    n * n
}

fn main() {
    let out = square(6);
    println!("{out}");
}
```

## Example: Simple Parser

```rust
fn parse_pair(input: &str) -> Option<(i32, i32)> {
    let (a, b) = input.split_once(',')?;
    Some((a.trim().parse().ok()?, b.trim().parse().ok()?))
}

fn main() {
    println!("{:?}", parse_pair("12, 34"));
}
```

## Common Mistakes

- Using `String` when `&str` is enough.
- Overusing `unwrap()` in production paths.
- Using loops where iterator methods improve clarity.

## Practice

1. Write a `grade(score: u8) -> &str` using `match` ranges.
2. Parse `"x:y"` into two `u32` values.
3. Refactor one `for` loop into iterator style.

## Deep Dive: Expression-Oriented Style

Rust prefers expressions over statements when possible.

```rust
fn abs(n: i32) -> i32 {
    if n < 0 { -n } else { n }
}
```

This style improves composability and reduces temporary state.

## Iterator Example (Readable + Efficient)

```rust
fn sum_even_squares(values: &[i32]) -> i32 {
    values
        .iter()
        .copied()
        .filter(|n| n % 2 == 0)
        .map(|n| n * n)
        .sum()
}

fn main() {
    let v = [1, 2, 3, 4, 5, 6];
    println!("{}", sum_even_squares(&v));
}
```

## Pattern Matching with Enums

```rust
enum Command {
    Start,
    Stop,
    Scale(u8),
}

fn handle(cmd: Command) {
    match cmd {
        Command::Start => println!("starting"),
        Command::Stop => println!("stopping"),
        Command::Scale(n) if n == 0 => println!("invalid scale"),
        Command::Scale(n) => println!("scale to {n}"),
    }
}
```

## Mini Lab

Build `stats_cli` that:

1. Accepts comma-separated integers.
2. Prints min, max, average.
3. Rejects malformed input with clear message.

## Review Questions

1. Why is `match` often preferred over nested `if`?
2. When does iterator style improve correctness?
3. What is the difference between `String` and `&str` ownership?
