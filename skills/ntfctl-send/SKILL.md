---
name: ntfctl-send
description: Send macOS desktop notifications from the terminal. This skill should be used when a long-running task completes and the user should be alerted, when a build finishes, when tests pass/fail, when the agent needs the user's attention, or when the user asks to "notify me when done", "send a notification", "alert me", "ping me", "let me know when finished". Use to provide non-intrusive status updates.
---

# Send macOS Desktop Notifications

Send native macOS Notification Center banners from the terminal or
AppleScript — perfect for alerting the user when long-running tasks
complete, builds finish, or tests pass/fail.

## Tools Available

### 1. terminal-notifier (CLI)

```bash
terminal-notifier -title "Build Complete" -message "All tests passed ✓" -sound default
```

Full options:

```bash
terminal-notifier \
  -title "Title" \
  -message "Body text" \
  -subtitle "Optional subtitle" \
  -sound default \
  -group "unique-id" \
  -open "https://example.com" \
  -execute "open -a Terminal ." \
  -activate "com.apple.Terminal"
```

| Flag | Purpose |
|------|---------|
| `-title` | Notification title (bold) |
| `-message` | Body text |
| `-subtitle` | Smaller text below title |
| `-sound NAME` | Alert sound (`default`, `Basso`, `Funk`, etc.) |
| `-group ID` | Replaces previous notifications with same group |
| `-open URL` | URL to open when notification is clicked |
| `-execute CMD` | Shell command to run when notification is clicked |
| `-activate BUNDLE` | App to bring to foreground on click |
| `-ignoreDnD` | Deliver even when Do Not Disturb is on |

Install: `brew install terminal-notifier`

### 2. osascript (built-in)

Pure AppleScript — no dependencies:

```bash
osascript -e 'display notification "Task complete!" with title "Agent" subtitle "Build succeeded" sound name "default"'
```

### 3. afplay (sound-only alert)

```bash
afplay /System/Library/Sounds/Ping.aiff
```

## When to Send a Notification

Send a notification whenever the user would benefit from knowing
a task has completed, especially after:

- **Long builds**: `npm run build`, `cargo build`, `xcodebuild`
- **Test runs**: `pytest`, `jest`, `go test`
- **Deployments**: `git push`, `cf push`, `kubectl apply`
- **AI completions**: When a multi-step code generation finishes
- **Errors**: When a command fails and the user should investigate
- **Milestones**: "Refactor complete", "100 files processed", "Migration done"

## Patterns

### Pattern 1: "Notify me when done"

User: "Run the tests and notify me when they're done."

```bash
npm test && terminal-notifier -title "Tests Passed" -message "All tests green ✓" -sound default || terminal-notifier -title "Tests Failed" -message "Check output ✗" -sound Basso
```

### Pattern 2: Background task with alert

User: "Start the build in the background and ping me."

```bash
(npm run build && terminal-notifier -title "Build Ready" -message "Build artifacts in dist/" -sound default) &
```

### Pattern 3: Progress milestones

```bash
terminal-notifier -title "Step 1/3" -message "Dependencies installed" -sound default -group "progress"
sleep 2
terminal-notifier -title "Step 2/3" -message "Tests running..." -sound default -group "progress"
sleep 2
terminal-notifier -title "Step 3/3" -message "All done!" -sound default -group "progress"
```

Using `-group` replaces the previous notification instead of stacking them.

### Pattern 4: Click-to-open

```bash
terminal-notifier -title "Report Ready" -message "Click to view" -open "file://$(pwd)/report.html"
```

### Pattern 5: AppleScript inline (no deps)

```bash
osascript -e 'display notification "✨ All done!" with title "Agent" subtitle "Task completed successfully"'
```

## Combining with ntfctl-control

Use `ntfctl-send` to alert the user, then `ntfctl-control` to let them
manage the notification afterward:

```bash
# Send notification
terminal-notifier -title "CI Failed" -message "3 tests failing" -sound Basso -group "ci-status"

# Later, user can clear it
osascript macscripts/ntfctl/ntfctl-dismiss.applescript
```

## Sound Names

Available system sounds:

```
Basso, Blow, Bottle, Frog, Funk, Glass, Hero,
Morse, Ping, Pop, Purr, Sosumi, Submarine, Tink
```

Or use `default` for the system notification sound.

## Requirements

- **terminal-notifier**: `brew install terminal-notifier`
- **osascript**: built-in, no install needed
- Notification Center must be running (it always is on modern macOS)

## References

- `references/sounds.md` — Complete list of available system sounds
- `../ntfctl-control/SKILL.md` — Companion skill for reading/dismissing notifications
