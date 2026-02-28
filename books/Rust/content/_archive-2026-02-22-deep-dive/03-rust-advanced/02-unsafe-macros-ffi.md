# Unsafe Rust, Macros, and FFI

## Rule: Keep Unsafe Small

Use `unsafe` only when necessary, and hide it behind safe APIs.

```rust
pub fn first_byte(s: &str) -> Option<u8> {
    if s.is_empty() {
        return None;
    }
    let ptr = s.as_ptr();
    // SAFETY: checked non-empty string, pointer valid for first byte.
    Some(unsafe { *ptr })
}
```

## Declarative Macro Example

```rust
macro_rules! kv {
    ($k:expr => $v:expr) => {{
        let mut m = std::collections::HashMap::new();
        m.insert($k, $v);
        m
    }};
}
```

## FFI Basics

```rust
#[link(name = "m")]
extern "C" {
    fn sqrt(x: f64) -> f64;
}

fn main() {
    let x = 16.0;
    let out = unsafe { sqrt(x) };
    println!("{out}");
}
```

## FFI Safety Checklist

- Define `repr(C)` for shared structs.
- Validate null pointers.
- Avoid panics across FFI boundaries.
- Document ownership transfer rules.

## Practice

1. Wrap one unsafe call in a safe function.
2. Create a tiny macro to reduce repetitive code.
3. Call one C function and validate inputs.

## Deep Dive: Unsafe Abstraction Pattern

Template:

1. validate preconditions in safe code
2. execute minimal unsafe operation
3. return safe type
4. document safety invariants

```rust
pub fn get_unchecked_safe(v: &[u8], idx: usize) -> Option<u8> {
    if idx >= v.len() {
        return None;
    }
    // SAFETY: idx bounds checked above.
    Some(unsafe { *v.get_unchecked(idx) })
}
```

## Macro Hygiene Tip

Prefer fully qualified paths inside macros for predictable expansion.

## FFI Struct Interop Example

```rust
#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct CPoint {
    pub x: i32,
    pub y: i32,
}
```

`repr(C)` is necessary when C reads/writes this struct.

## FFI Error Strategy

- Avoid panics crossing FFI boundary.
- Return error codes or nullable pointers.
- Provide explicit destroy/free function for owned resources.

## Review Questions

1. Why keep unsafe blocks tiny?
2. What can break if `repr(C)` is missing?
3. Why should ownership be explicit in C interop APIs?
