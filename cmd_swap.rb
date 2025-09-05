#!/usr/bin/env ruby
# cmd_swap.rb — Swap the current text selection with the current clipboard (macOS)

# ---------- Helpers ----------

abort("This script only works on macOS.") unless /darwin/ === RUBY_PLATFORM

def osa(*lines)
  system("osascript", *lines.flat_map { |l| ["-e", l] })
end

def esc(s)
  s.to_s.gsub('\\', '\\\\').gsub('"', '\"')
end

# On-screen popup (auto-dismiss), like Hammerspoon hs.alert.show
def popup(msg, timeout: 1.2, title: "cmd_swap")
  osa(%Q[tell application "System Events" to display alert "#{esc(title)}" message "#{esc(msg)}" as informational giving up after #{timeout.round(2)}])
end

# Notification Center banner
def notify(msg, title: "cmd_swap")
  osa(%Q[display notification "#{esc(msg)}" with title "#{esc(title)}"])
end

def pbpaste  = `pbpaste`
def pbcopy(s) = IO.popen("pbcopy", "w") { |io| io.print(s.to_s) }

# Unified feedback helper (shows popup and/or notification based on current toggles)
def message(msg, show_popup:, show_notification:, popup_timeout:)
  popup(msg, timeout: popup_timeout) if show_popup
  notify(msg)                         if show_notification
end

# ---------- Defaults & flags ----------

end_clip               = :selected   # :selected (default) or :original
type_instead_of_paste  = false       # --type (types text; no newlines)
copy_delay_seconds     = 0.18        # --delay=SECONDS (after Cmd+C)
popup_timeout          = 1.2         # --popup-timeout=SECONDS

# Independent toggles (default = popup ON, notification OFF)
show_popup        = true
show_notification = false

# Apply flags left-to-right so later flags can override earlier ones
ARGV.each do |arg|
  case arg
  when "--keep-clipboard"                    then end_clip = :original
  when "--type"                              then type_instead_of_paste = true
  when /\A--delay=(\d+(?:\.\d+)?)\z/         then copy_delay_seconds = $1.to_f
  when /\A--popup-timeout=(\d+(?:\.\d+)?)\z/ then popup_timeout = $1.to_f

  # Independent feedback toggles
  when "--popup"                             then show_popup = true
  when "--no-popup"                          then show_popup = false
  when "--notification"                      then show_notification = true
  when "--no-notification"                   then show_notification = false

  # Convenience: silence everything (later flags can re-enable)
  when "--no-feedback"
    show_popup = false
    show_notification = false

  when "-h", "--help"
    puts <<~HELP
      Usage: cmd_swap [options]

        --keep-clipboard           End with clipboard unchanged (default ends with selection)
        --type                     Type original text instead of paste (plain text, no newlines)
        --delay=SECONDS            Wait after Cmd+C before reading selection (default: #{copy_delay_seconds})
        --popup                    Enable pop-up feedback   (default: enabled)
        --no-popup                 Disable pop-up feedback
        --notification             Enable Notification Center feedback   (default: disabled)
        --no-notification          Disable Notification Center feedback
        --popup-timeout=SECONDS    Pop-up auto-dismiss timeout (default: #{popup_timeout})
        --no-feedback              Disable all feedback (later flags can re-enable)
        -h, --help                 Show this help

      Notes:
        • Flags are applied left-to-right. `--no-feedback --popup` results in popups enabled.
        • If both popup and notification are enabled, you will see both.

      Examples:
        cmd_swap                                   # popup only (default)
        cmd_swap --notification                    # popup + notification
        cmd_swap --no-popup --notification         # notification only
        cmd_swap --no-feedback                     # silent
        cmd_swap --no-feedback --popup             # silent, then re-enable popup (popup only)
        cmd_swap --delay=0.25                      # give slower apps more copy time
        cmd_swap --keep-clipboard                  # leave clipboard unchanged
        cmd_swap --type                            # type instead of paste (no newlines)
    HELP
    exit 0
  end
end

# ---------- Core logic ----------

original = pbpaste

osa('tell application "System Events" to keystroke "c" using {command down}')
sleep copy_delay_seconds
selected = pbpaste

if selected.to_s.empty?
  message("No text selected",
          show_popup:, show_notification:, popup_timeout:) if (show_popup || show_notification)
  exit 1
end

if original.to_s.empty?
  message("No text in clipboard",
          show_popup:, show_notification:, popup_timeout:) if (show_popup || show_notification)
  exit 1
end

pbcopy(selected)
osa('tell application "System Events" to keystroke "x" using {command down}')
sleep 0.06

if type_instead_of_paste
  # AppleScript 'keystroke' cannot send newlines; best-effort for short text
  typed = esc(original).gsub("\n", ' ')
  osa(%Q[tell application "System Events" to keystroke "#{typed}"])
else
  pbcopy(original)
  osa('tell application "System Events" to keystroke "v" using {command down}')
end

pbcopy(end_clip == :selected ? selected : original)

message("Text swapped successfully!",
        show_popup:, show_notification:, popup_timeout:) if (show_popup || show_notification)
