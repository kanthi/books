# Strings and Slices

## Learning Goals

- Distinguish `String`, `&str`, and string literals.
- Understand Rust strings as **UTF-8** and why byte indexing is restricted.
- Build, modify, concatenate, and slice strings safely.
- Use common APIs: `push`, `push_str`, `format!`, `split`, `lines`, `trim`, `contains`.
- Apply ownership/borrowing correctly with text-processing helpers.

## Two Main String Types

| Type | Owns data? | Description |
|------|------------|-------------|
| `String` | Yes | Growable, heap-allocated UTF-8 buffer |
| `&str` | No | Borrowed string slice (view into UTF-8) |

```rust
fn main() {
    let literal: &str = "hello"; // stored in binary, borrowed
    let owned: String = String::from("hello");
    let also_owned = "hello".to_string();
    let view: &str = &owned;
    println!("{literal} {owned} {also_owned} {view}");
}
```

### Prefer `&str` in function parameters

```rust
fn shout(s: &str) -> String {
    s.to_uppercase()
}

fn main() {
    println!("{}", shout("hi"));
    println!("{}", shout(&String::from("hi")));
}
```

Prefer `String` as a **return type** when you create new text, or as a field when the struct owns the text.

## Creating Strings

```rust
fn main() {
    let mut a = String::new();
    a.push_str("Hello");

    let b = String::from("Hello");
    let c = "Hello".to_owned();
    let d = format!("Hello, {}!", "Rust");
    println!("{a} {b} {c} {d}");
}
```

## Updating Strings

```rust
fn main() {
    let mut s = String::from("Hello");
    s.push(' ');       // single char
    s.push_str("Rust"); // string slice
    s += "!";          // sugar for append (moves left String)
    println!("{s}");
}
```

### Concatenation ownership

```rust
fn main() {
    let s1 = String::from("Hello, ");
    let s2 = String::from("world!");
    let s3 = s1 + &s2; // s1 moved, s2 borrowed
    // println!("{s1}"); // error
    println!("{s3} (s2 still: {s2})");
}
```

`format!` borrows all inputs and allocates a new `String`—often clearer:

```rust
fn main() {
    let s1 = String::from("Hello");
    let s2 = String::from("world");
    let s3 = format!("{s1}, {s2}!");
    println!("{s3}; still have {s1} and {s2}");
}
```

## UTF-8 Reality

Rust `str` is valid UTF-8. A **Unicode scalar value** (`char`) can be multiple bytes. Indexing with `s[0]` is **not allowed** for `String`/`str` because it is ambiguous (bytes vs chars).

```rust
fn main() {
    let s = String::from("नमस्ते");
    println!("bytes={}", s.len());
    println!("chars={}", s.chars().count());
    for (i, c) in s.chars().enumerate() {
        println!("{i}: {c}");
    }
    for b in s.bytes().take(6) {
        println!("byte {b}");
    }
}
```

### Safe slicing

Slices must lie on **char boundaries**:

```rust
fn main() {
    let s = "hello";
    let h = &s[0..1]; // ok: ASCII
    println!("{h}");

    let hi = "안녕";
    // let bad = &hi[0..1]; // panic: not a char boundary
    let first = hi.chars().next();
    println!("{first:?}");
}
```

Prefer iterators over hard-coded byte indices for user-facing text.

## Common Slice Patterns

```rust
fn main() {
    let text = String::from("cargo build --release");
    let first = first_word(&text);
    println!("first word = {first}");
}

fn first_word(s: &str) -> &str {
    match s.find(char::is_whitespace) {
        Some(i) => &s[..i],
        None => s,
    }
}
```

Range forms:

```rust
fn main() {
    let s = "abcdefgh";
    println!("{}", &s[2..5]); // cde
    println!("{}", &s[..3]);  // abc
    println!("{}", &s[3..]);  // defgh
    println!("{}", &s[..]);   // full
}
```

## Searching and Splitting

```rust
fn main() {
    let log = "INFO start\nWARN disk\nINFO done\n";
    for line in log.lines() {
        if line.starts_with("WARN") {
            println!("warning line: {line}");
        }
    }

    let path = "books/Rust/content/01-rust-basics";
    let parts: Vec<&str> = path.split('/').collect();
    println!("{parts:?}");

    let csv = "ada,grace,linus";
    for name in csv.split(',') {
        println!("name={}", name.trim());
    }
}
```

### Collecting owned pieces

```rust
fn main() {
    let line = "alpha beta gamma";
    let words: Vec<String> = line.split_whitespace().map(|w| w.to_string()).collect();
    println!("{words:?}");
}
```

If you only need views into `line`, collect `Vec<&str>` instead—cheaper, tied to `line`’s lifetime.

## Trimming and Case

```rust
fn main() {
    let raw = "  Hello Rust\n";
    println!("{:?}", raw.trim());
    println!("{}", raw.to_lowercase());
    println!("{}", raw.to_uppercase());
    println!("{}", raw.contains("Rust"));
    println!("{}", raw.replace("Rust", "World").trim());
}
```

## Bytes, `OsString`, and Paths (Awareness)

- For UTF-8 text: `String` / `&str`.
- For platform paths: `std::path::Path` / `PathBuf` (not always UTF-8 on every OS).
- For OS strings: `OsString` / `&OsStr`.

```rust
use std::path::Path;

fn main() {
    let p = Path::new("content/01-rust-basics/09-strings-and-slices.md");
    println!("file={:?}", p.file_name());
    println!("ext={:?}", p.extension());
}
```

## Ownership Patterns for Text APIs

```rust
// Good: borrow input, own output when creating new data
fn slugify(input: &str) -> String {
    input
        .trim()
        .to_lowercase()
        .chars()
        .map(|c| if c.is_ascii_alphanumeric() { c } else { '-' })
        .collect()
}

// Good: mutate buffer you already own
fn append_timestamp(buf: &mut String, ts: &str) {
    if !buf.is_empty() {
        buf.push(' ');
    }
    buf.push_str(ts);
}

fn main() {
    println!("{}", slugify(" Hello, Rust! "));
    let mut note = String::from("deploy");
    append_timestamp(&mut note, "2026-08-04");
    println!("{note}");
}
```

## Worked Example: Notes Line Parser

```rust
#[derive(Debug, PartialEq)]
struct NoteLine {
    id: u32,
    text: String,
}

fn parse_note_line(line: &str) -> Option<NoteLine> {
    let line = line.trim();
    if line.is_empty() || line.starts_with('#') {
        return None;
    }
    let (id_str, text) = line.split_once('|')?;
    let id: u32 = id_str.trim().parse().ok()?;
    let text = text.trim().to_string();
    if text.is_empty() {
        return None;
    }
    Some(NoteLine { id, text })
}

fn main() {
    let file = "\
# id|text
1|buy milk
2|learn rust slices
badline
3|
";
    let notes: Vec<NoteLine> = file.lines().filter_map(parse_note_line).collect();
    println!("{notes:#?}");
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses() {
        let n = parse_note_line("10|hello").unwrap();
        assert_eq!(n, NoteLine { id: 10, text: "hello".into() });
    }

    #[test]
    fn skips_comments() {
        assert_eq!(parse_note_line("# x"), None);
    }
}
```

## Capacity vs Length

```rust
fn main() {
    let mut s = String::with_capacity(16);
    println!("len={} cap={}", s.len(), s.capacity());
    s.push_str("abcdefghijklmnop");
    println!("len={} cap={}", s.len(), s.capacity());
    s.push('!');
    println!("after grow len={} cap={}", s.len(), s.capacity());
}
```

`len()` is bytes, not chars.

## Hands-On Practice

1. Write `fn count_words(s: &str) -> usize`.
2. Write `fn reverse_words(s: &str) -> String` reversing word order, not characters.
3. Parse `"name=ada;role=admin"` into a small list of `(key, value)` pairs (`&str` or `String`).
4. Implement a function that safely takes the first `n` **chars** (not bytes) of a string.
5. Build a multi-line report with `format!` and `push_str` without unnecessary clones of inputs.
6. Add tests for empty string, only spaces, and Unicode text.

```rust
fn count_words(s: &str) -> usize {
    s.split_whitespace().count()
}

fn reverse_words(s: &str) -> String {
    let words: Vec<&str> = s.split_whitespace().collect();
    words.into_iter().rev().collect::<Vec<_>>().join(" ")
}

fn first_n_chars(s: &str, n: usize) -> String {
    s.chars().take(n).collect()
}

fn main() {
    let s = "learn rust strings today";
    println!("words={}", count_words(s));
    println!("{}", reverse_words(s));
    println!("{}", first_n_chars("🦀rust", 2));
}
```

## Common Mistakes

- **Indexing strings with `s[i]`** like in other languages.
- **Slicing mid-codepoint** → runtime panic.
- **Taking `String` parameters** when `&str` would do.
- **Confusing byte length with character count**.
- **`+` concatenation chains** that obscure moves—prefer `format!` or `push_str` loops.
- **Storing `&str` in structs** without lifetime discipline—start with owned `String` fields.

## Chapter Summary

Rust text is **UTF-8**: own it with `String`, borrow it with `&str`. Build with `push_str`/`format!`, iterate with `chars`/`split`/`lines`, and slice only on char boundaries. Design APIs that borrow inputs and own outputs when creating new text. Next: **collections**—`Vec`, `HashMap`, and iterator fundamentals.
