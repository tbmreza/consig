# Architecture

This document outlines the high-level design, vision, and architectural principles of **Consig**.

## Vision

**Consig** aims to be a "SciPy for Lean"—a comprehensive signal processing library that balances the formal correctness of dependent types with the engineering pragmatism required for real-world simulation and analysis.

We envision a future where scientific computing papers are accompanied not just by code, but by *proofs* of key properties, enabled by a library that makes formal verification accessible to engineers.

## Design Philosophy

### 1. Gradual Verification
We do not demand 100% formal proof for every line of code from day one. Consig supports a spectrum of rigor:
*   **Runtime Contracts**: Like Python assertions or "Design by Contract", checking preconditions at runtime (e.g., `assert fs > 0`).
*   **Dependent Types**: Encoding invariants in types (e.g., `Signal (fs : Nat)` where `fs` is the sampling rate) to catch errors at compile time.
*   **Full Proofs**: Formally proving algorithms correct (e.g., "this filter implementation satisfies the spectral mask").

Users should be able to choose their level of rigor. A prototype might use runtime checks; a critical medical device component might use full proofs.

### 2. "Sorry-First" Development
To avoid "analysis paralysis" where the difficulty of proofs blocks feature development, we encourage a **"Sorry-First"** approach:
1.  Define the **Type Signatures** and **Propositions** (the "what").
2.  Implement the **Algorithm** (the "how").
3.  Use `sorry` (Lean's axiom for missing proofs) to fill in the logical gaps initially.
4.  Refine and prove the `sorry`s later as the design stabilizes.

This allows us to build "executable specifications" and validate the API design before investing in heavy proof engineering.

### 3. Pragmatic Interoperability
We acknowledge the vast ecosystem of existing tools (Python/SciPy, MATLAB/Octave). Consig should not reinvent the wheel where it doesn't add value.
*   **Foreign Function Interfaces (FFI)**: We will wrap robust external libraries for heavy lifting where appropriate, using Lean's type system to enforce safe usage boundaries.

## Intended Architecture

The project is organized into three conceptual layers:

### 1. Core Abstractions (`Consig.Core`)
The foundation of the library. This layer defines the vocabulary of signal processing in Lean.
*   **Types**: `Signal`, `Frequency`, `Time`, `Power`.
*   **Invariants**: Dependent types ensuring physical consistency (e.g., preventing the addition of signals with different sampling rates).

### 2. Implementation Strategies
Algorithms can be implemented in two ways:
*   **Native**: Pure Lean implementations. Preferred for core building blocks, educational value, and where formal verification is desired.
*   **Foreign**: Wrappers around external solvers or libraries. Used for complex numerical routines where performance or implementation effort is a bottleneck.

### 3. Simulation & Verification Layer
Tools for the working engineer to validate their systems.
*   **Simulation**: Running Monte Carlo simulations (e.g., BER vs. SNR curves).
*   **Property Testing**: Using tools like QuickCheck to statistically verify properties before proving them.
*   **Formal Verification**: The "gold standard" proofs of correctness.

## Code Organization

*   `Consig/`: **The Library**. Code here is intended to be stable, reusable, and eventually verified.
*   `Main.lean` & `building-blocks/`: **The Sandbox**. A space for experiments, prototypes, "executable specifications", and tutorials. Code here may be messy, unverified, or use `sorry` liberally.
