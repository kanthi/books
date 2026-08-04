# Borrowing and References

## Learning Goals

- Create shared references (`&T`) and mutable references (`&mut T`).
- State the borrow checker rules: many shared **or** one mutable, not both.
- Dereference with `*` when needed; prefer automatic deref in method calls.
- Pass and return references safely (without explicit lifetime syntax yet).
- Fix classic borrow errors: simultaneous mut + immut, dangling ideas, iterator invalidation patterns.

## Why Borrow?

Ownership moves are awkward when a function only needs to **read** or **temporarily modify** data. **Borrowing** lends access without transferring ownership.

```rust
fn main() {
    let s = String::from("hello");
    let len = str_len(&s); // borrow
    println!("'{s}' has len {len}"); // still own s
}

fn str_len(s: &String) -> usize {
    s.len()
}
```

Even better API: accept `&str` so both `String` and string literals work:

```rust
fn str_len(s: &str) -> usize {
    s.len()
}

fn main() {
    let owned = String::from("hello");
    println!("{}", str_len(&owned));
    println!("{}", str_len("world"));
}
```

## Shared References: `&T`

- Many shared references can coexist.
- Data cannot be mutated through a shared reference (with ordinary types).
- Creating `&T` requires the value to live long enough.

```rust
fn main() {
    let x = 10;
    let r1 = &x;
    let r2 = &x;
    println!("{r1} {r2}");
}
```

## Mutable References: `&mut T`

- Only **one** mutable reference at a time (in a given region).
- No shared references active while a mutable reference is active.
- The binding must be `mut` to create `&mut`.

```rust
fn main() {
    let mut s = String::from("hello");
    change(&mut s);
    println!("{s}");
}

fn change(s: &mut String) {
    s.push_str(", world");
}
```

## The Core Borrow Rules

At any time, you may have **either**:

- any number of `&T`, **or**
- exactly one `&mut T`,

and references must always be **valid** (no dangling).

```rust
fn main() {
    let mut s = String::from("hi");
    let r1 = &s;
    let r2 = &s;
    println!("{r1} {r2}");
    // r1, r2 last used above — non-lexical lifetimes allow mut borrow next
    let r3 = &mut s;
    r3.push('!');
    println!("{r3}");
}
```

This fails if overlapping:

```rust
fn main() {
    let mut s = String::from("hi");
    let r1 = &s;
    let r2 = &mut s; // error if r1 still used later
    // println!("{r1}");
    println!("{r2}");
}
```

## Dereferencing

Use `*` to access the underlying value when the compiler does not auto-deref:

```rust
fn main() {
    let mut x = 5;
    let r = &mut x;
    *r += 1;
    println!("{x}");
}
```

Method calls auto-deref: `s.len()` works on `String`, `&String`, `&str` via `Deref` coercions.

```rust
fn print_len(s: &str) {
    println!("{}", s.len());
}

fn main() {
    let owned = String::from("abc");
    print_len(&owned); // &String → &str
    print_len("abc");
}
```

## Mutable Borrowing Patterns

### Modify in place

```rust
fn add_exclamation(s: &mut String) {
    s.push('!');
}

fn main() {
    let mut name = String::from("Rust");
    add_exclamation(&mut name);
    println!("{name}");
}
```

### Swap or clear

```rust
fn main() {
    let mut a = String::from("left");
    let mut b = String::from("right");
    std::mem::swap(&mut a, &mut b);
    println!("{a} {b}");
    a.clear();
    println!("a cleared: '{a}', b={b}");
}
```

## Slices Are References

```rust
fn first_word(s: &str) -> &str {
    match s.find(' ') {
        Some(i) => &s[..i],
        None => s,
    }
}

fn main() {
    let sentence = String::from("cargo run");
    let word = first_word(&sentence);
    println!("first={word}");
    // sentence still owned; word borrows from it
    println!("full={sentence}");
}
```

You cannot mutate `sentence` while `word` (a borrow into it) is live:

```rust
fn main() {
    let mut sentence = String::from("cargo run");
    let word = first_word(&sentence);
    // sentence.clear(); // error: mutable borrow while word lives
    println!("{word}");
}

fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or("")
}
```

## Returning References (Intuition)

You can return references **into inputs** when the output lifetime is clearly tied to an input. Lifetime elision often makes this silent:

```rust
fn longer<'a>(a: &'a str, b: &'a str) -> &'a str {
    if a.len() >= b.len() {
        a
    } else {
        b
    }
}

fn main() {
    let a = String::from("short");
    let b = String::from("longer one");
    let r = longer(&a, &b);
    println!("{r}");
}
```

You **cannot** return a reference to a local dropped value:

```rust
// fn bad() -> &str {
//     let s = String::from("nope");
//     &s // dangling — will not compile
// }
```

Return owned data instead:

```rust
fn good() -> String {
    String::from("ok")
}

fn main() {
    println!("{}", good());
}
```

## References and Iteration

```rust
fn main() {
    let mut xs = vec![1, 2, 3];
    for x in &xs {
        println!("immut {x}");
    }
    for x in &mut xs {
        *x *= 10;
    }
    println!("{xs:?}");
}
```

Do not try to mutate a vector while holding an iterator that borrows it in conflicting ways—classic borrow conflict:

```rust
fn main() {
    let mut xs = vec![1, 2, 3];
    // for x in &xs {
    //     xs.push(*x); // error: cannot borrow as mutable
    // }
    let mut extra = Vec::new();
    for x in &xs {
        extra.push(*x);
    }
    xs.append(&mut extra);
    println!("{xs:?}");
}
```

## Shared XOR Mutable — Why It Matters

These rules prevent **data races** and many iterator invalidation bugs at compile time:

```text
Thread A: &mut data  ─┐
Thread B: &data      ─┴─ not allowed in safe Rust simultaneously
```

You will revisit this with threads in Intermediate. The same rules apply single-threaded—beneficial consistency.

## `ref` and Pattern Borrows

```rust
fn main() {
    let s = Some(String::from("hi"));
    match s {
        Some(ref inner) => println!("borrowed {inner}"),
        None => {}
    }
    println!("still have {s:?}");
}
```

Modern style often uses `as_ref()`:

```rust
fn main() {
    let s = Some(String::from("hi"));
    if let Some(inner) = s.as_ref() {
        println!("borrowed {inner}");
    }
    println!("still have {s:?}");
}
```

## Worked Example: In-Place Sanitize

```rust
fn sanitize(input: &mut String) {
    let cleaned: String = input
        .chars()
        .filter(|c| c.is_ascii_alphanumeric() || c.is_ascii_whitespace())
        .collect();
    *input = cleaned.trim().to_string();
}

fn word_count(s: &str) -> usize {
    s.split_whitespace().count()
}

fn main() {
    let mut note = String::from("  Hello, Rust!!!  ");
    sanitize(&mut note);
    println!("note={note:?}, words={}", word_count(&note));
}
```

## Worked Example: Split Borrow Scopes

```rust
fn main() {
    let mut scores = vec![10, 20, 30];
    {
        let first = &scores[0];
        println!("first={first}");
    } // shared borrow ends
    scores.push(40);
    println!("{scores:?}");
}
```

Non-lexical lifetimes often end borrows at last use without an explicit block—but explicit blocks help readability when things get tight.

## Hands-On Practice

1. Write `fn push_line(buf: &mut String, line: &str)` that appends `line` and a newline.
2. Write `fn contains_todo(lines: &[String]) -> bool` scanning for `"TODO"`.
3. Implement `fn grow(v: &mut Vec<i32>)` that pushes `v.len() as i32`.
4. Trigger a simultaneous `&` and `&mut` error on purpose; fix by splitting scopes.
5. Change a function from taking `String` to taking `&str` and update call sites.
6. Return a subslice from a function (`&str` from `&str`) and print both original and slice.

```rust
fn push_line(buf: &mut String, line: &str) {
    buf.push_str(line);
    buf.push('\n');
}

fn contains_todo(lines: &[String]) -> bool {
    lines.iter().any(|l| l.contains("TODO"))
}

fn main() {
    let mut buf = String::new();
    push_line(&mut buf, "first");
    push_line(&mut buf, "TODO: later");
    let lines: Vec<String> = buf.lines().map(|s| s.to_string()).collect();
    println!("buf:\n{buf}");
    println!("has todo? {}", contains_todo(&lines));
}
```

## Common Mistakes

- **Holding a reference while trying to mutate the owner**.
- **Taking `&String` instead of `&str`** in public APIs (less flexible).
- **Trying to return references to locals**.
- **Assuming Java/C# reference semantics** — Rust references are temporary borrows with compile-time rules, not GC handles.
- **Fighting NLL** with clones — first try restructuring scopes and API shapes.

## Chapter Summary

**Borrowing** lets you use data without owning it. Shared references (`&T`) allow many readers; mutable references (`&mut T`) allow one writer. The borrow checker enforces **shared XOR mutable** and **no dangling refs**. Prefer `&str` and slices in APIs. Next: **strings and slices** in depth—UTF-8, ownership of text, and safe views into buffers.
