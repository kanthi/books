# Variables and Mutability

## Learning Goals

- Declare bindings with `let` and understand **immutability by default**.
- Use `mut` when reassignment or in-place mutation is required.
- Apply **shadowing** deliberately (new binding, possibly new type).
- Distinguish `const` and `static` from ordinary variables.
- See how mutability interacts with **ownership** and later borrowing rules.

## Immutability by Default

In Rust, `let` creates an immutable binding. You can read the value, but you cannot reassign it or mutate its contents through that binding (for types that would require mutation).

```rust
fn main() {
    let x = 5;
    println!("x = {x}");
    // x = 6; // error: cannot assign twice to immutable variable
}
```

Why default immutable?

1. **Easier reasoning** — values do not change under your feet.
2. **Safer concurrency** later — less shared mutable state.
3. **Clear intent** — mutation is marked with `mut` at the binding site.

This is a design choice, not a performance handicap. The compiler optimizes immutable and mutable code aggressively.

## `mut` for Mutation

Add `mut` when you need to reassign or mutate:

```rust
fn main() {
    let mut count = 0;
    count += 1;
    count = count + 2;
    println!("count = {count}");
}
```

Mutation of a structure’s fields also requires a mutable binding (or a mutable reference—later chapter):

```rust
fn main() {
    let mut point = (0, 0);
    point.0 = 10;
    point.1 = 20;
    println!("point = {point:?}");
}
```

### Reassignment vs interior mutation

- **Reassignment:** `x = new_value` replaces the binding’s value (old value dropped if owned).
- **Interior mutation:** changing fields inside a value, e.g. `v.push(1)` on a `Vec`.

Both need appropriate mutability:

```rust
fn main() {
    let mut scores = vec![10, 20];
    scores.push(30); // interior mutation
    scores = vec![1, 2, 3]; // reassignment
    println!("{scores:?}");
}
```

## Shadowing

**Shadowing** means declaring a new variable with the same name in the same scope (or an inner scope). The previous binding is hidden, not mutated.

```rust
fn main() {
    let x = 5;
    let x = x + 1; // shadow: new immutable binding
    let x = x * 2;
    println!("x = {x}"); // 12
}
```

Shadowing can **change type**, which `mut` reassignment cannot:

```rust
fn main() {
    let spaces = "   ";
    let spaces = spaces.len(); // &str → usize
    println!("spaces count = {spaces}");

    // This would fail:
    // let mut spaces = "   ";
    // spaces = spaces.len(); // type mismatch
}
```

### When to shadow vs `mut`

| Prefer | When |
|--------|------|
| Shadowing | Transforming a value through stages; type changes; keep each stage immutable |
| `mut` | Loop counters, builders, accumulating buffers, in-place updates |

```rust
fn main() {
    let input = "  42 ";
    let input = input.trim();
    let input: i32 = input.parse().expect("number");
    println!("parsed = {input}");
}
```

(You will replace `expect` with proper `Result` handling soon.)

## Scope and Drop (Ownership Tie-In)

Bindings live in **scopes**. When a scope ends, owned values are dropped.

```rust
fn main() {
    let outer = String::from("outer");
    {
        let inner = String::from("inner");
        println!("{outer} and {inner}");
    } // `inner` dropped here
    println!("{outer}");
} // `outer` dropped here
```

Immutability does not mean “lives forever.” It means “cannot change through this binding while it lives.”

## Constants: `const`

`const` items are always immutable, require a type, and must be a **constant expression** (compile-time known in the const-eval sense).

```rust
const MAX_POINTS: u32 = 100_000;
const APP_NAME: &str = "notes";

fn main() {
    println!("{APP_NAME} max = {MAX_POINTS}");
}
```

Rules of thumb:

- Use `const` for true constants (limits, names, fixed config baked into the binary).
- Naming convention: `SCREAMING_SNAKE_CASE`.
- `const` can appear in any scope, including inside functions.
- No `mut`, no runtime value that is only known later.

```rust
fn scale(n: i32) -> i32 {
    const FACTOR: i32 = 3;
    n * FACTOR
}

fn main() {
    println!("{}", scale(14));
}
```

## Statics: `static`

`static` items have a fixed address for the life of the program. Immutable statics are common for global data. **Mutable statics** exist but require `unsafe` to read/write—avoid them for now; prefer interior mutability patterns later (`Mutex`, etc.).

```rust
static VERSION: &str = "0.1.0";

fn main() {
    println!("version {VERSION}");
}
```

| Feature | `let` | `const` | `static` |
|---------|-------|---------|----------|
| Runtime init | Yes | No (const expr) | Limited / special |
| Address identity | Stack/temporary | Inlined / no fixed addr guarantee like static | Fixed |
| Mutation | with `mut` | Never | `static mut` + unsafe (avoid) |
| Typical use | Local state | Named constants | Global read-only data |

## Type Annotations

Rust infers many types, but you can annotate:

```rust
fn main() {
    let guess: i32 = "42".parse().expect("number");
    let count: usize = 10;
    let flag: bool = true;
    println!("{guess}, {count}, {flag}");
}
```

Annotations are required when inference cannot decide (e.g. `parse` without a target type).

```rust
fn main() {
    // let n = "42".parse().unwrap(); // error: type must be known
    let n = "42".parse::<i32>().unwrap();
    let m: i32 = "7".parse().unwrap();
    println!("{n}, {m}");
}
```

## Patterns in `let`

`let` can destructure:

```rust
fn main() {
    let (x, y) = (1, 2);
    let [a, b, c] = [10, 20, 30];
    println!("x={x} y={y} a={a} b={b} c={c}");
}
```

With `mut` on parts (advanced pattern forms appear later with enums):

```rust
fn main() {
    let (mut x, y) = (1, 2);
    x += y;
    println!("{x}");
}
```

## Unused Variables

If you bind a name you do not use, the compiler warns:

```rust
fn main() {
    let unused = 1; // warning
    let _ intentional = 2; // underscore prefix silences unused warnings
    let _ = compute(); // explicitly discard
}

fn compute() -> i32 {
    42
}
```

## Mutability and Functions (Preview of Ownership)

Passing a value **moves** ownership for non-`Copy` types. Mutability of the caller’s binding does not automatically make the callee’s parameter mutable—each binding has its own mutability.

```rust
fn increment(mut n: i32) -> i32 {
    n += 1;
    n
}

fn main() {
    let x = 5; // immutable here
    let y = increment(x); // x is Copy (i32), so still usable
    println!("x={x}, y={y}");
}
```

For owned heap data:

```rust
fn append_bang(mut s: String) -> String {
    s.push('!');
    s
}

fn main() {
    let s = String::from("hi");
    let s = append_bang(s); // take ownership, return it back
    println!("{s}");
}
```

You will soon prefer borrowing (`&mut String`) for this pattern.

## Worked Example: Config Counter

```rust
const MAX_RETRIES: u32 = 3;

fn main() {
    let mut attempts = 0u32;
    let mut success = false;

    while attempts < MAX_RETRIES {
        attempts += 1;
        println!("attempt {attempts}/{MAX_RETRIES}");
        // pretend third try works
        if attempts == 3 {
            success = true;
            break;
        }
    }

    let status = if success { "ok" } else { "failed" };
    println!("status={status}, attempts={attempts}");
}
```

## Hands-On Practice

1. Write a program with an immutable `let` and show (via commented error) that reassignment fails.
2. Implement a temperature converter using shadowing: start from a string `"  36.6 "`, trim, parse to `f64`, convert C→F.
3. Declare three `const` values for a tiny game (max HP, max inventory slots, app name). Print them.
4. Use a `mut` `Vec` (or grow a counter in a loop) to sum numbers `1..=10`.
5. Experiment: shadow `x` from `i32` to `String` and back. Explain why `mut` could not do the type change.
6. Run `cargo clippy` on your practice crate.

```rust
fn c_to_f(c: f64) -> f64 {
    c * 9.0 / 5.0 + 32.0
}

fn main() {
    let raw = "  36.6 ";
    let raw = raw.trim();
    let c: f64 = raw.parse().expect("temp");
    let f = c_to_f(c);
    println!("{c}°C = {f}°F");
}
```

## Common Mistakes

- **Using `mut` everywhere “just in case”** — hides intent; prefer immutable until mutation is needed.
- **Confusing shadowing with mutation** — shadowing creates a new binding; old value may be dropped if not used.
- **Forgetting type on `const`** — required.
- **Trying to put runtime `String` into `const`** — use `let` or `static` with care; prefer owned data at runtime.
- **Assuming immutability means deep freeze of all reachable data** — through shared references and interior mutability types, more nuanced rules appear later; for now, think at the binding level.

## Chapter Summary

Rust variables are **immutable by default**. Mark **`mut`** when you reassign or mutate. Use **shadowing** for staged transforms and type changes. Prefer **`const`** for compile-time constants and immutable **`static`** for long-lived global data. Mutability will interact tightly with **ownership and borrowing** next—but first, master **data types** so you know what those bindings hold.
