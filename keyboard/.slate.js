/*global S, chain */
S.source('~/keyboard/config.js');
S.source('~/keyboard/util.js');

// Undo an op.
S.bind('u:cmd;alt;ctrl', S.op('undo'));

// Relaunch Slate so that the config is loaded again after an edit.
S.bind('r:cmd;shift', S.op('relaunch'));

// Monitors.
var laptop = '1280x800';
var tbolt = '2560x1440';

// Throw app between monitors.
var throwLaptop = S.op('throw', {
  screen : laptop,
  x      : 'screenOriginX',
  y      : 'screenOriginY',
  width  : 'screenSizeX/2',
  height : 'screenSizeY',
});
var throwTbolt = S.op('throw', {
  screen: tbolt,
  x      : 'screenOriginX',
  y      : 'screenOriginY',
  width  : 'screenSizeX/4',
  height : 'screenSizeY/2',
});
S.bind('n:ctrl;cmd;alt', chain(throwLaptop, throwTbolt));

// Focus windows with ctrl + nm,..
S.bind('n:ctrl', S.op('focus', { direction: 'left' }));
S.bind('m:ctrl', S.op('focus', { direction: 'down' }));
S.bind(',:ctrl', S.op('focus', { direction: 'up' }));
S.bind('.:ctrl', S.op('focus', { direction: 'right' }));
