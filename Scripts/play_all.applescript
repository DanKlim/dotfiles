# Pause all youtube videos in all youtube tabs.
set myjs to "
var button =
  document.getElementsByClassName('icon-player-play')[0] ||
  document.getElementsByClassName('js-play-button')[0];

if (button) {
  if (getComputedStyle(button).display !== 'none') {
    button.click();
  }
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
    if (player.playVideo) { player.playVideo(); }
    else if (player.play) { player.play(); }
  }
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/watch\\/|[^ ]+:32400\\/web\\/index\\.html)/*good*(&)/"
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
