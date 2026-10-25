{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Development / editors
    docker
    gh
    git
    unityhub
    vscode

    # Terminal / shell / utilities
    fastfetch
    fetch
    foot
    unzip
    wget

    # Hyprland / Wayland / desktop
    elephant
    grim
    hyprcursor
    hyprland
    hyprlock
    hyprpaper
    loupe
    quickshell
    showtime
    slurp
    swappy
    walker
    waybar

    # Desktop / files / storage
    desktop-file-utils
    glib
    gvfs
    prismlauncher
    rpi-imager
    thunar
    thunar-archive-plugin
    thunar-volman
    tumbler
    udiskie
    filezilla

    # Audio / graphics
    mesa-demos
    pavucontrol
    playerctl

    # Browsers / communication
    discord
    firefox

    # Fonts / cursors
    bibata-cursors

    # Filesystems / EFI
    efibootmgr
    ntfs3g

    # Authentication / system security
    polkit_gnome
  ];

  programs.thunar = {
    enable = true;
    plugins = with pkgs; [
      thunar-volman
      thunar-archive-plugin
    ];
  };

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
