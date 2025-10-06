# Architecture Overview

ESF is built as modular FiveM resources under [esf] namespace. Core principles:
- Event-driven: Use AddEventHandler, TriggerEvent for loose coupling.
- Shared types: In esf_core/shared/ (enums, constants).
- DB: oxmysql with versioned SQL migrations.
- NUI: React/TS for UIs (e.g., MDT).
- Performance: Zone-based triggers, statebags for sync.

Detailed diagrams in future updates.