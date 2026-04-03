# 禁用访客账户
sudo bash install-steps/guest_account.sh disable

# 使用 F1-F12 作为标准功能键
defaults write -globalDomain com.apple.keyboard.fnState -int 1

# 开启完全键盘控制
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# 隐藏部分应用图标于 Dock，并将 Dock 布局设置为左侧
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock orientation -string left

# 显示电池电量百分比
# defaults write com.apple.menuextra.battery ShowPercent -string "YES"

# 关闭菜单栏透明效果
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false

# Optimize window resize speed
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001

# Finder 中总是显示文件名的后缀
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# 禁用镜像文件验证
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true

# Config Finder
# defaults write com.apple.finder CreateDesktop true;
# defaults write com.apple.finder QLEnableTextSelection -boolean true;
# defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -boolean false;
# defaults write com.apple.finder ShowRemovableMediaOnDesktop -boolean false;
# defaults write com.apple.finder FXEnableExtensionChangeWarning -boolean false;

# Enable three finger to drag
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true

# Show the ~/Library Directory
chflags nohidden ~/Library

# Hide Siri Icon in menu bar
cp config/com.apple.Siri.plist ~/Library/Preferences/

# Hide input source Icon in menu bar
cp config/com.apple.systemuiserver.plist ~/Library/Preferences/

# Remove airplay icon in menubar
defaults write com.apple.airplay showInMenuBarIfPresent -bool false

# Disable smart quotes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false

# Disable smart dashes as they’re annoying when typing code
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

# Disable app verifying
sudo spctl --master-disable
defaults write com.apple.LaunchServices LSQuarantine -bool false

# 关闭自动校正
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false 
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false

# 允许模拟器全屏模式
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES

# 使配置生效
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES
echo "Restart Finder Dock Mail SystemUIServer"
for app in Finder Dock Mail SystemUIServer; do killall "$app" >/dev/null 2>&1; done

# 关闭截图阴影 true-关闭 false-开启
defaults write com.apple.screencapture disable-shadow -bool true && killall SystemUIServer
