# Re-attach to tmux session. Create a new session if none exists
alias s='tmux attach || tmux new'

# git repos home
alias gh="cd ~/Documents/git && pwd"

# seperate kubeconfig for oc
alias oc="oc --config=/Users/amir/.kube/ocp_config"
