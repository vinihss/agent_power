---
name: "Rust CLI Scaffold (Clap)"
description: "Create a new Rust command-line tool with Clap (derive), subcommands, a UI module, and custom errors. Use when scaffolding CLIs and terminal utilities."
---

# CLI (Clap, subcommands)

## When to use

- A new terminal tool in Rust with strict argument and subcommand parsing.
- Do not use for web services (`rust-api-web`), libraries (`rust-crate`), or monorepos (`rust-workspace`).

## How to run

Run from the directory where the project should be created (the script does `cargo new`):

```bash
bash .opencode/skills/rust-cli/scripts/generate_cli.sh my_tool
```

The name must be a valid crate name (lowercase, no spaces).

## What gets generated

```text
<project>/
├── Cargo.toml            # clap 4 (derive), indicatif
├── src/
│   ├── main.rs           # Cli::parse() → run_command()
│   ├── lib.rs
│   ├── cli.rs            # derive structs/enums (Parser, Subcommand) — definition only
│   ├── errors.rs         # CliError
│   ├── ui.rs             # output formatting (print_success)
│   └── commands/         # one module per subcommand
│       ├── mod.rs        # dispatches Commands → modules
│       ├── create.rs
│       └── list.rs
└── tests/                # starting point for process-level tests via the binary
```

Stack: edition 2024, clap 4.

## Verification

```bash
cd <project>
cargo build
cargo clippy -- -D warnings
cargo fmt --check
cargo run -- --help      # clap-generated help
cargo run -- create foo  # subcommand with argument
cargo run -- list        # subcommand without argument
```

## Conventions and gotchas

- Strict separation: `cli.rs` only declares arguments; each subcommand's logic lives in `commands/<name>.rs` (`pub fn run(...)`); `commands/mod.rs` only does the dispatching `match`. `ui.rs` owns output formatting (spinners via `indicatif` go here, not in commands).
- To add a subcommand: enum variant in `cli.rs` + new module in `commands/` + `match` arm in `commands/mod.rs` (all three; forgetting the match arm breaks compilation).
- Clap 4 syntax: `#[command(...)]`/`#[arg(...)]` attributes (Clap 3's `#[clap(...)]` no longer exists).
- Doc comments above variants automatically become subcommand help.
- The script replaces the default name with `$PROJECT_NAME` via `sed` in the manifest and imports — `cargo new` uses the real name, but the heredocs write the default one.
