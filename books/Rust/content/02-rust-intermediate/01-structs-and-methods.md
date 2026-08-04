# Structs and Methods

## Learning Goals

- Define named-field structs, tuple structs, and unit structs.
- Implement methods and associated functions with `impl`.
- Choose among `self`, `&self`, and `&mut self` correctly.
- Derive common traits (`Debug`, `Clone`, `PartialEq`) responsibly.
- Model small domain types with ownership-aware field design.

## Why Structs?

Structs group related data under a single type—your domain language in code.

```rust
struct User {
    id: u64,
    email: String,
    active: bool,
}

fn main() {
    let u = User {
        id: 1,
        email: String::from("ada@example.com"),
        active: true,
    };
    println!("{} active={}", u.email, u.active);
}
```

## Defining and Instantiating

Field order in the struct definition is fixed; init can use **field init shorthand**:

```rust
fn new_user(id: u64, email: String) -> User {
    User {
        id,
        email,
        active: true,
    }
}

struct User {
    id: u64,
    email: String,
    active: bool,
}

fn main() {
    let email = String::from("grace@example.com");
    let u = new_user(2, email);
    // email moved into User
    println!("{}", u.email);
}
```

### Update syntax

```rust
fn main() {
    let u1 = User {
        id: 1,
        email: String::from("a@x.com"),
        active: true,
    };
    let u2 = User {
        email: String::from("b@x.com"),
        ..u1
    };
    // u1.email was moved; u1.id/active are Copy so partial use rules apply
    println!("{} {}", u2.email, u2.id);
}

struct User {
    id: u64,
    email: String,
    active: bool,
}
```

## Ownership of Fields

- Owned fields (`String`, `Vec`) mean the struct **owns** that data.
- Borrowed fields (`&str`) require **lifetimes** (later chapter)—prefer owned fields until then.

```rust
struct Note {
    id: u32,
    text: String, // owns text
}

fn main() {
    let n = Note {
        id: 1,
        text: String::from("ship it"),
    };
    let text = n.text; // move field out
    // println!("{}", n.text); // error
    println!("{text}");
}
```

Borrow fields instead of moving when you still need the struct:

```rust
fn preview(n: &Note) -> &str {
    &n.text
}

struct Note {
    id: u32,
    text: String,
}

fn main() {
    let n = Note {
        id: 1,
        text: String::from("ship it"),
    };
    println!("{}", preview(&n));
    println!("still: {}", n.text);
}
```

## Tuple Structs

```rust
struct Color(u8, u8, u8);
struct Point(f64, f64);

fn main() {
    let black = Color(0, 0, 0);
    let origin = Point(0.0, 0.0);
    println!("r={} x={}", black.0, origin.0);
}
```

Useful for strong typing without named fields (`struct Metres(f64);`).

## Unit-Like Structs

```rust
struct AlwaysEqual;

fn main() {
    let _marker = AlwaysEqual;
}
```

Used as markers or trait implementors without data.

## Methods with `impl`

```rust
#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

impl Rectangle {
    fn area(&self) -> u32 {
        self.width * self.height
    }

    fn can_hold(&self, other: &Rectangle) -> bool {
        self.width >= other.width && self.height >= other.height
    }

    fn square(size: u32) -> Self {
        Self {
            width: size,
            height: size,
        }
    }

    fn grow(&mut self, by: u32) {
        self.width += by;
        self.height += by;
    }
}

fn main() {
    let mut r = Rectangle {
        width: 30,
        height: 50,
    };
    let sq = Rectangle::square(10);
    println!("{:?} area={}", r, r.area());
    println!("holds square? {}", r.can_hold(&sq));
    r.grow(5);
    println!("grown {:?}", r);
}
```

### Receiver cheat sheet

| Receiver | Meaning |
|----------|---------|
| `&self` | Borrow immutably (read) |
| `&mut self` | Borrow mutably (modify) |
| `self` | Take ownership (consume) |
| `mut self` | Own and mutate before possibly returning |

```rust
struct Token(String);

impl Token {
    fn into_inner(self) -> String {
        self.0
    }
}

fn main() {
    let t = Token(String::from("secret"));
    let s = t.into_inner();
    // t consumed
    println!("{s}");
}
```

## Multiple `impl` Blocks

Allowed and common (e.g. separate inherent methods from trait impls later):

```rust
struct Counter {
    n: u32,
}

impl Counter {
    fn new() -> Self {
        Self { n: 0 }
    }
}

impl Counter {
    fn inc(&mut self) {
        self.n += 1;
    }

    fn get(&self) -> u32 {
        self.n
    }
}

fn main() {
    let mut c = Counter::new();
    c.inc();
    println!("{}", c.get());
}
```

## Associated Functions vs Methods

- **Method:** first param is a self receiver; called with method syntax `value.method()`.
- **Associated function:** no self; often constructors `Type::new()`.

```rust
impl Rectangle {
    fn new(width: u32, height: u32) -> Option<Self> {
        if width == 0 || height == 0 {
            None
        } else {
            Some(Self { width, height })
        }
    }
}

#[derive(Debug)]
struct Rectangle {
    width: u32,
    height: u32,
}

fn main() {
    println!("{:?}", Rectangle::new(3, 4));
    println!("{:?}", Rectangle::new(0, 4));
}
```

## Deriving Traits

```rust
#[derive(Debug, Clone, PartialEq, Eq)]
struct UserId(u64);

fn main() {
    let a = UserId(7);
    let b = a.clone();
    assert_eq!(a, b);
    println!("{a:?}");
}
```

| Derive | Purpose |
|--------|---------|
| `Debug` | `{:?}` formatting |
| `Clone` | explicit deep-ish copy |
| `Copy` | only if all fields are `Copy` |
| `PartialEq` / `Eq` | equality |
| `Default` | `Type::default()` |

Do not derive `Copy` for types owning heap data.

## Builder Pattern (Light)

```rust
#[derive(Debug, Default)]
struct Request {
    path: String,
    verbose: bool,
}

impl Request {
    fn path(mut self, path: impl Into<String>) -> Self {
        self.path = path.into();
        self
    }

    fn verbose(mut self, yes: bool) -> Self {
        self.verbose = yes;
        self
    }
}

fn main() {
    let req = Request::default().path("/health").verbose(true);
    println!("{req:?}");
}
```

Consuming builder uses `self` by value; good for one-shot configuration.

## Visibility Preview

```rust
pub struct Config {
    pub name: String,
    max_retries: u32, // private field
}

impl Config {
    pub fn new(name: impl Into<String>) -> Self {
        Self {
            name: name.into(),
            max_retries: 3,
        }
    }

    pub fn max_retries(&self) -> u32 {
        self.max_retries
    }
}
```

Modules chapter expands `pub` and crate structure.

## Worked Example: Notes Domain Type

```rust
use std::fmt;

#[derive(Clone, PartialEq, Eq)]
struct Note {
    id: u32,
    text: String,
}

impl Note {
    fn new(id: u32, text: impl Into<String>) -> Result<Self, String> {
        let text = text.into();
        let text = text.trim().to_string();
        if text.is_empty() {
            return Err("note text empty".into());
        }
        Ok(Self { id, text })
    }

    fn id(&self) -> u32 {
        self.id
    }

    fn text(&self) -> &str {
        &self.text
    }

    fn set_text(&mut self, text: impl Into<String>) -> Result<(), String> {
        let text = text.into().trim().to_string();
        if text.is_empty() {
            return Err("note text empty".into());
        }
        self.text = text;
        Ok(())
    }
}

impl fmt::Display for Note {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        write!(f, "#{} {}", self.id, self.text)
    }
}

impl fmt::Debug for Note {
    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
        f.debug_struct("Note")
            .field("id", &self.id)
            .field("text", &self.text)
            .finish()
    }
}

fn main() {
    let mut n = Note::new(1, "  buy milk ").unwrap();
    println!("display: {n}");
    println!("debug: {n:?}");
    n.set_text("buy oat milk").unwrap();
    println!("text={}", n.text());
}
```

## Hands-On Practice

1. Model `Book { title: String, pages: u32, available: bool }` with `new` and `checkout(&mut self)`.
2. Implement `fn describe(&self) -> String` using `format!`.
3. Create a tuple struct `Celsius(f64)` with method `to_fahrenheit(&self) -> f64`.
4. Derive `Debug` + `PartialEq` and write a unit test for equality after mutation.
5. Implement a consuming method `fn into_title(self) -> String` on `Book`.
6. Clippy-clean your crate.

```rust
#[derive(Debug, PartialEq)]
struct Book {
    title: String,
    pages: u32,
    available: bool,
}

impl Book {
    fn new(title: impl Into<String>, pages: u32) -> Self {
        Self {
            title: title.into(),
            pages,
            available: true,
        }
    }

    fn checkout(&mut self) -> bool {
        if self.available {
            self.available = false;
            true
        } else {
            false
        }
    }

    fn into_title(self) -> String {
        self.title
    }
}

fn main() {
    let mut b = Book::new("The Rust Book", 500);
    assert!(b.checkout());
    assert!(!b.checkout());
    println!("{b:?}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn checkout_once() {
        let mut b = Book::new("X", 10);
        assert!(b.checkout());
        assert!(!b.available);
    }
}
```

## Common Mistakes

- **Always using `self` by value** for methods that should borrow—forces awkward reassignment.
- **Public fields everywhere** — prefer methods for invariants (non-empty text, etc.).
- **Storing `&str` too early** — lifetime noise; use `String` until lifetimes chapter.
- **Forgetting `#[derive(Debug)]`** when printing during debugging.
- **Partial moves** out of structs then trying to use the whole value.

## Chapter Summary

Structs model your data; `impl` blocks attach behavior. Choose **`&self` / `&mut self` / `self`** to match ownership needs. Prefer owned fields and constructors that enforce invariants. Next: **enums and pattern matching**—expressive state machines and error-friendly types.
