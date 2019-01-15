source basic.sh

# Link git configuration
mv ~/.gitconfig ~/.gitconfig_backup
backup_file ~/.gitattributes
ln -s ~/.macbootstrap/git-config/.gitconfig     ~/.gitconfig
ln -s ~/.macbootstrap/git-config/.gitattributes ~/.gitattributes


# zshrc setup
backup_file ~/.zshrc
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
ln -s ~/.macbootstrap/zsh-config/.zshrc  ~/.zshrc


# vim configuration
backup_file ~/.vim
backup_file ~/.config/nvim/
git clone https://github.com/bestswifter/vim-config.git ~/.config/nvim
ln -s ~/.vim ~/.config/nvim


# 用不到
# ESLint configuration
# backup_file ~/.eslintrc.js
# backup_file ~/.eslintrc
# ln -s ~/.macbootstrap/.eslintrc.js ~/.eslintrc.js


# Ranger configuration
if [[ ! -e $HEME/.config/ranger ]]; then
    mkdir -p $HOME/.config/ranger
fi
old_commands_py=$HOME/.config/ranger/commands.py
old_rc_conf=$HOME/.config/ranger/rc.conf
backup_file "$old_commands_py"
backup_file "$old_rc_conf"
ln -s ~/.macbootstrap/config/ranger/commands.py "$old_commands_py"
ln -s ~/.macbootstrap/config/ranger/rc.conf "$old_rc_conf"