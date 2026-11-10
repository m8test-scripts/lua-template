# Lua 模板脚本项目 i18n

Status: resolved
Triage: ready-for-agent

## Problem Statement

Lua 模板的入口 UI 使用固定中文文案，也没有标出当前界面来自 Lua 模板。项目缺少英文与中文字符串目录示例，复制模板的开发者无法直接使用宿主 locale 驱动的脚本本地化。

## Solution

为 Lua 模板添加英文和中文 BCP 47 字符串目录；入口 Compose UI 使用宿主的字符串资源 API 本地化计数文本、按钮和按钮下方的语言标识。目录同时提供本地化项目描述，中文目录覆盖项目名称。README 说明资源目录、Lua 全局变量和 locale 行为。

## Implementation Decisions

- 本次范围只包括 Lua 模板仓库；宿主的 locale 匹配与 fallback 逻辑不变。
- Lua 语言注册 `_` 作为全局变量前缀，脚本通过 `_G._stringResources` 读取静态字符串。
- 字符串目录位于 `lua/res/strings/`，文件名使用 `en.json` 和 `zh.json`。
- 英文 catalog 提供默认描述与 UI 文案，但不覆盖项目名称；中文 catalog 提供本地化项目名称、描述和 UI 文案。
- Lua 专名保持 `Lua`；用户可见语言说明作为完整静态字符串放入 catalog。
- 在 192.168.31.207 上用 `rerunLua` 验证英文和中文界面，并检查按钮下方的语言标识及点击计数。
- 不运行静态检查。

## Out of Scope

- 修改宿主、Gradle 插件、Lua Extension 或其他模板仓库。
- 新增 locale 选择、格式化 API、插值机制或额外语言目录。
