# Pause all youtube videos in all youtube tabs.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
if (player) {
  player.pauseVideo();
}
"

tell application "Google Chrome"
  repeat with t in tabs of windows
    tell t
      if URL starts with "http://www.youtube.com/watch" or URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/embed" or URL starts with "https://www.youtube.com/embed" then
        execute javascript myjs
      end if
    end tell
  end repeat
end tell
