# Python Book — Master Multi-Domain Engineering Syllabus

A single, comprehensive volume covering Python from scratch across all major professional engineering disciplines.

## Baseline & Standards
- **Part 1 (Python Foundations)**: Direct sequential topics covering the complete language progression, starting with modern developer tooling (`uv`, `ruff`, editor LSP) and syntax, followed by an **exhaustive deep dive into the Python Standard Library (`stdlib`)**, before moving into modern craft, testing, packaging, concurrency, and CPython internals.
- **Parts 2–8 (Domain Parts)**: Standalone engineering domains in sequence: DevOps → Network Automation → Data Science → AI / ML → Robotics → Cybersecurity → Web Services (last domain).
- **Part 9 (Enterprise Production Capstones)**: Cross-domain synthesized production architectures.
- **Python Version**: Python 3.14 (free-threading support, PEP 703, zero-cost exceptions).
- **Toolchain**: `uv` (`uv run`, `uv add`, `uv lock`, `pyproject.toml`) and `ruff` (linter/formatter).
- **Philosophy**: Completely self-contained; code-first; complete runnable files; strict adherence to `chapter-template.md`.

---

## PART 1: PYTHON FOUNDATIONS (`01-python-foundations`)

### Modern Tooling & Environment Setup
1. **What Is Python**: The execution pipeline (source → AST → bytecode → CPython VM), Python 3.14 runtime, 2026 landscape.
2. **The Modern Toolchain with `uv`**:
   - Installing and bootstrapping Python runtimes via `uv` (`uv python install 3.14`).
   - Virtual environments reinvented: `uv venv`, automatic `.venv` discovery, ephemeral environments.
   - Running scripts directly: `uv run script.py` with inline script dependency metadata.
   - Managing project dependencies: `uv add`, `uv remove`, deterministic `uv.lock`, and `pyproject.toml`.
3. **Developer Environment & Code Hygiene with `Ruff`**:
   - Editor setups: Language Server Protocol (LSP), Python extensions.
   - Fast linting and formatting with `ruff` (replacing Black, Flake8, isort).
   - Configuring rules in `pyproject.toml` (`[tool.ruff]`, `[tool.ruff.lint]`, line lengths, import sorting).
   - Automated git pre-commit hooks and CI hygiene checks.
4. **Editor Setup: VS Code with Modern Tooling**:
   - Workspace configuration via `.vscode/settings.json` (interpreter path, format-on-save with Ruff, auto-import sorting).
   - Extension recommendations via `.vscode/extensions.json` (Ruff, Python, Pylance/BasedPyright, Even Better TOML).
   - Interactive debugging via `.vscode/launch.json` (breakpoints, call stacks, variable watches, CLI argument testing).
   - Test Explorer integration with Pytest and inline gutter test execution.
5. **Running Python Code**:
   - Anatomy of a runnable Python script (`# name.py`, shebang lines, encoding).
   - The interactive REPL (`python` via `uv run`), command execution flags (`-c`, `-m`).
   - Reading tracebacks, syntax errors vs runtime exceptions on day one.

### Core Language Fundamentals
6. **Variables and Memory**: Names as references, object identity (`id()`), type, value, mutability vs immutability.
7. **Primitive Data Types**: Integers (arbitrary precision), floats (IEEE 754 precision caveats), booleans, string encoding (UTF-8).
8. **Operators & Expressions**: Arithmetic, bitwise, comparison, boolean logic, and short-circuit evaluation.
9. **Strings & Text Processing**: Slicing, immutability, common string methods, modern f-strings, template formatting.
10. **Control Flow: Branching**: `if`, `elif`, `else`, truthiness, and ternary operators.
11. **Control Flow: Loops**: `for` and `while` loops, `break`, `continue`, loop `else` clauses.
12. **Sequences: Lists & Tuples**: Dynamic arrays (`list`) vs immutable records (`tuple`), unpacking, slicing idioms.
13. **Associative Types: Dictionaries & Sets**: Hash tables, dictionary lookups, set operations (union/intersection).
14. **Functions & Scopes**: Defining functions (`def`), parameters, `*args`/`**kwargs`, return values, LEGB scope.
15. **Exception Handling**: Traceback anatomy, `try`/`except`/`else`/`finally`, custom exception hierarchies.

### Intermediate Craft, OOP & Architecture
15. **Comprehensions & Generators**: List/dict/set comprehensions, generator expressions, iterator protocol (`__iter__`, `__next__`), `yield`.
16. **Classes & Encapsulation**: OOP design, attributes vs methods, `self`, constructor `__init__`, public/private conventions, `@property`.
17. **The Python Data Model**: Dunder protocols (`__repr__`, `__str__`, `__eq__`, `__hash__`, operator overloading).
18. **Inheritance & Composition**: Single/multiple inheritance, MRO (C3 linearization), abstract base classes, composition over inheritance.
19. **Dataclasses & Pydantic**: Modern declarative data modeling with `@dataclass(slots=True)` and Pydantic v2 validation.
20. **Pattern Matching & Decorators**: Structural pattern matching (`match`/`case`) with guards, closures, parameterized decorators.
21. **Context Managers & RAII**: Resource management (RAII), `__enter__`/`__exit__`, `@contextlib.contextmanager`.

### The Python Standard Library (Exhaustive Coverage)
22. **Specialized Collections**: `collections.defaultdict`, `Counter`, `deque`, `namedtuple`, `OrderedDict`, `enum.Enum`, priority queues with `heapq`, and binary search with `bisect`.
23. **Functional & Iteration Tools**: High-performance iteration: `itertools` (`chain`, `cycle`, `islice`, `groupby`, `permutations`, `combinations`) and functional utilities: `functools` (`lru_cache`, `partial`, `reduce`, `singledispatch`), `operator`.
24. **Text Processing & Regex**: Regular expressions (`re`: patterns, flags, lookarounds, substitution), `unicodedata`, and `string.Template`.
25. **Filesystem & Pathlib**: Modern object-oriented filesystem paths with `pathlib.Path`, recursive directory walking, file streaming, high-level file operations (`shutil`), temporary storage (`tempfile`).
26. **Data Serialization & Formats**: Structured data parsing: `json` (encoding/decoding, custom hooks), `csv` (dialects, dict readers/writers), built-in TOML parsing with `tomllib`.
27. **Embedded Persistence with SQLite3**: Relational storage without dependencies: connection contexts, parameterized queries, row factories, transactions, and schema management.
28. **Dates, Times & Timezones**: Temporal mechanics: `datetime`, `date`, `time`, `timedelta`, strict timezone math with `zoneinfo`, ISO-8601 formatting.
29. **Math, Randomness & Cryptography**: Number utilities (`math`, arbitrary-precision `decimal`, `fractions`, `statistics`), CSPRNG secure secrets (`secrets`) vs pseudo-random (`random`), cryptographic hashing (`hashlib`, `hmac`).
30. **OS & Process Management**: Operating system environment access with `os` and `sys`, cross-platform process spawning and pipe redirection with `subprocess`, command splitting with `shlex`.
31. **CLI Parsing & Application Logging**: CLI argument parsing with `argparse`, hierarchical application logging with `logging` (handlers, formatters, log rotation).
32. **Archives & Compression**: Programmatic archive handling: creating, inspecting, and extracting archives with `zipfile`, `tarfile`, and in-memory compression with `gzip`.
33. **Networking & Sockets**: Raw socket fundamentals (`socket`), URL parsing (`urllib.parse`), and IP address / CIDR arithmetic (`ipaddress`).

### Modern Craft, Testing & Packaging
34. **Modern Typing & Mypy**: Static typing (`Union`, `Generic`, `Protocol`, `Literal`), static analysis with `mypy` and `pyright`.
35. **Unit & Integration Testing with Pytest**: Comprehensive testing with `pytest` (fixtures, markers, mocks, parametrization).
36. **Modern Packaging & Workspaces**: Multi-package workspaces with `uv`, building wheel packages (`uv build`), and version publishing.

### Advanced Internals, Concurrency & High Performance
37. **CPython VM & Bytecode**: Compilation pipeline: source code → AST → bytecode, disassembling with `dis`, evaluation loop (`ceval.c`).
38. **Memory Allocator & GC**: PyObject headers, pymalloc arenas/pools/blocks, generational cyclic garbage collection.
39. **The GIL & Free-Threading**: Global Interpreter Lock mechanics, Python 3.14 free-threading (PEP 703) on multi-core systems.
40. **Multithreading & Multiprocessing**: `threading`, thread-safe queues, `ProcessPoolExecutor`, shared memory IPC.
41. **AsyncIO & Task Groups**: Coroutines, tasks, futures, `async`/`await`, structured concurrency with `asyncio.TaskGroup`.
42. **Profiling & C Interoperability**: Bottleneck profiling (`cProfile`), native interop with `ctypes`, `cffi`, and PyO3 Rust bindings.
43. **Lab**: Building a high-throughput, typed, tested, async search and data processing engine synthesizing Foundations.

---

## PART 2: DEVOPS AND CLOUD ENGINEERING (`02-devops-and-cloud-engineering`)
1. **Advanced CLI Engineering**: Interactive terminal tools with `typer` and `rich` (tables, progress bars).
2. **System Administration Automation**: System auditing, storage checks, cron and systemd automation.
3. **Docker Automation with Python SDK**: `docker-py`, container lifecycle, image building, volume and network inspection.
4. **Kubernetes Client & Controllers**: Official `kubernetes` client, managing Deployments/Pods, reconciliation loops.
5. **Infrastructure as Code with Pulumi**: Provisioning cloud infrastructure with Python using Pulumi.
6. **Cloud Automation with Boto3**: AWS/Cloud automation, S3 manipulation, EC2 controllers, pagination and error handling.
7. **Observability: Telemetry & Metrics**: Distributed tracing with `opentelemetry-python`, Prometheus metrics with `prometheus_client`.
8. **CI/CD Pipeline Automation**: Python-based CI runners, GitHub Actions automation, PR validation bots.
9. **Lab**: Autonomous SRE remediation watchdog: scrapes Prometheus alerts, diagnoses failing containers, restarts services.

---

## PART 3: NETWORK AUTOMATION & NETDEVOPS (`03-network-automation`)
1. **Network Engineering for Developers**: IP addressing (`ipaddress` module), CIDR math, routing and interface states.
2. **SSH CLI Automation with Netmiko**: Multi-vendor SSH automation, prompts, paging, enable modes, error detection.
3. **High-Speed Async SSH with Scrapli**: Parallel device communication using `scrapli` and `scrapli-async`.
4. **Multi-Vendor Abstraction with NAPALM**: Vendor-neutral getters (`get_facts`, `get_interfaces`), atomic config rollback.
5. **Scalable Automation Frameworks: Nornir**: Concurrency models, inventory plugins, task execution, failure isolation.
6. **Data Modeling: Jinja2 & YAML**: Structured network data, YAML data modeling, Jinja2 template configuration rendering.
7. **Programmable APIs: NETCONF & RESTCONF**: YANG models, NETCONF RPCs via `ncclient`, RESTCONF with `httpx`.
8. **Model-Driven Telemetry with gNMI**: Next-gen telemetry streaming using `pygnmi` and gRPC.
9. **Source-of-Truth with NetBox**: Querying IPAM and device inventories via `pynetbox`, automating configuration drift checks.
10. **Network Testing & Validation with pyATS**: Automated network state diffing and validation using Cisco pyATS/Genie.
11. **Lab**: Zero-touch NetDevOps pipeline: reads intent from NetBox, renders Jinja2 configs, deploys via Nornir, tests via pyATS.

---

## PART 4: DATA SCIENCE & HIGH-PERFORMANCE ANALYTICS (`04-data-science-and-analytics`)
1. **Numerical Computing with NumPy**: Vectorized operations, `ndarray` structure, broadcasting, linear algebra.
2. **Data Wrangling with Pandas 2.0**: DataFrames/Series, indexing, aggregations, time-series, PyArrow backend.
3. **Next-Gen Fast DataFrames with Polars**: Columnar execution, lazy queries (`LazyFrame`), query optimization expressions.
4. **In-Process Analytical OLAP with DuckDB**: Embedded SQL warehouse, querying Polars/Parquet/CSV files with zero copies.
5. **Data Interoperability with Apache Arrow**: In-memory Arrow standard, Parquet reading/writing, zero-copy data interchange.
6. **Exploratory Data Analysis & Statistics**: Descriptive and inferential statistics with `scipy.stats`, hypothesis testing.
7. **Modern Visualization: Seaborn & Plotly**: Statistical graphics with Seaborn, interactive dashboards with Plotly.
8. **Data Pipeline Orchestration**: ETL pipeline design, schema drift handling, data validation with Pandera.
9. **Lab**: Real-time time-series analytics engine with Polars streaming, DuckDB aggregation, and Plotly dashboard.

---

## PART 5: ARTIFICIAL INTELLIGENCE & GENERATIVE AI (`05-artificial-intelligence`)
1. **Machine Learning Foundations**: Supervised/unsupervised paradigms, feature engineering, cross-validation, bias-variance.
2. **Classical ML with Scikit-Learn**: Classifiers, regressors, clustering, Scikit-Learn Pipelines, preprocessing.
3. **Model Evaluation & Hyperparameters**: Metrics (ROC-AUC, F1), confusion matrices, hyperparameter search (Optuna).
4. **Deep Learning Foundations with PyTorch**: PyTorch 2.x tensors, autograd engine, custom neural network modules (`nn.Module`).
5. **Training Neural Networks**: Loss functions, optimizers (AdamW), learning rate schedulers, custom training loops, GPU acceleration.
6. **Computer Vision & NLP Architectures**: Convolutional networks (CNNs), attention mechanics, Transformer architectures.
7. **Hugging Face Ecosystem**: Pretrained models, tokenizers, fine-tuning with `transformers`, LoRA/PEFT.
8. **Modern Generative AI & LLMs**: Local & cloud LLMs (Ollama, vLLM, API endpoints), prompt engineering, token streaming.
9. **Structured Output & Function Calling**: Deterministic schema generation using Instructor and Pydantic, tool use.
10. **Retrieval-Augmented Generation (RAG)**: Chunking strategies, vector embeddings, vector databases (Chroma/Qdrant), hybrid search.
11. **Autonomous Agents & Graph Workflows**: Cyclic reasoning agents, state management with LangGraph, self-correcting validation.
12. **Lab**: Agentic research assistant with vector retrieval, local LLM execution, tool calling, and structured citations.

---

## PART 6: ROBOTICS, PHYSICAL COMPUTING & SIMULATION (`06-robotics-and-simulation`)
1. **Physical Computing & Embedded Python**: MicroPython / CircuitPython, microcontroller flashing (RP2040/ESP32), GPIO, PWM, ADC.
2. **Sensors, Actuators & Buses**: I2C, SPI, UART communication, reading IMUs and ultrasonic sensors, driving servos/motors.
3. **Robotics Simulation with PyBullet**: Physics simulation setup, URDF models, joint motors, gravity and collision physics.
4. **ROS 2 Architecture & `rclpy`**: ROS 2 nodes, topics, publisher/subscriber patterns, DDS middleware.
5. **ROS 2 Services, Actions & Launch**: Request-reply services, long-running action servers, multi-node Python launch files.
6. **Computer Vision for Robotics with OpenCV**: Frame capture, color space transforms, contour detection, edge detection, optical flow.
7. **Fiducials & Pose Estimation**: ArUco markers and AprilTags detection, camera calibration, 6-DOF pose estimation.
8. **Kinematics & Motion Planning**: Forward/inverse kinematics, coordinate transforms, path planning (A*, Dijkstra, RRT).
9. **Behavior Trees & Decision Making**: State machines vs. Behavior Trees (`py_trees`), autonomous navigation logic.
10. **Lab**: Simulated autonomous rover in PyBullet that navigates an obstacle course towards an ArUco target using OpenCV.

---

## PART 7: CYBERSECURITY & THREAT AUTOMATION (`07-cybersecurity-and-automation`)
1. **Security Principles in Python**: Secure programming practices, memory safety, avoiding `eval`/`pickle`, cryptographic secrets.
2. **Low-Level Networking & Raw Sockets**: Raw sockets in Linux, constructing TCP/IP packets from scratch, promiscuous sniffing.
3. **Packet Crafting with Scapy**: Crafting custom ICMP/DNS/TCP packets, analyzing PCAP files programmatically.
4. **Network Reconnaissance & Port Scanning**: Concurrent TCP SYN/connect port scanner, banner grabbing, service fingerprinting.
5. **Cryptography Primitives**: Symmetric encryption (AES-GCM, Fernet), asymmetric cryptography (RSA), hashing, Argon2 key derivation.
6. **Web Security & Fuzzing**: Asynchronous HTTP directory fuzzer, security header auditing, parameter fuzzing.
7. **Malware Analysis & File Forensics**: Parsing PE/ELF binaries with `pefile`, extracting strings, computing hashes, VirusTotal API integration.
8. **SIEM Log Analysis & Incident Response**: Automated log parsing, detecting brute-force attempts, automated firewall IP blocking.
9. **Lab**: Real-time packet sniffer and signature-based network intrusion detection system with webhook alerting.

---

## PART 8: MODERN WEB APIS, MICROSERVICES & ASGI (`08-web-and-distributed-systems`)
*(Positioned as the final domain before the Capstones)*
1. **HTTP Protocol & Socket Foundations**: HTTP 1.1/2 semantics, raw TCP server with `socket`, request/response anatomy.
2. **ASGI & Starlette Fundamentals**: ASGI specification, WSGI vs ASGI, custom ASGI middleware.
3. **FastAPI Rapid API Development**: Routing, OpenAPI documentation, path/query parameters, dependency injection.
4. **Request Validation & Pydantic v2**: Deep validation pipelines, request/response models, custom serializers.
5. **Async Database Access with SQLAlchemy 2.0**: Async engines, connection pools, SQLModel, migrations with Alembic.
6. **Authentication & Authorization**: OAuth2 with password flow, JWT generation and validation, RBAC.
7. **Realtime Communications: WebSockets**: WebSocket lifecycle, bidirectional streaming, pub/sub rooms.
8. **Background Tasks & Message Queues**: Background worker queues with Redis and ARQ / Celery.
9. **Lab**: Production-ready asynchronous task platform with JWT auth, SQLite/PostgreSQL, and WebSockets.

---

## PART 9: ENTERPRISE PRODUCTION CAPSTONES (`09-capstone-systems`)
1. **Capstone 1: Autonomous Cloud SRE Agent**: Multi-domain synthesis of DevOps + AI/LLMs + Web Services.
2. **Capstone 2: NetDevOps Source-of-Truth Validator**: Multi-domain synthesis of Network Automation + Data Science + Security.
3. **Capstone 3: Vision-Guided Autonomous Robot Telemetry**: Multi-domain synthesis of Robotics + Computer Vision + WebSockets.
