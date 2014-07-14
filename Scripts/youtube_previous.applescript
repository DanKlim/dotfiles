# If in a playlist and the current video time is <= 5 seconds,
# play the previous video,
# otherwise, rewind to the beginning of the current video and play.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
if (player) {
  var className1 = 'yt-uix-button-icon-playlist-bar-prev';
  var className2 = 'yt-uix-button-icon-watch-appbar-play-prev';
  var prev =
    document.getElementsByClassName(className1)[0] ||
    document.getElementsByClassName(className2)[0];
  if (player.getCurrentTime() <= 5) {
    if (prev) {
      prev.click();
    } else {
      player.previousVideo();
    }
  } else {
    player.seekTo(0, true);
    if (player.getPlayerState() !== 1) {
      player.playVideo();
    }
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
