# Git 的常用封装

macbootstrap 在 `zsh-config/git.sh` 与 `git-config/gitconfig` 中封装了大量 Git 快捷命令。下面按使用场景分组介绍当前生效的别名与函数。

> 说明：历史版本中存在过 `gcn`、`gvc`、`ggs`、`gst`(stash)、`gpo`、`gt`、`grt` 等别名，目前均已移除或改写，请以本文为准。

## 帮助信息

- `gh COMMAND`：在终端打开某条命令的 man 帮助，等价于 `git help --man`，例如 `gh commit`。

## 用户信息与签名

用户信息与 GPG 签名由 `install-steps/personal.sh` 的 `init_git()` 自动配置（仅当当前用户为 `mosy` 时执行），通常无需手动设置：

- `user.name` 为 `mosy`，`user.email` 为 `mmosy@outlook.com`
- 导入 GPG 密钥并开启 `commit.gpgsign`
- `user.signingkey` 在 `personal.sh` 运行后会被设为 `368B0D29D38D4B4EEE5BF51EB2468CF4358BF1CF`

如需手动配置 GPG 签名，参考步骤如下：

1. `brew install gpg` 安装依赖（使用本脚本则已安装）
2. `gpg --full-generate-key` 生成密钥；个人使用可选择永不过期（时长填 0）
3. `gpg --list-keys` 查看密钥 ID
4. `gpg --armor --export <ID>` 导出公钥，粘贴到 [GitHub GPG Keys](https://github.com/settings/keys)
5. `git config --global user.signingkey <ID>` 指定签名密钥
6. `git config --global commit.gpgsign true` 默认开启签名
7. 若签名失败，将 `export GPG_TTY=$(tty)` 加入 shell 配置（本仓库已在 `zshrc` 中设置）

## 查看状态与历史

- `gs`：查看工作区状态。若安装了 `scmpuff` 则使用其增强输出，否则回退到 `git status`。
- `gss`：`git status --short`，简洁模式。
- `gg`：`git lg`，单行图形化提交历史（带分支关系）。完整格式定义在 `gitconfig` 的 `lg` 别名中。

  ![](http://images.bestswifter.com/QQ20171220-114944@2x.png)（图片可能已失效）

- `glp`：`git log -p`，展示每次提交的具体改动。
- 由于 `gg` 等价于 `git lg`，可在其后追加参数：`gg --stat`（改动文件）、`gg -p`（具体改动）、`gg --all`（所有分支）、`gg -2`（最近两条）、`gg HEAD~3..HEAD`（区间，左开右闭）。
- 按提交内容搜索用 `gg -G <pattern>`（支持正则）；按提交信息搜索用 `gg --grep <pattern>`。
- `ggrep`：`git grep --break --heading -n`，在 Git 仓库内替代 `grep`，速度更快且可限定搜索范围。同一文件的匹配会归并在一个文件名下，可读性更好。

  以查找 `gignore` 的定义位置为例：![](https://diycode.b0.upaiyun.com/photo/2017/dd45040c35ab5011400c7172fbf1ff9b.png)（图片可能已失效）

## 分支

- `gb`：`git branch`，列出本地分支。
- `gcb <name>`：`git checkout -b`，新建分支并切换。
- `gco <branch>`：`git checkout`，切换分支。有未提交改动时请谨慎切换。
- `gbdr`：删除远程分支（`git push origin :<branch>`），支持 fzf 补全远程分支名。

> 历史版本的 `gbv`、`gba`、`gbr`、`gbd`、`gbD`、`gbm`、`gbnm`、`gct`、`gtrack` 等别名已移除，对应功能请直接使用原生 Git 命令。

## 暂存与提交

- `ga`：`git add`；`gau`：`git add -u`；`gai`：`git add -i`（交互式）。
- `gan`：仅添加新增（未跟踪）文件。
- `gap`：`git add -p`，交互式按块暂存。

  ![](https://diycode.b0.upaiyun.com/photo/2017/ebd89558e4d3a39558eb3b13a39579b4.png)（图片可能已失效）

  交互模式下的动作：`y` 暂存本块、`n` 跳过、`a` 暂存整个文件、`d` 跳过整个文件、`s` 切分更小块、`e` 手工编辑区块、`/` 正则搜索。其中 `e` 可用来只提交某几行：删去不想暂存的部分即可。

- `gc`：`git commit`；`gcm <msg>`：`git commit -m`。
- `gom`：`git checkout` 所有已修改文件（丢弃工作区改动，慎用）。

## 差异

- `gd`：`git diff`，工作区改动。
- `gds`：`git diff --staged`，已暂存改动。
- `gdc`：`git diff HEAD~ HEAD`，最近一次提交的改动。
- `gdcr [sha] [file]`：生成某次提交的反向 diff，便于构造逆提交。例如 `gdcr <sha> <file> | git apply` 可精确回退单个文件。
- `gdt`：以 `icdiff` 作为外部 diff 工具查看改动（依赖 `icdiff`）。
- `gdr`：递归查看当前仓库及所有子模块的 diff。
- `gsr`：递归查看当前仓库及所有子模块的状态。

## 拉取与推送

- `gf`：`git fetch`；`gfr`：`git fetch; git rebase`。
- `gpush`：`git push origin HEAD:dev`。在 macOS 上，`platform.mac.sh` 会将其覆盖为 Gerrit 风格的 `git push origin HEAD:refs/for/<branch>`。

> 旧的 `gpo`、`gp` 别名已移除。

## 合并、变基与重置

- `gm`：`git merge`。
- `gr`：`git rebase`；`gri`：交互式变基 `git rebase -i`；`gro`：`git rebase -i --onto`。
- `gra` / `grc`：变基的 `--abort` / `--continue`。
- `grh`：`git reset --hard`；`grs`：`git reset --soft`。

## Cherry-pick 与 SVN

- `gcp`：`git cherry-pick`；`gcpc` / `gcpa`：`--continue` / `--abort`。
- `git_cherry_pick_with_user [commit]...`：保留原提交者的 author、email、date 进行 cherry-pick，支持 `-n` / `--no-date` 不保留日期。
- SVN 别名：`svnu` = `svn update`、`svnc` = `svn cleanup`。
- SVN 转 Git 辅助函数：`git_svn_clone_from_branch_base`、`git_svn_clone_from_last_10/20/50/100`，按指定 revision 起点执行 `git svn clone`。
- `git_merge_svn_from_to`、`git_get_svn_revision`：SVN 分支合并与 revision 查询。

## 子模块

- `cdsubmodule`：跳转到当前仓库第一个子模块目录。
- `gsfgcdev` / `gsfgcsit`：所有子模块批量切换到 `develop` / `sit` 分支。
- `gsfp`：所有子模块执行 `git pull`。
- `up`：递归所有子 Git 仓库执行 `git fetch`（含 svn-remote 的 `git svn fetch`）。

## 忽略文件

- `gignore`：`git update-index --assume-unchanged`，临时忽略已跟踪文件的改动（不修改 `.gitignore`）。
- `whyignore`：`git check-ignore -v`，查看某文件被哪条规则忽略。
- `reignore`：`git rm -r --cached . && git add .`，重新应用忽略规则。

## 其他

- `gnext` / `gprevious`：在 master 提交序列中切到下一个 / 上一个提交（`gprevious` 即 `git checkout HEAD^1`）。
- `editConfilicts`：用 gvim 打开所有冲突文件。
- `deleteNewFiles`：删除所有未跟踪文件（不可恢复，慎用）。
- `kgitx`：结束已有 GitX 进程后重新打开。

## 常见工作流

- `gsfrs`：`git stash; git fetch; git rebase; git stash pop`，暂存改动后拉取并变基，再恢复暂存。**注意**：若变基过程中遇到冲突，不会自动 pop 暂存，需要手动处理。
