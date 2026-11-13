# PartyTicker

**Your party and guild chat as a smooth scrolling ticker at the top of your screen, like a news crawl.**

PartyTicker shows incoming Party, Guild and optional Officer messages as a horizontal scrolling text bar at the top center of your screen. You can keep up with the conversation without keeping your eyes on the chat frame, which is handy during raids, dungeons and fast-paced combat.

## Features

- **Scrolling ticker bar** at the top center of the screen, designed for 1920x1080
- **One-time setup**: move the ticker once, it stays there permanently, even after relog, death or reload
- **Party chat** support, including party leader messages
- **Guild chat** support, enabled by default
- **Officer chat** support, optional and disabled by default
- **Raid chat** support, optional
- **Color-coded channels** with `[Party]`, `[Guild]` and `[Officer]` prefixes
- **Customizable look**: font size (10 to 48), font, text color and background transparency
- **Adjustable scroll speed**
- **Readable text** with an outline
- **Test mode** to preview the ticker without a group
- **Saved settings** that persist between sessions and are never reset by updates

## First-Time Setup

1. Type `/pticker setup`. The ticker becomes movable and shows "Drag to move".
2. Drag it to your preferred position and release the mouse button.
3. Done. The position is saved and the ticker locks automatically.

The ticker always starts locked, so you never have to set it up again. To move it later, simply run `/pticker setup` again.

## Slash Commands

| Command | Description |
|---|---|
| `/pticker` | Show help and current settings |
| `/pticker setup` | Make the ticker movable (alias: `/pticker unlock`) |
| `/pticker lock` | Save the position and lock the ticker |
| `/pticker test` | Show sample Party and Guild messages |
| `/pticker status` | Show all current settings |
| `/pticker size <10-48>` | Set the font size |
| `/pticker speed <20-600>` | Set the scroll speed |
| `/pticker font <font-file>` | Set the font |
| `/pticker color <r> <g> <b>` | Set a custom text color |
| `/pticker color reset` | Return to channel colors |
| `/pticker background <0-1>` | Set background transparency |
| `/pticker raid on\|off` | Toggle Raid chat |
| `/pticker guild on\|off` | Toggle Guild chat |
| `/pticker officer on\|off` | Toggle Officer chat |
| `/pticker reset` | Reset all settings to default |

## Installation

1. Download and extract the archive.
2. Copy the `PartyTicker` folder into `World of Warcraft/Interface/AddOns/` (or the folder of your game version).
3. Restart the game or type `/reload`.
4. Type `/pticker test` to check that it works.
5. Run `/pticker setup` once to place the ticker where you want it.

## Compatibility

- Interface version: 30300 (WoW 3.3.5)
- Works alongside other chat addons, because it only reads chat events and does not replace your chat frame

## Notes

- Settings are saved per account in `PartyTickerDB`.
- Updates only fill in missing values and never overwrite your existing configuration.
- See [CHANGELOG.md](CHANGELOG.md) for the full version history.
- If you find a bug or have a feature request, please open an issue on GitHub.