#!/bin/bash
#  
# Sets up my linux environment the way i want it
#

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

  info "🤖 Installing dotfiles"

  log "\t.bashrc"
  download ~/.bashrc https://raw.githubusercontent.com/amimof/dotfiles/master/.bashrc

  log "\t.screenrc"
  download ~/.screenrc https://raw.githubusercontent.com/amimof/dotfiles/master/.screenrc

  log "\t.vimrc"
  download ~/.vimrc https://raw.githubusercontent.com/amimof/dotfiles/master/.vimrc

  log "\t.bash_aliases"
  download ~/.bash_aliases https://raw.githubusercontent.com/amimof/dotfiles/master/.bash_aliases

  info "🤖 Creating .scripts directory"
  if [ ! -d ~/.scripts ]; then
      mkdir -p ~/.scripts
  else
      warn "\t~/.scripts directory already exists"
  fi

  info "🤖 Installing scripts"

  log "\tjava_select.sh"
  download ~/.scripts/java_select.sh https://raw.githubusercontent.com/amimof/scripts/master/java_select/java_select.sh

  log "\tse.sh"
  download ~/.scripts/se.sh https://raw.githubusercontent.com/amimof/scripts/master/se/se.sh

  log "\tscreen_ssh.sh"
  download ~/.scripts/screen_ssh.sh https://raw.githubusercontent.com/amimof/scripts/master/screen_ssh/screen_ssh.sh

  log "\tscreen_sessions.sh"
  download ~/.scripts/screen_sessions.sh https://raw.githubusercontent.com/amimof/scripts/master/screen_sessions/screen_sessions.sh

  info "🤖 Setting permissions"
  chmod +x ~/.scripts/*.sh

  info "🤖 Installing SSH config"
  if [ ! -d ~/.ssh ]; then
    mkdir ~/.ssh/
  fi
  if [ ! -f ~/.ssh/config ]; then
    download ~/.ssh/config https://raw.githubusercontent.com/amimof/configs/master/.ssh/config
    log "skip"
  else
    warn "\t~/.ssh/config already exists."
  fi
  
  info "\n💩 Done! Restart your shell session"

}

uninstall() {
  echo -e "\nRemoving dotfiles"
  echo -e " - .bashrc"
  #rm ~/.bashrc
  
  echo -e " - .screenrc"
  #rm ~/.screenrc
  
  echo -e " - .vimrc"
  #rm ~/.vimrc
  
  echo -e " - .bash_aliases"
  #rm ~/.bash_aliases

  echo -e "\nNot removing ~ /.scripts directory since it might contain non volatile content"

  echo -e "\nNot remvoing ~/.ssh/config since it might contain non volatile content"

  echo -e "\nDone installing. Restart your shell session"
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
