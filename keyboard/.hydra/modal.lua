local modalModes = {}
function ext.modal(mod, key, name, map)
  local enabled = false
  local hotkeys = {}
  for k, fn in ipairs(map) do
    table.insert(hotkeys, hotkey.new({}, k, function()
      fn()
      disable()
    end))
  end

  local function disable(exitMsg)
    if enabled then
      enabled = false
      for _, hk in ipairs(hotkeys) do
        hk.disable()
      end
      if exitMsg then
        hydra.alert("exit " .. name)
      end
    end
  end

  local disableWithMsg = function() disable(true) end
  --local escape = hotkey.new({}, "ESCAPE", disableWithMsg)
  --table.insert(hotkeys, escape)

  hotkey.bind(mod, key, function()
    if enabled then
      disable(true)
    else
      for _, disable in ipairs(modalModes) do
        disable()
      end
      enabled = true
      hydra.alert("inserting")
      for _, hk in ipairs(hotkeys) do
        hydra.alert("Enabling")
        hk.enable()
      end
      hydra.alert(name)
    end
  end)

  table.insert(modalModes, disable)
end
