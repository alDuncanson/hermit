# AGENTS.md

Instructions in this file apply to the entire repository.

## Commit Convention

- Use Conventional Commits for every commit message.
- Format: `type(scope): short summary`.
- Allowed types: `feat`, `fix`, `docs`, `refactor`, `test`, `chore`, `ci`, `build`, `perf`.
- Keep summary imperative and under 72 characters.

## Project Guidelines

- Keep this repository minimal and shell-first.
- Prefer concise docs with one command per fenced block.
- Use `hermit` as the default local image tag in examples.
- Keep Docker instructions compatible with plain Docker CLI usage.
