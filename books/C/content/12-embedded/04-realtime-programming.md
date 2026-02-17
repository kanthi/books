# Real-time Programming

## Introduction

Real-time programming in embedded systems requires deterministic behavior, precise timing control, and efficient resource management. This chapter explores the principles and techniques for developing real-time embedded applications, including scheduling strategies, timing analysis, and meeting strict temporal constraints.

## Real-time System Characteristics

Real-time systems must respond to events within specified time constraints. Understanding these constraints is fundamental to successful real-time programming.

### Types of Real-time Systems

1. **Hard Real-time Systems** - Missed deadlines can cause catastrophic failures
   - Examples: Aircraft control systems, medical devices, automotive safety systems

2. **Soft Real-time Systems** - Missed deadlines degrade performance but don't cause failures
   - Examples: Multimedia streaming, user interfaces, gaming

3. **Firm Real-time Systems** - Some deadlines can be missed with limited consequences
   - Examples: Industrial process control, data logging

### Real-time Requirements

```c
#include <stdint.h>
#include <stdbool.h>

// Real-time task structure
typedef struct {
    void (*function)(void);     // Task function
    uint32_t period;            // Task period in milliseconds
    uint32_t deadline;          // Task deadline in milliseconds
    uint32_t execution_time;    // Worst-case execution time
    uint32_t next_release;      // Next release time
    uint8_t priority;           // Task priority
    bool enabled;               // Task enabled flag
} rt_task_t;

// Real-time system parameters
typedef struct {
    uint32_t system_time;       // Current system time
    uint32_t max_response_time; // Maximum observed response time
    uint32_t missed_deadlines;  // Count of missed deadlines
} rt_system_t;

static rt_system_t rt_system;
```

## Task Scheduling

Effective task scheduling is crucial for meeting real-time constraints while maximizing system utilization.

### Rate Monotonic Scheduling (RMS)

Rate Monotonic Scheduling assigns priorities based on task periods - shorter periods get higher priorities.

```c
#include <stdint.h>
#include <stdbool.h>

#define MAX_TASKS 16

static rt_task_t task_list[MAX_TASKS];
static uint8_t task_count = 0;

// Add task to system
int rt_add_task(void (*function)(void), uint32_t period, uint32_t deadline, 
                uint32_t execution_time, uint8_t priority) {
    if (task_count >= MAX_TASKS) {
        return -1;  // Task list full
    }
    
    task_list[task_count].function = function;
    task_list[task_count].period = period;
    task_list[task_count].deadline = deadline;
    task_list[task_count].execution_time = execution_time;
    task_list[task_count].next_release = period;
    task_list[task_count].priority = priority;
    task_list[task_count].enabled = true;
    
    task_count++;
    return 0;
}

// Rate Monotonic priority assignment
void rt_assign_rm_priorities(void) {
    // Sort tasks by period (shortest first)
    for (int i = 0; i < task_count - 1; i++) {
        for (int j = 0; j < task_count - i - 1; j++) {
            if (task_list[j].period > task_list[j + 1].period) {
                // Swap tasks
                rt_task_t temp = task_list[j];
                task_list[j] = task_list[j + 1];
                task_list[j + 1] = temp;
            }
        }
    }
    
    // Assign priorities (higher number = higher priority)
    for (int i = 0; i < task_count; i++) {
        task_list[i].priority = task_count - i;
    }
}

// Check Rate Monotonic schedulability
bool rt_check_rm_schedulability(void) {
    // Calculate total utilization
    double total_utilization = 0.0;
    
    for (int i = 0; i < task_count; i++) {
        double utilization = (double)task_list[i].execution_time / task_list[i].period;
        total_utilization += utilization;
    }
    
    // Rate Monotonic bound: n * (2^(1/n) - 1)
    double rm_bound = task_count * (pow(2.0, 1.0/task_count) - 1.0);
    
    return (total_utilization <= rm_bound);
}
```

### Earliest Deadline First (EDF) Scheduling

EDF scheduling dynamically assigns priorities based on task deadlines.

```c
// Find highest priority task (earliest deadline)
int rt_find_highest_priority_task(void) {
    int highest_priority_task = -1;
    uint32_t earliest_deadline = UINT32_MAX;
    
    for (int i = 0; i < task_count; i++) {
        if (task_list[i].enabled && 
            task_list[i].next_release <= rt_system.system_time &&
            task_list[i].deadline < earliest_deadline) {
            earliest_deadline = task_list[i].deadline;
            highest_priority_task = i;
        }
    }
    
    return highest_priority_task;
}

// Update task deadlines
void rt_update_deadlines(void) {
    for (int i = 0; i < task_count; i++) {
        if (task_list[i].enabled) {
            // If task is ready to run
            if (rt_system.system_time >= task_list[i].next_release) {
                // Set absolute deadline
                task_list[i].deadline = task_list[i].next_release + 
                                      task_list[i].period;
            }
        }
    }
}
```

## Timing and Synchronization

Precise timing control is essential for real-time systems.

### Timer Management

```c
#include <stdint.h>

// Timer structure
typedef struct {
    uint32_t reload_value;      // Timer reload value
    uint32_t current_value;     // Current timer value
    bool running;               // Timer running flag
    bool expired;               // Timer expired flag
    void (*callback)(void);     // Expiration callback
} timer_t;

#define MAX_TIMERS 8
static timer_t timers[MAX_TIMERS];

// Initialize timer system
void timer_init(void) {
    for (int i = 0; i < MAX_TIMERS; i++) {
        timers[i].running = false;
        timers[i].expired = false;
        timers[i].callback = NULL;
    }
    
    // Configure hardware timer
    // TIM2->PSC = SystemCoreClock / 1000000 - 1;  // 1MHz timer
    // TIM2->ARR = 999;  // 1ms interrupt
    // TIM2->DIER |= TIM_DIER_UIE;  // Enable update interrupt
    // TIM2->CR1 |= TIM_CR1_CEN;    // Start timer
}

// Create timer
int timer_create(uint32_t milliseconds, void (*callback)(void)) {
    for (int i = 0; i < MAX_TIMERS; i++) {
        if (!timers[i].running) {
            timers[i].reload_value = milliseconds;
            timers[i].current_value = milliseconds;
            timers[i].callback = callback;
            timers[i].running = true;
            timers[i].expired = false;
            return i;
        }
    }
    return -1;  // No free timers
}

// Timer tick handler (called by timer interrupt)
void timer_tick_handler(void) {
    rt_system.system_time++;
    
    // Update all running timers
    for (int i = 0; i < MAX_TIMERS; i++) {
        if (timers[i].running) {
            if (timers[i].current_value > 0) {
                timers[i].current_value--;
            }
            
            if (timers[i].current_value == 0) {
                timers[i].expired = true;
                timers[i].running = false;
                
                if (timers[i].callback) {
                    timers[i].callback();
                }
            }
        }
    }
    
    // Update task deadlines
    rt_update_deadlines();
}

// Get system time
uint32_t rt_get_system_time(void) {
    return rt_system.system_time;
}

// Delay function (blocking)
void rt_delay_ms(uint32_t milliseconds) {
    uint32_t start_time = rt_system.system_time;
    while ((rt_system.system_time - start_time) < milliseconds) {
        // Wait
    }
}
```

### Semaphore Implementation

Semaphores provide synchronization between tasks and ISRs.

```c
#include <stdint.h>
#include <stdbool.h>

#define MAX_SEMAPHORES 16

typedef struct {
    volatile int32_t count;     // Semaphore count
    uint8_t max_count;          // Maximum count
    bool initialized;           // Initialization flag
} semaphore_t;

static semaphore_t semaphores[MAX_SEMAPHORES];

// Initialize semaphore
int sem_init(uint8_t sem_id, uint8_t initial_count, uint8_t max_count) {
    if (sem_id >= MAX_SEMAPHORES) {
        return -1;
    }
    
    semaphores[sem_id].count = initial_count;
    semaphores[sem_id].max_count = max_count;
    semaphores[sem_id].initialized = true;
    
    return 0;
}

// Wait on semaphore (blocking)
int sem_wait(uint8_t sem_id) {
    if (sem_id >= MAX_SEMAPHORES || !semaphores[sem_id].initialized) {
        return -1;
    }
    
    // Disable interrupts to ensure atomic operation
    uint32_t primask = __get_PRIMASK();
    __disable_irq();
    
    while (semaphores[sem_id].count <= 0) {
        // Re-enable interrupts and wait
        __set_PRIMASK(primask);
        
        // In a real RTOS, this would yield to other tasks
        // For simple implementation, just wait
        __asm__ volatile ("nop");
        
        // Disable interrupts again
        __disable_irq();
    }
    
    semaphores[sem_id].count--;
    
    // Restore interrupt state
    __set_PRIMASK(primask);
    
    return 0;
}

// Signal semaphore (non-blocking)
int sem_signal(uint8_t sem_id) {
    if (sem_id >= MAX_SEMAPHORES || !semaphores[sem_id].initialized) {
        return -1;
    }
    
    // Disable interrupts to ensure atomic operation
    uint32_t primask = __get_PRIMASK();
    __disable_irq();
    
    if (semaphores[sem_id].count < semaphores[sem_id].max_count) {
        semaphores[sem_id].count++;
    }
    
    // Restore interrupt state
    __set_PRIMASK(primask);
    
    return 0;
}

// Try wait on semaphore (non-blocking)
int sem_try_wait(uint8_t sem_id) {
    if (sem_id >= MAX_SEMAPHORES || !semaphores[sem_id].initialized) {
        return -1;
    }
    
    // Disable interrupts to ensure atomic operation
    uint32_t primask = __get_PRIMASK();
    __disable_irq();
    
    int result = -1;
    if (semaphores[sem_id].count > 0) {
        semaphores[sem_id].count--;
        result = 0;
    }
    
    // Restore interrupt state
    __set_PRIMASK(primask);
    
    return result;
}
```

## Interrupt Handling in Real-time Systems

Proper interrupt management is crucial for maintaining real-time performance.

### Interrupt Latency Management

```c
#include <stdint.h>

// Measure interrupt latency
static volatile uint32_t interrupt_timestamp = 0;
static volatile uint32_t interrupt_latency = 0;

// Interrupt service routine with latency measurement
void EXTI0_IRQHandler(void) {
    // Record interrupt entry time
    interrupt_timestamp = rt_system.system_time;
    
    // Clear interrupt flag
    // EXTI->PR = EXTI_PR_PR0;
    
    // Process interrupt
    process_external_interrupt();
    
    // Calculate latency
    interrupt_latency = rt_system.system_time - interrupt_timestamp;
}

// Critical section management
typedef struct {
    uint32_t primask;
    bool interrupts_disabled;
} critical_section_t;

// Enter critical section
critical_section_t enter_critical_section(void) {
    critical_section_t cs;
    cs.primask = __get_PRIMASK();
    __disable_irq();
    cs.interrupts_disabled = true;
    return cs;
}

// Exit critical section
void exit_critical_section(critical_section_t cs) {
    if (cs.interrupts_disabled) {
        __set_PRIMASK(cs.primask);
    }
}

// Deferred interrupt processing
#define INTERRUPT_QUEUE_SIZE 16

typedef enum {
    INTERRUPT_TYPE_GPIO,
    INTERRUPT_TYPE_UART,
    INTERRUPT_TYPE_TIMER
} interrupt_type_t;

typedef struct {
    interrupt_type_t type;
    uint32_t data;
    uint32_t timestamp;
} interrupt_event_t;

static interrupt_event_t interrupt_queue[INTERRUPT_QUEUE_SIZE];
static volatile uint8_t queue_head = 0;
static volatile uint8_t queue_tail = 0;
static volatile uint8_t queue_count = 0;

// Add interrupt event to queue
void queue_interrupt_event(interrupt_type_t type, uint32_t data) {
    critical_section_t cs = enter_critical_section();
    
    if (queue_count < INTERRUPT_QUEUE_SIZE) {
        interrupt_queue[queue_head].type = type;
        interrupt_queue[queue_head].data = data;
        interrupt_queue[queue_head].timestamp = rt_system.system_time;
        
        queue_head = (queue_head + 1) % INTERRUPT_QUEUE_SIZE;
        queue_count++;
    }
    
    exit_critical_section(cs);
}

// Process queued interrupts
void process_interrupt_queue(void) {
    while (queue_count > 0) {
        critical_section_t cs = enter_critical_section();
        
        interrupt_event_t event = interrupt_queue[queue_tail];
        queue_tail = (queue_tail + 1) % INTERRUPT_QUEUE_SIZE;
        queue_count--;
        
        exit_critical_section(cs);
        
        // Process the event
        switch (event.type) {
            case INTERRUPT_TYPE_GPIO:
                process_gpio_interrupt(event.data);
                break;
            case INTERRUPT_TYPE_UART:
                process_uart_interrupt(event.data);
                break;
            case INTERRUPT_TYPE_TIMER:
                process_timer_interrupt(event.data);
                break;
        }
    }
}
```

## Resource Management

Efficient resource management is essential for predictable real-time behavior.

### Memory Pool Management

```c
#include <stdint.h>
#include <stdbool.h>
#include <string.h>

#define MEMORY_POOL_SIZE 1024
#define BLOCK_SIZE 32
#define NUM_BLOCKS (MEMORY_POOL_SIZE / BLOCK_SIZE)

typedef struct {
    uint8_t pool[MEMORY_POOL_SIZE];
    bool block_used[NUM_BLOCKS];
    uint8_t free_blocks;
} memory_pool_t;

static memory_pool_t memory_pool;

// Initialize memory pool
void mem_pool_init(void) {
    memset(memory_pool.block_used, 0, sizeof(memory_pool.block_used));
    memory_pool.free_blocks = NUM_BLOCKS;
}

// Allocate memory block
void* mem_pool_alloc(void) {
    critical_section_t cs = enter_critical_section();
    
    if (memory_pool.free_blocks == 0) {
        exit_critical_section(cs);
        return NULL;  // No free blocks
    }
    
    // Find free block
    for (int i = 0; i < NUM_BLOCKS; i++) {
        if (!memory_pool.block_used[i]) {
            memory_pool.block_used[i] = true;
            memory_pool.free_blocks--;
            exit_critical_section(cs);
            return &memory_pool.pool[i * BLOCK_SIZE];
        }
    }
    
    exit_critical_section(cs);
    return NULL;  // Should not reach here
}

// Free memory block
void mem_pool_free(void* ptr) {
    if (ptr == NULL) return;
    
    // Calculate block index
    uintptr_t offset = (uintptr_t)ptr - (uintptr_t)memory_pool.pool;
    uint32_t block_index = offset / BLOCK_SIZE;
    
    if (block_index < NUM_BLOCKS) {
        critical_section_t cs = enter_critical_section();
        if (memory_pool.block_used[block_index]) {
            memory_pool.block_used[block_index] = false;
            memory_pool.free_blocks++;
        }
        exit_critical_section(cs);
    }
}
```

### Priority Inheritance

Priority inheritance prevents priority inversion in resource sharing.

```c
#include <stdint.h>
#include <stdbool.h>

#define MAX_PRIORITY 255

typedef struct {
    uint8_t original_priority;
    uint8_t current_priority;
    bool owned;
    uint8_t owner_task_id;
} resource_t;

#define MAX_RESOURCES 16
static resource_t resources[MAX_RESOURCES];

// Initialize resource
void resource_init(uint8_t resource_id) {
    if (resource_id < MAX_RESOURCES) {
        resources[resource_id].original_priority = 0;
        resources[resource_id].current_priority = 0;
        resources[resource_id].owned = false;
        resources[resource_id].owner_task_id = 0;
    }
}

// Acquire resource with priority inheritance
int resource_acquire(uint8_t resource_id, uint8_t task_id, uint8_t task_priority) {
    if (resource_id >= MAX_RESOURCES) {
        return -1;
    }
    
    critical_section_t cs = enter_critical_section();
    
    if (!resources[resource_id].owned) {
        // Resource is free, acquire it
        resources[resource_id].owned = true;
        resources[resource_id].owner_task_id = task_id;
        resources[resource_id].original_priority = task_priority;
        resources[resource_id].current_priority = task_priority;
    } else {
        // Resource is owned by another task
        uint8_t owner_id = resources[resource_id].owner_task_id;
        
        // Check if priority inversion would occur
        if (task_priority > resources[resource_id].current_priority) {
            // Apply priority inheritance
            resources[resource_id].current_priority = task_priority;
            // In a real system, you would boost the owner task's priority
            task_list[owner_id].priority = task_priority;
        }
        
        exit_critical_section(cs);
        return -2;  // Resource busy
    }
    
    exit_critical_section(cs);
    return 0;  // Success
}

// Release resource
int resource_release(uint8_t resource_id, uint8_t task_id) {
    if (resource_id >= MAX_RESOURCES) {
        return -1;
    }
    
    critical_section_t cs = enter_critical_section();
    
    if (resources[resource_id].owned && 
        resources[resource_id].owner_task_id == task_id) {
        // Release resource
        resources[resource_id].owned = false;
        resources[resource_id].owner_task_id = 0;
        // Restore original priority
        // In a real system, you would restore the owner task's original priority
    } else {
        exit_critical_section(cs);
        return -2;  // Not owner or not owned
    }
    
    exit_critical_section(cs);
    return 0;  // Success
}
```

## Timing Analysis and Deadline Monitoring

Monitoring and analyzing timing behavior ensures real-time constraints are met.

### Deadline Monitoring

```c
#include <stdint.h>
#include <stdbool.h>

// Task execution tracking
typedef struct {
    uint32_t start_time;
    uint32_t end_time;
    uint32_t execution_time;
    uint32_t deadline;
    bool deadline_missed;
} task_execution_t;

#define EXECUTION_HISTORY_SIZE 32
static task_execution_t execution_history[MAX_TASKS][EXECUTION_HISTORY_SIZE];
static uint8_t history_index[MAX_TASKS] = {0};

// Start task execution tracking
void task_start_execution(uint8_t task_id) {
    if (task_id < MAX_TASKS) {
        execution_history[task_id][history_index[task_id]].start_time = 
            rt_system.system_time;
        execution_history[task_id][history_index[task_id]].deadline = 
            task_list[task_id].deadline;
    }
}

// End task execution tracking
void task_end_execution(uint8_t task_id) {
    if (task_id < MAX_TASKS) {
        uint8_t idx = history_index[task_id];
        execution_history[task_id][idx].end_time = rt_system.system_time;
        execution_history[task_id][idx].execution_time = 
            execution_history[task_id][idx].end_time - 
            execution_history[task_id][idx].start_time;
        
        // Check for deadline miss
        if (rt_system.system_time > execution_history[task_id][idx].deadline) {
            execution_history[task_id][idx].deadline_missed = true;
            rt_system.missed_deadlines++;
        } else {
            execution_history[task_id][idx].deadline_missed = false;
        }
        
        // Update maximum response time
        if (execution_history[task_id][idx].execution_time > 
            rt_system.max_response_time) {
            rt_system.max_response_time = 
                execution_history[task_id][idx].execution_time;
        }
        
        // Advance history index
        history_index[task_id] = (history_index[task_id] + 1) % EXECUTION_HISTORY_SIZE;
    }
}

// Get task statistics
typedef struct {
    uint32_t avg_execution_time;
    uint32_t max_execution_time;
    uint32_t min_execution_time;
    uint32_t deadline_misses;
    double deadline_miss_rate;
} task_stats_t;

task_stats_t get_task_stats(uint8_t task_id) {
    task_stats_t stats = {0};
    
    if (task_id >= MAX_TASKS) {
        return stats;
    }
    
    uint32_t total_execution_time = 0;
    uint32_t valid_samples = 0;
    stats.max_execution_time = 0;
    stats.min_execution_time = UINT32_MAX;
    
    for (int i = 0; i < EXECUTION_HISTORY_SIZE; i++) {
        if (execution_history[task_id][i].end_time > 0) {
            uint32_t exec_time = execution_history[task_id][i].execution_time;
            total_execution_time += exec_time;
            valid_samples++;
            
            if (exec_time > stats.max_execution_time) {
                stats.max_execution_time = exec_time;
            }
            if (exec_time < stats.min_execution_time) {
                stats.min_execution_time = exec_time;
            }
            
            if (execution_history[task_id][i].deadline_missed) {
                stats.deadline_misses++;
            }
        }
    }
    
    if (valid_samples > 0) {
        stats.avg_execution_time = total_execution_time / valid_samples;
        stats.deadline_miss_rate = (double)stats.deadline_misses / valid_samples;
    }
    
    return stats;
}
```

## Practical Examples

### Real-time Control System

```c
#include <stdint.h>
#include <math.h>

// PID Controller
typedef struct {
    float kp;           // Proportional gain
    float ki;           // Integral gain
    float kd;           // Derivative gain
    float setpoint;     // Desired value
    float integral;     // Integral term
    float previous_error; // Previous error for derivative
    float output_min;   // Minimum output
    float output_max;   // Maximum output
} pid_controller_t;

// Initialize PID controller
void pid_init(pid_controller_t *pid, float kp, float ki, float kd,
              float output_min, float output_max) {
    pid->kp = kp;
    pid->ki = ki;
    pid->kd = kd;
    pid->setpoint = 0;
    pid->integral = 0;
    pid->previous_error = 0;
    pid->output_min = output_min;
    pid->output_max = output_max;
}

// Compute PID output
float pid_compute(pid_controller_t *pid, float feedback, float dt) {
    // Calculate error
    float error = pid->setpoint - feedback;
    
    // Proportional term
    float proportional = pid->kp * error;
    
    // Integral term
    pid->integral += error * dt;
    float integral = pid->ki * pid->integral;
    
    // Derivative term
    float derivative = pid->kd * (error - pid->previous_error) / dt;
    
    // Calculate output
    float output = proportional + integral + derivative;
    
    // Clamp output to limits
    if (output > pid->output_max) {
        output = pid->output_max;
        // Prevent integral windup
        pid->integral -= error * dt;
    } else if (output < pid->output_min) {
        output = pid->output_min;
        // Prevent integral windup
        pid->integral -= error * dt;
    }
    
    // Save error for next derivative calculation
    pid->previous_error = error;
    
    return output;
}

// Set PID setpoint
void pid_set_setpoint(pid_controller_t *pid, float setpoint) {
    pid->setpoint = setpoint;
}

// Real-time motor control task
static pid_controller_t motor_pid;
static float motor_position = 0.0;
static float motor_speed = 0.0;

void motor_control_task(void) {
    static uint32_t last_time = 0;
    uint32_t current_time = rt_system.system_time;
    float dt = (current_time - last_time) / 1000.0;  // Convert to seconds
    last_time = current_time;
    
    // Read motor position (simulated)
    // In real implementation: motor_position = read_encoder();
    
    // Compute PID output
    float control_output = pid_compute(&motor_pid, motor_position, dt);
    
    // Apply control output to motor
    // In real implementation: set_motor_pwm(control_output);
    
    // Update motor model (simulated)
    motor_speed = control_output;
    motor_position += motor_speed * dt;
}

// Initialize motor control system
void motor_control_init(void) {
    // Initialize PID controller
    pid_init(&motor_pid, 2.0, 1.0, 0.1, -100.0, 100.0);
    pid_set_setpoint(&motor_pid, 100.0);  // Set target position
    
    // Add motor control task (10ms period)
    rt_add_task(motor_control_task, 10, 10, 2, 0);
}
```

### Real-time Data Acquisition System

```c
#include <stdint.h>

// Data acquisition system
#define ADC_CHANNELS 8
#define SAMPLE_BUFFER_SIZE 256

typedef struct {
    uint16_t samples[ADC_CHANNELS][SAMPLE_BUFFER_SIZE];
    uint16_t write_index[ADC_CHANNELS];
    uint16_t read_index[ADC_CHANNELS];
    uint32_t sample_count[ADC_CHANNELS];
    uint32_t overrun_count[ADC_CHANNELS];
} data_acquisition_t;

static data_acquisition_t data_acq;

// Initialize data acquisition system
void data_acq_init(void) {
    for (int i = 0; i < ADC_CHANNELS; i++) {
        data_acq.write_index[i] = 0;
        data_acq.read_index[i] = 0;
        data_acq.sample_count[i] = 0;
        data_acq.overrun_count[i] = 0;
    }
}

// ADC interrupt handler
void ADC_IRQHandler(void) {
    static uint8_t current_channel = 0;
    
    // Read ADC value (simulated)
    // uint16_t adc_value = ADC1->DR;
    uint16_t adc_value = 0;  // Simulated value
    
    // Store sample
    uint16_t write_idx = data_acq.write_index[current_channel];
    data_acq.samples[current_channel][write_idx] = adc_value;
    
    // Update indices
    data_acq.write_index[current_channel] = (write_idx + 1) % SAMPLE_BUFFER_SIZE;
    data_acq.sample_count[current_channel]++;
    
    // Check for buffer overrun
    if (data_acq.write_index[current_channel] == data_acq.read_index[current_channel]) {
        data_acq.overrun_count[current_channel]++;
        // Handle overrun (e.g., increment read index to maintain FIFO behavior)
        data_acq.read_index[current_channel] = 
            (data_acq.read_index[current_channel] + 1) % SAMPLE_BUFFER_SIZE;
    }
    
    // Move to next channel
    current_channel = (current_channel + 1) % ADC_CHANNELS;
    
    // Configure ADC for next channel
    // ADC1->SQR3 = current_channel;  // Set channel in sequence register
}

// Read samples from buffer
int data_acq_read_samples(uint8_t channel, uint16_t *buffer, uint16_t max_samples) {
    if (channel >= ADC_CHANNELS) {
        return -1;
    }
    
    critical_section_t cs = enter_critical_section();
    
    uint16_t available_samples = 0;
    uint16_t read_idx = data_acq.read_index[channel];
    uint16_t write_idx = data_acq.write_index[channel];
    
    // Calculate available samples
    if (write_idx >= read_idx) {
        available_samples = write_idx - read_idx;
    } else {
        available_samples = SAMPLE_BUFFER_SIZE - read_idx + write_idx;
    }
    
    // Limit to requested samples
    if (available_samples > max_samples) {
        available_samples = max_samples;
    }
    
    // Copy samples
    for (uint16_t i = 0; i < available_samples; i++) {
        buffer[i] = data_acq.samples[channel][read_idx];
        read_idx = (read_idx + 1) % SAMPLE_BUFFER_SIZE;
    }
    
    // Update read index
    data_acq.read_index[channel] = read_idx;
    
    exit_critical_section(cs);
    
    return available_samples;
}

// Data processing task
void data_processing_task(void) {
    static uint16_t sample_buffer[64];
    
    // Process samples from channel 0
    int samples_read = data_acq_read_samples(0, sample_buffer, 64);
    
    if (samples_read > 0) {
        // Perform data processing (e.g., filtering, FFT, etc.)
        // process_samples(sample_buffer, samples_read);
    }
}

// Initialize data acquisition system
void data_acquisition_system_init(void) {
    data_acq_init();
    
    // Add data processing task (50ms period)
    rt_add_task(data_processing_task, 50, 50, 10, 0);
    
    // Enable ADC interrupt
    // NVIC_EnableIRQ(ADC_IRQn);
}
```

## Summary

Real-time programming in embedded systems requires careful consideration of:

1. **Scheduling Algorithms** - Rate Monotonic and Earliest Deadline First scheduling
2. **Timing Control** - Precise timer management and delay functions
3. **Synchronization** - Semaphores, mutexes, and critical sections
4. **Interrupt Handling** - Low-latency ISRs and deferred processing
5. **Resource Management** - Memory pools and priority inheritance
6. **Timing Analysis** - Deadline monitoring and performance measurement
7. **Control Systems** - PID controllers and real-time feedback loops

Key principles for successful real-time programming:
- Minimize interrupt latency and execution time
- Use deterministic algorithms and data structures
- Carefully manage shared resources to avoid priority inversion
- Monitor and analyze timing behavior to ensure constraints are met
- Implement proper error handling for missed deadlines
- Balance performance requirements with system complexity

These techniques enable developers to create reliable, predictable embedded systems that meet strict real-time requirements while efficiently utilizing limited system resources.