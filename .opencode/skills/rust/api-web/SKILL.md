---
name: "Rust Web API Scaffold (Axum)"
description: "Create a new Rust web service with Axum + SQLx using clean architecture (routes/domain/infra layers). Use when scaffolding REST APIs, HTTP microservices, or Postgres backends."
---

# Web API / Microservice (Axum + SQLx, clean architecture)

## When to use

- A new HTTP service in Axum with Postgres persistence via SQLx and business rules isolated from transport and database layers.
- Do not use for CLIs (`rust-cli`), pure libraries (`rust-crate`), or monorepos (`rust-workspace`).

## How to run

Run from the directory where the project should be created (the script does `cargo new`):

```bash
bash .opencode/skills/rust-api-web/scripts/generate_api_web.sh my_api
```

The name must be a valid crate name (lowercase, no spaces).

## What gets generated

```text
<project>/
├── Cargo.toml            # tokio, axum 0.8, sqlx 0.9 (postgres), tower-http 0.7 (trace), async-trait, dotenvy, tracing
├── .env                  # DATABASE_URL, PORT (added to .gitignore)
├── src/
│   ├── main.rs           # initializes tracing, loads .env, reads Config, starts the server
│   ├── lib.rs
│   ├── config.rs         # Config::from_env()
│   ├── routes/           # HTTP transport (axum Router + TraceLayer, e.g.: GET /health)
│   ├── domain/           # pure entities + traits (UserRepository, AppError)
│   └── infra/            # external implementations (SqlxRepository, hashing)
└── tests/api_tests.rs    # starting point for integration tests
```

Stack: edition 2024, axum 0.8, sqlx 0.9, tower-http 0.7.

## Verification

```bash
cd <project>
cargo build
cargo test
cargo clippy -- -D warnings
cargo fmt --check
RUST_LOG=tower_http=debug cargo run   # GET /health → "OK" + TraceLayer request logs
```

The template does not open a database connection at boot; real Postgres integration requires a server reachable via `DATABASE_URL`.

## Conventions and gotchas

- Layer rule: `domain` never imports from `routes`/`infra`; `infra` implements the traits defined in `domain`; `routes` orchestrates and returns `AppError`.
- The template uses the standalone `async-trait` crate (`#[async_trait]`) on the repository trait. `axum::async_trait` **no longer exists in Axum** (removed in 0.7). Native async fn in traits loses `dyn` compatibility and does not guarantee `Send`; keep `#[async_trait]` if you spawn `Box<dyn ...>` in `tokio::spawn`.
- Axum 0.8 route syntax for path params is `/{param}` — the old `:{param}` from 0.7 no longer works. The scaffold only uses `/health`, so nothing to migrate.
- Tracing is wired end to end: `tracing_subscriber::fmt::init()` in `main` (with `env-filter`) + `TraceLayer` on the router. Control verbosity with `RUST_LOG` (e.g. `RUST_LOG=tower_http=debug`, `RUST_LOG=debug`).
- `Config::from_env` reads `DATABASE_URL` and `PORT` (default 3000); `.env` is loaded in `main` via `dotenvy`. As the app grows, move shared config/state into `Router::with_state` (axum `State` extractor) instead of reading env in handlers.
- Domain errors live in `domain/errors.rs` (`AppError`) — extend with `thiserror` + `IntoResponse` once real handlers exist.
