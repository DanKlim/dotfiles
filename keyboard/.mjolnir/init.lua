local alert = require "mjolnir.alert"
local hotkey = require "mjolnir.hotkey"
local window = require "mjolnir.window"
local fnutils = require "mjolnir.fnutils"
local screen = require "mjolnir.screen"
local appfinder = require "mjolnir.cmsj.appfinder"
local pathwatcher = require "mjolnir._asm.pathwatcher"
local grid = require "grid"

alert.show("Hello this is mjolnir", 1.5)

pathwatcher.new(os.getenv("HOME") .. "/.mjolnir/", mjolnir.reload):start()

-- switch between app windows of the same screen
hotkey.bind({"alt"}, "F", function()
  local win = window.focusedwindow()
  if win then
    local winApp = win:application()

    for _, otherwin in ipairs(win:otherwindows_samescreen()) do
      if otherwin:application() == winApp then
        otherwin:focus()
        break
      end
    end
  end
end)

-- specific app switching
local appsTable = {}
local function focusApp(name)
  return function()
    local app = appsTable[name]
    if app == nil or not app:unhide() or not app:activate() then
      app = appfinder.app_from_name(name)
      if app then
        appsTable[name] = app
        if app:ishidden() then
          app:unhide()
        end
        app:activate()
      end
    end
    if app then
      local lastwin = app:allwindows()[1]
      if lastwin then
        lastwin:focus()
      end
    end
  end
end

local function each(funcs)
  return function()
    for _, fn in ipairs(funcs) do
      fn()
    end
  end
end

local switchKey = {"alt"}
hotkey.bind(switchKey, "W", focusApp("Google Chrome"))
hotkey.bind(switchKey, "E", focusApp("Terminal"))
hotkey.bind(switchKey, "R", focusApp("MacVim"))
hotkey.bind(switchKey, "S", focusApp("Finder"))
hotkey.bind(switchKey, "D", focusApp("HipChat"))
hotkey.bind(switchKey, "T", focusApp("µTorrent"))
hotkey.bind(switchKey, "G", each({
  focusApp("Clementine"),
  focusApp("Spotify"),
}))
hotkey.bind(switchKey, "2", focusApp("Skype"))
hotkey.bind(switchKey, "3", focusApp("Steam"))
hotkey.bind(switchKey, "4", focusApp("Messages"))
hotkey.bind(switchKey, "5", focusApp("Mumble"))
hotkey.bind(switchKey, "6", focusApp("Adium"))
hotkey.bind(switchKey, "7", focusApp("Microsoft Outlook"))

-- change window size / position
local winKey = {"ctrl", "alt"}

hotkey.bind(winKey, "Y", function() grid.adjustwidth( -1) end)
hotkey.bind(winKey, "U", function() grid.adjustheight(-1) end)
hotkey.bind(winKey, "I", function() grid.adjustheight( 1) end)
hotkey.bind(winKey, "O", function() grid.adjustwidth(  1) end)

hotkey.bind(winKey, "P", grid.maximize_window)

hotkey.bind(winKey, "B", grid.pushwindow_nextscreen)

hotkey.bind(winKey, "RETURN", function()
  grid.snap(window.focusedwindow())
end)

hotkey.bind(winKey, "N", grid.pushwindow_left)
hotkey.bind(winKey, "M", grid.pushwindow_down)
hotkey.bind(winKey, ",", grid.pushwindow_up)
hotkey.bind(winKey, ".", grid.pushwindow_right)

hotkey.bind(winKey, "H", grid.resizewindow_thinner)
hotkey.bind(winKey, "J", grid.resizewindow_shorter)
hotkey.bind(winKey, "K", grid.resizewindow_taller)
hotkey.bind(winKey, "L", grid.resizewindow_wider)

-- store and restore all window positions
local windowPositions = {}
local function getScreensKey()
  local key = ""
  fnutils.each(screen.allscreens(), function(screen)
    local frame = screen:frame();
    key = key .. "-" .. frame.w .. "x" .. frame.h
  end)
  return key
end

hotkey.bind({"ctrl", "cmd"}, "S", function()
  local positions = {}
  windowPositions[getScreensKey()] = positions
  fnutils.each(window.allwindows(), function(win)
    if win:isstandard() and not win:isminimized() then
      table.insert(positions, {
        win = win,
        frame = win:frame(),
      })
    end
  end)
  alert.show("all window positions saved")
end)

hotkey.bind({"ctrl", "cmd"}, "D", function()
  local positions = windowPositions[getScreensKey()]
  if not positions then return end
  for i = 1, #positions do
    local hash = positions[i]
    local win = hash.win
    if win:isstandard() then
      win:setframe(hash.frame)
    end
  end
  alert.show("all window positions restored")
end)
