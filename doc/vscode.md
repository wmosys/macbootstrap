# VSCode 与快捷键

> VSCode 由 `install-steps/personal.sh` 安装（仅当当前用户名为 `mosy` 时），仓库不托管其配置文件、键位与扩展列表。下文的快捷键与插件说明来自作者同步的设置，新机器需自行导入或配置，实际以本机 VSCode 为准。

## 安装与启动

- 安装：`personal.sh` 执行 `brew install visual-studio-code`
- 命令行打开：先在 VSCode 中按 `Command + Shift + P`，输入 `Shell`，选择 **Install 'code' command in PATH**，之后即可用 `code <file>` 打开文件
- 在 Zsh 中还封装了 `c` 命令：无参数执行 `code .`，参数为目录则进入后打开（见 [Zsh 相关](./zsh.md)）

## 配置同步

历史方案使用 **Settings Sync** 插件，通过 Gist 管理 配置以实现跨设备同步：

1. 安装 Settings Sync 插件
2. `Command + Shift + P` 输入 `Advanced Options`，选择 **Download Setting from Public GIST**（只读模式，无需 Token）
3. `Command + Shift + P` 选择 **Download Settings**，输入 Gist ID

> 下方 Gist ID 为原作者的示例，需替换为自己的：
>
> `e4e0667daf2dcd7f870880b7ddae5def`（示例，需替换）

> 注：新版 VSCode 已内置「Settings Sync」功能（通过 Microsoft 或 GitHub 账号登录同步），可替代上述插件方案。

## 集成终端

VSCode 集成的终端会读取 `~/.zshrc`，使用体验与 iTerm 接近。相关快捷键（来自作者同步的键位）：

1. `Command + \`：水平分割，新建终端
2. `Command + 数字`：聚焦对应终端窗口
3. `Command + w`：关闭当前终端
4. `Command + t`：新建终端
5. `Command + l`：在终端与编辑器间切换焦点
6. `` Ctrl + ` ``：隐藏 / 显示终端

## 编辑器快捷键

以下为作者同步的键位，区分默认与自定义，导入后生效：

1. `Command + B`：显示 / 隐藏侧边栏（VSCode 默认）
2. `Command + Shift + E`：侧边栏与编辑器间切换焦点
3. `Command + J`：显示 / 隐藏底部面板
4. `Shift + Option + F`：格式化文件（需对应语言插件）
5. `Command + Shift + X`：打开扩展列表
6. `Command + Shift + D`：打开调试面板
7. `Command + Shift + F`：全局搜索
8. `Command + 数字`：聚焦第 n 个编辑器标签

## 代码导航

1. `Ctrl + ]`：跳转到定义
2. `Ctrl + O`：回到上一位置
3. `Command + P`：按文件名快速打开
4. `Command + H`：显示悬停信息（Hover）

## Vim 插件（VSCode Vim）

### Vim 原生功能扩展

1. `jj` / `kk` / `hh` / `ll`：插入模式下连按两次，等价于 `Esc`
2. `Ctrl + x`：保存并关闭文件
3. Leader 键为 `;`

### EasyMotion

- `; + s`：搜索字母并跳转

### Surround

1. `ds"`：删除两侧 `"`，如 `"Hello"` → `Hello`
2. `cs"'`：把 `"` 改为 `'`，如 `"Hello"` → `'Hello'`
3. `cs"t <tag>`：把 `"` 改为 `<tag>`，如 `"Hello"` → `<tag>Hello</tag>`
4. `ysaw(`：在当前单词两侧加括号，如 `Hello` → `(Hello)`

### Commentary

1. `gc`：注释当前行
2. `gCi)`：注释括号内的所有行

## 插件

### 综合性插件

1. [Dash](https://marketplace.visualstudio.com/items?itemName=deerawan.vscode-dash)：`Ctrl + H` 在 Dash 中搜索光标下单词，`Option + H` 搜索自定义单词
2. Beautify：`Ctrl + B` 美化当前文件，适用于 JSON / HTML / CSS / JS
3. [Project Manager](https://marketplace.visualstudio.com/items?itemName=alefragnani.project-manager)：项目管理

> 注：Beautify 已长期未维护，新版 VSCode 通常改用 Prettier 做格式化。

### 前端相关

- Auto Rename Tag：修改一个标签时自动修改配对的另一个标签
