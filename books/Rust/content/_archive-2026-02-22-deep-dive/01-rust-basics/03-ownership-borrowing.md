# Ownership and Borrowing Fundamentals

## Mental Model

- Each value has one owner.
- Value is dropped when owner goes out of scope.
- You can borrow immutably many times, or mutably once.

## Moves vs Clones

```rust
fn main() {
    let s1 = String::from("rust");
    let s2 = s1; // move
    // println!("{}", s1); // compile error
    println!("{}", s2);
}
```

Clone only when ownership duplication is truly needed.

```rust
let s3 = s2.clone();
```

## Borrowing

```rust
fn length(s: &str) -> usize {
    s.len()
}

fn main() {
    let name = String::from("Ferris");
    println!("{}", length(&name));
}
```

## Mutable Borrowing

```rust
fn append_world(s: &mut String) {
    s.push_str(" world");
}

fn main() {
    let mut msg = String::from("hello");
    append_world(&mut msg);
    println!("{msg}");
}
```

## Slices

```rust
fn first_word(s: &str) -> &str {
    match s.find(' ') {
        Some(i) => &s[..i],
        None => s,
    }
}
```

## Lifetime Hint

Most beginner code does not need explicit lifetime annotations. Write signatures with references first; add lifetimes only when compiler asks.

## Practice

1. Implement `fn last_word(s: &str) -> &str`.
2. Write `fn normalize(s: &mut String)` that trims and lowercases.
3. Remove one unnecessary `.clone()` from your code.

## Deep Dive: Borrow Checker Decision Rules

When borrow errors occur, ask:

1. Who owns this value right now?
2. Is there an active mutable borrow?
3. How long does this borrow need to live?

Reducing borrow scope usually fixes most issues.

## Example: Fixing Borrow Scope

```rust
fn main() {
    let mut s = String::from("rust");

    {
        let r = &s;
        println!("{r}");
    }

    s.push('!');
    println!("{s}");
}
```

## Example: Borrowed Return Without Allocation

```rust
fn file_ext(path: &str) -> &str {
    match path.rsplit_once('.') {
        Some((_, ext)) => ext,
        None => "",
    }
}
```

## Example: Mutable Slice Processing

```rust
fn normalize_scores(scores: &mut [u8]) {
    for s in scores.iter_mut() {
        if *s > 100 {
            *s = 100;
        }
    }
}
```

## Common Pitfalls and Fixes

- Pitfall: cloning to bypass borrow checker.
- Fix: redesign function signatures with references.

- Pitfall: returning reference to temporary value.
- Fix: return owned value (`String`) or borrow from input.

## Review Questions

1. Why can there be many immutable borrows but one mutable borrow?
2. What signals that a clone is unnecessary?
3. When should function return `String` instead of `&str`?
