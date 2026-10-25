# 01: 验收任务结果、同步配置与异步组合

Type: task
Status: ready-for-agent

**What to build:** Lua 真实脚本通过 Test Control 证明任务创建、精确结果、错误恢复和组合等待。

**Blocked by:** 00：验收原有 Thread/Timer 的真实脚本基线


## 前置公开能力

- 目标语言可用的统一基础执行与协程 API

能力未具备时不能启动交付；本项目不定义或重建这些通用契约。

## Acceptance criteria

- [ ] 用稳定 manifest 与独立脚本运行，包含同步 builder、启动选择器、launch/async、结果链、nullable 与集合。
- [ ] 覆盖 delay、超时、循环及实际公开组合方法；建立可复用的有限事件等待与失败报告方式。
- [ ] 脚本实际断言之后才输出标记，最终响应与清理均成功才通过；测试源码保持产品发布隔离。

## Comments

基础上下文与嵌套上下文用例通过真实 Test Control，包含 `getScriptMain()` 回调线程、IO 调度、delay 后闭包访问、等待期间 Timer 推进及嵌套 launch 后外层继续。其他结果组合、超时/循环和同步 builder 仍需逐项补证。

`003-thread-timer-error` 已通过 Test Control：Timer callback 抛出的预期异常使脚本以 `scriptError` 结束，且错误消息匹配。

`002-thread-timer-context` 的线程生命周期断言现也通过：worker 的 `onStart` 与 `onExit` callback 检查 `isCurrent()`、`isMain()` 和 `getName()`，并继续验证 runnable、Timer 参数、interval 两轮后取消及嵌套 context。

该用例进一步断言生命周期回调期间线程仍 `isAlive()` 且 `isInterrupted()` 为假，设备 Test Control 通过。

`003-coroutine-thread-context` 现断言 `_async` 返回值为 `7`，且 Flow `map/toList` 结果为 `[2, 4]`；LuaJ 的 Java List 使用其公开 size/get 成员读取，设备 Test Control 通过。
