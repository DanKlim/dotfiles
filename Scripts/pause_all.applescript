# Pause all youtube videos in all youtube tabs.
set myjs to "
function getButton(className, querySelector) {
  var btn = querySelector ?
    document.querySelector(className) :
    document.getElementsByClassName(className)[0];
  return btn && getComputedStyle(btn).display !== 'none' ? btn : null;
}

var button =
  getButton('player-play-pause') ||
  getButton('js-pause-button') ||
  getButton('.mini-controls .pause-btn', true) ||
  null;


if (button) {
  button.click();
} else {
  var isCorrectPlayer = window.location.hostname === 'www.twitch.tv' ?
    function(player) { return player.getVideoTime; } :
    function(player) { return player.playVideo || player.play; } ;
  var getPlayer = function(byId, name) {
    var player = byId ?
      document.getElementById(name) : document.getElementsByTagName(name)[0];
    return player && isCorrectPlayer(player) ? player : null;
  };

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
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/videos\\/[0-9]+|netflix\\.com\\/watch\\/|[^ ]+:32400\\/web\\/index\\.html|app\\.plex\\.tv\\/web\\/app)/*good*(&)/"
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
