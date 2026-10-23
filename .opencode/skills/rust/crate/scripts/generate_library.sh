#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"my_library"}
cargo new --lib "$PROJECT_NAME"
cd "$PROJECT_NAME"

mkdir -p examples benches

cat << 'EOF' > Cargo.toml
[package]
name = "my_library"
version = "0.1.0"
edition = "2024"

[dependencies]
thiserror = "2"
EOF

cat << 'EOF' > src/lib.rs
mod core;
pub mod error;
mod utils;

pub use core::Processor;
EOF

cat << 'EOF' > src/error.rs
use thiserror::Error;

#[derive(Error, Debug)]
pub enum LibError {
    #[error("Invalid input data")]
    Invalid,
}
EOF

cat << 'EOF' > src/core.rs
use crate::error::LibError;
use crate::utils;

pub struct Processor;

impl Processor {
    pub fn run(&self, value: i32) -> Result<i32, LibError> {
        utils::internal_helper();
        if value < 0 {
            return Err(LibError::Invalid);
        }
        Ok(value * 2)
    }
}
EOF

cat << 'EOF' > src/utils.rs
pub fn internal_helper() {
    // Private internal code
}
EOF

cat << 'EOF' > examples/processing.rs
use my_library::Processor;

fn main() {
    let p = Processor;
    match p.run(10) {
        Ok(res) => println!("Example result: {}", res),
        Err(e) => eprintln!("Error: {}", e),
    }
}
EOF

# cargo new used the real project name; align the heredoc manifest and example
sed -i "s/my_library/${PROJECT_NAME}/g" Cargo.toml examples/processing.rs

echo "✅ Library structure generated successfully!"
