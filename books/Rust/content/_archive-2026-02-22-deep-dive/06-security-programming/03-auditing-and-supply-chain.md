# Auditing, Fuzzing, and Supply Chain Security

## Dependency Governance

Run these in CI:

```bash
cargo audit
cargo deny check
cargo tree
```

## Fuzzing Target Example

```rust
pub fn parse_frame(input: &[u8]) -> Option<u16> {
    if input.len() < 2 {
        return None;
    }
    Some(u16::from_be_bytes([input[0], input[1]]))
}
```

Build fuzz harnesses around parsers and state machines.

## Unsafe Code Review

For each `unsafe` block, require:

- safety invariant documentation
- reviewer sign-off
- tests for boundary behavior

## Supply Chain Policy

- pin critical dependency versions
- prefer maintained crates
- track licenses and legal constraints

## Practice

1. Add `cargo audit` and `cargo deny` to CI pipeline.
2. Create one fuzz target for parser input.
3. Add unsafe code review checklist to CONTRIBUTING guide.

## Deep Dive: Secure Dependency Policy

Require:

- lockfile committed
- approved license list
- minimal dependency footprint
- regular vulnerability scans

## Review Questions

1. Why can transitive dependencies be your largest risk?
2. Why should dependency upgrades be staged and tested?
