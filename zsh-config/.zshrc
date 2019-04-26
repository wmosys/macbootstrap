export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH:$M2_HOME/bin
export LANG=en_US.UTF-8
plugins=(extract encode64 urltools brew zsh-syntax-highlighting zsh-autosuggestions)
ZSH=$HOME/.oh-my-zsh

ZSH_THEME="robbyrussell"
PROMPT=$'%{$purple%}%n%{$reset_color%} in %{$limegreen%}%~%{$reset_color%}$(ruby_prompt_info " with%{$fg[red]%} " v g "%{$reset_color%}")$vcs_info_msg_0_%{$orange%}%{$reset_color%} at %{$hotpink%}%* %{$orange%}λ%{$reset_color%} '

# oh-my-zsh config
source $ZSH/oh-my-zsh.sh
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} r:|[._-]=** r:|=**'
zstyle ':completion:*:*' ignored-patterns '*ORIG_HEAD'

fpath=(/usr/local/share/zsh-completions $fpath)
compinit -u

# Hist config
HISTCONTROL=ignorespace
HISTFILE=~/.histfile
HISTSIZE=10000000
HISTFILESIZE=10000000
SAVEHIST=10000000
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=magenta'
ZSH_AUTOSUGGEST_STRATEGY="match_prev_cmd"

BS_ZSH_BASE="$HOME/.macbootstrap"
BS_ZSH_TOOLS=${BS_ZSH_BASE}/tools

# import macbootstrap shell function
source $BS_ZSH_BASE/basic.sh
source $BS_ZSH_BASE/zsh-config/common.sh
source /usr/local/etc/profile.d/autojump.sh
if brew ls --versions scmpuff > /dev/null; then
    eval "$(scmpuff init -s --aliases=false)"
fi

fpath=(/usr/local/share/zsh-completions $fpath)

# GO
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

# Java JDK
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH:.
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.

# Maven
export M2_HOME=~/Server/apache-maven-3.5.3
export PATH=$PATH:$M2_HOME/bin


# Homebrew
export PATH="/usr/local/sbin:$PATH"

# 个人暂时无使用需求
# for nvm
# Start ###################################################################
# export NVM_DIR=~/.nvm
# export EDITOR="nvim"
# #source $(brew --prefix nvm)/nvm.sh
# export NVM_SH="/usr/local/opt/nvm/nvm.sh"
# # https://github.com/creationix/nvm/issues/860
# declare -a NODE_GLOBALS=(`find $NVM_DIR/versions/node -maxdepth 3 -type l -wholename '*/bin/*' | xargs -n1 basename | sort | uniq`)
#
# NODE_GLOBALS+=("node")
# NODE_GLOBALS+=("nvm")
#
# load_nvm () {
#   [ -s "$NVM_SH" ] && . "$NVM_SH"
# }
#
# for cmd in "${NODE_GLOBALS[@]}"; do
#   eval "${cmd}(){ unset -f ${NODE_GLOBALS}; load_nvm; ${cmd} \$@ }"
# done
# End #####################################################################

# Bind key
bindkey ';' autosuggest-execute

# archey -o
autoload -U bashcompinit
bashcompinit

# Sublime Text 3
alias subl="'/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl'"
alias nano="subl"
export EDITOR="subl"


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
