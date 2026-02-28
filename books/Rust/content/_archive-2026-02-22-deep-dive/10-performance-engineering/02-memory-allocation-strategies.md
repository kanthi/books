# Memory and Allocation Strategies

## Allocation Awareness

Excess allocations often dominate latency in tight loops.

## Reuse Buffers

```rust
fn parse_lines(input: &str) -> usize {
    let mut buf = String::with_capacity(128);
    let mut count = 0;
    for line in input.lines() {
        buf.clear();
        buf.push_str(line);
        count += 1;
    }
    count
}
```

## Borrow Instead of Clone

```rust
fn takes_str(s: &str) {
    println!("{s}");
}
```

Prefer `&str` and slices when ownership transfer is unnecessary.

## Zero-Copy Considerations

- parse from byte slices where possible
- avoid intermediate string materialization
- design APIs around borrowed data lifetimes

## Practice

1. Remove three unnecessary clones from hot path.
2. Reuse one allocation-heavy buffer.
3. Measure allocation count before and after changes.

## Deep Dive: Owned vs Borrowed API Design

Prefer signatures like:

```rust
fn parse_record(input: &str) -> Result<&str, &'static str> {
    if input.is_empty() { return Err("empty"); }
    Ok(input)
}
```

Borrowed APIs reduce copies on hot paths.

## Review Questions

1. When does returning owned data become necessary?
2. What tradeoff do borrowed outputs create for API callers?
