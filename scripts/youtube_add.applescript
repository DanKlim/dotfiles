# Add current video to my kpop playlist.
set myjs to "
var PLAYLIST_NAME = 'kpop';
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
var buttons = document.getElementsByClassName('action-panel-trigger');
for (var i = 0, len = buttons.length; i < len; i++) {
  var button = buttons[i];
  if (button.getAttribute('data-trigger-for') === 'action-panel-addto') {
    button.click();
    break;
  }
}

function getPlaylists() {
  // Only look through playlists that don't already have the video.
  var selector = '.playlist-items li:not(.contains-selected-videos) ' +
    '.playlist-title';
  return document.querySelectorAll(selector);
}

function searchPlaylists(list) {
  if (list.length) {
    for (var i = 0, len = list.length; i < len; i++) {
      var pl = list[i];
      if (pl.textContent.trim() === PLAYLIST_NAME) {
        pl.click();
        console.log('added to the list');
        break;
      }
    }
    return true;
  }
  return false;
}

if (player) {
  var list = getPlaylists();
  if (list.length) {
    searchPlaylists(list)

  } else {
    // Wait a while for the playlists to load.
    var max = 10;
    var n = 0;
    var iid = setInterval(function() {
      if (searchPlaylists(getPlaylists()) || ++n === max) {
        clearInterval(iid);
      }
    }, 500);
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
      if URL starts with "http://www.youtube.com/watch" or URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/embed/videoseries" then
        execute javascript myjs
        exit repeat
      end if
    end tell
  end repeat
end tell
