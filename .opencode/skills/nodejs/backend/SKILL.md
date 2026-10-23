---
name: "Node.js Backend Application"
description: "Create a new Node.js/TypeScript backend application with Express framework, proper project structure, and best practices. Use ao scaffolder APIs REST, microserviços HTTP ou backends com persistência."
---

# Node.js Backend Application (Express + TypeScript)

## When to use

- New serviço web em Node.js/TypeScript com Express.
- Use ao scaffolder APIs REST, microsserviços HTTP ou backends com persistência.
- Não usar para CLI (`node-cli`) nem bibliotecas puras (`node-library`).

## Como executar

Rode na pasta onde o projeto deve ser criado:

```bash
bash .opencode/skills/nodejs/backend/scripts/gerar_backend.sh minha_api
```

O nome deve ser um diretório válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── src/
│   ├── index.ts          # Ponto de entrada da aplicação
│   ├── app.ts            # Configuração do Express
│   ├── routes/           # Roteadores da API
│   │   ├── index.ts      # Roteador principal
│   │   └── v1.ts         # Endpoints da versão 1
│   ├── controllers/      # Controladores da lógica
│   │   ├── index.ts
│   │   └── user.controller.ts
│   ├── models/           # Modelos de dados (Typegoose / Sequelize / TypeORM)
│   ├── services/         # Serviços de negócio
│   ├── middleware/       # Middleware (autenticação, autorização, erro)
│   ├── config/           # Configuração de ambiente (dotenv, viper)
│   └── database/         # Configuração de conexão com banco de dados
├── .env                  # Variáveis de ambiente (PORT, DATABASE_URL, JWT_SECRET)
├── .env.example          # Exemplo de variáveis de ambiente (sem secrets)
├── tsconfig.json         # TypeScript config
├── package.json          # Dependências: express, type, reflect-metadata
├── docker-compose.yml    # Configuração para desenvolvimento (banco, redis)
├── Dockerfile            # Multi-stage build para produção
├── .gitignore
├── README.md
└── jest.config.ts        # Test configuration
```

Stack: Node.js 20, Express 4, TypeScript 5, Jest, Supertest.

## Verification

```bash
cd <projeto>
npm install
npm run dev          # Compila e sobe em http://localhost:3000
npm run build        # TypeScript compilation check
npm run lint         # ESLint check
npm run test         # Jest tests
```

## Convenções e armadilhas

- **Pastas `src/`** — todo o código da aplicação fica dentro de `src/`.
- **Controladores** — a lógica de cada endpoint fica em `controllers/`.
- **Serviços** — business logic fica em `services/`, mantendo controladores magros.
- **Middleware** — logging, auth, error handling ficam em `middleware/`.
- **TypeScript estrito** — `noImplicitAny: true`, `strict: true` no `tsconfig.json`.
- **Environment variables** — configurar via `.env`; nunca commitar secrets.
- **Roteadores** — API versionada em `src/routes/v1.ts`; fácil extensão para `v2`, `v3`.
- **Banco de dados** — usar Typegoose (MongoDB), Sequelize ou TypeORM; o scaffold inclui configuração de conexão pronta.
- **Autenticação** — estratégia JWT com refresh tokens; middleware de auth em `middleware/auth.ts`.
- **Testes** — Jest + Supertest para endpoints HTTP; testes de integração em `src/database/`.

O script gera um projeto pronto para ser estendido, seguindo boas práticas de Node.js/TypeScript enterprise.
---