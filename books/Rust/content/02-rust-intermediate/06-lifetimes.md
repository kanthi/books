# Lifetimes

## Learning Goals

- Explain lifetimes as **regions of validity** for references, not a runtime cost.
- Read and write simple lifetime annotations on functions and structs.
- Use lifetime elision rules confidently.
- Distinguish `'static` from “lives forever in practice.”
- Fix common lifetime errors without panicking into unnecessary clones—though clones remain a valid tool.

## Lifetimes Exist Whether You Write Them or Not

Every reference has a lifetime. Annotations are needed when the compiler cannot infer relationships between borrows.

```rust
// Compiles — elision knows output borrow comes from input
fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or("")
}

fn main() {
    let s = String::from("hello rust");
    let w = first_word(&s);
    println!("{w}");
}
```

## The Classic Problem

```rust
// fn longest(x: &str, y: &str) -> &str {
//     if x.len() > y.len() { x } else { y }
// }
```

Without annotations, Rust cannot know whether the returned reference borrows `x` or `y`. Explicitly:

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() >= y.len() {
        x
    } else {
        y
    }
}

fn main() {
    let a = String::from("abcd");
    let b = String::from("xyz");
    println!("{}", longest(&a, &b));
}
```

Meaning: there is a lifetime `'a` that is a **common** lifetime of the two inputs; the output is valid for that same region (the intersection of the two borrows).

### Scope illustration

```rust
fn main() {
    let s1 = String::from("long string is long");
    {
        let s2 = String::from("xyz");
        let result = longest(&s1, &s2);
        println!("longest is {result}");
    } // s2 ends — result must not be used past here
}
```

If you tried to use `result` after `s2` dies while it might point at `s2`, that is exactly what lifetimes prevent.

## Lifetime Annotations Are Not About Duration Alone

They describe **relationships**: how output borrows connect to input borrows.

```rust
// Output only depends on `primary`
fn pick<'a>(primary: &'a str, _secondary: &str) -> &'a str {
    primary
}

fn main() {
    let a = String::from("keep");
    let r;
    {
        let b = String::from("temp");
        r = pick(&a, &b);
    }
    println!("{r}"); // ok — tied to `a`, not `b`
}
```

## Elision Rules (Practical)

The compiler applies elision so many signatures need no annotations:

1. Each elided input reference gets its own lifetime parameter.
2. If there is exactly one input lifetime, it is assigned to all elided output lifetimes.
3. If there are multiple input lifetimes but one is `&self` / `&mut self`, `self`’s lifetime is assigned to outputs.

```rust
// elided
fn f(s: &str) -> &str {
    s
}

// expanded
fn f_exp<'a>(s: &'a str) -> &'a str {
    s
}

struct Holder<'a> {
    s: &'a str,
}

impl<'a> Holder<'a> {
    // elision: output tied to &self
    fn get(&self) -> &str {
        self.s
    }
}

fn main() {
    let owned = String::from("x");
    println!("{}", f(&owned));
    let h = Holder { s: &owned };
    println!("{}", h.get());
}
```

## Structs That Hold References

If a struct stores a reference, it needs a lifetime parameter:

```rust
struct Excerpt<'a> {
    part: &'a str,
}

fn main() {
    let novel = String::from("Call me Ishmael. Some years ago...");
    let first = novel.split('.').next().unwrap();
    let e = Excerpt { part: first };
    println!("{}", e.part);
}
```

The struct cannot outlive the data it borrows.

```rust
// This will not compile:
// let e;
// {
//     let novel = String::from("...");
//     e = Excerpt { part: novel.as_str() };
// }
// println!("{}", e.part);
```

**Design tip:** Prefer owned `String` fields in long-lived structs unless you are deliberately building zero-copy views.

## Methods with Lifetimes

```rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}

impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }

    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention: {announcement}");
        self.part
    }
}

fn main() {
    let song = String::from("What a wonderful world");
    let ex = ImportantExcerpt {
        part: song.split(' ').next().unwrap(),
    };
    println!("{} level={}", ex.announce_and_return_part("now"), ex.level());
}
```

## `'static`

`'static` means the reference can live for the entire program duration.

```rust
fn main() {
    let s: &'static str = "I live in the binary";
    println!("{s}");
}
```

String literals are `'static`. Owned data on the heap is **not** `'static` just because it is long-lived—unless you leak it or store it in a true static.

Common confusion: error messages suggesting `'static` often mean “this value does not live long enough in the current design,” not “you should slap `'static` on everything.”

```rust
fn need_static(s: &'static str) {
    println!("{s}");
}

fn main() {
    need_static("ok");
    let owned = String::from("nope");
    // need_static(&owned); // error
    need_static(Box::leak(owned.into_boxed_str())); // works but leaks — avoid
}
```

## Lifetime Bounds

```rust
use std::fmt::Display;

fn longest_with_announcement<'a, T>(x: &'a str, y: &'a str, ann: T) -> &'a str
where
    T: Display,
{
    println!("Announcement! {ann}");
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

fn main() {
    println!(
        "{}",
        longest_with_announcement("ab", "xyz", "comparing")
    );
}
```

## Multiple Lifetime Parameters

```rust
fn zip_str<'a, 'b>(a: &'a str, b: &'b str) -> (&'a str, &'b str) {
    (a, b)
}

fn main() {
    let s = String::from("one");
    let t = String::from("two");
    let (x, y) = zip_str(&s, &t);
    println!("{x} {y}");
}
```

When relationships differ, use distinct lifetimes.

## When to Clone Instead

Lifetimes are not a purity test. Sometimes owning is simpler and correct:

```rust
fn longest_owned(x: &str, y: &str) -> String {
    if x.len() >= y.len() {
        x.to_string()
    } else {
        y.to_string()
    }
}

fn main() {
    let a = String::from("a");
    let result;
    {
        let b = String::from("bbb");
        result = longest_owned(&a, &b);
    }
    println!("{result}"); // free of borrow ties
}
```

Choose owned returns when zero-copy is not required.

## Common Compiler Messages (Decoded)

| Message idea | Likely fix |
|--------------|------------|
| missing lifetime specifier | Annotate relationships or return owned data |
| does not live long enough | Scope the borrow narrower or extend owner |
| cannot return reference to local | Return `String`/`Vec`/owned type |
| conflicting requirements | Restructure so one clear borrow source exists |

## Worked Example: Zero-Copy Line View

```rust
#[derive(Debug)]
struct LineView<'a> {
    number: usize,
    text: &'a str,
}

fn numbered_lines<'a>(body: &'a str) -> Vec<LineView<'a>> {
    body.lines()
        .enumerate()
        .map(|(i, text)| LineView {
            number: i + 1,
            text,
        })
        .collect()
}

fn main() {
    let file = "first\nsecond\nthird";
    let lines = numbered_lines(file);
    for l in &lines {
        println!("{:>4}: {}", l.number, l.text);
    }
}
```

All views share the lifetime of `file`.

## Worked Example: Struct Mixing Owned + Borrowed

```rust
struct SearchHit<'a> {
    query: String,   // owned
    snippet: &'a str, // borrowed from haystack
}

fn find_hit<'a>(haystack: &'a str, query: &str) -> Option<SearchHit<'a>> {
    let idx = haystack.find(query)?;
    let snippet = &haystack[idx..idx + query.len()];
    Some(SearchHit {
        query: query.to_string(),
        snippet,
    })
}

fn main() {
    let data = String::from("learn rust lifetimes today");
    if let Some(hit) = find_hit(&data, "rust") {
        println!("found {} at snippet {}", hit.query, hit.snippet);
    }
}
```

## Hands-On Practice

1. Implement `fn shortest<'a>(x: &'a str, y: &'a str) -> &'a str`.
2. Create `struct Config<'a> { name: &'a str, path: &'a str }` and a printer method.
3. Write a function that **fails** with a lifetime error when returning a local `String` as `&str`; fix by returning `String`.
4. Parse first CSV field zero-copy: `fn first_field(line: &str) -> &str`.
5. Change a domain struct from `name: &str` to `name: String` and delete lifetime params—compare complexity.
6. Explain in your notes why `longest` needs one shared lifetime for both inputs when either can be returned.

```rust
fn first_field(line: &str) -> &str {
    line.split(',').next().unwrap_or("").trim()
}

fn shortest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() <= y.len() {
        x
    } else {
        y
    }
}

fn main() {
    println!("{:?}", first_field("  ada, admin "));
    println!("{}", shortest("hi", "hello"));
}
```

## Common Mistakes

- **Sprinkling `'static`** to silence errors incorrectly.
- **Overusing references in structs** leading to viral lifetime parameters.
- **Fighting the checker with raw pointers** — not the Intermediate path.
- **Assuming lifetimes change runtime** — they are compile-time only.
- **Cloning everything forever** — learn both borrow-based and owned APIs.

## Chapter Summary

Lifetimes name **how long references are valid** and how outputs relate to inputs. Elision covers many cases; annotations document the rest. Prefer **owned data** in storage types when simplicity wins; use borrowed views for zero-copy parsing. Next: **testing**—locking behavior with `cargo test`.
