#!/bin/bash
#  
# Sets up my linux environment the way i want it
#

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
CMDS=("tmux" "kubectl" "kubectx" "vim" "curl")

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

# Check if commands are installed
for i in ${CMDS[@]}; do
  command -v $i >/dev/null && continue || { warn "🤯 $i doesn't seem to be installed. You should probably install it."; continue; }
done

install() {

  info "🤖 Installing dotfiles"

  log "\t.bashrc"
  download ~/.bashrc https://raw.githubusercontent.com/amimof/dotfiles/master/.bashrc

  log "\t.bash_aliases"
  download ~/.bash_aliases https://raw.githubusercontent.com/amimof/dotfiles/master/.bash_aliases

  log "\t.bash_exports"
  download ~/.bash_exports https://raw.githubusercontent.com/amimof/dotfiles/master/.bash_exports

  log "\t.vimrc"
  download ~/.vimrc https://raw.githubusercontent.com/amimof/dotfiles/master/.vimrc

  log "\t.tmux.conf"
  download ~/.tmux.conf https://raw.githubusercontent.com/amimof/dotfiles/master/.tmux.conf
  
  info "🤖 Installing scripts"
  mkdir -p ~/.scripts
  
  log "\tjonmosco/kube-tmux"
  git clone https://github.com/jonmosco/kube-tmux.git ~/.scripts/kube-tmux/

  info "\n💩 Done! Restart your shell session\n"

}

uninstall() {
  info "💀 Removing dotfiles"
  
  log "\t.bashrc"
  rm -rf ~/.bashrc
  
  log "\t.bash_aliases"
  rm -rf ~/.bash_aliases

  log "\t.bash_exports"
  rm -rf ~/.bash_exports
  
  log "\t.vimrc"
  rm -rf ~/.vimrc
  
  log "\t.tmux.conf"
  rm -rf ~/.tmux.conf

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
