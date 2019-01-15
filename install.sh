#!/bin/sh

# Intall Homebrew
if [[ ! -e /usr/local/bin/brew ]]; then
    # chcange source && avoid prompt && quiet install
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install | sed 's/https:\/\/github.com\/Homebrew\/brew/git:\/\/mirrors.ustc.edu.cn\/brew.git/g' | sed 's/https:\/\/github.com\/Homebrew\/homebrew-core/git:\/\/mirrors.ustc.edu.cn\/homebrew-core.git/g' | sed 's/\"fetch\"/\"fetch\", \"-q\"/g')" < /dev/null > /dev/null

    # Change source
    cd "$(brew --repo)"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git

    cd "$(brew --repo)/Library/Taps/homebrew/homebrew-core"
    git remote set-url origin https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git

    export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
else
    echo "You have installed brew"
fi

# 基础函数
source basic.sh

# Mac OS 系统配置优化
sudo ./install-steps/macos.sh

# Install Python3 & Shadowsocks
brew install python3
pip3 install shadowsocks

# Install and use shadowsocks
if not_tt_network; then
    nohup sslocal -q -c ~/.macbootstrap/tools/netconf &> /private/tmp/nohup.out&
    export ALL_PROXY=socks5://127.0.0.1:14179
else
    echo "You are in toutiao network, no need to use ss now"
fi

# Install gun-sed
./install-steps/gun_sed.sh

# Install applications
./install-steps/applications.sh

# config step
./install-steps/configuration.sh


# Install chisel & CodeRunner
# ./install-steps/dependencies.before.sh

unset ALL_PROXY
# ./install-steps/dependencies.after.sh


# 同步搜狗拼音设置
#./install-steps/sogou_sync.sh


# 终端会话配置
backup_file ~/.ssh/config
if [[ ! -e ~/.ssh ]]; then
    mkdir ~/.ssh
fi
ln -s ~/.macbootstrap/zsh-config/ssh_config ~/.ssh/config


# 个人设置
#./install-steps/personal.sh
./personal.sh

