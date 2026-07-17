#!/bin/bash
screenshot_filename="$HOME/Pictures/Screenshots/screenshot_$(date +"%d-%m-%Y-%H%S").png"
grim -g "$(slurp)" $screenshot_filename 
wl-copy < $screenshot_filename
if [ -e $screenshot_filename ]; then
    wl-copy < $screenshot_filename
fi