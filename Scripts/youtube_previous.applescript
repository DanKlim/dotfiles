# If in a playlist and the current video time is <= 5 seconds,
# play the previous video,
# otherwise, rewind to the beginning of the current video and play.
set myjs to "
var className = 'ytp-prev-button';
var prev = document.getElementsByClassName(className)[0];
if (prev && prev.style.display !== 'none') {
  prev.click();
} else {
  var getPlayer = function(byId, name) {
    var player = byId ?
      document.getElementById(name) : document.getElementsByTagName(name)[0];
    return player && (player.playVideo || player.play) ? player : null;
  };
  var player =
    getPlayer(true, 'movie_player') ||
    getPlayer(true, 'player1') ||
    getPlayer(false, 'video') ||
    getPlayer(false, 'object') ||
    getPlayer(false, 'embed');
  player.seekTo(0, true);
  if (player.getPlayerState() !== 1) {
    player.playVideo();
  }
}
"

tell application "Google Chrome"
  tell active tab of front window
    set cmd to "echo \"" & URL & "\" | sed -E \"s/https?:\\/\\/www\\.youtube\\.com\\/(watch|embed)/*good*(&)/\"" as string
    set result to do shell script cmd
    if result starts with "*good*" then
      execute javascript myjs
      return
    end if
  end tell

  repeat with w in windows
    tell active tab of w
      set cmd to "echo \"" & URL & "\" | sed -E \"s/https?:\\/\\/www\\.youtube\\.com\\/(watch|embed)/*good*(&)/\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
        return
      end if
    end tell
  end repeat

  repeat with t in tabs of windows
    tell t
      set cmd to "echo \"" & URL & "\" | sed -E \"s/https?:\\/\\/www\\.youtube\\.com\\/(watch|embed)/*good*(&)/\"" as string
      set result to do shell script cmd
      if result starts with "*good*" then
        execute javascript myjs
        return
      end if
    end tell
  end repeat
end tell
