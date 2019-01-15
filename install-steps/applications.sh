

# Install iterm2
if [[ ! -e /Applications/iTerm.app ]]; then
    brew cask install iterm2
    defaults delete com.googlecode.iterm2
    cp config/com.googlecode.iterm2.plist $HOME/Library/Preferences
    # config background image location
    command="set :New\ Bookmarks:0:Background\ Image\ Location /Users/""$(whoami)""/.macbootstrap/assets/iterm-background.jpg"
    /usr/libexec/PlistBuddy -c "$command" $HOME/Library/Preferences/com.googlecode.iterm2.plist
    defaults read -app iTerm >/dev/null
else
    echo "You have installed iTerm2"
fi

# Install oh-my-zsh
if [[ ! -e ~/.oh-my-zsh ]]; then
    curl -L https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh | sh
fi

# Powerline-font
# ---------------
git clone --depth=1 https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts

# Install SourceTree, Git Tool
if [[ ! -e /Applications/SourceTree.app ]]; then
    brew cask install sourcetree
else
    echo "You have installed SourceTree"
fi

# Install Chrome
if [[ ! -e /Applications/Google\ Chrome.app ]]; then
    brew cask install google-chrome

    # Set Chrome as default browser
    # git clone https://github.com/kerma/defaultbrowser ./tools/defaultbrowser
    # (cd ./tools/defaultbrowser && make && make install)
    # defaultbrowser chrome
else
    echo "You have installed chrome"
fi

# 扩展快速预览
# Extension for preview
brew cask install qlcolorcode qlstephen qlmarkdown quicklook-json webpquicklook provisionql quicklookapk
brew cask install --appdir='/usr/local/bin' qlimagesize qlvideo # Avoid password

# 安装 搜狗输入法
brew cask install sogouinput
sogou_base="/usr/local/Caskroom/sogouinput"
sogou_version="$sogou_base/"`ls "$sogou_base"`
sogou_app="$sogou_version/"`ls $sogou_version | grep .app | tail -n 1`
open "$sogou_app"

# Zip tool
brew cask install the-unarchiver

# Install Charles
if [[ -e /Applications/Charles.app ]]; then
    echo "You have installed Charles"
else
    if [[ ! -e $HOME/Downloads/Charles.app.zip ]]; then
        curl "http://p2w4johvr.bkt.clouddn.com/Charles.app.zip" -o ~/Downloads/Charles.app.zip
    fi

    unzip -q $HOME/Downloads/Charles.app.zip -d /Applications
    rm $HOME/Downloads/Charles.app.zip
fi


# Install Dash
# if [[ -e /Applications/Dash.app ]]; then
#     echo "You have installed Dash"
# else
#     if [[ ! -e $HOME/Downloads/Dash.app.zip ]]; then
#         curl "http://p2w4johvr.bkt.clouddn.com/Dash.app.zip" -o ~/Downloads/Dash.app.zip
#     fi
# 
#     unzip -q $HOME/Downloads/Dash.app.zip -d /Applications
#     rm $HOME/Downloads/Dash.app.zip
# fi


# Install Alfred
# if [[ -e "/Applications/Alfred 3.app" ]]; then
#     echo "You have installed Alfred"
# else
#     if [[ ! -e "$HOME/Library/Application Support/Alfred 3" ]]; then
#         mkdir -p "$HOME/Library/Application Support/Alfred 3"
#     fi
# 
#     # patch alfred
#     brew cask install alfred
#     sudo codesign -f -d -s - "/Applications/Alfred 3.app/Contents/Frameworks/Alfred Framework.framework/Versions/A/Alfred Framework"
#     cp tools/alfred.license.plist "$HOME/Library/Application Support/Alfred 3/license.plist"
# 
#     # sync configuration
#     rm -rf "$HOME/Library/Application Support/Alfred 3/Alfred.alfredpreferences"
#     curl http://p2w4johvr.bkt.clouddn.com/Alfred.alfredpreferences2.zip -o "$HOME/Downloads/Alfred.alfredpreferences.zip"
#     unzip -q "$HOME/Downloads/Alfred.alfredpreferences.zip" -d "$HOME/Library/Application Support/Alfred 3"
#     rm "$HOME/Downloads/Alfred.alfredpreferences.zip"
# fi

# Install IINA
brew cask install iina