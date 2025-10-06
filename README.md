# ESF Framework

ESF (Emergency Services Framework) is a FiveM framework for realistic, immersive first-responder simulations in GTA V/FiveM. It enables players to role-play as Law Enforcement, Firefighters, or EMS personnel in a PvE-focused environment (Player vs. PED/AI, like LSPDFR). Key features include an intelligent dispatch system, hyper-realistic MDT, advanced AI for peds and traffic, and modular resources.

## Quickstart

1. Clone the repo: `git clone https://github.com/yourusername/esf-framework.git`
2. Copy `resources/` to your FiveM server's resources folder.
3. Add to your `server.cfg` (use `server.cfg.example` as a template):
4. Start your server and connect. (Resources are empty in Phase 0; no functionality yet.)

## Setup for Development

- Install OX libraries: Ensure `ox_lib`, `ox_inventory`, and `oxmysql` are in your server resources.
- Database: Run SQL migrations from `resources/[esf]/*/sql/` in order (none yet in Phase 0).
- Tools: Use Luacheck for linting, Stylua for formatting.

See `docs/` for architecture, events API, and more.

## License

MIT License (see LICENSE file).