# Changelog

All notable changes to PartyTicker are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project follows [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-11-12

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

## [1.0.0] - 2026-11-01

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

[Unreleased]: https://codeberg.org/tastytactics/PartyTicker/compare/v1.1.0...HEAD
[1.1.0]: https://codeberg.org/tastytactics/PartyTicker/compare/v1.0.0...v1.1.0
[1.0.0]: https://codeberg.org/tastytactics/PartyTicker/releases/tag/v1.0.0