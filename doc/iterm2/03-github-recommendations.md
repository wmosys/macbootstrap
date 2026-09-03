# GitHub iTerm2 配置实践调研

> 调研日期：2026-08-25

## 筛选原则

- 优先选择仍在维护、有明确 README 或官方源码依据的项目。
- 只采纳与当前问题直接相关的 Colors、Text、Profile 管理和 Claude Code tab 状态实践。
- 不把公共仓库中的完整 plist 直接覆盖本机配置；个人 dotfiles 通常包含机器名、路径、SSH 命令和本地偏好。

## 推荐参考

| 项目 | 价值 | 对当前仓库的建议 |
|---|---|---|
| [`gnachman/iTerm2`](https://github.com/gnachman/iTerm2) | 官方源码、Python API、Profile 字段和最新开发方向的唯一高可信来源 | 用于确认 `Icon`、Colors/Text 字段和版本行为；不直接拉取源码参与安装 |
| [`mbadolato/iTerm2-Color-Schemes`](https://github.com/mbadolato/iTerm2-Color-Schemes) | 维护超过 450 个 terminal theme，提供 iTerm2 可导入的颜色文件，2026-05-25 仍有自动发布 | 需要换主题时只导入单个 `.itermcolors`，不要复制完整 Profile plist |
| [`catppuccin/iterm`](https://github.com/catppuccin/iterm) | 结构简单的四套 iTerm2 颜色文件，适合测试不同深色/浅色对比度 | 作为备选预设，不覆盖当前仓库的自定义 `Default`；目前不自动导入 |
| [`romkatv/powerlevel10k`](https://github.com/romkatv/powerlevel10k) | Powerlevel10k 官方配置、Nerd Font 和 iTerm2 字体检测实践 | 当前仓库已使用 Powerlevel10k；保留现有 `FiraCodeRoman`/`HackNF`，不为追随示例盲换 Meslo |
| [`sergio-santiago/.dotfiles`](https://github.com/sergio-santiago/.dotfiles) | 展示如何把 iTerm2 plist 作为独立配置保存，并避免与其他 dotfiles 混在一起 | 作为后续同步架构参考；本次先保留现有安装流程，避免扩大范围 |

## 与当前配置的具体对应

### Colors

`mbadolato/iTerm2-Color-Schemes` 和 `catppuccin/iterm` 的共同优点是把颜色作为独立 preset 管理。iTerm2 官方 Colors 文档也将 ANSI 16 色、前景/背景、光标、选区和 tab color 作为 Profile 外观字段。

本次不引入新主题，原因是用户已有仓库级 `Default` 基线，当前问题是不同 Profile 漂移而不是缺少主题。最小修复是让所有 Profile 复用当前配置源的 `Default` 颜色值。

### Text 与 Powerlevel10k

Powerlevel10k 官方仓库偏好使用 Meslo Nerd Font，但当前仓库已经明确使用 `FiraCodeRoman-Regular` 和 `HackNF-Regular`，且 `Draw Powerline Glyphs = true`。iTerm2 官方 Text 文档说明，ligatures 会禁用 GPU renderer 并降低绘制速度；当前 `ASCII Ligatures = false` 是合理的性能选择。

因此采用以下组合：

1. 统一所有 Profile 的 `Normal Font`、`Non Ascii Font` 和 Text 行为到 live `Default`。
2. 保留 `Draw Powerline Glyphs = true`，保证现有 Powerlevel10k 分隔符。
3. 保留 `ASCII Ligatures = false`，除非用户明确需要 FiraCode 连字并接受性能代价。
4. 不从 Powerlevel10k 示例反向覆盖仓库的字体选择。

### Claude Code tab 状态

[`JasperSui/claude-code-iterm2-tab-status`](https://github.com/JasperSui/claude-code-iterm2-tab-status) 使用 Claude Code hooks 和 iTerm2 Python adapter，向 tab title、subtitle、tab color 或 badge 写入运行/空闲/需处理状态。它适合希望把多个 Claude 会话状态显式聚合到 tab bar 的用户，但会增加插件、iTerm2 Python Runtime 和 AutoLaunch adapter。

当前截图已经能由 Claude Code 原生标题更新加 iTerm2 `Icon = 1` 解释，不需要再安装插件。本次不新增插件，避免出现两个状态来源同时改写标题。

## 官方版本信号

官方 iTerm2 仓库当前已有 `3.7` beta 的 Claude Code integration、Workgroups 和新的 tab/status 方向；当前机器是 `3.6.11`。这些内容属于 beta 或上游开发状态，不作为本次稳定配置的硬依赖：

- [iTerm2 `3.7.0beta2` release notes](https://github.com/gnachman/iTerm2/blob/master/docs/notes-3.7.0beta2.txt)
- [iTerm2 pull requests](https://github.com/gnachman/iTerm2/pulls)

## 不采用项

| 方案 | 不采用原因 |
|---|---|
| 直接导入 GitHub 上任意用户的完整 `com.googlecode.iterm2.plist` | 会覆盖本机 Profile、SSH 命令、路径、Hotkey 和版本相关字段 |
| 同时安装多个颜色/状态插件 | 会让 tab title、tab color 和 badge 的所有权不清晰，出现互相覆盖 |
| 为了截图升级到 iTerm2 `3.7` beta | 截图效果主要由现有稳定版 Profile 和 Claude Code 标题序列产生，升级不是必要条件 |
| 直接切换到 Meslo Nerd Font | 会改变用户当前 Powerlevel10k 和中文字体效果；现有字体能满足需求，不属于根因 |
| 使用在线 plist 编辑器处理完整 live 配置 | 会扩大敏感连接配置的暴露面；本次使用本机 `plistlib`/`plutil` 做字段级处理 |

## 最终推荐方案

当前仓库采用“稳定 Default 基线 + Profile 用途字段保留”的策略：

- Colors/Text：字段级对齐 `Default`。
- Claude Code 图标：目标 Profile 使用 `Icon = 1`。
- Claude Code 标题：目标 Profile 允许 `Allow Title Setting`，不关闭 Claude Code 原生标题。
- 远程连接：继续保留原有命令、主机、工作目录和窗口用途。
- 主题库：只作为以后手动选择颜色 preset 的来源，不作为本次自动变更来源。
