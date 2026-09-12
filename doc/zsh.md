# Zsh 相关

所有 Zsh 相关的函数、别名与配置（主要是对部分 Unix 命令的封装）都在 `zsh-config/` 目录下。

加载入口是 `zshrc`（安装时软链到 `~/.zshrc`），它先 `source` 根目录的 `basic.sh`，再 `source` `zsh-config/common.sh`。`common.sh` 作为模块聚合器，依次加载 `dirmark.sh`、`find.sh`、`git.sh`、`grep.sh`、`misc.sh`、`tools.sh`、`alias.sh`、`fzf.sh`、`server.sh`、`functions/*.sh`、`platform.mac.sh`、`colors.sh`。`personalized.sh` 的加载语句已注释，默认不启用。

## 目录书签（dirmark.sh）

把常用目录加入书签，后续用简短名字跳转或打开：

- `A`：把当前目录加入书签
- `G <name>`：跳转到书签目录
- `P <name>`：在 Finder 中打开书签目录
- `_l`：列出全部书签

书签名支持 Tab 补全。

## 文件查找（find.sh）

- `fn <regex>`：按文件名正则查找当前目录
- `fe <ext>`：按扩展名查找
- `gfe <ext>`：查找并用 gvimServer 打开

## 内容搜索

- `xgrep <ext> <pattern>`（grep.sh）：先按扩展名过滤文件再 grep
- `bsgrep <pattern>`（platform.mac.sh）：递归 grep

## 终端代理（platform.mac.sh）

封装为 `proxy` 命令，简写 `p`，通过 export 环境变量让终端命令（curl、git、npm 等）走本地代理，只影响当前 shell 会话，不影响 GUI 应用。端口在 `platform.mac.sh` 顶部的 `PROXY_HTTP_PORT` / `PROXY_SOCKS_PORT` 修改：

- `p on`：开启终端代理（设置 `http_proxy`/`https_proxy`/`all_proxy` 及大写、`no_proxy` 变量），并自动检测连通性
- `p off`：关闭终端代理（清除相关环境变量）
- `p s`：查看当前代理变量与连通性（经代理访问 `google.com/generate_204`）

## 网络与系统信息

- `ip`：当前网卡的局域网 IP
- `myip`：公网 IP（`curl -L ip.fm`）
- `cpu`：CPU 型号（`sysctl -n machdep.cpu.brand_string`）
- `wifipassword`：当前连接的 Wi-Fi 密码
- `dnsflush`：刷新 DNS 缓存（`sudo killall -HUP mDNSResponder`）
- `bsof <name|:port>`：按进程名查端口，或按端口查进程（`bsof redis`、`bsof :80`）
- `bssize <path>`：查看文件或目录大小；`bssize /` 查看磁盘占用，`bssize .` 查看当前目录及子目录

  ![](https://o8ouygf5v.qnssl.com/1506396195.png)（图片可能已失效）

## 文件与目录操作

- `realpath` / `readlink -f`：显示绝对路径（由 `coreutils` 提供）

  ```shell
  realpath clean.sh
  # /Users/<user>/.macbootstrap/clean.sh
  ```

- `resolution <img>`：显示图片分辨率，输出形如 `4096 x 2048`
- `mkcdir <name>`：创建目录并进入
- `showFiles` / `hideFiles`：显示 / 隐藏 Finder 中的隐藏文件
- `bsfilename <path>`：取不含扩展名的文件名（`bsfilename ~/x.py` → `x`）
- `bszip <path>`：压缩为同名 zip 文件
- `bsrenameextension <old> <new>`：批量修改当前目录下指定扩展名
- `app2ipa xxx.app`：把 `.app` 打包为 `.ipa`，输出 `/private/tmp/ipa/output.ipa`，可配合 `ideviceinstaller -i` 安装到设备

## 现代命令行替代

- eza（替代 `ls`）：`l`（`eza -lh`）、`la`（`eza -lAh`）、`ll`（`eza -lh`）、`ls`（`eza -G`）、`lsa`（`ls -lah`）
- bat（替代 `cat`）：`cat` 已被 alias 为 `bat`，配置文件为 `zsh-config/bat.conf`（关闭分页、plain 模式）
- `vim` 已被 alias 为 `nvim`；`vimf` 即 `vim $(fzf)`

## 编辑器与项目

- `c [target]`：用 VSCode 打开。无参数时 `code .`；参数为文件则打开文件；参数为目录则进入后 `code .`；其它情况尝试用 autojump 跳转后再打开
- `ow [dir]`：打开当前或指定目录下的 Xcode 工程，workspace 优先于 project

## 其他实用函数

- `bsfn <regex>`：按正则查找文件名（`platform.mac.sh`）
- `bswhich <name>`：查看某命令是函数还是别名，以及定义所在文件（`bswhich ip`、`bswhich gg`）
- `h [keyword]`：历史命令关键字统计排行，结果注册为 `f1`、`f2` 等编号 function，本会话内输入编号可重放对应命令
- `s <keyword>`：在 `~/dev/DailyLearning` 笔记中搜索关键字并高亮显示（路径写死在 `platform.mac.sh`，依赖该目录存在）
- `pt`：重启 polipo 并让当前会话的终端代理指向 `localhost:8123`（依赖 Homebrew 的 polipo，属旧方案，日常代理用 `p`）
- `bssclient`：后台启动 shadowsocks 本地客户端，配置为 `~/.macbootstrap/config/shadowsocks.conf`
- `urlencode` / `urldecode`：URL 编解码，结果自动写入剪贴板（`tools.sh`，实现会从远端拉取脚本，网络异常时不可用）
- `ppjson`：终端格式化 JSON（`echo '{"a":1}' | ppjson`）
- 全角句号适配（`chinese_characters_adapter.sh`）：`。` 等价于 `.`，`。。` 等价于 `..`
- `mosy_lazyload_add_command` / `mosy_lazyload_add_completion`（`functions/mosy_lazyload.sh`）：命令与补全的懒加载注册

### 行列抽取与统计（misc.sh）

这几个函数是全局别名 `R`（`| row`）与 `C`（`| column`）的底层实现：

- `row <n...>` / `nrow <n...>`：按行号抽取 / 剔除
- `column <n...>` / `ncolumn <n...>`：按列号抽取 / 剔除
- `add` / `average`：求和 / 求平均

## 终端文件管理器：Ranger

Ranger 是一个使用 Vim 键位的终端文件管理器，比 Finder 更便于与 Shell 交互。用快捷键 `r` 启动（`alias r='source ranger'`），这样 Ranger 中切换的目录会同步到外部 Shell。

基本操作：`j` / `k` 上下移动，`h` / `l` 目录后退 / 前进。常用快捷键：

1. `zh`：切换显示隐藏文件
2. `x`：删除文件（放入废纸篓而非直接 rm）
3. `yy` 复制、`dd` 剪切、`pp` 粘贴、空格多选
4. `gh`：进入用户目录
5. `yn` 复制文件名、`yd` 复制目录名、`yp` 复制完整路径
6. `:j`：autojump 跳转
7. `<C-f>`：用 fzf 搜索文件
8. `f`：当前目录内过滤文件名
9. `du`：查看各子目录大小
10. `oo`：在 Finder 中打开；`op` 或回车：系统默认程序打开；`oc`：用 VSCode 打开
11. `m` 添加书签、`um` 删除书签、`` ` `` 展示书签

## 全局别名

通过 `alias -g` 定义，可追加到任意命令后：

1. `H`：`| head -n`，如 `cat xxx H 3` 只看前 3 行
2. `T`：`| tail -n`，看后几行
3. `L`：`| less`，在 less 中查看长输出
4. `R`：`| row`，按行号抽取，如 `cat xxx R 1 3 7`
5. `C`：`| column`，按列号抽取，如 `cat xxx C -1`
6. `NE`：`2> /dev/null`，忽略报错
7. `NUL`：`> /dev/null 2>&1`，丢弃所有输出

## fzf

fzf 提供模糊搜索与补全，主要快捷键：

1. `kill` 后按 `Ctrl-t`：补全进程 PID
2. `ssh`、`export`、`unset`、`unalias` 等命令支持 fzf 补全
3. `Alt-c`：列出当前目录下的文件夹并快速进入
4. `Ctrl-g`：从 autojump 历史目录中交互选择一项并跳转（`autojump_with_fzf`）
5. `Ctrl-r`：命令历史搜索
6. `Ctrl-x Ctrl-r`：历史搜索后自动执行（`Ctrl-r` 仅粘贴不执行）

部分命令配置了独立的补全触发符（`FZF_PER_CMD_COMPLETION_TRIGGERS`），如 `vim` 用 `*`、`ssh` / `gbdr` / `make` 用空字符串触发。更多用法参考 [fzf Examples (completion)](https://github.com/junegunn/fzf/wiki/Examples-(completion))。

## 命令自动补全

- `Ctrl-e`：根据当前建议快速补全
- 历史版本中 `;` 可补全并执行，该绑定目前在 `zshrc` 中已注释，默认不生效

## SSH 配置

SSH 主机别名集中在 `zsh-config/ssh_config`，配合 `ssh-copy-id` 可免密登录。先上传公钥：

```shell
ssh-copy-id -i ~/.ssh/id_rsa.pub root@example.com -p 22
```

之后在 `ssh_config` 中维护主机别名，例如：

```
Host example
    HostName 198.51.100.10
    User root
    Port 22
    IdentityFile ~/.ssh/id_rsa
```

随后 `ssh example` 即可登录。该文件目前按用途分组维护了大量主机（My Cloud、HomeLab、Kayak 内网等），并使用 `ProxyCommand` 经跳板机访问内网主机。上面的 IP 与主机为示例，实际以 `zsh-config/ssh_config` 为准。

> 注：历史文档中以 `bwh` / `172.96.215.73` 作为示例，该主机已不在当前配置中。

## 已移除或失效的命令

以下命令在历史文档中出现过，但当前仓库已不再提供，列出以避免混淆：

- `encode64` / `decode64`：已移除（oh-my-zsh 的 `encode64` 插件也已注释）
- `x`（解压）：已无独立别名，可使用 oh-my-zsh 的 `extract` 插件
- `cal -3` / `cal -y`：macOS 自带 `cal` 不支持这些参数，需另装 `util-linux`
- `bubu`、`qn` / `qnconf`（七牛图床）、`xcodepath`：均已移除
