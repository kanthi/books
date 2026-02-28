# Structs, Enums, and Modules

## Struct Design

Use structs to model domain entities clearly.

```rust
#[derive(Debug, Clone)]
pub struct User {
    pub id: u64,
    pub email: String,
    pub active: bool,
}
```

## Enums for State

```rust
#[derive(Debug, Clone, Copy)]
pub enum Plan {
    Free,
    Pro,
    Enterprise,
}
```

Enums help avoid invalid states.

## Pattern Matching in Business Rules

```rust
fn max_projects(plan: Plan) -> u32 {
    match plan {
        Plan::Free => 1,
        Plan::Pro => 10,
        Plan::Enterprise => 100,
    }
}
```

## Module Organization

```text
src/
  lib.rs
  domain/
    mod.rs
    user.rs
    billing.rs
```

`src/lib.rs`:

```rust
pub mod domain;
```

`src/domain/mod.rs`:

```rust
pub mod user;
pub mod billing;
```

## Example: Constructor and Validation

```rust
impl User {
    pub fn new(id: u64, email: String) -> Result<Self, &'static str> {
        if !email.contains('@') {
            return Err("invalid email");
        }
        Ok(Self { id, email, active: true })
    }
}
```

## Practice

1. Model an `Order` with status enum and line items.
2. Split models into modules by domain.
3. Ensure impossible states are encoded via enums.

## Deep Dive: Rich Domain Modeling

Prefer types that encode business constraints.

```rust
#[derive(Debug, Clone)]
pub struct Email(String);

impl Email {
    pub fn parse(input: &str) -> Result<Self, &'static str> {
        if !input.contains('@') {
            return Err("invalid email");
        }
        Ok(Self(input.to_string()))
    }

    pub fn as_str(&self) -> &str {
        &self.0
    }
}
```

This prevents invalid values from entering your core logic.

## Enum State Machine Example

```rust
#[derive(Debug, Clone, Copy)]
enum TicketState {
    Open,
    InProgress,
    Closed,
}

fn transition(state: TicketState, action: &str) -> Option<TicketState> {
    match (state, action) {
        (TicketState::Open, "start") => Some(TicketState::InProgress),
        (TicketState::InProgress, "close") => Some(TicketState::Closed),
        _ => None,
    }
}
```

## Module Boundary Checklist

- `domain`: no DB/http dependencies.
- `infra`: adapter implementations.
- `app`: use cases and orchestration.

## Review Questions

1. Why is a newtype useful for input validation?
2. How do enums reduce illegal states?
3. What code belongs outside the domain module?
