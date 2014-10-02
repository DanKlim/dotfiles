# Add current video to my kpop playlist.
set myjs to "
var PLAYLIST_NAME = 'kpop';
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
var buttons = document.getElementsByClassName('yt-uix-button');
for (var i = 0, len = buttons.length; i < len; i++) {
  var button = buttons[i];
  if (button.getAttribute('data-trigger-for') === 'action-panel-addto') {
    button.click();
    break;
  }
}

function getPlaylists() {
  // Only look through playlists that don't already have the video.
  var selector = '.playlists li:not(.contains-selected-videos) ' +
    '.playlist-name';
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
