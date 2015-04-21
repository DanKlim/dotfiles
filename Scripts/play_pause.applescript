# Play or pause a video.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementById('player1') ||
  document.getElementsByTagName('video')[0] ||
  document.getElementsByTagName('object')[0] ||
  document.getElementsByTagName('embed')[0];

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
"

set regexp to "s/https?:\\/\\/(www\\.)?(youtube\\.com\\/(watch|embed)|twitch\\.tv\\/[a-zA-Z0-9_]+\\/[cv]\\/[0-9]+|netflix\\.com\\/WiPlayer|[^\\s]+:32400\\/web\\/index\\.html)/*good*(&)/"
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
