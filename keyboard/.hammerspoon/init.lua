hs.alert.show("Hello this is Hammerspoon", 1.5)
watcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", hs.reload):start()

-- Focus apps
local function focusApp(name)
  return function()
    app = hs.application.get(name)
    if not app:unhide() or app:activate()then end
  end
end

local switchKey = {"alt"}
hs.hotkey.bind(switchKey, "W", focusApp("Google Chrome"))
hs.hotkey.bind(switchKey, "E", focusApp("Cathode"))
hs.hotkey.bind(switchKey, "R", focusApp("MacVim"))
hs.hotkey.bind(switchKey, "S", focusApp("Finder"))
hs.hotkey.bind(switchKey, "D", focusApp("Discord"))
hs.hotkey.bind(switchKey, "J", focusApp("Slack"))
hs.hotkey.bind(switchKey, "T", focusApp("Transmission Remote GUI"))
hs.hotkey.bind(switchKey, "G", hs.fnutils.sequence(
  focusApp("iTunes"),
  focusApp("Clementine"),
  focusApp("Spotify")
))
hs.hotkey.bind(switchKey, "2", focusApp("Skype"))
hs.hotkey.bind(switchKey, "3", focusApp("Steam"))
hs.hotkey.bind(switchKey, "4", focusApp("Messages"))
hs.hotkey.bind(switchKey, "8", focusApp("Preview"))
hs.hotkey.bind(switchKey, "9", focusApp("Notes"))

-- Change window size / position
local winKey = {"ctrl", "alt"}

hs.grid.setMargins(hs.geometry.size(0, 0))
hs.grid.setGrid(hs.geometry.size(4, 4))

hs.hotkey.bind(winKey, "Y", function()
  grid = hs.grid.getGrid()
  grid.w = math.max(grid.w - 1, 1)
  hs.grid.setGrid(grid)
  hs.alert.show("Grid width set to " .. grid.w)
end)
hs.hotkey.bind(winKey, "U", function()
  grid = hs.grid.getGrid()
  grid.h = math.max(grid.h - 1, 1)
  hs.grid.setGrid(grid)
  hs.alert.show("Grid height set to " .. grid.h)
end)
hs.hotkey.bind(winKey, "I", function()
  grid = hs.grid.getGrid()
  grid.h = grid.h + 1
  hs.grid.setGrid(grid)
  hs.alert.show("Grid height set to " .. grid.h)
end)
hs.hotkey.bind(winKey, "O", function()
  grid = hs.grid.getGrid()
  grid.w = grid.w + 1
  hs.grid.setGrid(grid)
  hs.alert.show("Grid width set to " .. grid.w)
end)

hs.hotkey.bind(winKey, "P", hs.grid.maximizeWindow)

hs.hotkey.bind(winKey, "return", function()
  hs.grid.snap(hs.window.focusedWindow())
end)

hs.hotkey.bind(winKey, "N", hs.grid.pushWindowLeft)
hs.hotkey.bind(winKey, "M", hs.grid.pushWindowDown)
hs.hotkey.bind(winKey, ",", hs.grid.pushWindowUp)
hs.hotkey.bind(winKey, ".", hs.grid.pushWindowRight)

hs.hotkey.bind(winKey, "H", hs.grid.resizeWindowThinner)
hs.hotkey.bind(winKey, "J", hs.grid.resizeWindowShorter)
hs.hotkey.bind(winKey, "K", hs.grid.resizeWindowTaller)
hs.hotkey.bind(winKey, "L", hs.grid.resizeWindowWider)

-- Show grid
hs.hotkey.bind({"cmd"}, "G", hs.grid.toggleShow)

-- Focus windows directionally
hs.hotkey.bind({"ctrl"}, "N", hs.window.filter.focusWest)
hs.hotkey.bind({"ctrl"}, "M", hs.window.filter.focusSouth)
hs.hotkey.bind({"ctrl"}, ",", hs.window.filter.focusNorth)
hs.hotkey.bind({"ctrl"}, ".", hs.window.filter.focusEast)

-- Key Remmaps
hs.hotkey.bind({"ctrl"}, "H", hs.fnutils.partial(hs.eventtap.keyStroke, {"cmd", "shift"}, "["))
hs.hotkey.bind({"ctrl"}, "J", hs.fnutils.partial(hs.eventtap.keyStroke, {}, "down"))
hs.hotkey.bind({"ctrl"}, "K", hs.fnutils.partial(hs.eventtap.keyStroke, {}, "up"))
hs.hotkey.bind({"ctrl"}, "L", hs.fnutils.partial(hs.eventtap.keyStroke, {"cmd", "shift"}, "]"))
hs.hotkey.bind({"ctrl"}, "space", hs.fnutils.partial(hs.eventtap.keyStroke, {}, "return"))
hs.hotkey.bind({"alt"}, "space", function()
  hs.eventtap.keyStroke({}, "tab")
  hs.eventtap.keyStroke({}, "space")
end)
