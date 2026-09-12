# 临时文件目录，供本配置中的脚本存放日志等临时文件
export BSTEMP='/private/tmp'

# 检测当前可用的网络服务名称，供 ip 等网络命令确定操作对象
# 按 CalDigit 扩展坞以太网、Ethernet、Wi-Fi 的顺序返回第一个已启用的服务
# @return 输出网络服务名称；均未启用时输出空字符串
function current_networkservice() {
    network=''
    if [ "$(networksetup -getnetworkserviceenabled CalDigit-TS3-Plus)" = 'Enabled' ]; then
       network='CalDigit-TS3-Plus'
    elif [ "$(networksetup -getnetworkserviceenabled Ethernet)" = 'Enabled' ]; then
       network='Ethernet'
    elif [ "$(networksetup -getnetworkserviceenabled Wi-Fi)" = 'Enabled' ]; then
       network='Wi-Fi'
    else
       network=''
    fi
    echo $network
}

# 输出当前网络服务的局域网 IP 地址
# @return 输出形如 192.168.1.10 的 IP 地址；网络服务不可用时输出为空
function ip() {
    network=`current_networkservice`
    networksetup -getinfo $network | grep '^IP address' | awk -F: '{print $2}' | sed 's/ //g'
}

# ============================================================
# 终端命令行代理：通过 export 环境变量生效，只影响当前 shell 会话
# curl/git/npm/pip 等命令行工具读这些变量；GUI 应用不受影响
# ============================================================

# 代理客户端监听端口，按实际客户端修改
PROXY_HTTP_PORT=17893   # HTTP/HTTPS 代理端口
PROXY_SOCKS_PORT=17893  # SOCKS5 代理端口

# 设置/关闭/查看终端代理
# @param $1 子命令：on 开启代理 | off 关闭代理 | s 查看状态与连通性
# @return 0 成功；代理不可用时在输出中提示（连接测试失败）
function proxy() {
    case "$1" in
    on)
        export http_proxy="http://127.0.0.1:${PROXY_HTTP_PORT}"
        export https_proxy="http://127.0.0.1:${PROXY_HTTP_PORT}"
        export all_proxy="socks5://127.0.0.1:${PROXY_SOCKS_PORT}"
        # 部分工具只认大写变量，两套都设上
        export HTTP_PROXY="$http_proxy" HTTPS_PROXY="$https_proxy" ALL_PROXY="$all_proxy"
        # 本地地址不走代理，避免访问本机服务被转发到代理
        export no_proxy="localhost,127.0.0.1,::1" NO_PROXY="localhost,127.0.0.1,::1"
        echo "终端代理已开启：HTTP/HTTPS -> 127.0.0.1:${PROXY_HTTP_PORT}，SOCKS5 -> 127.0.0.1:${PROXY_SOCKS_PORT}"
        proxy s
        ;;
    off)
        unset http_proxy https_proxy all_proxy HTTP_PROXY HTTPS_PROXY ALL_PROXY no_proxy NO_PROXY
        echo "终端代理已关闭"
        ;;
    s)
        if [ -z "$http_proxy" ]; then
            echo -e "终端代理: ${RED}未开启${NC}（用 p on 开启）"
            return 0
        fi
        echo -e "http_proxy  : ${green}${http_proxy}${NC}"
        echo -e "https_proxy : ${green}${https_proxy}${NC}"
        echo -e "all_proxy   : ${green}${all_proxy}${NC}"
        # 连通性测试：经代理访问返回 204 的探针地址
        local code
        code=$(curl -s -o /dev/null -w "%{http_code}" --connect-timeout 3 -m 8 https://www.google.com/generate_204)
        if [ "$code" = "204" ]; then
            echo -e "连通性      : ${green}✔ 代理可用${NC}"
        else
            echo -e "连通性      : ${RED}✘ 代理不可用（HTTP $code，请确认代理客户端已启动、端口正确）${NC}"
        fi
        ;;
    *)
        echo "Usage: p {on|off|s}"
        echo "p on : 开启终端代理（export 环境变量，只影响当前会话）"
        echo "p off: 关闭终端代理（清除环境变量）"
        echo "p s  : 查看终端代理状态与连通性"
        ;;
    esac
}

alias p=proxy

# 用 Xcode 打开当前目录或指定目录下的工程
# 优先打开 .xcworkspace，没有时打开 .xcodeproj
# @param $1 可选，工程所在目录；省略时使用当前目录
function ow() {
    if [[ -n "$@" ]]; then
        (cd "$@" && ow)
    else
        if ls *.xcworkspace 2>&1 1>/dev/null; then
            for i in *.xcworkspace;open "$i"
        elif ls *.xcodeproj 2>&1 1>/dev/null; then
            for i in *.xcodeproj;open "$i"
        else
            echo "ERROR, xcode project not exists in '$(pwd)' !"
            echo "Use this in xcode project directory or use 'ow <DIRECTORY>'"
        fi
    fi
}

# 按关键字搜索文件内容
# @param $1 要搜索的关键字
# @param $2 可选，目标文件路径；省略时在当前目录递归搜索
function bsgrep() {
    if [ $# -eq 1 ]; then
        grep -rn "$1" .
    else
        grep -n "$1" "$pwd/$2"
    fi
}

# 交互式搜索历史命令，按使用次数排序、倒序输出
# 每条结果同时注册为临时 function（f1、f2……），本会话内输入编号即可重放对应命令
# @param $1 要搜索的关键字，不区分大小写
function h(){
    # 移除 zsh 默认的数字别名（1-9），避免与生成的编号 function 冲突
    if `alias | grep -q "1="`; then
        for i in {1..9}; do
            unalias $i
        done
    fi

    history | grep --color=always -i $1 | awk '{$1="";print $0}' | grep -v '^ h' | # 查找关键字，去掉左侧的数字和 h 命令自身 \
    sort | uniq -c | sort -rn | awk '{$1="";print NR " " $0}' | # 先去重（需要排序）然后根据次数排序，再去掉次数 \
    tee ~/.macbootstrap/.histfile_color_result | gsed -r "s/\x1B\[([0-9]{1,3}((;[0-9]{1,3})*)?)?[m|K]//g" |  # 把带有颜色的结果写入临时文件，然后去除颜色 \
    awk '{$1="";print "function " NR "() {" $0 "; echo \": $(date +%s):0;"$0"\" >> ~/.histfile }"}' | # 构造 function，把 $0 写入到 histfile 中 \
    {while read line; do eval $line &>/dev/null; done}  # 调用 eval，让 function 生效
    cat ~/.macbootstrap/.histfile_color_result | sed '1!G;h;$!d' # 倒序输出，更容易看到第一条
}

# 重启 polipo 代理服务，并让当前会话的终端代理指向它（localhost:8123）
# 依赖 Homebrew 安装的 polipo 及其 LaunchAgents 配置
function pt() {
    launchctl unload ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
    launchctl load ~/Library/LaunchAgents/homebrew.mxcl.polipo.plist
    export http_proxy=http://localhost:8123
    export https_proxy=http://localhost:8123
}

# 在 ~/dev/DailyLearning 的学习笔记中搜索关键字并高亮显示
# 笔记以「### 」作为条目分隔，输出匹配关键字所在的完整条目
# @param $1 要搜索的关键字，不区分大小写
function s() {
    word=$1
    cd ~/dev/DailyLearning
    ls | xargs cat | gawk 'BEGIN{RS="### "} {if(tolower($0) ~ /'"$word"'/)print "###", $0}' | egrep --color=always -i "$word|$|^"
    cd -
}

# 查看磁盘、目录或文件的占用大小
# @param $1 目标路径：/ 显示各磁盘容量；目录显示其一级子项大小；文件显示自身大小；路径不存在时给出提示
function bssize() {
    location=$1
    if [ ${location} = "/" ]; then
        /bin/df -gH
        return
    fi

    if [ -d "${location}" ]; then
        pushd $PWD > /dev/null
        cd ${location}
        du -d 1 -h -c
        if [ ${location} != "." ]; then
            popd >/dev/null
        fi
    else
        if [ -f "${location}" ]; then
            du -h ${location}
        else
            echo "No such file or directory"
            return
        fi
    fi
}

# 创建目录（自动创建父目录）并进入
# @param $1 要创建的目录路径
mkcdir () {
    mkdir -p -- "$1" &&
    cd -P -- "$1"
}

# 用 fzf 从 autojump 的历史目录中交互选择一项并跳转
# 依赖 autojump 与 fzf
function autojump_with_fzf() {
    local dir
    dir=$(cat ~/Library/autojump/autojump.txt | sort -nr | awk '{print $2}' | fzf +s) && cd "$dir"
}

# 在当前目录递归查找文件名匹配正则的普通文件与符号链接
# @param $1 扩展正则表达式，如 '\.md$'
function bsfn () {
    # -or 同时匹配普通文件和符号链接
    find . \( -type f -or -type l \) | egrep --color=always $1
}

# 后台启动 shadowsocks 本地客户端（sslocal）
# 配置文件为 ~/.macbootstrap/config/shadowsocks.conf，输出写入 $BSTEMP/nohup.out
function bssclient () {
    nohup sslocal -q -c ~/.macbootstrap/config/shadowsocks.conf &> $BSTEMP/nohup.out&
}

# 用 VS Code 打开文件或目录
# @param $1 可选，目标路径。省略时打开当前目录；传入文件直接打开；传入目录进入后打开；两者都不是时按 autojump 规则跳转后打开
function c() {
    if [ "$#" -eq 0 ]; then
        code .
    elif [ "$#" -eq 1 ]; then
        if [ -f $1 ]; then
            code $1
        elif [ -d $1 ]; then
            (cd $1 && code .)
        else
            (j $1 && code .)
        fi
    else
        echo "Usage: c or c path"
    fi
}

# 追查命令名在 shell 中的定义来源
# 是函数则打印定义；是别名则借助交互式 zsh 的调试输出，定位其 alias 定义所在文件
# @param $1 要追查的命令名
function bswhich() {
    if `type $1 | grep -q 'is a shell function'`; then
        type $1
        which $1
    elif `type $1 | grep -q 'is an alias'`; then
        PS4='+%x:%I>' zsh -i -x -c '' |& grep '>alias ' | grep "${1}="
    fi
}

# 输出当前连接 Wi-Fi 的密码
# 先用 airport 命令获取 SSID，再从钥匙串读取对应密码
function wifipassword () {
    SSID=`/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk '/ SSID/ {print substr($0, index($0, $2))}'`
    security find-generic-password -D "AirPort network password" -a "$SSID" -gw
}

# 查看图片的分辨率
# @param $1 图片文件路径
# 依赖 exiv2，缺失时自动通过 brew_install 安装
function resolution() {
    brew_install -q exiv2
    exiv2 $1 | grep 'Image size' | column 4 5 6
}
