# FFI with C

## Learning Goals

- Call C functions from Rust and expose Rust functions to C with a stable ABI.
- Use `repr(C)`, opaque pointers, and explicit ownership transfer rules.
- Handle null pointers, strings (`CString` / `CStr`), and error codes safely.
- Avoid panics unwinding across the FFI boundary.
- Know when to use `bindgen` / `cbindgen` vs hand-written bindings.
- Keep unsafe isolated behind a small safe Rust module.

## Concept Diagram

```mermaid
flowchart LR
    RustSafe[Safe Rust API] --> RustUnsafe[unsafe FFI layer]
    RustUnsafe -->|extern C| CLib[C library]
    CApp[C application] -->|extern C| RustCdylib[Rust cdylib]
    RustCdylib --> RustSafe
```

Foreign Function Interface (FFI) connects Rust to C’s ABI—the lingua franca of OS libraries and many legacy systems.

## Calling C from Rust

### Link and declare

```rust
use std::os::raw::c_int;

#[link(name = "m")] // libm on Unix; adjust per platform
extern "C" {
    fn abs(input: c_int) -> c_int;
    fn sqrt(x: f64) -> f64;
}

fn main() {
    unsafe {
        println!("abs(-3) = {}", abs(-3));
        println!("sqrt(9) = {}", sqrt(9.0));
    }
}
```

```bash
# On macOS/Linux, libm is usually available.
cargo run
```

Prefer `std::os::raw` / `core::ffi` types (`c_int`, `c_char`, `c_void`) over guessing Rust types.

### Safer wrapper

```rust
use std::os::raw::c_int;

extern "C" {
    fn abs(input: c_int) -> c_int;
}

/// Safe wrapper: pure function, no pointers.
pub fn safe_abs(v: i32) -> i32 {
    // SAFETY: C `abs` is pure for all i32 inputs we pass as c_int.
    // Note: abs(i32::MIN) is a known C footgun on some platforms—document/guard.
    if v == i32::MIN {
        return i32::MIN; // or return Option / error
    }
    unsafe { abs(v as c_int) as i32 }
}

fn main() {
    assert_eq!(safe_abs(-5), 5);
}
```

## Strings Across the Boundary

C strings are null-terminated `*const c_char`. Rust `String`/`&str` are UTF-8 length-prefixed.

### Rust → C

```rust
use std::ffi::CString;
use std::os::raw::c_char;

extern "C" {
    // Example signature: int puts(const char *s);
    fn puts(s: *const c_char) -> i32;
}

fn print_c_line(s: &str) {
    let c = CString::new(s).expect("interior nul not allowed");
    unsafe {
        puts(c.as_ptr());
    }
}

fn main() {
    print_c_line("hello from rust");
}
```

`CString::new` fails if the Rust string contains interior `\0`.

### C → Rust

```rust
use std::ffi::CStr;
use std::os::raw::c_char;

/// # Safety
/// `ptr` must be a valid, non-null, NUL-terminated C string.
unsafe fn cstr_to_string(ptr: *const c_char) -> String {
    // SAFETY: caller guarantees pointer validity.
    unsafe { CStr::from_ptr(ptr) }.to_string_lossy().into_owned()
}
```

Safe boundary:

```rust
pub fn optional_cstr<'a>(ptr: *const std::os::raw::c_char) -> Option<&'a CStr> {
    if ptr.is_null() {
        None
    } else {
        // SAFETY: non-null; caller must ensure lifetime and validity.
        Some(unsafe { CStr::from_ptr(ptr) })
    }
}
```

## `repr(C)` Structs

Without `repr(C)`, Rust may reorder fields; C will see garbage.

```rust
#[repr(C)]
#[derive(Debug, Copy, Clone)]
pub struct Point {
    pub x: f64,
    pub y: f64,
}

extern "C" {
    // Hypothetical: double distance(Point a, Point b);
    // fn distance(a: Point, b: Point) -> f64;
}

fn main() {
    let p = Point { x: 1.0, y: 2.0 };
    println!("{p:?}");
}
```

Rules:

- Use `#[repr(C)]` for shared layouts.
- Prefer `Copy` POD types for by-value passing when appropriate.
- For complex objects, pass **opaque pointers**.

## Opaque Pointers and Ownership

```rust
// C header sketch:
// typedef struct database database;
// database *db_open(const char *path);
// void db_close(database *db);

#[repr(C)]
pub struct Database {
    _private: [u8; 0],
}

extern "C" {
    fn db_open(path: *const std::os::raw::c_char) -> *mut Database;
    fn db_close(db: *mut Database);
}

pub struct DbHandle {
    ptr: *mut Database,
}

impl DbHandle {
    pub fn open(path: &str) -> Option<Self> {
        let c = std::ffi::CString::new(path).ok()?;
        let ptr = unsafe { db_open(c.as_ptr()) };
        if ptr.is_null() {
            None
        } else {
            Some(Self { ptr })
        }
    }
}

impl Drop for DbHandle {
    fn drop(&mut self) {
        unsafe { db_close(self.ptr) }
    }
}

// SAFETY: Document whether Database ops are thread-safe before asserting Send/Sync.
// unsafe impl Send for DbHandle {}
```

Ownership checklist:

| Direction | Who allocates | Who frees |
|-----------|---------------|-----------|
| C creates, Rust uses | C | C free fn via Drop |
| Rust creates, C uses | Rust | exported free from Rust |
| Borrowed | neither transfers | lifetime must not dangle |

Never free with the wrong allocator (Rust `Vec` vs C `malloc`).

## Exporting Rust to C (`cdylib`)

```toml
# Cargo.toml
[lib]
crate-type = ["cdylib", "rlib"]

[dependencies]
# ...
```

```rust
// src/lib.rs
use std::ffi::{CStr, CString};
use std::os::raw::c_char;

#[no_mangle]
pub extern "C" fn rust_add(a: i32, b: i32) -> i32 {
    a + b
}

/// Returns a newly allocated C string. Caller must free with `rust_string_free`.
#[no_mangle]
pub extern "C" fn rust_hello(name: *const c_char) -> *mut c_char {
    let name = if name.is_null() {
        "world"
    } else {
        match unsafe { CStr::from_ptr(name) }.to_str() {
            Ok(s) => s,
            Err(_) => return std::ptr::null_mut(),
        }
    };
    let s = CString::new(format!("hello, {name}")).unwrap_or_default();
    s.into_raw()
}

#[no_mangle]
pub extern "C" fn rust_string_free(s: *mut c_char) {
    if s.is_null() {
        return;
    }
    unsafe {
        drop(CString::from_raw(s));
    }
}
```

C header (hand-written or `cbindgen`):

```c
#include <stdint.h>

int32_t rust_add(int32_t a, int32_t b);
char *rust_hello(const char *name);
void rust_string_free(char *s);
```

```bash
cargo build --release
# link against target/release/libyourcrate.so / .dylib / .dll
```

## Panic Safety Across FFI

**Do not** let Rust panics unwind into C.

```rust
use std::panic::{catch_unwind, AssertUnwindSafe};

#[no_mangle]
pub extern "C" fn may_panic(x: i32) -> i32 {
    let result = catch_unwind(AssertUnwindSafe(|| {
        if x < 0 {
            panic!("neg");
        }
        x + 1
    }));
    match result {
        Ok(v) => v,
        Err(_) => -1, // error code for C
    }
}
```

Patterns:

- Return error codes / null
- Write errors into out-parameters
- Abort on bug (`panic = abort` in release for some cdylibs)

## Callbacks from C into Rust

```rust
type Callback = extern "C" fn(i32);

#[no_mangle]
pub extern "C" fn call_me_twice(cb: Option<Callback>) {
    if let Some(cb) = cb {
        cb(1);
        cb(2);
    }
}
```

If the callback needs user data:

```rust
type Cb = extern "C" fn(*mut std::ffi::c_void, i32);

#[no_mangle]
pub extern "C" fn with_userdata(user: *mut std::ffi::c_void, cb: Option<Cb>) {
    if let Some(cb) = cb {
        cb(user, 42);
    }
}
```

Lifetime must ensure `user` is valid for the callback duration.

## bindgen and cbindgen

```bash
# Generate Rust bindings from C headers
cargo install bindgen-cli
bindgen wrapper.h -o src/bindings.rs

# Generate C headers from Rust
cargo install cbindgen
cbindgen --crate your_crate --output include/your_crate.h
```

Workflow:

1. Vendor or system headers → `bindgen` → raw `extern` module  
2. Write a thin safe Rust API on top  
3. For libraries consumed by C/C++, export a small C API + `cbindgen`

## Error Model Design

```rust
#[repr(C)]
pub enum Status {
    Ok = 0,
    NullArg = 1,
    Utf8Error = 2,
    Internal = 3,
}

#[no_mangle]
pub extern "C" fn parse_u64(s: *const std::os::raw::c_char, out: *mut u64) -> Status {
    if s.is_null() || out.is_null() {
        return Status::NullArg;
    }
    let cstr = unsafe { std::ffi::CStr::from_ptr(s) };
    let Ok(text) = cstr.to_str() else {
        return Status::Utf8Error;
    };
    match text.parse::<u64>() {
        Ok(v) => {
            unsafe { *out = v };
            Status::Ok
        }
        Err(_) => Status::Internal,
    }
}
```

## Platform Notes (mid-2026 practice)

- Prefer `core::ffi` types in `no_std` + alloc contexts.
- Windows: `extern "C"` vs `extern "system"` (stdcall/win64 nuances).
- Dynamic loading: `libloading` crate for plugins.
- Always test both 64-bit layouts and alignment with C (`static_assert` on C side).

## Minimal End-to-End Lab Layout

```text
ffi-lab/
  Cargo.toml          # cdylib
  src/lib.rs          # exported API
  c/main.c            # caller
  c/Makefile
```

```c
// c/main.c
#include <stdio.h>
#include <stdint.h>

int32_t rust_add(int32_t a, int32_t b);

int main(void) {
    printf("%d\n", rust_add(40, 2));
    return 0;
}
```

```bash
cargo build --release
cc c/main.c -L target/release -lyourcrate -o demo
# Linux may need: -Wl,-rpath,$PWD/target/release
./demo
```

## Hands-On Practice

1. Wrap `libm` `sqrt` in a safe function with domain checks (`x >= 0`).
2. Pass a Rust string to `puts` via `CString`.
3. Build a `cdylib` exporting `rust_add` and call it from a tiny C program.
4. Implement `rust_hello` / `rust_string_free` ownership pair; verify no leaks with ASan or careful testing.
5. Add `catch_unwind` on an exported function that can panic.
6. Define a `#[repr(C)]` struct shared with a C file; print sizes from both sides (`sizeof` vs `size_of`).
7. Run `bindgen` on a simple header (or hand-write equivalent) and wrap it safely.
8. Document safety contracts in a short module-level rustdoc comment.

## Common Mistakes

- Missing `#[repr(C)]` on shared structs.
- Assuming Rust `String` layout matches C.
- Freeing C memory with Rust deallocator or vice versa.
- Ignoring null.
- Allowing panics to cross FFI.
- Returning pointers to Rust stack values.
- Claiming `Send` on handles to non-thread-safe C libs.
- Interior NUL in strings passed to `CString::new` without handling `Err`.

## Review Questions

1. Why is `extern "C"` required for ABI compatibility?
2. Who should free a string returned as `*mut c_char` from Rust?
3. What does `#[no_mangle]` do?
4. How do you stop panics from unwinding into C?
5. When are opaque pointers better than shared `repr(C)` structs?

## Chapter Summary

FFI is a **contract**: layout, ownership, threading, and error handling must be explicit. Keep `unsafe` at the edge, prefer safe wrappers, use `repr(C)` and opaque handles wisely, and never let panics or mismatched allocators cross the boundary. Next: **performance basics**—measuring before you reach for unsafe or FFI micro-optimizations.
