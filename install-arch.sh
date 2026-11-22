#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
CONFIG_SOURCE="$SCRIPT_DIR/nix_config/app-configs"
CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
BACKUP_ROOT="$HOME/.local/share/hyprland-rice/backups"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)"

official_packages=(
    hyprland
    foot
    fastfetch
    hyprlock
    hyprpaper
    quickshell
    grim
    slurp
    wl-clipboard
    pavucontrol
    blueman
    brightnessctl
    playerctl
    firefox
    thunar
    ttf-cascadia-code-nerd
    papirus-icon-theme
    jq
    lm_sensors
    wireplumber
)

aur_packages=(walker elephant)
config_dirs=(fastfetch foot hypr quickshell tofi walker)

die() {
    printf 'Error: %s\n' "$*" >&2
    exit 1
}

usage() {
    printf 'Usage: %s [--ssh user@host]\n' "$(basename "$0")"
    printf '\nWithout options, install on the current Arch system.\n'
    printf 'With --ssh, transfer the installer and configs, then install remotely.\n'
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    usage
    exit 0
fi

if [[ "${1:-}" == "--ssh" ]]; then
    [[ -n "${2:-}" ]] || die "Missing SSH target. Example: --ssh alba@192.168.1.63"
    command -v ssh >/dev/null 2>&1 || die "ssh was not found"
    command -v scp >/dev/null 2>&1 || die "scp was not found"
    command -v tar >/dev/null 2>&1 || die "tar was not found"

    archive=$(mktemp --tmpdir hyprland-rice.XXXXXX.tar.gz)
    trap 'rm -f "$archive"' EXIT
    tar -C "$SCRIPT_DIR" -czf "$archive" install-arch.sh nix_config/app-configs

    remote_dir=$(ssh "$2" 'mktemp -d "${TMPDIR:-/tmp}/hyprland-rice.XXXXXX"')
    scp "$archive" "$2:$remote_dir/configs.tar.gz"
    ssh -t "$2" "set -e; trap 'rm -rf \"$remote_dir\"' EXIT; tar -xzf \"$remote_dir/configs.tar.gz\" -C \"$remote_dir\"; bash \"$remote_dir/install-arch.sh\""
    exit 0
fi

[[ -z "${1:-}" ]] || die "Unknown option: $1 (use --help for usage)"
command -v pacman >/dev/null 2>&1 || die "pacman was not found. This script requires Arch Linux or an Arch-based distribution."
[[ -d "$CONFIG_SOURCE" ]] || die "Configuration directory not found: $CONFIG_SOURCE"

printf 'Installing official packages...\n'
sudo pacman -Syu --needed "${official_packages[@]}"

if command -v yay >/dev/null 2>&1; then
    printf 'Installing AUR packages with yay...\n'
    yay -S --needed "${aur_packages[@]}"
else
    printf 'Warning: yay is not installed; skipping AUR packages: %s\n' "${aur_packages[*]}" >&2
    printf 'Install yay and rerun this script to add Walker and Elephant.\n' >&2
fi

mkdir -p "$BACKUP_DIR" "$CONFIG_HOME"

for config_dir in "${config_dirs[@]}"; do
    if [[ -e "$CONFIG_HOME/$config_dir" || -L "$CONFIG_HOME/$config_dir" ]]; then
        cp -a "$CONFIG_HOME/$config_dir" "$BACKUP_DIR/"
    fi
    rm -rf "$CONFIG_HOME/$config_dir"
    cp -a "$CONFIG_SOURCE/$config_dir" "$CONFIG_HOME/"
done

# Make the copied configs work for users other than the original NixOS user.
for config_file in \
    "$CONFIG_HOME/hypr/hyprland.lua" \
    "$CONFIG_HOME/hypr/hyprpaper.conf" \
    "$CONFIG_HOME/hypr/hyprlock.conf"; do
    sed -i "s|/home/alba|$HOME|g" "$config_file"
done

# Tofi's Nix application paths are not present on Arch.
sed -i "s|^drun-paths =.*|drun-paths = /usr/share/applications:/usr/local/share/applications:~/.local/share/applications|" \
    "$CONFIG_HOME/tofi/config"

chmod +x "$CONFIG_HOME/hypr/logout_menu.sh" "$CONFIG_HOME/hypr/screenshot.sh"

printf '\nInstalled app-configs into %s\n' "$CONFIG_HOME"
printf 'Existing configs were backed up to %s\n' "$BACKUP_DIR"
printf 'Start Hyprland and review monitor names in %s/hyprland.lua if needed.\n' "$CONFIG_HOME"