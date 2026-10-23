---
name: "React Library Scaffold"
description: "Create a new reusable React component library with TypeScript, styled-components (optional) and storybook. Use ao scaffolder componentes reutilizáveis,design systems ou bibliotecas de UI."
---

# React Library (Component Library)

## When to use

- New biblioteca reutilizável de componentes React com TypeScript.
- Use ao scaffolder design systems, bibliotecas de UI, componentes de botão, input, card, etc.
- Não usar para aplicações completas (`react-web-app`) nem mobile nativo (`react-native`).

## Como executar

Rode na pasta onde o projeto deve ser criado (o script cria a estrutura da biblioteca):

```bash
bash .opencode/skills/react/react-library/scripts/generate_react_library.sh minha-biblioteca
```

O nome deve ser um identificador válido (minúsculas, sem espaços).

## O que é gerado

```text
<projeto>/
├── package.json            # @types/react, storybook, jest, typescript
├── tsconfig.json           # TypeScript config lib config
├── src/
│   ├── components/         # componentes da biblioteca (Button, Input, Card)
│   ├── styles/            # estilos (styled-components ou CSS módulos)
│   ├── index.ts           # superfície pública — exporta todos os componentes
│   └── types/             # tipos compartilhados (Props, States)
├── stories/                # storybook stories para cada componente
├── __tests__/             # testes unitários para componentes
├── package-lock.json
└── src/index.css           # global styles (reset + variáveis)
```

Stack: TypeScript 5.3, @types/react 18, Storybook 8, Jest 29, Styled Components 6.

## Verification

```bash
cd <projeto>
npm install
npm run build      # build da biblioteca (lib/ folder)
npm run storybook  # storybook dev server
npm run test         # Jest unit tests
npm run lint       # ESLint + TypeScript check
```

## Convenções e armadilhas

- **`index.ts` é a superfície pública** — apenas reexporta componentes e tipos; consumidores não importam caminhos internos.
- **Tipagem de Props** — todos os componentes devem tipar seus Props interfaces; nunca `any` direto.
- **Styled Components ou CSS Modules** — escolher um e manter consistente; styled-components usa `css` tagged template literal.
- **Storybook** — stories devem ser auto-documentativas; `argTypes` recomendado para documentação automática.
- **Jest + React Testing Library** — testes focam no comportamento do usuário (user events), não implementação interna.
- **Componentes puros** — devem ser pureos quando possível (`React.memo` ou `memo()`).
- **Accessibility** — `aria-label`, roles adequados, focus management em componentes interativos.
- **Versionamento** — o script define `version: "0.1.0"`, ajuste conforme necessário antes de publicar no npm.

O script cria uma biblioteca pronta para publicação — basta `npm version patch` e `npm publish` quando estiver pronto.
EOF