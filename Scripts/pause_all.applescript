# Pause all youtube videos in all youtube tabs.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1') ||
  document.getElementsByTagName('object')[0] ||
  document.getElementsByTagName('video')[0];

if (player) {
  if (player.pauseVideo) { player.pauseVideo(); }
  else if (player.pause) { player.pause(); }
}
"

set regexp to "s/https?:\\/\\/www\\.(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/WiPlayer)/*good*(&)/"
tell application "Google Chrome"
  repeat with t in tabs of windows
    tell t
      set cmd to "echo \"" & URL & "\" | sed -E \"" & regexp & "\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
      end if
    end tell
  end repeat
end tell
