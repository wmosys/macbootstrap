# 当前 iTerm2 配置审计

> 审计日期：2026-08-25

## 基线差异

| 来源 | iTerm2 版本 | Profiles | `Default Bookmark Guid` |
|---|---:|---:|---|
| 仓库 `config/com.googlecode.iterm2.plist` | `3.4.23` | 34 | `07DB6F8F-AC15-4BE3-B01F-E115B758F485` |
| 当前 live preferences | `3.6.11` | 36 | `07DB6F8F-AC15-4BE3-B01F-E115B758F485` |

两份配置的 Profile 集合不同。当前 live 多出或改名了部分 `Kayak-*`、`Mosy - PVE-*` Profile，仓库仍包含旧的 `Mosy - TXCloud LFZ`、`Mosy - PVE-Docker` 等条目。因此不能用仓库 plist 整体导入 live preferences；后续按 GUID 和字段族增量同步。

## 影响视觉结果的字段

### Default

当前 live `Default` 的关键值：

| 字段 | 当前值 | 影响 |
|---|---|---|
| `Normal Font` | `FiraCodeRoman-Regular 13` | ASCII 字符大小 |
| `Non Ascii Font` | `HackNF-Regular 13` | 中文、Unicode 和 Nerd Font 字符大小 |
| `Transparency` | `0` | 黑色不透明背景，接近截图 #2 |
| `Blur` | `false` | 不模糊桌面背景 |
| `Columns` / `Rows` | `300` / `80` | 新建普通窗口尺寸 |
| `Draw Powerline Glyphs` | `true` | Powerlevel10k 分隔符和图标的对齐方式 |
| `Unicode Version` | `9` | Emoji 和部分 Unicode 宽度表 |
| `Icon` | `0` | 不显示前台应用图标 |
| `Allow Title Setting` | `false` | 应用不能通过控制序列更新标题 |
| `Allow Title Reporting` | `true` | 允许标题报告相关行为 |

仓库 `Default` 使用 `FiraCodeRoman-Regular 14` 和 `HackNF-Regular 14`，这是当前配置与仓库快照的第一处明显漂移。

### 其他 Profiles

当前 live 中观察到：

- `Normal Font` 有 `13` 和 `14` 两种字号。
- `Non Ascii Font` 混用了 `HackNF-Regular 13`、`HackNF-Regular 14`、`HackNerdFontComplete-Regular 14`、`Menlo-Regular 11` 和 `FiraCodeRoman-Regular 14`。
- 大多数远程 Profile 使用 `Window Type = 15`、`180 x 60`，这是与普通 `Default` 不同的窗口用途设置。
- `Hotkey Window` 使用 `Window Type = 2`、`203 x 35`、透明度约 `0.0964`、模糊半径 `25`，这些字段用于浮动 Hotkey Window，不能当作普通 Profile 的主题差异直接覆盖。
- live 中多组 Profile 保存了独立的 `Ansi 0..15 Color`、前景色、背景色、光标色和 `Light/Dark` 颜色字段；这些值和 `Default` 不一致，正是不同 Profile 显示效果不一致的主要来源。
- `Draw Powerline Glyphs` 在 Profile 之间有 `true/false` 分叉；关闭它会改变 Powerlevel10k 分隔符的对齐效果。

## 官方文档对应的审计结论

| 领域 | 官方行为 | 对本仓库的处理 |
|---|---|---|
| Colors | 可分别设置 light/dark 颜色；ANSI 颜色、前景、背景、光标、选区和 tab color 都属于 Profile 外观 | 与 live `Default` 的颜色字段及开关统一 |
| Text | `Normal Font` 负责 ASCII，`Non-ASCII Font` 负责非 ASCII 字符；FiraCode 等字体可启用 ligatures | 与 live `Default` 的字体、抗锯齿、ligatures、Powerline 和 Unicode 行为统一 |
| Window | Transparency、Blur、Rows/Columns、Style 是窗口行为；Blur 只有在有透明度时才有视觉效果 | 保留 `Hotkey Window` 和远程 Profile 的窗口用途；不把 `Default` 的普通窗口尺寸强行复制过去 |
| General / Icon | `Built-in Icon for Current App` 基于前台应用显示图标 | 单独按图标策略处理，不把它混入 Colors/Text 同步 |
| General / Title | OSC 0/1 可更新 Session Name，前提是 Profile 允许应用修改标题 | 需要动态 Claude Code tab 标题的 Profile 单独开启 `Allow Title Setting` |
| Automatic Profile Switching | 依赖 Shell Integration，并可按主机、用户、路径和前台命令切换 Profile；iTerm2 `3.6` 按完整命令行匹配 job 规则 | 暂不新增规则；先避免已有远程 Profile 被同步破坏 |

参考：

- [iTerm2 Colors 文档](https://iterm2.com/documentation-preferences-profiles-colors.html)
- [iTerm2 Text 文档](https://iterm2.com/documentation-preferences-profiles-text.html)
- [iTerm2 Window 文档](https://iterm2.com/documentation-preferences-profiles-window.html)
- [iTerm2 General 文档](https://iterm2.com/documentation-preferences-profiles-general.html)
- [iTerm2 Session Title 文档](https://iterm2.com/documentation-session-title.html)
- [iTerm2 Automatic Profile Switching 文档](https://iterm2.com/documentation-automatic-profile-switching.html)

## 风险分级

| 等级 | 问题 | 处理 |
|---|---|---|
| P0 | live 与仓库 Profile 集合不一致，整体导入会删除或回滚连接入口 | 禁止整体覆盖；按当前 live 导出结果修改 |
| P1 | Colors、Text、Powerline 和 Unicode 设置分叉 | 以各自配置源的 `Default` 为源，只同步外观字段 |
| P1 | `Default` 当前 `Allow Title Setting = false`，不利于复现 Claude Code 动态标题 | 先记录；在目标 Profile 上按运行验证结果开启 |
| P1 | 部分 Profile 使用 `Menlo` 或不同 Nerd Font | 统一到 live `Default` 的 `FiraCodeRoman-Regular 13` / `HackNF-Regular 13` |
| P2 | `Hotkey Window` 的透明度、模糊、窗口尺寸与截图 #1 可能不同 | 保留其功能字段，后续按运行截图单独微调 |
| P2 | iTerm2 `3.7` beta 已有新的 Claude Code integration，但当前仍是 `3.6.11` | 不为了截图盲目升级；只采纳当前稳定版可验证的设置 |

## 审计后的最小变更集

1. 仓库 plist：保留 34 个 Profile，只同步每个 Profile 的 Colors/Text 外观字段。
2. live preferences：保留 36 个 Profile，只同步每个 Profile 的 Colors/Text 外观字段。
3. 对 `Default` 和明确用于 Claude Code 的 Profile 单独设置 `Icon = 1`；不设置固定 `Icon = 2`。
4. 不改 `Name`、`Guid`、`Command`、SSH 参数、工作目录、Hotkey、`Window Type`、窗口尺寸和远程连接字段。
5. 写入 live preferences 前保存完整 plist 备份，并在 iTerm2 重新读取后做最小运行验证。
