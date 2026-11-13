# Changelog

All notable changes to PartyTicker are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.2.1] - 2026-11-13

### Changed
- The TOC now uses `## Version: @project-version@`, so the addon version is set automatically from the release tag.

## [1.2.0] - 2026-11-13

### Added
- The ticker position is now also saved automatically on logout and when leaving the world (`PLAYER_LOGOUT`, `PLAYER_LEAVING_WORLD`) as a safety net.
- `/pticker unlock` is now an alias for `/pticker setup`.

### Changed
- The ticker now always starts locked after login, death or reload. Setup mode is never restored automatically.
- After dragging the ticker in setup mode, the position is saved and locked automatically on release. `/pticker lock` is no longer required.
- Position saving is more robust: the full anchor (point, relative point, x/y offsets) is stored reliably after moving.
- The ticker is clamped to the screen, so it can no longer end up outside the visible area.
- The drag hint is hidden correctly when the ticker is locked while idle.
- Resetting to defaults now always results in a locked ticker.

### Fixed
- Ticker appeared in the screen center with "Drag to move" after every death, relog or reload, because setup mode stayed active and the position was not saved.
- Ticker position was lost when leaving setup mode without running `/pticker lock`.

## [1.1.0] - 2026-11-13

### Added
- `/pticker guild` and `/pticker officer` to toggle those chat channels, with `on` and `off` arguments also supported.

### Changed
- Save the ticker's anchor point, relative anchor, and x/y offsets when saving its position.
- Show a drag instruction in movable mode and clear it when the ticker is locked while idle.

## [1.0.0] - 2026-11-12

### Added
- One-time setup: `/pticker setup` makes the ticker movable, `/pticker lock` saves its position permanently.
- `/pticker unlock` to move the ticker again later.
- `/pticker status` to show all current settings.
- `/pticker font`, `/pticker color` and `/pticker background` to customize the look.
- `/pticker raid on|off` to toggle Raid chat.
- `SavedVariables: PartyTickerDB` in the TOC file, so settings persist between sessions.

### Changed
- All settings (position, speed, font size, font, color, background, chat filters) are now stored in `PartyTickerDB`.
- On load, only missing values are filled with defaults. Existing settings are never overwritten, so updates will not reset your configuration.
- The ticker no longer has to be set up again after login, death or reload.

### Fixed
- Ticker position was lost after relog, death or reload.

## [0.9.0] - 2026-11-01

### Added
- Scrolling ticker bar at the top center of the screen (designed for 1920x1080).
- Party chat support, including party leader messages.
- Guild chat support, enabled by default.
- Optional Officer chat support, disabled by default.
- Color-coded channel prefixes: `[Party]`, `[Guild]`, `[Officer]`.
- Adjustable font size (10 to 48) with automatic bar height.
- Adjustable scroll speed.
- Text outline for better readability.
- `/pticker test` to preview the ticker without a group.
- `/pticker reset` to restore default settings.

[Unreleased]: https://github.com/Citizen-Modulo/PartyTicker/compare/v1.2.1...HEAD
[1.2.1]: https://github.com/Citizen-Modulo/PartyTicker/compare/v1.2.0...v1.2.1
[1.2.0]: https://github.com/Citizen-Modulo/PartyTicker/compare/v1.1.0...v1.2.0
[1.1.0]: https://github.com/Citizen-Modulo/PartyTicker/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Citizen-Modulo/PartyTicker/compare/v0.9.0...v1.0.0
[0.9.0]: https://github.com/Citizen-Modulo/PartyTicker/releases/tag/v0.9.0