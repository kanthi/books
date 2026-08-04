# What Is Rust and Why Rust

## Learning Goals

- Explain what Rust is and the problems it is designed to solve.
- Contrast Rust’s memory model with garbage-collected and manual-memory languages.
- Name the core guarantees: memory safety, thread safety, and zero-cost abstractions.
- Recognize when Rust is a strong fit (and when it might not be your first pick).
- Set expectations for the learning curve: the borrow checker is a feature, not a wall.

## What Is Rust?

**Rust** is a systems programming language that aims for:

1. **Performance** close to C/C++ (no mandatory garbage collector, fine-grained control).
2. **Reliability** via a strong type system and ownership rules enforced at compile time.
3. **Productivity** with a modern package manager (`cargo`), excellent compiler diagnostics, and a growing ecosystem.

Rust compiles to native machine code. A typical program is a binary you run like any other compiled language. You write source, `cargo build` or `cargo run` invokes `rustc`, and you get an executable.

```rust
fn main() {
    let language = "Rust";
    let year_focus = 2026;
    println!("{language}: systems language, stable toolchain focus {year_focus}");
}
```

Run it in a scratch project:

```bash
cargo new hello_rust && cd hello_rust
# edit src/main.rs, then:
cargo run
```

## Why Rust Exists

Many production bugs fall into a few categories:

| Category | Classic cause | Rust’s approach |
|----------|---------------|-----------------|
| Use-after-free | Freeing memory then using it | Ownership + lifetimes; invalid use fails to compile |
| Double free | Freeing the same block twice | Single owner; `Drop` runs once |
| Data races | Concurrent unsynchronized writes | `Send`/`Sync` + borrow rules across threads |
| Null dereference | Null pointers | `Option<T>` instead of nullable raw pointers in safe code |
| Buffer overruns | Unchecked indexing / pointer arithmetic | Bounds-checked indexing by default; unsafe is explicit |

Older systems languages often force a tradeoff: either you manage memory carefully by hand (power + footguns) or you accept a runtime GC (simpler memory, harder latency control). Rust’s bet is **compile-time ownership** so many classes of bugs never ship.

## The Ownership Pitch (Preview)

You will study ownership in depth in later chapters. The one-sentence version:

> Every value has a single **owner**. When the owner goes out of scope, the value is dropped. You can **borrow** references temporarily under strict rules.

That is enough to understand why people say Rust is “hard at first, then boring in a good way.” The compiler pushes you to state data flow clearly up front.

```rust
fn main() {
    let name = String::from("ferris");
    // `name` owns the heap String.
    greet(name); // ownership of the String moves into `greet`
    // println!("{name}"); // would not compile: name was moved
}

fn greet(who: String) {
    println!("hello, {who}");
} // `who` dropped here
```

Compare with borrowing (still a preview):

```rust
fn main() {
    let name = String::from("ferris");
    greet(&name); // borrow, do not move
    println!("still have: {name}"); // ok
}

fn greet(who: &str) {
    println!("hello, {who}");
}
```

## Safety Without a Garbage Collector

Rust does **not** insert a tracing GC that pauses your program to reclaim memory. Instead:

- Stack values free automatically when scopes end.
- Heap values (like `String`, `Vec`) free when their owner is dropped.
- Shared ownership exists (`Rc`, `Arc`) when you need it—you opt in.

That design matters for:

- **CLI tools** with predictable resource use  
- **Network services** with latency budgets  
- **Embedded / OS / drivers** (later parts of this book)  
- **Interop** with C via FFI when needed  

“Safe Rust” is the default. **`unsafe`** exists for raw pointers, FFI, and certain low-level patterns—but it is marked, audited, and minimized.

## Zero-Cost Abstractions

High-level features—iterators, generics, traits—are designed so that using them does **not** force a heavy runtime tax. After monomorphization and optimization, idiomatic Rust often matches hand-written loops in speed.

```rust
fn main() {
    let nums = vec![1, 2, 3, 4, 5];
    let sum: i32 = nums.iter().filter(|n| *n % 2 == 0).map(|n| n * n).sum();
    println!("sum of squares of evens = {sum}");
}
```

You will learn iterators properly with collections. For now, notice: this reads like a pipeline, and the compiler can optimize it aggressively.

## Cargo and the Ecosystem

Rust’s standard workflow is **Cargo**:

| Command | Purpose |
|---------|---------|
| `cargo new` | Create a project |
| `cargo build` / `run` | Compile / compile+run |
| `cargo test` | Run tests |
| `cargo fmt` | Format with rustfmt |
| `cargo clippy` | Lint for idioms and footguns |
| `cargo doc --open` | Build local docs |

Crates.io hosts libraries. Documentation for public crates lives on docs.rs. This tooling is a major reason teams adopt Rust even when the language itself has a learning curve.

```bash
# typical daily loop for a lesson crate
cargo check   # fast typecheck
cargo test
cargo clippy
cargo fmt
```

## Where Rust Shines

- **Correctness-critical systems**: parsers, databases, proxies, crypto plumbing, blockchain clients, cloud agents.
- **Performance-sensitive services** where GC pauses hurt.
- **CLI and developer tools** (many popular tools are Rust: ripgrep, fd, bat, and others in the ecosystem).
- **WebAssembly** targets and shared libraries with strong interfaces.
- **Teams that want refactor confidence**—the compiler is a relentless pair programmer.

## Where Rust May Not Be First Choice

Be honest with stakeholders:

- **Tiny scripts** where a shell or Python one-liner is enough.
- **Teams with zero systems experience** and a hard deadline measured in days for a throwaway prototype (prototype elsewhere, rewrite hot paths later if needed).
- **Domains locked into another stack** by regulation, vendor SDK, or org standard—interop may still use Rust modules.
- **GUI desktop apps** are doable but the ecosystem is more fragmented than for systems/services.

Rust is not “always the answer.” It is an excellent answer when **safety + performance + long-lived maintenance** matter.

## The Learning Curve (Honest Version)

Expect friction around:

1. **Ownership and borrowing** — feels strict until the mental model clicks.  
2. **Lifetimes** — mostly elided; when they appear, they document relationships you already had.  
3. **Async** — powerful; learn sync Rust first (this book’s order).  
4. **Error handling** — explicit `Result` is verbose at first and clearer later.

A productive mindset:

- Treat compiler errors as **teaching**, not rejection.
- Keep examples small.
- Prefer `cargo check` frequently while editing.
- Write tests early so refactors stay safe.

```rust
// The compiler helps you think about failure modes.
fn parse_port(s: &str) -> Result<u16, std::num::ParseIntError> {
    s.parse()
}

fn main() {
    match parse_port("8080") {
        Ok(port) => println!("listening intent: {port}"),
        Err(e) => eprintln!("bad port: {e}"),
    }
}
```

## Rust in 2024–2026 Practice

What “modern Rust” means for this book:

- Prefer **stable** toolchains; avoid depending on nightly for core lessons.
- Use **Edition 2024** when your `rustc` supports it in the project.
- Embrace **idioms**: `let-else`, careful `?` usage, iterators, `clippy` lints.
- Structure real programs as **library + binary** with tests.
- Treat `unwrap()` as a temporary student tool or a documented panic path—not production default.

```rust
fn first_word(s: &str) -> Option<&str> {
    s.split_whitespace().next()
}

fn main() {
    let line = "cargo clippy -- -D warnings";
    let Some(cmd) = first_word(line) else {
        eprintln!("empty input");
        return;
    };
    println!("command: {cmd}");
}
```

## How This Book Uses Rust’s Strengths

Part 1 builds:

- Syntax and types  
- Ownership and references  
- Strings, collections, `Result`  
- A **CLI notes** mini project  

Part 2 builds design skills: structs, enums, modules, traits, generics, lifetimes, tests, error design, threads.

Later parts take you into async, systems, networking, security, and more—always grounded in the same ownership model.

## Hands-On Practice

1. Create `cargo new why_rust` and print three reasons *you* want to learn Rust.
2. Write a function that takes ownership of a `String` and another that only borrows `&str`. Observe which caller can still use the value afterward.
3. Intentionally use a moved value and **read the full compiler error**. Rewrite until it compiles with borrowing.
4. Run `rustc --version` and `cargo --version`. Note them in a study log.
5. Run `cargo clippy` on your scratch crate (even with tiny code). Fix any suggestions you understand; note the rest for later.

```rust
fn takes_ownership(s: String) {
    println!("owned: {s}");
}

fn borrows(s: &str) {
    println!("borrowed: {s}");
}

fn main() {
    let a = String::from("systems");
    borrows(&a);
    println!("after borrow: {a}");
    takes_ownership(a);
    // println!("{a}"); // try uncommenting to see the error
}
```

## Common Mistakes

- **Expecting GC-like freedom** — Rust will not silently copy heap data on every assignment.
- **Fighting the compiler** by sprinkling `clone()` everywhere without understanding—clones are fine when intentional, not as a reflex.
- **Skipping tooling** — learning “just rustc” without Cargo leaves out how real projects work.
- **Jumping to async/unsafe on day one** — master ownership first.
- **Assuming “safe” means “bug-free”** — logic bugs, deadlocks (with locks), and resource exhaustion still exist; Rust removes whole categories of memory and data-race bugs in safe code.

## Chapter Summary

Rust is a **systems language** that prioritizes **memory and thread safety** without a garbage collector, using **ownership and borrowing** enforced at compile time. Combined with **Cargo**, **clippy**, and a strong ecosystem, it is a practical choice for reliable, high-performance software. The learning curve is real; this book paces concepts so the borrow checker becomes a partner. Next: install the toolchain and write your first program with Cargo.
