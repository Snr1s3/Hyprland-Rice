{ pkgs, videoDriver, ... }:

let
  sddmTheme = pkgs.stdenvNoCC.mkDerivation {
    pname = "hyprland-rice-sddm-theme";
    version = "1.0";
    src = ../app-configs/sddm/theme;

    installPhase = ''
      mkdir -p $out/share/sddm/themes/rice
      cp -r ./* $out/share/sddm/themes/rice/
      cp ${../app-configs/hypr/wallpapers/w3.jpg} $out/share/sddm/themes/rice/w3.jpg
    '';
  };
in
{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = pkgs.lib.optional (videoDriver != null) videoDriver;
    displayManager.sessionCommands = ''
      ${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1 &
    '';

    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager.sddm = {
    enable = true;
    wayland.enable = false;
    theme = "rice";
    extraPackages = [ sddmTheme ];
  };

  environment.etc."sddm.conf.d/10-rice.conf".source =
    ../app-configs/sddm/sddm.conf;

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-hyprland
      xdg-desktop-portal-gtk
    ];
  };
}
