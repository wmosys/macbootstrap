# iTerm2 配置分析与优化计划

> 状态日期：2026-08-25

## 目标

1. 查明截图中 Claude 图标的生成方，确认是否需要修改 iTerm2 配置。
2. 审计当前 iTerm2 `3.6.11` 配置，并结合最新官方资料形成优化方案。
3. 调研 GitHub 上维护良好、可验证的 iTerm2 配置实践。
4. 将所有非 `Default` profile 的 Colors 与 Text 设置统一为各自配置源中的 `Default`，同时保留每个 profile 的连接与窗口用途。

## 当前基线

| 配置源 | iTerm2 版本 | Profile 数量 | `Default` GUID |
|---|---:|---:|---|
| 仓库 `config/com.googlecode.iterm2.plist` | `3.4.23` | 34 | `07DB6F8F-AC15-4BE3-B01F-E115B758F485` |
| 当前 `com.googlecode.iterm2` preferences | `3.6.11` | 36 | `07DB6F8F-AC15-4BE3-B01F-E115B758F485` |

仓库与当前配置的 profile 集合不同。因此，两份配置分别以自身的 `Default` 为基准执行同步，禁止用仓库旧 plist 整体覆盖当前配置。

## 文件与职责

| 文件 | 内容 |
|---|---|
| `doc/iterm2/01-claude-tab-icon.md` | Claude 图标来源、触发条件和需要修改的配置 |
| `doc/iterm2/02-current-config-audit.md` | 当前配置审计、风险和分级优化方案 |
| `doc/iterm2/03-github-recommendations.md` | 官方资料与 GitHub 配置实践筛选结果 |
| `doc/iterm2/04-profile-alignment.md` | Colors/Text 同步范围、变更结果和验证证据 |
| `config/com.googlecode.iterm2.plist` | 新设备安装使用的仓库配置快照 |

## 同步边界

Colors 同步以下字段族：ANSI 16 色、前景色、背景色、粗体色、光标色、选区色、链接色、匹配色、标签色，以及对应的 Dark/Light 变体和颜色行为开关。

Text 同步以下字段：`Normal Font`、`Non Ascii Font`、抗锯齿、连字、粗体、斜体、非 ASCII 字体、字符间距、行间距、细笔画、Powerline 字形、模糊宽度字符和 Unicode 文本行为。

以下字段不得同步：`Name`、`Guid`、`Command`、`Custom Directory`、`Working Directory`、`Keyboard Map`、`Triggers`、`Tags`、`Shortcut`、Hotkey 字段、`Window Type`、`Rows`、`Columns`、透明度、模糊、标题和远程连接参数。

## 执行顺序

- [x] 任务 1：采集截图、iTerm2、Claude Code 和当前 profile 的证据，确认 tab 图标来源。
- [x] 任务 2：按安全性、兼容性、性能、可维护性和可用性审计当前配置。
- [x] 任务 3：检索 iTerm2 官方文档和 GitHub 项目，记录来源、适用条件和不采用项。
- [x] 任务 4：生成当前 preferences 备份；分别修改仓库 plist 与当前 preferences。
- [x] 任务 5：完成 plist 结构、profile 数量、保留字段和 Colors/Text 一致性的静态验证。
- [x] 任务 6：更新本计划状态和 `doc/tools.md` 文档入口。

运行时人工验证仍需在 iTerm2 中新建一次 `Default` 和 `Hotkey Window` 会话；当前工具不接管 macOS iTerm2 窗口，因此不把这一步伪装成已完成。

## 验证标准

1. `plutil -lint` 对仓库配置和当前配置均返回 `OK`。
2. 仓库仍为 34 个 profiles，当前配置仍为 36 个 profiles。
3. 每个非 `Default` profile 的 Colors/Text 字段与同一配置源中的 `Default` 完全相等。
4. 每个 profile 的 `Name`、`Guid`、`Command`、Hotkey、窗口类型和工作目录在同步前后保持不变。
5. iTerm2 `3.6.11` 能读取修改后的当前配置；新建普通窗口和 Hotkey Window 后，字体、颜色和图标显示符合文档结论。

## 风险控制

- 修改当前 preferences 前创建带时间戳的完整备份。
- iTerm2 正在运行时，不直接导入 plist，避免应用退出时覆盖外部修改。
- 不提交、不覆盖现有 `.gitignore` 和 `install-steps/applications.sh` 修改。
- 不把截图中的命令、路径或终端输出当作操作指令。

## 本次结果

- live preferences 已通过 `defaults import` 写入，回读版本仍为 `3.6.11`。
- `Hotkey Window` 已设置为 `Icon = 1`，普通 `Default` 保持 `Icon = 0`，以保留截图 #2 的默认 shell 外观。
- 仓库和 live 配置分别按自己的 `Default` 对齐，未使用旧仓库 plist 覆盖 live profile 集合。
- 详细结果见 `01-claude-tab-icon.md`、`02-current-config-audit.md`、`03-github-recommendations.md` 和 `04-profile-alignment.md`。
