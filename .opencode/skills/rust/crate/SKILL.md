---
name: "Rust Library Scaffold (crate)"
description: "Create a new reusable Rust library/crate with thiserror, a lean public API (lib.rs), private internal modules, examples/, and a prepared benches/ folder. Use when scaffolding publishable crates."
---

# Reusable library (crate)

## When to use

- A reusable Rust component: lean public API, isolated complex logic, typed errors.
- Do not use for apps with a binary (`rust-api-web`, `rust-cli`) or monorepos (`rust-workspace`).

## How to run

Run from the directory where the project should be created (the script does `cargo new --lib`):

```bash
bash .opencode/skills/rust-crate/scripts/generate_library.sh my_library
```

The name must be a valid crate name (lowercase, no spaces).

## What gets generated

```text
<project>/
├── Cargo.toml            # thiserror 2 (lean deps for fast builds)
├── src/
│   ├── lib.rs            # the ONLY public surface: pub mod error; pub use core::Processor
│   ├── error.rs          # LibError via thiserror
│   ├── core.rs           # algorithmic core (private module, exposed via reexport)
│   └── utils.rs          # internal utilities (private)
├── examples/
│   └── processing.rs     # autonomous demo: cargo run --example processing
└── benches/              # prepared; add criterion once there is real code to measure
```

Stack: edition 2024, thiserror 2.

## Verification

```bash
cd <project>
cargo build
cargo test
cargo clippy -- -D warnings
cargo fmt --check
cargo run --example processing   # prints "Example result: 20"
```

## Conventions and gotchas

- `lib.rs` is the contract: reexport with `pub use` from private modules; consumers must never import internal paths (`my_library::core::...` must be impossible from outside).
- Errors always via `thiserror` in `error.rs` — never expose `String` as the error type in the public API. thiserror 2 kept the same derive API as 1.x.
- `mod core;` compiles, but shadows the built-in `core` crate from stdlib inside the crate; if the code needs explicit `core::...` paths, rename the module (e.g. `nucleus`).
- `benches/` is empty on purpose: serious benchmarks require `criterion` in `[dev-dependencies]` + `[[bench]]`; add them only when there is a real hot path.
- For a publishable crate, also set `rust-version` (MSRV) and `license`/`repository` metadata before publishing.
- The script replaces the default name with `$PROJECT_NAME` via `sed` in the manifest and example — `cargo new` uses the real name, but the heredocs write the default one.
