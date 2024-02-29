#!/usr/bin/env zsh
#  
# Sets up my linux environment the way i want it #

GREEN='\033[1;32m'
YELLOW='\033[1;33m'
NC='\033[0m'
CMDS=("git" "zsh" "tmux" "kubectl" "kubectx" "kubens" "vim" "curl" "gitmux" "fzf") 

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
  curl -LSso "${1}" --create-dirs "${2}"
}

# Check to see if we are using zsh, warn if not
if [ "$SHELL" != $(which zsh) ]; then
  warn "Looks like your shell is ${SHELL} and not Zsh. You might want to consider switching."
fi

# Check if commands are installed
for i in ${CMDS[@]}; do
  command -v $i >/dev/null && continue || { warn "$i doesn't seem to be installed. You should probably install it."; continue; }
done

install() {

  # info "🔌 Installing plugins"
  
  # log "\tvim-plug"
  # download ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  # log "\Tmux Plugin Manager (TPM)"
  # git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm --quiet
  # exit

  # info "🤖 Installing dotfiles"

  # log "\t.zshrc"
  # download ~/.zshrc https://raw.githubusercontent.com/amimof/dotfiles/master/.zshrc

  # log "\t.vimrc"
  # download ~/.vimrc https://raw.githubusercontent.com/amimof/dotfiles/master/.vimrc

  # log "\t.tmux.conf"
  # download ~/.tmux.conf https://raw.githubusercontent.com/amimof/dotfiles/master/.tmux.conf

  # log "\t.gitconfig"
  # download ~/.gitconfig https://raw.githubusercontent.com/amimof/dotfiles/master/.gitconfig

  # log "\t.gitmux.conf"
  # download ~/.gitmux.conf https://raw.githubusercontent.com/amimof/dotfiles/master/.gitmux.conf

  info "\n💩 Done! Time to restart your shell\n"

  info "What to do next:\n"
  echo -e "${GREEN} ● ${NC} Install Nerd Fonts https://github.com/ryanoasis/nerd-fonts/releases/download/v3.1.1/FiraMono.zip"
  echo -e "${GREEN} ● ${NC} Install iTerm2 catppuccin theme https://github.com/catppuccin/iterm"

}

uninstall() {
  info "💀 Removing dotfiles"
  
  log "\t.zshrc"
  rm -rf ~/.zshrc
  
  log "\t.vimrc"
  rm -rf ~/.vimrc
  
  log "\t.tmux.conf"
  rm -rf ~/.tmux.conf

  log "\t.gitconfig"
  rm -rf ~/.gitconfig

  log "\t.gitmux.conf"
  rm -rf ~/.gitmux.conf
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
