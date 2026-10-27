---
name: accessing-jvm-from-lua
description: 从 M8Test Lua 脚本通过模板生成的 JVM 类代理访问 Java/Kotlin 类型、callback 或宿主 wrappers 时使用。
---

# 从 Lua 访问 JVM

Lua 模板通过生成的 `m8test_java` require 路径访问 JVM 类，实例方法使用冒号调用。先确认依赖已加载到脚本 classloader。公共 wrapper 语义见 `using-host-values-and-wrappers`。

```lua
local StringBuilder = require("m8test_java.java.lang.StringBuilder")
local builder = StringBuilder:newJavaObject("M8Test")
builder:append(" Lua")
assert(builder:toString() == "M8Test Lua")

local raw = _arrays:intArrayOf(3, 1, 2)
local values = _objectWrappers:wrapIntArray(raw)
values:set(0, 7)
assert(values:getSize() == 3 and values:contains(7))
```

Lua `table`、`number`、`nil` 与 JVM 类型不同；使用公开类型化工厂满足目标签名。Lua function 可作 callback 时，按 API 确认参数、返回和生命周期。修改示例时更新 Lua JVM interop Test Control，并验证目标运行时；不能外推 Rhino 或 Java 转换结果。
