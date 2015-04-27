# Pause all youtube videos in all youtube tabs.
set myjs to "
function getPlayer(byId, name) {
  var player = byId ?
    document.getElementById(name) : document.getElementsByTagName(name)[0];
  return player && (player.playVideo || player.play) ? player : null;
}

var player =
  getPlayer(true, 'movie_player') ||
  getPlayer(true, 'player1') ||
  getPlayer(false, 'video') ||
  getPlayer(false, 'object') ||
  getPlayer(false, 'embed');

if (player) {
  if (player.pauseVideo) { player.pauseVideo(); }
  else if (player.pause) { player.pause(); }
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/WiPlayer|[^\\s]+:32400\\/web\\/index\\.html)/*good*(&)/"
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
