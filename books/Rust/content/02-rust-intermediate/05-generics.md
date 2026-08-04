# Generics

## Learning Goals

- Write generic functions and structs with type parameters.
- Apply trait bounds so generics can call methods.
- Understand monomorphization at a high level (zero-cost abstraction).
- Use generic enums (`Option`, `Result`) deliberately.
- Avoid over-generalizing; keep APIs as simple as the problem allows.

## Why Generics?

Without generics you duplicate code per type:

```rust
fn largest_i32(list: &[i32]) -> &i32 {
    let mut best = &list[0];
    for item in list {
        if item > best {
            best = item;
        }
    }
    best
}
```

With generics + bounds:

```rust
fn largest<T: PartialOrd>(list: &[T]) -> &T {
    let mut best = &list[0];
    for item in list {
        if item > best {
            best = item;
        }
    }
    best
}

fn main() {
    println!("{}", largest(&[1, 5, 2]));
    println!("{}", largest(&['a', 'z', 'm']));
}
```

## Generic Functions

```rust
fn first<T>(items: &[T]) -> Option<&T> {
    items.first()
}

fn main() {
    let v = vec![10, 20];
    println!("{:?}", first(&v));
    println!("{:?}", first::<i32>(&[]));
}
```

Turbofish `::<>` when inference needs help.

## Generic Structs

```rust
#[derive(Debug)]
struct Point<T> {
    x: T,
    y: T,
}

impl<T> Point<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }

    fn x(&self) -> &T {
        &self.x
    }
}

impl Point<f64> {
    fn distance_from_origin(&self) -> f64 {
        (self.x * self.x + self.y * self.y).sqrt()
    }
}

fn main() {
    let i = Point::new(1, 2);
    let f = Point::new(1.0, 2.0);
    println!("{:?} {}", i, f.distance_from_origin());
}
```

Multiple parameters:

```rust
struct Pair<T, U> {
    a: T,
    b: U,
}

fn main() {
    let p = Pair { a: 1, b: "two" };
    println!("{} {}", p.a, p.b);
}
```

## Generic Enums

You already use:

```rust
enum Option<T> {
    Some(T),
    None,
}
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

Custom:

```rust
enum Either<L, R> {
    Left(L),
    Right(R),
}

fn main() {
    let a: Either<i32, &str> = Either::Left(1);
    let b: Either<i32, &str> = Either::Right("err");
    match (a, b) {
        (Either::Left(n), Either::Right(s)) => println!("{n} {s}"),
        _ => {}
    }
}
```

## Trait Bounds in Depth

```rust
use std::fmt::Display;

fn print_pair<T, U>(a: T, b: U)
where
    T: Display,
    U: Display,
{
    println!("{a} / {b}");
}

fn main() {
    print_pair(1, "two");
}
```

### Bound on impl block

```rust
struct Wrapper<T> {
    value: T,
}

impl<T: Display> Wrapper<T> {
    fn print(&self) {
        println!("{}", self.value);
    }
}

use std::fmt::Display;

fn main() {
    Wrapper { value: 42 }.print();
}
```

### Multiple bounds

```rust
fn dump<T>(t: &T)
where
    T: Display + Clone,
{
    let c = t.clone();
    println!("{c}");
}
```

## Monomorphization (Mental Model)

Rust compiles generic code into specialized versions per concrete type used (roughly):

```text
largest::<i32>  → concrete fn for i32
largest::<char> → concrete fn for char
```

- **Cost:** possible code size increase.
- **Gain:** no virtual call overhead; optimizes like hand-written code.

This is the “zero-cost” story for generics + traits (static dispatch).

## Generics vs `dyn Trait`

| | Generics (`T: Trait`) | `dyn Trait` |
|--|----------------------|-------------|
| Dispatch | Static | Dynamic |
| Heterogeneous list | Harder | Natural |
| Performance | Often better | Indirection |
| Code size | May grow | Single copy |

```rust
fn static_len<T: AsRef<str>>(s: T) -> usize {
    s.as_ref().len()
}

fn dynamic_len(s: &dyn AsRef<str>) -> usize {
    s.as_ref().len()
}

fn main() {
    println!("{}", static_len("hi"));
    println!("{}", static_len(String::from("hi")));
    println!("{}", dynamic_len(&"hi"));
}
```

## Conditional Methods with Bounds

```rust
struct Pair<T> {
    x: T,
    y: T,
}

impl<T> Pair<T> {
    fn new(x: T, y: T) -> Self {
        Self { x, y }
    }
}

impl<T: Clone> Pair<T> {
    fn first_clone(&self) -> T {
        self.x.clone()
    }
}

fn main() {
    let p = Pair::new(String::from("a"), String::from("b"));
    println!("{}", p.first_clone());
}
```

## Generic + Ownership Patterns

```rust
fn into_vec<T>(iter: impl IntoIterator<Item = T>) -> Vec<T> {
    iter.into_iter().collect()
}

fn main() {
    let v = into_vec([1, 2, 3]);
    let w = into_vec(vec![String::from("a")]);
    println!("{v:?} {w:?}");
}
```

```rust
fn push_all<T>(dst: &mut Vec<T>, src: impl IntoIterator<Item = T>) {
    dst.extend(src);
}

fn main() {
    let mut v = vec![1];
    push_all(&mut v, [2, 3]);
    println!("{v:?}");
}
```

## `impl Trait` vs Explicit Generics

```rust
fn map_len(items: impl IntoIterator<Item = impl AsRef<str>>) -> Vec<usize> {
    items.into_iter().map(|s| s.as_ref().len()).collect()
}

// Equivalent clarity sometimes better with named params:
fn map_len2<I, S>(items: I) -> Vec<usize>
where
    I: IntoIterator<Item = S>,
    S: AsRef<str>,
{
    items.into_iter().map(|s| s.as_ref().len()).collect()
}

fn main() {
    println!("{:?}", map_len(["a", "bb"]));
    println!("{:?}", map_len2(vec![String::from("xyz")]));
}
```

## Const Generics (Modern Stable Feature)

Arrays can be generic over length:

```rust
fn sum_array<const N: usize>(xs: [i32; N]) -> i32 {
    xs.iter().sum()
}

fn main() {
    println!("{}", sum_array([1, 2, 3]));
    println!("{}", sum_array([10, 20]));
}
```

Useful for fixed-size buffers and embedded-style code later.

## Worked Example: Generic Cache Key Wrapper

```rust
use std::collections::HashMap;
use std::hash::Hash;

struct Cache<K, V> {
    map: HashMap<K, V>,
}

impl<K, V> Cache<K, V>
where
    K: Eq + Hash,
{
    fn new() -> Self {
        Self {
            map: HashMap::new(),
        }
    }

    fn insert(&mut self, k: K, v: V) {
        self.map.insert(k, v);
    }

    fn get(&self, k: &K) -> Option<&V> {
        self.map.get(k)
    }
}

impl<K, V> Cache<K, V>
where
    K: Eq + Hash,
    V: Clone,
{
    fn get_cloned(&self, k: &K) -> Option<V> {
        self.get(k).cloned()
    }
}

fn main() {
    let mut c = Cache::new();
    c.insert("a", 1);
    c.insert("b", 2);
    println!("{:?}", c.get(&"a"));
    println!("{:?}", c.get_cloned(&"b"));
}
```

## Worked Example: Generic Result Helper

```rust
fn parse_pair<T, U>(s: &str) -> Result<(T, U), String>
where
    T: std::str::FromStr,
    U: std::str::FromStr,
    T::Err: std::fmt::Display,
    U::Err: std::fmt::Display,
{
    let (a, b) = s
        .split_once(',')
        .ok_or_else(|| "expected a,b".to_string())?;
    let a = a
        .trim()
        .parse()
        .map_err(|e| format!("left: {e}"))?;
    let b = b
        .trim()
        .parse()
        .map_err(|e| format!("right: {e}"))?;
    Ok((a, b))
}

fn main() {
    let p: Result<(i32, i32), _> = parse_pair("3, 4");
    let q: Result<(String, f64), _> = parse_pair("pi, 3.14");
    println!("{p:?} {q:?}");
}
```

## Hands-On Practice

1. Write `fn last<T>(xs: &[T]) -> Option<&T>`.
2. Generic struct `MinMax<T: PartialOrd + Copy>` tracking min and max via `fn observe(&mut self, v: T)`.
3. Implement `fn zip_sum(a: &[i32], b: &[i32]) -> Option<Vec<i32>>` then generalize element type with `Add` + `Copy` if ambitious.
4. Build `enum MaybeOwned<'a, T>` … skip lifetimes if not ready; instead `enum Cowish<T> { Owned(T), /* later */ }`.
5. Use const generics: `fn mid<const N: usize>(xs: &[i32; N]) -> i32` average of first/last or center.
6. Tests for empty input paths.

```rust
#[derive(Debug)]
struct MinMax<T> {
    min: T,
    max: T,
}

impl<T: PartialOrd + Copy> MinMax<T> {
    fn new(v: T) -> Self {
        Self { min: v, max: v }
    }
    fn observe(&mut self, v: T) {
        if v < self.min {
            self.min = v;
        }
        if v > self.max {
            self.max = v;
        }
    }
}

fn main() {
    let mut m = MinMax::new(10);
    for v in [3, 50, 7] {
        m.observe(v);
    }
    println!("{m:?}");
}
```

## Common Mistakes

- **Unbounded generics that call methods** — add trait bounds.
- **`T` everywhere** making signatures unreadable—name meaningful params or use `impl Trait`.
- **Premature abstraction** — wait until you have two real call sites.
- **Confusing type parameters with lifetimes** — different namespaces: `<'a, T>`.
- **Returning references to locals from generic helpers** — same ownership rules apply.

## Chapter Summary

Generics let you write **type-flexible** code that monomorphizes into efficient concrete functions. Pair them with **trait bounds** for real power. Prefer simple concrete types until duplication hurts. Next: **lifetimes**—how Rust validates borrows across functions and structs.
