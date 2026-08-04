# Concurrency Basics

## Learning Goals

- Spawn threads with `std::thread`.
- Move data into threads and join handles.
- Communicate with channels (`mpsc`).
- Share state with `Arc` and `Mutex` when message passing is awkward.
- Explain `Send` and `Sync` at a practical level; avoid data races in safe Rust.

## Fearless Concurrency (What It Means)

Rust cannot eliminate all concurrency bugs (deadlocks still exist), but **safe Rust prevents data races**: concurrent unsynchronized access where at least one access is a write.

The same **ownership and borrowing** rules extend across threads via marker traits:

| Trait | Meaning (intuition) |
|-------|---------------------|
| `Send` | Ownership can transfer to another thread |
| `Sync` | Shared references (`&T`) are safe across threads |

Most simple types are both. `Rc` is not `Send`; use `Arc` for shared ownership across threads.

## Spawning Threads

```rust
use std::thread;
use std::time::Duration;

fn main() {
    let handle = thread::spawn(|| {
        for i in 1..=5 {
            println!("worker {i}");
            thread::sleep(Duration::from_millis(10));
        }
    });

    for i in 1..=3 {
        println!("main {i}");
        thread::sleep(Duration::from_millis(10));
    }

    handle.join().expect("worker panicked");
}
```

- `join` waits for completion and propagates panic as `Err`.
- Without join, main can exit and kill threads (daemon-like behavior).

## Moving Ownership Into Threads

```rust
use std::thread;

fn main() {
    let name = String::from("ferris");
    let handle = thread::spawn(move || {
        println!("hello {name}");
    });
    // println!("{name}"); // moved
    handle.join().unwrap();
}
```

Closures that outlive the current stack must **own** or use `'static` data—hence `move` is common.

## Channels: Message Passing

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();

    thread::spawn(move || {
        for i in 1..=5 {
            tx.send(i).unwrap();
            thread::sleep(Duration::from_millis(20));
        }
    });

    for received in rx {
        println!("got {received}");
    }
}
```

- `send` transfers ownership of the message to the receiver.
- When all `Sender`s drop, `Receiver` iterator ends.

### Multiple producers

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    for n in 0..3 {
        let tx = tx.clone();
        thread::spawn(move || {
            tx.send(format!("msg from {n}")).unwrap();
        });
    }
    drop(tx); // drop original so rx can finish
    for msg in rx {
        println!("{msg}");
    }
}
```

### `try_recv` and timeouts

```rust
use std::sync::mpsc;
use std::thread;
use std::time::Duration;

fn main() {
    let (tx, rx) = mpsc::channel();
    thread::spawn(move || {
        thread::sleep(Duration::from_millis(50));
        tx.send("done").unwrap();
    });

    loop {
        match rx.try_recv() {
            Ok(v) => {
                println!("{v}");
                break;
            }
            Err(mpsc::TryRecvError::Empty) => {
                println!("waiting...");
                thread::sleep(Duration::from_millis(10));
            }
            Err(mpsc::TryRecvError::Disconnected) => break,
        }
    }
}
```

Prefer blocking `recv` / iteration unless you need polling.

## Shared State: `Mutex`

```rust
use std::sync::Mutex;

fn main() {
    let m = Mutex::new(5);
    {
        let mut num = m.lock().unwrap();
        *num += 1;
    }
    println!("{:?}", m);
}
```

- `lock()` blocks until the mutex is available.
- Returns a **guard** that derefs to the data; unlocks on drop.
- `unwrap` on lock handles **poisoning** if a holder panicked.

## `Arc` + `Mutex` Across Threads

```rust
use std::sync::{Arc, Mutex};
use std::thread;

fn main() {
    let counter = Arc::new(Mutex::new(0));
    let mut handles = vec![];

    for _ in 0..10 {
        let counter = Arc::clone(&counter);
        handles.push(thread::spawn(move || {
            let mut n = counter.lock().unwrap();
            *n += 1;
        }));
    }

    for h in handles {
        h.join().unwrap();
    }

    println!("result = {}", *counter.lock().unwrap());
}
```

- `Arc` = atomic reference counted shared ownership.
- `Mutex` = mutual exclusion for mutation.
- Clone `Arc` cheaply (bumps count); do not clone the mutex alone for sharing.

## Prefer Channels When Possible

| Approach | Strength |
|----------|----------|
| Channels | Clear ownership transfer; easier reasoning |
| Mutex | Shared structure in place; risk of lock contention/deadlocks |
| Immutable share (`Arc<T>` where T is immutable) | Many readers, no locks |

```rust
use std::sync::mpsc;
use std::thread;

enum Job {
    Add(i32),
    Quit,
}

fn main() {
    let (tx, rx) = mpsc::channel();
    let worker = thread::spawn(move || {
        let mut total = 0;
        for job in rx {
            match job {
                Job::Add(n) => total += n,
                Job::Quit => break,
            }
        }
        total
    });

    tx.send(Job::Add(5)).unwrap();
    tx.send(Job::Add(7)).unwrap();
    tx.send(Job::Quit).unwrap();

    println!("total={}", worker.join().unwrap());
}
```

## Scoped Threads (Modern Std)

Rust’s scoped threads allow borrowing non-`'static` data safely:

```rust
use std::thread;

fn main() {
    let mut a = vec![1, 2, 3];
    let mut x = 0;

    thread::scope(|s| {
        s.spawn(|| {
            println!("hello from the first scoped thread");
            dbg!(&a);
        });
        s.spawn(|| {
            println!("hello from the second scoped thread");
            x += a[0] + a[2];
        });
        println!("hello from the main thread");
    });

    // all scoped threads joined here
    a.push(4);
    assert_eq!(x, a[0] + a[2]);
}
```

Scoped threads are excellent for parallelizing work over local data without `Arc`.

## Deadlocks (Still Possible)

```rust
// Conceptual anti-pattern: lock A then B in one thread,
// lock B then A in another → deadlock risk.
```

Guidelines:

- Keep critical sections small.
- Acquire multiple locks in a consistent global order.
- Prefer channels to multi-lock designs.
- Consider `try_lock` for opportunistic patterns.

## `Send` / `Sync` Errors You Will See

```rust
// use std::rc::Rc;
// let r = Rc::new(1);
// thread::spawn(move || println!("{r}")); // Rc is not Send
```

Fix: `Arc` instead of `Rc` for cross-thread sharing.

Holding a `MutexGuard` across `.await` in async code is a later advanced hazard—stick to threads here.

## Worked Example: Parallel Map (Scoped)

```rust
use std::thread;

fn parallel_double(xs: &[i32]) -> Vec<i32> {
    let mid = xs.len() / 2;
    let (left, right) = xs.split_at(mid);
    let mut out = vec![0; xs.len()];
    let (out_l, out_r) = out.split_at_mut(mid);

    thread::scope(|s| {
        s.spawn(|| {
            for (dst, src) in out_l.iter_mut().zip(left) {
                *dst = src * 2;
            }
        });
        s.spawn(|| {
            for (dst, src) in out_r.iter_mut().zip(right) {
                *dst = src * 2;
            }
        });
    });
    out
}

fn main() {
    println!("{:?}", parallel_double(&[1, 2, 3, 4, 5]));
}
```

## Worked Example: Fan-Out / Fan-In Counter

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx, rx) = mpsc::channel();
    let data = vec![
        "to be or not to be",
        "that is the question",
        "to be",
    ];

    for chunk in data {
        let tx = tx.clone();
        thread::spawn(move || {
            let count = chunk.split_whitespace().count();
            tx.send(count).unwrap();
        });
    }
    drop(tx);

    let total: usize = rx.iter().sum();
    println!("total words = {total}");
}
```

## Hands-On Practice

1. Spawn five threads that each print their index; join all.
2. Build a channel pipeline: thread A generates numbers 1..=10, thread B squares them, main prints.
3. Use `Arc<Mutex<Vec<String>>>` to collect greetings from multiple threads—then rewrite with channels only.
4. Demonstrate a compile error with `Rc` across threads; fix with `Arc`.
5. Use `thread::scope` to sum two halves of a slice in parallel.
6. Intentionally create a potential deadlock in a toy (two mutexes) and then fix lock ordering—do this carefully and keep it small.

```rust
use std::sync::mpsc;
use std::thread;

fn main() {
    let (tx1, rx1) = mpsc::channel::<i32>();
    let (tx2, rx2) = mpsc::channel::<i32>();

    thread::spawn(move || {
        for i in 1..=10 {
            tx1.send(i).unwrap();
        }
    });

    thread::spawn(move || {
        for i in rx1 {
            tx2.send(i * i).unwrap();
        }
    });

    for v in rx2 {
        println!("{v}");
    }
}
```

## Common Mistakes

- **Forgetting `join`** and missing panics/results.
- **Cloning `Mutex` instead of `Arc`** for sharing.
- **Holding locks while doing heavy I/O** — longer contention.
- **Assuming mutexes prevent deadlocks**.
- **Jumping to many threads** for tiny work — overhead dominates; measure later.
- **Sharing without synchronization** — the compiler will often stop you; listen to it.

## Chapter Summary

Rust concurrency starts with **threads**, **channels**, and carefully shared state via **`Arc<Mutex<_>>`**. Ownership makes message passing natural; `Send`/`Sync` encode thread-safety. Prefer scoped threads for borrowing local data. Next: **intermediate project**—modules, errors, tests, and concurrency-friendly design in one crate.
