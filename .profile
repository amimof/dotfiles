# ~/.profile: executed by Bourne-compatible login shells.

if [ "$BASH" ]; then
  if [ -f ~/.bashrc ]; then
    . ~/.bashrc
  fi
fi

# Set screendir to ~/.screen. This works better with wsl.
export SCREENDIR=~/.screen

# Be specific and set term to xterm
export TERM=xterm-256color

# Colorize folders and files
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

mesg n || true
