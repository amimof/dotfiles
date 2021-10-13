#!/usr/bin/env zsh
#  
# Sets up my linux environment the way i want it
#

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
CMDS=("zsh" "tmux" "kubectl" "kubectx" "vim" "curl")

warn() {
  echo -e "🤯 ${YELLOW}${1}${NC}"
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

# Check to see if we are using zsh, warn if not
if [ "$SHELL" != $(which zsh) ]; then
  warn "Looks like your shell is ${SHELL} and not Zsh. You might want to consider switching."
fi
exit

# Check if commands are installed
for i in ${CMDS[@]}; do
  command -v $i >/dev/null && continue || { warn "$i doesn't seem to be installed. You should probably install it."; continue; }
done

install() {

  info "🤖 Installing dotfiles"

  log "\t.zshrc"
  download ~/.bashrc https://raw.githubusercontent.com/amimof/dotfiles/master/.zshrc

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
  
  log "\t.zshrc"
  rm -rf ~/.zshrc
  
  log "\t.vimrc"
  rm -rf ~/.vimrc
  
  log "\t.tmux.conf"
  rm -rf ~/.tmux.conf

  info  "\n💩 Done! Restart your shell session\n"
}

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
