{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Development / editors
    docker
    gh
    git
    vscode

    # Terminal / shell / utilities
    fastfetch
    fetch
    kitty
    unzip
    wget

    # Hyprland / Wayland / desktop
    elephant
    grim
    hyprcursor
    brightnessctl
    hyprland
    hyprlock
    hyprpaper
    jq
    ffmpeg
    amberol
    loupe
    quickshell
    showtime
    slurp
    swappy
    walker
    wl-clipboard
    btop

    # Desktop / files / storage
    desktop-file-utils
    glib
    gvfs
    prismlauncher
    rpi-imager
    kdePackages.dolphin
    tumbler
    udiskie
    filezilla
    pipewire

    # Audio / graphics
    mesa-demos
    pavucontrol
    playerctl
    qt6.qtmultimedia

    # Browsers / communication
    discord
    firefox

    # Fonts / cursors
    bibata-cursors

    # Authentication / system security
    polkit_gnome
  ];


  programs.xfconf.enable = true;

  fonts = {
    fontconfig.enable = true;

    packages = with pkgs; [
      nerd-fonts.caskaydia-cove
    ];
  };

  environment.variables = {
    XCURSOR_THEME = "Bibata-Modern-Ice";
    XCURSOR_SIZE = "24";
  };

  environment.etc."xdg/applications/overskride.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Overskride
    Comment=Bluetooth manager
    Exec=overskride
    Icon=overskride
    Terminal=false
    Categories=GTK;Settings;HardwareSettings;
  '';
}
