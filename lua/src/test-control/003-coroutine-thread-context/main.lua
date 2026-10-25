local scope = _G._coroutines:newScope(nil)
local timer = _G._script:getThreads():getMain():getTimer()
scope:launch(function(context)
  context:setName("script-main")
  context:setDispatcher(function(dispatchers) return dispatchers:getScriptMain() end)
  if context:getName() ~= "script-main" then error("coroutine context name mismatch") end
end, nil, function(s)
  if not _G._script:getThreads():getCurrent():isCurrent() then error("script-main dispatcher mismatch") end
  _G._logger:info("coroutine:lua:script-main-verified")
end)
local capturedScriptValue = "lua-captured"
local otherTaskProgress = { value = false }
timer:setTimeout(function(params)
  otherTaskProgress.value = true
  _G._logger:info("coroutine:lua:other-task-progressed")
end, 50)
scope:launch(function(context)
  context:setDispatcher(function(dispatchers) return dispatchers:getIO() end)
end, nil, function(s)
  if capturedScriptValue ~= "lua-captured" then error("captured script value mismatch") end
  _G._logger:info("coroutine:lua:io-captured-value-verified")
end)
scope:delay(200):onSuccess(function(value)
  if capturedScriptValue ~= "lua-captured" then error("delayed script value mismatch") end
  if not otherTaskProgress.value then error("other task did not progress during delay") end
  _G._logger:info("coroutine:lua:delayed-captured-value-verified")
end)
scope:launch(nil, nil, function(s) _G._logger:info("coroutine:lua:launch") end)
scope:_async(nil, nil, function(s) _G._logger:info("coroutine:lua:async"); return 7 end):onSuccess(
  function(value)
    if tonumber(value) ~= 7 then error("async value mismatch: " .. tostring(value)) end
    _G._logger:info("coroutine:lua:async-success")
  end)
scope:withContext(function(context) end, function(s) _G._logger:info("coroutine:lua:with-context"); return 9 end)
_G._coroutines:getFlows():of(1, 2):map(function(s, value)
  _G._logger:info("coroutine:lua:flow:" .. tostring(value))
  return s:resolve(value * 2)
end):toList(scope):onSuccess(function(values)
  if values.size ~= 2 or tonumber(values:get(0)) ~= 2 or tonumber(values:get(1)) ~= 4 then
    error("flow mapped values mismatch")
  end
  _G._logger:info("coroutine:lua:flow-complete")
end)
scope:delay(5000):onComplete(function() _G._logger:info("coroutine:lua:cancelled-work-complete") end)
timer:setTimeout(function(params) _G._logger:info("coroutine:lua:gate"); scope:cancel("done") end, 1500)
