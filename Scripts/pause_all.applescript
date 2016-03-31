# Pause all youtube videos in all youtube tabs.
set myjs to "
var isCorrectPlayer = window.location.hostname === 'www.twitch.tv' ?
  function(player) { return player.getVideoTime; } :
  function(player) { return player.playVideo || player.play; } ;
function getPlayer(byId, name) {
  var player = byId ?
    document.getElementById(name) : document.getElementsByTagName(name)[0];
  return player && isCorrectPlayer(player) ? player : null;
}

var button =
  document.getElementsByClassName('icon-player-pause')[0] ||
  document.getElementsByClassName('js-pause-button')[0];
var player =
  getPlayer(true, 'movie_player') ||
  getPlayer(true, 'player1') ||
  getPlayer(false, 'video') ||
  getPlayer(false, 'object') ||
  getPlayer(false, 'embed');

if (button) {
  if (getComputedStyle(button).display !== 'none') {
    button.click();
  }
} else  if (player) {
  if (player.pauseVideo) { player.pauseVideo(); }
  else if (player.pause) { player.pause(); }
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/watch\\/|[^\\s]+:32400\\/web\\/index\\.html)/*good*(&)/"
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
