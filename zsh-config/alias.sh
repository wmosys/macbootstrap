# git
# alias gbd='git branch -d'
# alias gpo='git push origin'
# alias gcn='git config user.name'
# alias gcng='git config --global user.name'
# alias gce='git config user.email'
# alias gceg='git config --global user.email'
# alias grsh='git remote show'
# alias ggs='gg --stat'
# alias ggp='gg -p'
# alias gbv='gb -vv'
# alias gbD='git branch -D'
# alias gbm='git branch --merged'
# alias gbnm='git branch --no-merged'
# alias gvc='git verify-commit'
# alias gct='git checkout --track'
# alias gtrack='git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`'
# alias gst='git stash -u'
# alias gga='gg --all'
# alias gdtc='gdt head~..head'
# alias gdts='gdt --staged'
# alias set-upstream='git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`'
# alias gref='git reflog'
# alias grm='git reset'
# alias grv='git remote -v'
# alias gca='git commit --amend'
# alias gcam='git commit --all -m'
# alias gbr='git branch --remote'
# alias gba='git branch -a'
# alias gt='git tag'
# alias gtd='git tag -d'
# alias glfi='git ls-files --exclude-standard --ignored --other'
alias gsfgcd="git submodule foreach 'git checkout develop'"
alias gsfp="git submodule foreach 'git pull'"

# SVN
alias svnu='svn update'
alias svnc='svn cleanup'

# zsh
alias cpu='sysctl -n machdep.cpu.brand_string'
alias showFiles='defaults write com.apple.finder AppleShowAllFiles -bool true && killall Finder'
alias hideFiles='defaults write com.apple.finder AppleShowAllFiles -bool false && killall Finder'
alias ppjson='python $BS_ZSH_TOOLS/json_pretty.py'
alias pi='pod install'
alias pu='pod update'
alias vim='nvim'
alias vimf='vim $(fzf)'
alias ns='npm start'
alias nb='npm run build'
alias r='source ranger'
alias -g H='| head -n'
alias -g T='| tail -n'
alias -g L="| less"
alias -g R='| row'
alias -g C='| column'
alias -g NE="2> /dev/null"
alias -g NUL="> /dev/null 2>&1"

# alias
alias l='ls -lhG'
alias ll='ls -lhG'
alias o='open'
alias oo='open .'
alias src='source ~/.zshrc'
alias rezsh='exec zsh'

# Tools
alias myip="curl -L ip.fm"
alias dnsflush="sudo killall -HUP mDNSResponder"

# zerotier
alias zerotier-unload="sudo launchctl unload /Library/LaunchDaemons/com.zerotier.one.plist"
alias zerotier-load="sudo launchctl load /Library/LaunchDaemons/com.zerotier.one.plist"

# Nebula
alias nebula-start="sudo brew services start nebula"
alias nebula-stop="sudo brew services stop nebula"
alias nebula-restart="sudo brew services restart nebula"