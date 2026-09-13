#!/bin/bash

CHOICE=$(echo -e "Lock\nLogout\nPower Off" | tofi \
    --prompt-text "" \
    --width 8% \
    --height 15% \
    --anchor center \
    --font "CaskaydiaMono Nerd Font 14" \
    --horizontal=false)

case $CHOICE in
    Lock)
        hyprlock
        ;;
    Logout)
        command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    *)
        ;;
esac