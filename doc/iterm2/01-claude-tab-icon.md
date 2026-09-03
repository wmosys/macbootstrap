# Claude Code Tab 图标与标题来源分析

> 分析日期：2026-08-25

## 结论

截图 #1 是 iTerm2 中运行 Claude Code 的终端会话，但视觉效果由两个独立机制叠加产生：

| 现象 | 实际来源 | 是否由 Colors/Text 控制 |
|---|---|---|
| 标签左侧的橙色应用图标 | iTerm2 Profile 的 `Icon` 选项 | 否 |
| `Claude Co...`、`working` 和忙碌状态符号 | Claude Code 通过终端标题序列更新标签标题 | 否 |
| 半透明、模糊、无传统标题栏窗口 | iTerm2 Profile 的 Window 设置 | 否 |
| 普通 shell 中的路径、Git 分支和状态段 | zsh 的 Powerlevel10k 配置 | 否 |

所以，用户的 iTerm2 与截图 #1 的差异不是单一主题差异，而是 iTerm2 Profile、Claude Code TUI 和 zsh prompt 三层配置不同。

## `Icon` 数值证据

官方 iTerm2 源码定义如下：

```text
iTermProfileIconNone = 0
iTermProfileIconAutomatic = 1
iTermProfileIconCustom = 2
```

对应关系：

| `Icon` | iTerm2 界面选项 | 行为 |
|---:|---|---|
| `0` | `No Icon` | 不显示 Profile 图标 |
| `1` | `Built-in Icon for Current App` | 根据当前前台进程显示内置应用图标 |
| `2` | `Custom` | 显示 `Custom Icon Path` 指向的固定图标 |

当前 iTerm2 `3.6.11` 的大多数 Profile 明确设置了 `Icon = 0`，而仓库配置也主要是 `Icon = 0`。因此，若要复现截图中“运行 Claude Code 时显示应用图标”的行为，应对目标 Profile 设置 `Icon = 1`，不能设置固定的 `Icon = 2`。

官方 Profile General 文档说明，`Built-in Icon for Current App` 会按前台应用选择图标，并显示在 tab bar 和窗口标题栏中：

- [iTerm2 Profile General](https://stage.iterm2.com/documentation-preferences-profiles-general.html)
- [iTerm2 官方源码：`iTermProfileIcon`](https://github.com/gnachman/iTerm2/blob/master/sources/Settings/Profiles/ITAddressBookMgr.h)
- [iTerm2 官方源码：tab graphic 渲染](https://github.com/gnachman/iTerm2/blob/master/sources/PTYSession/PTYSession.m)

## Claude Code 标题证据

截图中的 `✳`、`◐`/`◑` 类状态符号、`Claude Co...` 以及 `working` 状态，属于 Claude Code 写入终端标题后的结果。Claude Code 的公开问题记录了它在工作期间周期性写入 OSC 0 标题序列，空闲和忙碌状态使用不同符号；这解释了为什么标签文字会随任务状态变化：

- [Claude Code issue #88360：terminal title updates](https://github.com/anthropics/claude-code/issues/88360)

如果只修改 iTerm2 的 Colors 或 Text，不会生成这些标题和状态。若不希望 Claude Code 修改 tab title，可使用其环境变量 `CLAUDE_CODE_DISABLE_TERMINAL_TITLE=1`；本次目标是理解并复现截图，因此不关闭它。

## 与仓库配置的对应关系

仓库 `zsh-config/p10k.zsh` 只负责普通 shell 的 Powerlevel10k prompt，例如目录、Git 分支、状态和时间。它不会产生 Claude Code 的 TUI，也不会决定 iTerm2 的应用图标。

当前配置中：

- `Default` profile 的 `Icon = 0`，因此默认 shell 不显示前台应用图标。
- 本次已将 `Hotkey Window` 的 `Icon` 明确设置为 `1`，避免依赖缺省值；它仍保留截图 #1 所需的专用浮动窗口用途。
- 当前 live `Hotkey Window` 的 `Allow Title Setting = true`，已允许 Claude Code 通过控制序列更新标题；live `Default` 才是 `false`，因此普通默认 shell 与截图 #1 的动态标题行为不同。

## 本次配置策略

1. `Colors` 和 `Text` 按各自配置源的 `Default` 统一，解决截图 #1 与本机字体、颜色不一致的问题。
2. 保留远程 Profile 的 `Name`、`Guid`、SSH/命令、工作目录、Hotkey、窗口尺寸和透明度等用途字段，避免破坏现有连接入口。
3. 对需要显示前台应用图标的目标 Profile 使用 `Icon = 1`；本次目标是 `Hotkey Window`，普通 `Default` 继续为 `Icon = 0`，不把它误写成固定 Claude 图标。
4. 若所有 Profile 都设置为 `Icon = 1`，SSH、编辑器和其他前台程序也会显示各自图标；这属于 iTerm2 的预期行为。本次只对 `Hotkey Window` 开启，以保留普通 `Default` 的截图 #2 外观。

## 验证边界

- 静态验证：检查 `Icon` 枚举、plist 类型和值、Profile 数量和关键字段保留情况。
- 运行验证：重新打开 iTerm2 后，新建 `Default` 与 `Hotkey Window` 会话，确认 Claude Code 运行时显示动态标题和当前应用图标。
- 当前无法仅凭 plist 静态导出确认截图中的完整窗口圆角、背景模糊和标签布局；这些属于 iTerm2 Window/Appearance 设置，需要运行时观察。
