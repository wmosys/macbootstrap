# 系统配置优化

本节介绍 `install-steps/macos.sh` 对 macOS 默认设置所做的修改。脚本以 `sudo` 执行，写入的是系统级偏好，部分改动需要注销再登录（或重启相关进程）后才会生效。脚本末尾会自动重启 Finder、Dock、Mail、SystemUIServer。

## 键盘

### 将 F1-F12 作为标准功能键

默认情况下 F1-F12 是特殊键（调整亮度、音量等），作为功能键需配合 Fn。以下命令让 F1-F12 直接作为功能键，调节媒体功能时才需要 Fn：

```shell
defaults write -globalDomain com.apple.keyboard.fnState -int 1
```

### 开启完全键盘控制

在 macOS 弹出的对话框中，可用 `Tab` 在选项间切换、用空格确认，不必移动鼠标：

![](http://blog.bestswifter.com/1515801904.png)（图片可能已失效）

```shell
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3
```

## 触控板

### 开启三指拖动

开启后可用三指拖动非全屏窗口改变位置：

```shell
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool true
```

> 触控板「轻点点击」（Tap to Click）在历史文档中出现过，但当前 `macos.sh` 并未写入该设置，如需开启请在「系统设置 → 触控板」中手动打开。

## Dock 与菜单栏

### Dock 移至左侧并清空

当前脚本将 Dock 移到屏幕左侧，并清空其持久化应用列表（不使用自动隐藏）：

```shell
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock orientation -string left
```

> 历史文档记录过 `com.apple.dock autohide -bool true`，当前脚本未启用自动隐藏。

### 关闭菜单栏透明度

```shell
defaults write NSGlobalDomain AppleEnableMenuBarTransparency -bool false
```

### 隐藏菜单栏图标

通过覆盖预置 plist 隐藏菜单栏中的 Siri 与输入法图标：

```shell
cp config/com.apple.Siri.plist ~/Library/Preferences/
cp config/com.apple.systemuiserver.plist ~/Library/Preferences/
```

同时移除 AirPlay 的菜单栏图标：

```shell
defaults write com.apple.airplay showInMenuBarIfPresent -bool false
```

## 窗口动画

缩短窗口调整大小时的动画延迟：

```shell
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
```

## Finder 与文件

### 总是显示文件扩展名

```shell
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
```

### 显示 ~/Library 目录

```shell
chflags nohidden ~/Library
```

## 禁用镜像文件验证

打开较大的 DMG 时可跳过验证：

```shell
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true
```

## 关闭应用验证

允许安装第三方应用，并关闭首次打开的确认弹窗：

```shell
sudo spctl --master-disable
defaults write com.apple.LaunchServices LSQuarantine -bool false
```

## 截图

关闭截图的窗口阴影：

```shell
defaults write com.apple.screencapture disable-shadow -bool true
```

## 禁用文字自动替换

关闭智能引号、智能破折号与自动拼写校正，避免输入 `'`、`"`、`--` 时被自动改写：

```shell
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
```

## iOS 模拟器

允许模拟器进入全屏模式：

```shell
defaults write com.apple.iphonesimulator AllowFullscreenMode -bool YES
```

## 访客账户

禁用 macOS 访客账户，由 `install-steps/guest_account.sh disable` 完成（基于 `dscl` 与 `security`，需要 root）。该脚本也支持手动调用：

```shell
sudo ./install-steps/guest_account.sh enable    # 启用访客
sudo ./install-steps/guest_account.sh disable   # 禁用访客
```

## 未启用的配置

以下设置在 `macos.sh` 中以注释形式保留，默认不生效，可按需手动执行：

- 电池百分比：`defaults write com.apple.menuextra.battery ShowPercent -string "YES"`（Apple Silicon 上由「系统设置 → 控制中心」的开关控制）
- Finder 相关：`CreateDesktop`（桌面图标）、`QLEnableTextSelection`、`ShowExternalHardDrivesOnDesktop`、`ShowRemovableMediaOnDesktop`、`FXEnableExtensionChangeWarning`（扩展名变更警告）
