#!/bin/bash

# Update package list and upgrade all packages
sudo dnf update -y

# Install necessary dependencies from dependencies.txt
if [ -f dependencies.txt ]; then
    xargs -a dependencies.txt sudo dnf install -y
else
    echo "dependencies.txt not found!"
    exit 1
fi

# Create a directory for fonts if it doesn't exist
mkdir -p ~/.local/share/fonts

# Download UbuntuMono Nerd Font
wget -O UbuntuMono.zip https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/UbuntuMono.zip

# Unzip the font into the fonts directory
unzip UbuntuMono.zip -d ~/.local/share/fonts

# Remove the zip file
rm UbuntuMono.zip

# Refresh the font cache
fc-cache -fv

# Create a directory for wallpapers if it doesn't exist
mkdir -p ~/.wallpaper

# Download a sample wallpaper
wget -O ~/.wallpaper/wallpaper02.jpg https://example.com/path/to/your/wallpaper02.jpg

# Create hyprpaper.conf file with the given content
mkdir -p ~/.config/hypr
cat <<EOL > ~/.config/hypr/hyprpaper.conf
preload = ~/.wallpaper/wallpaper02.jpg
wallpaper = eDP-1,contain:~/.wallpaper/wallpaper02.jpg # laptop
splash = false
EOL

echo "Installation complete. All dependencies and configurations have been set up."