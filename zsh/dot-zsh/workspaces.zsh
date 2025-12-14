#!/usr/bin/env zsh

# Exit if we're not in WezTerm
is_wezterm=$(wezterm cli list-clients 2> /dev/null)
if [ $? -ne 0 ]; then
    return
fi

# Handle any errors while listing clients
current_workspace=$(wezterm cli list-clients --format=json | jq -r ".[0].workspace" 2>/dev/null)
if [ $? -ne 0 ] || [ -z "$current_workspace" ]; then
    echo "Error: Failed to retrieve a valid workspace from WezTerm."
    return
fi

# Here we can set variables that are common for all Workspaces
echo "Detected workspace: ${current_workspace}"
export WORKSPACE="${current_workspace}"

# Check the workspace and export its environment variables
case "${current_workspace}" in "Home")
    echo "Settings for ${WORKSPACE} have been set."
    ;;
"Västtrafik")
    export KUBECONFIG="${HOME}/.kube/ocp-config.yaml"
    echo "Settings for ${WORKSPACE} have been set."
    ;;
"VGR")
    echo "Settings for ${WORKSPACE} have been set."
    ;;
"Education")
    export KUBECONFIG="${HOME}/.kube/gbg.yaml"
    ;;
*)
    echo "Workspace '${current_workspace}' not recognized. No environment variables set."
    ;;
esac
    

