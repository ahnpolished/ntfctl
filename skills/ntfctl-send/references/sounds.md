# macOS System Sounds

All built-in alert sounds available for notifications.

| Sound | Description |
|-------|-------------|
| `Basso` | Low, deep chime |
| `Blow` | Breath / blow sound |
| `Bottle` | Bottle pop |
| `Frog` | Croak |
| `Funk` | Funky synth note |
| `Glass` | Crystal glass ting |
| `Hero` | Heroic fanfare |
| `Morse` | Morse code beeps |
| `Ping` | Single high ping |
| `Pop` | Pop / bubble |
| `Purr` | Cat purr |
| `Sosumi` | Classic Mac chime |
| `Submarine` | Sonar ping |
| `Tink` | Tiny bell tink |

Use `default` for the standard macOS notification sound.

## Usage

```bash
terminal-notifier -title "Done" -message "Task complete" -sound Ping
osascript -e 'display notification "Done" with title "Agent" sound name "Glass"'
```

## Preview a Sound

```bash
afplay /System/Library/Sounds/Ping.aiff
```

All system sounds live in `/System/Library/Sounds/`:

```bash
ls /System/Library/Sounds/*.aiff
```
