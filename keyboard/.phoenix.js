/*global api, Window */
var hyper = ['cmd', 'alt', 'ctrl'];
var ctrl = ['ctrl'];
var cmd = ['cmd'];
var previousSizes = {};

/**
 * Sets a window's frame to a grid with its properties as percentages.
 *
 * @param {Number} x
 * @param {Number} y
 * @param {Number} w
 * @param {Number} h
 */
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

/**
 * Returns function that calls method on the focused window.
 *
 * @param {Function} fn
 * @return {Function}
 */
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

// Keep track of modal mode bindings.
var modalModes = [];

/**
 * Creates a "modal" mode by binding more keys to actions specified in
 * `map` when `key` and `mod` are pressed.
 * Will exit out of this mode when either the activation binding is pressed
 * again, escape is pressed, any key in the map is pressed, or
 * another modal mode is activated.
 *
 * Will display a `msg` when entering/exiting this mode.
 *
 * @param {String} key
 * @param {Array.<String>} mod
 * @param {String} msg
 * @param {Object.<Function>} map
 */
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

// Position modally.
var grid = { width: 4, height: 4 };

/**
 * Changes the dimensions of the grid and shows an alert with the
 * property changed and the updated grid.
 *
 * @param {String} prop
 * @param {Boolean} increase
 */
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

/**
 * Snaps the current window to the grid and changes its property
 * size by a block. A `block` is equal to the screen property size
 * divided by the grid property. For example, if the screen's with is
 * 1200, and the grid width is 4, a block is 300.
 *
 * If the window's size is within 10% of a multiple of a block,
 * it will round the size the nearest block multiple, and it will
 * add or remove a block. If not, then it will only "round".
 * Round will mean `Math.ceil()` if `increase` is `true`,
 * `Math.floor()` otherwise.
 *
 * The `pivot` will also be snapped to the nearest grid intersection.
 *
 * @param {String} prop
 * @param {String} pivot
 * @param {Boolean} increase
 * @param {Boolean} adjustPivot
 */
function snap(prop, pivot, increase, adjustPivot) {
  var win = Window.focusedWindow();
  var screenFrame = win.screen().frameWithoutDockOrMenu();
  var block = screenFrame[prop] / grid[prop];
  var winFrame = win.frame();
  var winBlocks = winFrame[prop] / block;
  var val = winFrame[prop];
  var newval;

  // Snap pivot to nearest block.
  winFrame[pivot] = screenFrame[pivot] +
    Math.round(winFrame[pivot] / block) * block;

  var closeness = winBlocks % 1;
  if (closeness < 0.1 || closeness > 0.91) {
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
    winFrame[pivot] = winFrame[pivot] + adjustment;
  }
  win.setFrame(winFrame);
}

/**
 * Pushes the current window to the edge of its screen.
 *
 * @param {String} prop
 * @param {String} pivot
 * @param {Boolean} increase
 */
function push(prop, pivot, increase) {
  var win = Window.focusedWindow();
  var screenFrame = win.screen().frameWithoutDockOrMenu();
  var winFrame = win.frame();
  winFrame[pivot] = screenFrame[pivot];
  if (increase) {
    winFrame[pivot] += screenFrame[prop] - winFrame[prop];
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

api.mbind('u', cmd, 'push', {
  a: f(push, 'width', 'x', false), // left
  s: f(push, 'height', 'y', true), // down
  d: f(push, 'height', 'y', false),  // up
  f: f(push, 'width', 'x', true),  // right
});
