# 工具使用

安装脚本通过 Homebrew 安装以下工具，分为命令行工具与 GUI 应用两类。命令行工具来自 `install-steps/gun_sed.sh`，通用 GUI 应用来自 `install-steps/applications.sh`，个人专属应用来自 `install-steps/personal.sh`。

## 命令行工具

来自 `install-steps/gun_sed.sh`：

- 基础：`gnu-sed`、`coreutils`、`wget`、`cmake`、`gawk`、`ssh-copy-id`
- Git 相关：`git`、`git-flow`、`git-lfs`、`mercurial`
- 搜索与文件浏览：`fzf`、`fd`、`the_silver_searcher`（命令名 `ag`）、`ranger`
- 现代命令行替代：`eza`（替代 `ls`）、`bat`（替代 `cat`）
- 开发：`python3`、`nvim`、`universal-ctags`、`cloc`、`exiftool`、`imagemagick`、`catimg`
- 语言版本管理：`jenv`（Java）、`fnm`（Node.js）、`n`
- 其他：`autojump`、`gpg`、`icdiff`、`scmpuff`、`zsh-completions`

说明：Node.js 不再直接安装，改由 `fnm` 管理；安装结束会执行 fzf 的 `--all` 绑定脚本。oh-my-zsh 也在本步安装。

## 通用 GUI 应用

来自 `install-steps/applications.sh`：

- iTerm2（安装后写入预置配置 `config/com.googlecode.iterm2.plist`）
- SourceTree
- Google Chrome
- The Unarchiver
- QuickLook 扩展：`qlcolorcode`、`qlstephen`、`qlmarkdown`、`quicklook-json`、`webpquicklook`、`provisionql`、`quicklookapk`、`qlimagesize`、`qlvideo`

## 个人应用

来自 `install-steps/personal.sh`，仅当当前用户名为 `mosy` 时安装：

- 效率与系统：`1password`、`istat-menus`、`bartender`、`betterzip`、`gpg-suite`、`beyond-compare`、`balenaetcher`、`windows-app`、`winbox`
- 开发：`visual-studio-code`、`postman`、`drawio`、`another-redis-desktop-manager`
- 办公与笔记：`pdf-expert`、`eudic`、`siyuan`、`yinxiangbiji`、`imazing`
- 媒体与通讯：`iina`、`qq`、`qqmusic`、`telegram-desktop`、`waegisub`、`cc-switch`
- 命令行与网络：`svn`、`btop`、`tree`、`nebula`、`telnet`、`syncthing`

## iTerm2

使用本脚本安装会自动套用预置配置，主要改动：

1. `Command + ←` / `Command + →`：在命令行中按单词左右移动
2. `Command + delete`：删除至行首
3. `Command + d`：垂直分屏；`Command + Shift + d`：水平分屏；`Command + [` / `Command + ]`：切换分屏

更多快捷键可打开 iTerm2 设置查看，或参考预置 plist 文件。

## fzf

fzf 是模糊搜索工具，安装后会自动执行绑定脚本完成快捷键配置，安装过程中各步骤选择确认即可。

常用功能：

1. `Ctrl-t`：触发文件名搜索，`Ctrl-j` / `Ctrl-k` 上下选择，与 Vim 键位一致
2. 编辑不记得名字的文件：`vimf`（即 `vim $(fzf)`）
3. `kill -9` 后按 `Tab`：补全进程
4. `ssh **` 后按 `Tab`：补全主机

完整快捷键说明见 [Zsh 相关](./zsh.md) 的 fzf 一节。

## QuickLook 插件

参考 [quick-look-plugins](https://github.com/sindresorhus/quick-look-plugins)。本仓库安装：

1. qlcolorcode：代码文件预览时高亮
2. qlstephen：以纯文本形式预览无扩展名或未知扩展名文件
3. qlmarkdown：预览渲染后的 Markdown 文件
4. quicklook-json：预览格式化后的 JSON 文件
5. qlimagesize：预览图片时显示尺寸
6. webpquicklook：预览 WebP 图片
7. qlvideo：预览视频文件
8. provisionql：预览 iOS 的 provision 文件
9. quicklookapk：预览安卓 APK 文件

> 历史版本曾通过七牛链接安装 Charles、Dash，以及 coderunner、JetBrains Toolbox、redis 等工具，目前已不在安装范围内。
