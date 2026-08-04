# Embedded Basics

## Introduction

Embedded systems are specialized computing systems designed to perform dedicated functions within larger mechanical or electrical systems. Unlike general-purpose computers, they are often resource-constrained and optimized for specific tasks. This chapter builds C-focused foundations you can practice on a Linux host: bit helpers, packed structs, `volatile`, register overlays over a buffer, a button-debounce state machine, and high-level cross-compile notes for `arm-none-eabi-gcc`.

Many examples are **host simulations** (plain `gcc` on Linux). They teach patterns you will use on bare metal without requiring a board.

**Host compile convention:**

```bash
gcc -std=c17 -Wall -Wextra -o program program.c
./program
```

## What Are Embedded Systems?

An embedded system is a computer with a dedicated function inside a larger product, often with real-time constraints.

### Characteristics

1. **Dedicated function** — not a general-purpose desktop OS workload  
2. **Resource constraints** — limited RAM, flash, CPU, energy  
3. **Real-time operation** — deadlines matter  
4. **Reliability** — long uptime expectations  
5. **Cost sensitivity** — BOM-driven design  
6. **Power efficiency** — batteries and thermal limits  

### Types (rough scale)

| Scale | Typical hardware | Examples |
|-------|------------------|----------|
| Small | 8/16-bit MCU, KB of RAM | sensors, toys, simple appliances |
| Medium | 32-bit MCU, tens–hundreds of KB | motor control, IoT nodes |
| Sophisticated | MPU + OS (Linux/RTOS), MB+ | routers, automotive domains, phones |

## Microcontroller vs Microprocessor

**Microcontroller (MCU):** CPU + memory + peripherals on one chip; minimal external parts.

**Microprocessor (MPU):** CPU core; RAM, flash, and many peripherals are external; higher performance, more complex board design.

### Typical Components

- Processor (CPU)  
- Memory (Flash/ROM, RAM, sometimes EEPROM)  
- GPIO and serial (UART, SPI, I²C)  
- ADC/DAC, timers/counters  
- Interrupt controller, clock tree, power management  

## Development Environments and Cross-Compilation

Embedded builds usually **cross-compile**: the compiler runs on a host (e.g. x86_64 Linux) and emits code for a different target (e.g. ARM Cortex-M).

### High-Level Toolchain Notes (`arm-none-eabi-gcc`)

| Piece | Role |
|-------|------|
| `arm-none-eabi-gcc` | C compiler for bare-metal ARM (no Linux userspace ABI) |
| `arm-none-eabi-as` / `ld` | Assembler / linker (often driven by gcc) |
| `arm-none-eabi-objcopy` | ELF → binary/ihex for flashing |
| `arm-none-eabi-objdump` / `size` | Inspect sections and code size |
| `arm-none-eabi-gdb` | Debug via probe (OpenOCD, J-Link, etc.) |
| Linker script (`.ld`) | Places `.text`, `.data`, `.bss`, stack at real addresses |
| Startup (`.s` / `.c`) | Reset handler, copy `.data`, zero `.bss`, call `main` |

**Typical flags (illustrative Cortex-M3):**

```bash
# Install on Debian/Ubuntu-style hosts (example package name):
# sudo apt install gcc-arm-none-eabi binutils-arm-none-eabi

arm-none-eabi-gcc -std=c17 -Wall -Wextra \
  -mcpu=cortex-m3 -mthumb \
  -ffunction-sections -fdata-sections \
  -T linker_script.ld \
  -nostartfiles \
  -o firmware.elf startup.c main.c

arm-none-eabi-objcopy -O binary firmware.elf firmware.bin
arm-none-eabi-size firmware.elf
```

**What those flags mean (high level):**

- `-mcpu=cortex-m3 -mthumb` — generate Thumb code for that core  
- `-ffunction-sections -fdata-sections` — enable linker garbage collection of unused sections (with `-Wl,--gc-sections`)  
- `-T linker_script.ld` — memory map for flash/RAM  
- `-nostartfiles` — you supply startup (or use a vendor CRT carefully)  

You do **not** need this toolchain for the host simulation programs below; use native `gcc` on Linux for those.

### Other Tools You Will Meet

- IDEs: vendor tools, VS Code + Cortex-Debug, CLion, etc.  
- Debug probes: SWD/JTAG  
- Simulators: QEMU (machine-dependent), Renode  

## Memory Organization

| Region | Typical use |
|--------|-------------|
| Flash / ROM | Code (`.text`), constants (`.rodata`), initializers |
| RAM | `.data` (copied at boot), `.bss` (zeroed), heap, stack |
| EEPROM / NVM | Configuration that survives power loss |
| MMIO registers | Peripheral control/status (volatile) |

```c
/* Conceptual Cortex-M style map (numbers vary by chip) */
/* 0x00000000  code flash
 * 0x20000000  SRAM
 * 0x40000000  peripherals
 * 0xE0000000  system (NVIC, SysTick, ...)
 */
```

### Startup Sketch (bare metal idea)

```c
/* Conceptual only — addresses come from the linker script */
extern unsigned int _etext, _data, _edata, _bss, _ebss;

void Reset_Handler(void) {
    unsigned int *src = &_etext;
    unsigned int *dst = &_data;
    while (dst < &_edata) {
        *dst++ = *src++;
    }
    dst = &_bss;
    while (dst < &_ebss) {
        *dst++ = 0;
    }
    main();
    for (;;) {
        /* halt if main returns */
    }
}
```

### Section Placement Reminders

```c
int initialized_var = 42;     /* .data */
int uninitialized_var;        /* .bss */
const int constant_var = 100; /* .rodata */

void example_function(void) {
    static int static_var = 10; /* .data */
    static int static_uninit;   /* .bss */
}
```

---

## Bit Manipulation Helpers

Bit ops are daily drivers for GPIO, flags, and control registers. Prefer unsigned types and `1U` shifts.

```c
/* bit_helpers.c — host-runnable */
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>

static inline uint32_t bit_mask(unsigned bit) {
    return 1u << bit;
}

static inline void set_bit(uint32_t *reg, unsigned bit) {
    *reg |= bit_mask(bit);
}

static inline void clear_bit(uint32_t *reg, unsigned bit) {
    *reg &= ~bit_mask(bit);
}

static inline void toggle_bit(uint32_t *reg, unsigned bit) {
    *reg ^= bit_mask(bit);
}

static inline bool test_bit(uint32_t reg, unsigned bit) {
    return (reg & bit_mask(bit)) != 0u;
}

/* Multi-bit field helpers (field in [lsb, lsb+width)) */
static inline void write_field(uint32_t *reg, unsigned lsb, unsigned width,
                               uint32_t value) {
    uint32_t mask = ((1u << width) - 1u) << lsb;
    *reg = (*reg & ~mask) | ((value << lsb) & mask);
}

static inline uint32_t read_field(uint32_t reg, unsigned lsb, unsigned width) {
    return (reg >> lsb) & ((1u << width) - 1u);
}

int main(void) {
    uint32_t gpio = 0;

    set_bit(&gpio, 3);
    set_bit(&gpio, 1);
    printf("after set 3 and 1: 0x%08X\n", gpio);

    clear_bit(&gpio, 1);
    printf("after clear 1:     0x%08X\n", gpio);

    toggle_bit(&gpio, 3);
    toggle_bit(&gpio, 3);
    printf("after toggle 3 x2: 0x%08X (bit3=%d)\n",
           gpio, test_bit(gpio, 3));

    /* e.g. mode field bits [5:4] = 0b10 */
    write_field(&gpio, 4, 2, 0x2);
    printf("field[5:4]=%u reg=0x%08X\n",
           read_field(gpio, 4, 2), gpio);

    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o bit_helpers bit_helpers.c
./bit_helpers
```

**Macro form** (common in headers; use carefully with side-effect arguments):

```c
#define SET_BIT(reg, bit)    ((reg) |=  (1U << (bit)))
#define CLEAR_BIT(reg, bit)  ((reg) &= ~(1U << (bit)))
#define TOGGLE_BIT(reg, bit) ((reg) ^=  (1U << (bit)))
#define CHECK_BIT(reg, bit)  (((reg) >> (bit)) & 1U)
```

**Shift safety:** shifting by ≥ width of the type is undefined. Keep `bit < 32` for `uint32_t`.

---

## `volatile` — Why Embedded Needs It

The compiler may cache memory values in registers or remove “useless” reads/writes. Memory-mapped registers and variables shared with ISRs **change outside the abstract machine**. Mark them `volatile` so each access in the source becomes a real access.

```c
/* volatile_demo.c */
#include <stdio.h>
#include <stdint.h>

/* Simulated peripheral register (on bare metal this would be MMIO) */
static volatile uint32_t FAKE_UART_STATUS;
static volatile uint32_t FAKE_UART_DATA;

#define STATUS_RX_FULL (1u << 0)

static void hw_sim_inject(char c) {
    FAKE_UART_DATA = (uint32_t)(unsigned char)c;
    FAKE_UART_STATUS |= STATUS_RX_FULL;
}

static char uart_getc_blocking(void) {
    /* Without volatile on STATUS, an optimizer could read once and loop forever */
    while ((FAKE_UART_STATUS & STATUS_RX_FULL) == 0u) {
        /* spin — in real chips an IRQ or WFI would be better */
    }
    char c = (char)FAKE_UART_DATA;
    FAKE_UART_STATUS &= ~STATUS_RX_FULL;
    return c;
}

int main(void) {
    hw_sim_inject('Z');
    char c = uart_getc_blocking();
    printf("received: %c\n", c);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -O2 -o volatile_demo volatile_demo.c
./volatile_demo
```

**Rules of thumb:**

- MMIO registers: `volatile` (often via pointer typedef).  
- Flags set in an ISR, read in main: `volatile`.  
- `volatile` is **not** a substitute for mutexes on multi-core or for atomic RMW correctness across threads — it only limits *compiler* optimizations on that object.  

---

## Packed Structs

Compilers insert padding for alignment. Hardware register maps and wire formats often need **exact** layouts. Use packing attributes carefully (unaligned access cost/faults on some CPUs).

```c
/* packed_structs.c */
#include <stdio.h>
#include <stdint.h>
#include <stddef.h>

struct Loose {
    uint8_t  a;
    uint32_t b;
    uint8_t  c;
};

struct Packed {
    uint8_t  a;
    uint32_t b;
    uint8_t  c;
} __attribute__((packed));

/* Bit-fields: handy for docs; packing/order is implementation-defined — verify */
struct StatusBits {
    uint8_t ready : 1;
    uint8_t error : 1;
    uint8_t mode  : 2;
    uint8_t       : 4; /* padding bits */
};

int main(void) {
    printf("sizeof(Loose)  = %zu\n", sizeof(struct Loose));
    printf("sizeof(Packed) = %zu\n", sizeof(struct Packed));
    printf("offset b Loose  = %zu\n", offsetof(struct Loose, b));
    printf("offset b Packed = %zu\n", offsetof(struct Packed, b));

    struct Packed p = { .a = 1, .b = 0x11223344u, .c = 0xFE };
    const unsigned char *bytes = (const unsigned char *)&p;
    printf("Packed bytes:");
    for (size_t i = 0; i < sizeof p; i++) {
        printf(" %02X", bytes[i]);
    }
    printf("\n");

    struct StatusBits st = { .ready = 1, .error = 0, .mode = 3 };
    printf("status ready=%u error=%u mode=%u\n", st.ready, st.error, st.mode);
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o packed_structs packed_structs.c
./packed_structs
```

On a typical 64-bit Linux host, `Loose` is larger than 6 bytes due to padding; `Packed` is 6 bytes. Always check with `sizeof` / `offsetof` for your ABI.

---

## Memory-Mapped Register Pattern as Struct Overlay

On hardware, a peripheral’s registers sit at a fixed address. In C you often overlay a `struct` on that address. On the host, overlay the same struct on a **byte buffer** to practice without silicon.

```c
/* mmio_overlay.c — simulate a tiny GPIO block in a buffer */
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdbool.h>

typedef struct {
    volatile uint32_t DIR;    /* 0x00: 1 = output */
    volatile uint32_t DATA;   /* 0x04: pin levels */
    volatile uint32_t SET;    /* 0x08: write 1 to set bit in DATA */
    volatile uint32_t CLEAR;  /* 0x0C: write 1 to clear bit in DATA */
} GpioBlock;

/* Host “device memory” */
static uint8_t device_mem[sizeof(GpioBlock)];

static GpioBlock *gpio_at_buffer(void) {
    return (GpioBlock *)(void *)device_mem;
}

/* Emulate SET/CLEAR side effects a real peripheral would do in hardware */
static void gpio_bus_write(GpioBlock *g, volatile uint32_t *reg, uint32_t value) {
    if (reg == &g->SET) {
        g->DATA |= value;
    } else if (reg == &g->CLEAR) {
        g->DATA &= ~value;
    } else {
        *reg = value;
    }
}

static void gpio_init_outputs(GpioBlock *g, uint32_t mask) {
    gpio_bus_write(g, &g->DIR, g->DIR | mask);
}

static void gpio_set_pins(GpioBlock *g, uint32_t mask) {
    gpio_bus_write(g, &g->SET, mask);
}

static void gpio_clear_pins(GpioBlock *g, uint32_t mask) {
    gpio_bus_write(g, &g->CLEAR, mask);
}

int main(void) {
    memset(device_mem, 0, sizeof device_mem);
    GpioBlock *gpio = gpio_at_buffer();

    const uint32_t LED = (1u << 0);
    gpio_init_outputs(gpio, LED);

    gpio_set_pins(gpio, LED);
    printf("DIR=0x%X DATA=0x%X (LED on)\n", gpio->DIR, gpio->DATA);

    gpio_clear_pins(gpio, LED);
    printf("DIR=0x%X DATA=0x%X (LED off)\n", gpio->DIR, gpio->DATA);

    /* On bare metal you would instead write:
     *   #define GPIOA ((GpioBlock *)0x40020000u)
     *   GPIOA->DIR |= LED;
     * with the real memory map — never do that to a random address on Linux.
     */
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o mmio_overlay mmio_overlay.c
./mmio_overlay
```

**Bare-metal sketch (do not run as a normal Linux userspace poke):**

```c
#define GPIOA_BASE 0x40020000u
#define GPIOA ((volatile GpioBlock *)GPIOA_BASE)
```

---

## Software Model: Button Debounce State Machine

Mechanical buttons bounce. A small state machine filters chatter before you act on a press/release.

```c
/* button_debounce_fsm.c */
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

typedef enum {
    BTN_IDLE,
    BTN_DEBOUNCE_PRESS,
    BTN_PRESSED,
    BTN_DEBOUNCE_RELEASE
} BtnState;

typedef struct {
    BtnState state;
    uint32_t ticks;       /* time spent in current state */
    uint32_t threshold;   /* ticks required to accept transition */
    bool     stable_down; /* debounced level: true = pressed */
} BtnFsm;

static void btn_init(BtnFsm *b, uint32_t threshold) {
    memset(b, 0, sizeof *b);
    b->state = BTN_IDLE;
    b->threshold = threshold;
}

/* raw_down: instantaneous sample (active high here) */
static void btn_update(BtnFsm *b, bool raw_down) {
    switch (b->state) {
        case BTN_IDLE:
            if (raw_down) {
                b->state = BTN_DEBOUNCE_PRESS;
                b->ticks = 0;
            }
            break;

        case BTN_DEBOUNCE_PRESS:
            if (!raw_down) {
                b->state = BTN_IDLE;
                b->ticks = 0;
            } else if (++b->ticks >= b->threshold) {
                b->state = BTN_PRESSED;
                b->stable_down = true;
                printf("event: PRESS accepted\n");
            }
            break;

        case BTN_PRESSED:
            if (!raw_down) {
                b->state = BTN_DEBOUNCE_RELEASE;
                b->ticks = 0;
            }
            break;

        case BTN_DEBOUNCE_RELEASE:
            if (raw_down) {
                b->state = BTN_PRESSED;
                b->ticks = 0;
            } else if (++b->ticks >= b->threshold) {
                b->state = BTN_IDLE;
                b->stable_down = false;
                printf("event: RELEASE accepted\n");
            }
            break;
    }
}

/* Simulated noisy waveform: 0=up, 1=down. Called once per “ms”. */
int main(void) {
    BtnFsm btn;
    btn_init(&btn, 3);  /* need 3 stable samples */

    /* bounce on press, solid hold, bounce on release */
    const char *wave =
        "000"          /* idle */
        "10110111"     /* noisy press */
        "1111111"      /* held */
        "01001000"     /* noisy release */
        "00000";

    printf("raw sequence (1=down): %s\n", wave);
    for (size_t i = 0; wave[i] != '\0'; i++) {
        bool raw = (wave[i] == '1');
        btn_update(&btn, raw);
        printf("t=%02zu raw=%d state=%d stable=%d\n",
               i, raw, (int)btn.state, btn.stable_down);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o button_debounce_fsm button_debounce_fsm.c
./button_debounce_fsm
```

Tune `threshold` to your sample rate (e.g. 20 ms at 1 kHz sampling → threshold 20).

---

## Classic Patterns (Still Useful)

### LED Blink Superloop (conceptual MMIO)

```c
#include <stdint.h>

#define GPIO_PORT_ADDR 0x40020000u
#define GPIO_DIR  (*(volatile uint32_t *)(GPIO_PORT_ADDR + 0x00))
#define GPIO_DATA (*(volatile uint32_t *)(GPIO_PORT_ADDR + 0x04))
#define LED_PIN 0

/* On host, prefer the buffer overlay example — these addresses are not yours. */

void delay(volatile uint32_t count) {
    while (count--) {
        __asm__ volatile("nop");
    }
}

void led_init(void) {
    GPIO_DIR |= (1u << LED_PIN);
}

int main(void) {
    led_init();
    for (;;) {
        GPIO_DATA |= (1u << LED_PIN);
        delay(1000000);
        GPIO_DATA &= ~(1u << LED_PIN);
        delay(1000000);
    }
}
```

### Interrupt Sketch

```c
void UART_IRQHandler(void) {
    uint32_t status = UART_STATUS_REG;
    if (status & UART_RX_INTERRUPT) {
        char data = (char)UART_DATA_REG;
        process_received_data(data);
        UART_STATUS_REG = UART_RX_INTERRUPT; /* clear */
    }
}
```

Keep ISRs short: set flags / push to a ring buffer; do heavy work in the main loop.

### Timing

Busy-wait delays waste power and drift with optimization and clock changes. Prefer hardware timers or a SysTick counter for production firmware. Software `nop` loops are only for crude bring-up.

---

## Practical Host Lab: Mini “Firmware” Module

Combine bits + overlay + FSM in one translation unit you can test on Linux.

```c
/* mini_fw_sim.c */
#include <stdio.h>
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

typedef struct {
    volatile uint32_t DIR;
    volatile uint32_t DATA;
} SimpleGpio;

static uint8_t ram[sizeof(SimpleGpio)];
static SimpleGpio *GPIO;

static inline void set_bit_u32(volatile uint32_t *r, unsigned b) {
    *r |= (1u << b);
}
static inline void clear_bit_u32(volatile uint32_t *r, unsigned b) {
    *r &= ~(1u << b);
}

#define LED 0u
#define BTN 1u

typedef enum { S_OFF, S_ON } LedMode;

int main(void) {
    memset(ram, 0, sizeof ram);
    GPIO = (SimpleGpio *)(void *)ram;

    set_bit_u32(&GPIO->DIR, LED);    /* LED out */
    clear_bit_u32(&GPIO->DIR, BTN);  /* BTN in  */

    LedMode mode = S_OFF;
    /* Pretend samples of button (active high) every step */
    const int samples[] = {0, 0, 1, 1, 1, 1, 0, 0};
    int stable = 0;
    int last = 0;

    for (size_t i = 0; i < sizeof samples / sizeof samples[0]; i++) {
        int raw = samples[i];
        if (raw == last) {
            stable++;
        } else {
            stable = 0;
            last = raw;
        }
        if (stable == 2 && raw == 1) {
            mode = (mode == S_OFF) ? S_ON : S_OFF;
            printf("toggle -> %s\n", mode == S_ON ? "ON" : "OFF");
        }
        if (mode == S_ON) {
            set_bit_u32(&GPIO->DATA, LED);
        } else {
            clear_bit_u32(&GPIO->DATA, LED);
        }
        printf("i=%zu raw=%d DATA=0x%X\n", i, raw, GPIO->DATA);
    }
    return 0;
}
```

```bash
gcc -std=c17 -Wall -Wextra -o mini_fw_sim mini_fw_sim.c
./mini_fw_sim
```

---

## Exercises

### Exercise 1 — Bit library

Implement `set`, `clear`, `toggle`, `test`, and `write_field` / `read_field` in a small header. Write tests that print expected masks for bits 0, 7, 31 on `uint32_t`. Reject `bit >= 32` safely.

```bash
gcc -std=c17 -Wall -Wextra -o bit_tests bit_tests.c
```

### Exercise 2 — Packed vs unpacked

Define a packet:

```text
u8 type; u16 length; u8 flags; u32 crc;
```

Print `sizeof` and offsets with and without `__attribute__((packed))`. Serialize to a `uint8_t` buffer with explicit byte writes (portable) and compare to a packed memcpy approach.

### Exercise 3 — Overlay UART

Model a UART with `STATUS` (RX_FULL, TX_EMPTY) and `DATA` registers in a buffer. Write `uart_putc` / `uart_getc` that spin on flags. Inject bytes from `main` by writing the buffer as the “hardware” would.

### Exercise 4 — Debounce FSM extension

Add a long-press state: if pressed longer than `L` ticks, emit `LONG_PRESS` once. Draw the state diagram in comments.

### Exercise 5 — Cross-compile dry run

If `arm-none-eabi-gcc` is installed, compile a tiny `main` that only returns 0:

```bash
arm-none-eabi-gcc -std=c17 -Wall -Wextra -mcpu=cortex-m3 -mthumb \
  -c -o main.o main.c
arm-none-eabi-size main.o
```

Note: without startup and a linker script you will not produce a full flashable image; the goal is to confirm the cross compiler runs and inspect section sizes.

### Exercise 6 — Volatile experiment

Write a loop waiting on a non-volatile global that a second function would change (on one core with `-O2`, the wait may spin forever if the compiler caches the load). Then mark the flag `volatile` and show the wait completes when you flip the flag between calls (e.g. cooperative single-thread simulation).

---

## Summary

Embedded C fundamentals covered here:

1. **Architecture** — MCU vs MPU, memory map, startup and sections  
2. **Cross-compilation** — role of `arm-none-eabi-gcc`, flags, linker script, objcopy  
3. **Bit helpers** — set/clear/toggle/test and field pack/unpack  
4. **`volatile`** — MMIO and ISR-shared flags; not a lock  
5. **Packed structs** — layout control and portability caveats  
6. **Struct overlay** — register blocks on real addresses or host buffers  
7. **Debounce FSM** — software model for noisy digital inputs  
8. **Host labs** — practice patterns safely with Linux `gcc`  

Next chapters go deeper into low-level techniques, embedded-specific C patterns, real-time structure, and hardware interfaces.
