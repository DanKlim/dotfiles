# Pause all youtube videos in all youtube tabs.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1') ||
  document.getElementsByTagName('object')[0];
if (player) {
  player.pauseVideo();
}
"

tell application "Google Chrome"
  repeat with t in tabs of windows
    tell t
      set cmd to "echo \"" & URL & "\" | sed -E \"s/https?:\\/\\/www\\.(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/c\\/[0-9]+)/*good*(&)/\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
      end if
    end tell
  end repeat
end tell
