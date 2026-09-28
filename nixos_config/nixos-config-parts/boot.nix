{ config, pkgs, inputs, ... }:

{
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    theme = inputs.nixos-grub-themes.packages.${pkgs.stdenv.hostPlatform.system}.fallout;
  };

  boot.loader.efi.canTouchEfiVariables = true;
}
