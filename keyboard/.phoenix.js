/*global api, Window */
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

// Position a window.
api.bind('q', hyper, Window.func('toGrid', 0.0, 0.0, 0.5, 0.5));
api.bind('w', hyper, Window.func('toGrid', 0.5, 0.0, 0.5, 0.5));
api.bind('a', hyper, Window.func('toGrid', 0.0, 0.5, 0.5, 0.5));
api.bind('s', hyper, Window.func('toGrid', 0.5, 0.5, 0.5, 0.5));
api.bind('z', hyper, Window.func('toGrid', 0.0, 0.0, 0.5, 1.0));
api.bind('x', hyper, Window.func('toGrid', 0.5, 0.0, 0.5, 1.0));
api.bind('f', hyper, Window.func('toggleFullscreen'));

// Focus windows in directions with ctrl + nm,.
api.bind('n', ctrl, Window.func('focusWindowLeft'));
api.bind('m', ctrl, Window.func('focusWindowDown'));
api.bind(',', ctrl, Window.func('focusWindowUp'));
api.bind('.', ctrl, Window.func('focusWindowRight'));

function f(fn) {
  var args = Array.prototype.slice.call(arguments, 1);
  return function() {
    fn.apply(null, args);
  };
}

var modalModes = [];
api.mbind = function(key, mod, msg, map) {
  var enabled = false;
  var hotkeys = [];
  for (var k in map) {
    (function(key, fn) {
      var hotkey = api.bind(key, null, function() {
        fn();
        disable();
      });
      hotkey.disable();
      hotkeys.push(hotkey);
    })(k, map[k]);
  }

  function disable(exitMsg) {
    if (!enabled) { return; }
    enabled = false;
    hotkeys.forEach(function(hotkey) {
      hotkey.disable();
    });
    if (exitMsg) {
      api.alert('exit ' + msg);
    }
  }

  var disableWithMsg = disable.bind(null, true);
  var escape = api.bind('escape', null, disableWithMsg);
  escape.disable();
  hotkeys.push(escape);

  api.bind(key, mod, function() {
    if (enabled) {
      disable(true);
    } else {
      modalModes.forEach(function(disable) { disable(); });
      enabled = true;
      hotkeys.forEach(function(hotkey) {
        hotkey.enable();
      });
      api.alert(msg);
    }
  });

  // Add the `disable()` function defined here to an array so that
  // when one modal mode is enabled, others are disabled.
  modalModes.push(disable);
};

// Position modally
var grid = { width: 4, height: 4 };
function changeGrid(prop, increase) {
  var inc = 0;
  var symbol = '';
  if (increase) {
    inc = grid[prop];
    symbol = ' + ';
    grid[prop] *= 2;
  } else if (grid[prop] > 1) {
    symbol = ' - ';
    inc = grid[prop] / 2;
    grid[prop] /= 2;
  }
  api.alert('grid ' + prop + symbol + inc +
    ': [' + grid.width + ',' + grid.height + ']');
}

function snap(prop, pivot, increase, adjustPivot) {
  var win = Window.focusedWindow();
  var screenFrame = win.screen().frameWithoutDockOrMenu();
  var block = screenFrame[prop] / grid[prop];
  var winFrame = win.frame();
  var winBlocks = winFrame[prop] / block;
  var val = winFrame[prop];
  var newval;

  // Snap pivot to nearest block.
  winFrame[pivot] = Math.round(winFrame[pivot] / block) * block;

  var closeness = winBlocks % 1;
  if (closeness < 0.05 || closeness > 0.91) {
    // If close enough, consider window already snapped.
    var blocks = Math.round(winBlocks) * block;
    if (increase) {
      var screenSize = screenFrame[prop];
      if (!adjustPivot) {
        screenSize -= winFrame[pivot];
      }
      newval = Math.min(blocks + block, screenSize);
    } else {
      newval = Math.max(blocks - block, block);
    }
  } else {
    // If not already snapped, snap to nearest block size and position.
    var round = Math[increase ? 'ceil' : 'floor'];
    newval = round(winBlocks) * block;
  }
  winFrame[prop] = newval;

  if (adjustPivot) {
    // If `adjustPivot` is set, then the window's top left point
    // will be adjusted so that the bottom/right side of the window
    // stays in the same position.
    var adjustment = val - newval;
    var adjusted = winFrame[pivot] + adjustment;
    if (Math.abs(adjustment) > 5 &&
        adjusted >= 0 && adjustment + newval <= screenFrame[prop]) {
      winFrame[pivot] = adjusted;
    }
  }
  win.setFrame(winFrame);
}

api.mbind('i', cmd, 'config', {
  a: f(changeGrid, 'width', false),
  s: f(changeGrid, 'height', false),
  d: f(changeGrid, 'height', true),
  f: f(changeGrid, 'width', true),
});

api.mbind('j', cmd, 'resize width', {
  a: f(snap, 'width', 'x', true, false),
  s: f(snap, 'width', 'x', false, false),
  d: f(snap, 'width', 'x', false, true),
  f: f(snap, 'width', 'x', true, true),
});

api.mbind('k', cmd, 'resize height', {
  a: f(snap, 'height', 'y', false, false),
  s: f(snap, 'height', 'y', true, false),
  d: f(snap, 'height', 'y', true, true),
  f: f(snap, 'height', 'y', false, true),
});
