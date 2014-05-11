/*global bind, api, Window, App */

// Switch between windows of the same app and screen.
bind('f', ['ctrl'], function() {
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

var hyper = ['cmd', 'alt', 'ctrl'];
var ctrl = ['ctrl'];

Window.prototype.toGrid = function(x, y, w, h) {
  var screen = this.screen().frameWithoutDockOrMenu();
  this.setFrame({
    x : Math.round(x * screen.w) + screen.x,
    y : Math.round(y * screen.h) + screen.y,
    w : Math.round(w * screen.w),
    h : Math.round(h * screen.h),
  });
  return this;
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
    if (app.title() === title) {
      return app;
    }
  }
};

// Position a window.
function pos(key, x, y, w, h) {
  bind(key, hyper, Window.func('toGrid', x, y, w, h));
}

pos('q', 0.0, 0.0, 0.5, 0.5);
pos('w', 0.5, 0.0, 0.5, 0.5);
pos('a', 0.0, 0.5, 0.5, 0.5);
pos('s', 0.5, 0.5, 0.5, 0.5);
pos('f', 0.0, 0.0, 1.0, 1.0);
pos('z', 0.0, 0.0, 0.5, 1.0);
pos('x', 0.5, 0.0, 0.5, 1.0);

// Switch to specific apps.
bind('w', ctrl, function() {
  var app = App.byTitle('Google Chrome');
  if (app) {
    log('got app');
    var wins = app.allWindows();
    if (wins.length) {
      wins[0].focusWindow();
    }
  }
});

// Focus windos with cdtrl + nm,.
bind('n', ctrl, Window.func('focusWindowLeft'));
bind('m', ctrl, Window.func('focusWindowDown'));
bind(',', ctrl, Window.func('focusWindowUp'));
bind('.', ctrl, Window.func('focusWindowRight'));
