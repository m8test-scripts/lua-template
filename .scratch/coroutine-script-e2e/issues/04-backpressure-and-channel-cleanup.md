# 04: 验收背压、时间操作与通道清理

Type: task
Status: ready-for-agent

**What to build:** Lua 真实脚本在可控生产消费顺序下验证背压、时间、发送关闭和回调流清理。

**Blocked by:** 02：验收取消、完成通知与续体竞争；03：验收 Flow 来源、转换与终端


## 前置公开能力

- 背压、时间及公开通道行为

能力未具备时不能启动交付；本项目不定义或重建这些通用契约。

## Acceptance criteria

- [ ] 覆盖公开 buffer/conflate/latest/时间操作，以事件与精确值断言，不依赖随机时序。
- [ ] 发送等待不阻塞推进，关闭与取消后 awaitClose 清理一次且后续无非法回调。
- [ ] 用有限超时与最终清理证据报告结果，资源清理失败不记为通过。

## Comments

暂无。
