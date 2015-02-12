# Add current video to my kpop playlist.
set myjs to "
var PLAYLIST_NAME = 'kpop';
var MAX_TIME = 10000;
var player =
  document.getElementById('movie_player') ||
  document.getElementsByTagName('embed')[0] ||
  document.getElementById('player1');
var buttons = document.getElementsByClassName('yt-uix-button');
for (var i = 0, len = buttons.length; i < len; i++) {
  var button = buttons[i];
  if (button.getAttribute('title') === 'Add to') {
    button.click();
    break;
  }
}

function searchPlaylists() {
  // Only look through playlists that don't already have the video.
  var selector = '.playlists li:not(.contains-selected-videos) ' +
    '.playlist-name';
  var list = document.querySelectorAll(selector);
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

var scrollTop = document.body.scrollTop;
function waitForNoti() {
  var $notiContainer = document.getElementById('appbar-main-guide-notification-container');
  var start = Date.now();
  var iid = setInterval(function() {
    if ($notiContainer.children.length) {
      clearInterval(iid);
      document.body.scrollTop = scrollTop;
    }
    if (Date.now() - start > MAX_TIME) {
      clearInterval(iid);
    }
  }, 100);
}

if (player) {
  if (!searchPlaylists()) {
    // Wait a while for the playlists to load.
    var start = Date.now();
    var iid = setInterval(function() {
      if (searchPlaylists()) {
        clearInterval(iid);
        waitForNoti();
      }
      if (Date.now() - start > MAX_TIME) {
        clearInterval(iid);
      }
    }, 100);
  } else {
    waitForNoti();
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
