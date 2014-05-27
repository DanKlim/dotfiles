# If in a playlist, play the next video.
set myjs to "
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
var next = document.getElementsByClassName('yt-uix-button-icon-playlist-bar-next')[0];
if (player && rnd && next) {
  rnd.click();
  next.click();
}
"

tell application "Google Chrome"
  repeat with t in tabs of windows
    tell j
      if URL starts with "http://www.youtube.com/watch" or URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/embed" or URL starts with "https://www.youtube.com/embed" then
        execute javascript myjs
        exit repeat
      end if
    end tell
  end repeat
end tell
