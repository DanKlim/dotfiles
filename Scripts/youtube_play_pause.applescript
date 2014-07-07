# Play or pause a video.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');

if (player) {
  if (player.getPlayerState() === 1) {
    player.pauseVideo();
  } else {
    player.playVideo();
  }
}
"

tell application "Google Chrome"
  set t to active tab of front window
  tell t
    if URL starts with "http://www.youtube.com/watch" or URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/embed" or URL starts with "https://www.youtube.com/embed" then
      execute javascript myjs
      return
    end if
  end tell

  repeat with t in tabs of windows
    tell t
      if URL starts with "http://www.youtube.com/watch" or URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/embed" or URL starts with "https://www.youtube.com/embed" then
        execute javascript myjs
        exit repeat
      end if
    end tell
  end repeat
end tell