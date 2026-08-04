# Ownership Basics

## Learning Goals

- State Rust’s three ownership rules from memory.
- Predict when values are **moved**, **copied**, or **dropped**.
- Explain stack vs heap for `String` vs integers.
- Return ownership from functions and avoid accidental moves.
- Read common move-related compiler errors and fix them deliberately.

## The Three Rules

1. Each value in Rust has a variable that is its **owner**.
2. There can only be **one owner** at a time.
3. When the owner goes **out of scope**, the value is **dropped**.

These rules make memory safety possible **without a GC**.

```rust
fn main() {
    {
        let s = String::from("hello"); // s owns the String
        println!("{s}");
    } // s goes out of scope; memory freed (Drop)
}
```

## Stack, Heap, and `String`

- **Stack:** fixed-size values (`i32`, `bool`, small arrays). Fast push/pop with scopes.
- **Heap:** growable data. `String` holds a pointer, length, and capacity on the stack; bytes on the heap.

```rust
fn main() {
    let x = 5; // entirely on the stack
    let s = String::from("hello"); // metadata stack, data heap
    println!("x={x}, s={s}");
}
```

`String::from` allocates. When the owner drops, the heap buffer is freed exactly once.

## Move Semantics

Assigning a non-`Copy` value **moves** ownership. The old name becomes invalid.

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1; // move
    // println!("{s1}"); // error: borrow of moved value
    println!("{s2}");
}
```

Why not auto-deep-copy? Hidden allocations would be expensive and surprising. Rust makes moves explicit and cheap (pointer metadata moves; heap data not cloned).

### Visual mental model

```text
Before move:  s1 → [h e l l o]
After move:   s1 (invalid)
              s2 → [h e l l o]
Drop s2: free heap once
```

## `Clone` When You Need a Deep Copy

```rust
fn main() {
    let s1 = String::from("hello");
    let s2 = s1.clone();
    println!("s1={s1}, s2={s2}");
}
```

Cloning is explicit—you see the cost in the source.

## The `Copy` Trait

Types that are trivial to duplicate implement `Copy` (and `Clone`). Assignment copies bits; old binding remains valid.

Common `Copy` types: integers, floats, `bool`, `char`, shared references `&T`, and tuples/arrays of `Copy` types.

```rust
fn main() {
    let x = 5;
    let y = x; // copy
    println!("x={x}, y={y}");
}
```

`String`, `Vec`, and other owned heap structures are **not** `Copy`.

```rust
fn main() {
    let a = [1, 2, 3]; // [i32; 3] is Copy
    let b = a;
    println!("{a:?} {b:?}");

    let v = vec![1, 2, 3]; // Vec is not Copy
    let w = v;
    // println!("{v:?}"); // moved
    println!("{w:?}");
}
```

## Ownership and Functions

Passing a non-`Copy` argument **moves** into the function unless you pass a reference (next chapter).

```rust
fn take(s: String) {
    println!("took {s}");
} // s dropped here

fn main() {
    let s = String::from("rust");
    take(s);
    // println!("{s}"); // moved
}
```

### Give ownership back

```rust
fn take_and_give(s: String) -> String {
    println!("saw {s}");
    s
}

fn main() {
    let s = String::from("rust");
    let s = take_and_give(s);
    println!("back: {s}");
}
```

### Return newly created ownership

```rust
fn make_greeting(name: &str) -> String {
    format!("Hello, {name}!")
}

fn main() {
    let g = make_greeting("Ferris");
    println!("{g}");
}
```

## Scope and Partial Moves

Moving a field can partially invalidate a struct:

```rust
struct Who {
    name: String,
    age: u32,
}

fn main() {
    let w = Who {
        name: String::from("Ada"),
        age: 36,
    };
    let name = w.name; // move field
    // println!("{}", w.name); // error
    println!("age still accessible? {}", w.age); // age is Copy
    println!("name={name}");
}
```

Design note: prefer borrowing fields over moving them out when you still need the whole struct.

## `Drop` Trait (Conceptual)

When a value goes out of scope, Rust calls `drop` (the `Drop` trait). You rarely implement it early, but you benefit from RAII: files close, locks release, memory frees.

```rust
struct Banner;

impl Drop for Banner {
    fn drop(&mut self) {
        println!("Banner dropped");
    }
}

fn main() {
    let _b = Banner;
    println!("end of main coming");
}
```

## Ownership in Collections

Pushing into a `Vec` **moves** (or copies) the element into the vector:

```rust
fn main() {
    let mut names = Vec::new();
    let n = String::from("a");
    names.push(n);
    // println!("{n}"); // moved into vec
    names.push(String::from("b"));
    println!("{names:?}");
}
```

## Moves in Control Flow

The compiler tracks ownership through branches:

```rust
fn main() {
    let s = String::from("x");
    let t = false;
    if t {
        drop(s);
    } else {
        println!("{s}"); // ok: only this branch uses s
    }
}
```

If both branches need different ownership outcomes, structure carefully—or clone, or borrow.

```rust
fn maybe_take(flag: bool, s: String) -> Option<String> {
    if flag {
        Some(s)
    } else {
        println!("not taking {s}");
        None
        // s dropped at end of else when not returned — actually moved into println via Display? 
        // Wait: println borrows s, then s drops at end of else. Good.
    }
}

fn main() {
    println!("{:?}", maybe_take(true, String::from("yes")));
    println!("{:?}", maybe_take(false, String::from("no")));
}
```

Actually looking at my maybe_take - in the else branch, s is still owned and drops at end. Good.

## Common Patterns

### Pattern: transform owned data

```rust
fn normalize(s: String) -> String {
    s.trim().to_lowercase()
}

fn main() {
    let s = String::from("  RuSt  ");
    let s = normalize(s);
    println!("{s}");
}
```

### Pattern: build and return

```rust
fn join_names(a: &str, b: &str) -> String {
    format!("{a}+{b}")
}

fn main() {
    println!("{}", join_names("left", "right"));
}
```

### Anti-pattern: clone to silence the compiler blindly

```rust
fn main() {
    let s = String::from("data");
    // let s2 = s.clone(); // only if you truly need two owned copies
    let s2 = s;
    println!("{s2}");
}
```

Prefer redesigning APIs to **borrow** when both sides need access.

## Worked Example: Ownership Through a Pipeline

```rust
fn read_fake_input() -> String {
    String::from("  cargo test  ")
}

fn clean(s: String) -> String {
    s.trim().to_string()
}

fn tokenize(s: String) -> Vec<String> {
    s.split_whitespace().map(|t| t.to_string()).collect()
}

fn main() {
    let raw = read_fake_input();
    let cleaned = clean(raw);
    let tokens = tokenize(cleaned);
    println!("{tokens:?}");
}
```

Better with borrowing where possible:

```rust
fn clean_str(s: &str) -> &str {
    s.trim()
}

fn tokenize_str(s: &str) -> Vec<&str> {
    s.split_whitespace().collect()
}

fn main() {
    let raw = String::from("  cargo test  ");
    let cleaned = clean_str(&raw);
    let tokens = tokenize_str(cleaned);
    println!("{tokens:?}");
    println!("raw still owned: {raw:?}");
}
```

## Hands-On Practice

1. Demonstrate a move with `String` and paste the compiler error into your notes (then fix).
2. Write `fn consume(s: String)` and `fn borrow(s: &str)`. Call both appropriately from `main`.
3. Build a `Vec<String>` by moving five owned strings into it; print the vec.
4. Implement `fn longest_owned(a: String, b: String) -> String` returning the longer (clone or move one). Then write a better `fn longer_len(a: &str, b: &str) -> usize`.
5. Use `clone` once intentionally and comment **why** two owners are required.
6. Add a type that implements `Drop` and observe print order.

```rust
fn longer_len(a: &str, b: &str) -> usize {
    a.len().max(b.len())
}

fn longest_owned(a: String, b: String) -> String {
    if a.len() >= b.len() {
        a
    } else {
        b
    }
}

fn main() {
    let a = String::from("alpha");
    let b = String::from("toolong");
    println!("len max {}", longer_len(&a, &b));
    println!("owned {}", longest_owned(a, b));
}
```

## Common Mistakes

- **Using a value after move** — trust the compiler; redesign with borrow/return.
- **Cloning everything** — hides design issues and costs allocations.
- **Thinking `Copy` applies to `String`** — it does not.
- **Partial moves** out of structs then trying to use the whole struct.
- **Assuming move is slow** — moving a `String` copies only pointer/len/cap, not the bytes.

## Chapter Summary

Ownership is Rust’s core memory model: **one owner**, **moves transfer ownership**, **drop frees resources**, and **`Copy`/`clone`** make duplication explicit. Prefer APIs that **borrow** when callers need to keep data. Next: **borrowing and references**—using values without taking ownership.
