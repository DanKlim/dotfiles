/*global S, ifOneScreen, chain, each, push, focusApp */
S.source('~/keyboard/config.js');
S.source('~/keyboard/util.js');

// Enable better app switcher.
// S.bind('f:ctrl', S.op('switch'));

// Switch to same window app in same screen.
S.bind('f:ctrl', function(win) {
  if (!win) return;
  var screenID = win.screen().id();
  var app = win.app();
  app.eachWindow(function(otherWin) {
    if (otherWin.screen().id() === screenID && otherWin !== win) {
      otherWin.focus();
    }
  });
});

// Show window hints.
S.bind('e:cmd', S.op('hint', { characters: 'ASDFGQWERTCV' }));

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

// Positional operations.
var lapLeft = S.op('push', {
  screen    : laptop,
  direction : 'left',
  style     : 'bar-resize:screenSizeX/2',
});
var lapRight = lapLeft.dup({ direction: 'right' });

// Thunderbolt 4x2 grid.
var tboltTopFarLeft = S.op('move', {
  screen : tbolt,
  x      : 'screenOriginX',
  y      : 'screenOriginY',
  width  : 'screenSizeX/4',
  height : 'screenSizeY/2',
});
var tboltTopLeft     = tboltTopFarLeft.dup({
  x: 'screenOriginX+screenSizeX/4'
});
var tboltTopRight    = tboltTopFarLeft.dup({
  x: 'screenOriginX+screenSizeX/2'
});
var tboltTopFarRight = tboltTopFarLeft.dup({
  x: 'screenOriginX+screenSizeX/4*3'
});
var tboltBotFarLeft  = tboltTopFarLeft.dup({
  y: 'screenOriginY+screenSizeY/2'
});
var tboltBotLeft     = tboltBotFarLeft.dup({
  x: 'screenOriginX+screenSizeX/4'
});
var tboltBotRight    = tboltBotFarLeft.dup({
  x: 'screenOriginX+screenSizeX/2'
});
var tboltBotFarRight = tboltBotFarLeft.dup({
  x: 'screenOriginX+screenSizeX/4*3'
});
var tboltMove4x2 =  [
  tboltTopFarLeft, tboltTopLeft, tboltTopRight, tboltTopFarRight,
  tboltBotFarLeft, tboltBotLeft, tboltBotRight, tboltBotFarRight
];
var tboltTwitchVideo = S.op('move', {
  screen : tbolt,
  x      : 'screenOriginX+screenSizeX/4*3',
  y      : 'screenOriginY+screenSizeY/3*2',
  width  : 'screenSizeX/4',
  height : 'screenSizeY/3',
});
var tboltTwitchChat = S.op('move', {
  screen : tbolt,
  x      : 'screenOriginX+screenSizeX/4*3',
  y      : 'screenOriginj+screenSizeY/8*3',
  width  : 'screenSizeX/8',
  height : 'screenSizeY/24*7',
});
var tboltYoutubeVideo = S.op('move', {
  screen : tbolt,
  x      : 'screenOriginX+screenSizeX/4*3',
  y      : 'screenOriginY+screenSizeY/8*5',
  width  : 'screenSizeX/4',
  height : 'screenSizeY/8*3',
});

// Switch to specific apps.
S.bind('w:ctrl', each(
  focusApp('Google Chrome'),
  ifOneScreen(push('HUDTube', 'bottom right'))
));
S.bind('e:ctrl', focusApp('Terminal'));
S.bind('r:ctrl', each(
  focusApp('MacVim'),
  ifOneScreen(push('HUDTube', 'bottom left'))
));
S.bind('s:ctrl', focusApp('Finder'));
S.bind('d:ctrl', focusApp('HipChat'));
S.bind('t:ctrl', focusApp('µTorrent'));
S.bind('g:ctrl', each(
  focusApp('Spotify'),
  focusApp('Clementine')
));
S.bind('6:ctrl', focusApp('Mumble'));
S.bind('7:ctrl', focusApp('Skype'));
S.bind('8:ctrl', focusApp('Steam'));
S.bind('9:ctrl', focusApp('Messages'));

var n = 0;
var devToolsRegexp = /^(Developer Tools - |chrome-devtools:\/\/devtools\/)/;
// Examples:
//   www.twitch.tv/slidingghost/c/4193238/popout?t=5s
//   www.twitch.tv/slidingghost/popout
var twitchVideoRegexp = /^www\.twitch\.tv\/[^\/]+(\/c\/\d+)?\/popout/;
// Example: www.twitch.tv/slidingghost/chat?popout=
var twitchChatRegexp = /^www\.twitch\.tv\/[^\/]+\/chat\?popout/;
S.on('windowOpened', function(e, win) {
  switch (win.app().name()) {
  // Position new Terminal window.
  case 'Terminal':
    if (win.screen().isMain()) {
      win.doop(lapLeft);
    } else {
      win.doop(tboltMove4x2[n++ % tboltMove4x2.length]);
    }
    break;
  case 'MacVim':
    if (win.screen().isMain()) {
      win.doop(lapRight);
    }
    break;
  case 'Google Chrome':
    var title = win.title();
    // Keeping this here for now for logging purposes.
    // Window titles are inconsistent.
    S.log('title', title);
    if (devToolsRegexp.test(title)) {
      win.doop(tboltBotFarLeft);
    } else if (title === 'Untitled' || twitchVideoRegexp.test(title)) {
      win.doop(tboltTwitchVideo);
    } else if (twitchChatRegexp.test(title)) {
      win.doop(tboltTwitchChat);
    } else if (title === 'My subscriptions - YouTube') {
      win.doop(tboltYoutubeVideo);
    }
    break;
  }
});

// When a MacVim window closes, focus on the app that's behind.
// This is usually the wanted behavior.
S.on('windowClosed', function(e, app) {
  switch (app.name()) {
    case 'MacVim':
      focusApp('Terminal')();
      break;
  }
});

// Focus windows with ctrl + nm,..
S.bind('n:ctrl', S.op('focus', { direction: 'left' }));
S.bind('m:ctrl', S.op('focus', { direction: 'down' }));
S.bind(',:ctrl', S.op('focus', { direction: 'up' }));
S.bind('.:ctrl', S.op('focus', { direction: 'right' }));
