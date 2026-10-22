# [M8Test](https://dev-docs.m8test.com) Lua Gradle 模板

> 如有疑问，请加入我们的官方 QQ 群：[749248182](https://qm.qq.com/q/jVVADJCAI8) 或 QQ
> 频道：[m8testofficial](https://pd.qq.com/s/8pidhywcy)

---

## 📦 Gradle 任务说明

### 任务分组

1. **`m8test-build`**  
   M8Test构建相关任务组，包含`buildLua`（构建Lua项目）、`runLua`（运行项目）等任务。

2. **`m8test-code-completion`**  
   M8Test代码补全相关任务组，包含`generateLuaAllCodeCompletionFiles` （生成所有需要的代码补全文件）,
   `generateLuaGlobalVariables`（生成全局变量代码补全文件）等任务。

3. **`m8test-developmenet-environment`**  
   M8Test开发环境相关任务组，包含`installDevelopmentEnvironment`（安装开发环境）、`installLuaPlugin`（安装语言插件）等任务。

4. **`m8test-download`**  
   M8Test资源下载相关任务组，包含`downloadLuaCodeTemplate`（下载示例代码模板）、`downloadLuaDocs`（下载文档）等任务。

> 实际开发中主要关注构建任务和代码补全任务即可。

### 常用任务

| 任务名称                                                 | 任务分组                     | 功能描述                                                                                     |
|------------------------------------------------------|--------------------------|------------------------------------------------------------------------------------------|
| `generateLuaAllCodeCompletionFiles`                  | `m8test-code-completion` | 生成所有Lua代码补全文件，会执行所有的 `generateLuaCodeXXXCodeCompletionFiles` 任务, 编写脚本之前执行一次此任务即可有代码提示功能。 |
| `generateLuaGlobalVariables`                         | `m8test-code-completion` | 生成Lua全局变量代码补全文件，提供IDE代码提示功能。需连接安卓设备，建议编写代码前执行一次，依赖更新后需重新执行。                              |
| `generateLuaNormalAndroidCodeCompletionFiles`        | `m8test-code-completion` | 生成 Android API 的 Lua 代码提示文件。成功后，Lua 代码中将有 Android API 的代码提示。                             |
| `generateLuaNormalDevelopmentKitCodeCompletionFiles` | `m8test-code-completion` | 生成 M8Test API 的 Lua 代码提示文件。成功后，Lua 代码中将有 M8Test API 的代码提示。                               |
| `generateLuaComponentXXXCodeCompletionFiles`         | `m8test-code-completion` | 生成 XXX 组件 API 的 Lua 代码提示文件。成功后，Lua 代码中将有 XXX 组件 API 的代码提示。                               |
| `buildLua`                                           | `m8test-build`           | 构建M8Test Lua脚本项目源码（不执行），构建结果位于`build/project`目录。                                         |
| `runLua`                                             | `m8test-build`           | 构建并将项目推送到已连接的安卓设备上运行。                                                                    |
| `buildLuaApk`                                        | `m8test-build`           | 将M8Test Lua脚本项目打包成APK文件。                                                                 |

---

## 🚀 执行任务的方法

### 方法一：使用快捷搜索

1. 双击 `Ctrl` 键，打开搜索框。
2. 输入 `gradle 任务名`，例如 `gradle runLua`，然后按回车执行。

   ![方法一示例](images/1.png)

### 方法二：通过 Gradle 面板

1. 点击 Gradle 图标。
2. 依次展开 `lua` > `Tasks` > `m8test`。
3. 双击需要执行的任务。

   ![方法二示例](images/2.png)

### 方法三：使用终端命令

1. 按下快捷键 `Alt + F12` 打开终端。
2. 输入命令 `./gradlew 任务名`，例如 `./gradlew runLua`，然后按回车执行。

   ![方法三示例](images/3.png)

---

## ⚙️ 配置脚本项目

脚本项目的配置位于 `lua/build.gradle.kts` 文件中。您可以根据需要修改设备的 IP、ADB 端口等参数。该文件中包含详细的代码注释，供参考。

---

## 🛠️ 项目开发流程

1. **生成代码提示文件**  
   执行 `generateLuaAllCodeCompletionFiles` 任务，生成 Lua 代码补全文件，提供代码提示功能。

2. **连接日志服务**

   按下快捷键 `Alt + T`，依次选择 `M8Test` > `连接日志服务`。

3. **编写并运行脚本**

   编写代码并保存后，执行 `runLua` 任务，即可在安卓设备上运行脚本项目。确保安卓设备已开启 ADB 调试。运行日志可在
   M8Test 日志面板中查看。

   `runLua` 会先生成并推送 `build/project`（BuildProjectSource），等待 BuildScript 完成后，再启动独立的 LuaKotlin ProjectScript。模板使用标准 Lua Extension ID `com.m8test.extension.language.lua` 和 capability ID `com.m8test.capability.language.lua`；实际运行 artifact 来自 `luakt` 模块。

4. **BuildProjectSource 与 ProjectScript**

   Lua 的 `settings.lua`、`init.build.lua` 和 `build.lua` 属于 BuildScript 阶段。BuildScript 成功后生成最终 SPA，再由独立 ProjectScript 执行 `init`、入口和 side。每次 `rerunLua` 都会创建新的 Lua Globals、Java bridge、require 环境和 Script 生命周期。

5. **打包Apk**
   所有的脚本开发工作都完整后, 如果你需要打包成独立的apk可以执行 `buildLuaApk` 任务。

## APK 启动策略

应用身份在 `projectConfig` 中设置：`name` 是显示名称，`packageName` 是唯一包名，`versionName` 与 `versionCode` 控制版本，`logo` 指向 `res` 下的图标。构建生成的脚本配置会将这些值应用到 APK。`appName`、`appVersionName` 和 `appVersionCode` Gradle 属性可覆盖名称和版本。默认安装后自动运行脚本。需要由用户点击运行时，在语言配置块中选择手动启动：

```kotlin
m8testLua {
    apkBuild {
        launchMode = "manual"
    }
}
```

`launchMode` 只接受 `"automatic"` 或 `"manual"`。手动模式显示启动页，由用户决定何时运行。
## 发布签名

APK 默认使用开发签名。发布时在 `m8testLua { apkBuild { ... } }` 中设置 `signingMode = "release"`、密钥库路径和别名，并通过 `providers.environmentVariable("M8TEST_RELEASE_STORE_PASSWORD")` 与 `providers.environmentVariable("M8TEST_RELEASE_KEY_PASSWORD")` 提供密码。发布 APK 在本机签名并验证，输出到 `build/apk/`。密钥库和密码不会进入生成源码或设备项目；缺少发布签名配置时构建会失败。请把密钥库保存在受控位置并排除在版本控制之外，JDK `keytool` 可用于生成、导入和导出密钥材料。
