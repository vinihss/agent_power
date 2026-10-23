---
name: "React Web Application Scaffold"
description: "Create a new React.js application with component-based architecture using TypeScript and Vite. Use ao scaffolder SPA, dashboards ou sistemas de painel admin."
---

# React Web Application (Vite + TypeScript)

## When to use

- New React application with component-based architecture, TypeScript and Vite.
- Use ao scaffolder SPA, dashboards, painel admin ou sites institucionais.
- Não usar para bibliotecas (`react-library`) nem mobile nativo (`react-native`).

## Como executar

Rode na pasta onde o projeto deve ser criado (o script usa `create-react-app` com template TypeScript ou Vite):

```bash
bash .opencode/skills/react/react-web-app/scripts/generate_react_web_app.sh minha_app
```

O nome deve ser um identificador válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── package.json            # react 18, react-dom, vite, typescript, eslint, jest
├── tsconfig.json           # TypeScript config with paths alias
├── vite.config.ts         # Vite build config com alias e plugins
├── src/
│   ├── components/         # UI components (botões, cards, modais, etc)
│   ├── hooks/             # Custom hooks (useFetch, useDebounce, etc)
│   ├── pages/             # Páginas da aplicação (rota-based)
│   ├── App.tsx            # Componente raiz com routing
│   └── main.tsx           # Ponto de entrada ReactDOM.createRoot
├── public/                 # assets e favicon
├── eslint.config.js        # ESLint config com plugin:react/recommended
├── jest.config.js          # Jest config com @testing-library/react
└── src/index.css           # Global styles (reset + variáveis)
```

Stack: TypeScript 5.3, React 18, Vite 5, ESLint 8, Jest 29.

## Verification

```bash
cd <projeto>
npm install          # instala deps
npm run dev          # sobe dev server em http://localhost:5173
npm run build        # build produção em dist/
npm run lint         # ESLint — erros e warnings
npm run test         # Jest + React Testing Library
```

## Convenções e armadilhas

- **Componentes funcionais com hooks** (function components with hooks) — padrão moderno React.
- **Props interfaceadas** (com TypeScript) ou validadas (com PropTypes) — nunca `any` direto.
- **`index.tsx`/`.tsx` deve exportar apenas a superfície pública** — consumidores não devem importar caminhos internos.
- **pastas `components/`, `hooks/`, `utils/`, `styles/`** — convenção recomendada, não rígida.
- **`pages/` para routing** (ou `routes/`) — usar React Router ou file-based routing do Vite.
- **Vite por padrão** — mais rápido que CRA para desenvolvimento; troque para CRA se necessário, mas o scaffold já vem otimizado para Vite.
- **TypeScript estrito** — `noImplicitAny: true`, `strict: true` no `tsconfig.json`.
- **Composição sobre herança** — components combinam via props e hooks, não extendem classes.
- **Custom hooks** para lógica compartilhada — `useFetch`, `useDebounce`, `useForm` etc ficam em `hooks/`.
- **Testes** — `Jest` + `@testing-library/react`; testes devem focar no comportamento do usuário, não implementação interna.

O script usa `create-react-app` com template TypeScript sob o capô, mas configura Vite como dev server para velocidade. Se preferir CRA puro, remova a configuração Vite e ajuste `package.json`.
EOF