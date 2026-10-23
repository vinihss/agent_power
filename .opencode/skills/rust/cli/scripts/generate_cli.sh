#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"my_cli"}
cargo new --bin "$PROJECT_NAME"
cd "$PROJECT_NAME"

mkdir -p src/commands tests

cat << 'EOF' > Cargo.toml
[package]
name = "my_cli"
version = "0.1.0"
edition = "2024"

[dependencies]
clap = { version = "4", features = ["derive"] }
indicatif = "0.17"
EOF

cat << 'EOF' > src/lib.rs
pub mod cli;
pub mod commands;
pub mod errors;
pub mod ui;
EOF

cat << 'EOF' > src/cli.rs
use clap::{Parser, Subcommand};

#[derive(Parser)]
#[command(name = "my_cli", version = "1.0", about = "An automated Rust CLI")]
pub struct Cli {
    #[command(subcommand)]
    pub command: Commands,
}

#[derive(Subcommand)]
pub enum Commands {
    /// Create a resource with the given name
    Create { name: String },
    /// List all resources
    List,
}
EOF

cat << 'EOF' > src/errors.rs
#[derive(Debug)]
pub enum CliError {
    ExecutionFailed(String),
}
EOF

cat << 'EOF' > src/ui.rs
pub fn print_success(msg: &str) {
    println!("✨ {}", msg);
}
EOF

cat << 'EOF' > src/commands/mod.rs
use crate::cli::Commands;

pub mod create;
pub mod list;

pub fn run_command(command: Commands) {
    match command {
        Commands::Create { name } => create::run(&name),
        Commands::List => list::run(),
    }
}
EOF

cat << 'EOF' > src/commands/create.rs
use crate::ui;

pub fn run(name: &str) {
    println!("Creating resource: {}", name);
    ui::print_success("Resource created successfully!");
}
EOF

cat << 'EOF' > src/commands/list.rs
pub fn run() {
    println!("Listing all resources...");
}
EOF

cat << 'EOF' > src/main.rs
use clap::Parser;
use my_cli::cli::Cli;
use my_cli::commands::run_command;

fn main() {
    let args = Cli::parse();
    run_command(args.command);
}
EOF

# cargo new used the real project name; align the heredoc manifests and imports
sed -i "s/my_cli/${PROJECT_NAME}/g" Cargo.toml src/cli.rs src/main.rs

echo "✅ CLI structure generated successfully!"
