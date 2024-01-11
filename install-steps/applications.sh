# Install iterm2
if [[ ! -e /Applications/iTerm.app ]]; then
    brew install --cask iterm2
    defaults delete com.googlecode.iterm2
    cp config/com.googlecode.iterm2.plist $HOME/Library/Preferences
    # config background image location
    # command="set :New\ Bookmarks:0:Background\ Image\ Location /Users/""$(whoami)""/.macbootstrap/assets/iterm-background.jpg"
    # /usr/libexec/PlistBuddy -c "$command" $HOME/Library/Preferences/com.googlecode.iterm2.plist
    defaults read -app iTerm >/dev/null
else
    echo "You have installed iTerm2"
fi


# Install SourceTree, Git Tool
if [[ ! -e /Applications/SourceTree.app ]]; then
    brew install --cask sourcetree
else
    echo "You have installed SourceTree"
fi

# Install Chrome
if [[ ! -e /Applications/Google\ Chrome.app ]]; then
    brew install --cask google-chrome

    # Set Chrome as default browser
    # git clone https://github.com/kerma/defaultbrowser ./tools/defaultbrowser
    # (cd ./tools/defaultbrowser && make && make install)
    # defaultbrowser chrome
else
    echo "You have installed Google Chrome"
fi

# 扩展快速预览
brew install --cask qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook provisionql quicklookapk
brew install --cask --appdir='/usr/local/bin' qlimagesize qlvideo # Avoid password

# 安装 搜狗输入法
brew install --cask sogouinput
sogou_base="/usr/local/Caskroom/sogouinput"
sogou_version="$sogou_base/"`ls "$sogou_base"`
sogou_app="$sogou_version/"`ls $sogou_version | grep .app | tail -n 1`
open "$sogou_app"

# Zip tool
brew install --cask the-unarchive