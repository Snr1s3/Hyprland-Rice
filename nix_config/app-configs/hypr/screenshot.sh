#!/usr/bin/env bash
set -euo pipefail

DIR="$HOME/Pictures/Screenshots"
mkdir -p "$DIR"

geometry="$(slurp)" || exit 0

timestamp="$(date +%Y%m%d-%H%M%S)"
screenshot="$DIR/$timestamp.png"

grim -g "$geometry" "$screenshot"
wl-copy --type image/png < "$screenshot"
hyprctl notify 1 3000 0 "Screenshot copied to clipboard"