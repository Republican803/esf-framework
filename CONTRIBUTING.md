# Contributing to ESF Framework

Thank you for considering contributing to the ESF Framework! We welcome pull requests, bug reports, and feature suggestions.

## How to Contribute

1. **Fork the Repository**: Click the "Fork" button on GitHub.
2. **Clone Your Fork**: `git clone https://github.com/yourusername/esf-framework.git`
3. **Create a Branch**: Use descriptive names, e.g., `feature/add-mdt-ui` or `fix/core-db-bug`. Branch from `main`.
4. **Make Changes**: Follow coding rules below.
5. **Commit**: Use clear messages, e.g., "Add initial fxmanifest for esf_core".
6. **Push and Open PR**: Target the `main` branch. Use the PR template.
7. **Code Review**: Address feedback.

## Coding Rules

- **Languages**: Lua (server/client/shared), TypeScript (NUI/React).
- **Style**: Run `stylua` and `luacheck` before committing. Use .stylua.toml and .luacheckrc.
- **Events**: Strict contracts; document in EVENTS_API.md.
- **Performance**: Avoid heavy loops; use events/zones. Respect tick budgets.
- **Dependencies**: OX libs (ox_lib, oxmysql, ox_inventory). No external deps without approval.
- **Tests**: Add unit tests in future phases; for now, ensure resources load without errors.
- **SQL**: Versioned migrations in numeric order (e.g., 001_init.sql). No edits to old files.

## PR Style

- Small, focused PRs.
- Include tests/docs updates.
- Reference issues, e.g., "Fixes #123".

## Branching

- `main`: Stable.
- Feature branches: `feature/*`.
- Bugfix: `fix/*`.
- Release: `release/vX.Y.Z`.

See CODE_OF_CONDUCT.md for community standards.