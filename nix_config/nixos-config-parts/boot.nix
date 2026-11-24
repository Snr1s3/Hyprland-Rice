{ ... }:

{
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    resolution = "1920x1080";
    maxGenerations = 5;

    style = {
      wallpapers = [
        ../app-configs/hypr/wallpapers/w3.jpg
      ];
      wallpaperStyle = "centered";
      backdrop = "000000";

      interface = {
        branding = "NixOS";
      };

      graphicalTerminal = {
        font.scale = "1x1";
      };
    };
  };

  boot.loader.efi.canTouchEfiVariables = true;
}