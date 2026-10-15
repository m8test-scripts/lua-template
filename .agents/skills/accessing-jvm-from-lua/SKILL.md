---
name: accessing-jvm-from-lua
description: 当 Lua 脚本需要访问 JVM 类、调用 Java/Kotlin 成员或传递函数 callback 时使用。
---

# 从 Lua 访问 JVM

Lua 通过插件生成的 m8test_java require 路径访问 JVM 类；脚本中调用 Java 对象使用冒号语法，并按模板 init/access-jvm.lua 示例用 newJavaObject 构造对象。

## 类与对象

```lua
local StringBuilder = require("m8test_java.java.lang.StringBuilder")
local builder = StringBuilder:newJavaObject("M8Test")
builder:append(" Lua")
assert(builder:toString() == "M8Test Lua")
```

先确认依赖已加载到当前脚本 classloader。声明文件或代码补全存在不等于运行时类可见。方法重载、静态字段、嵌套类、异常等边界按目标语言的生成代码和实际设备行为验证。

## 函数 callback

Lua function 可作为 callback 传入函数式参数；根据 API 签名传参/返回。遵循本语言的冒号方法调用约定。

## 函数 callback 示例

Lua function 可以按目标 Kotlin 函数类型传入 callback。模板 Test Control 通过 Logger.withContext 实际验证 callback 被调用并获得参数：

```lua
local called = false
_logger:withContext(function(context) called = context ~= nil end)
assert(called)
```

## 类型转换边界

Lua table、number、nil 与 JVM 类型不是同一类型。需要 JVM 数组和集合时，使用宿主工厂并用设备端验证每个目标签名。

逐项记录已测试的 primitive/boxed、字符串、nullable、数组、集合、varargs、重载和异常行为。未经执行验证的转换写为待验证，不根据其他脚本语言推断。

## 验证

本模板的 lua-template-jvm-interop Test Control 场景会实际调用 JVM StringBuilder，并验证宿主数组工厂和 wrapper。运行当前项目支持的选中 Test Control 任务并检查 summary 中该 requestId 为 passed；若当前模板没有注册相应任务，使用模板设备运行任务并确认成功日志。Gradle 使用 -q。
