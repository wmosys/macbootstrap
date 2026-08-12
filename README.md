# 介绍

macbootstrap 是一套面向新 Mac 的开发环境一键配置脚本，集成常用的系统配置、命令行工具、Zsh 与 Git 快捷命令，以及 Vim、VSCode 等编辑器配置。所有配置与功能均有配套文档说明，既是使用手册，也是实现参考。

第一次接触本项目，可以先阅读 [这些问题](./doc/features.md)。如果当前没有更简单的方式实现这些需求，可以考虑使用 macbootstrap。

重要文件在覆盖前会自动备份。例如原有的 `~/.zshrc` 会改名为 `~/.zshrc_backup`，被备份的还包括 `~/.gitconfig`、`~/.gitattributes`、`~/.ssh/config`、`~/.p10k.zsh`、`~/.config/nvim/` 与 ranger 配置等，统一加上 `_backup` 后缀。

环境配置是一件主观的事，不同人的审美与需求并不一致。如果不打算整体采用这套配置，也可以只浏览文档，了解其中的实现思路，把有用的函数迁移到自己的环境里。

本项目主要面向新电脑初始化。虽然做了备份保护，仍不建议直接用于生产环境，因配置丢失或错乱造成的后果需自行承担。

# 安装

执行以下命令即可完成一键安装：

```shell
curl https://raw.githubusercontent.com/wmosys/macbootstrap/master/bootstrap.sh | sh
```

安装脚本（`bootstrap.sh`）会按顺序完成：

1. 安装 Homebrew（使用中科大与清华镜像加速，静默安装）
2. 在全新电脑上安装 Xcode 命令行工具（含 gcc 等），绝大多数命令行程序依赖此项；若自动安装失败，可手动执行 `xcode-select --install`
3. 将本仓库 clone 到 `~/.macbootstrap`
4. 执行 `install.sh`，按顺序调用 `install-steps/` 下的各安装步骤脚本

如果不使用一键命令，也可以手动安装：

```shell
git clone https://github.com/wmosys/macbootstrap.git ~/.macbootstrap
cd ~/.macbootstrap
bash install.sh
```

# 安装架构

仓库结构与各目录用途如下。

## install-steps/

被 `install.sh` 顺序调用的安装步骤脚本：

- `gun_sed.sh`：安装 oh-my-zsh、gnu-sed、coreutils 及一批 brew 工具（git、git-flow、python3、fzf、fd、ag、neovim、ranger、jenv、fnm、eza、bat 等）
- `applications.sh`：通过 `brew install --cask` 安装 GUI 应用（iTerm2、SourceTree、Google Chrome、QuickLook 扩展、The Unarchiver 等）
- `configuration.sh`：建立 dotfile 软链（`~/.zshrc`、`~/.gitconfig`、`~/.ssh/config`、`~/.p10k.zsh`、`~/.config/nvim`、ranger 配置等），并克隆 powerlevel10k、zsh-syntax-highlighting、zsh-autosuggestions、vim-config
- `dependencies.after.sh`：安装 chisel 用于 LLDB 调试，写入 `~/.lldbinit`
- `macos.sh`：以 `sudo` 执行，集中写入 macOS 系统偏好（Dock、功能键、访客账户、截图、拼写校正等），随后重启 Finder、Dock 等进程
- `personal.sh`：个人定制，仅当当前用户为 `mosy` 时执行（Git 身份、SSH 私钥、GPG 签名、个人应用清单等）

## 其他目录

- `zsh-config/`：Zsh 配置与功能模块，入口与加载链见下文 [Zsh](#zsh) 一节
- `git-config/`：gitconfig、gitattributes 与 GPG 密钥
- `config/`：应用预置 plist（iTerm2 等）、ranger 配置、shadowsocks 配置、`.lldbinit`
- `ssh/`：SSH 相关辅助脚本
- `tools/`：iTerm2 zmodem 脚本、Alfred 配置、json_pretty 等小工具
- `profile/`：shell 历史文件 `.histfile`
- `software/`：预留的软件包目录
- `doc/`：各模块使用文档

## 根目录脚本

- `bootstrap.sh`：一键安装入口
- `install.sh`：安装流程编排，顺序调用 `install-steps/` 各脚本
- `basic.sh`：提供 `brew_install`、`backup_file`、`bs_cp` 等公共函数
- `backup_config.sh`、`clean.sh`、`install_homebrew.sh`、`onlogin.sh`：备份、清理、Homebrew 安装、登录钩子等辅助脚本

# 能力概览

这套脚本主要覆盖以下配置：

- macOS 系统偏好的基础调整
- 常用 Homebrew 工具与 GUI 应用
- 基于 Zsh 的效率命令，以及 Git 快捷命令
- Vim 与 VSCode 配置
- 语言版本管理器：pyenv（Python）、fnm（Node.js）、jenv（Java）、Maven，相关初始化已写入 `zsh-config/zprofile` 与 `zshrc`

各模块的详细用法见下文文档导航。

# 文档导航

- 常见问题与功能一览：[features.md](./doc/features.md)
- 系统配置优化：[system.md](./doc/system.md)
- Homebrew 工具：[tools.md](./doc/tools.md)
- Zsh 相关：[zsh.md](./doc/zsh.md)
- Git 使用指南：[git.md](./doc/git.md)
- Vim 使用指南：[vim.md](./doc/vim.md)
- VSCode 使用指南：[vscode.md](./doc/vscode.md)

# Zsh

Zsh 相关的函数与配置（主要是对部分 Unix 命令的封装）都在 `zsh-config/` 目录下。

入口文件是 `zshrc`，安装时软链到 `~/.zshrc`。其加载链为：

1. `zshrc` 先 `source` 根目录的 `basic.sh`，获得公共函数
2. 再 `source` `zsh-config/common.sh`
3. `common.sh` 作为模块聚合器，依次加载 `alias.sh`、`git.sh`、`grep.sh`、`fzf.sh`、`tools.sh`、`functions/` 等功能模块

因此整体入口是 `zshrc`，`common.sh` 是 `zsh-config/` 目录下的模块加载器。

`personalized.sh` 的加载语句在 `common.sh` 中目前处于注释状态，默认不加载，可按需启用。

详细文档参考 [Zsh 相关](./doc/zsh.md)。

# Homebrew 排错

如果安装时出现「The formula built, but is not symlinked into /usr/local」并导致 link 失败，按 CPU 架构处理：

- Intel（Homebrew 前缀 `/usr/local`）：

  ```shell
  sudo chown -R $(whoami) /usr/local
  ```

- Apple Silicon（Homebrew 前缀 `/opt/homebrew`）：通常无需 chown，确认 `/opt/homebrew/bin` 已加入 `PATH` 即可。

具体包含的工具与用法参考 [Homebrew 工具](./doc/tools.md)。

# 讨论

如对项目有建议或反馈，可发送邮件到 [bestswifter@gmail.com](mailto:bestswifter@gmail.com)。
