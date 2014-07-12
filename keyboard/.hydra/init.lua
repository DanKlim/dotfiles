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
hotkey.bind({"ctrl"}, "F", function()
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
      appsTable[name] = app
      app:activate()
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

hotkey.bind({"ctrl"}, "W", focusApp("Google Chrome"))
hotkey.bind({"ctrl"}, "E", focusApp("Terminal"))
hotkey.bind({"ctrl"}, "R", focusApp("MacVim"))
hotkey.bind({"ctrl"}, "S", focusApp("Finder"))
hotkey.bind({"ctrl"}, "D", focusApp("HipChat"))
hotkey.bind({"ctrl"}, "T", focusApp("µTorrent"))
hotkey.bind({"ctrl"}, "G", each({
  focusApp("Clementine"),
  focusApp("Spotify"),
}))
hotkey.bind({"ctrl"}, "6", focusApp("Mumble"))
hotkey.bind({"ctrl"}, "7", focusApp("Skype"))
hotkey.bind({"ctrl"}, "8", focusApp("Steam"))
hotkey.bind({"ctrl"}, "9", focusApp("Messages"))

-- change window size / position
require "grid"

hotkey.bind({"shift", "cmd"}, "Y", function() ext.grid.adjustwidth( -1) end)
hotkey.bind({"shift", "cmd"}, "U", function() ext.grid.adjustheight(-1) end)
hotkey.bind({"shift", "cmd"}, "I", function() ext.grid.adjustheight( 1) end)
hotkey.bind({"shift", "cmd"}, "O", function() ext.grid.adjustwidth(  1) end)

hotkey.bind({"shift", "cmd"}, "M", ext.grid.maximize_window)

hotkey.bind({"shift", "cmd"}, "N", ext.grid.pushwindow_nextscreen)

hotkey.bind({"shift", "cmd"}, "A", ext.grid.pushwindow_left)
hotkey.bind({"shift", "cmd"}, "S", ext.grid.pushwindow_down)
hotkey.bind({"shift", "cmd"}, "D", ext.grid.pushwindow_up)
hotkey.bind({"shift", "cmd"}, "F", ext.grid.pushwindow_right)

hotkey.bind({"shift", "cmd"}, "H", ext.grid.resizewindow_thinner)
hotkey.bind({"shift", "cmd"}, "J", ext.grid.resizewindow_shorter)
hotkey.bind({"shift", "cmd"}, "K", ext.grid.resizewindow_taller)
hotkey.bind({"shift", "cmd"}, "L", ext.grid.resizewindow_wider)
