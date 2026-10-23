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
bash .opencode/skills/nodejs/backend/scripts/gerar_backend.go minha_api
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

## Script de Automação Bash (`gerar_backend.go`)

```bash
#!/bin/bash
set -euo pipefail

PROJECT_NAME=${1:-"minha-api"}

# Create project directory
mkdir -p "$PROJECT_NAME"/{src/{api/controllers,api/models,api/middleware,api/routes,v1},.env,tests,config}

# Initialize npm project
cd "$PROJECT_NAME"
npm init -y > /dev/null 2>&1

# Install dependencies
npm install express reflect-metadata @types/express cors helmet morgan jsonwebtoken bcryptjs dayjs
npm install -D @types/node @types/express @types/jest ts-jest jest supertest

# TypeScript config
cat > tsconfig.json << 'TSCONF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "commonjs",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "forceConsistentCasingInFileNames": true,
    "outDir": "./dist",
    "rootDir": "./src",
    "declaration": true,
    "sourceMap": true
  },
  "include": ["src/**/*"],
  "exclude": ["node_modules", "dist"]
}
TSCONF

# Source files
cat > src/index.ts << 'INDEX'
import "./src/app";
INDEX

cat > src/app.ts << 'APP'
import express, { Request, Response, NextFunction } from "express";
import helmet from "helmet";
import cors from "cors";
import morgan from "morgan";
import dotenv from "dotenv";
import router from "./api/routes";

dotenv.config();

const app = express();
const port = process.env.PORT || 3000;

app.use(helmet());
app.use(cors());
app.use(morgan("combined"));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use("/api", router);

app.use((err: Error, req: Request, res: Response) => {
  console.error(err.stack);
  res.status(500).json({ error: "Something failed!" });
});

app.listen(port, () => {
  console.log(`🚀 Server running at http://localhost:${port}`);
});
APP

# Create directory structure
mkdir -p src/api/routes src/api/controllers src/api/models src/middleware src/config src/database

# Create .env.example
cat > .env.example << 'EXAMPLE'
PORT=3000
DATABASE_URL=postgres://user:password@localhost:5432/dbname
JWT_SECRET=your_jwt_secret
NODE_ENV=development
EXAMPLE

# Create src/api/routes/index.ts
cat > src/api/routes/index.ts << 'ROUTES'
import { Router } from "express";
import userRouter from "../controllers/user.controller";

const router = Router();
router.use("/users", userRouter);
export default router;
ROUTES

# Create src/api/controllers/user.controller.ts
cat > src/api/controllers/user.controller.ts << 'CONTROLLER'
import { Request, Response } from "express";

export const getUsers = (req: Request, res: Response) => {
  res.json({ message: "List of users" });
};

export const createUser = (req: Request, res: Response) => {
  const { name, email } = req.body;
  res.status(201).json({ message: `User ${name} created`, user: { name, email } });
};
CONTROLLER

# Create src/middleware/error.middleware.ts
cat > src/middleware/error.middleware.ts << 'ERROR_MW'
import { Request, Response, NextFunction } from "express";

export const errorHandler = (err: Error, req: Request, res: Response, next: NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ error: "Internal Server Error" });
  next();
};
ERROR_MW

# Create src/middleware/auth.middleware.ts
cat > src/middleware/auth.middleware.ts << 'AUTH_MW'
import jwt from "jsonwebtoken";

export const authenticateToken = (req: Request, res: Response, next: NextFunction) => {
  const authHeader = req.headers["authorization"];
  const token = authHeader && authHeader.split(" ")[1];
  if (!token) return res.status(401).json({ error: "Access denied" });
  jwt.verify(token, process.env.JWT_SECRET!, (err, user) => {
    if (err) return res.status(403).json({ error: "Invalid token" });
    req.user = user;
    next();
  });
};
AUTH_MW

# Create src/config/index.ts
cat > src/config/index.ts << 'CONFIG'
export const PORT = process.env.PORT || 3000;
export const JWT_SECRET = process.env.JWT_SECRET || "default-secret";
export const NODE_ENV = process.env.NODE_ENV || "development";
CONFIG

# Create tests
cat > tests/user.test.ts << 'TEST'
import request from "supertest";
import app from "../src/index";

describe("User Endpoints", () => {
  describe("GET /api/users", () => {
    it("should return list of users", async () => {
      const response = await request(app).get("/api/users");
      expect(response.status).toBe(200);
      expect(response.body).toHaveProperty("message");
    });
  });

  describe("POST /api/users", () => {
    it("should create a new user", async () => {
      const response = await request(app).post("/api/users").send({ name: "Test", email: "test@test.com" });
      expect(response.status).toBe(201);
      expect(response.body).toHaveProperty("message");
    });
  });
});
TEST

# Create jest.config.ts
cat > jest.config.ts << 'JEST'
{
  "preset": "ts-jest",
  "testEnvironment": "node"
}
JEST

# Create .gitignore
cat > .gitignore << 'GITIGNORE'
node_modules
dist
.env
*.log
EXAMPLE

echo "✅ Node.js Backend Application gerada com sucesso!"