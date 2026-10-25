local timer = _G._script:getThreads():getMain():getTimer()
local timeoutArgs = false
local immediateDone = false
local worker = false
timer:setImmediate(function(params) immediateDone = true; _G._logger:info("thread-context:lua:immediate") end)
timer:setTimeout(function(params)
  if params[1] ~= "payload" or params[2] ~= nil then error("timeout arguments mismatch") end
  timeoutArgs = true
  _G._logger:info("thread-context:lua:timeout")
end, 100, "payload", nil)
local cancelledTimeout = timer:setTimeout(function(params) error("cleared timeout ran") end, 1000)
timer:clearTimeout(cancelledTimeout)
local cancelledImmediate = timer:setImmediate(function(params) error("cleared immediate ran") end)
timer:clearImmediate(cancelledImmediate)
local count = 0
local intervalId = 0
intervalId = timer:setInterval(function(params)
  if #params ~= 1 or params[1] ~= "tick" then error("interval arguments mismatch") end
  count = count + 1
  if count == 2 then
    timer:clearInterval(intervalId)
    _G._logger:info("thread-context:lua:interval")
  end
end, 75, "tick")
_G._script:getThreads():onStart(function(thread)
  if not thread:isCurrent() or thread:isMain() or not thread:isAlive() or thread:isInterrupted() or tostring(thread:getName()) ~= "thread-context-worker" then
    error("thread start context mismatch")
  end
  _G._logger:info("thread-context:lua:thread-start")
end)
_G._script:getThreads():onExit(function(thread)
  if not thread:isCurrent() or thread:isMain() or not thread:isAlive() or thread:isInterrupted() or tostring(thread:getName()) ~= "thread-context-worker" then
    error("thread exit context mismatch")
  end
  _G._logger:info("thread-context:lua:thread-exit")
end)
_G._script:getThreads():start("thread-context-worker", function(thread) worker = true; _G._logger:info("thread-context:lua:thread") end)
timer:setTimeout(function(params)
  if not timeoutArgs or not immediateDone or not worker or count ~= 2 then error("timer callback state mismatch") end
  _G._logger:info("thread-context:lua:verified")
end, 500)
