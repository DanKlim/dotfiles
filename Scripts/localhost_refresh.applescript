tell application "Google Chrome"
  tell active tab of front window
    set cmd to "echo \"" & URL & "\" | sed -E \"s/http:\\/\\/localhost:/*good*(&)/\"" as string
    set result to do shell script cmd
    if result starts with "*good*" then
      reload
      return
    end if
  end tell

  repeat with win in windows
    tell active tab of win
    set cmd to "echo \"" & URL & "\" | sed -E \"s/http:\\/\\/localhost:/*good*(&)/\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        reload
        return
      end if
    end tell
  end repeat
end tell
