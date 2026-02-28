# Traits, Generics, and Lifetimes

## Traits for Behavior

```rust
trait Summary {
    fn summary(&self) -> String;
}

struct Article {
    title: String,
}

impl Summary for Article {
    fn summary(&self) -> String {
        format!("Article: {}", self.title)
    }
}
```

## Generic Functions

```rust
fn largest<T: Ord + Copy>(items: &[T]) -> Option<T> {
    items.iter().copied().max()
}
```

## Generic Structs

```rust
struct Point<T> {
    x: T,
    y: T,
}
```

## Lifetime Example

```rust
fn longer<'a>(a: &'a str, b: &'a str) -> &'a str {
    if a.len() >= b.len() { a } else { b }
}
```

Use explicit lifetimes to describe how output borrows from input.

## Trait Bounds in APIs

```rust
use std::fmt::Display;

fn print_twice<T: Display>(value: T) {
    println!("{value}");
    println!("{value}");
}
```

## Practice

1. Create a `Persistable` trait with `save()`.
2. Build `Repository<T>` generic over entity type.
3. Write one function requiring lifetime annotation.

## Deep Dive: Trait Objects vs Generics

- Generics (`T: Trait`) monomorphize at compile time.
- Trait objects (`Box<dyn Trait>`) enable runtime polymorphism.

## Generic Strategy Example

```rust
trait Formatter {
    fn format(&self, input: &str) -> String;
}

struct Upper;
impl Formatter for Upper {
    fn format(&self, input: &str) -> String {
        input.to_uppercase()
    }
}

fn apply<F: Formatter>(f: &F, s: &str) -> String {
    f.format(s)
}
```

## Trait Object Example

```rust
fn apply_dyn(f: &dyn Formatter, s: &str) -> String {
    f.format(s)
}
```

## Lifetime Practice Pattern

```rust
struct LineRef<'a> {
    line: &'a str,
}
```

Use this when struct stores borrowed data.

## Review Questions

1. When prefer generics over trait objects?
2. What lifetime does `'a` communicate in a struct?
3. Why are lifetime annotations about relationships, not duration in time?
