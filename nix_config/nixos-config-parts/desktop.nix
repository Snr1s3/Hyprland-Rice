{ pkgs, videoDriver, ... }:

{
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
    withUWSM = true;
  };

  services.xserver = {
    enable = true;
    videoDrivers = pkgs.lib.optional (videoDriver != null) videoDriver;
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  environment.systemPackages = [ pkgs.sddm-sugar-dark ];

  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.theme = "sugar-dark";

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}