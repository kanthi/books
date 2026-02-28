# Hardware Abstraction and Peripheral Access

## HAL Pattern

Hardware Abstraction Layer lets your application code stay portable across boards.

## Trait-Based Peripheral Example

```rust
trait Led {
    fn on(&mut self);
    fn off(&mut self);
}

fn blink<T: Led>(led: &mut T) {
    led.on();
    led.off();
}
```

## GPIO Conceptual Flow

1. configure pin mode
2. set output state
3. optionally configure pull-up/down

## Serial/UART Considerations

- baud rate mismatch causes garbage data
- use framing/CRC for robust payloads
- handle partial reads safely

## Practice

1. Abstract one peripheral with a trait.
2. Build a fake peripheral for desktop tests.
3. Add error handling for peripheral init failures.

## Deep Dive: Driver API Design

Good peripheral drivers expose:

- explicit initialization
- non-blocking/bounded operations
- clear error enums

## Review Questions

1. Why keep hardware-specific details behind traits?
2. How does this improve testability on host systems?
