# Collections Intro

## Learning Goals

- Use `Vec<T>` for growable lists: create, push, index, iterate.
- Use `HashMap<K, V>` for key-value data.
- Apply ownership rules when storing and retrieving values.
- Get comfortable with iterator adapters: `map`, `filter`, `collect`, `sum`.
- Choose between arrays, slices, `Vec`, and maps for common tasks.

## Why Collections?

Fixed arrays are great when size is known. Real programs need **dynamic** containers:

| Collection | Use when |
|------------|----------|
| `Vec<T>` | Ordered list, stack-like, growable buffer |
| `HashMap<K,V>` | Lookup by key |
| `HashSet<T>` | Unique membership (briefly) |
| `VecDeque<T>` | Efficient front/back queue (later as needed) |

All are in `std::collections` ( `Vec` is re-exported in the prelude heavily).

## `Vec<T>` Basics

```rust
fn main() {
    let mut v: Vec<i32> = Vec::new();
    v.push(1);
    v.push(2);
    v.push(3);

    let v2 = vec![10, 20, 30];
    println!("{v:?} {v2:?}");
    println!("len={} capacity≈{}", v.len(), v.capacity());
}
```

### Reading elements

```rust
fn main() {
    let v = vec![10, 20, 30];
    let second = &v[1]; // panics if OOB
    println!("second={second}");

    match v.get(1) {
        Some(x) => println!("get={x}"),
        None => println!("none"),
    }
    println!("{:?}", v.get(99));
}
```

### Ownership and indexing

```rust
fn main() {
    let mut v = vec![String::from("a"), String::from("b")];
    let first = &v[0];
    // v.push(String::from("c")); // error: might reallocate, invalidating first
    println!("{first}");
    v.push(String::from("c")); // ok after first is no longer used
    println!("{v:?}");
}
```

Borrow checker prevents iterator invalidation class bugs.

## Iterating Vectors

```rust
fn main() {
    let v = vec![1, 2, 3];
    for x in &v {
        println!("borrow {x}");
    }
    let mut v = v;
    for x in &mut v {
        *x *= 2;
    }
    for x in v {
        // moves out; v consumed
        println!("owned {x}");
    }
}
```

## Common `Vec` Operations

```rust
fn main() {
    let mut v = vec![1, 2, 3, 4, 5];
    v.pop();                 // Some(5)
    v.insert(1, 99);         // [1, 99, 2, 3, 4]
    let two = v.remove(2);   // removes 2
    println!("removed {two}, now {v:?}");

    v.retain(|x| *x % 2 == 1);
    println!("odds {v:?}");

    let slice: &[i32] = &v[0..v.len().min(2)];
    println!("slice {slice:?}");
}
```

### Preallocation

```rust
fn main() {
    let mut v = Vec::with_capacity(100);
    for i in 0..100 {
        v.push(i);
    }
    println!("len={} cap={}", v.len(), v.capacity());
}
```

## `HashMap<K, V>`

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::new();
    scores.insert(String::from("blue"), 10);
    scores.insert(String::from("red"), 50);

    let team = String::from("blue");
    let score = scores.get(&team).copied().unwrap_or(0);
    println!("blue={score}");

    for (k, v) in &scores {
        println!("{k}: {v}");
    }
}
```

### Ownership of keys/values

`insert` takes ownership of key and value (unless they are `Copy`).

```rust
use std::collections::HashMap;

fn main() {
    let mut map = HashMap::new();
    let field = String::from("color");
    let value = String::from("blue");
    map.insert(field, value);
    // field/value moved
    println!("{map:?}");
}
```

### Entry API (idiomatic updates)

```rust
use std::collections::HashMap;

fn main() {
    let mut counts: HashMap<char, u32> = HashMap::new();
    for c in "hello rust".chars().filter(|c| !c.is_whitespace()) {
        *counts.entry(c).or_insert(0) += 1;
    }
    println!("{counts:?}");
}
```

### Update patterns

```rust
use std::collections::HashMap;

fn main() {
    let mut scores = HashMap::from([("blue".into(), 10), ("red".into(), 50)]);
    scores.insert("blue".into(), 25); // overwrite
    scores.entry("yellow".into()).or_insert(1); // insert if missing
    scores.entry("blue".into()).and_modify(|s| *s += 5);
    println!("{scores:?}");
}
```

## Iterators: The Pipeline Mindset

Collections shine with **iterators**:

```rust
fn main() {
    let nums = vec![1, 2, 3, 4, 5, 6];
    let sum: i32 = nums
        .iter()
        .filter(|n| *n % 2 == 0)
        .map(|n| n * n)
        .sum();
    println!("sum of squares of evens = {sum}");
}
```

### Consuming vs borrowing iterators

| Method | Yields | Consumes collection? |
|--------|--------|----------------------|
| `.iter()` | `&T` | No |
| `.iter_mut()` | `&mut T` | No |
| `.into_iter()` | `T` | Yes |

```rust
fn main() {
    let names = vec![String::from("a"), String::from("b")];
    let lens: Vec<usize> = names.iter().map(|s| s.len()).collect();
    println!("{names:?} lens={lens:?}"); // names still available

    let owned: Vec<String> = names.into_iter().map(|s| s + "!").collect();
    println!("{owned:?}");
}
```

### `collect` type hints

```rust
fn main() {
    let v: Vec<i32> = (1..=5).collect();
    let s: String = ['r', 'u', 's', 't'].iter().collect();
    println!("{v:?} {s}");
}
```

## `HashSet` Snapshot

```rust
use std::collections::HashSet;

fn main() {
    let mut set = HashSet::from([1, 2, 3]);
    set.insert(2); // no-op membership-wise
    set.insert(4);
    println!("has 3? {}", set.contains(&3));
    println!("{set:?}");
}
```

## Sorting and Searching on `Vec`

```rust
fn main() {
    let mut v = vec![4, 1, 3, 2];
    v.sort();
    println!("{v:?}");
    println!("binary_search 3 = {:?}", v.binary_search(&3));

    let mut words = vec!["banana", "apple", "pear"];
    words.sort_by_key(|w| w.len());
    println!("{words:?}");
}
```

## Ownership Mini-Lab: Moving Out of a Vec

```rust
fn main() {
    let mut v = vec![String::from("one"), String::from("two")];
    // let s = v[0]; // error: cannot move out of index
    let s = v.remove(0); // take ownership of element
    println!("took {s}, left {v:?}");

    let v = vec![String::from("a"), String::from("b")];
    let first = v.into_iter().next();
    println!("{first:?}"); // v consumed
}
```

Or clone if you need both.

## Worked Example: Word Frequency CLI Core

```rust
use std::collections::HashMap;

fn word_freq(text: &str) -> HashMap<String, usize> {
    let mut map = HashMap::new();
    for w in text
        .split_whitespace()
        .map(|w| w.trim_matches(|c: char| !c.is_alphanumeric()))
        .filter(|w| !w.is_empty())
        .map(|w| w.to_lowercase())
    {
        *map.entry(w).or_insert(0) += 1;
    }
    map
}

fn top_n(freq: &HashMap<String, usize>, n: usize) -> Vec<(&String, &usize)> {
    let mut items: Vec<_> = freq.iter().collect();
    items.sort_by(|a, b| b.1.cmp(a.1).then_with(|| a.0.cmp(b.0)));
    items.into_iter().take(n).collect()
}

fn main() {
    let text = "To be or not to be, that is the question. To be!";
    let freq = word_freq(text);
    for (w, c) in top_n(&freq, 5) {
        println!("{w}: {c}");
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn counts_to() {
        let f = word_freq("To be to");
        assert_eq!(f.get("to"), Some(&2));
        assert_eq!(f.get("be"), Some(&1));
    }
}
```

## When to Use What

```text
Fixed size, stack        → [T; N]
View into contiguous     → &[T]
Growable ordered         → Vec<T>
Key lookup               → HashMap<K,V>
Unique keys only         → HashSet<T>
```

## Hands-On Practice

1. Build a `Vec` of the first 20 Fibonacci numbers.
2. Given `vec![1,2,2,3,3,3]`, produce a frequency `HashMap`.
3. Merge two `Vec<i32>` that are sorted into one sorted vec (no sort call—two pointers).
4. Use iterators to compute the product of all odd numbers in a vec.
5. Store student grades: `HashMap<String, Vec<u8>>`, then compute averages.
6. Write tests for empty input and single-element collections.

```rust
use std::collections::HashMap;

fn fib(n: usize) -> Vec<u64> {
    let mut v = Vec::with_capacity(n);
    for i in 0..n {
        let next = match i {
            0 => 0,
            1 => 1,
            _ => v[i - 1] + v[i - 2],
        };
        v.push(next);
    }
    v
}

fn freq(nums: &[i32]) -> HashMap<i32, usize> {
    let mut m = HashMap::new();
    for &n in nums {
        *m.entry(n).or_insert(0) += 1;
    }
    m
}

fn main() {
    println!("{:?}", fib(10));
    println!("{:?}", freq(&[1, 2, 2, 3, 3, 3]));
}
```

## Common Mistakes

- **Indexing without `.get`** on untrusted indices.
- **Holding a reference into a `Vec` while pushing**.
- **Using `HashMap` with keys that do not implement `Eq + Hash`**.
- **Moving out via `v[i]` for non-Copy types**.
- **Collecting without a type annotation** when inference fails.
- **Overusing `clone` on maps/vecs** instead of borrowing.

## Chapter Summary

`Vec` and `HashMap` are the workhorse collections. Combine them with **iterators** for clear, efficient data pipelines. Respect borrowing when indexing and mutating. Next: **error handling**—`Option`, `Result`, and the `?` operator so collection-backed programs can fail safely.
