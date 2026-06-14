# ntfctl

> **ntfctl** — control macOS Notification Center from the keyboard.
> Clear, peek, dismiss, count, toggle Do Not Disturb.
> Pure AppleScript + Raycast extension.

## Quick Start

```bash
# Clear all notifications
osascript ntfctl-clear.applescript

# Peek at the newest one
osascript ntfctl-latest.applescript

# Dismiss just the top one
osascript ntfctl-dismiss.applescript

# Count pending
osascript ntfctl-count.applescript

# Toggle Do Not Disturb
osascript ntfctl-dnd.applescript

# Open/close Notification Center
osascript ntfctl-center.applescript

# Unified CLI
osascript ntfctl.applescript clear
osascript ntfctl.applescript latest
```

## Scripts

| Script | Action |
|--------|--------|
| `ntfctl-clear.applescript` | Clear all visible notifications (3 strategies, 11 languages) |
| `ntfctl-latest.applescript` | Peek at newest notification (dialog with Copy button) |
| `ntfctl-dismiss.applescript` | Dismiss only the top notification |
| `ntfctl-count.applescript` | Count pending notifications |
| `ntfctl-dnd.applescript` | Toggle Do Not Disturb / Focus |
| `ntfctl-center.applescript` | Open / close Notification Center |
| `ntfctl.applescript` | Unified script (arg: `clear|latest|dismiss|dnd|count|center`) |

## Raycast Extension

A full Raycast extension is included in `raycast/` with 6 commands:

| Command | Mode | Icon |
|---------|------|------|
| Clear All Notifications | no-view (HUD) | 🧹 |
| Peek at Latest Notification | view (Detail) | 📬 |
| Dismiss Latest Notification | no-view (HUD) | 🗑️ |
| Count Notifications | view (Detail) | # |
| Toggle Do Not Disturb | no-view (HUD) | 🔕 |
| Toggle Notification Center | no-view (HUD) | 🔔 |

### Install

```bash
cd raycast
npm install
npm run build
# Then: Raycast → Extensions → Import → select raycast/ directory
```

## Skills (for Coding Agents)

The `skills/` directory contains Claude Code / Copilot agent skills:

| Skill | Purpose |
|-------|---------|
| `skills/ntfctl-control/` | Teach agents to clear, peek, dismiss, count notifications |
| `skills/ntfctl-send/` | Teach agents to send desktop notifications to the user |

Each skill includes `scripts/` wrappers and `references/` documentation.

## Test Suite

```bash
bash test.sh
# Sends test notifications via terminal-notifier, exercises every script
```

## Requirements

- macOS 15 (Sequoia) or later (tested on macOS 26 Tahoe)
- Accessibility permission granted (System Settings → Privacy & Security → Accessibility)
- `terminal-notifier` (for testing only): `brew install terminal-notifier`

## How It Works

Each script:
1. Clicks the clock in the menu bar to open Notification Center
2. Uses System Events / Accessibility API to traverse the UI tree
3. Reads text or clicks dismiss buttons
4. Clicks the clock again to close Notification Center

Dismiss buttons are 20×20px `AXButton` elements identified by size and position.

## Setup Keyboard Shortcuts

```bash
bash setup-hotkeys.sh
# Creates .app wrappers in /Applications/ntfctlScripts/
# Then bind them in: System Settings → Keyboard → Keyboard Shortcuts
```

## Market Position

ntfctl is the **only Raycast extension** for Notification Center control and the
**only multi-action AppleScript suite**. See `raycast/MARKET_RESEARCH.md` for
competitive analysis of 7 alternatives.

## License

MIT
