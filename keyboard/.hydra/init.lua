hydra.alert("Hello this is hydra", 1.5)

-- show the menu
menu.show(function()
  local updatetitles = {[true] = "Install Update", [false] = "Check for Update..."}
  local updatefns = {[true] = updates.install, [false] = checkforupdates}
  local hasupdate = (updates.newversion ~= nil)

  return {
    {title = "Reload Config", fn = hydra.reload},
    {title = "Show Logs", fn = logger.show},
    {title = "-"},
    {title = "About", fn = hydra.showabout},
    {title = updatetitles[hasupdate], fn = updatefns[hasupdate]},
    {title = "Quit Hydra", fn = os.exit},
  }
end)

function checkforupdates()
  updates.check()
  settings.set("lastcheckedupdates", os.time())
end

-- check for updates every week
timer.new(timer.weeks(1), checkforupdates):start()

-- launch Hydra at login
autolaunch.set(true)

-- reload config automatically
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

-- switch between app windows of the same screen
hotkey.bind({"alt"}, "F", function()
  local win = window.focusedwindow()
  local winApp = win:application()

  for _, otherwin in ipairs(win:otherwindows_samescreen()) do
    if otherwin:application() == winApp then
      otherwin:focus()
      break
    end
  end
end)

-- specific app switching
require "appfinder"
local appsTable = {}
local function focusApp(name)
  return function()
    local app = appsTable[name]
    if app == nil or not app:activate() then
      app = ext.appfinder.app_from_name(name)
      if app then
        appsTable[name] = app
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
hotkey.bind(switchKey, "6", focusApp("Mumble"))
hotkey.bind(switchKey, "7", focusApp("Skype"))
hotkey.bind(switchKey, "8", focusApp("Steam"))
hotkey.bind(switchKey, "9", focusApp("Messages"))

-- change window size / position
require "grid"
local winKey = {"ctrl", "alt"}

hotkey.bind(winKey, "Y", function() ext.grid.adjustwidth( -1) end)
hotkey.bind(winKey, "U", function() ext.grid.adjustheight(-1) end)
hotkey.bind(winKey, "I", function() ext.grid.adjustheight( 1) end)
hotkey.bind(winKey, "O", function() ext.grid.adjustwidth(  1) end)

hotkey.bind(winKey, "P", ext.grid.maximize_window)

hotkey.bind(winKey, "B", ext.grid.pushwindow_nextscreen)

hotkey.bind(winKey, "N", ext.grid.pushwindow_left)
hotkey.bind(winKey, "M", ext.grid.pushwindow_down)
hotkey.bind(winKey, ",", ext.grid.pushwindow_up)
hotkey.bind(winKey, ".", ext.grid.pushwindow_right)

hotkey.bind(winKey, "H", ext.grid.resizewindow_thinner)
hotkey.bind(winKey, "J", ext.grid.resizewindow_shorter)
hotkey.bind(winKey, "K", ext.grid.resizewindow_taller)
hotkey.bind(winKey, "L", ext.grid.resizewindow_wider)
