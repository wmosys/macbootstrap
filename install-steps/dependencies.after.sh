source basic.sh

##################################################
#                                                #
#                                                #
#               Install Proxifier                #
#                                                #
#                                                #
##################################################
# brew cask install proxifier
# open /Applications/Proxifier.app
# 
# defaults write com.initex.proxifier.macosx.plist LicenseOwner -string "bestswifter"
# defaults write com.initex.proxifier.macosx.plist LicenseKey -string "P427L-9Y552-5433E-8DSR3-58Z68"
# bs_cp config/bs_aotu_fq.ppx "$HOME/Library/Application Support/Proxifier/Profiles/"

# Powerline-font
# ---------------
# git clone --depth=1 https://github.com/powerline/fonts.git --depth=1
# cd fonts
# ./install.sh
# cd ..
# rm -rf fonts

# Python
# ---------------
# pip3 install --trusted-host pypi.python.org neovim jedi ipython
# pip3 install --user --upgrade --trusted-host pypi.python.org PyYAML

# Gem update
gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/
sudo gem update --system 2.7.6
# sudo gem install -n /usr/local/bin cocoapods
# sudo gem install -n /usr/local/bin cocoapods-plugins
# sudo gem install colored

# fnm & npm install
if [[ ! -e /opt/homebrew/opt/fnm ]]; then
    brew_install fnm
    fnm install 24

    npm config set registry http://mirrors.tencent.com/npm/
    npm config set strict-ssl false
    npm config delete proxy
    npm config delete https-proxy
    npm config list
else
    echo "You have installed fnm"
fi

if [[ ! -d $HOME/. ]]; then
    mkdir $HOME/.nvm
    export NVM_DIR="$HOME/.nvm"
    source $(brew --prefix nvm)/nvm.sh
    export NVM_NODEJS_ORG_MIRROR=https://npm.taobao.org/mirrors/node
    nvm install 18
    ./install-steps/node_global.sh
fi

# 
# hook login
#./install-steps/hook_login.sh

# Install Font Fira Code 
brew install --cask font-fira-code
brew install --cask font-hack-nerd-font