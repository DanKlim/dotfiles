tell application "System Events"
  tell security preferences
    set require password to wake to true
  end tell
end tell
activate application "ScreenSaverEngine"
