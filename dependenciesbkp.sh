echo"Installing Dependecies:"
sudo dnf install -y gtkmm3 jsoncpp libsigc++ fmt wayland chrono-date spdlog libgtk-3-dev libgtk-3-dev gobject-introspection libgirepository1.0-dev libpulse libnl libappindicator-gtk3 libdbusmenu-gtk3 libmpdclient libsndio libevdev xkbregistry upower

#Waybar
git clone https://github.com/Alexays/Waybar
cd Waybar
meson build
ninja -C build
./build/waybar
ninja -C build install
waybar

#Hyprland && Hyprpaper
sudo dnf install hyprland
sudo dnf install wayland-devel wayland-protocols-devel hyprlang-devel pango-devel cairo-devel file-devel libglvnd-devel libglvnd-core-devel libjpeg-turbo-devel libwebp-devel gcc-c++
git clone https://github.com/hyprwm/hyprpaper.git
cd hyprpaper
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprpaper -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
cmake --install ./build
git clone https://github.com/hyprwm/hyprlang.git
cd hyprlang
cmake --no-warn-unused-cli -DCMAKE_BUILD_TYPE:STRING=Release -DCMAKE_INSTALL_PREFIX:PATH=/usr -S . -B ./build
cmake --build ./build --config Release --target hyprlang -j`nproc 2>/dev/null || getconf _NPROCESSORS_CONF`
sudo cmake --install ./build