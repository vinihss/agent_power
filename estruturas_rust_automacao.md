# Project Structures — Multi-Stack Index

This file is an **index** pointing to skills for each stack. The executable templates live only in `.opencode/skills/`.

Mantenha seu `src/` ou `lib.rs` sempre limpo e gerencie o crescimento através de componentes/módulos bem delimitados.

## 1. Rust Web API (Axum + SQLx, arquitetura limpa)
- **Skill**: `rust-api-web`
- **Geração**: `bash .opencode/skills/rust-api-web/scripts/generate_api_web.sh <nome>`
- **Stack**: Rust systems programming, async web, clean architecture
- **Verificação**: `cargo clippy -- -D warnings`, `cargo test`, `GET /health → OK`

## 2. Ferramentas de Linha de Comando (CLI)
- **Skill**: `rust-cli`
- **Geração**: `bash .opencode/skills/rust-cli/scripts/generate_cli.sh <nome>`
- **Stack**: Rust terminal tools, argument parsing
- **Verificação**: `cargo build`, `cargo run -- --help`, subcomandos funcionando

## 3. Bibliotecas Reutilizáveis (Crates)
- **Skill**: `rust-crate`
- **Geração**: `bash .opencode/skills/rust-crate/scripts/generate_library.sh <nome>`
- **Stack**: Rust libraries, thiserror, API pública enxuta
- **Verificação**: `cargo build`, `cargo test`, example execution

## 4. Monorepos / Sistemas Grandes (Cargo Workspaces)
- **Skill**: `rust-workspace`
- **Geração**: `bash .opencode/skills/rust-workspace/scripts/generate_workspace.sh <nome>`
- **Stack**: Rust monorepos, resolver 3, path deps
- **Verificação**: `cargo build --workspace`, `cargo test --workspace`

## 5. React Web Application (Vite + TypeScript)
- **Skill**: `react-web-app`
- **Geração**: `bash .opencode/skills/react/react-web-app/scripts/generate_react_web_app.sh <nome>`
- **Stack**: Frontend SPA, dashboards, painéis admin
- **Verificação**: `npm run dev`, `npm run build`, `npm run lint`, `npm run test`

## 6. Bibliotecas Reutilizáveis (React)
- **Skill**: `react-library`
- **Geração**: `bash .opencode/skills/react/react-library/scripts/generate_react_library.sh <nome>`
- **Stack**: Componentes reutilizáveis, design systems, UI libraries
- **Verificação**: `npm run build`, `npm run storybook`, `npm run test`, `npm run lint`

## How to Discover Skills

```bash
# List all available skills
opencode skills list

# Load a specific skill (agent will auto-load on next prompt)
# - rust-api-web, rust-cli, rust-crate, rust-workspace
# - react-web-app, react-library

# Check best practices for any stack
open AGENTS.best-practices.md

# Verify a generated project
# Rust: cargo clippy -- -D warnings
# React: npm run lint && npm run test
```

## Verification (all stacks)

```bash
# Rust
cargo clippy -- -D warnings

# React  
npm run lint && npm run test
```

## Maintenance Rules

- Skills are the single source of truth for scaffolds
- Keep embedded scripts in `estruturas_rust_automacao.md` only as an index — do not execute them directly
- Always verify generated projects with stack-specific commands
- Research dates per stack:
  - Rust: 2026-10-23 (edition 2024, axum 0.8, sqlx 0.9, tower-http 0.7)
  - React: 2026-10-23 (React 18, Vite 5, TypeScript 5.3)
- When in doubt, omit — prefer the skills over copy-pasting from this index