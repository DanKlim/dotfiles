/*global api, Window, App */
var hyper = ['cmd', 'alt', 'ctrl'];
var ctrl = ['ctrl'];
var cmd = ['cmd'];
var previousSizes = {};

Window.prototype.toGrid = function(x, y, w, h) {
  var screen = this.screen().frameWithoutDockOrMenu();
  this.setFrame({
    x      : Math.round(x * screen.width) + screen.x,
    y      : Math.round(y * screen.height) + screen.y,
    width  : Math.round(w * screen.width),
    height : Math.round(h * screen.height),
  });
  return this;
};

Window.prototype.toggleFullscreen = function() {
  var prevSize = previousSizes[this];
  if (prevSize) {
    this.setFrame(prevSize);
    delete previousSizes[this];
  } else {
    previousSizes[this] = this.frame();
    this.toGrid(0, 0, 1, 1);
  }
};

// Returns function that calls method on the focused window.
Window.func = function(fn) {
  var args = Array.prototype.slice.call(arguments, 1);
  return function() {
    var win = Window.focusedWindow();
    win[fn].apply(win, args);
  };
};

// Calls an object method with given args.
function func(obj, method) {
  var args = Array.prototype.slice.call(arguments, 2);
  if (obj) {
    obj[method].apply(obj, args);
  }
}

function bind(obj, method) {
  var args = Array.prototype.slice.call(arguments, 2);
  return function() {
    if (obj) {
      obj[method].apply(obj, args);
    }
  };
}

function f(fn) {
  var args = Array.prototype.slice.call(arguments, 1);
  return function() {
    fn.apply(null, args);
  };
}

// Get app by title.
App.apps = {};
App.byTitle = function(title) {
  var app = App.apps[title];
  if (app) {
    return app;
  }
  var apps = App.runningApps();
  for (var i = 0, len = apps.length; i < len; i ++) {
    app = apps[i];
    if (app.title() === title) {
      App.apps[title] = app;
      return app;
    }
  }
};

App.focusByTitle = function(title) {
  func(App.byTitle(title), 'focus');
};

App.prototype.firstWindow = function() {
  return this.visibleWindows()[0];
};

App.prototype.focus = function() {
  func(this.firstWindow(), 'focusWindow');
};

api.mbind = function(key, mod, msg, map) {
  var enabled = false;
  var hotkeys = [];
  for (var k in map) {
    (function(key, fn) {
      var hotkey = api.bind(key, null, function() {
        fn();
      });
      hotkey.disable();
      hotkeys.push(hotkey);
    })(k, map[k]);
  }

  function disable() {
    enabled = false;
    hotkeys.forEach(function(hotkey) {
      hotkey.disable();
    });
    api.alert('exit ' + msg);
  }

  var escape = api.bind('escape', null, disable);
  escape.disable();
  hotkeys.push(escape);

  api.bind(key, mod, function() {
    if (enabled) {
      disable();
    } else {
      enabled = true;
      hotkeys.forEach(function(hotkey) {
        hotkey.enable();
      });
      api.alert(msg);
    }
  });
};

// Position a window.
api.bind('q', hyper, Window.func('toGrid', 0.0, 0.0, 0.5, 0.5));
api.bind('w', hyper, Window.func('toGrid', 0.5, 0.0, 0.5, 0.5));
api.bind('a', hyper, Window.func('toGrid', 0.0, 0.5, 0.5, 0.5));
api.bind('s', hyper, Window.func('toGrid', 0.5, 0.5, 0.5, 0.5));
api.bind('z', hyper, Window.func('toGrid', 0.0, 0.0, 0.5, 1.0));
api.bind('x', hyper, Window.func('toGrid', 0.5, 0.0, 0.5, 1.0));
api.bind('f', hyper, Window.func('toggleFullscreen'));

// Switch to specific apps.
api.bind('w', ctrl, bind(App.byTitle('Google Chrome'), 'focus'));
api.bind('e', ctrl, bind(App.byTitle('Terminal'), 'focus'));
api.bind('r', ctrl, bind(App.byTitle('MacVim'), 'focus'));
api.bind('t', ctrl, bind(App.byTitle('µTorrent'), 'focus'));
api.bind('s', ctrl, bind(App.byTitle('Finder'), 'focus'));
api.bind('d', ctrl, bind(App.byTitle('Hipchat'), 'focus'));
api.bind('tab', ctrl, bind(App.byTitle('Spotify'), 'focus'));
api.bind('g', ctrl, bind(App.byTitle('Steam'), 'focus'));

// Focus windos with ctrl + nm,.
api.bind('n', ctrl, Window.func('focusWindowLeft'));
api.bind('m', ctrl, Window.func('focusWindowDown'));
api.bind(',', ctrl, Window.func('focusWindowUp'));
api.bind('.', ctrl, Window.func('focusWindowRight'));

// Position modally
var grid = { width: 4, height: 4 };
function changeGrid(prop, increase) {
  if (increase) {
    ++grid[prop];
  } else if (grid[prop] > 1) {
    --grid[prop];
  }
  api.alert('grid ' + prop + ': ' + grid[prop]);
}

function snap(frameProp, gridProp, increase, adjustPoint) {
  var win = Window.focusedWindow();
  var screenFrame = win.screen().frameWithoutDockOrMenu();
  var block = screenFrame[frameProp] / grid[gridProp];
  var winFrame = win.frame();
  var winBlocks = winFrame[frameProp] / block;
  var val = winFrame[frameProp];
  var newval;

  // If close enough, consider window already snapped.
  var closeness = winBlocks % 1;
  if (closeness < 0.05 || closeness > 0.95) {
    if (increase) {
      newval = Math.min(val + block, screenFrame[gridProp]);
    } else {
      newval = Math.max(val - block, block);
    }
  } else {
    newval = Math[increase ? 'ceil' : 'floor'](winBlocks) * block;
  }
  winFrame[frameProp] = newval;
  if (adjustPoint) {
    var adjustment = val - newval;
    var adjusted = winFrame[adjustPoint] + adjustment;
    if (Math.abs(adjustment) > 5 &&
        adjusted >= 0 && adjustment + newval <= screenFrame[gridProp]) {
      winFrame[adjustPoint] = adjusted;
    }
  }
  win.setFrame(winFrame);
}

api.mbind('s', cmd, 'size', {
  'y': f(changeGrid, 'width', false),
  'u': f(changeGrid, 'height', false),
  'i': f(changeGrid, 'height', true),
  'o': f(changeGrid, 'width', true),
  'j': f(snap, 'height', 'height', true),
  'k': f(snap, 'height', 'height', false),
  'm': f(snap, 'height', 'height', false, 'y'),
  ',': f(snap, 'height', 'height', true, 'y'),
  'h': f(snap, 'width', 'width', false),
  'l': f(snap, 'width', 'width', true),
  'n': f(snap, 'width', 'width', true, 'x'),
  '.': f(snap, 'width', 'width', false, 'x'),
});
