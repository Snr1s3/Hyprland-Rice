{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ============================================================================
  # Boot
  # ============================================================================

  boot.loader.systemd-boot = {
    enable = true;
    configurationLimit = 3;

    extraEntries = {
      "windows.conf" = ''
        title Windows
        efi /EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # ============================================================================
  # Networking
  # ============================================================================

  networking = {
    hostName = "BonDia";

    networkmanager.enable = true;
    wireless.enable = true;
  };

  # ============================================================================
  # Bluetooth
  # ============================================================================

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  # ============================================================================
  # Locale / Time
  # ============================================================================

  time.timeZone = "Europe/Madrid";

  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "es_ES.UTF-8";
      LC_IDENTIFICATION = "es_ES.UTF-8";
      LC_MEASUREMENT = "es_ES.UTF-8";
      LC_MONETARY = "es_ES.UTF-8";
      LC_NAME = "es_ES.UTF-8";
      LC_NUMERIC = "es_ES.UTF-8";
      LC_PAPER = "es_ES.UTF-8";
      LC_TELEPHONE = "es_ES.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  # ============================================================================
  # Security
  # ============================================================================

  security.polkit.enable = true;

  # ============================================================================
  # User
  # ============================================================================

  users.users.alba = {
    isNormalUser = true;
    description = "Alba";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  # ============================================================================
  # Desktop / Hyprland
  # ============================================================================

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = false;
  };

  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "breeze";
  };

  xdg.portal.enable = true;

  # ============================================================================
  # NVIDIA
  # ============================================================================

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    open = true;
  };

  # ============================================================================
  # Applications
  # ============================================================================

  environment.systemPackages = with pkgs; [
    # Editors / development
    vim
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
    overskride

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

    # Browsers / communication
    firefox
    discord

    # Gaming
    # Steam is provided by programs.steam below.

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

  # ============================================================================
  # Gaming
  # ============================================================================

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  # ============================================================================
  # Services
  # ============================================================================

  services.openssh = {
    enable = true;

    settings = {
      PasswordAuthentication = true;
      PermitRootLogin = "no";
    };
  };

  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.devmon.enable = true;
  services.tumbler.enable = true;

  programs.dconf.enable = true;
  services.dbus.enable = true;

  # ============================================================================
  # Nautilus customization
  # ============================================================================

  nixpkgs.overlays = [
    (final: prev: {
      nautilus = prev.nautilus.overrideAttrs (old: {
        buildInputs =
          old.buildInputs
          ++ (with pkgs.gst_all_1; [
            gst-plugins-good
            gst-plugins-bad
          ]);
      });
    })
  ];

  # ============================================================================
  # Nix
  # ============================================================================

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  # ============================================================================
  # Filesystems
  # ============================================================================

  fileSystems."/mnt/Games" = {
    device = "/dev/disk/by-uuid/88A43A08A439F8F0";
    fsType = "ntfs";
  };

  fileSystems."/mnt/Disk1" = {
    device = "/dev/disk/by-uuid/D840556740554D7E";
    fsType = "ntfs";
  };

  fileSystems."/mnt/Tot" = {
    device = "/dev/disk/by-uuid/7C604DC5604D86BC";
    fsType = "ntfs";
  };

  # ============================================================================
  # System version
  # ============================================================================

  system.stateVersion = "26.05";
}
