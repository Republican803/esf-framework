# Changelog

All notable changes to the ESF Framework will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2.0.0] - 2025-10-07
### Added
- Phase 2: Identity module with landing page, character system (1-4 slots), department selection from departments.json (based on departments.txt).
- Account resolution via license/steam/discord.
- Character creation/selection/deletion with last position resume.
- Basic appearance storage and application (ped components as JSON).
- Persistence for positions and playtime (atomic saves every 5 min and on drop).
- Spawn at department-specific coordinates (or last pos).
- Immersive NUI expansions: Welcome header/banner, background styling, animations.
- Custom EUP menu: Department-specific outfits selected during creation, applied via natives.
- Immersive "application" process: Multi-step form with name, age, bio, department select, and EUP choice.
- New fields in characters table: char_name, age, bio.
- Expanded departments.json with eup_outfits (component variations for EUP).

### Changed
- Updated NUI (landing.html/js/css) for visual immersion (images, modals, forms).
- Enhanced create flow to include new fields and outfit selection.
- Updated client/landing.lua to pass departments to NUI and handle expanded messages.

## [1.0.0] - 2025-10-06
### Added
- Phase 1: Core module with event bus, logger, DB wrapper, config loader, timekeeper.
- Client basics: core boot, notify, markers.
- Configs: permissions, server_settings, locales.
- SQL: Init tables.

## [0.0.1] - 2025-10-06
- Initial release: Empty structure validated.
- Phase 0: Repository foundation with CI, formatting, and empty resources.