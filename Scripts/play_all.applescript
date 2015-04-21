# Pause all youtube videos in all youtube tabs.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementById('player1') ||
  document.getElementsByTagName('video')[0] ||
  document.getElementsByTagName('object')[0] ||
  document.getElementsByTagName('embed')[0];

if (player) {
  if (player.playVideo) { player.playVideo(); }
  else if (player.play) { player.play(); }
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/WiPlayer|[^\\s]+:32400\\/web\\/index\\.html)/*good*(&)/"
tell application "Google Chrome"
  repeat with win in windows
    if win is visible
      tell active tab of win
        set cmd to "echo \"" & URL & "\" | sed -E \"" & regexp & "\"" as string
        set result to do shell script cmd
        if result starts with "*good*" then
          execute javascript myjs
        end if
      end tell
    end if
  end repeat
end tell
