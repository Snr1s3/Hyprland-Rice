#!/usr/bin/env bash

set -euo pipefail

choice=$(printf '%s\n' "Lock" "Logout" "Reboot" "Power Off" | walker \
    --dmenu \
    --theme nord \
    --placeholder "System" \
    --width 180 \
    --maxheight 180 \
    --nosearch \
    --hideqa)

case "${choice}" in
    Lock)
        hyprlock
        ;;
    Logout)
        command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'
        ;;
    Reboot)
        systemctl reboot
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    *)
        ;;
esac