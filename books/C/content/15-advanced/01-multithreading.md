# Module 15.1: Multithreading in C

## Introduction

Multithreading is a powerful technique that allows programs to perform multiple tasks concurrently within a single process. In C programming, multithreading can significantly improve performance for CPU-intensive applications and enable responsive user interfaces. This module explores the fundamentals of multithreading using the POSIX Threads (pthreads) library, which is the standard threading API on Unix-like systems.

## Learning Objectives

By the end of this module, you will be able to:
- Understand the concepts of processes and threads
- Create and manage threads using the pthread library
- Implement thread synchronization mechanisms
- Handle thread communication and data sharing
- Debug and optimize multithreaded applications
- Apply best practices for thread safety

## 1. Fundamentals of Multithreading

### 1.1 Processes vs Threads

A **process** is an independent program execution unit that has its own memory space, file descriptors, and system resources. A **thread** is a lightweight subprocess that exists within a process and shares the process's resources.

Key differences:
- Processes have separate memory spaces; threads share memory
- Process creation is expensive; thread creation is relatively cheap
- Inter-process communication requires special mechanisms; threads can communicate directly through shared memory
- Processes are isolated; threads can affect each other if not properly synchronized

### 1.2 Thread Lifecycle

A thread goes through several states during its lifetime:
1. **New**: Thread is being created
2. **Runnable**: Thread is ready to run
3. **Running**: Thread is executing
4. **Blocked**: Thread is waiting for a resource
5. **Terminated**: Thread has finished execution

### 1.3 Thread Attributes

Threads can have various attributes that control their behavior:
- **Detached vs Joinable**: Detached threads clean up automatically; joinable threads require explicit joining
- **Scheduling policy**: Determines how the thread is scheduled (SCHED_FIFO, SCHED_RR, SCHED_OTHER)
- **Stack size**: Controls the amount of stack memory allocated to the thread

## 2. Creating and Managing Threads

### 2.1 Basic Thread Creation

The pthread library provides the `pthread_create()` function to create threads:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

// Thread function
void* thread_function(void* arg) {
    int thread_id = *(int*)arg;
    printf("Hello from thread %d\n", thread_id);
    
    // Simulate some work
    sleep(1);
    
    printf("Thread %d finishing\n", thread_id);
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int id1 = 1, id2 = 2;
    
    // Create threads
    if (pthread_create(&thread1, NULL, thread_function, &id1) != 0) {
        perror("pthread_create failed");
        exit(EXIT_FAILURE);
    }
    
    if (pthread_create(&thread2, NULL, thread_function, &id2) != 0) {
        perror("pthread_create failed");
        exit(EXIT_FAILURE);
    }
    
    // Wait for threads to complete
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("All threads completed\n");
    return 0;
}
```

### 2.2 Thread Arguments and Return Values

Threads can receive arguments and return values:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    int start;
    int end;
    long long sum;
} thread_data_t;

void* calculate_sum(void* arg) {
    thread_data_t* data = (thread_data_t*)arg;
    
    data->sum = 0;
    for (int i = data->start; i <= data->end; i++) {
        data->sum += i;
    }
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    thread_data_t data1 = {1, 50000000, 0};
    thread_data_t data2 = {50000001, 100000000, 0};
    
    // Create threads
    pthread_create(&thread1, NULL, calculate_sum, &data1);
    pthread_create(&thread2, NULL, calculate_sum, &data2);
    
    // Wait for completion
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    long long total_sum = data1.sum + data2.sum;
    printf("Sum of 1 to 100000000: %lld\n", total_sum);
    
    return 0;
}
```

## 3. Thread Synchronization

### 3.1 Race Conditions

A race condition occurs when multiple threads access shared data concurrently, and the outcome depends on the timing of their execution. Consider this problematic code:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int shared_counter = 0;

void* increment_counter(void* arg) {
    for (int i = 0; i < 1000000; i++) {
        shared_counter++;  // Race condition here!
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    
    pthread_create(&thread1, NULL, increment_counter, NULL);
    pthread_create(&thread2, NULL, increment_counter, NULL);
    
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("Expected: 2000000, Actual: %d\n", shared_counter);
    return 0;
}
```

### 3.2 Mutexes

Mutexes (mutual exclusions) are the most common synchronization primitive:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

int shared_counter = 0;
pthread_mutex_t counter_mutex = PTHREAD_MUTEX_INITIALIZER;

void* increment_counter(void* arg) {
    for (int i = 0; i < 1000000; i++) {
        pthread_mutex_lock(&counter_mutex);
        shared_counter++;
        pthread_mutex_unlock(&counter_mutex);
    }
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    
    pthread_create(&thread1, NULL, increment_counter, NULL);
    pthread_create(&thread2, NULL, increment_counter, NULL);
    
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    printf("Expected: 2000000, Actual: %d\n", shared_counter);
    
    pthread_mutex_destroy(&counter_mutex);
    return 0;
}
```

### 3.3 Condition Variables

Condition variables allow threads to wait for specific conditions:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

int buffer = -1;
int count = 0;
pthread_mutex_t buffer_mutex = PTHREAD_MUTEX_INITIALIZER;
pthread_cond_t buffer_not_empty = PTHREAD_COND_INITIALIZER;
pthread_cond_t buffer_not_full = PTHREAD_COND_INITIALIZER;

void* producer(void* arg) {
    for (int i = 0; i < 10; i++) {
        pthread_mutex_lock(&buffer_mutex);
        
        // Wait while buffer is full
        while (count == 1) {
            pthread_cond_wait(&buffer_not_full, &buffer_mutex);
        }
        
        buffer = i;
        count = 1;
        printf("Produced: %d\n", i);
        
        // Signal consumer that buffer is not empty
        pthread_cond_signal(&buffer_not_empty);
        pthread_mutex_unlock(&buffer_mutex);
        
        sleep(1);  // Simulate work
    }
    return NULL;
}

void* consumer(void* arg) {
    for (int i = 0; i < 10; i++) {
        pthread_mutex_lock(&buffer_mutex);
        
        // Wait while buffer is empty
        while (count == 0) {
            pthread_cond_wait(&buffer_not_empty, &buffer_mutex);
        }
        
        int item = buffer;
        count = 0;
        printf("Consumed: %d\n", item);
        
        // Signal producer that buffer is not full
        pthread_cond_signal(&buffer_not_full);
        pthread_mutex_unlock(&buffer_mutex);
        
        sleep(1);  // Simulate work
    }
    return NULL;
}

int main() {
    pthread_t producer_thread, consumer_thread;
    
    pthread_create(&producer_thread, NULL, producer, NULL);
    pthread_create(&consumer_thread, NULL, consumer, NULL);
    
    pthread_join(producer_thread, NULL);
    pthread_join(consumer_thread, NULL);
    
    pthread_mutex_destroy(&buffer_mutex);
    pthread_cond_destroy(&buffer_not_empty);
    pthread_cond_destroy(&buffer_not_full);
    
    return 0;
}
```

## 4. Advanced Threading Concepts

### 4.1 Thread-Specific Data

Thread-specific data allows each thread to have its own copy of a variable:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>

pthread_key_t thread_key;

void destructor(void* value) {
    printf("Destroying thread-specific data: %d\n", *(int*)value);
    free(value);
}

void* thread_function(void* arg) {
    int* thread_data = malloc(sizeof(int));
    *thread_data = *(int*)arg;
    
    pthread_setspecific(thread_key, thread_data);
    
    int* retrieved_data = (int*)pthread_getspecific(thread_key);
    printf("Thread %d has data: %d\n", *(int*)arg, *retrieved_data);
    
    return NULL;
}

int main() {
    pthread_t thread1, thread2;
    int data1 = 100, data2 = 200;
    
    pthread_key_create(&thread_key, destructor);
    
    pthread_create(&thread1, NULL, thread_function, &data1);
    pthread_create(&thread2, NULL, thread_function, &data2);
    
    pthread_join(thread1, NULL);
    pthread_join(thread2, NULL);
    
    pthread_key_delete(thread_key);
    return 0;
}
```

### 4.2 Thread Cancellation

Threads can be cancelled by other threads:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

void cleanup_handler(void* arg) {
    printf("Cleanup handler called with argument: %d\n", *(int*)arg);
    free(arg);
}

void* cancellable_thread(void* arg) {
    int* data = malloc(sizeof(int));
    *data = 42;
    
    // Install cleanup handler
    pthread_cleanup_push(cleanup_handler, data);
    
    // Enable cancellation
    pthread_setcancelstate(PTHREAD_CANCEL_ENABLE, NULL);
    pthread_setcanceltype(PTHREAD_CANCEL_DEFERRED, NULL);
    
    while (1) {
        printf("Working...\n");
        sleep(1);
        
        // Cancellation point
        pthread_testcancel();
    }
    
    // This won't be reached due to infinite loop
    pthread_cleanup_pop(0);
    return NULL;
}

int main() {
    pthread_t thread;
    
    pthread_create(&thread, NULL, cancellable_thread, NULL);
    
    sleep(3);  // Let thread work for a while
    
    printf("Cancelling thread...\n");
    pthread_cancel(thread);
    
    pthread_join(thread, NULL);
    printf("Thread cancelled and joined\n");
    
    return 0;
}
```

## 5. Performance Considerations

### 5.1 Thread Pool Implementation

A thread pool can improve performance by reusing threads:

```c
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define NUM_THREADS 4
#define QUEUE_SIZE 10

typedef struct {
    void (*function)(void* arg);
    void* arg;
} task_t;

typedef struct {
    task_t task_queue[QUEUE_SIZE];
    int front, rear, count;
    pthread_mutex_t queue_mutex;
    pthread_cond_t queue_not_empty;
    pthread_cond_t queue_not_full;
    int shutdown;
    pthread_t threads[NUM_THREADS];
} threadpool_t;

threadpool_t pool = {0};

void* worker_thread(void* arg) {
    while (1) {
        pthread_mutex_lock(&pool.queue_mutex);
        
        // Wait for tasks or shutdown
        while (pool.count == 0 && !pool.shutdown) {
            pthread_cond_wait(&pool.queue_not_empty, &pool.queue_mutex);
        }
        
        if (pool.shutdown) {
            pthread_mutex_unlock(&pool.queue_mutex);
            break;
        }
        
        // Get task from queue
        task_t task = pool.task_queue[pool.front];
        pool.front = (pool.front + 1) % QUEUE_SIZE;
        pool.count--;
        
        pthread_mutex_unlock(&pool.queue_mutex);
        pthread_cond_signal(&pool.queue_not_full);
        
        // Execute task
        task.function(task.arg);
    }
    return NULL;
}

int threadpool_init() {
    pthread_mutex_init(&pool.queue_mutex, NULL);
    pthread_cond_init(&pool.queue_not_empty, NULL);
    pthread_cond_init(&pool.queue_not_full, NULL);
    
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_create(&pool.threads[i], NULL, worker_thread, NULL);
    }
    
    return 0;
}

int threadpool_add_task(void (*function)(void*), void* arg) {
    pthread_mutex_lock(&pool.queue_mutex);
    
    // Wait if queue is full
    while (pool.count == QUEUE_SIZE) {
        pthread_cond_wait(&pool.queue_not_full, &pool.queue_mutex);
    }
    
    // Add task to queue
    pool.task_queue[pool.rear].function = function;
    pool.task_queue[pool.rear].arg = arg;
    pool.rear = (pool.rear + 1) % QUEUE_SIZE;
    pool.count++;
    
    pthread_mutex_unlock(&pool.queue_mutex);
    pthread_cond_signal(&pool.queue_not_empty);
    
    return 0;
}

int threadpool_shutdown() {
    pthread_mutex_lock(&pool.queue_mutex);
    pool.shutdown = 1;
    pthread_mutex_unlock(&pool.queue_mutex);
    
    pthread_cond_broadcast(&pool.queue_not_empty);
    
    for (int i = 0; i < NUM_THREADS; i++) {
        pthread_join(pool.threads[i], NULL);
    }
    
    pthread_mutex_destroy(&pool.queue_mutex);
    pthread_cond_destroy(&pool.queue_not_empty);
    pthread_cond_destroy(&pool.queue_not_full);
    
    return 0;
}

// Example task function
void example_task(void* arg) {
    int task_id = *(int*)arg;
    printf("Executing task %d\n", task_id);
    sleep(1);
    printf("Task %d completed\n", task_id);
}

int main() {
    threadpool_init();
    
    // Add tasks to thread pool
    for (int i = 0; i < 10; i++) {
        int* task_id = malloc(sizeof(int));
        *task_id = i;
        threadpool_add_task(example_task, task_id);
    }
    
    sleep(5);  // Let tasks execute
    
    threadpool_shutdown();
    printf("Thread pool shutdown complete\n");
    
    return 0;
}
```

## 6. Debugging Multithreaded Applications

### 6.1 Common Issues

1. **Deadlocks**: Threads waiting for each other indefinitely
2. **Race conditions**: Unpredictable behavior due to timing
3. **Priority inversion**: High-priority thread blocked by low-priority thread
4. **Thread starvation**: Thread never gets CPU time

### 6.2 Debugging Tools

- **Valgrind with Helgrind**: Detects race conditions and threading errors
- **GDB**: Can debug individual threads
- **ThreadSanitizer**: Compiler-based tool for detecting threading bugs

Example Valgrind command:
```bash
valgrind --tool=helgrind ./multithreaded_program
```

## 7. Best Practices

### 7.1 Design Principles

1. **Minimize shared data**: Reduce the need for synchronization
2. **Use immutable data**: Avoid race conditions by not modifying shared data
3. **Keep critical sections small**: Reduce lock contention
4. **Avoid nested locks**: Prevent deadlocks
5. **Use RAII for resource management**: Automatic cleanup

### 7.2 Performance Optimization

1. **Profile before optimizing**: Identify actual bottlenecks
2. **Consider Amdahl's Law**: Understand the limits of parallelization
3. **Use appropriate synchronization primitives**: Mutex for mutual exclusion, condition variables for signaling
4. **Avoid false sharing**: Ensure cache lines aren't shared unnecessarily
5. **Consider lock-free data structures**: For high-performance scenarios

## Summary

Multithreading in C provides powerful capabilities for concurrent programming but requires careful design and implementation to avoid common pitfalls. Key concepts include:

- Understanding the difference between processes and threads
- Properly creating and managing threads with pthread_create and pthread_join
- Implementing synchronization with mutexes and condition variables
- Handling thread-specific data and cancellation
- Optimizing performance with thread pools and careful resource management

Mastering multithreading requires practice and understanding of both the technical details and the underlying concepts. Always prioritize correctness over performance and use appropriate debugging tools to identify issues in multithreaded code.