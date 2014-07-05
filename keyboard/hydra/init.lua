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
  settings.set('lastcheckedupdates', os.time())
end

-- check for updates every week
timer.new(timer.weeks(1), checkforupdates):start()

-- launch Hydra at login
autolaunch.set(true)

-- reload config automatically
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

-- specific app switching
local appsTable = {}
local function focusApp(name)
  return function()
    local myapp = appsTable[name]
    if myapp == nil then
      local apps = application.runningapplications()
      for _, app in ipairs(apps) do
        if app:title() == name then
          appsTable[name] = app
          myapp = app
          break
        end
      end
    end
    if myapp then
      myapp:activate()
    end
  end
end

hotkey.bind({"ctrl"}, "W", focusApp("Google Chrome"))
hotkey.bind({"ctrl"}, "E", focusApp("Terminal"))
hotkey.bind({"ctrl"}, "R", focusApp("MacVim"))
hotkey.bind({"ctrl"}, "S", focusApp("Finder"))
hotkey.bind({"ctrl"}, "D", focusApp("HipChat"))
hotkey.bind({"ctrl"}, "T", focusApp("µTorrent"))
hotkey.bind({"ctrl"}, "G", focusApp("Clementine"))
hotkey.bind({"ctrl"}, "6", focusApp("Mumble"))
hotkey.bind({"ctrl"}, "7", focusApp("Skype"))
hotkey.bind({"ctrl"}, "8", focusApp("Steam"))
hotkey.bind({"ctrl"}, "E", focusApp("Messages"))
