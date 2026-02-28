# no_std, Cross Compilation, and Toolchains

## Why Embedded Rust Is Different

Embedded targets often have:

- no OS
- limited RAM/flash
- strict timing constraints

`no_std` removes the standard library dependency.

## Minimal no_std Example

```rust
#![no_std]
#![no_main]

use core::panic::PanicInfo;

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    loop {}
}
```

## Cross-Compilation Basics

```bash
rustup target add thumbv7em-none-eabihf
cargo build --target thumbv7em-none-eabihf
```

## Linker and Memory Layout

Understand these artifacts:

- linker script (`memory.x`)
- vector table placement
- stack/heap boundaries

## Practice

1. Build a hello-world firmware target.
2. Inspect binary size with `cargo size` equivalent tool.
3. Document memory budget assumptions.

## Deep Dive: Panic Strategy

In constrained systems, panic behavior must be explicit.

- halt safely
- reset controller
- record diagnostic marker if possible

## Review Questions

1. Why is panic policy part of system reliability design?
2. What diagnostic signal helps post-failure analysis?
