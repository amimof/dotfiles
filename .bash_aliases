# Re-attach to tmux session. Create a new session if none exists
alias s='tmux attach || tmux new'

# git repos home
alias gh="cd ~/git && pwd"

# separate kubeconfig for oc
alias oc="oc --config=/Users/amir/.kube/ocp_config"

# Alias kubectl to k and also add bash-completion for it
alias k="kubectl"
complete -F __start_kubectl k

# Alias kubectx to kx
alias kx="kubectx"