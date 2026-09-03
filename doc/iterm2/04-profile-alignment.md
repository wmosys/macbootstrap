# Profile 外观同步结果

> 执行日期：2026-08-25

## 执行策略

两份 plist 分开处理，各自使用自己的 `Default Bookmark Guid` 对应 Profile 作为源：

- 仓库配置使用仓库 `Default`，不把 live `3.6.11` 的字段反向写入旧的 `3.4.23` 快照。
- live preferences 使用当前 live `Default`，不删除或新增 Profile。
- 同步范围是 Colors 与 Text 的字段族，不包含连接、命令、窗口用途和远程主机字段。
- `Hotkey Window` 单独设置 `Icon = 1`，使其能够根据 Claude Code 当前前台进程显示内置应用图标。

## 变更统计

| 配置源 | Profiles | 外观字段数 | 被修改的 profile-field 值 | 额外设置 |
|---|---:|---:|---:|---|
| 仓库 `config/com.googlecode.iterm2.plist` | 34 | 55 | 122 | `Hotkey Window.Icon = 1` |
| live preferences | 36 | 132 | 3836 | `Hotkey Window.Icon = 1` |

live 字段数更多，是因为 iTerm2 `3.6.11` 保存了 `Light/Dark` 颜色变体、颜色行为开关和新的 Text 字段；这些字段仍以 live `Default` 为准。

## 同步字段

### Colors

- `Ansi 0..15 Color` 及 `Light/Dark` 变体
- `Foreground Color`、`Background Color`、`Bold Color`
- `Cursor Color`、`Cursor Text Color`、`Cursor Guide Color`
- `Selection Color`、`Selected Text Color`、`Link Color`
- `Match Background Color`、`Tab Color`、`Underline Color`
- `Badge Color`、`Smart Cursor Color`
- `Minimum Contrast`、`Cursor Boost`、`Use Separate Colors for Light and Dark Mode`
- `Use Cursor Guide`、`Use Selected Text Color`、`Use Tab Color`、`Use Underline Color`
- `Brighten Bold Text`、`Faint Text Alpha` 等 light/dark 行为开关

### Text

- `Normal Font`、`Non Ascii Font`
- ASCII/non-ASCII 抗锯齿和 ligatures
- `Use Bold Font`、`Use Bright Bold`、`Use Italic Font`、`Use Non-ASCII Font`
- `Draw Powerline Glyphs`、`Thin Strokes`
- `Horizontal Spacing`、`Vertical Spacing`
- `Unicode Version`、`Unicode Normalization`、`Ambiguous Double Width`
- `Character Encoding`
- 光标形状、闪烁、失焦隐藏和交互移动等 Text 行为

## 明确保留

以下字段在同步前后通过 GUID 逐项比较，均未改变：

- `Name`、`Guid`
- `Command`、`Custom Command`
- `Custom Directory`、`Working Directory`
- `Keyboard Map`、`Triggers`、`Tags`、`Shortcut`
- `Window Type`、`Rows`、`Columns`
- `Transparency`、`Blur`、`Blur Radius`
- 远程连接配置和 `Hotkey Window` 的 Hotkey 字段

这意味着 `Hotkey Window` 仍保留原有浮动窗口、透明度、模糊和尺寸；远程 Profile 仍保留原有连接入口，只改变终端内容的颜色和字体表现。

## 结果验证

已完成：

1. `config/com.googlecode.iterm2.plist` 通过 `plutil -lint`。
2. live 导出结果通过 `plutil -lint`。
3. live `com.googlecode.iterm2` 仍报告 iTerm2 `3.6.11`。
4. 仓库 Profile 数量仍为 34，live Profile 数量仍为 36。
5. 两份配置中每个 Profile 的 Colors/Text 字段均与同一来源的 `Default` 相等。
6. Profile GUID、名称顺序和受保护字段保持不变。
7. live 完整备份已保存至 `/Users/mosy/Library/Preferences/com.googlecode.iterm2.plist.codex-backup-20260825.plist`。

尚未自动完成的部分：当前工具不能无损接管 macOS iTerm2 窗口并代替用户观察新建会话。因此，首次打开新的 `Hotkey Window` 后，需要人工确认：Claude Code 运行时显示 `Claude` 动态标题、内置应用图标以及原有透明/模糊窗口效果；普通 `Default` 仍保持用户截图 #2 的不透明黑色外观。

## 回滚

如需恢复本次 live 修改，先退出 iTerm2，再执行：

```sh
defaults import com.googlecode.iterm2 /Users/mosy/Library/Preferences/com.googlecode.iterm2.plist.codex-backup-20260825.plist
```

仓库 plist 的原始版本保存在本次会话的临时备份 `/private/tmp/iterm2-repo-before-change.plist`；工作区中的实际变更只涉及 `config/com.googlecode.iterm2.plist` 和本目录文档。
