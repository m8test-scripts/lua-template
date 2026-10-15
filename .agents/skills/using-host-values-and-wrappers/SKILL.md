---
name: using-host-values-and-wrappers
description: 当 Lua 脚本需要创建 JVM 数组、集合或使用宿主对象 wrapper 时使用。
---

# 使用宿主值与 wrapper

全局变量名称及其公开类型以本模板当前生成文件为准。构造脚本需要传给 JVM API 的数组和集合时，优先使用宿主公开的 Arrays、Iterables、Maps、Sequences 工厂；使用 ObjectWrappers 的专用 wrapper 操作支持的 JVM 对象。

## 类型化工厂和 wrapper

```lua
local raw = _arrays:intArrayOf(3, 1, 2)
local values = _objectWrappers:wrapIntArray(raw)
values:set(0, 7)
assert(values:getSize() == 3 and values:contains(7))
```

根据目标签名选择 primitive array、引用 array、List、Set、Map、Pair 或 Sequence 工厂。脚本语言原生 list/table/array 不自动等同 JVM 容器。

## Wrapper 与 origin

类型化 wrapper 只承诺其接口定义的操作；通用 wrap 不会代理任意对象的全部方法。wrapper 操作若与原始对象共享底层数据，修改会反映到该对象；转换成新数组或集合时检查具体 API 的返回值与可变性。只有下游 API 明确要求原始类型时才取 getOrigin()，因为这会让脚本依赖该 JVM 类型及其库。VariableWrappers 用于脚本变量及元信息，不替代数据对象 wrapper。

## 验证

本模板的 lua-template-jvm-interop Test Control 场景验证本语言的工厂调用语法、wrapper 操作和底层数组更新。新增用法时同步增加设备端断言并运行该场景；构建成功只证明静态编译或源码生成完成。
