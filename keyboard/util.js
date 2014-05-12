/*global S */
/*jshint unused:false */

// Returns true if there is currently one screen.
function oneScreen() {
  return S.screenCount() === 1;
}

// Only runs operation if there is currently one screen.
function ifOneScreen(op) {
  return function() {
    if (oneScreen()) {
      op();
    }
  };
}

function chain() {
  return S.op('chain', {
    operations: Array.prototype.slice.call(arguments)
  });
}

function each() {
  var ops = Array.prototype.slice.call(arguments);
  return function() {
    ops.forEach(function(op) {
      if (op) { op(); }
    });
  };
}

// Keep copy of focus specific apps ops.
var focusAppOps = {};

function focusApp(appName) {
  var op = focusAppOps[appName];
  if (!op) {
    op = focusAppOps[appName] = S.op('focus', { app: appName });
  }
  return op.run.bind(op);
}

function getApp(appName) {
  var theapp;
  S.eachApp(function(app) {
    if (app.name() === appName) {
      theapp = app;
      return false;
    }
  });
  return theapp;
}

// Pushes an app in given directions.
// `directions` can be multiple directions separated by a space.
function push(appName, directions) {
  return function() {
    var app = getApp(appName);
    if (app) {
      var win = app.mainWindow();
      if (win && win.isMovable()) {
        directions.split(' ').forEach(function(direction) {
          win.doop(S.op('push', { direction: direction }));
        });
      }
    }
  };
}
