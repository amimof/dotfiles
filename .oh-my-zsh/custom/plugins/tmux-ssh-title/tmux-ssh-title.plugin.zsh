# Sets the Tmux window name to the SSH remote host currently connected to  
ssh() {
    __tm_window=""
    if [ "$(ps -p $(ps -p $$ -o ppid=) -o comm=| cut -d : -f 1)" = "tmux" ]; then
        __tm_window=$(tmux list-windows| awk -F : '/\(active\)$/{print $1}')
        # Use current window to change back the setting. If not it will be applied to the active window
        trap "tmux set-window-option -t $__tm_window automatic-rename on 1>/dev/null" EXIT SIGINT SIGTERM SIGKILL

        # Determine if host is an IP Address or DNS name
        local HOST="$(echo $* | rev | cut -d ' ' -f 1 | rev)"
        if [[ ! $HOST =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
            HOST="$(echo $HOST| cut -d . -f 1)"
        fi  
        tmux rename-window "$HOST"
    fi  
    command ssh "$@"
}