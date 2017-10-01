# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
color_prompt=yes

# Set a fancy prompt. Root should have a slight different prompt to emphasize this.
# If we are in a screen session, don't show current command/path in command prompt,
# this is shown in the screen status line instead.
if [[ "$color_prompt" = yes ]]; then
    PCOL="\[\e[1;34m\]"
    if [[ "$USER" = root ]]; then
        UCOL="\[\e[0;31m\]"
    else
        UCOL="\[\e[0;32m\]"
    fi
fi
if [[ "$TERM" == screen* ]]; then
    PS1="$UCOL\u\[\e[m\] \[\e[00m\]$ "
else
    PS1="$UCOL\u\[\e[m\] $PCOL\w\[\e[m\] \[\e[00m\]$ "
fi

unset color_prompt

# If we are in a screen session. Show current folder in title
if [[ "$TERM" == screen* ]]; then
  screen_set_window_title () {
    local HPWD="$PWD"
    case $HPWD in
      $HOME) HPWD="~";;
      $HOME/*) HPWD="~${HPWD#$HOME}";;
    esac
    printf '\ek%s\e\\' "$HPWD"
    echo -ne "\e]0;$HPWD\a"
  }
  PROMPT_COMMAND="screen_set_window_title; $PROMPT_COMMAND"
fi

# enable color support of ls and also add handy aliases.
# To define more aliases, use ~/.bash_aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Autocomplete ssh hosts in ~/.ssh/config
complete -W "$(echo $(grep ^Host ~/.ssh/config | sed -e 's/Host //' | grep -v "\*"))" ssh

# Set custom path for scripts
PATH=$PATH:~/.scripts

# Set TERM to xterm for compatibility
export TERM=xterm-256color

# Set screendir to ~/.screen. This works better with ws/.screen. This works better with wsl.
export SCREENDIR=~/.screen


