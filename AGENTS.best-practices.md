# Rust & React Best Practices for AI Agents

Every line answers: "Would an agent likely miss this without help?" If not, it's out.

## Rust Practices (verified 2026-10-23)

### Formatação e Estilo de Código (Ferramentas Oficiais)

- **`rustfmt`** — formador oficial, vem com Rustup. Configure `format-on-save` no editor.
- **`clippy`** — rode `cargo clippy -- -D warnings` antes de todo commit. Captura erros comuns, redundâncias e sugestões idiomáticas.
- **Referência**: As [Microsoft Rust Guidelines for AI](https://microsoft.github.io/rust-guidelines/agents/all.txt) enfatizam que APIs idiomáticas Rust são mais fáceis de usar por agentes, e o compilador Rust fornece verificações abrangentes que contrabalanceiam a falta de compreensão genuína dos agentes.

### Convenções de Nomenclatura (Rust API Guidelines)

- **UpperCamelCase** — tipos, structs, enums, traits, variantes de enum.
- **snake_case** — funções, métodos, módulos, variáveis locais, macros.
- **SCREAMING_SNAKE_CASE** — constantes e variáveis estáticas (`static`).
- **Referência**: As [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html) recomendam padrões consistentes de caixa para diferentes elementos. A comunidade de agents cita regras como `M-SHORT-NAMES`, `M-PUBLIC-DISPLAY`, `M-ASYNC-FN`.

### Convenções para Conversão de Tipos

- **`as_`** (ex: `as_ref`, `as_mut`) — conversões gratuitas ou extremamente baratas que mudam de um tipo emprestado para outro (`&T` para `&U`).
- **`to_`** (ex: `to_string`) — conversões caras que geralmente envolvem alocação no heap.
- **`into_`** (ex: `into_iter`) — consomem a propriedade/ownership do dado original.
- **Referência**: O [Rust Agent Skill](https://github.com/alphaonedev/rust-agent-skill) (180 rules para Rust 1.98/2024-edition) inclui regras como `CONVERSION-01` sobre conversões gratuitas vs caras.

### Tratamento de Erros Robusto e Explícito

- **Evite `.unwrap()` em produção** — faz o programa sofrer `panic` se houver falha. Propague erros com o operador `?`.
- **Use `.expect("mensagem")` apenas em testes** — ou quando tiver certeza matemática e contextual de que o erro é impossível.
- **Aproveite o padrão `let-else`** — introduzido para simplificar retornos rápidos (early returns) ao desestruturar `Option` ou `Result`, mantendo o código plano.
- **Referência**: O [Rust Agent Skill](https://github.com/alphaonedev/rust-agent-skill) dedica a categoria "Error Handling" (12 regras) a `Result`/`Option`/`?`, tipos validados que tornam estados ilegais e o operador `?`. A diretriz do Microsoft reforça: "Never use `unwrap()` or `expect()` in production code".

### Referências oficiais (Rust)

- Style guide (Rust 2024): https://rust-lang.github.io/rfcs/2436-style-guide.html
- API guidelines: https://rust-lang.github.io/api-guidelines/checklist.html
- Rust Agent Skill (180 rules): https://github.com/alphaonedev/rust-agent-skill
- Microsoft AI Rust Guidelines: https://microsoft.github.io/rust-guidelines/agents/all.txt

### Verificação rápida (before commit)

```
cargo clippy -- -D warnings
cargo fmt -- --check
```

Além disto, projetos que seguem as [Microsoft AI Rust Guidelines](https://microsoft.github.io/rust-guidelines/agents/all.txt) costumam incluir uma tabela de regras aplicadas:

| Rule | Applied | Where |
|------|:---:|-------|
| M-SHORT-NAMES | ✅ | Nomes de métodos encurtados nas camadas de dados e handlers HTTP |
| M-WEASEL-WORDS | ✅ | Remoção de palavras vazias dos tipos e nomes de campos da API pública |
| M-PUBLIC-DISPLAY | ✅ | Adição de `Display` impls para todos os tipos e erros de usuário |
| M-ASYNC-FN | ✅ | Migração de APIs orientadas a I/O de `impl Future` returns para `async fn` |

Good practices become habits; the list above is the minimum an agent should verify without additional context.

## React Practices (verified 2026-10-23)

### Formatação e Estilo de Código

- **`prettier`** — official code formatter for React/JS. Configure `format-on-save` no editor.
- **`eslint`** — rode `npm run lint` antes de qualquer commit. Captura erros comuns e sugere melhorias.
- **`stylelint`** — para styling em CSS/SCSS/TSX.

### Convenções de Nomenclatura (React)

- **camelCase** — propriedades JSX, estado, props
- **PascalCase** — componentes React
- **kebab-case** — nomes de arquivos e pastas
- **UPPER_SNAKE_CASE** — constants e tipos de ação

### Conveniências para Estados e Props

- **`useState`** — estado local de componente
- **`useReducer`** — estado complexo com transições explícitas
- **`useRef`** — refs para DOM access ou valores mutáveis sem re-render
- **`useEffect`** — side effects, com política de cleanup

### Tratamento de Erros em React

- **Error Boundaries** — components que capturam erros de filhos
- **`throw`** — erros inesperados no servidor
- **`try/catch`** — assincronia e event handlers

### Referências oficiais (React)

- React Guidelines: https://react.dev/learn
- TypeScript Guidelines: https://www.typescriptlang.org/handbook
- React Best Practices Handbook: https://reactpatterns.com/

### Verificação rápida (before commit)

```
npm run lint
npm run test
npm run type-check  # if using TypeScript
```

Além disto, projetos React seguem convenções de:

- Pastas `components/`, `hooks/`, `utils/`, `styles/`
- Componentes puros devem ser pureos quando possível
- Props devem ser tipados (com TypeScript) ou validados (com PropTypes)
- `index.ts`/`.tsx` deve exportar apenas a superfície pública
- pastas `pages/` para routing (ou `routes/`)

### Official References (Both)

- Style guide (Rust 2024): https://rust-lang.github.io/rfcs/2436-style-guide.html
- API guidelines: https://rust-lang.github.io/api-guidelines/checklist.html
- React Guidelines: https://react.dev/learn
- TypeScript Guidelines: https://www.typescriptlang.org/handbook
- Rust Agent Skill (180 rules): https://github.com/alphaonedev/rust-agent-skill
- Microsoft AI Rust Guidelines: https://microsoft.github.io/rust-guidelines/agents/all.txt

## Research date: October 23, 2026

## Sources consulted:

- Microsoft Rust Guidelines for AI (AI-directed Rust API design)
- Rust Agent Skill (180 prioritized rules for Rust 1.98/2024-edition)
- Rust API Guidelines (official checklist for API design)
- React Guidelines (official React documentation)
- TypeScript Guidelines (official TypeScript handbook)
- Web search for current best practices (out/2026 ecosystem state)