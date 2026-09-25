# Writing Kernel with AI: Curriculum & Syllabus

**CPU to AI-Written Kernels**

---

## Part I: Parallelism, from the CPU up
*Get comfortable with "doing many things at once" on a CPU first, then meet the GPU and how you program it, so every kernel that follows sits on solid foundations.*

### 1. Parallelism on the CPU
- SIMD vectorization: AVX-512, Arm Neon, Google Highway, and compiler autovectorization
- Lightweight threads (Go goroutines, Java virtual threads, Rust tokio) vs classic models (pthreads, OpenMP)
- CPU core microarchitecture: pipelining, superscalar dispatch, out-of-order execution, branch prediction

### 2. Roofline Lab: Predict Then Measure (Lecture 1 & Lab 1)
- The fundamental speed limit: compute-bound vs memory-bound workloads
- The Roofline chart: operational intensity (FLOPs / byte transferred)
- Hands-on PyTorch & CUDA profiling: predicting bottlenecks and measuring hardware limits

### 3. The CUDA Programming Model & GPU Puzzles (Lecture 2 & Lab 2)
- GPU execution model: threads, 32-thread lockstep warps, thread blocks, streaming multiprocessors (SMs)
- Warp divergence penalties and mitigation strategies
- Inspecting PTX intermediate representation and SASS machine assembly
- Writing first GPU kernels and solving GPU Puzzles

### 4. The Memory Hierarchy in Anger: Matrix Transpose (Lecture 3 & Lab 3)
- Memory subsystems: global DRAM, L2 cache, high-speed shared memory (SRAM), registers
- Memory coalescing: coalesced 128-byte transactions vs uncoalesced strided access (~10x lever)
- Bank conflicts in shared memory and occupancy cliffs
- Step-by-step optimization of matrix transpose using NVIDIA Nsight Compute (NCU)

---

## Part II: The GEMM Worklog: Naive → cuBLAS
*Take the single most important operation in AI, matrix multiply, from a version that uses ~1% of the GPU to one that beats NVIDIA's own library, one improvement at a time.*

### 5. GEMM Worklog I: Naive to Tiled (Lecture 4 & Lab 4)
- Matrix multiply as the computational backbone of deep learning (~90% of model FLOPs)
- Dissecting the naive GEMM: why it achieves only ~1.3% of theoretical peak compute
- Global memory coalesced reading and shared memory 2D block tiling (reaching 36.5% peak)
- Quantifying gains with hardware performance counters

### 6. GEMM Worklog II: Registers & Warp Tiling (Lecture 5 & Lab 5)
- Micro-tiling in register files: maximizing arithmetic reuse at the register layer
- Vectorized memory transactions with `float4` / `int4`
- Hierarchical warp-level tiling reaching ~93.7% of hand-tuned cuBLAS
- Assembly inspection: compressing 8 memory loads down to 2

### 7. Tensor Cores & WMMA: The Second Worklog (Lecture 6 & Lab 6)
- Specialized matrix compute engines: Tensor Core architecture
- Direct programming using WMMA (Warp Matrix Multiply and Accumulate) C++ APIs
- Numerical precision trade-offs: FP16, BF16, TF32, and FP8
- Surpassing conventional scalar CUDA core limits

---

## Part III: Attention & Profiling
*Learn to find why a kernel is slow like a pro, then build the operation at the heart of every LLM, FlashAttention, and kick off your capstone.*

### 8. Profiling & Debugging Like a Pro (Lecture 7 & Lab 7)
- Methodical bottleneck diagnosis: reading NVIDIA Nsight Compute & Nsight Systems like a compiler engineer
- The professional debugging toolkit: `compute-sanitizer`, race detection, illegal address trapping (vLLM triage workflow)
- Hands-on incident lab: isolating and repairing three sabotaged production kernels under time constraints

### 9. Attention: The Kernel That Ate the World & FlashAttention v1 (Lecture 8 & Lab 8)
- Self-attention mechanics: $QK^T$, Softmax, and $AV$ bottlenecks ($O(N^2)$ memory traffic)
- The mathematical breakthrough: Online Softmax (Milakov & Gimelshein, Tri Dao)
- Fusing Softmax and Matmul into shared memory to eliminate high-bandwidth memory roundtrips
- Prefill (compute-bound) vs Decode (memory-bound token generation) dynamics

---

## Part IV: The Modern Frontier
*The 2025-2026 kernels the best labs ship right now: Hopper, Blackwell, DeepSeek, and Flash Attention 4, each one explained from the ground up, not assumed.*

### 10. Deep-Dive 1: FlashAttention from Scratch (FA1 → FA2 → FA3)
- Complete ground-up reference implementation with causal masking
- FlashAttention-2: non-matmul FLOP elimination and sequence parallel splitting
- FlashAttention-3: Hopper asynchronous execution, ping-pong GEMM, and FP8 acceleration

### 11. Deep-Dive 2: Beating cuBLAS on an H100
- Hopper hardware capabilities: Tensor Memory Accelerator (TMA) and WGMMA instructions
- Warp specialization: decoupling producer warps (TMA async loads) from consumer warps (math)
- Assembling a custom matrix multiply that exceeds native cuBLAS throughput on H100

### 12. Deep-Dive 3: Triton → CUTLASS → CuTe-DSL
- OpenAI Triton: Block-level GPU programming in ~40 lines of Python
- NVIDIA CUTLASS: C++ template library, hierarchy of tiles, and collective builders
- The 2025-2026 paradigm shift: CuTe-DSL and Python-to-metal compilation (CuTe layouts and tensors)

### 13. Deep-Dive 4: Inference-Serving Kernels
- Architectural disaggregation: prompt prefill vs autoregressive decode
- PagedAttention: managing dynamic, fragmented KV-cache allocations in vLLM & SGLang
- Speculative decoding: draft-verify speculative kernels achieving 2-3x latency reduction
- Low-bit quantization kernels: FP8 GEMM, AWQ, and GPTQ Marlin kernels

### 14. Deep-Dive 5: Blackwell & NVFP4
- NVIDIA Blackwell architecture: `tcgen05` fifth-generation Tensor Cores and on-chip Tensor Memory (TMEM)
- NVFP4: 4-bit microscopic floating-point representation doubling inference density
- Multi-die NVLink interconnects and cooperative multi-chip execution

### 15. Deep-Dive 6: Flash Attention 4
- The 2026 Blackwell shift: compute units outpace memory so fast that Softmax becomes the bottleneck
- Adaptive Softmax: conditional normalization updates skipping redundant work
- Crossing the 1 PetaFLOP/s single-GPU frontier using modern Python DSLs

---

## Part V: AI-Written Kernels
*The newest twist of all: tiny hand-crafted kernels that beat huge libraries, and AI models that now write GPU kernels themselves, and how a kernel engineer guides them.*

### 16. Deep-Dive 7: DeepSeek: FlashMLA & DeepGEMM
- Architectural breakdown of DeepSeek's open-source kernels
- FlashMLA: optimized Multi-head Latent Attention kernel minimizing KV-cache memory bandwidth
- DeepGEMM: ~300 lines of clean CUDA code achieving peak FP8 performance via smart software pipelining

### 17. Deep-Dive 8: LLM-Generated Kernels: The Agent + Profiler Loop
- Autonomous kernel engineering: LLM code generation across CUDA, Triton, and CuTe
- Rigorous evaluation: KernelBench methodology and correctness testbenches
- Google DeepMind AlphaEvolve: evolutionary algorithm search discovering novel GEMM schedules (+32% attention speedup)
- The Kernel Engineer's evolving role: guiding agentic loops with profiler metrics, memory proofs, and safety verifications

---

## Part VI: Kernel Engineering Capstone Projects
*A real kernel-engineering project, built on capstone project ideas from Crusoe and graded at demo day, the closest thing to an on-site interview before the on-site interview.*

### 18. Crusoe Capstone Specifications & Problem Tracks
- Problem Track 1: Custom Fused Multi-Head Attention kernel with structured sparsity
- Problem Track 2: Mixed-precision quantized GEMM kernel for sub-4-bit LLM serving
- Problem Track 3: High-throughput speculative decoding verification kernel

### 19. Verification, Profiling, and Benchmarking Harness
- Constructing testbenches with PyTorch reference baselines and unit tests
- Benchmarking with CUDA events and hardware performance counters
- Reproducible benchmarking scripts and roofline validation

### 20. Demo Day Presentation & Portfolio
- Documenting kernel architecture, memory layout, and optimization progression
- Visualizing speedup charts against cuBLAS, FlashAttention, and Triton baselines
- Preparing the technical defense for performance engineering interviews
