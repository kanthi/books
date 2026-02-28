# Advanced Architecture Patterns

## Layered Architecture

A practical Rust service often has:

- `domain`: business rules
- `application`: use cases/orchestration
- `infrastructure`: DB/network/files
- `interface`: HTTP/CLI/gRPC handlers

## Trait-Driven Ports

```rust
trait UserRepo {
    fn get_email(&self, id: u64) -> Option<String>;
}

struct GetEmailUseCase<R: UserRepo> {
    repo: R,
}
```

This keeps core logic independent from storage choices.

## Error and Boundary Strategy

- Convert low-level errors near boundaries.
- Keep domain errors stable and semantic.
- Log context once at the boundary.

## Example Folder Layout

```text
src/
  domain/
  app/
  infra/
  interfaces/
```

## Example: Configuration Object

```rust
#[derive(Clone)]
struct AppConfig {
    db_url: String,
    http_port: u16,
}
```

Load config once, pass immutable shared state.

## Practice

1. Split a monolithic crate into domain/app/infra modules.
2. Add trait-based repository interfaces.
3. Replace ad-hoc globals with explicit config injection.

## Deep Dive: Dependency Injection in Rust

Use constructors with trait bounds and explicit shared state.

```rust
trait Clock {
    fn now_unix(&self) -> i64;
}

struct SystemClock;
impl Clock for SystemClock {
    fn now_unix(&self) -> i64 {
        1_700_000_000
    }
}

struct TokenService<C: Clock> {
    clock: C,
}

impl<C: Clock> TokenService<C> {
    fn issued_at(&self) -> i64 {
        self.clock.now_unix()
    }
}
```

## Configuration Layering

Merge config from:

1. defaults
2. config file
3. environment variables
4. command-line overrides

## Architectural Review Checklist

- Are invariants enforced in domain layer?
- Are boundary errors translated once?
- Can dependencies be swapped for tests?
- Is startup/shutdown lifecycle explicit?

## Review Questions

1. Why isolate side effects in infrastructure layer?
2. What makes a boundary contract stable?
3. How does trait-based DI improve testability?
