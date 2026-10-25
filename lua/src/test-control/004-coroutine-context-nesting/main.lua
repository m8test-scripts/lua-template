local scope = _G._coroutines:newScope(nil)
local timer = _G._script:getThreads():getMain():getTimer()
local captured = "lua-nested"
local otherTaskProgress = { value = false }
timer:setTimeout(function(params)
  otherTaskProgress.value = true
  _G._logger:info("nest:lua:other-task-progressed")
end, 50)
scope:launch(function(context) context:setDispatcher(function(dispatchers) return dispatchers:getIO() end) end, nil, function(outer)
  if captured ~= "lua-nested" then error("outer capture unavailable") end
  _G._logger:info("nest:lua:outer-started")
  scope:launch(function(context) context:setDispatcher(function(dispatchers) return dispatchers:getScriptMain() end) end, nil, function(inner)
    if captured ~= "lua-nested" then error("nested capture unavailable") end
    _G._logger:info("nest:lua:inner-callback")
  end)
  if captured ~= "lua-nested" then error("outer capture not restored") end
  _G._logger:info("nest:lua:outer-resumed")
end)
scope:delay(200):onSuccess(function(value)
  if not otherTaskProgress.value or captured ~= "lua-nested" then error("delay state mismatch") end
  _G._logger:info("nest:lua:delay-resumed")
end)
timer:setTimeout(function(params) _G._logger:info("nest:lua:gate"); scope:cancel("done") end, 1500)
