# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 项目性质

macbootstrap 是一套 macOS 开发环境一键配置脚本（纯 Shell + dotfiles，无构建/测试/lint 系统）。本仓库为个人定制版（remote: wmosys/macbootstrap，fork 自 bestswifter/macbootstrap）。

- 脚本假定仓库位于 `~/.macbootstrap`，运行时通过 `$BS_ZSH_BASE` 硬编码引用该绝对路径
- `bootstrap.sh` 开头会 `rm -rf ~/.macbootstrap` 后重新 clone，勿在该目录存放未提交内容
- `bootstrap.sh` 与 `basic.sh` 的 `brew_install` 仍按 Intel 前缀 `/usr/local` 判断，Apple Silicon（`/opt/homebrew`，见 `zsh-config/zprofile`）下这些判断会失效，手动安装路径（clone + `bash install.sh`）更可靠

## 常用命令

```shell
# 完整安装（新机器上）
git clone <repo> ~/.macbootstrap && cd ~/.macbootstrap && bash install.sh

# 单独执行某个安装步骤（各步骤均有幂等检查，可重复执行）
./install-steps/gun_sed.sh

# 语法校验（无测试框架，改动后至少做 shell 语法检查）
bash -n <script.sh>
zsh -n zsh-config/*.sh

# 将当前机器的 iTerm2 实配回灌进仓库
./backup_config.sh
```

## 安装流程架构

`bootstrap.sh`（一键入口）→ clone 到 `~/.macbootstrap` → `install.sh` 按顺序调用 `install-steps/`：

1. `gun_sed.sh` — oh-my-zsh、gnu-sed、coreutils 及一批 brew CLI 工具（经 `brew_install` 幂等安装）
2. `applications.sh` — `brew install --cask` GUI 应用；iTerm2 安装后会 `defaults delete` 再灌入仓库预置的 `config/com.googlecode.iterm2.plist`
3. `configuration.sh` — 建立 dotfile 软链，clone powerlevel10k、zsh-syntax-highlighting、zsh-autosuggestions、vim-config
4. `dependencies.after.sh` — chisel 与 `~/.lldbinit`
5. `macos.sh` — **须 sudo 执行**，集中 `defaults write` 系统偏好并重启 Finder/Dock
6. `personal.sh` — 仅 `whoami == mosy` 时执行（Git 身份、SSH 私钥软链、GPG 导入、submodule update、个人应用清单）

公共函数在根目录 `basic.sh`：`brew_install`（幂等装 brew 包）、`backup_file`（原文件改为 `_backup` 后缀）、`bs_cp`。所有 install-steps 脚本第一行 `source basic.sh`。

## 软链映射（configuration.sh 建立）

- `zsh-config/zshrc` → `~/.zshrc`
- `zsh-config/p10k.zsh` → `~/.p10k.zsh`
- `zsh-config/ssh_config` → `~/.ssh/config`
- `git-config/gitconfig`、`gitattributes` → `~/.gitconfig`、`~/.gitattributes`
- `config/ranger/{commands.py,rc.conf}` → `~/.config/ranger/`
- vim：clone vim-config 到 `~/.config/nvim`，再 `ln -s ~/.vim ~/.config/nvim`
- `profile/.histfile` → `~/.histfile`（personal.sh）

注意：`zsh-config/zprofile`（静态环境变量）**没有**被任何安装脚本软链，需手动同步到 `~/.zprofile`。

## Zsh 加载链

运行时入口 `~/.zshrc`（即 `zsh-config/zshrc`）：

1. p10k instant prompt → history / oh-my-zsh（plugins 数组）初始化
2. `source basic.sh`（复用公共函数）
3. `source zsh-config/common.sh` — 模块聚合器，按固定顺序加载 dirmark、chinese_characters_adapter、find/git/grep/misc/tools/alias/fzf/server，然后 `for` 循环加载 `functions/*.sh`（新增函数文件放这里即可自动生效，无需改 common.sh），最后 platform.mac.sh、colors.sh；`personalized.sh` 的加载语句被注释，默认不启用
4. 版本管理器 `eval` 初始化：jenv / fnm / pyenv

静态环境变量（镜像源、`JAVA_HOME`、Maven/Ant、pyenv、去重的 PATH 数组）集中在 `zsh-config/zprofile`。

## 约定

- 文档与注释使用中文；`doc/` 下每个模块有对应使用文档（zsh.md、git.md、tools.md、system.md 等），改动命令行为后需同步更新
- `config/` 下的预置 plist（iTerm2、Siri 等）是机器实配快照，更新走 `backup_config.sh`，不要手改
- `install-steps/personal.sh`、`git-config/*.asc`、`config/id_rsa_*` 含个人密钥与敏感信息，勿外传
