#!/bin/bash
#  
# Sets up my linux environment the way i want it
#

BRANCH=master
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

warn() {
  echo -e "${YELLOW}${1}${NC}"
}

info() {
  echo -e "${GREEN}${1}${NC}"
}

log() {
  echo -e "${1}"
}

download() {
  curl -LSso "${1}" "${2}"
}

install() {

  info "\n🤖 Installing oh-my-zsh"
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

  info "\n🤖 Downloading dotfiles"
  log "\t.zshrc"
  download ~/.zshrc https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.zshrc

  log "\taliases.zsh"
  download ~/.oh-my-zsh/custom/aliases.zsh https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.oh-my-zsh/custom/aliases.zsh

  log "\texports.zsh"
  download ~/.oh-my-zsh/custom/exports.zsh https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.oh-my-zsh/custom/exports.zsh

  log "\ttmux-ssh-title.plugin.zsh"
  mkdir -p ~/.oh-my-zsh/custom/plugins/tmux-ssh-title
  download ~/.oh-my-zsh/custom/plugins/tmux-ssh-title/tmux-ssh-title.plugin.zsh https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.oh-my-zsh/custom/plugins/tmux-ssh-title/tmux-ssh-title.plugin.zsh

  log "\tholiday.zsh-theme"
  download ~/.oh-my-zsh/custom/themes/holiday.zsh-theme https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.oh-my-zsh/custom/themes/holiday.zsh-theme

  log "\t.vimrc"
  download ~/.vimrc https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.vimrc

  log "\t.tmux.conf"
  download ~/.tmux.conf https://raw.githubusercontent.com/amimof/dotfiles/$BRANCH/.tmux.conf
  
  info "\n🤖 Installing scripts"
  mkdir -p ~/.scripts
  
  log "\tjonmosco/kube-tmux"
  git clone https://github.com/jonmosco/kube-tmux.git ~/.scripts/kube-tmux/

  info "\n💩 Done! Restart your shell session\n"

}

uninstall() {
  info "\n💀 Removing dotfiles"
  
  log "\t.zshrc"
  rm -rf ~/.zshrc
  
  log "\taliases.zsh"
  rm -rf ~/.oh-my-zsh/custom/aliases.zsh

  log "\texports.zsh"
  rm -rf ~/.oh-my-zsh/custom/exports.zsh
  
  log "\t.vimrc"
  rm -rf ~/.vimrc
  
  log "\t.tmux.conf"
  rm -rf ~/.tmux.conf

  log "\ttmux-ssh-title.plugin.zsh"
  rm -rf ~/.oh-my-zsh/custom/plugins/tmux-ssh-title/

  log "\tholiday.zsh-theme"
  rm -rf ~/.oh-my-zsh/custom/themes/holiday.zsh-theme

  info "\nNot removing oh-my-zsh. You can do it yourself by running uninstall_oh_my_zsh"
  info  "\n💩 Done! Restart your shell session\n"
}

# if [ $# -lt 1 ]; then
#   echo "Usage: $0 [install|uninstall]"
# fi

case "$1" in
  'install') 
    install
    ;;
  'uninstall')
    uninstall
    ;;
  *) 
    install
    exit 1
esac
