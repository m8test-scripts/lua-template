local StringBuilder = require("m8test_java.java.lang.StringBuilder")
local builder = StringBuilder:newJavaObject("M8Test")
builder:append(" Lua")
if builder:toString() ~= "M8Test Lua" then error("StringBuilder") end
local raw = _arrays:intArrayOf(3, 1, 2)
local values = _objectWrappers:wrapIntArray(raw)
if values:getSize() ~= 3 then error("wrapped size") end
values:set(0, 7)
if not values:contains(7) then error("wrapped array") end
local callbackCalled = false
_logger:withContext(function(context) callbackCalled = context ~= nil end)
if not callbackCalled then error("Kotlin function callback") end
local list = _iterables:listOf("first", "second")
if list:get(1) ~= "second" then error("host List factory") end
_logger:info("lua-template-jvm-interop:passed")
