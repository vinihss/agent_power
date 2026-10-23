---
name: "Rust Monorepo Scaffold (Workspace)"
description: "Create a Rust monorepo with a Cargo workspace: crates/ for shared libraries, services/ for final binaries, [workspace.dependencies] inheritance, and glob members. Use for systems with multiple crates."
---

# Monorepo / Cargo workspace

## When to use

- A system with multiple crates: shared libraries plus one or more final binaries, unified builds, and a single build cache.
- Do not use for single-crate projects (`rust-api-web`, `rust-cli`, `rust-crate`).

## How to run

Run from the parent directory of the monorepo (the script creates the tree and the crates with `cargo new`):

```bash
bash .opencode/skills/rust-workspace/scripts/generate_workspace.sh my_system
```

Order matters during bootstrap: the script creates the crates **before** writing the root `Cargo.toml` — if `[workspace]` exists first, every `cargo new` warns that the glob has no members yet.

## What gets generated

```text
<monorepo>/
├── Cargo.toml                    # VIRTUAL workspace: [workspace] (glob members, resolver = "3")
│                                 # + [workspace.dependencies] (path deps declared once)
├── crates/                       # shared libraries
│   ├── core_models/              # business structs/enums
│   └── crypto_utils/             # reusable crypto components
└── services/                     # final compilable applications
    ├── api_backend/              # core_models.workspace = true
    └── cli_tool/                 # core_models + crypto_utils via workspace = true
```

Stack: edition 2024, resolver 3 (Rust-version aware dependency resolution).

## Verification

```bash
cd <monorepo>
cargo build --workspace
cargo test --workspace
cargo clippy --workspace -- -D warnings
cargo fmt --all --check
cargo run -p api_backend
cargo run -p cli_tool
```

Note: on a virtual workspace root, `cargo fmt` needs `--all` to find targets — plain `cargo fmt --check` fails with "Failed to find targets".

Whenever possible, run commands from the root with `-p <crate>`; the root `target/` is the shared cache that makes workspaces fast.

## Conventions and gotchas

- The root is a virtual workspace: never put code or `[package]` at the root. Final crates (with `main.rs`) go in `services/`; libraries go in `crates/`.
- Declare shared dependencies once in `[workspace.dependencies]` (path, version, common features) and consume them in members with `workspace = true` — do not duplicate dependency versions across member manifests.
- `members = ["crates/*", "services/*"]` with globs: new crates inside those folders are picked up automatically; a crate outside the globs must be added to `members` manually (otherwise cargo reports "believes it's in a workspace when it's not").
- `resolver = "3"` is required here because the workspace is virtual: resolver settings are not inferred from member editions in a virtual root. Resolver 3 brings Rust-version aware fallback.
- Since the workspace contains binaries, commit the root `Cargo.lock`.
- The script creates all four crates of the layout and wires the services' `Cargo.toml` via workspace inheritance; the bins start with hello-world — replace with real usage of the internal crates.
