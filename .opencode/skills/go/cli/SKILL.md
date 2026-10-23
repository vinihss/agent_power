---
name: "Go CLI Tool"
description: "Create a new Go command-line tool with Cobra framework, subcommands, and best practices. Use ao scaffolder ferramentas de terminal e utilitários."
---

# Go CLI Tool (Cobra)

## When to use

- Nova ferramenta de linha de comando em Go com Cobra.
- Use para utilitários de terminal, scripts de automação e tools de produtividade.
- Não usar para serviços web (`go-web-app`) nem bibliotecas puras (`go-library`).

## Como executar

Rode na pasta onde o projeto deve ser criado:

```bash
bash .opencode/skills/go/cli/scripts/gerar_cli.go minha_ferramenta
```

O nome deve ser um diretório válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── main.go               # Entry point do CLI com Cobra
├── go.mod              # Módulo Go com dependências Cobra e indicatif
├── cmd/
│   └── root.go          # Root command definition
│   └── create.go        # Command: create
│   └── list.go          # Command: list
│   └── version.go       # Command: version
├── internal/
│   └── utils/           # Funções utilitárias auxiliares
├── go.mod
├── go.sum
└── Dockerfile           # Configuração para containerização
```

Stack: Go 1.22, Cobra 1.8, indicatif 1.32.

## Verification

```bash
cd <projeto>
go mod tidy
go build ./...
go test ./...
go vet ./...
```

Generated CLI is ready for use after `go install` or `go build`.

## Convenções e armadilhas

- **Cobra** — estrutura padrão para CLIs em Go; commands ficam em `cmd/`.
- **indicatif** — biblioteca para spinners e progress bars; usada em `internal/utils/`.
- **Command hierarchy** — root command com subcomandos `create`, `list`, `version`; fácil extensão com novos subcomandos.
- **Persistent flags** — cobra suporta flags persistentes em todos os subcomandos via `root.PersistentFlags()`.
- **Error handling** — erros devem ser retornados explicitamente; usar `cobra.CheckForExtraArgs` para validar args.
- **Version command** — comando `version` deve printar a versão do application e sair.
- **Help text** — Cobra gera help automático; docstrings em cada command ficam disponíveis via `--help`.
- **Dockerfile** — multi-stage build recomendado; binary estático para imagens pequenas.

O script gera um projeto CLI pronto para uso imediato, seguindo convenções do ecossistema Go.
EOF