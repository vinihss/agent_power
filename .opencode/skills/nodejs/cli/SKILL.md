---
name: "Node.js CLI Tool"
description: "Create a new Node.js CLI tool with Commander framework, subcommands, and best practices. Use ao scaffolder ferramentas de terminal e utilitários."
---

# Node.js CLI Tool (Commander)

## When to use

- Nova ferramenta de linha de comando em Node.js.
- Use para utilitários de terminal, scripts de automação e tools de produtividade.
- Não usar para serviços web (`node-backend`) nem bibliotecas puras (`node-library`).

## Como executar

Rode na pasta onde o projeto deve ser criado:

```bash
bash .opencode/skills/nodejs/cli/scripts/gerar_cli.go minha_ferramenta
```

O nome deve ser um diretório válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── src/
│   ├── index.ts          # Ponto de entrada do CLI
│   └── commands/         # Comandos do CLI
│       ├── index.ts      # Registro de comandos
│       ├── create.ts     # Command: create
│       └── list.ts       # Command: list
├── package.json          # Dependências: commander, inquirer
├── .gitignore
├── .env.example          # Exemplo de variáveis de ambiente
├── jest.config.ts        # Test configuration
└── README.md
```

Stack: Node.js 20, Commander 11, Inquirer 9, Jest.

## Verification

```bash
cd <projeto>
npm install
npm run build       # se usar TypeScript
npm run lint        # ESLint check
npm run test        # Jest tests
```

Generated CLI is ready for use after `npm install`.

## Convenções e armadilhas

- **Commander** — estrutura padrão para CLIs em Node.js; commands ficam em `src/commands/`.
- **Inquirer** — biblioteca para prompts interativos; usada para coletar entrada do usuário.
- **Hierarquia de comandos** — command principal com subcomandos `create`, `list`, `remove`; fácil extensão com novos subcomandos.
- **Flags persistentes** — Commander suporta flags persistentes em todos os subcomandos via `program.addOption()`.
- **Tratamento de erros** — erros devem ser retornados explicitamente; usar `commander.parse(process.argv)` para validar args.
- **Help text** — Commander gera help automático; docstrings em cada command ficam disponíveis via `--help`.
- **Testes** — Jest + Inquirer.mock para testes de prompts; testes de comando via `commander`.

O script gera um projeto CLI pronto para uso imediato, seguindo convenções do ecossistema Node.js.