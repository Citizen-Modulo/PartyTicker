---

# PartyTicker

**Your party and guild chat as a smooth scrolling ticker at the top of your screen, like a news crawl.**

PartyTicker shows incoming Party, Guild and optional Officer messages as a horizontal scrolling text bar at the top center of your screen. You can keep up with the conversation without keeping your eyes on the chat frame, which is handy during raids, dungeons and fast-paced combat.

## Features

- **Scrolling ticker bar** at the top center of the screen, designed for 1920x1080
- **Party chat** support, including party leader messages
- **Guild chat** support, enabled by default
- **Officer chat** support, optional and disabled by default
- **Color-coded channels** with `[Party]`, `[Guild]` and `[Officer]` prefixes
- **Adjustable font size** from 10 to 48, with the bar height adapting automatically
- **Adjustable scroll speed**
- **Readable text** with an outline
- **Test mode** to preview the ticker without a group
- **Saved settings** that persist between sessions

## Slash Commands

| Command | Description |
|---|---|
| `/pticker` | Show help and current settings |
| `/pticker test` | Show sample Party and Guild messages |
| `/pticker size <10-48>` | Set the font size |
| `/pticker speed <value>` | Set the scroll speed |
| `/pticker guild on\|off` | Toggle Guild chat |
| `/pticker officer on\|off` | Toggle Officer chat |
| `/pticker reset` | Reset all settings to default |

## Installation

1. Download and extract the archive.
2. Copy the `PartyTicker` folder into `World of Warcraft/_classic_/Interface/AddOns/` (or the folder of your game version).
3. Restart the game or type `/reload`.
4. Type `/pticker test` to check that it works.

## Compatibility

- Interface version: 11507
- Works alongside other chat addons, because it only reads chat events and does not replace your chat frame

## Notes

- Settings are saved per account.
- If you find a bug or have a feature request, please leave a comment on this page.

---
