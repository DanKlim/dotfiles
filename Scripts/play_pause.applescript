# Play or pause a video.
set myjs to "
var button =
  document.getElementsByClassName('player-play-pause')[0] ||
  document.getElementsByClassName('js-control-playpause-button')[0];

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
    if (player.getPlayerState && player.getPlayerState() === 1 ||
        player.isPaused && !player.isPaused() || player.paused === false) {
      if (player.pauseVideo) { player.pauseVideo(); }
      else if (player.pause) { player.pause(); }
    } else {
      if (player.playVideo) { player.playVideo(); }
      else if (player.play) { player.play(); }
    }
  }
}
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/watch\\/|[^ ]+:32400\\/web\\/index\\.html)/*good*(&)/"
tell application "Google Chrome"
  tell active tab of front window
    set cmd to "echo \"" & URL & "\" | sed -E \"" & regexp & "\"" as string
    set result to do shell script cmd
    if result starts with "*good*" then
      execute javascript myjs
      return
    end if
  end tell

  repeat with win in windows
    tell active tab of win
      set cmd to "echo \"" & URL & "\" | sed -E \"" & regexp & "\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
        return
      end if
    end tell
  end repeat

  repeat with t in tabs of windows
    tell t
      set cmd to "echo \"" & URL & "\" | sed -E \"" & regexp & "\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
        exit repeat
      end if
    end tell
  end repeat
end tell
