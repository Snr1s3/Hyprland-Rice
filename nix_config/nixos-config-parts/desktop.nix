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

  environment.systemPackages = [ pkgs.sddm-astronaut ];

  services.displayManager.sddm = {
    enable = true;
    theme = "sddm-astronaut-theme";
    wayland.enable = true;
    extraPackages = [ pkgs.sddm-astronaut ];
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };
}