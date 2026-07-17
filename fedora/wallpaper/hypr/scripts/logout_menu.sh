#!/bin/bash

CHOICE=$(echo -e "Lock\nLogout\nPower Off" | tofi \
    --prompt-text "" \
    --width 8% \
    --height 15% \
    --anchor center \
    --font "UbuntuMono Nerd Font 14" \
    --horizontal=false)

case $CHOICE in
    Lock)
        hyprlock
        ;;
    Logout)
        hyprctl dispatch exit
        ;;
    "Power Off")
        systemctl poweroff
        ;;
    *)
        ;;
esac