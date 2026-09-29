# Boring Rust: Syllabus & Table of Contents

**A Complete Guide to Safe, Concurrent, High-Performance Programming**

---

## Introduction: Why Rust Matters
- The Problem Rust Solves
- How Rust Achieves This
- What You Will Learn
- How to Read This Book
- The Current State of Rust
- What Rust Is Not

---

## Chapter 1: Getting Started with Rust
- The Story of Rust: History and Philosophy
- Installing Rust with rustup
- Your First Program: Hello World
- Understanding rustc and cargo
- Exploring a Cargo Project Structure
- Summary

## Chapter 2: Language Basics: Variables, Types, and Expressions
- Variables, Mutability, and Shadowing
- Primitive Data Types in Detail
- Compound Types: Tuples and Arrays
- Functions, Statements, and Expressions
- Control Flow: if, loop, while, and for
- Summary

## Chapter 3: Ownership: The Heart of Rust
- What is Ownership and Why Does It Exist?
- Stack vs Heap Memory in Rust
- Move Semantics Explained
- Copy Types and Clone
- The Drop Trait and Resource Cleanup
- Summary

## Chapter 4: Borrowing, References, and Slices
- Shared and Mutable References
- The Borrowing Rules Demystified
- Dangling References Prevented at Compile Time
- String Slices and &str
- Slice Types and Range Syntax
- Summary

## Chapter 5: Structs, Enums, and Pattern Matching
- Defining and Using Structs
- Enumerations Beyond Simple Tags
- The match Expression in Depth
- if let and while let for Partial Matching
- Real-World Data Modeling with Enums
- Summary

## Chapter 6: Modules, Crates, and Visibility
- Modules and the Filesystem
- The use Statement and Path Resolution
- Public vs Private Visibility Rules
- Crates, Packages, and Cargo Workspaces
- Re-exporting and Organizing Large Projects
- Summary

## Chapter 7: Collections and Strings
- Vec and Dynamic Arrays
- String vs &str Deep Dive
- HashMap and BTreeMap for Key-Value Storage
- Other Collections: HashSet, BinaryHeap, LinkedList
- Efficient Collection Operations
- Summary

## Project 1: Building a CLI Task Manager
- Testing the Task Manager
- Benchmarking the Task Manager
- Deploying the Task Manager

## Chapter 8: Error Handling in Rust
- Unrecoverable Errors with panic!
- Recoverable Errors with Result
- The Option Type for Absent Values
- Propagating Errors with the ? Operator
- Custom Error Types and thiserror
- Summary

## Chapter 9: Generics, Traits, and Associated Types
- Generic Functions and Data Structures
- Defining and Implementing Traits
- Trait Bounds and Where Clauses
- Associated Types vs Generics
- Trait Objects and Dynamic Dispatch
- Summary

## Chapter 10: Lifetimes: Complete Understanding
- What Lifetimes Are (and Are Not)
- The Lifetime Elision Rules
- Annotating Lifetimes in Functions and Structs
- Lifetime Bounds on Traits
- Advanced Lifetime Patterns
- Summary

## Chapter 11: Smart Pointers and Interior Mutability
- Box for Heap Allocation
- Reference Counting with Rc and Arc
- Interior Mutability with RefCell
- Cell and Mutex for Shared State
- Weak References and Breaking Cycles
- Summary

## Chapter 12: Iterators, Closures, and Functional Patterns
- The Iterator Trait and Protocol
- Creating Custom Iterators
- Closures and Capture Semantics
- Higher-Order Functions and Combinators
- Lazy Evaluation and Performance
- Summary

## Chapter 13: Concurrency: Fearless Parallelism
- Spawning Threads with std::thread
- Message Passing with Channels
- Shared State with Mutex and RwLock
- Atomic Operations for Lock-Free Code
- Send and Sync Traits Explained
- Summary

## Project 3: Parallel Data Processing Pipeline with rayon
- Testing the Text Analyzer
- Benchmarking the Text Analyzer
- Deploying the Text Analyzer

## Chapter 14: Asynchronous Programming with async/await
- The Future Trait and Async Basics
- Running Async Code with Tokio
- Pinning and Self-Referential Types
- Async Streams and Error Handling
- Building Production Async Applications
- Summary

## Chapter 15: Macros, Unsafe Rust, and FFI
- Declarative Macros with macro_rules!
- Procedural Macros and Derive
- Understanding unsafe Rust
- Memory Layout and Representation
- Foreign Function Interfaces
- Summary

## Chapter 16: Testing, Documentation, Performance, and Deployment
- Unit Tests, Integration Tests, and Doctests
- Benchmarking with Criterion
- Writing Great Documentation
- Profiling and Optimization Techniques
- Building and Deploying Rust Applications
- Summary

## Chapter 17: The Rust Ecosystem: Essential Crates for Production Development
- serde: Serialization and Deserialization
- clap: Command-Line Argument Parsing
- reqwest: HTTP Client
- axum: Web Framework
- actix-web: High-Performance Web Framework
- Project 2: Async HTTP API with axum, sqlx, and tracing
  - Testing the User API
  - Benchmarking the User API
  - Deploying the User API
- sqlx: Async Database Access
- rayon: Data Parallelism
- tracing: Structured Logging and Observability
- chrono: Date and Time
- uuid: Universally Unique Identifiers
- rand: Random Number Generation
- regex: Regular Expressions
- bytes: Efficient Binary Buffers
- futures: Async Primitives
- Summary

## Chapter 18: Advanced Topics: Compiler, Debugging, Security, and Anti-Patterns
- The Rust Compilation Pipeline
- Debugging Rust Programs
- Security Considerations in Rust
- Common Anti-Patterns and How to Avoid Them
- Summary

## Chapter 19: WebAssembly with Rust
- Why Rust for WebAssembly?
- WebAssembly Fundamentals
- Setting Up: wasm-pack and wasm-bindgen
- Building Your First WebAssembly Module
- Interacting with the DOM
- Handling Events and Async
- Performance Considerations
- Server-Side WebAssembly
- Publishing and Distribution
- Summary

## Chapter 20: Embedded Rust and no_std Development
- Understanding no_std
- Choosing a Target: Cortex-M
- Writing an Embedded Application: Blinking an LED
- Memory Management Without a Heap
- Interrupts and Concurrency
- Choosing an Executor or RTOS
- Testing Embedded Code
- Toolchain and Debugging
- Summary

---

## Conclusion: The Rust Mindset
- Core Principles
- Where Rust Shines
- Where Rust May Not Be the Best Fit
- Continuing Your Journey
- Final Thoughts
