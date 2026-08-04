# Data Types

## Learning Goals

- Use Rust’s scalar types: integers, floats, `bool`, `char`.
- Work with compound types: tuples, arrays, and a first look at slices.
- Understand type inference, annotations, and when casting is needed.
- Know the difference between fixed-size arrays and growable `Vec` (preview).
- Avoid common pitfalls: overflow, integer division, Unicode vs bytes.

## Static Typing and Inference

Rust is **statically typed**: every value has a type known at compile time. You often omit annotations because the compiler **infers** types from usage.

```rust
fn main() {
    let x = 42;        // i32 by default for integers
    let y = 2.5;       // f64 by default for floats
    let ok = true;     // bool
    let heart = '❤';    // char (Unicode scalar)
    println!("{x} {y} {ok} {heart}");
}
```

When inference cannot decide, annotate or use turbofish:

```rust
fn main() {
    let n: u32 = "10".parse().expect("num");
    let m = "10".parse::<u32>().expect("num");
    println!("{n} {m}");
}
```

## Integer Types

| Length | Signed | Unsigned |
|--------|--------|----------|
| 8-bit  | `i8`   | `u8`     |
| 16-bit | `i16`  | `u16`    |
| 32-bit | `i32`  | `u32`    |
| 64-bit | `i64`  | `u64`    |
| 128-bit| `i128` | `u128`   |
| arch   | `isize`| `usize`  |

- Default integer inference: **`i32`**.
- **`usize`/`isize`** match pointer width (32 or 64 bit). Indexing uses `usize`.

```rust
fn main() {
    let a: i32 = -3;
    let b: u8 = 255;
    let idx: usize = 0;
    let big: u64 = 1_000_000;
    println!("a={a} b={b} idx={idx} big={big}");
}
```

### Integer literals

```rust
fn main() {
    let dec = 98_222;
    let hex = 0xff;
    let oct = 0o77;
    let bin = 0b1111_0000;
    let byte = b'A'; // u8
    println!("{dec} {hex} {oct} {bin} {byte}");
}
```

### Overflow behavior

- **Debug builds:** overflow panics for arithmetic on integers in many cases.
- **Release builds:** two’s complement wrapping by default for `+`/`-`/`*` (still prefer explicit APIs).

Prefer explicit methods when overflow matters:

```rust
fn main() {
    let x: u8 = 255;
    let wrapped = x.wrapping_add(1); // 0
    let checked = x.checked_add(1);  // None
    let saturating = x.saturating_add(1); // 255
    let (sum, overflowed) = x.overflowing_add(1);
    println!("{wrapped} {checked:?} {saturating} {sum} {overflowed}");
}
```

## Floating Point

| Type | Notes |
|------|--------|
| `f32` | Single precision |
| `f64` | Double precision (**default**) |

```rust
fn main() {
    let x = 2.0;      // f64
    let y: f32 = 3.0;
    println!("{} {}", x.sqrt(), y * 2.0);
}
```

Never use raw binary floats for currency; use integers of minor units or a decimal crate later.

## Booleans and Characters

```rust
fn main() {
    let t = true;
    let f: bool = false;
    let c = 'z';
    let z = 'ℤ';
    let emoji = '🦀';
    println!("{t} {f} {c} {z} {emoji}");
}
```

- `bool` is not an integer; use explicit comparisons.
- `char` is 4 bytes and represents a Unicode scalar value—not a single “grapheme cluster” always as users think of characters.

## Tuples

Tuples group values of possibly different types. Fixed length.

```rust
fn main() {
    let tup: (i32, f64, char) = (500, 6.4, 'x');
    let (a, b, c) = tup; // destructure
    println!("{a} {b} {c}");
    println!("first = {}", tup.0);
}
```

Unit type `()` is the empty tuple—default return type of functions that return nothing meaningful.

```rust
fn log_hi() {
    println!("hi");
} // returns ()

fn main() {
    let r = log_hi();
    println!("r = {r:?}");
}
```

## Arrays

Arrays have **fixed length** known at compile time and homogeneous element type. Stored inline (on the stack when local).

```rust
fn main() {
    let a = [1, 2, 3, 4, 5];
    let b: [i32; 5] = [1, 2, 3, 4, 5];
    let zeros = [0; 3]; // [0, 0, 0]
    println!("{:?} {:?} {:?}", a, b, zeros);
    println!("len = {}, first = {}", a.len(), a[0]);
}
```

Out-of-bounds indexing **panics** at runtime (safe Rust):

```rust
fn main() {
    let a = [10, 20, 30];
    // let x = a[99]; // panic
    if let Some(x) = a.get(1) {
        println!("safe get: {x}");
    }
}
```

## Slices (Preview)

A **slice** is a view into a contiguous sequence: type `&[T]` (or `&mut [T]`). Arrays coerce to slices.

```rust
fn sum(xs: &[i32]) -> i32 {
    xs.iter().sum()
}

fn main() {
    let a = [1, 2, 3, 4];
    println!("{}", sum(&a));
    println!("{}", sum(&a[1..3])); // 2 + 3
}
```

Slices are critically tied to **borrowing** (later chapters). They do not own the data.

## Type Casting with `as`

Rust does not implicitly widen/narrow numbers in all cases. Use `as` carefully:

```rust
fn main() {
    let x: i32 = 1000;
    let y = x as i16; // may truncate for large values
    let z = 3.9_f64 as i32; // truncates toward zero → 3
    println!("{y} {z}");
}
```

Prefer safe conversions:

```rust
fn main() {
    let x: i32 = 1000;
    let y = i16::try_from(x); // Result
    println!("{y:?}");

    let n: i32 = -1;
    let u = u32::try_from(n); // Err
    println!("{u:?}");
}
```

```rust
use std::convert::TryFrom;

fn main() {
    match u16::try_from(70_000i32) {
        Ok(v) => println!("fit: {v}"),
        Err(e) => println!("no fit: {e}"),
    }
}
```

## Integer Division and Remainders

```rust
fn main() {
    let q = 7 / 2;     // 3 (integer division)
    let r = 7 % 2;     // 1
    let f = 7.0 / 2.0; // 3.5
    println!("{q} {r} {f}");
}
```

## `String` vs `&str` (Type-Level Preview)

You will dedicate a chapter to strings. For type awareness:

| Type | Owns data? | Typical use |
|------|------------|-------------|
| `String` | Yes (heap) | Growable text you own |
| `&str` | No (borrow) | String slices / literals |

```rust
fn main() {
    let owned: String = String::from("hello");
    let slice: &str = &owned;
    let literal: &str = "world";
    println!("{owned} {slice} {literal}");
}
```

## Compound Example: Parsing a Point

```rust
fn parse_point(s: &str) -> Option<(i32, i32)> {
    let mut parts = s.split(',');
    let x = parts.next()?.trim().parse().ok()?;
    let y = parts.next()?.trim().parse().ok()?;
    if parts.next().is_some() {
        return None;
    }
    Some((x, y))
}

fn main() {
    let samples = ["10, 20", "bad", "1,2,3"];
    for s in samples {
        match parse_point(s) {
            Some((x, y)) => println!("{s:?} → ({x}, {y})"),
            None => println!("{s:?} → invalid"),
        }
    }
}
```

## Arrays vs `Vec` (When to Choose)

```rust
fn main() {
    let fixed: [i32; 3] = [1, 2, 3];
    let mut growable = vec![1, 2, 3];
    growable.push(4);
    println!("{:?} {:?}", fixed, growable);
}
```

- Use **arrays** for fixed small buffers, compile-time sizes, stack-friendly data.
- Use **`Vec<T>`** for runtime length (collections chapter).

## Numeric Methods You Will Use Constantly

```rust
fn main() {
    let x = -5_i32;
    println!("abs={} pow={}", x.abs(), 2_i32.pow(10));
    println!("max={}", 3.max(9));
    let v = 16u32;
    println!("is_power_of_two={}", v.is_power_of_two());
}
```

## Hands-On Practice

1. Print min/max for `i8` and `u8` using `i8::MIN`, `i8::MAX`, etc.
2. Write `fn average(xs: &[f64]) -> Option<f64>` returning `None` on empty input.
3. Convert a list of Celsius temps stored as `[f64; 5]` to Fahrenheit into a new array (or `Vec`).
4. Use `checked_add` to safely add two `u8` values from “user input” strings.
5. Destructure a tuple `(name, age, active)` and print a sentence.
6. Intentionally index an array out of bounds once to see the panic message; then rewrite with `.get()`.

```rust
fn average(xs: &[f64]) -> Option<f64> {
    if xs.is_empty() {
        return None;
    }
    let sum: f64 = xs.iter().sum();
    Some(sum / xs.len() as f64)
}

fn main() {
    let temps = [20.0, 22.5, 19.0];
    println!("{:?}", average(&temps));
    println!("{:?}", average(&[]));
}
```

## Common Mistakes

- **Assuming default integer is platform-sized** — default is `i32`, not `isize`.
- **Using floats for money**.
- **Silent truncation with `as`** on integers/floats.
- **Confusing `char` with UTF-8 bytes** — strings are UTF-8; indexing bytes ≠ indexing chars.
- **Expecting arrays to grow** — use `Vec`.
- **Integer division surprises** when you wanted floats.

## Chapter Summary

Rust’s type system covers **scalars** (integers, floats, bool, char) and **compounds** (tuples, arrays), with **slices** as borrowed views. Inference reduces noise; annotations resolve ambiguity. Prefer **checked conversions** over casual `as`. Next: **functions and expressions**—how you structure computation and return values.
