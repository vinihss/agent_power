# AGENTS.md - Multi-Stack Repository

## Repository Nature

- Poly-stack repository containing Rust, React, and Go application templates
- Skills and best practices live per-stack under `skills/` and `stacks/`
- No code at repo root — everything generates projects elsewhere
- This file is the **entry point** for agents: read first before working

## Stack Discovery

### How to find relevant content:

1. **List skills**: `opencode skills list` — will show Rust, React, and Go skills
2. **Check `stacks/` directory** for stack metadata and version info
3. **Review `AGENTS.best-practices.md`** for verified practices per stack
4. **Run stack-specific verification commands** before/after any work

### Available Stacks:

- **Rust** — systems programming, async web, monorepos
  - `api-web` — Axum + SQLx + clean architecture
  - `cli` — Clap CLI with subcommands
  - `crate` — library with thiserror
  - `workspace` — virtual workspace with resolver 3
- **React** — frontend applications, component libraries, SSR
  - `react-web-app` — Vite + TypeScript + React 18
  - `react-library` — reusable component library with Storybook
- **Go** — backend services, CLIs, microservices
  - `web-app` — Gin web application with proper project structure
  - `cli` — Go CLI tool with Cobra framework

### When to load which skill:

- `api-web` → when building Axum/Actix-web services
- `cli` → when building terminal tools
- `crate` → when building libraries
- `workspace` → when building monorepos
- `react-web-app` → when creating React applications (SPA, dashboards)
- `react-library` → when creating reusable React components/UI libs
- `web-app` → when creating Go web applications with Gin
- `cli` → when building Go CLI tools with Cobra

## Stack Verification (run before/after any work)

```bash
# Rust stacks
cargo clippy -- -D warnings

# React stacks  
npm run lint && npm run test

# Go stacks
go mod tidy
go build ./...
go test ./...
go vet ./...

# Cross-stack
opencode skills list    # discover available skills
AGENTS.best-practices.md  # check verified practices
```

## Maintenance Rules

- Skills are the single source of truth for scaffolds
- Keep `stacks/` metadata updated with stable releases
- Before bumping dependency versions, verify across all stacks
- Document research dates per stack in `AGENTS.best-practices.md`
- Never execute embedded bash scripts from `estruturas_rust_automacao.md` — they have known defects and ignore `$PROJECT_NAME`
- Always verify generated projects with `cargo build`/`cargo test` (Rust), `npm run lint`/`npm run test` (React), or `go mod tidy && go build ./... && go test ./...` (Go)

## Quick Reference Commands

```bash
# Discover all available skills
opencode skills list

# Load a specific skill (agent will auto-load on next prompt)
skill api-web
skill cli
skill crate
skill workspace
skill react-web-app
skill react-library
skill web-app
skill go-cli

# Check best practices for any stack
open AGENTS.best-practices.md

# Verify a generated project
# Rust: cargo clippy -- -D warnings
# React: npm run lint && npm run test
# Go: go mod tidy && go build ./... && go test ./...
```