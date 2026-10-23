#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"my_monorepo"}
mkdir -p "$PROJECT_NAME"/{crates,services}
cd "$PROJECT_NAME"

# Create the crates BEFORE the root manifest: if [workspace] exists first,
# every cargo new warns that the glob (e.g. services/*) has no members yet.
cargo new --lib crates/core_models
cargo new --lib crates/crypto_utils
cargo new --bin services/api_backend
cargo new --bin services/cli_tool

# Root workspace manifest (virtual workspace: only [workspace], no [package]).
# resolver = "3" is the edition-2024 resolver (Rust-version aware fallback).
cat << 'EOF' > Cargo.toml
[workspace]
members = [
    "crates/*",
    "services/*",
]
resolver = "3"

[workspace.dependencies]
core_models = { path = "crates/core_models" }
crypto_utils = { path = "crates/crypto_utils" }
EOF

# Backend service consumes the internal models crate via workspace inheritance
cat << 'EOF' > services/api_backend/Cargo.toml
[package]
name = "api_backend"
version = "0.1.0"
edition = "2024"

[dependencies]
core_models.workspace = true
EOF

# CLI tool consumes models and crypto utilities via workspace inheritance
cat << 'EOF' > services/cli_tool/Cargo.toml
[package]
name = "cli_tool"
version = "0.1.0"
edition = "2024"

[dependencies]
core_models.workspace = true
crypto_utils.workspace = true
EOF

echo "✅ Cargo workspace initialized and configured successfully!"
