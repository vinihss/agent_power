# Rust Best Practices for Agents

Every line answers: "Would an agent likely miss this without help?" If not, it's out.

## Formatting and Code Style (Official Tools)

- **`rustfmt`** — official code formatter, comes with Rustup. Configure `format-on-save` in your editor.
- **`clippy`** — run `cargo clippy -- -D warnings` before every commit. Captures common errors, redundancies, and idiomatic improvements.
- **Reference**: The [Microsoft Rust Guidelines for AI](https://microsoft.github.io/rust-guidelines/agents/all.txt) emphasize that idiomatic Rust APIs are easier for agents to use, and the Rust compiler provides abundant checks that counterbalance agents' lack of genuine understanding.

## Naming Conventions (Rust API Guidelines)

- **UpperCamelCase** — types, structs, enums, traits, enum variants.
- **snake_case** — functions, methods, modules, local variables, macros.
- **SCREAMING_SNAKE_CASE** — constants and static variables (`static`).
- **Reference**: The [Rust API Guidelines](https://rust-lang.github.io/api-guidelines/checklist.html) recommend consistent case for different elements. The agent community cites rules such as `M-SHORT-NAMES`, `M-PUBLIC-DISPLAY`, `M-ASYNC-FN`.

## Type Conversion Conventions

- **`as_`** (e.g., `as_ref`, `as_mut`) — free or extremely cheap conversions that change from one borrowed type to another (`&T` to `&U`).
- **`to_`** (e.g., `to_string`) — expensive conversions that generally involve heap allocation.
- **`into_`** (e.g., `into_iter`) — consume the original data's ownership.
- **Reference**: The [Rust Agent Skill](https://github.com/alphaonedev/rust-agent-skill) (180 rules for Rust 1.98/2024-edition) includes rules such as `CONVERSION-01` on free vs. expensive conversions.

## Robust and Explicit Error Handling

- **Avoid `.unwrap()` in production** — causes the program to panic on failure. Propagate errors using the `?` operator instead.
- **Use `.expect("message")` only in tests** — or when you have mathematical and contextual certainty that the error is impossible.
- **Leverage the `let-else` pattern** — introduced to simplify early returns (early returns) when destructuring `Option` or `Result`, keeping code flat.
- **Reference**: The [Rust Agent Skill](https://github.com/alphaonedev/rust-agent-skill) dedicates its "Error Handling" category (12 rules) to `Result`/`Option`/`?`, validated types that make illegal states unrepresentable, and the `?` operator. The Microsoft directive reinforces: "Never use `unwrap()` or `expect()` in production code".

## Official References

- Style guide (Rust 2024): https://rust-lang.github.io/rfcs/2436-style-guide.html
- API guidelines: https://rust-lang.github.io/api-guidelines/checklist.html
- Rust Agent Skill (180 rules): https://github.com/alphaonedev/rust-agent-skill
- Microsoft AI Rust Guidelines: https://microsoft.github.io/rust-guidelines/agents/all.txt

## Quick Verification (before commit)

```
cargo clippy -- -D warnings
cargo fmt -- --check
```

Additionally, projects following the [Microsoft AI Rust Guidelines](https://microsoft.github.io/rust-guidelines/agents/all.txt) often include an applied rules table:

| Rule | Applied | Where |
|------|:---:|-------|
| M-SHORT-NAMES | ✅ | Shortened method names across data-access and HTTP handler layers |
| M-WEASEL-WORDS | ✅ | Removal of weasel words from type and field names throughout the public API |
| M-PUBLIC-DISPLAY | ✅ | Added `Display` impls for all user-facing identifier and error types |
| M-ASYNC-FN | ✅ | Migrated I/O-facing APIs from `impl Future` returns to `async fn` |

Good practices become habits; the list above is the minimum an agent should verify without additional context.

**Research date**: October 23, 2026
**Sources consulted**:
- Microsoft Rust Guidelines for AI (AI-directed Rust API design)
- Rust Agent Skill (180 prioritized rules for Rust 1.98/2024-edition)
- Rust API Guidelines (official checklist for API design)
- Rust 2024 Style RFC (language style guide)
- Web search for current best practices (out/2026 ecosystem state)
