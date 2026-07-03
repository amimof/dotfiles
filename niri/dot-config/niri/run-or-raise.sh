#!/usr/bin/env bash

set -euo pipefail

APP_ID="$1"
CMD="${2:-$1}"

WIN_ID=$(
    niri msg -j windows \
    | jq -r --arg app "$APP_ID" \
        '.[] | select(.app_id == $app) | .id' \
    | head -n1
)

if [[ -n "$WIN_ID" ]]; then
    niri msg action focus-window --id "$WIN_ID"
else
    niri msg action spawn -- "$CMD"
fi
