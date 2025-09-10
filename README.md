# cmd_swap

A lightweight macOS utility that **swaps the current text selection with the clipboard contents**.  

---

## Features
- Swap selected text with clipboard contents in any app
- Configurable clipboard behavior (keep or replace)
- Pop-up (default) or Notification Center feedback
- Adjustable timing for slower apps
- Plain Ruby script — no external deps

---

## Installation

### Recommended (via Homebrew tap)
```bash
brew tap titsworthrob/tools
brew install cmd_swap

###Alternative (Install directly from the formula with Homebrew:)

```bash
brew install --formula https://raw.githubusercontent.com/titsworthrob/cmd_swap/main/Formula/cmd_swap.rb

---

## Command-Line Options

```text
Usage: cmd_swap [options]

  --keep-clipboard           End with clipboard unchanged (default ends with selection)
  --type                     Type original text instead of paste (plain text, no newlines)
  --delay=SECONDS            Wait after Cmd+C before reading selection (default: 0.18)
  --popup                    Enable pop-up feedback   (default: enabled)
  --no-popup                 Disable pop-up feedback
  --notification             Enable Notification Center feedback   (default: disabled)
  --no-notification          Disable Notification Center feedback
  --popup-timeout=SECONDS    Pop-up auto-dismiss timeout (default: 1.2)
  --no-feedback              Disable all feedback (later flags can re-enable)
  -h, --help                 Show this help
```

### Examples

```bash
cmd_swap                                   # popup only (default)
cmd_swap --notification                    # popup + notification
cmd_swap --no-popup --notification         # notification only
cmd_swap --no-feedback                     # silent
cmd_swap --no-feedback --popup             # silent, then re-enable popup
cmd_swap --delay=0.25                      # give slower apps more copy time
cmd_swap --keep-clipboard                  # leave clipboard unchanged
cmd_swap --type                            # type text instead of pasting (plain text only)
cmd_swap --popup-timeout=1.5               # extend popup display duration
```

---

## Assigning a Hotkey on macOS

The script itself does not set hotkeys — you bind it via macOS tools.

### Option 1: Shortcuts (recommended, built-in)
1. Open the **Shortcuts** app.
2. Create a new shortcut:
   - **Add Action** → search **Run Shell Script**.
   - Paste the full path to your script:
     ```bash
     /path/to/cmd_swap.rb
     ```
3. Name it (e.g., **Cmd Swap**) and save.
4. Go to **System Settings → Keyboard → Keyboard Shortcuts → Services → Shortcuts**.
5. Find **Cmd Swap** and assign a hotkey (recommended: **⌃⌘X**).

### Option 2: Automator (Quick Action workflow)
1. Open **Automator** → **New Document** → **Quick Action**.
2. Add **Run Shell Script** to the workflow.
3. Paste the path:
   ```bash
   /path/to/cmd_swap.rb
   ```
4. Save as **Cmd Swap**.
5. Go to **System Settings → Keyboard → Keyboard Shortcuts → Services**.
6. Find **Cmd Swap** and assign your hotkey (recommended: **⌃⌘X**).

---

## Permissions

Because `cmd_swap.rb` simulates keystrokes, macOS requires **Accessibility** permission:

- **System Settings → Privacy & Security → Accessibility**
- Enable the launcher app you use (Terminal/iTerm2, Shortcuts, or Automator).

---

## Troubleshooting

- **No popup appears:** Ensure Focus/Do Not Disturb is off. Confirm Accessibility is enabled for your launcher app.
- **Nothing swaps:** Some apps need a longer copy delay; try `--delay=0.25` (or higher).
- **No notifications:** In **System Settings → Notifications**, allow alerts for your launcher app.
- **Multiline with `--type`:** `keystroke` can’t type newlines; lines will be flattened to spaces. Use paste mode for multiline.

---

## License
MIT — free to use, share, and modify.

---

## Author

**Rob Titsworth**  
[GitHub](https://github.com/titsworthrob)
