# Traits

## Learning Goals

- Define traits and implement them for your types.
- Use default methods and override them when needed.
- Accept trait bounds in functions (`T: Trait`, `impl Trait`, `dyn Trait` intro).
- Derive and manually implement common std traits: `Display`, `Debug`, `Default`, `From`.
- Understand traits as Rust’s primary abstraction for shared behavior.

## What Is a Trait?

A **trait** defines a set of methods a type must provide—similar in spirit to interfaces, with important differences (coherence, orphan rules, static dispatch by default).

```rust
trait Greet {
    fn greet(&self) -> String;
}

struct Person {
    name: String,
}

impl Greet for Person {
    fn greet(&self) -> String {
        format!("Hello, {}!", self.name)
    }
}

fn main() {
    let p = Person {
        name: String::from("Ada"),
    };
    println!("{}", p.greet());
}
```

## Default Method Implementations

```rust
trait Summary {
    fn summarize_author(&self) -> String;

    fn summarize(&self) -> String {
        format!("(Read more from {}...)", self.summarize_author())
    }
}

struct Article {
    author: String,
    headline: String,
}

impl Summary for Article {
    fn summarize_author(&self) -> String {
        self.author.clone()
    }

    fn summarize(&self) -> String {
        format!("{} — by {}", self.headline, self.author)
    }
}

struct Tweet {
    username: String,
    content: String,
}

impl Summary for Tweet {
    fn summarize_author(&self) -> String {
        format!("@{}", self.username)
    }
    // uses default summarize
}

fn main() {
    let a = Article {
        author: "Grace".into(),
        headline: "Compilers".into(),
    };
    let t = Tweet {
        username: "ferris".into(),
        content: "hi".into(),
    };
    println!("{}", a.summarize());
    println!("{}", t.summarize());
}
```

## Traits as Parameters

### `impl Trait` in argument position

```rust
fn notify(item: &impl Summary) {
    println!("Breaking: {}", item.summarize());
}
```

### Trait bound syntax (more flexible)

```rust
fn notify_bound<T: Summary>(item: &T) {
    println!("{}", item.summarize());
}

fn notify_two<T: Summary + Clone>(item: &T) {
    let _ = item.clone();
    println!("{}", item.summarize());
}
```

### `where` clauses

```rust
fn some_function<T, U>(t: &T, u: &U) -> String
where
    T: Summary + Clone,
    U: Summary,
{
    format!("{} | {}", t.summarize(), u.summarize())
}
```

## Returning `impl Trait`

```rust
fn make_tweet(user: &str) -> impl Summary {
    Tweet {
        username: user.into(),
        content: "hello".into(),
    }
}
```

Note: `impl Trait` in return position is a **single concrete type** (opaque). Returning either `Article` or `Tweet` from one function needs `Box<dyn Summary>` or an enum.

## Trait Bounds on Methods / Structs (Preview with Generics)

```rust
struct Wrapper<T: Summary> {
    item: T,
}

impl<T: Summary> Wrapper<T> {
    fn print(&self) {
        println!("{}", self.item.summarize());
    }
}
```

More on generics next chapter—traits and generics are inseparable.

## Common Standard Traits

### `Display` and `Debug`

```rust
use std::fmt;

struct Point {
    x: i32,
    y: i32,
}

impl fmt::Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl fmt::Debug for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Point")
            .field("x", &self.x)
            .field("y", &self.y)
            .finish()
    }
}

fn main() {
    let p = Point { x: 1, y: 2 };
    println!("display {p}");
    println!("debug {p:?}");
}
```

### `Default`

```rust
#[derive(Debug, Default)]
struct Config {
    host: String,
    port: u16,
}

// manual if needed:
// impl Default for Config { fn default() -> Self { ... } }

fn main() {
    let c = Config {
        port: 8080,
        ..Config::default()
    };
    println!("{c:?}");
}
```

### `From` / `Into`

```rust
struct Metres(f64);

impl From<f64> for Metres {
    fn from(v: f64) -> Self {
        Self(v)
    }
}

fn main() {
    let m: Metres = 3.5_f64.into();
    let m2 = Metres::from(2.0);
    println!("{} {}", m.0, m2.0);
}
```

Implement `From`; `Into` is free via a blanket impl.

### `Clone` / `PartialEq`

Prefer `#[derive(...)]` when all fields support it.

## Operator Traits (A Taste)

```rust
use std::ops::Add;

#[derive(Debug, Clone, Copy)]
struct Vec2 {
    x: i32,
    y: i32,
}

impl Add for Vec2 {
    type Output = Self;
    fn add(self, rhs: Self) -> Self {
        Self {
            x: self.x + rhs.x,
            y: self.y + rhs.y,
        }
    }
}

fn main() {
    let a = Vec2 { x: 1, y: 2 };
    let b = Vec2 { x: 3, y: 4 };
    println!("{:?}", a + b);
}
```

## Associated Types

```rust
trait Iteratorish {
    type Item;
    fn next(&mut self) -> Option<Self::Item>;
}

struct Counter {
    n: u32,
    max: u32,
}

impl Iteratorish for Counter {
    type Item = u32;
    fn next(&mut self) -> Option<Self::Item> {
        if self.n < self.max {
            let v = self.n;
            self.n += 1;
            Some(v)
        } else {
            None
        }
    }
}

fn main() {
    let mut c = Counter { n: 0, max: 3 };
    while let Some(v) = c.next() {
        println!("{v}");
    }
}
```

Real code implements `std::iter::Iterator` instead of inventing this.

## Supertraits

```rust
use std::fmt::Display;

trait OutlinePrint: Display {
    fn outline_print(&self) {
        let s = self.to_string();
        println!("*{}*", s);
    }
}

struct Point {
    x: i32,
    y: i32,
}

impl Display for Point {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "({}, {})", self.x, self.y)
    }
}

impl OutlinePrint for Point {}

use std::fmt;

fn main() {
    Point { x: 1, y: 2 }.outline_print();
}
```

## Fully Qualified Syntax

When multiple traits define the same method name:

```rust
trait A {
    fn hello(&self) -> &str {
        "A"
    }
}
trait B {
    fn hello(&self) -> &str {
        "B"
    }
}
struct T;
impl A for T {}
impl B for T {}

fn main() {
    let t = T;
    println!("{}", A::hello(&t));
    println!("{}", B::hello(&t));
    println!("{}", <T as A>::hello(&t));
}
```

## Dynamic Dispatch Intro: `dyn Trait`

```rust
fn print_summary(item: &dyn Summary) {
    println!("{}", item.summarize());
}

fn main() {
    let t = Tweet {
        username: "a".into(),
        content: "b".into(),
    };
    print_summary(&t);
}
```

- **Static dispatch** (`impl Trait` / generics): monomorphized, often faster.
- **Dynamic dispatch** (`dyn Trait`): fat pointer + vtable, useful for heterogeneous collections.

```rust
fn main() {
    let items: Vec<Box<dyn Summary>> = vec![
        Box::new(Article {
            author: "a".into(),
            headline: "h".into(),
        }),
        Box::new(Tweet {
            username: "u".into(),
            content: "c".into(),
        }),
    ];
    for i in items {
        println!("{}", i.summarize());
    }
}
```

`Summary` must be **object-safe** for `dyn Summary` (roughly: methods don’t return `Self` or use generics in object-incompatible ways). Defaults that call other methods are fine if the trait is object-safe.

## Orphan Rule (Awareness)

You may implement a trait for a type only if **either** the trait **or** the type is local to your crate. You cannot implement `Display` for `Vec<T>` from your crate—wrap it in a newtype.

```rust
struct MyVec(Vec<i32>);
// impl Display for MyVec { ... } // ok
```

## Worked Example: Serialize-ish Trait for Notes

```rust
trait Wire {
    fn to_wire(&self) -> String;
    fn from_wire(s: &str) -> Result<Self, String>
    where
        Self: Sized;
}

#[derive(Debug, PartialEq, Eq)]
struct Note {
    id: u32,
    text: String,
}

impl Wire for Note {
    fn to_wire(&self) -> String {
        format!("{}|{}", self.id, self.text)
    }

    fn from_wire(s: &str) -> Result<Self, String> {
        let (id, text) = s
            .split_once('|')
            .ok_or_else(|| "missing |".to_string())?;
        let id = id.parse().map_err(|e| format!("id: {e}"))?;
        Ok(Self {
            id,
            text: text.to_string(),
        })
    }
}

fn roundtrip<T: Wire + PartialEq + std::fmt::Debug>(value: &T) {
    let w = value.to_wire();
    let back = T::from_wire(&w).unwrap();
    assert_eq!(&back, value);
    println!("ok: {w}");
}

fn main() {
    let n = Note {
        id: 1,
        text: "hi".into(),
    };
    roundtrip(&n);
}
```

## Hands-On Practice

1. Define `trait Area { fn area(&self) -> f64; }` for `Circle` and `Rectangle`.
2. Write `fn total_area(items: &[impl Area])` — or use generics.
3. Implement `Display` for a `UserId(u64)` newtype.
4. Implement `From<&str>` for a small `Name` wrapper that rejects empty strings via `TryFrom` instead if you prefer fallible.
5. Create `Vec<Box<dyn Area>>` and sum areas.
6. Use `cargo test` for `from_wire` error cases.

```rust
trait Area {
    fn area(&self) -> f64;
}

struct Circle {
    r: f64,
}
struct Rect {
    w: f64,
    h: f64,
}

impl Area for Circle {
    fn area(&self) -> f64 {
        std::f64::consts::PI * self.r * self.r
    }
}
impl Area for Rect {
    fn area(&self) -> f64 {
        self.w * self.h
    }
}

fn total(items: &[&dyn Area]) -> f64 {
    items.iter().map(|i| i.area()).sum()
}

fn main() {
    let c = Circle { r: 2.0 };
    let r = Rect { w: 3.0, h: 4.0 };
    println!("{}", total(&[&c, &r]));
}
```

## Common Mistakes

- **Forgetting to import a trait** so methods are not in scope (`use std::io::Write;`).
- **Fighting the orphan rule** — use newtypes.
- **Overusing `dyn` when generics are simpler** and more optimizable.
- **Non-object-safe traits** used as `dyn` unexpectedly.
- **Huge trait surfaces** — prefer small traits (interface segregation).

## Chapter Summary

Traits define **shared behavior**. Use bounds and `impl Trait` for flexible APIs, implement std traits for ergonomics, and reach for `dyn Trait` when you need heterogeneous values. Next: **generics**—type parameters that work with traits to build reusable data structures and functions.
