# Vim 使用简介

> 本仓库的 Vim 配置来自外部仓库 [bestswifter/vim-config](https://github.com/bestswifter/vim-config)，由 `install-steps/configuration.sh` 克隆到 `~/.config/nvim`，并将 `~/.vim` 软链到该目录。下文的插件与快捷键说明基于该仓库的历史状态编写，可能与仓库当前内容不一致，实际以打开 `nvim` 后的效果为准。

使用 macbootstrap 安装脚本时无需另行操作，`gun_sed.sh` 会安装 `nvim`，`configuration.sh` 会完成克隆与软链。手动安装则执行：

```shell
brew install neovim
git clone https://github.com/bestswifter/vim-config.git ~/.config/nvim
ln -s ~/.vim ~/.config/nvim
```

随后用 `nvim` 打开文件即可。

![](http://blog.bestswifter.com/WX20180110-204528@2x.png)（图片可能已失效）

## 基础用法

1. Leader 键为 `空格`，NerdTree 与 Denite 专用 Leader 键为 `;`
2. 替换单个字母用 `r` 加目标内容（`s` 在该配置中无效）
3. 普通模式下：`q` 关闭未修改的文件，`Ctrl-s` 保存（等价 `:w`），`Ctrl-q` 不保存强制退出，`Ctrl-x` 保存并退出
4. 插入模式下：`Ctrl-q` 强制退出，`Ctrl-x` 保存并退出

### 光标移动

1. `e` 移动到单词结尾，`w` 移动到下一个单词开头
2. `%` 跳到对应的括号（`(`、`[`、`{`）
3. `*` 跳到下一个相同单词，`#` 跳到上一个

### 搜索替换

使用 `/` 搜索，默认忽略大小写；`/pattern\C` 强制区分大小写。

替换格式为 `:范围s/old/new/模式`。若已执行过搜索，`old` 可省略，默认为上次搜索内容。

范围写法：

1. `.,10`：当前行到第 10 行（`.` 表示当前行）
2. `.,$`：当前行到文件末尾（`$` 表示末尾）
3. `%`：整个文件，即 `1,$`，如全文替换 `:%s/old/new/g`
4. `.,+2`：当前行及其后两行

模式标志：`g` 替换范围内所有匹配（不写仅替换第一个），`c` 替换前确认，`i` 忽略大小写，`I` 区分大小写。

替换光标所在单词无需重新输入：按 `<Leader + s>`，再输入新内容与模式，该替换为全局替换。

### Window 与 Buffer

Window 指编辑器内的窗口区域（如 NerdTree 文件列表），Buffer 指打开的文件。切换 Window 的常用方式：

1. `<Tab>`：在多个 Window 间循环切换
2. `-`：弹出所有 Window 的缩写，输入字母快速跳转
3. `Ctrl-h/j/k/l`：向左 / 下 / 上 / 右切换 Window

多个 Buffer 间的切换：

1. `g0` 前往第一个 Buffer，`g$` 前往最后一个
2. `<F9>` 前一个 Buffer，`<F10>` 后一个

### 大小写切换

1. `guu` 当前行全小写，`gUU` 当前行全大写
2. `~` 切换当前字符大小写，`3~` 切换后续三个字符
3. `guiw` 当前单词全小写，`gUiw` 当前单词全大写
4. `g~iw` 当前单词逐字符切换大小写

## 常见插件

以下插件说明依赖外部仓库 `vim-config` 的实际配置，仅供参考。

### easymotion

快速光标跳转插件，常用三个快捷键：

1. `;w`：以单词为单位跳转，屏内单词显示高亮缩写，输入缩写即跳转
2. `;l`：行内跳转，速度更快、更精确
3. `;s`：按单个字母搜索后跳转

### Denite

集成文件、字符串、Buffer 搜索的工具：

1. `;f`：项目内按文件名模糊搜索（类似 Xcode 的 `Command + Shift + O`）
2. `;g`：项目内字符串搜索（类似 Xcode 的 `Command + Shift + F`）
3. `;b`：在已打开的 Buffer 中搜索

搜索结果实时更新。在结果中按 `Esc` 在输入与选择模式间切换，打开方式：

1. `st`：在新 tab 打开
2. `sv`：垂直切分后打开
3. `sh`：水平切分后打开

按 `q` 退出。

### Vim-Operator-Surround

扩展文本对象（Text Object）的 surround 操作，命令均以 `s` 开头，分添加（`sa`）、删除（`sd`）、替换（`sr`）三种。

以单词 `abc` 为例，光标停在 `b` 上：

1. `saiw"`：添加双引号，得到 `"abc"`
2. `sda"`：删除两侧双引号，回到 `abc`（对比 `da"` 会连同单词一起删除）
3. `sriw'`：把双引号替换为单引号，得到 `'abc'`

高级模式下无需手动指定文本对象，插件自动选取最近的、两侧相同的字符。以 `"Hello, (world), Hello"` 为例，光标停在 `world` 上时操作作用于圆括号，否则作用于外层双引号：

1. `saa'`：得到 `"Hello, ('world'), Hello"`
2. `srr'`（光标在 `hello`）：得到 `'Hello, (world), Hello'`
3. `sdd`：得到 `"Hello, world, Hello"`

### Terminal

在 Vim 内打开终端：`t<Enter>`，会在底部打开一个 10 行高的终端窗口，iTerm 与 `~/.zshrc` 的配置均生效。该终端也是 Vim 窗口，输入模式下无法切换 Window，需先按 `Esc`。

### TagBar

依赖 ctags，本仓库通过 `universal-ctags` 提供。配置为启动时自动打开，手动打开按 `<Leader> + o`。

### NerdTree

文件树窗口，打开文件时自动展开，关闭最后一个文件时自动收起，手动切换按 `;a`。窗口内用 `hjkl` 操作，`hl` 展开 / 折叠目录。

### Commentary

选中内容后按 `<Leader> v` 切换注释；按 `v` 进入可视模式并智能扩展选区。

## 特定语言支持

该配置使用 [dein](https://github.com/Shougo/dein.vim) 管理插件，可按文件类型加载，例如：

```yaml
- { repo: vim-python/python-syntax, on_ft: python }
```

表示 `python-syntax` 仅在打开 Python 文件时加载。历史说明中提到对 HTML / CSS / JS / Python / Go 的语法支持，实际覆盖范围以仓库当前配置为准。

### Python

主要能力（依赖外部仓库的插件配置）：

1. 基于语法的补全（`deoplete-jedi`）
2. 运行当前文件，快捷键 `rr`（连按两次 `r`，避免与替换键冲突）
3. 保存文件（`Ctrl-s`）时自动语法校验
4. 文本对象扩展：`C` 表示类，`M` 表示方法 / 函数，如 `daM` 删除整个函数
