# Concurrency and Ecosystem Workflow

## Threads and Channels

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        tx.send(String::from("job complete")).unwrap();
    });

    println!("{}", rx.recv().unwrap());
}
```

## Shared State with Mutex

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..5 {
        let c = Arc::clone(&counter);
        handles.push(thread::spawn(move || {
            *c.lock().unwrap() += 1;
        }));
    }

    for h in handles {
        h.join().unwrap();
    }

    println!("counter={}", *counter.lock().unwrap());
}
```

## Crate Evaluation Checklist

- Maintenance: release recency, issue activity.
- Safety: unsafe usage, audit status.
- API stability: semver discipline.
- Performance footprint.

## Example: Feature Flags

`Cargo.toml`:

```toml
[dependencies]
tracing = { version = "0.1", optional = true }

[features]
default = []
observability = ["tracing"]
```

## Practice

1. Build a worker pool with channel-based job dispatch.
2. Protect shared cache with `Arc<Mutex<...>>`.
3. Add a feature flag for optional logging.

## Deep Dive: Concurrency Design Choices

Prefer message passing when shared state is hard to reason about.

## Worker Pool Example

```rust
use std::sync::{mpsc, Arc, Mutex};
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel::<u32>();
    let rx = Arc::new(Mutex::new(rx));

    let mut workers = vec![];
    for _ in 0..4 {
        let rx = Arc::clone(&rx);
        workers.push(thread::spawn(move || loop {
            let msg = rx.lock().unwrap().recv();
            match msg {
                Ok(job) => println!("processed job {job}"),
                Err(_) => break,
            }
        }));
    }

    for i in 0..10 {
        tx.send(i).unwrap();
    }
    drop(tx);

    for w in workers {
        w.join().unwrap();
    }
}
```

## Ecosystem Evaluation Matrix

- API ergonomics
- maintenance signals
- security posture
- benchmark evidence

## Review Questions

1. When does channel-based design beat mutex-heavy design?
2. Why bound worker count?
3. What red flags indicate risky dependency adoption?
