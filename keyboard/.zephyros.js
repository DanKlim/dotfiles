/*global bind, listen, api, log, Window, App, Screen */

var hyper = ['cmd', 'alt', 'ctrl'];
var ctrl = ['ctrl'];

// Switch between windows of the same app and screen.
bind('f', ctrl, function() {
  var win = api.focusedWindow();
  var appTitle = win.app().title();
  var wins = win
    .otherWindowsOnSameScreen()
    .filter(function(w) {
      return w.app().title() === appTitle;
    });
  if (wins.length) {
    wins[0].focusWindow();
  }
});

Window.prototype.toGrid = function(x, y, w, h, otherScreen) {
  var screen;
  if (otherScreen) {
    var screens = api.allScreens();
    if (screens.length > 1) {
      screen = screens[1];
    }
  } else {
    screen = this.screen();
  }
  var frame = screen.frameWithoutDockOrMenu();

  this.setFrame({
    x : Math.round(x * frame.w) + frame.x,
    y : Math.round(y * frame.h) + frame.y,
    w : Math.round(w * frame.w),
    h : Math.round(h * frame.h),
  });
  return this;
};

Screen.laptop = { w: 1280, h: 800 };
Screen.tbolt = { w: 2560, h: 1440 };

Screen.prototype.isMain = function() {
  var frame = this.frameIncludingDockAndMenu();
  var main = Screen.laptop;
  log('ohoh ' + frame.w + ', ' + frame.h + ', ' + main.w + ', ' + main.h);
  return ~~frame.w === main.w && ~~frame.h === main.h;
};

// Returns function that calls method on a window.
Window.func = function(fn) {
  var args = Array.prototype.slice.call(arguments, 1);
  return function() {
    var win = api.focusedWindow();
    win[fn].apply(win, args);
  };
};

// Get app by title.
App.byTitle = function(title) {
  var apps = api.runningApps();
  for (var i = 0, len = apps.length; i < len; i ++) {
    var app = apps[i];

    // `App#title()` return an object not a string.
    if ('' + app.title() === title) {
      return app;
    }
  }
};

// Position a window.
function pos(key, x, y, w, h, otherScreen) {
  bind(key, hyper, Window.func('toGrid', x, y, w, h, otherScreen));
}

pos('q', 0.0, 0.0, 0.5, 0.5);
pos('w', 0.5, 0.0, 0.5, 0.5);
pos('a', 0.0, 0.5, 0.5, 0.5);
pos('s', 0.5, 0.5, 0.5, 0.5);
pos('f', 0.0, 0.0, 1.0, 1.0);
pos('z', 0.0, 0.0, 0.5, 1.0);
pos('x', 0.5, 0.0, 0.5, 1.0);
pos('c', 0.0, 0.0, 1.0, 1.0);
pos('v', 0.25, 0.5, 0.5, 0.5, true);
pos('b', 0.25, 0.0, 0.5, 0.5, true);

// Switch to specific apps.
function focusApp(key, appName) {
  bind(key, ctrl, function() {
    var app = App.byTitle(appName);
    if (app) {
      app.show();
      var wins = app.visibleWindows();
      if (wins.length) {
        wins[0].focusWindow();
      }
    }
  });
}

focusApp('w', 'Google Chrome');
focusApp('e', 'Terminal');
focusApp('r', 'MacVim');
focusApp('t', 'µTorrent');
focusApp('s', 'Finder');
focusApp('d', 'HipChat');
focusApp('g', 'Clementine');
focusApp('7', 'Skype');
focusApp('8', 'Steam');
focusApp('9', 'Messages');

// Focus windos with cdtrl + nm,.
bind('n', ctrl, Window.func('focusWindowLeft'));
bind('m', ctrl, Window.func('focusWindowDown'));
bind(',', ctrl, Window.func('focusWindowUp'));
bind('.', ctrl, Window.func('focusWindowRight'));

var devToolsRegexp = /^(Developer Tools - |chrome-devtools:\/\/devtools\/)/;
// Examples:
//   www.twitch.tv/slidingghost/c/4193238/popout?t=5s
//   www.twitch.tv/slidingghost/popout
var twitchVideoRegexp = /^www\.twitch\.tv\/[^\/]+(\/c\/\d+)?\/popout/;
// Example: www.twitch.tv/slidingghost/chat?popout=
var twitchChatRegexp = /^www\.twitch\.tv\/[^\/]+\/chat\?popout/;

// When certain apps open new windows.
listen('window_created', function(win) {
  var app = win.app();
  if (!app) { return; }
  var appTitle = '' + app.title();

  // Keeping this here for now for logging purposes.
  // Window titles are inconsistent.
  log('window created: ' + appTitle);
  switch (appTitle) {
  case 'Terminal':
    if (win.screen().isMain()) {
      win.toGrid(0.0, 0.0, 0.5, 1.0);
    }
    break;
  case 'MacVim':
    if (win.screen().isMain()) {
      win.toGrid(0.5, 0.0, 0.5, 1.0);
    }
    break;
  case 'Google Chrome':
    var title = win.title();
    if (devToolsRegexp.test(title)) {
      win.toGrid(0.0, 0.5, 0.25, 0.5, true);
    } else if (title === 'Untitled' || twitchVideoRegexp.test(title)) {
      win.toGrid(0.75, 0.66, 0.25, 0.33, true);
    } else if (twitchChatRegexp.test(title)) {
      win.toGrid(0.75, 0.375, 0.125, 0.29, true);
    } else if (title === 'My subscriptions - YouTube') {
      win.toGrid(0.75, 0.625, 0.25, 0.375, true);
    }
    break;
  }
});
