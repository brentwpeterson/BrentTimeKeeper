# BrentTimeKeeper

A simple macOS menu bar time tracker built with SwiftUI.

![Time Keeper](screenshot.png)

## Features

- Lives in your menu bar (no Dock icon)
- Start/Pause/Resume/Finish tracking
- Logs sessions to a markdown file with timestamps
- Optional "Launch at Login" toggle
- Shows elapsed time in the menu bar

## Requirements

- macOS 13.0 or later
- Xcode 15+ (to build from source)

## Installation

### From Source

1. Clone the repo
2. Open `BrentTimeKeeper.xcodeproj` in Xcode
3. Build and run (Cmd+R)

### Configuration

By default, sessions are logged to `~/Documents/WORK-LOG.md`.

To change the log location, set the `TIMEKEEPER_LOG_PATH` environment variable:

```bash
# For GUI apps on macOS
launchctl setenv TIMEKEEPER_LOG_PATH "/path/to/your/WORK-LOG.md"
```

Or run the included setup script:

```bash
./setup-env.sh
```

## Log Format

Sessions are logged in markdown table format:

```markdown
## 2026-01-04
| Start | End | Hours | Task |
|-------|-----|-------|------|
| 9:15 AM | 12:30 PM | 3.25 | Building time keeper app |
```

## License

MIT

## Built With

- SwiftUI
- [Claude Code](https://claude.com/claude-code)

---

*This app was built during a "Tuesdays with Claude" session, documented in [this article](link-to-article).*
