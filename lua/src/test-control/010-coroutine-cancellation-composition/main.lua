local a=_G._coroutines:newScope(nil)
local b=_G._coroutines:newScope(nil)
local c=_G._coroutines:newScope(nil)
local d=_G._coroutines:newScope(nil)
local e=_G._coroutines:newScope(nil)
local timer=_G._script:getThreads():getMain():getTimer()
a:withTimeout(75,function(s) return s:delay(1000) end):catchError(function(s,err)
  _G._logger:info("coroutine:lua:timeout-cancellation-preserved")
  return s:resolve("fallback")
end):onError(function(err)
  _G._logger:info("coroutine:lua:timeout-cancellation-preserved")
end):onSuccess(function(v) error("timeout unexpectedly succeeded") end)
b:withTimeoutOrNull(75,function(s) return s:delay(1000) end):onSuccess(function(v)
  if v~=nil then error("expected nil") end
  _G._logger:info("coroutine:lua:timeout-or-null-ok")
end):onComplete(function() _G._logger:info("coroutine:lua:timeout-or-null-complete") end)
local timed=0
c:loopWithTimeout(75,function(s)
  timed=timed+1
  return s:delay(1000):_then(function(inner,v) return inner:resolve(true) end)
end):onError(function(err)
  if timed~=1 then error("timed loop count") end
  _G._logger:info("coroutine:lua:loop-timeout-cancelled-wait")
end)
local count=0
d:loop(function(s)
  count=count+1
  _G._logger:info("coroutine:lua:loop-iteration:"..tostring(count))
  return s:resolve(count<3)
end):onComplete(function()
  if count~=3 then error("loop count") end
  _G._logger:info("coroutine:lua:loop-completed-count:3")
end)
e:withTimeoutOrNull(500,function(s)
  return s:delay(25):_then(function(inner,v) return inner:resolve(23) end)
end):onSuccess(function(v)
  if v==nil or tonumber(v)~=23 then error("composed value") end
  _G._logger:info("coroutine:lua:composed-wait-ok")
end):onComplete(function() _G._logger:info("coroutine:lua:composed-wait-complete") end)
timer:setTimeout(function(p)
  a:cancel("done")
  _G._logger:info("coroutine:lua:cancellation-gate")
end,3000)
