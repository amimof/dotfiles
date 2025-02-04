# Options section
setopt correct                                                  # Auto correct mistakes
setopt extendedglob                                             # Extended globbing. Allows using regular expressions with *
setopt nocaseglob                                               # Case insensitive globbing
setopt rcexpandparam                                            # Array expension with parameters
setopt nocheckjobs                                              # Don't warn about running processes when exiting
setopt numericglobsort                                          # Sort filenames numerically when it makes sense
setopt nobeep                                                   # No beep
setopt appendhistory                                            # Immediately append history instead of overwriting
setopt histignorealldups                                        # If a new command is a duplicate, remove the older one
setopt autocd                                                   # if only directory path is entered, cd there.
setopt inc_append_history                                       # save commands are added to the history immediately, otherwise only when shell exits.

# Speed up completions
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' menu select                              # Menu select on double-tab
zstyle ':completion:*' matcher-list 'r:|=*' 'l:|=* r:|=*'       # tab-completion case sensitive
zstyle ':completion:*:git-checkout:*' sort false                # disable sort when completing `git checkout`
zstyle ':completion:*:descriptions' format '[%d]'

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
WORDCHARS=""                                                    # Don't consider certain characters part of the word
CLICOLOR=1                                                      # Add colors to files and directories
LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd                                 # Add colors to files and directories
GPG_TTY=$(tty)

# Keybindings section
bindkey -v                                                      # Enable vi mode
bindkey -e
bindkey "^[" vi-cmd-mode                                        # Bind Esc to vi cmd mode
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey '^[[2~' overwrite-mode                                  # Insert key
bindkey '^[[3~' delete-char                                     # Delete key
bindkey '^[[C'  forward-char                                    # Right key
bindkey '^[[D'  backward-char                                   # Left key
bindkey '^[[5~' history-beginning-search-backward               # Page up key
bindkey '^[[6~' history-beginning-search-forward                # Page down key
bindkey '^w' backward-kill-word                                 # Ctrl+w to delete words
bindkey '^[[1;9C' forward-word
bindkey '^[[1;9D' backward-word

# Navigate words with ctrl+arrow keys
bindkey '^[Oc' forward-word                                     #
bindkey '^[Od' backward-word                                    #
bindkey '^[[1;5D' backward-word                                 #
bindkey '^[[1;5C' forward-word                                  #
bindkey '^H' backward-kill-word                                 # delete previous word with ctrl+backspace
bindkey '^[[Z' undo                                             # Shift+tab undo last action

# Alias section
alias grep="grep --color=auto"                                  # Add color to grep
alias cp="cp -i"                                                # Confirm before overwriting something
alias df='df -h'                                                # Human-readable sizes
alias free='free -m'                                            # Show sizes in MB
alias gitu='git add . && git commit && git push'
alias s='tmux attach || tmux new'                               # Re-attach to tmux session. Create a new session if none exists
alias g="git"                                                   # Git becomes g
alias gh="cd ~/git && pwd"                                      # git repos home
alias k="kubectl"                                               # Alias kubectl to k and also add bash-completion for it
alias kx="kubectx"                                              # Alias kubectx to kx
alias kn="kubens"                                               # Alias kubens to kn
alias kc="kubecfg"                                              # Alias kubecfg to kc
alias diff="diff --color"                                       # Add colors to diff command
alias ls="ls --color=tty"                                       # Enable ls colors
alias ll="ls -latrh"
alias vim="nvim"                                                # Use NeoVim over Vim
alias ls="eza --git --icons=always --hyperlink"
alias cat="bat --theme=base16"

# Completion
autoload -U compinit colors zcalc
compinit -d
colors

# Exports
export KEYTIMEOUT=1                                             # Reduce the delay to enter vi-mode
export TERM=tmux-256color
export PATH=$PATH:/usr/local/go/bin:~/go/bin                             # Puts go into PATH
export MOZ_GTK_TITLEBAR_DECORATION=client                       # Configure GTK to use client titlebar
export GTK_THEME=Adwaita:dark                                   # Make GTK windows dark
export EDITOR=nvim                                               # NeoVim is our editor
export CLICOLOR=1                                               # Add colors to files and directories
export LSCOLORS=ExGxBxDxCxEgEdxbxgxcxd                          # Add colors to files and directories
export GPG_TTY=$(tty)                                           # Tell gpg agent which TTY we are in
export COMPLETION_WAITING_DOTS="true"
export PATH="/usr/local/bin:$PATH"

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# FZF config
export FZF_TMUX=0
export FZF_DEFAULT_COMMAND='fd . --hidden --color always'
export FZF_DEFAULT_OPTS='
  --reverse
  --border rounded
  --color dark
'
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:wrap:hidden:border-horizontal --bind '?:toggle-preview'"
export FZF_CTRL_T_OPTS="--preview '([[ -d {} ]] && eza -l --color=always {} || bat --style=numbers --color=always --line-range=:500 {}) 2> /dev/null | head -200'"

# Prompt
#PROMPT='%F{blue}%1~ %B%f%F{green}%f%b '
#GIT_PROMPT=false
#precmd() { print "" }  # Print empty line before prompt is rendered

# Stylize the prompt and right prompt with git info
# https://zsh.sourceforge.io/Doc/Release/User-Contributions.html#Configuration-3
# if [ "$GIT_PROMPT" = true ] ; then
#   autoload -Uz vcs_info
#   precmd_vcs_info() { vcs_info }
#   precmd_functions+=( precmd_vcs_info )
#   setopt prompt_subst
#   RPROMPT=\$vcs_info_msg_0_
#   zstyle ':vcs_info:*' enable git
#   zstyle ':vcs_info:*' check-for-changes true
#   zstyle ':vcs_info:*' unstagedstr '%{%F{yellow}!%}'
#   zstyle ':vcs_info:*' stagedstr ''
#   zstyle ':vcs_info:git*+set-message:*' hooks untracked
#   zstyle ':vcs_info:git:*' formats ' %F{white}%b%f %F{red}%m%f%F{red}%u%f%F{green}%c%f'
#   zstyle ':vcs_info:git:*' actionformats ' %F{white}%b%f %F{cyan}%a%f %F{yellow}%m%f%F{red}%u%f%F{green}%c%f'
#
#   # Add support for untracked status
#   +vi-untracked() {
#     if [[ -n "$(git ls-files --others --exclude standard)" ]]; then
#         hook_com[misc]='?'
#     else
#         hook_com[misc]=''
#     fi
#   }
# fi


# Set terminal window and tab/icon title
#
# usage: title short_tab_title [long_window_title]
#
# See: http://www.faqs.org/docs/Linux-mini/Xterm-Title.html#ss3.1
# Fully supports screen and probably most modern xterm and rxvt
# (In screen, only short_tab_title is used)
# function title {
#   emulate -L zsh
#   setopt prompt_subst
#
#   [[ "$EMACS" == *term* ]] && return
#
#   # if $2 is unset use $1 as default
#   # if it is set and empty, leave it as is
#   : ${2=$1}
#
#   case "$TERM" in
#     xterm*|putty*|rxvt*|konsole*|ansi|mlterm*|alacritty|st*)
#       print -Pn "\e]2;${2:q}\a" # set window name
#       print -Pn "\e]1;${1:q}\a" # set tab name
#       ;;
#     screen*|tmux*)
#       print -Pn "\e]2;${2:q}\a" # set window name
#       print -Pn "\ek${1:q}\e\\" # set screen hardstatus
#
#       # # Set screen tab title to ssh host if we are in a tmux session
#       # if [[ $line = ssh* ]]; then
#       #   if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=| cut -d : -f 1)" = "tmux" ]; then
#       #       __tm_window=$(tmux list-windows| awk -F : '/\(active\)$/{print $1}')
#       #       # Use current window to change back the setting. If not it will be applied to the active window
#       #       trap "tmux set-window-option -t $__tm_window automatic-rename on 1>/dev/null" RETURN
#
#       #       # Determine if host is an IP Address or DNS name
#       #       local HOST="$(echo $* | rev | cut -d ' ' -f 1 | rev)"
#       #       if [[ ! $HOST =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
#       #           HOST="$(echo $HOST| cut -d . -f 1)"
#       #       fi  
#       #       tmux rename-window "$HOST"
#       #   fi 
#       # fi
#       # command ssh "$@"
#       ;;
#     *)
#     # Try to use terminfo to set the title
#     # If the feature is available set title
#     if [[ -n "$terminfo[fsl]" ]] && [[ -n "$terminfo[tsl]" ]]; then
#       echoti tsl
#       print -Pn "$1"
#       echoti fsl
#     fi
#       ;;
#   esac
# }

# ZSH_THEME_TERM_TAB_TITLE_IDLE="%15<‥<%~%<<" #15 char left truncated PWD
# ZSH_THEME_TERM_TITLE_IDLE="%n@%m:%~"

# Runs before showing the prompt
# function mzc_termsupport_precmd {
#   [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return
#   title $ZSH_THEME_TERM_TAB_TITLE_IDLE $ZSH_THEME_TERM_TITLE_IDLE
# }

# Runs before executing the command
# function mzc_termsupport_preexec {
#   [[ "${DISABLE_AUTO_TITLE:-}" == true ]] && return
#
#   emulate -L zsh
#
#   # split command into array of arguments
#   local -a cmdargs
#   cmdargs=("${(z)2}")
#   # if running fg, extract the command from the job description
#   if [[ "${cmdargs[1]}" = fg ]]; then
#     # get the job id from the first argument passed to the fg command
#     local job_id jobspec="${cmdargs[2]#%}"
#     # logic based on jobs arguments:
#     # http://zsh.sourceforge.net/Doc/Release/Jobs-_0026-Signals.html#Jobs
#     # https://www.zsh.org/mla/users/2007/msg00704.html
#     case "$jobspec" in
#       <->) # %number argument:
#         # use the same <number> passed as an argument
#         job_id=${jobspec} ;;
#       ""|%|+) # empty, %% or %+ argument:
#         # use the current job, which appears with a + in $jobstates:
#         # suspended:+:5071=suspended (tty output)
#         job_id=${(k)jobstates[(r)*:+:*]} ;;
#       -) # %- argument:
#         # use the previous job, which appears with a - in $jobstates:
#         # suspended:-:6493=suspended (signal)
#         job_id=${(k)jobstates[(r)*:-:*]} ;;
#       [?]*) # %?string argument:
#         # use $jobtexts to match for a job whose command *contains* <string>
#         job_id=${(k)jobtexts[(r)*${(Q)jobspec}*]} ;;
#       *) # %string argument:
#         # use $jobtexts to match for a job whose command *starts with* <string>
#         job_id=${(k)jobtexts[(r)${(Q)jobspec}*]} ;;
#     esac
#
#     # override preexec function arguments with job command
#     if [[ -n "${jobtexts[$job_id]}" ]]; then
#       1="${jobtexts[$job_id]}"
#       2="${jobtexts[$job_id]}"
#     fi
#   fi
#
#   # cmd name only, or if this is sudo or ssh, the next cmd
#   local CMD=${1[(wr)^(*=*|sudo|ssh|mosh|rake|-*)]:gs/%/%%}
#   local LINE="${2:gs/%/%%}"
#
#   title '$CMD' '%100>...>$LINE%<<'
# }
# autoload -U add-zsh-hook
# add-zsh-hook precmd mzc_termsupport_precmd
# add-zsh-hook preexec mzc_termsupport_preexec

# Source completion plugins
if type "kubectl" > /dev/null; then
 source <(kubectl completion zsh)             # kubectl auto completion
fi
if type "podman" > /dev/null; then
 source <(podman completion zsh)             # kubectl auto completion
fi

# Load plugins
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh # fzf key bindings and auto completion
[ -f /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ] && source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # syntax highlighting
[ -f ~/.zsh/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh ] && source ~/.zsh/catppuccin-zsh-syntax-highlighting/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh # syntax highlighting
[ -f ~/.zsh/fzf-tab-completion/zsh/fzf-zsh-completion.sh ] && source ~/.zsh/fzf-tab-completion/zsh/fzf-zsh-completion.sh
[ -f ~/.zsh/vpn.zsh ] && source ~/.zsh/vpn.zsh

# Starship prompt
eval "$(starship init zsh)"

