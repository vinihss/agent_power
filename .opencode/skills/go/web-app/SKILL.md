---
name: "Go Web Application"
description: "Create a new Go web application with Gin framework, proper project structure, and best practices. Use ao scaffolder APIs, microservicos, ou backends com Go."
---

# Go Web Application (Gin + SQLX-like concepts)

## When to use

- New serviço web em Go com Gin e roteamento limpo.
- Use ao scaffolder APIs REST, microsserviços HTTP ou backends com persistência.
- Não usar para CLI (`go-cli`) nem bibliotecas puras (`go-library`).

## Como executar

Rode na pasta onde o projeto deve ser criado:

```bash
bash .opencode/skills/go/web-app/scripts/gerar_web.go minha_api
```

O nome deve ser um diretório válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── main.go               # Ponto de entrada do application
├── go.mod              # Módulo Go com dependências
├── internal/
│   ├── config/          # Configuração de ambiente e logging
│   ├── db/              # Camada de abstração de banco de dados
│   └── middleware/      # Middleware de logging, recovery, cors
├── api/
│   └── v1/              # Versão da API com endpoints
│       └── router.go    # Roteador Gin
├── cmd/
│   └── api/             # Entry point para o binary Gin
├── go.sum
└── Dockerfile           # Configuração para containerização
```

Stack: Go 1.22, Gin 1.10, modern Go patterns.

## Verification

```bash
cd <projeto>
go mod tidy
go build ./...
go test ./...
go vet ./...
```

The template generates a clean, testable Go application with proper separation of concerns.

## Convenções e armadilhas

- **Pastas `internal/`** — código privado do módulo Go, não importável fora do projeto.
- **Pastas `api/`** — endpoints da API, organizados por versão.
- **Pastas `cmd/`** — entry points para binários; cada binary tem seu próprio `main.go`.
- **Middleware** — Gin middleware para logging, recovery, cors devem ficar em `internal/middleware`.
- **Database abstraction** — não usar ORMs pesados; prefere-se `database/sql` com prepared statements.
- **Error handling** — erros devem ser explícitos; criar tipos de erro customizados em vez de usar apenas `error`.
- **Environment variables** — configurar via `viper` ou `os.Getenv`; nunca hardcode de secrets.
- **Dockerfile** — multi-stage build recomendado para imagens menores.

O script gera um projeto pronto para ser estendido, seguindo padrões de engenharia de software em Go.