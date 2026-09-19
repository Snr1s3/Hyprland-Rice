{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Editors / development
    vscode
    git
    gh
    unityhub

    # Terminal / shell
    foot
    fastfetch
    fetch
    wget
    unzip

    # Hyprland / Wayland
    waybar
    hyprpaper
    hyprlock
    hyprcursor
    swappy
    slurp
    grim
    elephant
    walker
    quickshell

    # Desktop / files
    thunar
    gvfs
    udiskie
    desktop-file-utils
    tumbler
    glib

    # Audio / graphics
    pavucontrol
    mesa-demos
    playerctl

    # Browsers / communication
    firefox
    discord

    # Fonts / cursors
    bibata-cursors

    # Filesystems / EFI
    ntfs3g
    efibootmgr

    # Authentication
    polkit_gnome
  ];

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
