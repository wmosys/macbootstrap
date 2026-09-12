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

第二种写法稍微高级些，它和第一种写法一致并且可以切换分支，之前的 tips 中介绍过 `gcb` 后面加单个参数的含义和用法，这里第二个参数表示跟着远程分支。

第三中方法最简单，因为它参数少，而且功能和第二种写法一样，我给他起的别名叫 `gct`，对应 `git checkout --track`

如果想为当前分支设置跟踪的远程分支，输入 `gtrack` 即可，不需要携带参数，它会自动让当前分支跟踪远程的同名分支

## git diff

1. 输入 `gd` 即可查看工作区内的变动，等价于命令 `git diff`
2. 输入 `gds` 可以查看暂存区的变动，也就是查看那些被 `git add` 了的文件的变动，等价于命令 `git diff --staged`
3. 输入 `gdc` 可以查看最近一次提交的变动，等价于命令 `git diff HEAD^ HEAD`
4. 输入 `gdcr` 可以倒过来查看某次提交的变动，它的第一个参数是提交的 SHA-1 值，如果不写则是 HEAD，所以 `gdcr` 和 `gdc` 是恰好相反的 diff。这样的好处是如果
   想撤销某次提交，只要用 `gdcr sha-1` 就可以获得那次提交的逆提交，如果想要精确到只恢复某个文件，第二个参数可以是文件名。比如 `gdcr sha-1 file_name | git apply`
5. 输入 `gdt` 即可用外部 diff 工具查看 diff，它是 `git difftool --no-prompt --extcmd "icdiff --line-numbers --no-bold" "$@" | less` 命令的缩写，这个命令依赖 `icdiff` 这个工具，可以用 homebrew 安装。
6. 输入 `gdts` 和 `gdtc` 可以对应的用外部 diff 查看已暂存和上次提交的变动，这些和 `gds` 与 `gdc` 命令基本上是一样的，区别在于使用外部 diff 工具，会更美观一些（当然速度也会更慢），效果如图所示
   ![](http://images.bestswifter.com/MacHi-2018-01-02-19-48-29.png)

## git push

1. 输入 `gpo` 可以快速的将提交推送到远程仓库，等价于命令 `git push origin`，如果不写分支名则默认把当前分支推送到远程仓库对应的分支上
2. 如果远程仓库的名称不是默认的 origin，可以使用 `gp repo_name`，因为 `gp` 等价于 `git push`

## git commit

1. 输入 `gcam` 可以在不 add 的前提下一次性提交所有改动，等价于命令 `git commit -a -m`

输入命令 `git add -p` 就可以交互式的暂存文件，我给这个命令起了别名：`gap`。这个命令后面如果不加参数，会试着暂存所有文件，也可以加上文件名，只 add 某个文件。

![](https://diycode.b0.upaiyun.com/photo/2017/ebd89558e4d3a39558eb3b13a39579b4.png)

注意左下角的蓝色文字，这里提供了很多动作命令，解释如下：

1. y: 暂存这个区块
2. n: 不暂存这个区块
3. a: 暂存整个文件
4. d: 不暂存整个文件
5. g: 跳到某个区块，注意不是所有情况下都有这个选项
6. j: 跳到下一个还未决定的区块
7. k: 跳到上一个还未决定的区块
8. s: 把这个区块切分为更小的几个区块
9. e: 编辑区块
10. /: 正则搜索某个区块

前面几个操作都很好理解，重点介绍一下 8 和 9 这两个操作。不是所有的区块都能被切分，根据我的观察如果有几行有改动，然后相邻且没有缩进的另外几行也有改动，这种情况下才能切分。

有时候一个常见的需求是只提交某几行，在我的印象中 SourceTree 需要手动选择连续的行，而 Tower 干脆就不支持，这时候需要用到命令 `e`，我们编辑改动的部分，把不想暂存的部分删掉就可以了。

## git remote

1. 输入 `grsh` 可以查看所有的远程仓库，输入 `grsh origin` 可以查看 origin 仓库中的分支、track 信息，等价于命令 `git remote show`
2. 输入 `grv` 可以查看远程仓库的地址，等价于命令 `git remote -v`

## git stash

1. 输入命令 `gst` 可以储藏所有未提交的改动，包括已暂存的改动和未跟踪的文件，它是命令 `git stash -u` 的缩写
2. 输入命令 `gsp` 可以恢复最近的一次暂存，它会完整恢复状态，也就是说如果储藏时这个文件已暂存，恢复后也是暂存的，它是 `git stash pop --index` 命令的缩写

## git grep

这个命令和 grep 的区别在于运行更快，而且可以指定搜索范围（比如是否搜索未跟踪文件，搜索某个特定的 tag 等），如果当前目录是 git 目录，可以用 `ggrep` 来替代 `grep`

`ggrep` 是 `git grep --break --heading -n` 命令的缩写，第一个参数表示不同文件的搜索结果间用空格分割，便于阅读。第二个参数非常有用，它不再在每一行输出前面加上文件名，而是在所有属于同一个文件的匹配之前加上一次文件名，
这样输出结果的可读性更高，`-n` 表示输出行号。

以查找 `gignore` 这个命令的历史为例，先输入 `ggrep gignore`，得到如图所示的结果，这告诉我们它定义在 `zsh-config/git.sh` 这个文件的第 25 行：

![](https://diycode.b0.upaiyun.com/photo/2017/dd45040c35ab5011400c7172fbf1ff9b.png)

然后输入 `ggp -L 25,25:./zsh-config/git.sh`，参数 `—L` 表示行内查找，即查找这个文件的第 25-25 行的提交记录，得到的结果如图所示：

![](https://diycode.b0.upaiyun.com/photo/2017/a872cea9a13ce464e848cec8c0db3196.png)

提交的 SHA-1 值、日期、提交者等信息就完全显示出来了

## git tag

1. 输入命令 `gt` 可以打标签，等价于命令 `git tag`
2. 输入命令 `gtd` 可以删除**本地标签**，等价于命令 `git tag -d`

## 常见工作流

注意，这里说的工作流不是 git-workflow 的意思，而是一些常见命令的组合。

1. 输入 `gsfrs` 可以先暂存(stash) 当前改动，拉取远程代码，rebase 以后再应用暂存，等价于命令 `git stash;git fetch;git rebase;git stash pop;`。**警告 ⚠️** 如果 rebase 的过程中遇到冲突，不会自动 pop 暂存，需要手动执行命令

## 其他

这里整理了一些暂时无法分类的命令：

1. `grt` 可以跳转到本地 git 目录的根路径，等价于 `cd $(git rev-parse --show-toplevel || echo ".")`
2. `grm` 表示默认的 `git reset`，因为 `gr` 被更常用的 rebase 命令占用了
3. `gref` 是命令 `git reflog` 的缩写，用来查看 HEAD 分支的变动历史
