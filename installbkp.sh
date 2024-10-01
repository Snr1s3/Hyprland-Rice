sudo dnf update -y
sudo dnf install -y grim slurp notify-send blueman alsa-lib-devel python3-devel pamixer @development-tools kernel-headers kernel-devel dkms fastfetch gammastep  mako-1.8.0-4.fc40.x86_64 foot cmake wayland-devel wayland-protocols-devel hyprlang-devel pango-devel cairo-devel file-devel libglvnd-devel libglvnd-core-devel libjpeg-turbo-devel libwebp-devel gcc-c++ meson scdoc wayland-protocols-devel freetype-devel cairo-devel pango-devel wayland-devel libxkbcommon-devel harfbuzz waybar dotnet-runtime-8.0 java-latest-openjdk.x86_64 keepassxc code ./VirtualBox-7.0-7.0.18_162988_fedora40-1.x86_64.rpm  virtualbox-guest-additions
pip install pyalsaaudio netifaces
sudo usermod -aG vboxusers $USER
newgrp vboxusers
cd
mkdir installs && cd installs
git clone https://github.com/philj56/tofi.git
cd tofi
meson build && ninja -C build install
cd ..
git clone https://github.com/hyprwm/hyprpaper.git
cd hyprpaper/
sudo cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
sudo cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build
cd ..
git clone https://github.com/bugaevc/wl-clipboard.git
cd wl-clipboard/
meson build && ninja -C build install
sudo dnf remove libreoffice* gnome-boxes-46.1-1.fc40.x86_64 gnome-calendar-46.1-1.fc40.x86_64 gnome-clocks-46.0-1.fc40.x86_64 gnome-connections-46.0-3.fc40.x86_64 gnome-tour-46.0-2.fc40.x86_64 gnome-weather-46.0-1.fc40.noarch gnome-maps-46.11-1.fc40.x86_64 kitty