#!/bin/sh

# Intall Homebrew
# ./install_homebrew.sh

# Base Funcation
source basic.sh

# Install Python3 & Shadowsocks
# if [[ ! -e /usr/local/bin/sslocal ]]; then
#     brew install shadowsocks-libev
#     brew services start shadowsocks-libev
# else
#     echo "You have installed shadowsocks"
# fi

# Install and use shadowsocks
# if not_tt_network; then
#     nohup sslocal -c ~/.macbootstrap/tools/netconf &> /private/tmp/nohup.out&
#     #export ALL_PROXY=socks5://127.0.0.1:14179
# else
#     echo "You are in toutiao network, no need to use ss now"
# fi

# Install gun-sed
./install-steps/gun_sed.sh

# Install applications
./install-steps/applications.sh

# config step
./install-steps/configuration.sh

# Install chisel & CodeRunner
# ./install-steps/dependencies.before.sh

unset ALL_PROXY
./install-steps/dependencies.after.sh

# Mac OS 系统配置优化
printf "=== Begin === macos.sh ======================"
sudo ./install-steps/macos.sh

# 个人设置
printf "=== Begin === personal.sh ======================"
./install-steps/personal.sh

