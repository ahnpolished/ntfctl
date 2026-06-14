# AppleScript Internals

This reference documents how each AppleScript works under the hood.
Useful for debugging, extending, or understanding failure modes.

## Common Pattern

All scripts follow the same flow:

```
tell application "System Events"
    tell process "ControlCenter"
        click menu bar item 2 of menu bar 1   -- opens NC
    end tell
    delay 0.7

    tell process "NotificationCenter"
        set ncWindow to item 1 of (every window)
        set allElements to entire contents of ncWindow
        -- [walk elements, perform action]
    end tell

    tell process "ControlCenter"
        click menu bar item 2 of menu bar 1   -- closes NC
    end tell
end tell
```

Key constraints:
- Cannot nest `tell process "ControlCenter"` inside `tell process "NotificationCenter"` — AppleScript interprets nested process tells as parent-child relationships, which fail
- `entire contents` may fail if Notification Center's UI hierarchy changes mid-traversal — always wrap in `try`
- The Notification Center window is named "NotificationCenter" and the process is "NotificationCenter"

## Notification Center UI Hierarchy

On macOS 26 (Tahoe), the accessibility tree looks like:

```
Window "Notification Center"
└── AXGroup (root)
    ├── AXScrollArea          ← contains notification list
    │   ├── AXGroup           ← "Today" section / heading area
    │   │   ├── AXHeading ("Notification Center")
    │   │   └── AXButton      ← NC close button (20×20, y≈26)
    │   ├── AXGroup           ← notification group 1
    │   │   ├── AXStaticText  ← app name
    │   │   ├── AXStaticText  ← notification title
    │   │   ├── AXStaticText  ← notification body
    │   │   └── AXButton      ← dismiss "X" (20×20, hidden until hover)
    │   ├── AXGroup           ← notification group 2
    │   │   └── ...
    │   └── AXOpaqueProviderGroup ← "1 more event" collapsed group
    ├── AXButton              ← options button
    ├── AXMenuButton          ← "..." menu
    └── AXGroup               ← footer (Screen Time prompt, etc.)
```

## Clear All Strategies

`ntfctl-clear.applescript` tries three approaches in order:

### Strategy 1: "Clear All" Button
Checks every `AXButton` for a title/description matching clear keywords in 11 languages:
- English: "Clear All", "Clear"
- German: "Alle löschen"
- French: "Tout effacer"
- Spanish: "Borrar todo"
- Japanese: "すべてクリア"
- Korean: "모두 지우기"
- Chinese: "全部清除"
- Russian: "Очистить все"
- Portuguese: "Limpar Tudo"
- Polish: "Usuń wszystko"

### Strategy 2: Per-Notification Dismiss Buttons
Each notification has a hidden 20×20 px dismiss button at x≈1884 (right edge).
The script finds all such buttons by size, filtering out the NC close button
at y≈26 (menu bar area).

### Strategy 3: Restart NotificationCenter
`killall NotificationCenter` — clears the UI. NotificationCenter auto-restarts
on the next notification event or when the user clicks the clock.

## Dismiss Button Detection

Dismiss buttons are identified by:
- Role: `AXButton`
- Size: ≤ 28×28 px (they're 20×20)
- Position: y > 30 (the NC close button at top is y≈26)

## Peek / Count: Reading Notification Text

Notifications are read by finding `AXStaticText` elements at y > 40
(skipping the "Notification Center" heading). The pattern is:
- First text element with y > 40 → app name
- Next text element → notification title
- Next text element → notification body

For counting, every third text element is treated as the start of a new
notification group (rough heuristic).

## Common Failure Modes

1. **"Invalid index" error**: UI elements shifted during `entire contents` traversal.
   Handled by try-catch; falls back gracefully.
2. **"Can't get window"**: Notification Center didn't open in time.
   Increase `delay 0.7` if this happens frequently.
3. **No dismiss buttons found**: Buttons are hidden until hover on some macOS versions.
   The keyboard fallback (Tab + Delete) or the killall fallback handles this.
4. **DnD shortcut not found**: User hasn't created "DND Until I Leave" in Shortcuts.app.
   Shows a failure toast with instructions.

## Adding a New Language

For the clear-all keyword detection, add the translated phrase for "Clear All" to the
`clearKeywords` list in `ntfctl-clear.applescript`. The format is:

```applescript
set clearKeywords to {..., "New Language Phrase", ...}
```

## Testing

```bash
# Send test notification
terminal-notifier -title "Test" -message "Hello" -sound default

# Then test any script
osascript macscripts/ntfctl/ntfctl-clear.applescript
```

Full test suite: `bash macscripts/ntfctl/test-notif.sh` (18/18 pass).
