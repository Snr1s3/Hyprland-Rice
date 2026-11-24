#!/usr/bin/env bash

set -euo pipefail

official_packages=(
    base-devel
    blueman
    breeze
    brightnessctl
    discord
    docker
    docker-compose
    dolphin
    fastfetch
    firefox
    gcc
    git
    grim
    gvfs
    hyprland
    hyprlock
    hyprpaper
    imv
    jq
    kitty
    lm_sensors
    make
    mpv
    openssh
    papirus-icon-theme
    pavucontrol
    playerctl
    polkit-gnome
    prism-launcher
    qt6ct
    quickshell
    sddm
    slurp
    swappy
    ttf-cascadia-code-nerd
    unzip
    wget
    wl-clipboard
    wireplumber
)

aur_packages=(
    bibata-cursor-theme
    elephant
    elephant-desktopapplications
    visual-studio-code-bin
    walker
    fetch
)

# Check if the script is running on Arch Linux
if [[ -r /etc/os-release ]]; then
    source /etc/os-release
fi
echo "Detected OS: ${NAME:-Unknown} ${VERSION_ID:-}"

if [[ ${ID:-} != "arch" && ${ID_LIKE:-} != *arch* ]]; then
    echo "This script is only supported on Arch Linux." >&2
    exit 1
fi

# UPDATE SYSTEM
sudo pacman -Syu --noconfirm

# INSTALL YAY & REMOVE GIT CLONE
cd ${HOME} 
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si --noconfirm
cd ${HOME} 
sudo rm  -rf yay

# INSTALL OFFICIAL AND AUR PACKAGES
sudo pacman -S --needed "${official_packages[@]}"
yay -S --needed "${aur_packages[@]}"

# GIT CLONE DOTFILES
cd ${HOME}
mkdir -p ${HOME}/.config
mkdir -p ${HOME}/github
cd ${HOME}/github
git clone https://github.com/Snr1s3/Hyprland-Rice.git 
cd Hyprland-Rice
cp -r arch_config/* ${HOME}/.config/
cd ${HOME} 

# SET UP FETCH

