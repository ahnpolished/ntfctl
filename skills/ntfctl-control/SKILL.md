---
name: ntfctl-control
description: Control macOS Notification Center from the terminal. This skill should be used when the user asks to "clear notifications", "dismiss notifications", "check notifications", "peek at latest notification", "count notifications", "toggle do not disturb", "toggle notification center", or needs to interact with macOS Notification Center programmatically during a coding session. Also triggers on "what's in my notifications", "show me notifications", "clear my notifications", "dismiss that notification".
---

# macOS Notification Control

Control Notification Center directly from the terminal using AppleScript.
Clear, peek, dismiss, count, and toggle — all without touching the trackpad.

## Available Scripts

All scripts live in the project's `macscripts/ntfctl/` directory.
Resolve paths with `${PROJECT_ROOT}/macscripts/ntfctl/` or use the
wrapper scripts in `scripts/` of this skill.

| Script | Action | Invocation |
|--------|--------|------------|
| `ntfctl-clear.applescript` | Clear **all** visible notifications | `osascript ntfctl-clear.applescript` |
| `ntfctl-latest.applescript` | Peek at the newest notification | `osascript ntfctl-latest.applescript` |
| `ntfctl-dismiss.applescript` | Dismiss **only the top** notification | `osascript ntfctl-dismiss.applescript` |
| `ntfctl-count.applescript` | Count pending notifications | `osascript ntfctl-count.applescript` |
| `ntfctl-dnd.applescript` | Toggle Do Not Disturb / Focus | `osascript ntfctl-dnd.applescript` |
| `ntfctl-center.applescript` | Open / close Notification Center | `osascript ntfctl-center.applescript` |
| `ntfctl.applescript` | Unified CLI (arg: clear\|latest\|…) | `osascript ntfctl.applescript clear` |

## Quick Reference

### Clear all notifications

```bash
osascript macscripts/ntfctl/ntfctl-clear.applescript
```

Uses three strategies: (1) click "Clear All" button, (2) click per-notification
dismiss buttons, (3) fallback to `killall NotificationCenter`. Supports 11 languages.

### Peek at the newest notification

```bash
osascript macscripts/ntfctl/ntfctl-latest.applescript
```

Opens Notification Center, reads the top notification's app name, title, and body,
then presents them in a dialog with a **Copy** button.

### Dismiss only the latest

```bash
osascript macscripts/ntfctl/ntfctl-dismiss.applescript
```

Dismisses just the topmost notification banner — useful for triaging one at a time.

### Count pending notifications

```bash
osascript macscripts/ntfctl/ntfctl-count.applescript
```

Shows `~N notifications` dialog. Counts by inspecting the accessibility tree.

### Toggle Do Not Disturb

```bash
osascript macscripts/ntfctl/ntfctl-dnd.applescript
```

Requires a Shortcuts.app shortcut named **"DND Until I Leave"** that toggles
Focus → Do Not Disturb. Shows a failure toast if not configured.

### Open / close Notification Center

```bash
osascript macscripts/ntfctl/ntfctl-center.applescript
```

Toggles Notification Center open or closed — like clicking the clock in the menu bar.

## When to Use Each Command

| Scenario | Command |
|----------|---------|
| User says "clear my notifications" / "dismiss all" | `ntfctl-clear` |
| User says "what's my last notification" / "peek" | `ntfctl-latest` |
| User says "dismiss that one" / "clear the top one" | `ntfctl-dismiss` |
| User says "how many notifications do I have" | `ntfctl-count` |
| User says "turn on dnd" / "silence notifications" | `ntfctl-dnd` |
| Need to open/close Notification Center programmatically | `ntfctl-center` |
| Want to script notification actions | `ntfctl-control <action>` |

## How It Works

Each script follows the same pattern:

1. Click the clock in the macOS menu bar (ControlCenter process, menu bar item 2) to open Notification Center
2. Use System Events / Accessibility API to traverse the UI element tree
3. Read text or click buttons as needed
4. Click the clock again to close Notification Center

Dismiss buttons are identified as 20×20px `AXButton` elements at y > 30
(the Notification Center close button sits at y ≈ 26).

## Requirements

- macOS 15 (Sequoia) or later (tested on macOS 26 Tahoe)
- **Accessibility permission** granted to the terminal app running the scripts
  (System Settings → Privacy & Security → Accessibility)

## Bundled Scripts

Wrapper scripts in `scripts/` provide convenient one-liners from any directory:

| Script | Purpose |
|--------|---------|
| `scripts/clear.sh` | Clear all notifications |
| `scripts/latest.sh` | Peek at newest notification |
| `scripts/dismiss.sh` | Dismiss top notification |
| `scripts/count.sh` | Count notifications |
| `scripts/dnd.sh` | Toggle DnD |
| `scripts/center.sh` | Toggle Notification Center |

## References

- `references/applescripts.md` — Full source and explanation of each AppleScript
- Project README: `macscripts/ntfctl/README.md`
- Test suite: `macscripts/ntfctl/test-notif.sh` (18/18 pass)
