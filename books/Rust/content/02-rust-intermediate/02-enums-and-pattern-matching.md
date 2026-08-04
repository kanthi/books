# Enums and Pattern Matching

## Learning Goals

- Define enums with unit, tuple, and struct-like variants.
- Use `match` exhaustively; apply `if let` and `let-else`.
- Encode domain states that would be error-prone as booleans/strings.
- Implement methods on enums.
- See how `Option` and `Result` are enums you already use.

## Enums as Domain Types

An **enum** is a type that can be one of several **variants**.

```rust
enum IpAddrKind {
    V4,
    V6,
}

fn main() {
    let a = IpAddrKind::V4;
    let b = IpAddrKind::V6;
    route(a);
    route(b);
}

fn route(kind: IpAddrKind) {
    match kind {
        IpAddrKind::V4 => println!("v4"),
        IpAddrKind::V6 => println!("v6"),
    }
}
```

## Variants Can Carry Data

```rust
enum IpAddr {
    V4(u8, u8, u8, u8),
    V6(String),
}

fn main() {
    let home = IpAddr::V4(127, 0, 0, 1);
    let loopback = IpAddr::V6(String::from("::1"));
    describe(&home);
    describe(&loopback);
}

fn describe(ip: &IpAddr) {
    match ip {
        IpAddr::V4(a, b, c, d) => println!("v4 {a}.{b}.{c}.{d}"),
        IpAddr::V6(s) => println!("v6 {s}"),
    }
}
```

Struct-like variants:

```rust
enum Message {
    Quit,
    Move { x: i32, y: i32 },
    Write(String),
    ChangeColor(u8, u8, u8),
}

impl Message {
    fn summary(&self) -> String {
        match self {
            Message::Quit => "quit".into(),
            Message::Move { x, y } => format!("move to ({x},{y})"),
            Message::Write(s) => format!("write {s}"),
            Message::ChangeColor(r, g, b) => format!("color {r},{g},{b}"),
        }
    }
}

fn main() {
    let msgs = [
        Message::Quit,
        Message::Move { x: 10, y: 20 },
        Message::Write(String::from("hi")),
        Message::ChangeColor(255, 0, 0),
    ];
    for m in &msgs {
        println!("{}", m.summary());
    }
}
```

## `Option` and `Result` Are Enums

```rust
enum Option<T> {
    None,
    Some(T),
}

enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

(You use the std versions; do not redefine them.) Matching them is the same skill:

```rust
fn main() {
    let values = [Some(1), None, Some(3)];
    for v in values {
        match v {
            Some(n) => println!("n={n}"),
            None => println!("missing"),
        }
    }
}
```

## Exhaustiveness

The compiler errors if a variant is unhandled. When you add a variant later, `match` sites light up—this is a feature.

```rust
enum Status {
    Open,
    Closed,
    // Archived, // uncomment later and fix matches
}

fn label(s: Status) -> &'static str {
    match s {
        Status::Open => "open",
        Status::Closed => "closed",
    }
}

fn main() {
    println!("{}", label(Status::Open));
}
```

Use `_` only when truly intentional—it silences future exhaustiveness help.

## Pattern Features

### Destructuring and ignores

```rust
enum Event {
    Click { x: i32, y: i32 },
    Key(char),
}

fn main() {
    let e = Event::Click { x: 5, y: 9 };
    match e {
        Event::Click { x, y: 0 } => println!("on x-axis at {x}"),
        Event::Click { x, y } => println!("click {x},{y}"),
        Event::Key(_) => println!("key"),
    }
}
```

### Guards

```rust
fn classify(n: i32) -> &'static str {
    match n {
        x if x < 0 => "neg",
        0 => "zero",
        x if x % 2 == 0 => "pos even",
        _ => "pos odd",
    }
}

fn main() {
    for n in [-2, 0, 3, 4] {
        println!("{n}: {}", classify(n));
    }
}
```

### `@` bindings

```rust
fn main() {
    let msg = Some(5);
    match msg {
        Some(n @ 1..=9) => println!("digit-ish {n}"),
        Some(n) => println!("other {n}"),
        None => {}
    }
}
```

### Nested patterns

```rust
struct Point {
    x: i32,
    y: i32,
}

enum Shape {
    Circle { center: Point, r: u32 },
    Rect(Point, Point),
}

fn main() {
    let s = Shape::Circle {
        center: Point { x: 0, y: 0 },
        r: 5,
    };
    match s {
        Shape::Circle {
            center: Point { x: 0, y: 0 },
            r,
        } => println!("origin circle r={r}"),
        Shape::Circle { center, r } => println!("circle at {},{} r={r}", center.x, center.y),
        Shape::Rect(a, b) => println!("rect {},{} -> {},{}", a.x, a.y, b.x, b.y),
    }
}
```

## `if let` and `let-else`

```rust
fn main() {
    let config = Some(String::from("dark"));
    if let Some(theme) = &config {
        println!("theme={theme}");
    }

    let Some(theme) = config else {
        eprintln!("missing theme");
        return;
    };
    println!("owned theme={theme}");
}
```

## Methods That Transition State

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
enum Connection {
    Disconnected,
    Connecting { attempt: u32 },
    Connected { session: String },
    Failed { reason: String },
}

impl Connection {
    fn start() -> Self {
        Connection::Disconnected
    }

    fn begin_connect(self) -> Self {
        match self {
            Connection::Connected { .. } => self,
            Connection::Connecting { attempt } if attempt >= 3 => Connection::Failed {
                reason: "max attempts".into(),
            },
            Connection::Connecting { attempt } => Connection::Connecting {
                attempt: attempt + 1,
            },
            _ => Connection::Connecting { attempt: 1 },
        }
    }

    fn succeed(self, session: impl Into<String>) -> Self {
        Connection::Connected {
            session: session.into(),
        }
    }

    fn fail(self, reason: impl Into<String>) -> Self {
        Connection::Failed {
            reason: reason.into(),
        }
    }
}

fn main() {
    let c = Connection::start().begin_connect().succeed("abc123");
    println!("{c:?}");
}
```

Enums + consuming methods encode legal transitions better than a pile of booleans.

## Match Ergonomics and Borrowing

```rust
enum MaybeName {
    Name(String),
    Anonymous,
}

fn main() {
    let m = MaybeName::Name(String::from("Ada"));
    match &m {
        MaybeName::Name(n) => println!("name={n}"),
        MaybeName::Anonymous => println!("anon"),
    }
    // m still owned
    match m {
        MaybeName::Name(n) => println!("moved {n}"),
        MaybeName::Anonymous => {}
    }
}
```

## Worked Example: CLI Command Enum

```rust
#[derive(Debug, PartialEq, Eq)]
enum Command {
    Add { text: String },
    Remove { id: u32 },
    List,
    Help,
}

fn parse(args: &[&str]) -> Result<Command, String> {
    let Some(cmd) = args.first().copied() else {
        return Ok(Command::Help);
    };
    match cmd {
        "help" => Ok(Command::Help),
        "list" => Ok(Command::List),
        "add" => {
            let text = args[1..].join(" ");
            if text.trim().is_empty() {
                return Err("add needs text".into());
            }
            Ok(Command::Add { text })
        }
        "remove" => {
            let id = args
                .get(1)
                .ok_or("remove needs id")?
                .parse()
                .map_err(|e| format!("id: {e}"))?;
            Ok(Command::Remove { id })
        }
        other => Err(format!("unknown {other}")),
    }
}

fn main() {
    let samples = [
        vec![],
        vec!["list"],
        vec!["add", "buy", "milk"],
        vec!["remove", "3"],
        vec!["nope"],
    ];
    for s in samples {
        println!("{:?} → {:?}", s, parse(&s));
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn add_joins() {
        assert_eq!(
            parse(&["add", "a", "b"]).unwrap(),
            Command::Add {
                text: "a b".into()
            }
        );
    }
}
```

## Prefer Enums Over Stringly State

```rust
// Hard to maintain:
// status: String  // "open" | "closed" | "???"

// Better:
enum Status {
    Open,
    Closed,
}
```

Invalid states become unrepresentable.

## Hands-On Practice

1. Define `enum Shape { Circle(f64), Rectangle { w: f64, h: f64 } }` with `fn area(&self) -> f64`.
2. Write a `match` that classifies HTTP-ish status codes stored as `enum` buckets plus an `Other(u16)`.
3. Model a traffic light with methods `next(self) -> Self`.
4. Parse `"ON"`/`"OFF"` into `enum Power` with `FromStr`.
5. Refactor a boolean pair `(is_admin, is_active)` into a single enum if it improves clarity.
6. Unit test every variant of `area`.

```rust
#[derive(Debug)]
enum Shape {
    Circle(f64),
    Rectangle { w: f64, h: f64 },
}

impl Shape {
    fn area(&self) -> f64 {
        match self {
            Shape::Circle(r) => std::f64::consts::PI * r * r,
            Shape::Rectangle { w, h } => w * h,
        }
    }
}

enum Light {
    Red,
    Green,
    Yellow,
}

impl Light {
    fn next(self) -> Self {
        match self {
            Light::Red => Light::Green,
            Light::Green => Light::Yellow,
            Light::Yellow => Light::Red,
        }
    }
}

fn main() {
    let s = Shape::Rectangle { w: 3.0, h: 4.0 };
    println!("area={}", s.area());
    let mut l = Light::Red;
    for _ in 0..4 {
        l = l.next();
    }
}
```

## Common Mistakes

- **Boolean soup** instead of enums for multi-state logic.
- **`_` catch-alls too early** hiding new variants.
- **Moving out of enum in a match** while still needing the original—match on a reference.
- **Huge enums without methods** — put behavior in `impl`.
- **Using strings for commands** without parsing into an enum at the boundary.

## Chapter Summary

Enums express **one of several shapes of data** and pair naturally with **exhaustive `match`**. Carrying data in variants makes invalid states harder to represent. Combined with methods, enums model lifecycles cleanly. Next: **modules and crates**—organizing growing codebases with Cargo.
