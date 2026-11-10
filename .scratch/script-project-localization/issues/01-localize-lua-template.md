# 01: 本地化 Lua 脚本模板

**What to build:** 为 Lua 模板增加英文和中文字符串目录，并让项目元数据和示例界面跟随宿主语言显示。

**Blocked by:** None

**Status:** resolved
**Type:** task

- [x] 增加英文与中文 BCP 47 字符串目录，提供项目描述和界面文案。
- [x] 入口 Lua 脚本通过 `_G._stringResources` 获取计数标签、按钮文本和语言标识。
- [x] 在按钮下方显示本地化的 `Lua` 语言名称。
- [x] 中文目录覆盖项目名称，英文目录保留 `appName` 配置回退值。
- [x] README 说明字符串目录和 Lua 全局变量 API。
- [x] 使用 `rerunLua` 在指定设备验证英文、中文 UI 和按钮交互。
