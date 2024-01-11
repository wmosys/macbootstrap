printf "If you have some personal installation steps, you can add them in ~/.macbootstrap/personal.sh\n"
username='mosy'

function init_git() {
    # Git config
    git config --global user.name mosy
    git config --global user.email mmosy@outlook.com

    if [[ ! -d $HOME/.ssh ]]; then
        mkdir $HOME/.ssh
    fi

    # ssh key
    if [[ ! -f $HOME/.ssh/id_rsa ]]; then
        chmod 400 $HOME/.macbootstrap/config/id_rsa
        ln -s $HOME/.macbootstrap/config/id_rsa $HOME/.ssh/
    fi

    if [[ ! -f $HOME/.ssh/id_rsa.pub ]]; then
        ln -s $HOME/.macbootstrap/config/id_rsa.pub $HOME/.ssh/
    fi

    ssh-add -K $HOME/.ssh/id_rsa

    # GPG_KEY
    GPG_KEY="$HOME/.macbootstrap/git-config/mosy.asc"
    gpg --import "$GPG_KEY"
    #shred --remove "$GPG_KEY"
    git config --global user.signingkey 368B0D29D38D4B4EEE5BF51EB2468CF4358BF1CF
    git config --global commit.gpgsign true
}


function install_personal_apps() {
    brew install nebula
    brew install telnet
    brew install 1password
    brew install istat-menus
    brew install bartender
    brew install betterzip
    brew install gpg-suite
    brew install beyond-compare
    brew install postman
    brew install pdf-expert
    brew install iina
    brew install another-redis-desktop-manager
    brew install qq
    brew install qqmusic
    brew install youdaodict
    brew install imazing
    brew install yinxiangbiji
    brew install visual-studio-code
    brew install balenaetcher
    brew install nrlquaker-winbox
}


function handle_person_profile() {
    # copy histfile
    if [[ -e ~/.histfile ]]; then
        rm ~/.histfile
    fi
    ln -s ~/.macbootstrap/profile/.histfile ~/.histfile
}

# Write script you want to use in the `if` block
if [[ "$username" == $(whoami) ]]; then
    
    
    # initialize git
    init_git

    # 一定要在 ssh 身份认证后，再安装 private 仓库
    git submodule init
    git submodule update

    # 处理个人数据
    handle_person_profile

    # install my apps
    install_personal_apps
    

    # cp ss conf
    ln -s ~/.macbootstrap/tools/netconf ~/.macbootstrap/config/shadowsocks.conf
fi
