source basic.sh

# Install oh-my-zsh
if [[ ! -e ~/.oh-my-zsh ]]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Install gnu-sed
if brew ls --versions gnu-sed > /dev/null; then
    echo "You have installed gsed"
else
    brew install gnu-sed
fi

# Install Coreutils shell tool
if [[ ! -e /usr/local/opt/coreutils ]]; then
    brew install coreutils
    mv /usr/local/opt/coreutils/libexec/gnubin/ls /usr/local/opt/coreutils/libexec/gnubin/gls
else
    echo "You have installed coreutils"
fi

# Install gnu tool
brew install --HEAD universal-ctags/universal-ctags/universal-ctags
brew reinstall universal-ctags
brew install git
brew install mercurial
brew install git-flow
brew_install git-lfs && git lfs install
brew_install python3
brew_install cmake
brew_install gawk
brew_install autojump
brew_install wget
brew_install nvm
brew_install exiv2
brew_install ssh-copy-id
brew_install imagemagick
brew_install catimg
brew_install gpg
brew_install icdiff
brew_install scmpuff
brew_install fzf
brew_install fd
brew_install the_silver_searcher
brew_install nvim
brew_install exiftool
brew_install archey
brew_install ranger
brew_install cloc
brew_install jenv
brew_install asdf
brew_install neofetch
$(brew --prefix)/opt/fzf/install --all

if [[ ! -e /usr/local/opt/asdf ]]; then
    brew_install asdf
    asdf plugin add java
    asdf plugin add nodejs
else
    echo "You have installed coreutils"
fi

